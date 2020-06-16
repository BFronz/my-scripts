#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
 
$position_table = "thomposition16Q4";  # 1612, 1701
$position_table = "thomposition17Q1"; # 1702, 1703, 1704
#$position_table = "thomposition17Q2"; # 1705
$position_table = "tgrams.position";     # 1706
    
$cov     = 'NA';
$covflag = 'n';


print "\n$position_table\t $fdate\n";

# open file
$outfile   = "position_popz_se_pos.txt";
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
      
# delete from tables
$query = "DELETE FROM thomposition_popz_se_pos WHERE date='$fdate' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# pull data        
$i=0;     
#$query = "SELECT acct,heading, pos, cov FROM $position_table WHERE cov='$cov'  ORDER BY heading, pos  ";
$query = "SELECT acct,heading, pos, cov FROM $position_table WHERE cov='$cov' AND pop>0  ORDER BY heading, pos  ";
$query = "SELECT acct, heading, pos, cov FROM $position_table WHERE cov='$cov' AND adv=1  ORDER BY heading, pos  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$acct     =  $$row[0]; 
	$heading  =  $$row[1]; 
	$pos      =  $$row[2]; 
	$cov      =  $$row[3]; 
       
	print "$i. $heading\n";
         
	# pull se at acct & heading                          
	$subq  = "SELECT us AS se FROM thomqlogY WHERE date='$fdate' AND acct='$acct' AND heading='$heading' AND covflag='$covflag'  ";
	#print "$subq\n";	 
	my $ssth = $dbh->prepare($subq);
	if (!$ssth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $srow = $ssth->fetchrow_arrayref)
	{  
		$se = $$srow[0];
	}
   
	if($se eq "")     {  $se = "0"; }
 
	print wf "$fdate\t$heading\t$pos\t$cov\t$se\n";
 
	$acct = $heading = $pos = $se = 0;

	$i++;
}  
 
close(wf);
 
system("mysqlimport  -L thomas  $outfile");

$dbh->disconnect;

print "\nDone...\n";
 
