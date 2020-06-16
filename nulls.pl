#!/usr/bin/perl
#

$infile=$ARGV[0];
 

open (rf, "$infile") || die (print "Could not opne $infile"); 
  
$outfile = $infile . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

while (!eof(rf))
{  
 $instr = <rf>;
 chop($instr);
 @fld =  split("\t", $instr);

 $fld[2] =~ s/^\s+//;
 $fld[2] =~ s/\s+$//;

 #$fld[2] =~ s/\000//g; 
  
 $len = length($fld[2]); 
  
 print "field: $fld[2]\nlength: $len\n";

 undef(@fld);   
 $i++;
 if($i eq 100) {exit;}
} 

close(wf);
close(rf); 


