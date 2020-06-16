#!/usr/bin/perl
#
# Loads asset link table
# run ./load-alinks.pl date(yymm)

$fdate = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear   = "20" . substr($fdate, 0, 2);
$yy      = substr($fdate, 0, 2);  
$table   = "tnetlogALINKS" . $yy;
$outfile = "tnetlogALINKS" . $yy . ".txt";
 
# date     acct      count       type       id       link
$infileT  = $fyear . "/" . "advAlink" . "-" . $fdate . ".txt";     
$infileN  = $fyear . "/" . "advAlinkNews" . "-" . $fdate . ".txt";     
  
# Delete from 
$query = "delete from thom$table where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
  
# Load Tnet files
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
open(rf, "$infileT")  || die (print "Could not open $infileT\n");
print "$infileT\n"; 
while (!eof(rf))
   {
    $instr = <rf>;
    chop($instr); 
    $instr =~ s/\\//g;  
    ($date, $acct, $cnt, $linktype, $linkid, $alink) = split(/\t/, $instr);
    $alink =~ s/^\s+//;
    $alink =~ s/\s+$//; 
    if($linkid ne "" && $alink eq "") { $alink = $linkid; $linkid = 0;  } # hack
    print wf "$fdate\t$acct\t$linktype\t$linkid\t$alink\t$cnt\ttnet\n"; 
    $acct = $linktype = $linkid = $alink = $cnt = "";
   }    
close(rf);  

# Load News files
open(rf, "$infileN")  || die (print "Could not open $infileN\n");
print "$infileN\n"; 
while (!eof(rf))
   {
    $instr = <rf>;
    chop($instr);
    $instr =~ s/\\//g;
    ($date, $acct, $cnt, $linktype, $linkid, $alink) = split(/\t/, $instr);
    $alink =~ s/^\s+//;
    $alink =~ s/\s+$//;
    if($linkid ne "" && $alink eq "") { $alink = $linkid; $linkid = 0;  }  # hack
    print wf "$fdate\t$acct\t$linktype\t$linkid\t$alink\t$cnt\tnews\n"; 
    $acct = $linktype = $linkid = $alink = $cnt = "";
   }  
close(rf); 
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile"); 
system("rm -f $outfile"); 

$rc = $dbh->disconnect;



=for comment
 
CREATE TABLE tnetlogALINKS{yy} (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  linktype varchar(20) NOT NULL default '',
  linkid int(11) NOT NULL default '0',
  alink varchar(70) NOT NULL default '',
  cnt int(11) NOT NULL default '0',
  org varchar(4) NOT NULL default '0',
  KEY date (date,acct,linkid,alink)
);

=cut


