#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

 
#$rdatelable = "March2015"; $table = "thomtnetlogORGD15_03W";  $postable = "position15Q1";
#$rdatelable = "July2015";  $table = "thomtnetlogORGD15_07W"; $postable = "position15Q2";
  
#$rdatelable = "March2016"; $table = "thomtnetlogORGD16_03W";  $postable = "position16Q1";          
#$rdatelable = "April2016";  $table = "thomtnetlogORGD16_04W"; $postable = "position16Q1";
#$rdatelable = "May2016";    $table = "thomtnetlogORGD16_05W"; $postable = "position16Q2";
#$rdatelable = "June2016";   $table = "thomtnetlogORGD16_06W"; $postable = "position16Q2";
#$rdatelable = "July2016";   $table = "thomtnetlogORGD16_07W"; $postable = "position16Q2"; 
#$rdatelable = "August2016";   $table = "thomtnetlogORGD16_08W"; $postable = "position16Q3"; 

#$rdatelable = "September2016";   $table = "thomtnetlogORGD16_09W"; $postable = "position16Q3"; 
 
$rdatelable = "October2016";   $table = "thomtnetlogORGD16_10W"; $postable = "position16Q4"; 
      
$i=0;   

$outfile = "supplier_visitor_co_org_isp_counts_sessions" .  $rdatelable . "_alt.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "Account Name\tAccount Number\tAdvertiser Y/N\tCo/Org Unique Name / Location Count\tCo/Org User Session Count\tISP Unique Name / Location Count\tISP User Session Count\n";
   
    
# accts in an array
$i=0; 
$query  =  "SELECT distinct (acct) FROM $table  ";
#print "\n$query\n\n";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$acct[$i] = $$row[0];
	$i++; 
}
$sth->finish;
 
      
# org data
$query  =  "select acct, sum(cnt), count(distinct(concat(org,city,state,zip))) from $table where isp='N' and acct>0   group by acct ";
#print "$query\n\n";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
        $orgus[$$row[0]]  = $$row[1];
        $orgloc[$$row[0]] = $$row[2];
} 
$sth->finish;
  
    
# isp data
$query  =  "select acct, sum(cnt), count(distinct(concat(org,city,state,zip))) from $table where isp='Y' and acct>0   group by acct  ";
#print "$query\n\n"; 
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
        $ispus[$$row[0]] = $$row[1];
        $isploc[$$row[0]] = $$row[2];
} 
$sth->finish;

  

$j=1;
foreach $acct (@acct)
{ 	
	print "$j.\t$acct\n";
 
	$comp = $adv =  $org_us = $org_loc = $isp_us = $isp_loc = "";

	$adv=0;
	$q  = "SELECT  adv FROM thom$postable  WHERE acct='$acct' limit 1  ";
	if($debug eq 1) { print " $q\n\n"; } 
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $sth->fetchrow_arrayref)
	{  
		$adv = $$row[0];
	}  
	if($adv eq "1") { $adv = "Y"; }
	else            { $adv = "N"; }


	$q  = "SELECT company, adv FROM tgrams.main  WHERE acct='$acct'  ";
	if($debug eq 1) { print " $q\n\n"; }
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{  
		$comp = $$row[0];

		$org_us  = $orgus[$acct]; 
		$org_loc = $orgloc[$acct];
		$isp_us  = $ispus[$acct]; 		
		$isp_loc = $isploc[$acct];
                         
		if($org_us eq "")  { $org_us  = "0"; }		
		if($org_loc eq "") { $org_loc = "0"; }		
		if($isp_us eq "")  { $isp_us  = "0"; }		
		if($isp_loc eq "") { $isp_loc = "0"; }		
	
		print wf "$$row[0]\t";
 		print wf "$acct\t";
		print wf "$adv\t";

		print wf "$org_loc\t";
		print wf "$org_us\t";

		print wf "$isp_loc\t"; 
		print wf "$isp_us\n";
	}
	$sth->finish;		

	$j++;
}

close(wf);

$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 
 
print "\nDone...";
