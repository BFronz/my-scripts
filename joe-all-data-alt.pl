#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$rdate = " '1510','1511','1512','1601','1602','1603','1604','1605','1606','1607','1608','1609' ";
$label  = "October2015-to-September2016";


 
# put families in an array
$query  =  "SELECT heading,description FROM tgrams.headings  ORDER BY description  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
        $headings[$i] = "$$row[0]\t$$row[1]";
        $i++;
}
$sth->finish;
  
  

$outfile2 = $label . "-Categories-alt-detail-all.txt";
open(wf, ">$outfile2")  || die (print "Could not open $outfile2\n");
print wf "Category\tCategory ID\tVisitor\tLogo\t";
print wf "Industry\tSubindustry\tRevenue Range\tCity\tState\tZip\t";
print wf "Tgrams Count\t";  
print wf "Description\n";  
 
$j=1;
foreach $headings (@headings)
 {
	($hd,$desc) = split(/\t/,$headings);

    
    
        # get visitor    
        $sq  = " SELECT o.org, CONCAT('http://reports.tnt.com/tnetnbr/logos/',img), description, sum(cnt) AS tot,  industry, 
			subindustry,revenuerange, city, state, zip, count(distinct acct)  FROM tnetlogORGCATDWIZ AS o, wizlogos AS w   
		WHERE  o.org=w.org AND date in ($rdate)  AND o.isp='N' AND heading='$hd' AND img>'' GROUP BY o.org, city, state ORDER BY tot DESC";
        #print "\n$sq\n";  
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
                                        
		print "$j) $desc\t$$srow[0]\t\n";
		print wf "$desc\t$hd\t$$srow[0]\t$$srow[1]\t$$srow[4]\t$$srow[5]\t$$srow[6]\t$$srow[7]\t$$srow[8]\t$$srow[9]\t$$srow[10]\t$$srow[2]\n";
 		$j++; 
	} 
        $ssth->finish;
       

}


close(wf);




$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 


=for comment
=cut 
 
print "\nDone...";
