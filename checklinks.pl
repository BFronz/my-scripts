#!/usr/bin/perl
#
# checks to see is total links > that break out links


$fdate   = $ARGV[0];
if($ARGV[0] eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 
use DBI;
use POSIX;
$dbh = DBI->connect("dbi:mysql:tgrams:localhost", "", "");

# get accountsf from main table
$i=0;
$query  = "select company, acct from tgrams.main ";
$query .= "where adv>'' ";
#$query .= "and acct=34359 ";
#$query .= "and company like 'Sw%' ";
$query .= "order by company ";
#print "$query\n"; exit;
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i] = "$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

 
$outfile = "checklinks.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
$j=0;
foreach $record (@record)
{
  ($comp,$acct) = split(/\|/,$record); 
  #print "$j)\t$record\n";
  $totallinks = $brokenoutlinks = 0;     
 
  $query  = " select sum(ln) as ln from thomtnetlogARTU09 where acct='$acct' and date='$fdate' and covflag='t' ";
  #print "$query\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {
     $totallinks = "$$row[0]";
   }

  $query  = " select sum(linksweb) as linksweb from thomtnetlogPNN09 where acct='$acct' and date='$fdate' ";
  #print "$query\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   { 
     $totallinks += "$$row[0]";
   }

  $query  = " select sum(cnt) as n from thomtnetlogALINKS09 where acct='$acct'  and date='$fdate'";
  #print "$query\n";
  my $sth = $dbh->prepare($query);
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   {
     $brokenoutlinks = "$$row[0]";
   }
  
   if( $brokenoutlinks > $totallinks  ) 
   {
    print    "$j)\t$comp - $acct\t$totallinks\t$brokenoutlinks\n";
    $diff = $brokenoutlinks - $totallinks;
    print wf "$acct|$diff\n";
    $j++;
   }    


}

close(wf);
 

$dbh->disconnect;



=for comment
 

=cut
