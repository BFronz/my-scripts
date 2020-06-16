#!/usr/bin/perl
#
#

use HTML::Entities;
use DBI;
$dbh      = DBI->connect("", "", "");

$rdate .= " '1301','1302','1303','1304','1305','1306','1307','1308','1309','1310','1311','1312' ";

$outfile  = "news-site-org-rpt-2013-new.txt"; 
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");      
    
$query  = "
 SELECT o.org, domain, count(*) AS n 

 FROM  newsORGD13 AS o 
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
