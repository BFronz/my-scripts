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
$label  = "Logo-October2015-to-September2016";

 

$outfile2 = $label . "-detail-all.txt";
open(wf, ">$outfile2")  || die (print "Could not open $outfile2\n");
print wf "Visitor\tLogo\t";
print wf "Industry\tSubindustry\tRevenue Range\tCity\tState\tZip\t";
print wf "Tgrams Count\t";
print wf "Description\n";

 
    
        # get visitor     
        $sq  = " SELECT o.org, 
			CONCAT('http://reports.tnt.com/tnetnbr/logos/',img), 
			industry, 
			subindustry,
			revenuerange, 
			city, 
			state, 
			zip, 
			count(distinct acct),
			description    
		FROM tnetlogORGCATDWIZ AS o, wizlogos AS w   
		WHERE  o.org=w.org AND date in ($rdate)  AND o.isp='N'  AND img>'' GROUP BY o.org, city, state, zip";
        #print "\n$sq\n";  
        my $ssth = $dbh->prepare($sq);
        if (!$ssth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $srow = $ssth->fetchrow_arrayref)
        { 
  
		$$srow[0] =~ s/^\s+//;
		$$srow[0] =~ s/\s+$//;
		$$srow[0] =~ s/&amp;/&/g;
		$$srow[0] =~ s/\n//g;
		$$srow[0] =~ s/\t//g;
		$$srow[2] =~ s/\R//g;

		$$srow[9] =~ s/^\s+//;
		$$srow[9] =~ s/\s+$//;
		$$srow[9] =~ s/&amp;/&/g;
		$$srow[9] =~ s/\n//g;
		$$srow[9] =~ s/\t//g;
		$$srow[9] =~ s/\R//g;
                                        
		print "$j) $$srow[0]\t\n";
		print wf "$$srow[0]\t$$srow[1]\t$$srow[2]\t$$srow[3]\t$$srow[4]\t$$srow[5]\t$$srow[6]\t$$srow[7]\t$$srow[8]\t$$srow[9]\n";
 		$j++; 
	} 
        $ssth->finish;
       



close(wf);




$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 


=for comment
=cut 
 
print "\nDone...";
