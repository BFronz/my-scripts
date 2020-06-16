#!/usr/bin/perl
#
# Loads webtraxs_cross table
# run as ./load-webtraxs.pl 

print "\n\nAdd list....\n\n";
exit;

use DBI;
$dbh      = DBI->connect("", "", "");
 
#$acct[0] =  "37885";    
#$acct[1] =  "39433";    
#$acct[2] =  "453024";   
#$acct[3] =  "569991";   
#$acct[4] =  "578582";   
#$acct[5] =  "585503";   
#$acct[6] =  "588687";   
#$acct[7] =  "1027098";  
#$acct[8] =  "1080186";  
#$acct[9] =  "1280986";  
#$acct[10] = "10019347"; 
#$acct[11] = "10029023"; 
#$acct[12] = "10029783"; 
#$acct[13] = "10051928"; 
#$acct[14] = "20047410"; 
 
$acct[0] =  "39433"; 
$acct[1] =  "1280986";
$acct[2] =  "10029783"; 

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

system("mysqlimport thomas $outfile");

$q = "update thomwebtraxs_cross set vid=md5(concat(acct,visitor,city,state,country)) where vid=''  ";
my $sth = $dbh->prepare($q);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;
 
$rc = $dbh->disconnect;

print "\n\nDone...\n\n";
