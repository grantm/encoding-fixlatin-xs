use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Encoding::FixLatin::XS',
    VERSION_FROM      => 'lib/Encoding/FixLatin/XS.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Encoding/FixLatin/XS.pm', # retrieve abstract from module
    AUTHOR            => 'Grant McLean <grantm@cpan.org>',
    LIBS              => [''], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
    # Insert -I. if you add *.h files later:
    INC               => '', # e.g., '-I/usr/include/other'
    # Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
