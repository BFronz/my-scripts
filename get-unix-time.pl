#!/usr/bin/perl
#
# Accepts date input as Mon/dd/yyyy hh:mm:ss and returns unix timestamp (epoch)

use Time::Local;

my $d = $ARGV[0];
my $t = $ARGV[1];
my $m = "";

@d = split /\//, $d;
@t = split /:/, $t;

if ( $d[0] eq "Jan" ) { $m = 0 }
elsif ( $d[0] eq "Feb" ) { $m = 1 }
elsif ( $d[0] eq "Mar" ) { $m = 2 }
elsif ( $d[0] eq "Apr" ) { $m = 3 }
elsif ( $d[0] eq "May" ) { $m = 4 }
elsif ( $d[0] eq "Jun" ) { $m = 5 }
elsif ( $d[0] eq "Jul" ) { $m = 6 }
elsif ( $d[0] eq "Aug" ) { $m = 7 }
elsif ( $d[0] eq "Sep" ) { $m = 8 }
elsif ( $d[0] eq "Oct" ) { $m = 9 }
elsif ( $d[0] eq "Nov" ) { $m = 10 }
elsif ( $d[0] eq "Dec" ) { $m = 11 };

$time = timelocal($t[2], $t[1], $t[0], $d[1], $m, $d[2]);

print "$time\n";
