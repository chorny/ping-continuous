package Ping2DB;
use 5.006;
use strict;
use warnings;

use DBI;
use Time::Piece;
use Net::Ping;
use Time::Hires;
use Exporter 'import';
our @EXPORT=our @EXPORT_OK=qw/create_sqlite_db current_date_hour current_date_hour_10min
ping_periodically open_or_create/;
our $VERSION=0.01;

sub create_sqlite_db {
  my $db_name=shift || 'ping_db.sqlite';
  my $dbh = DBI->connect("DBI:SQLite:$db_name",'','')
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

sub open_or_create {
  my $db_name=shift || 'ping_db.sqlite';
  my $dbh;
  if (-e $db_name) {
    $dbh = DBI->connect('DBI:SQLite:ping_db.sqlite','','')
     || die('Connect error: '.$DBI::errstr);
  } else {
    $dbh = create_sqlite_db($db_name);
  }
}

sub current_date_hour { #date + hour
  my $t = gmtime;
  return $t->ymd.' '.$t->hour;
}

sub current_date_hour_10min { # minutes rounded to multiplier of 10
  my $t = gmtime;
  return $t->ymd.' '.$t->hour.':'.sprintf("%02i",int($t->min/10)*10);
}

sub test_ping {
  my $host=shift;
  my $ping=Net::Ping->new('icmp');
  return $ping->ping($host);
}

sub test_http_ok {
  my $url=shift;
  require LWP::UserAgent;
  my $ua=LWP::UserAgent->new();
  my $response=$ua->get($url);
  if ($response->is_success) {
    if ($response->content()=~/ok/) {
      return 1;
    }
  }
  return 0;
}

sub ping_and_store {
  my $dbh=shift;
  my $host=shift;
  my $dt=current_date_hour_10min();
  my $field;
  if (test_http_ok($host)) {
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

our $ping_periodically_exit=0;
sub ping_periodically {
  my $dbh=shift;
  my $host=shift;
  my $period=shift;
  my $max_period= shift || 0;
  my $end_time=time+$max_period;
  while (1) {
    my $time=time;
    ping_and_store($dbh,$host);
    return if $max_period && time>$end_time;
    return if $ping_periodically_exit;
    if (time<$time+$period) {
      sleep($time+$period-time);
    }
    return if $ping_periodically_exit;
  }
}

1;
