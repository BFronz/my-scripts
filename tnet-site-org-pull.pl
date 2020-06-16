#!/usr/bin/perl
#
#

use HTML::Entities;
use DBI;
$dbh      = DBI->connect("", "", "");

$rdate .= " '1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312' ";

$outfile  = "tnet-site-org-rpt-2013-new.txt"; 
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");      
    
$query  = "
 SELECT o.org, domain, count(*) AS n 

 FROM  tnetlogORGD13M AS o 
 LEFT JOIN tnetlogORGflagBLOCK ON o.org=orgblock 
 LEFT JOIN tnetlogORGflagExtra AS f ON o.org=f.org 

 WHERE date IN ('1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312') 
 AND (isp='N' && block='N') 
 AND ( orgblock IS null && f.org IS null )   

 GROUP BY org
 ORDER BY n DESC  
";  
 
print "\n$query\n"; #exit;
$i=0;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{    
 $$row[0]  =~ s/^\s+//;
 $$row[0]  =~ s/\s+$//; 
 $$row[0] = decode_entities($$row[0]);
 print "$i) $$row[0]\t$$row[1]\t$$row[2]\n";
 print wf "$$row[0]\t$$row[1]\t$$row[2]\n";
 $i++;
}      
$sth->finish;

close(wf);

$rc = $dbh->disconnect;

print "\n\nDone...\n\n";


=for comment
 CREATE TABLE `tnetlogORGD13M` (
  `date` varchar(4) NOT NULL default '',
  `acct` bigint(20) NOT NULL default '0',
  `org` varchar(125) NOT NULL default '',
  `domain` varchar(125) NOT NULL default '',
  `country` varchar(100) NOT NULL default '',
  `city` varchar(100) NOT NULL default '',
  `state` varchar(50) NOT NULL default '',
  `zip` varchar(12) NOT NULL default '',
  `cnt` bigint(20) NOT NULL default '0',
  `isp` char(1) NOT NULL default '',
  `block` char(1) NOT NULL default '',
  `orgid` varchar(32) NOT NULL default '',
  `oid` varchar(32) NOT NULL default '',
  `ip` varchar(39) NOT NULL default '',
  KEY `oid` (`oid`),
  KEY `date` (`date`,`acct`),
  KEY `acct` (`acct`),
  KEY `orgid` (`orgid`)
) TYPE=MRG_MyISAM INSERT_METHOD=LAST UNION=(tnetlogORGD13_01,tnetlogORGD13_02,tnetlogORGD13_03,tnetlogORGD13_04,tnetlogORGD13_05,tnetlogORGD13_06,
tnetlogORGD13_07,tnetlogORGD13_08,tnetlogORGD13_09,tnetlogORGD13_10,tnetlogORGD13_11,tnetlogORGD13_12) 

=cut 
