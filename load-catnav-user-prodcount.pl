#!/usr/bin/perl
# 
# Loads user prodlines
# Run ./load-catnav-user-prodcount.pl YYMM file
  
if($ARGV[0] eq "" || $ARGV[1] eq "") {print "\n\nMissing date(yymm) or file\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
$infile  = $ARGV[1];
$yy      = substr($fdate, 0, 2);
$mm      = substr($fdate, 2, 2);
 
$table   = "catnav_lines" . $yy;
$outfile = "catnav_lines" . $yy . ".txt";       
 
$query = "delete from thom$table where date='$fdate' ";
print "$query\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
            
# Load file 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
  
$j=1;
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);      
      print "$j \t$instr\n";
      ($cnid, $cid, $prod, $freq) = split(/\t/,$instr);
      $prod =~ s/\"([^"]*)\"/$1/m;
      $prod  =~ s/\"(.*?)\"/$1/m;
      if($cid ne 0) { print wf "$fdate\t$cid\t$freq\t$prod\n"; }
      $cid = $prod = $freq = "";
      $j++;	
   } 
close(rf); 
close(wf);
system("mysqlimport -iL thomas $DIR/catnav/$outfile"); 
 
  
$sth->finish;

   
$rc = $dbh->disconnect;
 
print "\n\nDone...\n\n";
exit; 
