use v6.*;
use JSON::Fast;
use Sway::API::Event;

use Sway::API::Atomic;
use Sway::API::Criteria;
use Sway::API::Commands;

use Sway::API::Command::Criteria;
use Sway::API::Command::Atomic;

unit class Sway::API;

also does Sway::API::Commands;
also does Sway::API::Command::Criteria;
also does Sway::API::Command::Atomic;

enum Cmd (
    IPC_COMMAND        => 0,
    IPC_GET_WORKSPACES => 1,
    IPC_SUBSCRIBE      => 2,
    IPC_GET_OUTPUTS    => 3,
    IPC_GET_TREE       => 4,
    IPC_GET_MARKS      => 5,
    IPC_GET_BAR_CONFIG => 6,
    IPC_GET_VERSION    => 7,
    IPC_GET_BIND_MODES => 8,
    IPC_GET_CONFIG     => 9,
    IPC_SEND_TICK      => 10,
    IPC_SYNC           => 11,
    IPC_GET_BIND_STATE => 12,
    IPC_GET_INPUTS     => 100,
    IPC_GET_SEATS      => 101,
);

has Str $.socket-path = %*ENV<SWAYSOCK> // %*ENV<I3SOCK> // die "SWAYSOCK não definido";

sub u32-le(Int $n) {
    Buf.new:
        $n +& 0xff,
        ($n +> 8)  +& 0xff,
        ($n +> 16) +& 0xff,
        ($n +> 24) +& 0xff,
}

sub from-u32-le(Blob $b) {
    $b[0] + ($b[1] +< 8) + ($b[2] +< 16) + ($b[3] +< 24)
}

method !envelope(Cmd $type, $payload is copy) {
    $payload .= encode if $payload ~~ Str;
    my Buf $buf .= new:
        |"i3-ipc".encode.list,
        |u32-le($payload.elems),
        |u32-le($type.Int),
        |$payload.list,
    ;
    return $buf
}

sub extract-data(Buf $buf) {
    die "no header message" if $buf.elems < 14;

    my $magic = $buf.subbuf(0, 6).decode;
    die "Invalid IPC magic $magic" if $magic ne "i3-ipc";

    my $body-len = from-u32-le $buf.subbuf: 6, 4;
    warn "Less data than expected" if $buf.elems < 14 + $body-len;

    $buf.subbuf(14, $body-len).decode.&from-json
}

sub supply-response($sock, Bool :$keep = False, Bool :$validate = False) {
    return supply {
        my Bool $got-status = False;
        whenever $sock.Supply: :bin {
            my $resp = .&extract-data;
            if $got-status.not && ($validate || $keep) {
                $got-status = True;
                die "ERROR: ", $resp unless $resp<success>;
                last unless $keep;
                next
            }
            emit $resp;
            last unless $keep;
        }
    }
}

method !send(Cmd $type, $payload = Blob.new, Bool :$keep = False, :&map) {
    my $conn = await IO::Socket::Async.connect-path: $!socket-path;

    await $conn.write: self!envelope: $type, $payload;

    my Supply $s = supply-response $conn, :$keep;
    $s .= map: &map if &map;
    return $keep ?? $s !! await $s
}

method workspaces { self!send: IPC_GET_WORKSPACES }
method outputs    { self!send: IPC_GET_OUTPUTS }
method tree       { self!send: IPC_GET_TREE }
method version    { self!send: IPC_GET_VERSION }

method output-names {
    $.outputs.map: *<name>
}

method run-command(Str $cmd) {
    note "sending: $cmd";
    my $json = self!send: IPC_COMMAND, $cmd, :validate;
    die "Error: $json" unless $json.head<success>;
    $json
}

method subscribe(@events --> Supply) {
    my $payload = to-json(@events);

    return self!send: IPC_SUBSCRIBE, $payload, :keep, :map{
        Sway::API::Event.new: |%$_
    };
}

=begin pod

=head1 NAME

Sway::API - blah blah blah

=head1 SYNOPSIS

=begin code :lang<raku>

use Sway::API;

my $sway = Sway::API.new;

say $sway.workspaces;
say $sway.border: :2pixels;
say $sway.run-command: "bindsym Mod4+Shift+m nop test";

react {
    whenever $sway.subscribe(["binding",]) {
	.say
    }
}

=end code

=head1 DESCRIPTION

Sway::API is a lib to comunicate with your local Sway

=head1 AUTHOR

Fernando Correa de Oliveira <fco@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright $year Fernando Correa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
