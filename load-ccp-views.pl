#!/usr/bin/perl
# 
# Loads ccp profile items
# run ./load-ccp-views.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$outfile  = "tnetlogCCPViews$yy.txt";
          
$file[0]  = "vv:advVideofViewCCpid_t";   # videos viewed        
$file[1]  = "iv:advImgViewCCPid_t";      # images viewed         
$file[2]  = "dv:advDocfViewCCPid_t";     # documents viewed
        
# Delete from table          
$query = "delete from thomtnetlogCCPViews$yy where fdate='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";
  
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      print wf "$instr\t$type\n"; 
    } 
   close(rf); 
 }
close(wf);
system("mysqlimport  -L thomas $DIR/$outfile"); 
#system("rm -f $outfile"); 
 
$rc = $dbh->disconnect;

exit;



