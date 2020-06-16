#!/usr/bin/perl
#  
# Loads ad items
# run ./load-ad-views.pl YYMM infile adtype (pai or bad)

$fdate    = $ARGV[0]; 
$infile   = $ARGV[1]; 
$adtype   = $ARGV[2]; 
   
if($fdate eq "" || $infile eq "" || $adtype eq "") {print "\n\nForgot to add params\n\n"; exit;}

use DBI;
$dbh      = DBI->connect("", "", "");
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$outfile  = "tnetlogADviewsServer.txt";
                  
# Delete from table          
$query = "delete from tnetlogADviewsServer where fdate='$fdate' and adtype='$adtype' ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
   
open(rf, "$infile")  || die (print "Could not open $infile\n");
  while (!eof(rf))
   {
    $instr = <rf>;
    chop($instr);
    print wf "$fdate\t$instr\t$adtype\n"; 
   } 
  close(rf); 

close(wf);
system("mysqlimport  thomas $outfile"); 
#system("rm -f $outfile"); 
 
$rc = $dbh->disconnect;

exit;



