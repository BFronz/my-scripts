#!/usr/bin/perl
# 
# Loads CAD master & detail  data
# run ./load-CAD-mdx.pl date(yymm)

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  

sub CleanFormat
{
  $val=$_[0]; 
  $val =~ s/&gt;/\>/gi;
  $val =~ s/&lt;/\</gi;
  $val =~ tr/a-z/A-Z/;
  return $val;
}

$query = "select file_type, description  from thomCAD_file_type where file_type>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $c   = $$row[0];
  $d = $$row[1];
  $cft{$c} = $d;
  $c =~ tr/a-z/A-Z/;  
  $cft{$c} = $d; # uppercase version
  #print "$c\t$cft{$c}\n";
 }
$sth->finish;

# Load Detail file  tnetlogCADDET{yy}     
$query = "delete from thomtnetlogCADDET$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
          
#$infile   = $fyear . "/" . "advCADActionDetail-new" . "-" . $fdate . ".txt";
$infile   = "advCADActionDetail-new" . "-" . $fdate . ".txt";
$outfile  = "tnetlogCADDET" . $yy . ".txt";
$outfile2 = "tnetlogCADlog.txt"; 

open(wf, ">$outfile")   || die (print "Could not open $outfile\n");
open(wf2, ">$outfile2") || die (print "Could not open $outfile2\n");
open(rf, "$infile")     || die (print "Could not open $infile\n");
while (!eof(rf))
  {
   $instr = <rf>;
   chop($instr);
 
   ($date, $acct, $ipaddress, $action_date, $action_time, $action, $partnum, $partname, $partdes, $format, $tinid) = split(/\t/, $instr);   

   ($mon,$day,$year) =  split(/\//, $action_date);

   $recs++;     

   $sortdate = $year . $mon . $day;
     
   $format  = &CleanFormat($format);
   $nformat = $cft{$format};
   if($nformat eq "") {$nformat = $format;}             

   #else  {$nformat = "File Type Unknown";}             
   #if($format  eq ""  || $nformat eq "") {$nformat = "File Type Unknown";}             
   
   if($action eq "cad part email")       {$action = "email";}
   elsif($action eq "email")             {$action = "email";}
   elsif($action eq "E-mail")            {$action = "email";}
   elsif($action eq "cad part download") {$action = "download";}
   elsif($action eq "Download")          {$action = "download";}
   elsif($action eq "download")          {$action = "download";}
   elsif($action eq "cad part insert")   {$action = "insert";}
   elsif($action eq "insert")            {$action = "insert";}
   elsif($action eq "Insert")            {$action = "insert";}
   else {$action="skip";}
 
   if($partnum eq "" && $partdes eq "" && $partname eq "") {$action="skip";}
   #if($acct eq 106826) { print "$action\t|$partnum|\t|$partdes|\t|$partname|\n"; } 
  
   if($acct ne "" and $action ne "skip") 
    {
     print wf  "$fdate\t$acct\t$ipaddress\t$action_date\t$action_time\t$partnum\t$partdes\t$partname\t$tinid\t$nformat\t$action\t$sortdate\n";
     print wf2 "$fdate\t$acct\t$ipaddress\t$action\t$tinid\n"; 
     $frecs++;
   }	

   $nformat = $date = $acct = $ipaddress = $action_date = $action_time = $partnum = $partname = $tinid =  $partdes  = $format = $action = $sortdate = $mon = $day = $year = "";

  }
close(rf);
close(wf);

print "\nTotal Records: $recs Inserts: $frecs\n";



system("mysqlimport -iL thomas $DIR/$outfile"); 
system("mysqlimport -dL thomas $DIR/$outfile2"); 


# Load Master file into table tnetlogCADMAST{yy} from tnetlogCADlog
# Fields: date,acct,ipaddress,downloads, email,inserts 
 
$query = "delete from thomtnetlogCADMAST$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
  
$outfile = "tnetlogCADMAST" . $yy . ".txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n"); 
$query  = "select date, acct, ipaddress, ";
$query .= "sum(if(action='download',1,0)) as dl, sum(if(action='email',1,0)) as em, ";
$query .= "sum(if(action='insert',1,0)) as ins, tinid ";
$query .= "from thomtnetlogCADlog where date='$fdate' and acct>0  and action>'' ";
$query .= "group by acct, ipaddress, tinid  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $date = $$row[0];
  $acct = $$row[1];
  $ip   = $$row[2];
  $dl   = $$row[3];
  $em   = $$row[4];
  $ins  = $$row[5];
  $tid  = $$row[6];
  print wf "$date\t$acct\t$ip\t$dl\t$em\t$ins\t$tid\n";
 }

close(wf);
system("mysqlimport -iL thomas $DIR/$outfile"); 


# Update tnetlogARTU{yy} table 
$subq = " update thomtnetlogARTU$yy  set cd=0 where date='$fdate' "; 
my $substh = $dbh->prepare($subq);
if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); } 
$substh->finish;

$tdl = 0;
$tem = 0;
$tins = 0;
$query  = "select acct, sum(downloads), sum(emails), sum(inserts) ";
$query .= "from thomtnetlogCADMAST$yy  where date='$fdate' group by acct";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $acct = $$row[0];
  $dl   = $$row[1];
  $em   = $$row[2];
  $ins  = $$row[3];
  $tdl += $dl;
  $tem += $em;
  $tins +=  $ins; 
  
   $dlins = $dl + $ins;
   $subq = " update thomtnetlogARTU$yy  set cd=$dlins where acct=$acct and covflag='t' and date='$fdate' "; 
   my $substh = $dbh->prepare($subq);
   if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); } 
   $substh->finish;
   $dlins=0;
 } 
$sth->finish; 


# Update Site Table
$query = " update thomtnetlogSITEN set  caddown=$tdl, cadinsert=$tins, cademail=$tem where date='$fdate' ";
#print "$query\n";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$sth->finish;

$rc = $dbh->disconnect;



=for comment
 
CREATE TABLE tnetlogCADMASTN06 (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  ipaddress varchar(20) NOT NULL default '',
  downloads int(11) default NULL,
  emails int(11) default NULL,
  inserts int(11) default NULL,
  tinid varchar(32) NOT NULL default '',
  KEY date (date,acct,tinid)
) TYPE=MyISAM;

CREATE TABLE tnetlogCADDET{yy} (
  date        varchar(4) NOT NULL default '',
  acct        bigint(20) NOT NULL default '0',
  ipaddress   varchar(20) NOT NULL default '',
  action_date varchar(10) default NULL,
  action_time varchar(8) NOT NULL default '',
  partnum     varchar(255) default NULL,
  partdes     varchar(255) default NULL,          
  partname    varchar(255) default NULL,
  tinid       varchar(32) NOT NULL default '',  
  format      varchar(255) default NULL,
  action      varchar(8) default NULL,
  sortdate    varchar(10) NOT NULL default '',
  KEY date (date,acct),
  KEY tinid (tinid),          
  KEY action (action),
  KEY sortdate (sortdate),
  KEY action_time (action_time));
 
CREATE TABLE tnetlogCADlog (
  date varchar(4) NOT NULL default '',
  acct bigint(20) NOT NULL default '0',
  ipaddress varchar(20) NOT NULL default '',
  action varchar(8) NOT NULL default '',
  tinid varchar(32) NOT NULL default '',
  KEY date (date,acct,ipaddress,action,tinid)
) TYPE=MyISAM;

=cut


