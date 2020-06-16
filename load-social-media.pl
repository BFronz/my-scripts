#!/usr/bin/perl
# 
# Loads social media items
# run ./load-ad-views.pl YYMM

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
 
# at coverage 
$outfile  = "tnetlogSocialMedia.txt";
            
$file[0]  = "advSocMedViewCovMT_c";    # at cov        
$file[1]  = "advSocMedViewCovMT_n";    # at nat        
$file[2]  = "advSocMedViewCovMT_t";    # total 
        
# Delete from table          
$query = "delete from thomtnetlogSocialMedia where fdate='$fdate'";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   $infile    = $fyear . "/" . $file . "-" . $fdate . ".txt";
   print "$infile\n";
  
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      print wf "$instr\n"; 
    } 
   close(rf); 
 }
close(wf);
system("mysqlimport -L thomas $DIR/$outfile"); 
#system("rm -f $DIR/$outfile"); 


 
# at coverage  & heading
$outfile  = "tnetlogSocialMediaCat.txt";
            
$file[0]  = "advSocMedViewCatMT_c";    # at cov        
$file[1]  = "advSocMedViewCatMT_n";    # at nat        
$file[2]  = "advSocMedViewCatMT_t";    # total 
        
# Delete from table          
$query = "delete from thomtnetlogSocialMediaCat where fdate='$fdate'";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   $infile    = $fyear . "/" . $file . "-" . $fdate . ".txt";
   print "$infile\n";
  
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      print wf "$instr\n"; 
    } 
   close(rf); 
 }
close(wf);
system("mysqlimport -L  thomas $DIR/$outfile"); 
#system("rm -f $DIR/$outfile"); 
 
$rc = $dbh->disconnect;

exit;



