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

$outfile = "CompanyOrgs-Counts-" . $fdate . ".txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Account Name\t";                 
print wf "Account Number\t";               
print wf "Company/Org Visitors\n";  

$i=0;
$query  = "SELECT m.company, m.acct FROM tgrams.main AS m, thomtnetlogORGDAllM_test AS o WHERE m.acct=o.acct GROUP BY  m.acct  ORDER BY m.company ";
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

 $org="";
 $q  = "SELECT sum(cnt) FROM  thomtnetlogORGDAllM_test WHERE acct IN ($acctmap) ORDER BY org ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 { 
 	print wf "$comp\t";
 	print wf "$acct\t";
 	print wf "$$row[0]\n";
  
 } 
 $sth->finish; 


 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
