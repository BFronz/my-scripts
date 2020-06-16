#!/usr/bin/perl
#

 
use DBI;
require "/usr/wt/trd-reload.ph";
 

           
# Get Webtraxs accounts
$query = "SELECT distinct(acct) FROM tgrams.webtraxs_accts  ";
#$query .= "WHERE acct=643553 "; $REPLACE=1;
$query .= " limit 10 ";

#$query ="select t.acct, m.acct from tgrams.webtraxs_accts as t left join webtraxs_cross as m on t.acct=m.acct where  m.acct is null and  t.acct>0"; $REPLACE=1;  
#$query = "select acct from thomwebtraxs_cross where visitor='Not connected for pphlogger data:'";   $REPLACE=1;  
#$query = "select * from webtraxs_cid where cid=30233712";   $REPLACE=1;  
#$query = "select acct from tgrams.webtraxs_accts where  acct=30233712 ";   $REPLACE=1;  # hack to run one acct
#$query = "select acct from tgrams.webtraxs_accts where  acct=423444 ";   $REPLACE=1;  # hack to run one acct
#$query = "select cid from  webtraxs_cid_do_over limit 1";   $REPLACE=1;
$query = "select acct from tgrams.webtraxs_accts where  acct=587988 ";   $REPLACE=1;  # hack to run one acct                
#$query = "select distinct acct from tgrams.webtraxs_accts  ";  

 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $acct[$i] = "$$row[0]";
 $i++;
 }
$sth->finish;

print "\nQ: $query\n\n";

$rc = $dbh->disconnect;
 
$outfile = "webtraxs_cross.txt"; 
$infile  = "webtraxs.txt"; 
$j = 1;  
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");            
foreach $acct (@acct)
 {
  print "$j)\t$acct\n";
     
  $url = "http://clients.web.com/CrossReport.php?acct=$acct";
  print "$url\n\n";
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



   
if($REPLACE eq 1) { system("mysqlimport -L thomas -r $DIR/webtraxs/$outfile"); }
else              { system("mysqlimport -L thomas -d $DIR/webtraxs/$outfile"); }
    
$rc = $dbh->disconnect;   

 
print "\n\nload-webtraxs1 completed...\n\n";
