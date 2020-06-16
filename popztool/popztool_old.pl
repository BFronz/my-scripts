#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

$outfile   = "position_popz.txt";
$rdate     = " '1601','1602','1603' ";
$rdate     = " '1604','1605','1606' ";
$rdate     = " '1607','1608','1609' ";
$rdate     = " '1610','1611','1612' ";
$rdate     = " '1701','1702','1703' ";

$rdate     = " '1703','1704','1705' ";
      
# load position_popz tables first  run popztoolload                                     

# open file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
     
# total supplier evaluation array
$i=0;
$query = "SELECT heading, us FROM thomposition_popz_se_total WHERE covflag='n' AND heading>0  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
  {
    $h = $$row[0];
    $u = $$row[1];
    $setotal{$h} = $u;
    $i++;
   }
$sth->finish;


# pull rank data       
$i=0;  
$query = "SELECT * FROM tgrams.position WHERE cov='NA' AND adv=1  ORDER BY heading, pos ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$acct     =  $$row[0]; 
	$heading  =  $$row[1]; 
	$cov      =  $$row[2]; 
	$pos      =  $$row[3]; 
	$adv      =  $$row[4]; 
	$pop      =  $$row[5]; 
	$premiums =  $$row[6]; 
	$p1       =  $$row[7]; 
	$p2       =  $$row[8]; 
	$p3       =  $$row[9]; 
	$p4       =  $$row[10];
	$p5       =  $$row[11];
	$p6       =  $$row[12];
	$p7       =  $$row[13];
	$p8       =  $$row[14];
	$p9       =  $$row[15];
	$p10      =  $$row[16];
	$p15      =  $$row[17];
	$p20      =  $$row[18];
	$p25      =  $$row[19];
      
	print "$i. $heading\n";

	if($cov eq 'NA') { $covflag = "n";  }
	else            { $covflag = $cov; }
        
	# pull se at acct & heading                          
	$subq    = "SELECT us AS se FROM thomposition_popz_se WHERE acct = '$acct'  AND heading='$heading'  AND covflag='$covflag'  ";
	my $ssth = $dbh->prepare($subq);
	if (!$ssth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $srow = $ssth->fetchrow_arrayref)
	{  
		$se = $$srow[0];
	}
 
	# check for total se
	if( $setotal{$heading} ne "")  {  $se_total = $setotal{$heading}; }
 	else                           {  $se_total = "0"; }		
 
	print wf "$acct\t$heading\t$cov\t$pos\t$adv\t$pop\t$premiums\t$p1\t$p2\t$p3\t$p4\t$p5\t$p6\t$p7\t$p8\t$p9\t$p10\t$p15\t$p20\t$p25\t$se\t$se_total\n"; 

	$acct = $heading = $cov = $pos = $adv = $pop = $premiums = $p1 = $p2 = $p3 = $p4 = $p5 = $p6 = $p7 = $p8 = $p9 = $p10 = $p15 = $p20 = $p25 = $se = $se_total = "";

	$i++;
}  
 
close(wf);
 
system("mysqlimport  -dL thomas  /usr/wt/$outfile");

$dbh->disconnect;

print "\nDone...\n";
 
