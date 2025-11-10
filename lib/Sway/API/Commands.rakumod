unit role Sway::API::Commands;

method run-command { ... }

multi border(Bool :$none!          ) { border "none"         }
multi border(Bool :$normal!        ) { border "normal"       }
multi border(Bool :$csd!           ) { border "csd"          }
multi border(Bool :$pixel!         ) { border "pixel"        }
multi border(UInt :pixels(:$pixel)!) { border "pixel $pixel" }
multi border(Bool :$toggle!        ) { border "toggle"       }
multi border(                      ) { border :toggle        }
multi border(Str $value            ) { "border $value"       }

method border(|c) is hidden-from-backtrace { $.run-command: border |c }

method exit is hidden-from-backtrace { $.run-command: "exit" }

multi floating(Bool $enable = True) { "floating { $enable ?? "enable" !! "disable" }" }
multi floating(Bool :$enable!     ) { floating $enable                                }
multi floating(Bool :$disable!    ) { floating !$disable                              }

method floating(|c) is hidden-from-backtrace { $.run-command: floating |c }

multi focus(Str  $value   ) { "focus $value" }
multi focus(Bool :$up!    where *.so) { focus "up" }
multi focus(Bool :$down!  where *.so) { focus "down" }
multi focus(Bool :$left!  where *.so) { focus "left" }
multi focus(Bool :$right! where *.so) { focus "right" }

multi focus(Bool :$prev! where *.so, Bool :$sibling) { focus "{ "prev" }{ " sibling" if $sibling }" }
multi focus(Bool :$next! where *.so, Bool :$sibling) { focus "{ "next" }{ " sibling" if $sibling }" }

multi focus(Str :$output! where <up down left right>.any) { focus "output $output" }

multi focus(Bool :$child!  where *.so) { focus "child" }
multi focus(Bool :$parent! where *.so) { focus "parent" }

multi focus(Bool :$tiling!      where *.so) { focus "tiling" }
multi focus(Bool :$floating!    where *.so) { focus "floating" }
multi focus(Bool :$mode-toggle! where *.so) { focus "mode_toggle" }

multi method focus(Str :$output! where $.output-names.any) is hidden-from-backtrace { $.run-command: "focus output $output" }
multi method focus(|c)                                               is hidden-from-backtrace { $.run-command: focus |c }

multi fullscreen(Str  $value, Bool :$global) { "fullscreen { $value }{ "global" if $global }"         }
multi fullscreen(Bool $value, Bool :$global) { fullscreen ($value ?? "enable" !! "disable"), :$global }

multi fullscreen(Bool :$global) { fullscreen "" , :$global }

multi fullscreen(Bool :$toggle! where *.so, Bool :$global) { fullscreen "toggle" , :$global }

multi fullscreen(Bool :$enable! , Bool :$global) { fullscreen $enable  , :$global }
multi fullscreen(Bool :$disable!, Bool :$global) { fullscreen !$disable, :$global }

method fullscreen(|c) is hidden-from-backtrace { $.run-command: fullscreen |c }

multi gaps(
    UInt $amount,
    Bool :$inner     = False,   Bool :$outer    = False,
    Bool :$horizontal= False,   Bool :$vertical = False,
    Bool :$top       = False,   Bool :$bottom   = False,
    Bool :$right     = False,   Bool :$left where {
        [
            $inner, $outer,  $horizontal, $vertical,
            $top,   $bottom, $right,      $left,
        ].sum == 1
    } = False,
    Bool :$all = False, Bool :$current where { $all + $current <= 1 } = False,
    Rat() :$set, Rat() :$plus, Rat() :$minus, Rat() :$toggle where {
        [$set, $plus, $minus, $toggle].map(*.defined).sum <= 1
    }
) is default {
    "gaps {
        $inner          ?? "inner"
        !! $outer       ?? "outer"
        !! $horizontal  ?? "horizontal"
        !! $vertical    ?? "vertical"
        !! $top         ?? "top"
        !! $bottom      ?? "bottom"
        !! $right       ?? "right"
        !! $left        ?? "lefit"
        !! die "Choose what gap to set"
    } {
        $all        ?? "all"
        !! $current ?? "current"
        !! "all"
    } {
        $set        ?? "set"
        !! $plus    ?? "plus"
        !! $minus   ?? "minus"
        !! $toggle  ?? "toggle"
        !! "set"
    } $amount"
}

method gaps(|c) is hidden-from-backtrace { $.run-command: gaps |c }

multi inhibit-idle(Bool :$focus!      where *.so) { "inhibit_idle focus"      }
multi inhibit-idle(Bool :$fullscreen! where *.so) { "inhibit_idle fullscreen" }
multi inhibit-idle(Bool :$open!       where *.so) { "inhibit_idle open"       }
multi inhibit-idle(Bool :$none!       where *.so) { "inhibit_idle none"       }
multi inhibit-idle(Bool :$visible!    where *.so) { "inhibit_idle visible"    }

method inhibit-idle(|c) is hidden-from-backtrace { $.run-command: inhibit-idle |c }

multi layout(Bool :$default!  where *.so) { "layout default"  }
multi layout(Bool :$splith!   where *.so) { "layout splith"   }
multi layout(Bool :$splitv!   where *.so) { "layout splitv"   }
multi layout(Bool :$stacking! where *.so) { "layout stacking" }
multi layout(Bool :$tabbed!   where *.so) { "layout tabbed"   }

multi layout(Bool :$toggle! where *.so                                               ) { "layout toggle"           }
multi layout(Str  :$toggle! where <all split>.one                                    ) { "layout toggle $toggle"   }
multi layout(Str  :@toggle! where *.all ~~ <split tabbed stacking splitv splith>.one ) { "layout toggle @toggle[]" }

method layout(|c) is hidden-from-backtrace { $.run-command: layout |c }

multi max-render-time(Bool :$off! where *.so) { "max_render_time off"    }
multi max-render-time(UInt $value           ) { "max_render_time $value" }

method max-render-time(|c) is hidden-from-backtrace { $.run-command: max-render-time |c }

multi allow_tearing(Bool $value = True) { "allow_tearing { $value ?? "yes" !! "no" }" }

multi allow_tearing(Bool :$yes!) { allow_tearing $yes }
multi allow_tearing(Bool :$no! ) { allow_tearing !$no }

method allow_tearing(|c) is hidden-from-backtrace { $.run-command: allow_tearing |c }

multi move(UInt $px?, Bool :$left!  where *.so) { "move left {  "$px px" with $px }" }
multi move(UInt $px?, Bool :$right! where *.so) { "move right { "$px px" with $px }" }
multi move(UInt $px?, Bool :$up!    where *.so) { "move up {    "$px px" with $px }" }
multi move(UInt $px?, Bool :$down!  where *.so) { "move down {  "$px px" with $px }" }

method move(|c) is hidden-from-backtrace { $.run-command: move |c }


