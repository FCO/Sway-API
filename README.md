[![Actions Status](https://github.com/FCO/Sway-API/actions/workflows/test.yml/badge.svg)](https://github.com/FCO/Sway-API/actions)

NAME
====

Sway::API - A way to communicate with local SwayWM

SYNOPSIS
========

```raku
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
```

DESCRIPTION
===========

Sway::API is a lib to comunicate with your local Sway

AUTHOR
======

Fernando Correa de Oliveira <fco@cpan.org>

COPYRIGHT AND LICENSE
=====================

Copyright $year Fernando Correa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

