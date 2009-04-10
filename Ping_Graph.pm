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
  my $max_time=Time::Piece->parse($max_dt);
}

sub graph_for_latest {
  my $dbh=shift;
  my $max_dt=max_dt($dbh);
  my $max_time=Time::Piece->parse($max_dt);

  my $sql="SELECT dt AS m FROM pings_by_period WHERE $max_dt";
  my $sth=$dbh->prepare($sql);

  $sth->execute() || err($dbh->errstr());
  if (my $ref = $sth->fetchrow_hashref()) {
    return $max_dt;
  } else {
    die;
  }
}


1;
