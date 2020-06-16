#!/usr/bin/perl
#
#

 
use DBI;
require "/usr/wt/trd-reload.ph";
 

$q = "update thomwebtraxs_cross set vid=md5(concat(acct,visitor,city,state,country))  ";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;

$q = "DELETE FROM thomwebtraxs_cid_do_over";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;   

$q = "INSERT INTO thomwebtraxs_cid_do_over (cid) SELECT cid FROM webtraxs_cid LEFT JOIN webtraxs_cross ON cid=acct WHERE acct IS NULL GROUP BY cid ";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;  

 
$rc = $dbh->disconnect;
 
print "\n\load-webtraxs2 completed...\n\n";
