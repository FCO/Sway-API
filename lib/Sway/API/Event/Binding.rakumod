unit class Sway::API::Event::Binding;

has Str    $.command    is required;
has UInt   $.input-code;
has UInt() @.input-codes;
has Str    $.input-type;
has Str()  @.event-state-mask;
has Str    $.symbol;
has Str()  @.symbols;

method COERCE(
	% (
		:$command,
		:$symbol,
		:@symbols,
		:$input_code,
		:@input_codes,
		:$input_type,
		:@event_state_mask,
	)
) {
	my %map is Map = 
		:$command,
		:$symbol,
		:@symbols,
		:input-code(       $input_code       ),
		:input-codes(      @input_codes      ),
		:input-type(       $input_type       ),
		:event-state-mask( @event_state_mask ),
	;
	self.new: |%map
}
