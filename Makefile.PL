use 5.014000;       # May work with older Perls - try it and let me know :-)

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Encoding::FixLatin::XS',
    VERSION_FROM      => 'lib/Encoding/FixLatin/XS.pm', # finds $VERSION
    PREREQ_PM         => {
                            'Encoding::FixLatin'  => 1.03
                         },
    ABSTRACT_FROM     => 'lib/Encoding/FixLatin/XS.pm', # retrieve abstract from module
    AUTHOR            => 'Grant McLean <grantm@cpan.org>',
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    # Insert -I. if you add *.h files later:
    INC               => '', # e.g., '-I/usr/include/other'
    # Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
