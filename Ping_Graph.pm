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
  my $period_minutes=shift;
  my $max_dt=max_dt_tp($dbh);
  $max_dt-=60*$period_minutes;
  my $max_dt_str=$max_dt->ymd.' '.$max_dt->hour.':'.$max_dt->min;

  my $sql="SELECT * FROM pings_by_period WHERE dt>$max_dt_str";
  my $sth=$dbh->prepare($sql);

  $sth->execute() || err($dbh->errstr());
  my @values;
  while (my $ref = $sth->fetchrow_hashref()) {
    my $dt=$ref->{'dt'};
    my $fail=$ref->{'pings_fail'};
    push @{$values[0]},$dt;
    push @{$values[1]},$fail || 0;
  }
  @values=sort {$_->[0] cmp $_->[1]} @values;
  require GD::Graph;
  require GD::Graph::mixed;
  my $width=300;
  my $height=200;
  my $graph=GD::Graph::mixed->new($width,$height);
  $graph->set( 
	x_label => 'Fails',
	y_label => 'count',
	title => 'Ping fails',
	#y_max_value => 70,
	#y_tick_number => 10,
	#y_label_skip => 2,
	#accent_treshold => 41,
	transparent => 0,
        #types => [ qw( area area linespoints ) ],
        types => [ qw( bars ) ],
        dclrs => [qw/red/],
  );

  #$graph->set_legend( 'Fails' );
  my $gd=$graph->plot(\@values);
  return $gd->png;
}


1;
