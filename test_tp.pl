#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use lib '.';
use Time::Piece;
use Test::More qw(no_plan);

=for cmt
{
my $time=Time::Piece->parse('2009-04-10');
is($time->year,2009);
is($time->mon,4);
is($time->mday,10);
}
{
my $time=Time::Piece->parse('09-04-10');
is($time->year,2009);
is($time->mon,4);
is($time->mday,10);
}
{
my $time=Time::Piece->parse('10-04-2009');
is($time->year,2009);
is($time->mon,4);
is($time->mday,10);
}
=cut
my $date='09-04-10';
my $DATE_SEP=':';
my $TIME_SEP = ':';
        my @components = $date =~ /(\d+)$DATE_SEP(\d+)$DATE_SEP(\d+)(?:(?:T|\s+)(\d+)$TIME_SEP(\d+)(?:$TIME_SEP(\d+)))/;
        @components = reverse(@components[0..5]);
print scalar(@components),"\n";
print Time::Piece::_strftime("%s", @components);
