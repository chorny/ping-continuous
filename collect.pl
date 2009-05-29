#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Ping2DB;
my $dbh=open_or_create();
my $host='http://chorny.net';
print "Pinging $host...\n";
ping_periodically($dbh,$host,20,3600*10);
