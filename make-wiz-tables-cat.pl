#!/usr/bin/perl
#
#
# Wizard Catebory

use DBI;
require "/usr/wt/trd-reload.ph";
 
$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date\n\n"; exit;}
 

$fyear     = "20" . substr($fdate, 0, 2);
$yy        =  substr($fdate, 0, 2);
$mm        =  substr($fdate, 2, 2);
$table     = "tnetlogORGCATD" . $yy . "_" . $mm . "W";

$outfile = $table . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        

print "\nTable:$table Outfile:$outfile\n"; 

$query = "SELECT zip, cov FROM tgrams.fullzip2cov ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{     
	$zipcov{$$row[0]} = $$row[1];
}   
$sth->finish;
  
# pull records add zcov if available              
$query  = "SELECT * FROM $table  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{         	  
	$$row[8] =~ tr/a-z/A-Z/;
  
	print wf  "$$row[0]\t"; 
	print wf  "$$row[1]\t"; 
	print wf  "$$row[2]\t"; 
	print wf  "$$row[3]\t"; 
	print wf  "$$row[4]\t"; 
	print wf  "$$row[5]\t"; 
	print wf  "$$row[6]\t"; 
	print wf  "$$row[7]\t"; 
	print wf  "$$row[8]\t";  # zip
	print wf  "$$row[9]\t"; 
	print wf  "$$row[10]\t";
	print wf  "$$row[11]\t";
	print wf  "$$row[12]\t";
	print wf  "$$row[13]\t";
	print wf  "$$row[14]\t";
	print wf  "$$row[15]\t";
	print wf  "$$row[16]\t";
	print wf  "$$row[17]\t";
	print wf  "$$row[18]\t";
	print wf  "$$row[19]\t";
	print wf  "$$row[20]\t";
	print wf  "$$row[21]\t";
	print wf  "$$row[22]\t";
	print wf  "$$row[23]\t";
	print wf  "$$row[24]\t";
	print wf  "$$row[25]\t";
	print wf  "$$row[26]\t";
	print wf  "$$row[27]\t";
	print wf  "$$row[28]\t";
	print wf  "$$row[29]\t";
	print wf  "$$row[30]\t";
	print wf  "$$row[31]\t";
	print wf  "$$row[32]\t";
	print wf  "$$row[33]\t";
	print wf  "$$row[34]\t";
	print wf  "$$row[35]\t";
	print wf  "$$row[36]\t";
	print wf  "$zipcov{$$row[8]}\n";
  
	#print "$i.\t$$row[8] | $zipcov{$$row[8]}\n";
	$i++;
}  
    
close(wf);

system("mysqlimport  -dL thomas $outfile");

$rc = $dbh->disconnect;

 

