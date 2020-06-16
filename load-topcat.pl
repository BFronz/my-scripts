#!/usr/bin/perl
#
# Loads top category table
# run ./load-topcatx.pl date(yymm)

$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$outfile  = "topcategories.txt";
    
$file[0]  = "topCategories"; 
  
# Delete from table          
$query = "delete from thomtopcategories where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;


# Load files into table
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";

   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    { 
      $instr = <rf>;
      chop($instr);
      ($dt,$cnt,$hd) = split(/\t/, $instr);
      print wf "$dt\t$hd\t$cnt\n";
      $dt = $cnt = $hd = "";
    }
   close(rf); 
 }
close(wf);
system("mysqlimport -iL thomas $DIR/$outfile"); 
system("rm -f $DIR/$outfile"); 
  

exit;

=for comment
 
CREATE TABLE topcategories (               
  date varchar(4) NOT NULL default '',  
  heading bigint(20) NOT NULL default '0', 
  cnt int(11) NOT NULL default '0',        
  PRIMARY KEY  (date,heading)           
);                                         


=cut


