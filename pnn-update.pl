#!/usr/bin/perl
# 

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);

 
$outfile = "datepublished.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
        
$query  = "SELECT prid, datepublished FROM thomnews_conversions$yy WHERE date='$fdate' and datepublished='0000-00-00 00:00:00' AND prid>0 GROUP BY prid";
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
        #print "$j\t$prid\t$dp\n";
    
	$query  = "SELECT datepublished FROM tgrams.tnn_news WHERE  prid='$prid' ";
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
 	{   
		$query = "UPDATE thomnews_conversions$yy SET datepublished='$$row[0]' WHERE prid='$prid' AND  date='$fdate' ;\n";		
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
