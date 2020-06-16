#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$i=0;   
$outfile = "Category-points.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "Category ID\tCategory Name\tTotal National Points\tTotal State Points\n"; 

 
# get all account that are state pop only
$state_accounts="";
$query ="select acct, sum(if(cov='NA', pop,0)) as natpop,  sum(if(cov!='NA', pop,0)) as covpop from tgrams.position where adv>'' group by acct having (natpop=0 && covpop>0) ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
	$state_accounts .= $$row[0] . ",";
} 
$sth->finish;
$state_accounts  = substr($state_accounts, -1) = '';  
#print "$state_accounts"; exit;


              
# put headings in an array
$i=0;   
$query  =  "SELECT heading, description FROM tgrams.headings ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$cat[$i]="$$row[0]\t$$row[1]";
	$i++; 
}
$sth->finish;
 
  

$j=1;
foreach $cat (@cat)
{
	($heading,$desc) = split(/\t/,$cat);
	print "$j) $desc\t$hd\n";   
  
	$NatPOP=0; # sum of all rank points across all National advertisers
	$q  = "SELECT SUM(pop) FROM tgrams.position  WHERE heading='$heading' AND cov='NA' AND pop>0  ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$NatPOP = $$row[0];
	} 
	$sth->finish;
	if($NatPOP eq "") {$NatPOP="0";} 
 
	$StPOP=0; # sum of all state points across all State advertisers
	$q  = "SELECT SUM(pop) FROM tgrams.position  WHERE heading='$heading' AND cov!='NA' AND pop>0  AND acct IN ($state_accounts)  ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$StPOP = $$row[0];
	} 
	$sth->finish;
	if($StPOP  eq "") {$StPOP ="0";} 

	print wf "$heading\t$desc\t$NatPOP\t$StPOP\n";  
 
	$j++;
}

close(wf);

$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 
 
print "\nDone...";
