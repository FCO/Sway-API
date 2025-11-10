use Sway::API::Atomic;

unit role Sway::API::Command::Atomic;

method atomic { Sway::API::Atomic.new: :client(self) }

