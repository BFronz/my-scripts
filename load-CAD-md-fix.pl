#!/usr/bin/perl
# 
# ARTU Fix
#
 
$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
$dbh   = DBI->connect("", "", "");
$fyear = "20" . substr($fdate, 0, 2);
$yy    =  substr($fdate, 0, 2);  

sub CleanFormat
{
  $val=$_[0]; 
  $val =~ s/&gt;/\>/gi;
  $val =~ s/&lt;/\</gi;
  $val =~ tr/a-z/A-Z/;
  return $val;
}
# Update tnetlogARTU{yy} table 
$tdl = 0;
$tem = 0;
$tins = 0;
$query  = "select acct, sum(downloads), sum(emails), sum(inserts) ";
$query .= "from tnetlogCADMAST$yy  where date='$fdate' group by acct";
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


 
