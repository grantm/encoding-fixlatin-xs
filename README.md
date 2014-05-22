Encoding::FixLatin::XS
======================

This CPAN module is an add-on for the
[Encoding::FixLatin](https://metacpan.org/pod/Encoding::FixLatin) module to
provide an implementation of the `fix_latin` algorthim written in C for
significantly improved performance.

To use this module, simply install it from CPAN and then use
`Encoding::FixLatin` as normal.  The XS implementation layer will be used if
it's available, otherwise the pure-Perl implementation will be used as a
fallback.
