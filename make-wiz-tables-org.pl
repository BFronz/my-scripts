#!/usr/bin/perl
#
#
# Wizard Org

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
	$$row[7] =~ tr/a-z/A-Z/;

	print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t";
	print wf "$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]\t$$row[18]\t$$row[19]\t$$row[20]\t";
	print wf "$$row[21]\t$$row[22]\t$$row[23]\t$$row[24]\t$$row[25]\t$$row[26]\t$$row[27]\t$$row[28]\t$$row[29]\t$$row[30]\t";
	print wf "$$row[31]\t$$row[32]\t$$row[33]\t$$row[34]\t$$row[35]\t$zipcov{$$row[7]}\n";
}  
    
close(wf);

system("mysqlimport -L thomas $outfile");

$rc = $dbh->disconnect;


#   0 date
#   1 acct
#   2 org
#   3 domain
#   4 country
#   5 city
#   6 state
#   7 zip
#   8 cnt
#   9 isp
#  10 block
#  11 orgid
#  12 oid
#  13 ip
#  14 naics
#  15 primary_sic
#  16 countrycode
#  17 dunsnum
#  18 domestichqdunsnumber
#  19 hqdunsnumber
#  20 gltdunsnumber
#  21 countrycode3
#  22 audience
#  23 audiencesegment
#  24 b2b
#  25 employeerange
#  26 forbes2k
#  27 fortune1k
#  28 industry
#  29 informationlevel
#  30 latitude
#  31 longitude
#  32 phone
#  33 revenuerange
#  34 subindustry
#  35 cov
