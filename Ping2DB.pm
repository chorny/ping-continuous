package Ping2DB;
use 5.006;
use strict;
use warnings;
use DBI;
use Time::Piece;
use Net::Ping;
use Exporter 'import';
our @EXPORT=our @EXPORT_OK=qw/create_sqlite_db current_date_hour current_date_hour_10min/;

sub create_sqlite_db {
  my $dbh = DBI->connect('DBI:SQLite:ping_db.sqlite','','')
    || die('Connect error: '.$DBI::errstr);
  $dbh->do(<<'EOT') or die('DB error '. $dbh->errstr());
CREATE TABLE pings_by_period (
 dt VARCHAR NOT NULL PRIMARY KEY,
 pings_pass INTEGER NOT NULL DEFAULT 0,
 pings_fail INTEGER NOT NULL DEFAULT 0
)
EOT
  return $dbh;
}

sub current_date_hour {
  my $t = gmtime;
  return $t->ymd.' '.$t->hour;
}

sub current_date_hour_10min {
  my $t = gmtime;
  return $t->ymd.' '.$t->hour.':'.sprintf("%02i",int($t->min/10)*10);
}

sub ping_and_store {
  my $dbh=shift;
  my $host=shift;
  my $ping=Net::Ping->new();
  my $dt=current_date_hour_10min();
  my $field;
  if ($ping->ping($host)) {
    $field='pings_pass';
  } else {
    $field='pings_fail';
  }
  my $sql="UPDATE pings_by_period
  SET $field=$field+1
  WHERE dt=?";
  my $n=$dbh->do($sql,{},$dt) || die('DB error '. $dbh->errstr());;
  if ($n==0) {
    $sql="INSERT INTO pings_by_period (dt,$field) VALUES (?,1)";
    $dbh->do($sql,{},$dt) || die('DB error '. $dbh->errstr()."\nsql: $sql");;
  }
}

1;
