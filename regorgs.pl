#!/usr/bin/perl
# 
use DBI;
require "/usr/wt/trd-reload.ph";

open(wf,  ">regorgsupdate.txt")  || die (print "Could not open regorgsupdate.txt\n");

$i=1;
                           
$query  = "SELECT zip FROM thomregorgs";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
		
		$zipin = $$row[0];
   
		# try primary first 
        	$squery  = "SELECT place_name, admin_code1  FROM thomallCountries WHERE postal_code like '%$zipin' AND country_code='us' limit 1 ";
        	$squery1  = "SELECT place_name, admin_code1  FROM thomallCountries WHERE postal_code like '%$zipin' AND country_code='US' limit 1 ";
        	my $ssth = $dbh->prepare($squery);  
        	if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        	if (my $srow = $ssth->fetchrow_arrayref)
        	{ 
        	$city  =  $$srow[0];
        	$state =  $$srow[1];
        	}
        	$ssth->finish;

        	if($city eq "") { # try for secondary
        	$squery  = "SELECT City, State  FROM thomzipcodes WHERE Zipcode like '%$zipin' AND LocationType='ACCEPTABLE' limit 1 ";
        	my $ssth = $dbh->prepare($squery);
        	if (!$ssth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
        	if (my $srow = $ssth->fetchrow_arrayref)
        	{
        	$city  =  $$srow[0];
        	$state =  $$srow[1];
        	}
        	$ssth->finish;
		}

    		$city  =~ tr/[A-Z]/[a-z]/;
    		$state =~ tr/[A-Z]/[a-z]/;

		print wf "update regorgs set city='$city', state='$state' where zip='$zipin';\n";

		
	
		print "$i.\t$zip\t$city\t$state\n";                     

		$city = $state = "";
		$i++;
 }  
$sth->finish;


close(wf);
