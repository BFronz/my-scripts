#!/usr/bin/perl
# 
# Loads ad clicks  items from IR
# run ./load-ad-views.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$outfile  = "tnetlogADviews.txt";
# tnetlogADviews table: fdate | acct   | cnt | covflag | adtype | action 
             
#$infile[0]  = "allAdClicks_t";                   
$infile  = "allAdClicks_t";                   
         
# Delete from table          
$query = "delete from thomtnetlogADviews where fdate='$fdate' and action ='C' ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");


$infile    = $fyear . "/" . $infile . "-" . $fdate . ".txt";
print "$infile\n";
  
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
{
 $instr = <rf>;
 chop($instr);
 # Ad Link gives clicks for "PreviewAds", "Ad Link Bold" gives clicks for "Company Display Ads".
 $instr =~ s/Ad Link Bold/da/g;
 $instr =~ s/Ad Link/pa/g;
 print wf "$instr\tC\n"; 
}    
close(rf); 
 
close(wf);
system("mysqlimport -L thomas $DIR/$outfile"); 
#system("rm -f $outfile"); 
 
$rc = $dbh->disconnect;

exit;



