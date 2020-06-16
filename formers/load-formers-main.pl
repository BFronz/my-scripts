#!/usr/bin/perl
#
# Load formers_main table 
 
use DBI;
use POSIX;
#use Switch;
require "/usr/wt/trd-reload.ph";
$unixtime = time();
$adv = "";

$mon{"Jan"}="01";
$mon{"Feb"}="02";
$mon{"Mar"}="03";
$mon{"Apr"}="04";
$mon{"May"}="05";
$mon{"Jun"}="06";
$mon{"Jul"}="07";
$mon{"Aug"}="08";
$mon{"Sep"}="09";
$mon{"Oct"}="10";
$mon{"Nov"}="11";
$mon{"Dec"}="12";

$outfile = "formers_main.txt"; 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");    

# 0 acct
# 1 company
# 2 city
# 3 state
# 4 zip
# 5 seniorid
# 6 salesman
# 7 territory
# 8 prodgrp
# 9 start
# 10 end
# 11 startdate
# 12 enddate
# lastm
# lastmod
# adv
# convb
# conva
# convp  
$query  = "select a.acct, a.company, m.city, m.state, m.zip, a.seniorid, a.salesman, a.territory, a.prodgrp, a.start, ";
$query  .= "a.end, a.startdate, a.enddate   ";
$query  .= "from tgrams.adunits_sum as a, tgrams.main as m   ";
$query  .= "where  a.acct=m.acct and a.active='N' and a.adv='' and a.prodgrp='TRINET' and a.rectype='CT' ";
$query  .= "group by a.acct  ";
#$query  .= "limit 10 ";
#print "\n\n$query\n\n";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  $month = $yy = $lastq = "";         

  $month = substr($$row[10], 3, 3);
  $yy    = abs(substr($$row[10], 7, 2));
  $lastm = $yy . $mon{$month};

  print wf "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t";
  print wf "$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t$$row[11]\t$$row[12]\t";
  print wf "$lastm\t0\t$adv\t0\t0\t0\n";
 }  
$sth->finish;

close(wf);
  
system("mysqlimport -iL thomas $DIR/formers/$outfile");
 
$dbh->disconnect;


=for comment
CREATE TABLE formers_main (
  acct bigint(20) NOT NULL default '0',
  company varchar(130) NOT NULL default '',
  city varchar(50) default NULL,
  state char(2) NOT NULL default '',
  zip varchar(6) default NULL,
  seniorid varchar(4) NOT NULL default '',
  salesman varchar(4) NOT NULL default '',
  territory char(2) NOT NULL default '',
  prodgrp varchar(8) NOT NULL default '',
  start varchar(10) NOT NULL default '',
  end varchar(10) NOT NULL default '',
  startdate int(11) NOT NULL default '0',
  enddate int(11) NOT NULL default '0',
  lastm int(11) NOT NULL default '0',
  lastmod int(11) NOT NULL default '0',
  adv char(1) NOT NULL default '',
  convb int(11) NOT NULL default '0',
  conva int(11) NOT NULL default '0',
  PRIMARY KEY  (acct,prodgrp),
  KEY lastm (lastm)
) TYPE=MyISAM;
=cut  


