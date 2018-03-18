require 5.006;
use ExtUtils::MakeMaker;
WriteMakefile
(
  'PREREQ_PM' => {
                   'Carp' => 0,
                   'Data::Dumper' => 0
                   'Data::Validate::Type' => 0,
                   'LWP::UserAgent' => 0,
                   'Net::Telnet' => 0,
                   'Scalar::Util' => 0,
                   'Storable' => 0,
                   'Test::FailWarnings' => 0,
                   'Test::Most' => 0,
                   'Try::Tiny' => 0,
                 },
  'INSTALLDIRS' => 'site',
  'EXE_FILES' => [],
  'PL_FILES' => {},
  'VERSION_FROM' => 'lib/Net/Dogstatsd.pm',
  'NAME' => 'Net::Dogstatsd',
  'test' => {
              'TESTS' => 't/*.t'
            }
)
;
