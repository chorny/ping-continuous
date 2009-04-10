#/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Ping2DB;
my $dbh=create_sqlite_db();
ping_periodically($dbh,'forum.md',20,1500);
