#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use lib '.';
use Time::Piece;
use Test::More qw(no_plan);

{
my $time=Time::Piece->strptime('2009-04-10 19:34',"%Y-%m-%d %H:%M");
is($time->year,2009);
is($time->mon,4);
is($time->mday,10);
is($time->hour,19);
is($time->min,34);
$time+=3600;
is($time->hour,20);
is($time->min,34);
}
{
my $time=Time::Piece->strptime('09-04-10',"%y-%m-%d");
is($time->year,2009);
is($time->mon,4);
is($time->mday,10);
}
{
my $time=Time::Piece->strptime('10-04-2009',"%d-%m-%Y");
is($time->year,2009);
is($time->mon,4);
is($time->mday,10);
}
