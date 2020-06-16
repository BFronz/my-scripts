#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$rdate = " '1608' ";
$label  = "August-2016";
$famids = " 152409, 154387, 152397, 151461, 152403, 159982, 154308, 151761, 152407, 160606, 152336, 151845 ";


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
  
  

$outfile2 = $label . "-12-Families-Categories-alt-detail.txt";
open(wf, ">$outfile2")  || die (print "Could not open $outfile2\n");
print wf "Family\tFamily ID\tCategory\tCategory ID\tVisitor\tLogo\t";
print wf "Industry\tSubindustry\tRevenue Range\t";
print wf "Description\n"; 

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
  
 
        # get visitor
        $sq  = " SELECT o.org, CONCAT('http://reports.tnt.com/tnetnbr/logos/',img), description, sum(cnt) AS tot,  industry, subindustry,revenuerange  FROM tnetlogORGCATD16M AS o, wizlogos AS w   
		WHERE  o.org=w.org AND date in ($rdate)  AND o.isp='N' AND heading=$$row[1] AND img>'' GROUP BY o.org ORDER BY tot DESC limit 1";
        #print "\n$q\n"; 
        my $ssth = $dbh->prepare($sq);
        if (!$ssth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
        while (my $srow = $ssth->fetchrow_arrayref)
        {
 
		$$srow[2] =~ s/^\s+//;
		$$srow[2] =~ s/\s+$//;
		$$srow[2] =~ s/&amp;/&/g;
		$$srow[2] =~ s/\n//g;
		$$srow[2] =~ s/\t//g;
		$$srow[2] =~ s/\R//g;
              
		print "$j) $desc\t$famid\t$$row[0]\t$$row[1]\t$$srow[0]\n";
		print wf "$desc\t$famid\t$$row[0]\t$$row[1]\t$$srow[0]\t$$srow[1]\t$$srow[4]\t$$srow[5]\t$$srow[6]\t$$srow[2]\n";
 		$j++; 
	}
        $ssth->finish;
       


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
