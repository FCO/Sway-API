use Sway::API::Commands;
use Sway::API::Criteria;

use Sway::API::Command::Criteria;

unit class Sway::API::Atomic does Sway::API::Commands does Sway::API::Command::Criteria;

has     $.client;
has Str @!commands;

method run-command(Str $command) {
    @!commands.push: $command;
    self
}
method prepare-command {
    @!commands.join: " ; "
}
method run(\SELF where {@!commands || die "there is nothing to run"}:) {
    $!client.run-command: $.prepare-command
}
