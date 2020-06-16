#!/usr/bin/perl
#
# Loads webtraxs_cross table
# run as ./load-webtraxs.pl 
 
use DBI;
$dbh      = DBI->connect("dbi:mysql:thomas:localhost", "", "");
            
# Get bad Webtraxs accounts
$i = $j = 0;
$query = "select acct from thomwebtraxs_cross where visitor='Not connected for pphlogger data:'";   
$query = "select acct from thomwebtraxs_cross where visitor like '%pphlogger%'";   
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
  $cid = "$$row[0]";

  $subq = "select count(*) from thomwebtraxs_cross where acct='$cid' ";
  my $substh = $dbh->prepare($subq);
  if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  if  (my $subrow = $substh->fetchrow_arrayref)
   {  
    if( $$subrow[0] == 1) 
      { 
        $acct[$j] = $cid; 
        print "$j\t$acct[$j]\n";
        $j++; 
      }
   } 
  $substh->finish;
  
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
  #print "$url\n\n";
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
  sleep(1);
 } 
 
close(wf); 
   
system("mysqlimport thomas -r $outfile"); 
    
use DBI;
$dbh      = DBI->connect("dbi:mysql:thomas:localhost", "", "");
  
#$q = "update thomwebtraxs_cross set vid=md5(concat(acct,visitor,city,state,country)) where acct=10065781  ";
$q = "update thomwebtraxs_cross set vid=md5(concat(acct,visitor,city,state,country))  ";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
 
$rc = $dbh->disconnect;
 
print "\n\nDone...\n\n";
