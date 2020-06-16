#!/usr/bin/perl
#  

$table="LORdata17_09";
   
use DBI;
require "/usr/wt/trd-reload.ph";
sub updateTable
{ 
	$q = $_[0];
	#print "\n$q\n"; 
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	#sleep(1);
}    
   
$i=0;
$query  = "SELECT  countryname, iso2, iso3 FROM netacuitycountry ORDER BY countryname ";
#$query .= " LIMIT 5";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{     
	print "$i.\t$$row[0]\t$$row[1]\t$$row[2]\n";
	updateTable("UPDATE thom$table SET country='$$row[1]' WHERE country IN ( '$$row[0]','$$row[2]' ) ");    
	$i++;
}     
$sth->finish;

print "Done...\n";
