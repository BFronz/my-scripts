#!/usr/bin/perl
#
#

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
$dbh      = DBI->connect("", "", "");
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  
$outfile  = "flat_catnav_summmarylog.txt";
$outfile2 = "flat_catnav_summmary" . $fdate . ".txt";

# Summary   
$file[0]  = "avgpagesperses:CatFlatAvePagePerSession";  # Average Pages Viewed per Session  - date, acct, pgspervisit
$file[1]  = "avgsesdur:CatFlatAveSesDuration";          # Average Session Duration (min.)   - date, acct, avgminutes
$file[2]  = "totalsearchend:CatFlatUsersSearchEng";     # Total users from Search Engines - date, acct, cnt
    
# Delete from tables
$query = "delete from flat_catnav_summmarylog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
               
#$query = "update  flat_catnav_summmary$yy set  avgpagesperses=0, avgsesdur=0, totalsearchend=0 where date='$fdate'";
#my $sth = $dbh->prepare($query);
#if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
#$sth->finish;
 
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
 
      ($d,$a,$ct,$ex) = split(/\t/,$instr);
  
      print wf "$d\t$a\t$ct\t$type\n"; 
      $d = $a = $ct = $ex = ""; 
   } 
   close(rf); 
 }
close(wf);
system("mysqlimport -di thomas $outfile"); 
   
# Query and load summary table 
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");

$query  = " select acct, ";
$query .= " sum(if(type='avgpagesperses',cnt,0))           as    avgpagesperses            , ";
$query .= " sum(if(type='avgsesdur',cnt,0))                as    avgsesdur                 , ";
$query .= " sum(if(type='totalsearchend',cnt,0))           as    totalsearchend              ";
$query .= " from flat_catnav_summmarylog       ";
$query .= " where date='$fdate' and acct>0  ";
$query .= " group by acct ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
 $acct                      = $$row[0]; 
 $avgpagesperses           = $$row[1]; 
 $avgsesdur                = $$row[2]; 
 $totalsearchend           = $$row[3]; 
 #print wf  "update  flat_catnav_summmary$yy set  avgpagesperses='$avgpagesperses', avgsesdur='$avgsesdur', totalsearchend='$totalsearchend' ";
 #print wf  " where date='$fdate' and tgramsid ='$acct' ;\n";
                                            
 print wf  "update  catnav_summmary$yy ";
 print wf  "set avgpagesperses = avgpagesperses + '$avgpagesperses', avgsesdur = avgsesdur + '$avgsesdur', totalsearchend = totalsearchend + '$totalsearchend' ";
 print wf  " where date='$fdate' and tgramsid ='$acct' ;\n";
 }   
$sth->finish; 
close(wf);

print "\n"; 
print "Check and make update mysql thomas < $outfile2 "; 
print "\n"; 

$rc = $dbh->disconnect;



