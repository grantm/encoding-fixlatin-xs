Encoding::FixLatin::XS
======================

This Perl module is an add-on for the
[Encoding::FixLatin](https://metacpan.org/pod/Encoding::FixLatin) module to
provide an implementation of the `fix_latin` algorithm written in C for
significantly improved performance.  The documentation link for
Encoding::FixLatin (above) describes what the module does - this module does
exactly the same thing but faster.

To use this module, simply install it from CPAN and then use
`Encoding::FixLatin` as normal.  The XS implementation layer will be used if
it's available, otherwise the pure-Perl implementation will be used as a
fallback.
