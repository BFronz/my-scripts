#!/usr/bin/perl
#  
# Loads ad views items from IR
# run ./load-ad-views.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$outfile  = "tnetlogADviews.txt";
# tnetlogADviews table: fdate | acct   | cnt | covflag | adtype | action 
             
$file[0]  = "pa:advPreviewAd_t";               # preview ads        
$file[1]  = "da:advCompProfileDisplayAd_t";    # company profile display ads        
$file[2]  = "tc:advTotalAdClicks_t";           # total ads 
        
# Delete from table          
$query = "delete from thomtnetlogADviews where fdate='$fdate' and action ='V' ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load 
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
      print wf "$instr\t$type\tV\n"; 
    } 
   close(rf); 
 }
close(wf);
system("mysqlimport -L thomas $DIR/$outfile"); 
#system("rm -f $DIR/$outfile"); 
 
$rc = $dbh->disconnect;

exit;



