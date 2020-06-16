#!/usr/bin/perl
#
#


use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$rdate = " '1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612' ";
$i=0;   

$outfile = "CurrentInvestment-2016-Activity.txt";
$outfile = "CurrentInvestment-2016-Activity2.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "Category ID\tCategory Name\tPaid\tBold\tFree\tNatPOP\tStPOP\tSupplier Evaluations 2016\tConverted User Sessions 2016\tTotal User Sessions 2016\n";

             
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

	$paid=0; # number of listings due to rank points
	$q  = "SELECT count(*) FROM tgrams.position  WHERE heading='$heading'  AND pop>0 ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$paid = $$row[0];
	}
	$sth->finish;
	if($paid eq "") {$paid="0";}
 
	$bold=0; # number of listings due to advertiser status, no rank points
	$q  = "SELECT count(*) FROM tgrams.position  WHERE heading='$heading' AND pop=0 AND adv=1 ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$bold = $$row[0];
	} 
	$sth->finish;
	if($bold eq "") {$bold="0";}
       
	$free=0; # number of non-advertiser listings
	$q  = "SELECT count(*) FROM tgrams.position  WHERE heading='$heading'  AND pop=0 and adv=0 ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$free = $$row[0];
	}
	$sth->finish;
	if($free eq "") {$free="0";} 

 
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
	$q  = "SELECT SUM(pop) FROM tgrams.position  WHERE heading='$heading' AND cov!='NA' AND pop>0  ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$StPOP = $$row[0];
	} 
	$sth->finish;
	if($StPOP  eq "") {$StPOP ="0";} 

  
        $se=0; # all coverage areas including National
        $q  = "SELECT SUM(us) AS se FROM thomqlogY WHERE date IN ($rdate)  AND heading='$heading' AND covflag='t'  ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
                $se = $$row[0];
	} 
	$sth->finish;
	if($se eq "") {$se="0";} 

   
	$converted_visits = 0; # all coverage areas including National
	$query  = "SELECT sum(convertedvisits) FROM thomtnetloghdgCovConvM  WHERE date in ($rdate) AND heading='$heading'   ";
	my $sth = $dbh->prepare($query);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$converted_visits = $$row[0];
	} 
	$sth->finish;
	if($converted_visits eq "") {$converted_visits="0";}  
 
  
	$total_user_sessions = 0; # all coverage areas including National
	$query  = " SELECT SUM(cnt) FROM thomquickUS16 WHERE date in ($rdate )  AND heading='$heading' AND covflag='t'  ";
	my $sth = $dbh->prepare($query);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$total_user_sessions = $$row[0];
	} 
	$sth->finish;
	if($total_user_sessions eq "") {$total_user_sessions="0";} 

	print wf "$heading\t$desc\t$paid\t$bold\t$free\t$NatPOP\t$StPOP\t$se\t$converted_visits\t$total_user_sessions\n";  
 

 	$j++;
}

close(wf);

$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 
 
print "\nDone...";
