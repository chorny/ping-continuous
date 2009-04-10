package Ping2DB;
use 5.006;
use strict;
use warnings;
use Time::Piece;
use GD::Graph;

sub max_dt {
  my $dbh=shift;
  my $sql="SELECT MAX(dt) AS m FROM pings_by_period";
  my $sth=$dbh->prepare($sql);

  $sth->execute() || err($dbh->errstr());
  if (my $ref = $sth->fetchrow_hashref()) {
    my $max_dt=$ref->{m};
    return $max_dt;
  } else {
    die;
  }
}

sub max_dt_tp {
  my $dbh=shift;
  my $max_dt=max_dt($dbh);
  my $max_time=Time::Piece->strptime($max_dt,"%Y-%m-%d %H:%M");
  return $max_time;
}

sub graph_for_latest {
  my $dbh=shift;
  my $max_dt=max_dt_tp($dbh);
  $max_dt-=3600*5;

  my $sql="SELECT * FROM pings_by_period WHERE dt>$max_dt";
  my $sth=$dbh->prepare($sql);

  $sth->execute() || err($dbh->errstr());
  while (my $ref = $sth->fetchrow_hashref()) {
    return $max_dt;
  }
}


1;
