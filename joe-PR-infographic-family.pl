#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$rdate = " '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512' ";
$year = "2015";
$states = " 'CT','ME','MA','NH','RI','VT','NJ','NY','PA,' ";                                        $statelabel = "Region1-Northeast";
# $states = " 'IL','IN','MA','OH','WI','IA','KS','MN','MO','NE','ND','SD' ";                          $statelabel = "Region2-Midwest";
# $states = " 'DE','DC','FL','GA','MD','NC','SC','VA','WV','AL','KY','MS','TN','AR','LA','OK','TX' "; $statelabel = "Region3-South";
# $states = " 'AZ','CO','ID','MT','NV','NM','UT','WY','AK','CA','HI','OR','WA' ";                     $statelabel = "Region4-West";
# $states = " 'AB','BC','MB','NB','NL','NT','NS','NU','ON','PE','QC','SK','YT' ";                     $statelabel = "Region5-Canada";
  
  
$i=0; 
$outfile = "family-infographic-".   $year  . "-" .   $statelabel . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "category\tcategory #\tuser session count\tsupplier evaluations\n";
 
# put families in an array  
$query  =  "SELECT FamilyID, FamilyCategoryName FROM directorytax.taxonomy GROUP BY FamilyID ORDER BY FamilyCategoryName  ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$family[$i] = "$$row[0]\t$$row[1]";
	$i++;  
}
$sth->finish;
  
  
$j=1;
foreach $family (@family)
 {
	($famid,$desc) = split(/\t/,$family);

 	# get uses
	$us = "";   
	$q  = "SELECT sum(cnt) FROM thomtnetlogORGCATD15M AS o, directorytax.tax_headings AS t  ";
	$q .= "WHERE FamilyID = '$famid'  AND heading=HeadingID AND heading > 0   "; 
	$q .= "AND state in ($states) AND date in ($rdate)  ";
	#print "\n$q\n";
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
	$q  = "SELECT sum(convertedvisits) FROM thomtnetloghdgCovConvM AS c, directorytax.tax_headings AS t ";
        $q .= "WHERE  FamilyID = '$famid'  AND heading=HeadingID  ";
        $q .= "AND date in ($rdate) AND heading > 0  ";
	#print "\n$q\n\n";	
	my $sth = $dbh->prepare($q);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$se = $$row[0]; 
	}    
	$sth->finish;
	if($se eq "") {$se="0";}

	if($us gt 0)
	{
		print "$j) $desc\t$hd\t$us\t$se\n";
		print wf "$desc\t$hd\t$us\t$se\n";
 		$j++;
	}
}

close(wf);

$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 


=for comment
=cut 
 
print "\nDone...";
