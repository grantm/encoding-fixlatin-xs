#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


MODULE = Encoding::FixLatin::XS   PACKAGE = Encoding::FixLatin::XS

SV *
encoding_fixlatin_xs(source)
        SV * source
    INIT:
        STRLEN l;
        printf("source = '%s'\n", SvPV(source, l));
        if(0) {
            XSRETURN_UNDEF;
        }
    PPCODE:
        ST(0) = newSVpv("RESULT",0);
        sv_2mortal(ST(0));
        XSRETURN(1);
