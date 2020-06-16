#!/usr/bin/perl
#
# test

use DBI;
#$dbh      = DBI->connect("", "", "");
#$dbh      = DBI->connect("dbi:mysql:dbname=thomas:host=po.ec2.c.net", , ) or die "Can't connect to DB:$!\n";
$dbh      = DBI->connect("dbi:mysql:thomas:", "", "") or die "Can't connect to DB:$!\n";
   
   

$query  = " select description, heading from thomheadings order by description limit 10 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {    
  $hd[$i]="$$row[0]|$$row[1]";
  print "$hd[$i]\n";
  $i++; 
 }
$sth->finish;
  
$dbh->disconnect;

print "\nDone...\n\n";
