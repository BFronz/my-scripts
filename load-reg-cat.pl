#!/usr/bin/perl
#
# Loads registered user file by category
# run ./load-reg-cat.pl date(yymm)
# Note: tnetlogREGCAT table needs to be in tgrams to join on mt_proile
 
$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);             
$outfile  = "tnetlogREGCATlog.txt";
$outfile2 = "tnetlogREGCAT$yy.txt";

$file[0] = "pv:advCompProfViewRegCat";     
$file[1] = "pc:advProdCatalogViewRegCat";  
$file[2] = "ln:advSupLinkClickRegCat";     
$file[3] = "ec:advEMailColleagueRegCat";   
$file[4] = "mt:advMyThomasSavesRegCat";    

#$file[5] = "cl:advCadLinksRegCat";           
#$file[8] = "lc:advProdCatalogLinkRegCat";          
#$file[3] = "mi:advMoreInfoClickRegCat";    
#$file[4] = "ca:advContactAdvClickRegCat";   
 
# Delete from tables
$query = "delete from thomtnetlogREGCATlog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

$query = "delete from thomtnetlogREGCAT$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;


# Load file date into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   #$infile    = new . "/" . $f . "-" . $fdate . ".txt";
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
$query  = " select date, acct, tinid, heading, ";
$query .= " sum(if(type='pv',cnt,0)) as pv, "; 
$query .= " sum(if(type='pc',cnt,0)) as pc, "; 
$query .= " sum(if(type='ln',cnt,0)) as ln, "; 
$query .= " sum(if(type='mi',cnt,0)) as mi, "; 
$query .= " sum(if(type='ca',cnt,0)) as ca, "; 
$query .= " sum(if(type='ec',cnt,0)) as ec, "; 
$query .= " sum(if(type='mt',cnt,0)) as mt, "; 
$query .= " sum(if(type='cl',cnt,0)) as cl,  ";
$query .= " sum(if(type='lc',cnt,0)) as lc  ";
$query .= " from thomtnetlogREGCATlog ";
$query .= " where date='$fdate' and acct>0   ";
$query .= " group by heading, acct, tinid ";
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

CREATE TABLE tnetlogREGCATlog (
  date varchar(4) NOT NULL default '',
  acct  bigint(20) default '0' not null,
  cnt int(11) NOT NULL default '0',
  tinid varchar(32) NOT NULL default '',
  heading  bigint(20) default '0' not null,
  type char(2) NOT NULL default '',
  KEY date (date),
  KEY acct (acct),
  KEY heading(heading),
  KEY tinid (tinid),
  KEY type (type)
);

CREATE TABLE tnetlogREGCAT{yy} (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  tinid varchar(32) NOT NULL default '',
  heading bigint(20) NOT NULL default '0',
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
  KEY acct (acct),
  KEY heading (heading)
) TYPE=MyISAM;

=cut
