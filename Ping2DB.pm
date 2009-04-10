package Ping2DB;
use 5.006;
use strict;
use warnings;
use DBI;
use Time::Piece;
use Exporter 'import';
our @EXPORT=our @EXPORT_OK=qw/create_sqlite_db/;

sub create_sqlite_db {
  my $dbh = DBI->connect('DBI:SQLite:ping_db.sqlite','','')
    || die('Connect error: '.$DBI::errstr);
  $dbh->do(<<'EOT') or die('DB error '. $dbh->errstr());
CREATE TABLE pings_by_hour (
 dt VARCHAR NOT NULL PRIMARY KEY,
 pings_pass INTEGER NOT NULL DEFAULT 0,
 pings_fail INTEGER NOT NULL DEFAULT 0
)
EOT
  return $dbh;
}

1;
