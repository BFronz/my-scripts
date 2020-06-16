#!/usr/bin/perl
#
# Loads Product Search activity
# run ./load-PS-report.pl date(yymm)

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}


use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$outfile  = "tnetlogPSlog.txt";
$outfile2 = "tnetlogPS$yy.txt";

# Total Prod  Search Pages Viewed
$file[0]  = "psrch:advPSTotalProdSearchPagesViewed";

# Total Product Detail Views
$file[1]  = "pdetail:advPSTotalProductDetailViews";

# Total Browse Product Line Views
$file[2]  = "bprdln:advPSTotalBrowseProductLineViews";

# Total Browse All Product Views
$file[3]  = "ball:advPSTotalBrowseAllProductViews";

# Total Requests for Information
$file[4]  = "rfi:advTotalPSRequestsInfo";

# Total Catalog PDF Views
$file[5]  = "pdf:advTotalPSCatalogPDFViews";

# Total Links to Website
$file[6]  = "links:advTotalPSLinksWebsite";

# Total Profile Views
$file[7]  = "prof:advPSTotalProfileViews";

# Delete from tables
$query = "delete from thomtnetlogPSlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$query = "delete from thomtnetlogPS$yy where fdate='$fdate'";
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
      ($d,$a,$ct) = split(/\t/,$instr);
      print wf "$d\t$a\t$ct\t$type\n";
      $d = $a = $ct = "";
   }
   close(rf);
 }
close(wf);
system("mysqlimport -diL thomas $DIR/$outfile");
system("rm -f $DIR/$outfile");
 
# Query and load summary table
$query  = " select fdate, acct,      ";
$query .= " sum(if(type='psrch',cnt,0))   as psrch , ";
$query .= " sum(if(type='pdetail',cnt,0)) as pdetail , ";
$query .= " sum(if(type='bprdln',cnt,0))  as bprdln , ";
$query .= " sum(if(type='ball',cnt,0))    as ball , ";
$query .= " sum(if(type='rfi',cnt,0))     as rfi , ";
$query .= " sum(if(type='pdf',cnt,0))     as pdf , ";
$query .= " sum(if(type='links',cnt,0))   as links , ";
$query .= " sum(if(type='prof',cnt,0))    as prof  ";
$query .= " from thomtnetlogPSlog              ";
$query .= " where fdate='$fdate' and acct>0   ";
$query .= " group by acct";
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $date     = $$row[0];
  $acct     = $$row[1];          
  $psrch    = $$row[2];
  $pdetail  = $$row[3];
  $bprdln   = $$row[4];
  $ball     = $$row[5];
  $rfi      = $$row[6];
  $pdf      = $$row[7];
  $links    = $$row[8];
  $prof     = $$row[9];
  print wf "$date\t$acct\t$psrch\t$pdetail\t$bprdln\t$ball\t$rfi\t$pdf\t$links\t$prof\n";
 }
$sth->finish;
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile2");
system("rm -f $DIR/$outfile2");

print "\n\n";

 
#### PS Item Details
# PS Item Details
$infile  = "advPSProductDetailView";   # date, acct, count, PrdS_PROD_ID, PrdS_ITEM_Name, PrdS_ITEM_ID                
$outfile = "tnetlogPSDetail$yy.txt";          

# Delete from table          
$query = "delete from thomtnetlogPSDetail$yy where fdate='$fdate'";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

$infile    = $fyear . "/" . $infile . "-" . $fdate . ".txt";
print "$infile\n";
  
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
{
 $instr = <rf>;
 chop($instr);

 ($dt,$acct, $count, $PrdS_PROD_ID, $PrdS_ITEM_Name, $PrdS_ITEM_ID) = split(/\t/,$instr);

 $PrdS_PROD_ID = dirify($PrdS_PROD_ID);
 $PrdS_ITEM_Name = dirify($PrdS_ITEM_Name);
 $PrdS_ITEM_ID = dirify($PrdS_ITEM_ID);

 print wf "$fdate\t$acct\t$count\t$PrdS_PROD_ID\t$PrdS_ITEM_Name\t$PrdS_ITEM_ID\n";

}    
close(rf); 
 
close(wf);
system("mysqlimport -L thomas $DIR/$outfile"); 

$rc = $dbh->disconnect;

exit;

=for comment
  
CREATE TABLE tnetlogPSlog (
  fdate varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  cnt int(11) NOT NULL default '0',
  type varchar(7) NOT NULL default '',
  KEY fdate (fdate),
  KEY acct (acct),
  KEY type (type)
) TYPE=MyISAM;

CREATE TABLE tnetlogPS12 (
  fdate varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  psrch int(11) NOT NULL default '0',
  pdetail int(11) NOT NULL default '0',
  bprdln int(11) NOT NULL default '0',
  ball int(11) NOT NULL default '0',
  rfi int(11) NOT NULL default '0',
  pdf int(11) NOT NULL default '0',
  links int(11) NOT NULL default '0',
  prof int(11) NOT NULL default '0',
  KEY fdate (fdate, acct)
) TYPE=MyISAM;

=cut


