#!/usr/bin/perl
# 
# loads company merge table, main_map with file from thomcomp


$infile   = $ARGV[0]; 
if($infile eq "") {print "\n\nForgot File\n\n"; exit;}
open(rf, "$infile")  || die (print "Could not open $infile\n");
   
$outfile  = "main_map.txt";
system("rm -f $outfile"); 
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
       
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);       
      ($no,$prime,$dupe,$date,$extra) = split(/\t/,$instr);
      $date = substr($date, 0, 8);
      #print  "$no\t$prime\t$dupe\t$date\t$extra\n";
      print wf "$dupe\t$prime\t$date\n";
    }  
close(rf);
close(wf);

system("mysqlimport -i tgrams $outfile"); 

exit;

=for comment

CREATE TABLE main_map (
  dupe bigint(20) NOT NULL default '0',
  prime bigint(20) NOT NULL default '0',
  date varchar(20) NOT NULL default '',
  PRIMARY KEY  (prime,dupe),
  KEY prime (prime)
) TYPE=MyISAM;

=cut


