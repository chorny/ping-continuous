#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Ping_Graph;
use DBI;

my $dbh = DBI->connect('DBI:SQLite:ping_db.sqlite','','')
  || die('Connect error: '.$DBI::errstr);
open my $fh,'>','ping.png';
binmode $fh;
print $fh graph_for_latest($dbh,5*60);
