#!/usr/bin/perl
#
#  Updates  Product Catalog Pages Viewed (pc) in tnetlogARTU table  (where covflag = t)
#  based on numbers from the "catalog team's" file 
#  Make sure of spreadsheets field order 
#  Run as: ./load-catalog-extra.pl yymm file
    

$fdate  = $ARGV[0];
$infile = $ARGV[1];
if($fdate eq "" || $infile eq "") {print "\n\nForgot to add date yymm or file\n\n"; exit;}

$year    = substr($fdate, 0, 2);
$yy      = $year  ;
$year    = "20" . $year ;
$month   = substr($fdate, 2, 2);
$outfile = "load-catalog-extra-update.txt";   
system("rm -f $outfile");
$dt      = time();  
$backup  = "catnavlog" . $dt . ".bak";

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");  
 
    
# Load catalog data from the Catalog Group into a table. Need it for other things anyway 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$i=0;
open(rf, "$infile")  || die (print "Could not open $infile\n");
open(wf, ">catnavlog.txt")  || die (print "Could not open catnavlog.txt\n");
while (!eof(rf)) 
 {
   $instr = <rf>;
   chop($instr);
   print wf "$fdate\t$instr\n"; 
   $i++;
 }
close(rf);
close(wf);

# Delete 
$query = "delete from thomcatnavlog where date='$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

system ("mysqlimport -i thomas catnavlog.txt");


 
# Remove 0 account numbers
$query = "delete from thomcatnavlog where date='$fdate' and TGRAMSID=0 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 
# Get catalog accounts and update if necessary   
open(wf2, ">$backup")  || die (print "Could not open $backup\n"); # This is backup
$j=0;
$query = "select acct from tgrams.main where (premiums like '%O%' || premiums like '%V%' || premiums like '%T%' ||  premiums like '%U%' ) ";
#$query .= " and acct=588687 ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {    
     
  # Get tnet catalog views 
   $subq  = " select pc from thomtnetlogARTU$yy where covflag='t' and acct='$$row[0]' and date='$fdate' ";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $tnetpc  = $$srow[0];
    }
   $subr->finish;
 
  # Get catnav views 
   $subq  = " select sum(TotalPageViews) as totalviews from thomcatnavlog where TGRAMSID='$$row[0]' and date='$fdate' and IsActive='Yes' ";
   my $subr = $dbh->prepare($subq); 
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $catnavpc  = $$srow[0];
    }
   $subr->finish;

 
  # Get catalog views  at headings
   $qtable =  "qlog" . $yy . "Y";
   $subq  = " select sum(pc) as pc from $qtable as u , headings_history as h ";
   $subq .= "where acct='$$row[0]' and date='$fdate' and u.heading=h.heading  and covflag='t' ";
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    {
     $tnetpchd  = $$srow[0];
     if( ( $tnetpchd > $catnavpc ) && $catnavpc > 0) { $catnavpc = $tnetpchd;  $extraupdate=1;}
    }
   $subr->finish;

    
  # Sync all   
   $subq  = " update thomtnetlogARTU$yy set pc='$catnavpc' where acct='$$row[0]' and date='$fdate' and covflag='t' "; 
   print wf2 "update thomtnetlogARTU$yy set pc='$tnetpc' where acct='$$row[0]' and date='$fdate' and covflag='t'; \n";
   my $subr = $dbh->prepare($subq); 
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   $subr->finish;

  
   if($extraupdate eq 1)
   { 
    $subq  = "update thomcatnav_summmary$yy set totalpageviews='$catnavpc' ";
    $subq .= "where tgramsid='$$row[0]' and isactive='yes' and date='$fdate' ";
    print wf2 "$subq ;\n";
    my $subr = $dbh->prepare($subq); 
    if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }

    #reset avge page per ses
    $subq  = "update thomcatnav_summmary$yy set avgpagesperses= totalpageviews/totalses  ";
    $subq .= "where tgramsid='$$row[0]' and isactive='yes' and date='$fdate' ";
    print wf2 "$subq ;\n";
    my $subr = $dbh->prepare($subq); 
    if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }


    $subr->finish; 
   }
  

  $catnavpc = $tnetpc = $tnetpchd = $extraupdate = 0;
 }
$sth->finish; 

$rc = $dbh->disconnect; 
close(wf2); 
 

#print "\n\nTotal Updates: $j \n\n";

# Field Order:
# CNID
# TGRAMSID
# Company Short Name
# Is Active
# Is Ecommerce
# Date of Initial Publish
# Date of Quick Links Publish
# Total Sessions
# Total Page Views
# Total Item Detail Views
# Total Asset Downloads/Views
# Total Inquiries
# Total Printable Pages
# Total Email This Page
# Total Orders/RFQs
# % Sessions with Item Detail View
# % Sessions with Asset Download/View
# % Sessions with Inquiry
# % Sessions with Printable Page
# % Sessions with Email This Page
# % Sessions with Order/RFQ
# Average Pages per Session
# Average Session Duration (min)
# % Sessions with Client Site Referrer
# % Sessions with tnet Referrer
# % Sessions with Google Referrer
# % Sessions with Other Search Engine Referrer
# % Sessions with Other Referrer
# % Sessions Direct to Catalog
