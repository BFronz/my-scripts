#!/usr/bin/perl
#
# Loads referer by heading used in prodhead rpt
# run ./load-refheadx.pl date(yymm)

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             

$outfile  = "tnetlogREFHDlog.txt";
$outfile2 = "tnetlogREFHD$yy.txt";
   
#$file[0] = "fi:cat1stIndRefs";           # First Ind Refs 
#$file[1] = "nw:catPNNRefs";              # PNN Refs
#$file[2] = "se:catSERefsTotal";          # Search Eng Refs
#$file[3] = "tr:catTRDRefs";              # TR Refs
#$file[0] = "nw:catPNNRefs";              # PNN Refs
$file[0] = "se:catSERefsTotal";          # Search Eng Refs

  
# Delete from tables
$query = "delete from thomtnetlogREFHDlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
          
$query = "delete from thomtnetlogREFHD$yy where date='$fdate'";
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
      ($d,$ct,$hd) = split(/\t/,$instr);
      #print wf "$instr\t$type\n"; 
      print wf "$d\t$hd\t$ct\t$type\n"; 
      $d = $ct = $hd = "";
    }    
   close(rf); 
 }
close(wf);
system("mysqlimport -diL thomas $DIR/$outfile"); 
system("rm -f $DIR/$outfile"); 
  

 
# Query and load summary table
$query  = " select date, heading, ";
$query .= " sum(if(type='fi',cnt,0)) as fi, ";   
$query .= " sum(if(type='nw',cnt,0)) as nw, ";   
$query .= " sum(if(type='se',cnt,0)) as se, ";   
$query .= " sum(if(type='tr',cnt,0)) as tr  ";   
$query .= " from thomtnetlogREFHDlog            ";
$query .= " where date='$fdate' and heading>0  ";
$query .= " group by heading";

open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $date    = $$row[0];   
  $heading = $$row[1];   
  $fi      = $$row[2];  
  $nw      = $$row[3];  
  $se      = $$row[4];  
  $tr      = $$row[5];      
  print wf "$date\t$heading\t$fi\t$nw\t$se\t$tr\t\n";
 } 
$sth->finish; 
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile2");
system("rm -f $DIR/$outfile2"); 


$rc = $dbh->disconnect;


exit;
