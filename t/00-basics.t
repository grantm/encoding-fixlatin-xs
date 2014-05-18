#!perl -T

use 5.014;
use strict;
use warnings;
use autodie;

use Test::More;

use Encoding::FixLatin::XS;

ok(
    UNIVERSAL::can('Encoding::FixLatin::XS','_fix_latin_xs'),
    'expected XS sub is available'
);

# Alias XS sub name to something shorter for test purposes

*fx = \&Encoding::FixLatin::XS::_fix_latin_xs;

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

is(
    fx("M\xC4\x81ori"),
    "M\x{101}ori",
    "UTF-8 bytes passed through"
);

is(
    fx("Caf\xE9"),
    "Caf\x{E9}",
    "latin byte transcoded to UTF-8"
);

is(
    fx("Caf\xE9 Rom\xC4\x81 (\xE2\x82\xAC9.99)"),
    "Caf\x{E9} Rom\x{101} (\x{20AC}9.99)",
    "mixed latin and UTF-8 translated to UTF-8"
);

done_testing;

