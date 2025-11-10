use Sway::API::Commands;

unit role Sway::API::Criteria does Sway::API::Commands;

has $.client;
has %.criteria;

method Str {
    my @pairs = do for %!criteria.kv -> Str $k, $v {
        next without $v;
        my $key = $k.subst: /"-"/, "_", :g;
        $v === True
        ?? $key
        !! qq|{ $key }="$v"|
    }
    my $crit = @pairs.join: " ";

    "[{ $crit }]"
}

method run-command(Str $command) {
    my $ret = $!client.run-command: "{ $.Str } { $command }";
    return self if $ret ~~ Sway::API::Commands;
    $ret
}

method run(\SELF where { $!client.^can("run") || die "criteria has no run method" }:) { $!client.run }

method atomic {
    $!client = $!client.atomic;
    self
}
