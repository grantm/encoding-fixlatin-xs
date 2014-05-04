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

*fx = \&Encoding::FixLatin::XS::encoding_fixlatin_xs;

is(fx("RESULT"), "RESULT", "plain ASCII input is returned unchanged");

done_testing;

