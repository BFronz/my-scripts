#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";
   
$rdate = "'1608','1609','1610','1611','1612','1701','1702','1703','1704','1705','1706','1707'";
#$rdate = "'1707'"; # testing
$year ="August2016-July2017";

sub PrintQ
{
	$q = $_[0];
	print "\n$q\n";
}

$i=0; 
$outfile = "Cateogry-Activity-".   $year  . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); 
print wf "CategoryID\tCategoryName\tUser Sessions\tConverted User Sessions\tConversions\n";
     
# put headings in an array 
$query  =  "SELECT heading, description FROM tgrams.headings order by description";
#$query  =  "SELECT heading, description FROM tgrams.headings where heading=3601481 order by description";
#$query .= " LIMIT 1000 "; # testing
PrintQ($query);
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$heading[$i] = "$$row[0]\t$$row[1]";
	$i++; 
}
$sth->finish;
   
   
$j=1;
foreach $heading (@heading)
 {
	($hd,$desc) = split(/\t/,$heading);
	print "$j) $desc\t$hd\n";

	# User Sessions 	 
	$us="0";
	#$q = "SELECT sum(cnt) AS us FROM thomquickUSM  WHERE date IN ($rdate) AND heading='$hd' AND covflag='t'";
	#PrintQ($q);
	#my $sth = $dbh->prepare($q);   
	#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	#while (my $row = $sth->fetchrow_arrayref)
	#{
	#	$us = $$row[0]; 
	#}   
	#$sth->finish;  
 
 
	# Converted User Sessions
	$cus = "0";
	$q  =  "SELECT sum(convertedvisits) FROM thomtnetloghdgCovConvM WHERE  date IN ($rdate) AND heading='$hd' AND cov='NA'  ";
	$q  =  "SELECT sum(convertedvisits) FROM thomtnetloghdgCovConvM WHERE  date IN ($rdate) AND heading='$hd'  ";
	PrintQ($q);
	my $sth = $dbh->prepare($q);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$cus = $$row[0]; 
	}   
	$sth->finish;
    
 	# Conversions
	$conv="0";
	# Links to Supplier Websites (lw), Profiles Viewed (pv), Links to Catalog/CAD (cd + lc), Product Catalog Pages Viewed (pc), Custom Company Profile Interactions (vv + dv + iv + sm + pp + mv )
	$q = "SELECT sum(us), sum(lw + pv + cd + lc + pc + vv + dv + iv + sm + pp + mv) AS cus FROM thomqlogY WHERE date IN ($rdate) AND heading='$hd' AND covflag='t' ";
	PrintQ($q);  
	my $sth = $dbh->prepare($q);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{ 
		$us    = $$row[0]; 
		$conv = $$row[1]; 
	}   
	$sth->finish;     

  	if($us eq "")   {$us="0";}
	if($se eq "")   {$se="0";}
	if($cus eq "")  {$cus="0";}
	if($cus2 eq "")  {$cus2="0";}
	if($conv eq "") {$conv="0";}

	if($us ne "0" && $conv ne "0") {  print wf "$hd\t$desc\t$us\t$cus\t$conv\n"; }
	
	
  
 	$j++;
	print "------------------------------------------\n";
}

close(wf);

$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 

=for comment
=cut 
 
print "\nDone...";
