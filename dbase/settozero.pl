#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;


$created = 1467650312; 

  
$query  =  "
SELECT i.ip FROM thomdbaseNetAcuityIP AS i JOIN dbaseIPresolved AS r ON i.ip=r.ip AND i.created>='$created' 
WHERE ( (country='united states' && countrycode3!='usa')  ||  (country='canada' && countrycode3!='can') ) 
AND informationlevel='detail' ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$ips .= "'$$row[0]',";
	$i++;  
}
$sth->finish;
$ips = substr($ips, 0, -1);    
    
$q = " UPDATE thomdbaseNetAcuityIP SET created='0' WHERE ip IN ($ips) ";
#print "\n$q\n"; exit;
my $sth = $dbh->prepare($q);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;     


$dbh->disconnect;

 
print "\nDone...";
