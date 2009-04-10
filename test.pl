#/usr/bin/perl
use 5.006;
use strict;
use warnings;
use Ping2DB;
use Test::More qw(no_plan);
unlink('ping_db.sqlite');
my $dbh=create_sqlite_db();
ok($dbh);
like(current_date_hour,qr/^\d{4}-\d{2}-\d{2} \d{2}$/s);
like(current_date_hour_10min,qr/^\d{4}-\d{2}-\d{2} \d{2}:\d0$/s);
Ping2DB::ping_and_store($dbh,'localhost');

