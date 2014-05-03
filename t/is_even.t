#!/usr/bin/perl

use 5.014;
use strict;
use warnings;
use autodie;

use Test::More;

use Encoding::FixLatin::XS;

is(Encoding::FixLatin::XS::is_even(0), 1);
is(Encoding::FixLatin::XS::is_even(1), 0);
is(Encoding::FixLatin::XS::is_even(2), 1);

done_testing;
