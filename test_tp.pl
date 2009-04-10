#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Time::Piece;
use Test::More qw(no_plan);
my $time=Time::Piece->parse('2009-04-10');
is($time->year,2009);
