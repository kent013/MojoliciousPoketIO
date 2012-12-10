use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
    'DBI'         => 0,
    'FindBin'     => 0,
    'Plack'       => 0,
    'Twiggy'      => 0,
    'MojoX::Session' => 0,
    'Digest::SHA' => 0,
    'PocketIO' => 0,
    'Mojolicious' => '3.54'
  },
  AUTHOR        => 'kent013',
  test      => {TESTS => 't/*.t'}
);
