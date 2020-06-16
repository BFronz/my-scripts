#!/usr/bin/perl

$| = 1;
use DBI;

$infile = "position.txt";
$outfile = "pos.txt";
$outfilepf = "pop.txt";

open(RF, $infile) || die(print "Could not open input file $infile\n");
open(WF, ">$outfile") || die(print "Could not open input file $outfile\n");
open(PF, ">$outfilepf") || die(print "Could not open input file $outfilepf\n");

$i = 0;
$pos = 0;
$lastrec = "XX";
while (!eof(RF))
# while (!eof(RF) && $i < 50)
{ 

  $line = <RF>;
  $line =~ s/\s+$//;
  #print "$line\n";
 
  $i++;

  ($heading, $acct, $cov, $rank, $prem) = split(/\t/, $line);
  if ($rank !~ /^0+$/)
  {
    $pop=0; 
    $adv=1;
    #if ( ($cov eq "NAT" && $rank =~ /^90/)  || ($cov ne "NAT" && $rank =~ /^9002/) )
    if ( ($cov eq "NA" && $rank =~ /^90/)  || ($cov ne "NA" && $rank =~ /^9002/) )
     { $pop = substr($rank, 4, 6) + 0; }
  }
  else { $adv=0; $pop=0; }
  
  #if($cov eq "NAT") { $cov = "NA"; }

  $grp = $heading . $cov;
  if($grp ne $lastgrp)
  {
 
    $popline = "$p[1]\t$p[2]\t$p[3]\t$p[4]\t$p[5]\t$p[10]\t$p[15]\t$p[20]\t$p[25]";
    for ($j = 0; $j < @outlines; $j++) { print WF "$outlines[$j]\t$popline\n"; }
    print PF "$lasthd|$lastcov|$p[1]|$p[2]|$p[3]|$p[4]|$p[5]|$p[10]|$p[15]|$p[20]|$p[25]\n";
    $p[1] = $p[2] = $p[3] = $p[4] = $p[5] = $p[10] = $p[15] =$p[20] = $p[25] = 0;
    # undef(@p);
    undef(@outlines);
    $pos = 1;

  } 

  $rec = $heading . $acct . $cov;
  if($lastrec eq $rec) { next; }

  $p[$pos] = $pop;

  # write all records to the first file
  #print WF "$acct\t$heading\t$cov\t$pos\t$adv\t$pop\n";
  $outlines[@outlines] = "$acct\t$heading\t$cov\t$pos\t$adv\t$pop\t$prem";


  $lastrec = $rec;
  $lastgrp = $grp;
  $lasthd = $heading;
  $lastcov = $cov;

  $pos++;

  if ($i % 1000 == 0) { print "$i\r"; } 
}

print "$i\n";

close(RF);
close(WF);
close(PF);

