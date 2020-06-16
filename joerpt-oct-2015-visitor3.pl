#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);

sub PrintQ
{
 $q = $_[0];
# print "\n$q\n";
}

$outfile = "CompanyOrgs-Counts-Unique-New2-" . $fdate . ".txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Account Name\t";                 
print wf "Account Number\t";               
print wf "Company/Org Visitors\t";
print wf "ISPs\t";  
print wf "User Sessions\n";  

$i=0;
$query  = "SELECT m.company, m.acct FROM tgrams.main AS m, thomtnetlogORGDAllM_test AS o WHERE m.acct=o.acct GROUP BY  m.acct  ORDER BY m.company ";
$query  = "SELECT company, acct FROM tgrams.main   ORDER BY company ";
#$query  .= "LIMIT 500 "; # for testing 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $$row[0] =~ s/\|//g;	
   $record[$i]="$$row[0]|$$row[1]";
   $i++;
 }
$sth->finish;
 

$z=1;
foreach $record (@record)
{
 print "$z) $record\n";
 ($comp, $acct) = split(/\|/,$record);
 
 $acctmap = "0";
 $q = "SELECT dupe FROM tgrams.main_map WHERE prime='$acct'  ";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $acctmap = "$$row[0],";
  }
 $sth->finish;
 $acctmap .= $acct;
   
 $org="0";
 $q  = "SELECT count(distinct org) FROM  thomtnetlogORGDAllM_test WHERE acct IN ($acctmap) AND isp='N' ORDER BY org ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {  
 	$org = $$row[0]; 
 } 
 $sth->finish; 

 
 $isp="0";
 $q  = "SELECT count(distinct org) FROM  thomtnetlogORGDAllM_test WHERE acct IN ($acctmap) AND isp='Y' ORDER BY org ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
 	$isp = $$row[0]; 
 } 
 $sth->finish; 

 $us="0";
 $q  = "SELECT sum(us) FROM  thomtnetlogARTU_test  WHERE acct IN ($acctmap) ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
 	$us = $$row[0]; 
 } 
 $sth->finish; 
if($us eq "") {$us="0";}
 
 
 print wf "$comp\t";
 print wf "$acct\t";
 print wf "$org\t";
 print wf "$isp\t";
 print wf "$us\n";

 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
