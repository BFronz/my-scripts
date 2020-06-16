#!/usr/bin/perl
# 
# Loads pnn data views, email comp, email story
# run ./load-PNN.pl date

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             
$outfile  = "tnetlogPNNlog.txt";
$outfile2 = "tnetlogPNN$yy.txt";
     
$file[0]  = "pv:advNewsFullStoryViews";     # pages Viewed        
$file[1]  = "pr:advPressReleaseViews";      # press Viewed         
$file[2]  = "lw:advSupplierLinkClicksNews"; # links
  
#$file[1]  = "es:advNewsEmailStory";         # email story 
#$file[3]  = "ec:advNewsEmailCompany";       # email comp   
#$file[3]  = "ec:advNewsEmailCompanyB";       # using news/cmg file

#advNewsCompanyStoryViews
#advPRIDViews

#advNewsEmailStory
#advPRIDEmailStory

#advNewsEmailCompany
#advPRIDEmailCompany

#advNewsWebLinks
#advPRIDWebLinks
   
# Delete from tables
$query = "delete from thomtnetlogPNNlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
          
$query = "delete from thomtnetlogPNN$yy where date='$fdate'";
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
system("mysqlimport -diL thomas $DIR/$outfile"); 
#system("rm -f $outfile"); 
 


# Query and load summary table
$query  = " select date, acct,      ";
$query .= " sum(if(type='pv',cnt,0)) as pv, ";   
$query .= " sum(if(type='ec',cnt,0)) as ec, ";   
$query .= " sum(if(type='es',cnt,0)) as es, ";   
$query .= " sum(if(type='pr',cnt,0)) as pr, ";   
$query .= " sum(if(type='lw',cnt,0)) as lw ";   
$query .= " from thomtnetlogPNNlog              ";
#$query .= " where date='$fdate' and acct>0  "; # need negative numbers
$query .= " where date='$fdate'";
$query .= " group by acct ";
  
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $date   = $$row[0];   
  $acct   = $$row[1];   
  $pv     = $$row[2];   
  $ec     = $$row[3];   
  $es     = $$row[4];   
  $pr     = $$row[5];   
  $lw     = $$row[6];   
  print wf "$date\t$acct\t$pv\t$ec\t$es\t$pr\t$lw\n";
 }
$sth->finish;
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile2");
#system("rm -f $outfile2"); 
 

$rc = $dbh->disconnect;

exit;



