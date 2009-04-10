#/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Ping2DB;
my $dbh=create_sqlite_db();
die unless current_date_hour=~/^\d{4}-\d{2}-\d{2} \d{2}$/s;
