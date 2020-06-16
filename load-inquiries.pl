#!/usr/bin/perl
#
# Run as ./load-inquiries.pl yymm file


if($ARGV[0] eq "" || $ARGV[1] eq "") 
 {print "\n\nMissing date(yymm) or file\n\n"; exit;}


sub CleanField {
 my $data=shift;
 $data =~ s/[[:punct:]]//g;
 $data	=~ s/�//g;
 $data	=~ s/–//g;
 $data	=~ s/™//g;
 $data	=~ s/�//g;
 $data	=~ s/“//g;
 $data	=~ s/�//g;
 $data	=~ s/”//g;
 $data	=~ s/�//g;
 $data	=~ s/•//g;
 $data	=~ s/’//g;
 $data	=~ s/●//g;
 $data	=~ s/�//g;
 $data	=~ s/ \? //g;
 $data	=~ s/ñ//g;
 $data	=~ s/ç//g;
 $data	=~ s/'//g;
 $data	=~ s/<//g;
 $data	=~ s/>//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/'//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�"//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/~//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 $data	=~ s/�//g;
 return $data;
}    

use DBI;
require "/usr/wt/trd-reload.ph";
 
$fdate   = $ARGV[0];
$infile  = $ARGV[1];
$yy      = substr($fdate, 0, 2);
$table   = "catnav_inquiries" . $yy;     
$outfile = $table . ".txt";
$clean   = "$clean.txt";
  
# Delete from table
#$query = "delete from $table where date = '$fdate' ";
$query = "delete from $table  where date = '$fdate'  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
  
open(wf, ">$clean")  || die (print "Could not open $clean\n");  
open(rf, "$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
 {
  $instr = <rf>;
  chop($instr);
    
  $instr =~ s/\n//g;  
  $instr =~ s/\^\|\^/\n/g; 
  $instr =~ s/\~\`~/\t/g; 
#  $instr = &CleanField($instr);
 
  print wf "$instr";
 }
close(rf);
close(wf);


open(wf, ">$outfile")  || die (print "Could not open $outfile\n");  
open(rf, "$clean")  || die (print "Could not open $clean\n");
while (!eof(rf))
 {
  $instr = <rf>;
  chop($instr);
     
  print wf "$fdate\t$instr\n";
 }
close(rf);
close(wf);



system("mysqlimport -iL thomas $outfile");

#system("rm -f $outfile");


exit;

