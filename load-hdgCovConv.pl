#!/usr/bin/perl
#
# loads tnetloghdgCovConv table
# run as ./load-hdgCovConv.pl YYMM  

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 


use DBI;
require "/usr/wt/trd-reload.ph";

$fyear   = "20" . substr($fdate, 0, 2);
$yy      =  substr($fdate, 0, 2);             
$outfile = "tnetloghdgCovConv$yy.txt";
$infile  = "hdgCovConv-" . $fdate . ".txt";     
   
# Delete from table
$query = "delete from thomtnetloghdgCovConv$yy where date='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
 

# Load file date into  file and import
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
 
open(rf, "$fyear/$infile")  || die (print "Could not open $infile\n");
while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
      print wf "$instr\n";
    }
close(rf); 
close(wf);
system("mysqlimport -iL thomas $DIR/$outfile"); 
 
 


exit; 

=for comment

 <row cov='NA' v='288' hdg='0' conversions='393' convertedvisits='75' />

 CREATE TABLE tnetloghdgCovConv15 (
  date             varchar(4) NOT NULL DEFAULT '',
  cnt              int(11)    NOT NULL DEFAULT '0', 
  conversions      int(11)    NOT NULL DEFAULT '0',
  convertedvisits  int(11)    NOT NULL DEFAULT '0',
  heading          bigint(20) NOT NULL DEFAULT '0',  
  cov              char(2)    NOT NULL DEFAULT '', 
  KEY date (date, cov),                      
  KEY acct (cov)                                       
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ; 

=cut
