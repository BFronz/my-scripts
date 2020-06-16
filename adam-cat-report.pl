#!/usr/bin/perl
#
#

use DBI;
require "/usr/wt/trd-reload.ph";

sub PrintQ
{
	$q = $_[0];
	#print "\n$q\n";
}

$outfile = "Category-Report-March-April.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
 
print wf "Category Name\t";
print wf "Category ID\t";
print wf "March Category Site User Sessions\t";
print wf "March Category Site Conversions\t";
print wf "March National User Sessions\t";
print wf "March National Conversions\t";
print wf "April Category Site User Sessions\t";
print wf "April Category Site Conversions\t";
print wf "April National User Sessions\t";
print wf "April National Conversions\n";
 
$i=0;
#$query  = "SELECT description, heading FROM tgrams.headings  ORDER BY description limit 1000";
$query  = "SELECT description, heading FROM tgrams.headings  ORDER BY description";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$record[$i]="$$row[0]\t$$row[1]";
	$i++;
}
$sth->finish;

$z=1;
foreach $record (@record)
{
	print "$z) $record\n";
	($desc,$hd) = split(/\t/,$record);

	$march_us_t  = $march_conv_t = $march_us_n = $march_conv_n  = $april_us_t =$april_conv_t = $april_us_n =$april_conv_n ="0";
      
	# March
	$q  = "select sum(us), sum(cd + cl + em + lw + pc + pv + lc + vv + dv + iv + sm + pp + mv) ";
	$q .= "from qlog17Y where heading=$hd and covflag='t' and date='1703'";
	my $sth = $dbh->prepare($q); 
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }	
	while (my $row = $sth->fetchrow_arrayref)
	{
		$march_us_t   = $$row[0];
		$march_conv_t = $$row[1];
	}
	$sth->finish;

	$q  = "select sum(us), sum(cd + cl + em + lw + pc + pv + lc + vv + dv + iv + sm + pp + mv) ";
	$q .= "from qlog17Y where heading=$hd and covflag='n' and date='1703'";
	my $sth = $dbh->prepare($q); 
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }	
	while (my $row = $sth->fetchrow_arrayref)
	{
		$march_us_n   = $$row[0];
		$march_conv_n = $$row[1];
	}
	$sth->finish;
 
	# April
	$q  = "select sum(us), sum(cd + cl + em + lw + pc + pv + lc + vv + dv + iv + sm + pp + mv) ";
	$q .= "from qlog17Y where heading=$hd and covflag='t' and date='1704'";
	my $sth = $dbh->prepare($q); 
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }	
	while (my $row = $sth->fetchrow_arrayref)
	{
		$april_us_t   = $$row[0];
		$april_conv_t = $$row[1];
	}
	$sth->finish; 
		            	 
	$q  = "select sum(us), sum(cd + cl + em + lw + pc + pv + lc + vv + dv + iv + sm + pp + mv) ";
	$q .= "from qlog17Y where heading=$hd and covflag='n' and date='1704'";
	my $sth = $dbh->prepare($q); 
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }	
	while (my $row = $sth->fetchrow_arrayref)
	{
		$april_us_n   = $$row[0];
		$april_conv_n = $$row[1];
	}
	$sth->finish;

	if($march_us_t    eq "") {$march_us_t   ="0";}
	if($march_conv_t  eq "") {$march_conv_t ="0";}
	if($march_us_n    eq "") {$march_us_n   ="0";}
	if($march_conv_n  eq "") {$march_conv_n ="0";}

	if($april_us_t    eq "") {$april_us_t   ="0";}
	if($april_conv_t  eq "") {$april_conv_t ="0";}
	if($april_us_n    eq "") {$april_us_n   ="0";}
	if($april_conv_n  eq "") {$april_conv_n ="0";}
 
	print wf "$desc\t";          # category name
	print wf "$hd\t";            # category id
  
	print wf "$march_us_t\t";    # March Category Site User Sessions
	print wf "$march_conv_t\t";  # March Category Site Conversions
	print wf "$march_us_n\t";    # March National User Sessions
	print wf "$march_conv_n\t";  # March National Conversions
 
	print wf "$april_us_t\t";    # April Category Site User Sessions
	print wf "$april_conv_t\t";  # April Category Site Conversions
	print wf "$april_us_n\t";    # April National User Sessions
	print wf "$april_conv_n\n";  # April National Conversions
    
	$z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
