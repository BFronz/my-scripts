#!/usr/bin/perl
# 
# Loads user engagement
# Run ./load-catnav-user-engage.pl YYMM file
  
if($ARGV[0] eq "" || $ARGV[1] eq "") {print "\n\nMissing date(yymm) or file\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
$infile  = $ARGV[1];
$yy      = substr($fdate, 0, 2);
$mm      =  substr($fdate, 2, 2);
 
$table   = "catnav_engagement" . $yy;
$outfile = "catnav_engagement" . $yy . ".txt";       
 
$query = "delete from thom$table where date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
            
# Load file 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
  
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
 
      ($cnid, $cid, $h1, $h2, $h3, $h4, $h5) = split(/\t/,$instr);
      if($cid ne 0  && $instr !~ /[^\x00-\x7e]/ ) { print wf "$fdate\t$cid\t$h1\t$h2\t$h3\t$h4\t$h5\n"; }
      $cid = $h1 = $h2 = $h3 = $h4 = $h5 = "";
   }  
close(rf); 
close(wf);
system("mysqlimport -iL thomas $DIR/catnav/$outfile");  
  
$sth->finish;

$rc = $dbh->disconnect;
 
print "\n\nDone...\n\n";
exit; 
