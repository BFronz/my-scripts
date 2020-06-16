#!/usr/bin/perl
 

$outfile = "rahg.txt";

# Connect to mysql database
use DBI;
require "/usr/wt/trd-reload.ph";

open (OF, ">$outfile") || die(print "Could not open output file $outfile\n");
 
$query = "SELECT DISTINCT(heading) as hd";
$query .= " FROM tgrams.listings";
$query .= " WHERE left(rank,2)=90";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
$i = 0;
while (@data = $sth->fetchrow_array())
{
  $hd = $data[0];
  print OF "$hd\t$hd\t0\n";
  $pos = 0;

  $subq = "SELECT list2.heading, h.cnt_headin, count(DISTINCT list1.acct) AS ct";
  $subq .= " FROM tgrams.listings AS list1";
  $subq .= " LEFT JOIN tgrams.listings AS list2 ON list1.acct=list2.acct AND left(list2.rank, 2)=90 AND list1.heading!=list2.heading";
  $subq .= " LEFT JOIN tgrams.headings AS h ON list2.heading=h.heading";
  $subq .= " WHERE list1.heading=$hd AND left(list1.rank, 2)=90";
  $subq .= " GROUP BY list2.heading";
  $subq .= " HAVING count(DISTINCT list1.acct) > 1";
  $subq .= " ORDER BY ct DESC, h.cnt_headin DESC";
  my $subr = $dbh->prepare($subq);
  if (!$subr->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
  while (@row = $subr->fetchrow_array())
  {
    $relhd = $row[0]; $cnt = $row[1]; $ct = $row[2];
    $pos++;
    print OF "$hd\t$relhd\t$pos\n";
  }

  $i++;
  print "$i\r";
  #if ($i % 100 == 0) { print "$i\r"; }
}

close(OF);
$sth->finish;

print "Headings: $i\n";


system("mysqlimport -iL tgrams $DIR/rahg.txt");
