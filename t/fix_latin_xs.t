#!/usr/bin/perl

use 5.014;
use strict;
use warnings;
use autodie;

use Test::More;

use Encoding::FixLatin::XS;

ok(
    UNIVERSAL::can('Encoding::FixLatin::XS','encoding_fixlatin_xs'),
    'expected XS sub is available'
);

# Alias XS sub name to something shorter for test purposes

*fx = \&Encoding::FixLatin::XS::encoding_fixlatin_xs;

is(
    fx("Plain ASCII"),
    "Plain ASCII",
    "plain ASCII input is returned unchanged"
);

is(
    fx("Longer plain ASCII with newline\n"),
    "Longer plain ASCII with newline\n",
    "longer plain ASCII input with newline is returned unchanged"
);

is(
    fx("Plain ASCII\0with embedded null byte"),
    "Plain ASCII\0with embedded null byte",
    "plain ASCII input with embedded null byte returned unchanged"
);

done_testing;

