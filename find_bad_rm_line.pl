#!/usr/bin/perl
#
#

                 
$infile = "INQUIRIES_06012008.txt";
$outfile = "INQUIRIES_06012008A.txt";


$i=1;
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
 {
  $instr   = <rf>;
  $instr  =~ s/\\//g;
  chop($instr);
  if($i ne 94104 && $i ne 94105) {print wf "$instr\n"; }
  $i++;
 }  
close(rf);
close(wf);
print "$i\n";

 

