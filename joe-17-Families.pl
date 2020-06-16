#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$rdate = " '1702' ";
$label  = "February-2017";
$famids = " 157558,151598,157754,151613,151470,157559,152397,152546,152161,151467,151461,151464,151761,152585,152133,151845,151628 ";

  
  
$i=0; 

$outfile = $label . "-17-Families.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "Family\tConverted Visits\tSupplier Evaluations\n";
    
  
# put families in an array  
$query  =  "SELECT taxonomy_family_id,taxonomy_family_name FROM taxonomy.taxonomy_family  WHERE taxonomy_family_id IN ($famids) ORDER BY taxonomy_family_name ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$family[$i] = "$$row[0]\t$$row[1]";
	#print "$family[$i]\n";
	$i++;  
}
$sth->finish;
  
$j=1;
foreach $family (@family)
 {
	($famid,$desc) = split(/\t/,$family);

 	# get uses
	$us = "";   
	$q  = "SELECT sum(cnt) FROM thomtnetlogORGCATD17M AS o, taxonomy.tax_headings AS t  ";
	$q .= "WHERE FamilyID = '$famid'  AND heading=HeadingID AND heading > 0   "; 
	$q .= "AND  date in ($rdate)  ";
	print "\n$q\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$us = $$row[0];
	} 
	$sth->finish;
	if($us eq "") {$us="0";}
      
	# get converted visits
	$se = ""; 
	$q  = "SELECT sum(convertedvisits) FROM thomtnetloghdgCovConvM AS c, taxonomy.tax_headings AS t ";
        $q .= "WHERE  FamilyID = '$famid'  AND heading=HeadingID  ";
        $q .= "AND date in ($rdate) AND heading > 0  ";
	print "\n$q\n\n";	
	my $sth = $dbh->prepare($q);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$se = $$row[0]; 
	}    
	$sth->finish;
	if($se eq "") {$se="0";}

		print "$j) $desc - $famid\t$se\t$us\n";
		print wf "$desc\t$se\t$us\n";
 		$j++;
}

close(wf);

print "\n\n";
 

$outfile2 = $label . "-17-Families-Categories.txt";
open(wf, ">$outfile2")  || die (print "Could not open $outfile2\n");
print wf "Family\tFamily ID\tCategory\tCategory ID\n";

$j=1;
foreach $family (@family)
 {
	($famid,$desc) = split(/\t/,$family);

  
	$q  = "SELECT description, HeadingID FROM taxonomy.tax_headings AS t, tgrams.headings AS h  ";
	$q .= "WHERE FamilyID = '$famid'  AND heading=HeadingID GROUP BY HeadingID ORDER BY description "; 
	#print "\n$q\n"; 
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{ 
		print "$j) $desc\t$famid\t$$row[0]\t$$row[1]\n";
		print wf "$desc\t$famid\t$$row[0]\t$$row[1]\n";
 		$j++; 

	} 
	$sth->finish;

 

}


close(wf);




$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 


=for comment
=cut 
 
print "\nDone...";
