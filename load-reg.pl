#!/usr/bin/perl
#
# Loads registered user file
# run ./load-reg.pl date(yymm)

use DBI; 
require "/usr/wt/trd-reload.ph";
  
$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);       
$outfile  = "tnetlogREGlog.txt";
$outfile2 = "tnetlogREG$yy.txt";
 
$file[0] = "pv:advCompProfViewReg";     
$file[1] = "pc:advProdCatalogViewReg";  
$file[2] = "ln:advSupLinkClickReg";     
$file[3] = "ec:advEMailColleagueReg";   
$file[4] = "mt:advMyThomasSavesReg";    
$file[5] = "cl:advCadLinksReg";         

#$file[7] = "lc:advProdCatalogLinkReg"; ///CHECK ON THIS FILE         
#$file[3] = "mi:advMoreInfoClickReg";    
#$file[4] = "ca:advContactAdvClickReg";  
 
# Delete from tables
$query = "delete from thomtnetlogREGlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$query = "delete from thomtnetlogREG$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;


# Load file date into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   #$infile    = "new" . "/" . $f . "-" . $fdate . ".txt";
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
system("mysqlimport -iL thomas $DIR/$outfile"); 
system("rm -f $DIR/$outfile2");



# Query log table and load summary table
$query  = " select date, acct, tinid,";
$query .= " sum(if(type='pv',cnt,0)) as pv, "; 
$query .= " sum(if(type='pc',cnt,0)) as pc, "; 
$query .= " sum(if(type='ln',cnt,0)) as ln, "; 
$query .= " sum(if(type='mi',cnt,0)) as mi, "; 
$query .= " sum(if(type='ca',cnt,0)) as ca, "; 
$query .= " sum(if(type='ec',cnt,0)) as ec, "; 
$query .= " sum(if(type='mt',cnt,0)) as mt, "; 
$query .= " sum(if(type='cl',cnt,0)) as cl,  "; 
$query .= " sum(if(type='lc',cnt,0)) as lc  "; 
$query .= " from thomtnetlogREGlog ";
$query .= " where date='$fdate' and acct>0   ";
$query .= " group by acct, tinid ";

open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $date   = $$row[0];  
  $acct   = $$row[1]; 
  $tinid  = $$row[2];
  $pv     = $$row[3]; 
  $pc     = $$row[4]; 
  $ln     = $$row[5]; 
  $mi     = $$row[6]; 
  $ca     = $$row[7]; 
  $ec     = $$row[8]; 
  $mt     = $$row[9]; 
  $cl     = $$row[10];
  $lc     = $$row[10];
  $cv=0; 
  $cd=0; 
  print wf "$date\t$acct\t$tinid\t$pv\t$pc\t$ln\t$mi\t$ca\t$ec\t$mt\t$cl\t$cv\t$cd\t$lc\n";
 }
$sth->finish;
close(wf);

system("mysqlimport -iL thomas $DIR/$outfile2");
#system("rm -f $DIR/$outfile2");
 


exit; 

=for comment

CREATE TABLE tnetlogREGlog (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  cnt int(11) NOT NULL default '0',
  tinid varchar(32) NOT NULL default '',
  type char(2) NOT NULL default '',
  KEY date (date),
  KEY acct (acct),
  KEY tinid (tinid),
  KEY type (type)
);
 
CREATE TABLE tnetlogREG{yy} (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  tinid varchar(32) NOT NULL default '',
  pv int(11) NOT NULL default '0',
  pc int(11) NOT NULL default '0',
  ln int(11) NOT NULL default '0',
  mi int(11) NOT NULL default '0',
  ca int(11) NOT NULL default '0',
  ec int(11) NOT NULL default '0',
  mt int(11) NOT NULL default '0',
  cl int(11) NOT NULL default '0',
  cv int(11) NOT NULL default '0',
  cd int(11) NOT NULL default '0',
  lc int(11) NOT NULL default '0',
  KEY date (date),
  KEY acct (acct)
) TYPE=MyISAM;

=cut
