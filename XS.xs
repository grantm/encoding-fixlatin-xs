#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


SV* _encoding_fix_latin_xs(SV* source) {
    SV* out = NULL;  // Defer initialisation until first non-ASCII character
    STRLEN l;
    printf("source = '%s'\n", SvPV(source, l));

    out = newSVpv("RESULT",0);
    sv_2mortal(out);

    return out;
}


MODULE = Encoding::FixLatin::XS   PACKAGE = Encoding::FixLatin::XS

SV *
encoding_fixlatin_xs(source)
        SV * source
    PPCODE:
        ST(0) = _encoding_fix_latin_xs(source);
        XSRETURN(1);
