#!/usr/bin/perl
#
#
# Wizard Site 

use DBI;
require "/usr/wt/trd-reload.ph";
 
$table   = $ARGV[0];
if($table eq "") {print "\n\nForgot to add table\n\n"; exit;}

$log = substr($table, 0, -1);

$outfile = $table . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        

print "\nTable:$table Outfile:$outfile Log:$log\n"; 

$query = "SELECT zip, cov FROM tgrams.fullzip2cov ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{     
	$zipcov{$$row[0]} = $$row[1];
}   
$sth->finish;
  
# pull records add zcov if available              
$query  = "SELECT * FROM $log ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{         	 
	$$row[6] =~ tr/a-z/A-Z/;

	print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
	print wf "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t";
	print wf "$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\t";
	print wf "$$row[31]\t$$row[32]\t$$row[33]\t$$row[34]\t$zipcov{$$row[6]}\n";
}  
    
close(wf);

system("mysqlimport -L thomas $outfile");

$rc = $dbh->disconnect;


# 0 date
# 1 org
# 2 domain
# 3 country
# 4 city
# 5 state
# 6 zip
# 7 cnt
# 8 isp
# 9 block
# 10 orgid
# 11 oid
# 12 ip
# 13 naics
# 14 primary_sic
# 15 countrycode
# 16 dunsnum
# 17 domestichqdunsnumber
# 18 hqdunsnumber
# 19 gltdunsnumber
# 20 countrycode3
# 21 audience
# 22 audiencesegment
# 23 b2b
# 24 employeerange
# 25 forbes2k
# 26 fortune1k
# 27 industry
# 28 informationlevel
# 29 latitude
# 30 longitude
# 31 phone
# 32 revenuerange
# 33 subindustry
# 34 cov
