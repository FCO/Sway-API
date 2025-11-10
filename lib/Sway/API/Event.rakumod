use Sway::API::Event::Binding;

unit class Sway::API::Event;

has Sway::API::Event::Binding() $.binding;
has Str                         $.change;
