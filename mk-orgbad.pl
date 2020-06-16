#!/usr/bin/perl
#
# Makes bad org include file

$outfile  = "orgbad.inc"; 
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        
print wf "<?\n";


$outfile2  = "orgbad_alt.inc"; 
system("rm -f $outfile2");
open(wf2, ">$outfile2")  || die (print "Could not open $outfile2\n");        
print wf2 "<?\n";
   
use DBI;
$dbh = DBI->connect("", "", "");
   
$query = "select trim(org) as org from thomtnetlogORGflag where isp='Y' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $$row[0] =~ tr/A-Z/a-z/;
  print wf "\$isp\[\"$$row[0]\"\] = \"$$row[0]\";\n";
  print wf2 "\$ispp\[\"$$row[0]\"\] = \"$$row[0]\";\n";
  $i++; 
 }
$sth->finish;


$query = "select trim(org) as org from thomtnetlogORGflag where block='Y' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $$row[0] =~ tr/A-Z/a-z/;  
  print wf "\$block\[\"$$row[0]\"\] = \"$$row[0]\";\n";
  print wf "\$blockk\[\"$$row[0]\"\] = \"$$row[0]\";\n";
  $i++;  
 } 
$sth->finish;

  
print wf "?>\n"; 
print wf2 "?>\n"; 

close(wf);
close(wf2);
$rc = $dbh->disconnect;

  
#system("scp $outfile taurus:/www/tnetrpt/tnetrpt/inc");
#system("scp $outfile taurus:/www/tnetrpt/news/inc");

#system("scp $outfile2 taurus:/www/tnetrpt/tnetrpt/inc");
#system("scp $outfile2 taurus:/www/tnetrpt/news/inc");
   


#system("scp $outfile taurus:/www/tnetrpt/tnetrpt/inc");
#system("scp $outfile taurus:/www/tnetrpt/tgr/inc");
#system("scp $outfile taurus:/www/tnetrpt/news/inc");
  
print "\n\nRecords $i\n\n";
