#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"


MODULE = Encoding::FixLatin::XS   PACKAGE = Encoding::FixLatin::XS

int
is_even(input)
        int input
    CODE:
        RETVAL = (input % 2 == 0);
    OUTPUT:
        RETVAL
