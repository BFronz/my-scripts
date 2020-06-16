#!/usr/bin/perl
#
# 
# makes the category catalog views =  total catalog views if category catalog views >  total catalog views
       
$fdate = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to date YYMM\n\n"; exit;}
$yy    =  substr($fdate, 0, 2);       

use DBI;
require "/usr/wt/trd-reload.ph";

print "\n";
print "Processing: $fdate\n";
print "Companys with issues:\n";
 

$outfile = "checkcats.txt";       
open(wf, ">$outfile")  || die (print "Could not open $outfile\n"); 

$totaltable = "tnetlogARTU" . $yy;  
$cattable   = "qlog" . $yy . "Y";

$query  = "select company, m.acct, lc, pc ";
$query  .= "from thom$totaltable as t, tgrams.main as m ";
$query  .= "where m.acct=t.acct and date='$fdate' and covflag='t' and lc>0 and pc>0 order by company ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {     
   $subq  = "select sum(pc) as pc ";
   $subq  .= "from thom$cattable as u , headings_history as h ";
   $subq  .= "where acct=$$row[1] and u.heading=h.heading and date='$fdate' and covflag='t' ";
   my $substh = $dbh->prepare($subq);
   if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $subrow = $substh->fetchrow_arrayref)
    { 
      if($$subrow[0] > $$row[3]) 
       { 
        print  "$$row[0]\t$$subrow[0]\t>\t$$row[3]\n";
        print wf "update thom$totaltable set pc='$$subrow[0]' where acct='$$row[1]' and date='$fdate' and covflag='t' and pc='$$row[3]' ;\n"; 
       } 
    } 
   $substh->finish; 
 }
$sth->finish;

close(wf);

$rc = $dbh->disconnect;

exit;
 




