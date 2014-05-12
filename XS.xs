#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"


U8 _encoding_fix_latin_ms_map[] = {
    0xE2, 0x82, 0xAC, 0x00,   // 80 EURO SIGN
    0x25, 0x38, 0x31, 0x00,   // 81 <UNUSED>
    0xE2, 0x80, 0x9A, 0x00,   // 82 SINGLE LOW-9 QUOTATION MARK
    0xC6, 0x92, 0x00, 0x00,   // 83 LATIN SMALL LETTER F WITH HOOK
    0xE2, 0x80, 0x9E, 0x00,   // 84 DOUBLE LOW-9 QUOTATION MARK
    0xE2, 0x80, 0xA6, 0x00,   // 85 HORIZONTAL ELLIPSIS
    0xE2, 0x80, 0xA0, 0x00,   // 86 DAGGER
    0xE2, 0x80, 0xA1, 0x00,   // 87 DOUBLE DAGGER
    0xCB, 0x86, 0x00, 0x00,   // 88 MODIFIER LETTER CIRCUMFLEX ACCENT
    0xE2, 0x80, 0xB0, 0x00,   // 89 PER MILLE SIGN
    0xC5, 0xA0, 0x00, 0x00,   // 8A LATIN CAPITAL LETTER S WITH CARON
    0xE2, 0x80, 0xB9, 0x00,   // 8B SINGLE LEFT-POINTING ANGLE QUOTATION MARK
    0xC5, 0x92, 0x00, 0x00,   // 8C LATIN CAPITAL LIGATURE OE
    0x25, 0x38, 0x44, 0x00,   // 8D <UNUSED>
    0xC5, 0xBD, 0x00, 0x00,   // 8E LATIN CAPITAL LETTER Z WITH CARON
    0x25, 0x38, 0x46, 0x00,   // 8F <UNUSED>
    0x25, 0x39, 0x30, 0x00,   // 90 <UNUSED>
    0xE2, 0x80, 0x98, 0x00,   // 91 LEFT SINGLE QUOTATION MARK
    0xE2, 0x80, 0x99, 0x00,   // 92 RIGHT SINGLE QUOTATION MARK
    0xE2, 0x80, 0x9C, 0x00,   // 93 LEFT DOUBLE QUOTATION MARK
    0xE2, 0x80, 0x9D, 0x00,   // 94 RIGHT DOUBLE QUOTATION MARK
    0xE2, 0x80, 0xA2, 0x00,   // 95 BULLET
    0xE2, 0x80, 0x93, 0x00,   // 96 EN DASH
    0xE2, 0x80, 0x94, 0x00,   // 97 EM DASH
    0xCB, 0x9C, 0x00, 0x00,   // 98 SMALL TILDE
    0xE2, 0x84, 0xA2, 0x00,   // 99 TRADE MARK SIGN
    0xC5, 0xA1, 0x00, 0x00,   // 9A LATIN SMALL LETTER S WITH CARON
    0xE2, 0x80, 0xBA, 0x00,   // 9B SINGLE RIGHT-POINTING ANGLE QUOTATION MARK
    0xC5, 0x93, 0x00, 0x00,   // 9C LATIN SMALL LIGATURE OE
    0x25, 0x39, 0x44, 0x00,   // 9D <UNUSED>
    0xC5, 0xBE, 0x00, 0x00,   // 9E LATIN SMALL LETTER Z WITH CARON
    0xC5, 0xB8, 0x00, 0x00,   // 9F LATIN CAPITAL LETTER Y WITH DIAERESIS
    0x00
};


static SV* _encoding_fix_latin_xs(SV*);
static int consume_utf8_bytes(U8*, U8*);
static int consume_latin_byte(U8*, U8*);


static SV* _encoding_fix_latin_xs(SV* source) {
    SV* out = NULL;  // Defer initialisation until first non-ASCII character
    U8 *ph, *pt;
    U8 ubuf[8];
    UV i, bytes, bytes_consumed;

    STRLEN l;
    ph = pt = SvPV(source, l);
    bytes = SvCUR(source);
    for(i = 0; i < bytes; i++, ph++) {
        if((*ph & 0x80) == 0)
            continue;

        if(out == NULL) {   // Deferred initialisation
            out = newSV(bytes * 12 / 10);  // Pre-allocate 20% more space
            SvPOK_on(out);
        }

        // Copy the ASCII byte sequence up to, but not including, the byte that
        // we're currently pointing at
        if(ph > pt) {
            sv_catpvn(out, pt, (STRLEN)(ph - pt));
        }

        bytes_consumed = consume_utf8_bytes(ph, ubuf);
        if(!bytes_consumed) {
            bytes_consumed = consume_latin_byte(ph, ubuf);
        }
        sv_catpvn(out, ubuf, strnlen(ubuf, 8));
        i  += bytes_consumed - 1;
        ph += bytes_consumed - 1;

        pt = ph + 1;
    }

    // If the input was all ASCII, just return the input
    if(out == NULL) {
        return(source);
    }

    if(ph > pt) {
        sv_catpvn(out, pt, (STRLEN)(ph - pt));
    }

    SvUTF8_on(out);

    return(sv_2mortal(out));
}

static int consume_utf8_bytes(U8* in, U8* out) {
    UV  cp, bytes, i;
    U8 *d;

    if((in[0] & 0b11100000) == 0b11000000) {
        cp = in[0] & 0b00011111;
        bytes = 2;
    }
    else if((in[0] & 0b11110000) == 0b11100000) {
        cp = in[0] & 0b00001111;
        bytes = 3;
    }
    else if((in[0] & 0b11111000) == 0b11110000) {
        cp = in[0] & 0b00000111;
        bytes = 4;
    }
    else if((in[0] & 0b11111100) == 0b11111000) {
        cp = in[0] & 0b00000011;
        bytes = 5;
    }
    else {
        return(0);
    }

    for(i = 1; i < bytes; i++) {
        if((in[i] & 0b11000000) != 0b10000000) {
            return(0);
        }
        cp <<= 6;
        cp += in[i] & 0b00111111;
    }

    d = uvchr_to_utf8(out, cp);
    *d = '\0';
    return(bytes);
}


static int consume_latin_byte(U8* in, U8* out) {
    U8 *d;

    if(in[0] > 0x9F) {
        d = uvchr_to_utf8(out, (UV)in[0]);
        *d = '\0';
    }
    else {
        strncpy(out, _encoding_fix_latin_ms_map + (in[0] & 0x7F) * 4, 4);
    }
    return(1);
}


MODULE = Encoding::FixLatin::XS   PACKAGE = Encoding::FixLatin::XS

SV *
encoding_fixlatin_xs(source)
        SV * source
    PPCODE:
        ST(0) = _encoding_fix_latin_xs(source);
        XSRETURN(1);
