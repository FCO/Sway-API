use Sway::API;

my $sway = Sway::API.new;
say $sway.run-command: "smart_gaps on";
say $sway.workspaces;
say $sway.run-command: "bindsym Mod4+Shift+m nop test";
say $sway.border: :2pixels;
react {
    whenever $sway.subscribe(["binding",]) {
	.say
    }
}


