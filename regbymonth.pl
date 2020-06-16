#!/usr/bin/perl
#
#  reg by month report for tom marren

use DBI;
$dbh      = DBI->connect("dbi:mysql:tgrams:localhost", "", "");

 
$fdate = $ARGV[0];
if($fdate eq ""){print "\n\nMissing date YYMM\n\n"; exit;}
 
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$mm       =  substr($fdate, 2, 2); 
 
$outfile    = "regbymonth.txt";
system("rm -f $outfile");
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$i=0;                              
$query  = "select l.tinid,substring(from_unixtime(created),1,7), count(*) from  tnetlogREG$yy as l, mt_profile_history as m ";
$query .= "where  l.tinid=m.tinid and date='$fdate' group by l.tinid "; 
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {       
  print wf "$fdate\t$$row[0]\t$$row[1]\n";
  $i++; 
 }
$sth->finish;
print "\nTotal unique tinid's for $fdate: $i\n";  
close(wf);
system("mysqlimport tgrams -i $outfile");


$outfile    = "reg_by_month_report.csv";
system("rm -f $outfile");
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
print wf "Month,Active Users (w/conversion),Month of Registration\n";              
$query = "select date, mnth, count(*) as n from regbymonth group by date, mnth ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {        
  $y = substr($$row[0], 0, 2);
  $m = substr($$row[0], 2, 2);
  print wf "20$y-$m,$$row[2],$$row[1]\n";
  $i++; 
 }
$sth->finish;
close(wf);

system("scp $outfile orion:/www/tnetadmin/reports/");

$dbh->disconnect;
