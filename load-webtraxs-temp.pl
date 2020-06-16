#!/usr/bin/perl
#
# Loads webtraxs_cross table
# run as ./load-webtraxs.pl 
 
use DBI;
$dbh      = DBI->connect("", "", "");
           
# Get Webtraxs accounts
$query = "SELECT * FROM thomwebtraxs_cid_alt";
#$query .= " limit 10 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $acct[$i] = "$$row[0]";
  print "$acct[$i]\n";
  $i++;
 }
$sth->finish;

$rc = $dbh->disconnect;

$outfile = "webtraxs_cross.txt"; 
$infile  = "webtraxs.txt"; 
$j = 1;  
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");            
foreach $acct (@acct)
 {
  print "$j)\t$acct\n";
     
  $url = "http://clients.web.com/CrossReport.php?acct=$acct";
  $cmd = "wget \"$url\" -O $infile ";
  system("$cmd");
  
  open(rf, "$infile")  || die (print "Could not open infile\n");
  while (!eof(rf))
   { 
    $line = <rf>;
    chop($line);
    $line =~ s/^\s+//;
    $line =~ s/\s+$//;

    #print "$line\n\n";
    if($line !~ /Database select failed/ ) { print wf "$acct\t$line\t\t0\t0\n"; }
   } 
  close(rf);

  system ("rm webtraxs.txt"); 
  $j++;
 } 
 
close(wf);
 
system("mysqlimport thomas  $outfile");

use DBI;
$dbh      = DBI->connect("", "", "");

$q = "update thomwebtraxs_cross set vid=md5(concat(acct,visitor,city,state,country))  ";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
 
$rc = $dbh->disconnect;
 
print "\n\nDone...\n\n";
