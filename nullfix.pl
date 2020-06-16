#!/usr/bin/perl
#
# removes null values and cleans up files
use utf8;

use DBI;
require "/usr/wt/trd-reload.ph";

$infile=$ARGV[0];

$infile =~ s/.txt//g;  
$infile =~ s/.csv//g;  

system("mv $ARGV[0] $infile");

open (rf, "$infile") || die (print "Could not open $infile"); 
  
$outfile = $ARGV[0];
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

while (!eof(rf))
{  
 $instr = <rf>;
 chop($instr);
 $instr =~ s/\000//g; 
 utf8::encode($instr); 

 $instr =~ s/\00fa//g; 
 $instr =~ s/\374//g; 
 $instr =~ s/\303\203//g; 
 $instr =~ s/\370//g; 
 $instr =~ s/0\370//g; 
 $instr =~ s/ú//g;
 $instr =~ s/\343//g;
 $instr  =~ s/\303\243/a/g;
 $instr  =~ s/\347\343/ca/g;

   
 print wf "$instr\n";  
 $i++;
} 

system("perl -p -i -e \"s/\r//g\" $outfile");

system("rm -f $infile");

close(wf);
close(rf); 


