#!/usr/bin/perl
# 


$table   = $ARGV[0];
if($table eq "") {print "\n\nForgot to add table\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";
 
$i=0;
$dates = "'1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312','1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412','1501','1502','1503','1504' ";
   
$query  = "SELECT zip, city, state FROM thomregorgs WHERE zip>'0' and city>'' order by zip ";
#$query .= "limit 10";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]|$$row[2]";
  #print "$record[$i]\n";
  $i++; 
 }
$sth->finish;
print "\ntotal records: $i\n";

$j=1;
foreach $record (@record)
{
        ($zip,$city,$state) = split(/\|/,$record);
        print "$j\t$zip\t$city\t$state\t $table\n";
 
	$query = "UPDATE $table SET city='$city', state='$state' WHERE zip='$zip' AND date in ($dates) AND latitude='0.0001' AND country='united states' AND city='' AND state='' ";
	$query = "UPDATE $table SET city='$city', reg='$state' WHERE zip='$zip' AND date in ($dates)  AND country='united states'  ";
        #print "$query\n\n"; 
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	$sth->finish;
 
	$j++;
}
close(wf);
close(wf2);
 

                           


