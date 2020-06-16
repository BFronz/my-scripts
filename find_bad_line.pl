#!/usr/bin/perl
#
#

                
$infile = "INQUIRIES_06012008.txt";
$i=1;
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
 {
  $instr   = <rf>;
  $instr  =~ s/\\//g;
  if($i>94104 and $i<94106) {print "$i $instr\n"; }
  $i++;
 } 
close(rf);

 

