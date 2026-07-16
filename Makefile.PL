use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME      => 'VictoriaMetrics::Client',
  VERSION   => '0.1',
  PREREQ_PM => {
    'Carp'        => 0,
    'HTTP::Tiny'  => 0,
    'JSON::PP'    => 0,
    'URI'         => 0,
    'URI::Escape' => 0
  },
  # tests are good and stuff (need more)
  test => {TESTS => 't/*.t'}
);
