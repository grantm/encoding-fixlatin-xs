#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


SV* _encoding_fix_latin_xs(SV* source) {
    SV* out = NULL;  // Defer initialisation until first non-ASCII character
    U8 *ph, *pt;
    UV i, bytes;

    STRLEN l;
    ph = pt = SvPV(source, l);
    bytes = SvCUR(source);
    for(i = 0; i < bytes; i++, ph++) {
        if((*ph & 0x80) == 0)
            continue;

        out = newSVpv("NOT ASCII",0);
        return(sv_2mortal(out));
    }

    // If the input was all ASCII, just return the input
    if(out == NULL) {
        return(source);
    }

    return out;
}


MODULE = Encoding::FixLatin::XS   PACKAGE = Encoding::FixLatin::XS

SV *
encoding_fixlatin_xs(source)
        SV * source
    PPCODE:
        ST(0) = _encoding_fix_latin_xs(source);
        XSRETURN(1);
