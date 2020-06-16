#!/usr/bin/perl
#
# Run as ./load-inquiries.pl yymm file


if($ARGV[0] eq "" || $ARGV[1] eq "") 
 {print "\n\nMissing date(yymm) or file\n\n"; exit;}


sub CleanField {
 my $data=shift;
 $data =~ s/[[:punct:]]//g;
 $data	=~ s/√//g;
 $data	=~ s/‚Äì//g;
 $data	=~ s/‚Ñ¢//g;
 $data	=~ s/ì//g;
 $data	=~ s/‚Äú//g;
 $data	=~ s/î//g;
 $data	=~ s/‚Äù//g;
 $data	=~ s/ï//g;
 $data	=~ s/‚Ä¢//g;
 $data	=~ s/‚Äô//g;
 $data	=~ s/‚óè//g;
 $data	=~ s/¬//g;
 $data	=~ s/ \? //g;
 $data	=~ s/√±//g;
 $data	=~ s/√ß//g;
 $data	=~ s/'//g;
 $data	=~ s/<//g;
 $data	=~ s/>//g;
 $data	=~ s/ì//g;
 $data	=~ s/î//g;
 $data	=~ s/Ñ//g;
 $data	=~ s/ë//g;
 $data	=~ s/í//g;
 $data	=~ s/Ç//g;
 $data	=~ s/´//g;
 $data	=~ s/ª//g;
 $data	=~ s/ã//g;
 $data	=~ s/õ//g;
 $data	=~ s/ò//g;
 $data	=~ s/®//g;
 $data	=~ s/à//g;
 $data	=~ s/¥//g;
 $data	=~ s/∏//g;
 $data	=~ s/Ø//g;
 $data	=~ s/ñ//g;
 $data	=~ s/ó//g;
 $data	=~ s/Ö//g;
 $data	=~ s/ï//g;
 $data	=~ s/∑//g;
 $data	=~ s/∞//g;
 $data	=~ s/â//g;
 $data	=~ s/'//g;
 $data	=~ s/¢//g;
 $data	=~ s/£//g;
 $data	=~ s/§//g;
 $data	=~ s/•//g;
 $data	=~ s/Ä//g;
 $data	=~ s/É//g;
 $data	=~ s/ô//g;
 $data	=~ s/Æ//g;
 $data	=~ s/©//g;
 $data	=~ s/¿//g;
 $data	=~ s/¡//g;
 $data	=~ s/¬//g;
 $data	=~ s/√//g;
 $data	=~ s/ƒ//g;
 $data	=~ s/≈//g;
 $data	=~ s/∆"//g;
 $data	=~ s/«//g;
 $data	=~ s/»//g;
 $data	=~ s/…//g;
 $data	=~ s/ //g;
 $data	=~ s/À//g;
 $data	=~ s/Ã//g;
 $data	=~ s/Õ//g;
 $data	=~ s/Œ//g;
 $data	=~ s/œ//g;
 $data	=~ s/–//g;
 $data	=~ s/—//g;
 $data	=~ s/“//g;
 $data	=~ s/”//g;
 $data	=~ s/‘//g;
 $data	=~ s/’//g;
 $data	=~ s/÷//g;
 $data	=~ s/ÿ//g;
 $data	=~ s/Ÿ//g;
 $data	=~ s/⁄//g;
 $data	=~ s/å//g;
 $data	=~ s/ä//g;
 $data	=~ s/€//g;
 $data	=~ s/‹//g;
 $data	=~ s/›//g;
 $data	=~ s/ü//g;
 $data	=~ s/ﬁ//g;
 $data	=~ s/ﬂ//g;
 $data	=~ s/ø//g;
 $data	=~ s/°//g;
 $data	=~ s/Ü//g;
 $data	=~ s/á//g;
 $data	=~ s/∂//g;
 $data	=~ s/¶//g;
 $data	=~ s/ß//g;
 $data	=~ s/º//g;
 $data	=~ s/Ω//g;
 $data	=~ s/æ//g;
 $data	=~ s/π//g;
 $data	=~ s/≤//g;
 $data	=~ s/≥//g;
 $data	=~ s/™//g;
 $data	=~ s/∫//g;
 $data	=~ s/‡//g;
 $data	=~ s/·//g;
 $data	=~ s/‚//g;
 $data	=~ s/„//g;
 $data	=~ s/‰//g;
 $data	=~ s/Â//g;
 $data	=~ s/Ê//g;
 $data	=~ s/Á//g;
 $data	=~ s/Ë//g;
 $data	=~ s/È//g;
 $data	=~ s/Í//g;
 $data	=~ s/Î//g;
 $data	=~ s/Ï//g;
 $data	=~ s/Ì//g;
 $data	=~ s/Ó//g;
 $data	=~ s/Ô//g;
 $data	=~ s///g;
 $data	=~ s/Ò//g;
 $data	=~ s/Ú//g;
 $data	=~ s/Û//g;
 $data	=~ s/Ù//g;
 $data	=~ s/ı//g;
 $data	=~ s/ˆ//g;
 $data	=~ s/¯//g;
 $data	=~ s/ú//g;
 $data	=~ s/ö//g;
 $data	=~ s/˘//g;
 $data	=~ s/˙//g;
 $data	=~ s/˚//g;
 $data	=~ s/¸//g;
 $data	=~ s/˝//g;
 $data	=~ s/ˇ//g;
 $data	=~ s/˛//g;
 $data	=~ s/~//g;
 $data	=~ s/ò//g;
 $data	=~ s/±//g;
 $data	=~ s/◊//g;
 $data	=~ s/˜//g;
 $data	=~ s/ﬂ//g;
 $data	=~ s/µ//g;
 $data	=~ s/¨//g;
 $data	=~ s/µ//g;
 $data	=~ s/Û//g;
 $data	=~ s/·//g;
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

