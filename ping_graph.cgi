#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Ping_Graph;
use CGI qw/header/;

my $dbh = DBI->connect('DBI:SQLite:ping_db.sqlite','','')
  || die('Connect error: '.$DBI::errstr);
print header(-type=>'image/png');
binmode STDOUT;
print graph_for_latest($dbh,5*60);
