#!/usr/bin/perl
#
 
use DBI;
$dbh      = DBI->connect("", "", "");

           
# Get Webtraxs accounts
$query = "SELECT * FROM thomwebtraxs_cid where cid=30463548 ";
#$query .= " limit 10 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $acct[$i] = "$$row[0]";
  $i++;
 }
$sth->finish;

$query = "delete from thomwebtraxs_cross where acct=30463548 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

 
$rc = $dbh->disconnect;


$outfile = "webtraxs_cross.txt"; 
$infile  = "webtraxs.txt"; 
$j = 1;  
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");            
foreach $acctno (@acct)
 {
  print "$j)\t$acctno\n";      
  $url = "http://clients.web.com/CrossReport.php?acct=$acctno";
  $url = "http://clients.web.com/CrossReport-News.php?acct=$acctno";
 
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
    if($line !~ /Database select failed/ ) { print wf "$acctno\t$line\t\t0\t0\n"; }
   } 
  close(rf);

  system ("rm webtraxs.txt"); 
  $j++;
  sleep(1);
 } 
 
close(wf);
 
system("mysqlimport thomas -r $outfile");
 
use DBI;
$dbh      = DBI->connect("", "", "");
  
  
$q = "update thomwebtraxs_cross set vid=md5(concat(acct,visitor,city,state,country)) where acct=30463548 ";
print "\n$q\n\n";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
 
$rc = $dbh->disconnect;
 
print "\n\nDone...\n\n";
