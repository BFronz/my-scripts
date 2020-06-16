#!/usr/bin/perl
# 

use DBI;
require "/usr/wt/trd-reload.ph";
 
$outfile = "datepublished.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
     
$query  = "SELECT prid, datepublished FROM thomnews_conversions17 WHERE datepublished='0000-00-00 00:00:00' AND prid>0 GROUP BY prid";
#$query .= " LIMIT 1000";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $record[$i]="$$row[0]|$$row[1]";
  #print "$record[$i]\n";
  $i++;  
 }
$sth->finish;
print "\ntotal records: $i\n";

$j=1;
foreach $record (@record)
{
        ($prid, $dp) = split(/\|/,$record);
        print "$j\t$prid\t$dp\n";
   
	$query  = "SELECT datepublished FROM tgrams.tnn_news WHERE  prid='$prid' ";
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
 	{   
		$query = "UPDATE thomnews_conversions17 SET datepublished='$$row[0]' WHERE prid='$prid';\n";		
		print wf "$query";
	}
	$sth->finish;
	$j++;
} 
  
$sth->finish;
close(wf);
 
print "\nUpdateing\n";
system("mysql thomas < $outfile"); 

                      
print "\nDone...";
