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

$outfile = "calltracking-2016-new-2.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
  
print wf "Account Numbmer\t";                     
print wf "Account Name\t";                   
print wf "Total CT Calls\t";
print wf "CT Sales Inquiries\t";
print wf "CT Solicitations\t";
print wf "CT Other\n";
  
$i=0; 
$query = "SELECT c.acct, company
 FROM thomcalltracking AS c, tgrams.main AS m 
 WHERE c.acct=m.acct
 AND  date IN ('1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612')
 AND  (callername not like '%industrial quick%' && callername not like '%INDUSTRIAL QUICK SEARCH%' )
 AND  callresult NOT IN (2,3,4)
 GROUP BY c.acct 
 ORDER BY company ";
# $query  .= "LIMIT 100 "; # for testing 
#  AND  callresult not in (2,3,4)
#print "$query\n";
PrintQ($query);
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
{
	($acct, $comp) = split(/\|/,$record);
 
        $acctmap = "0";
	$q = "SELECT dupe FROM tgrams.main_map WHERE prime='$acct' ";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
	{
		$acctmap = "$$row[0],";
	}
	$sth->finish;
	$acctmap .= $acct;

	# WHEN typeid=10 THEN 'Sales Inquiry'            
	# WHEN typeid=20 THEN 'Solicitation'             
	# WHEN typeid=30 THEN 'Robocall'                 
	# WHEN (typeid=99 || typeid=40) THEN 'Other'     
 
  
	$tot = $inq = $sol = $other ="0"; 
	$q = "	SELECT 
		SUM(if(typeid=10,1,0)), 
		SUM(if(typeid=20,1,0)), 
		SUM(if((typeid=99 || typeid=40),1,0))
		FROM thomcalltracking AS c LEFT JOIN tgrams.cs_calls AS s ON c.acct=s.acct AND c.filename=s.filename 
		WHERE c.acct in ($acctmap) 
		AND (callername NOT LIKE '%industrial quick%' && callername NOT LIKE '%INDUSTRIAL QUICK SEARCH%') 
		AND date IN ('1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612')
		AND  callresult NOT IN (2,3,4)  ";
	PrintQ($q);   
	my $sth = $dbh->prepare($q);	
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 	while (my $row = $sth->fetchrow_arrayref)
	{
		$inq   = $$row[0];
		$sol   = $$row[1];	 	
		$other = $$row[2];
	}
	$sth->finish; 
 
	if($inq eq "")   {$inq = "0";}
	if($sol eq "")   {$sol = "0";}
	if($other eq "") {$other = "0";}
 
	$tot = $inq + $sol + $other;


	#if($tot eq "0")
	#{ 
		$q = "	SELECT count(*) 
		FROM thomcalltracking
		WHERE acct in ($acctmap) 
		AND (callername NOT LIKE '%industrial quick%' && callername NOT LIKE '%INDUSTRIAL QUICK SEARCH%') 
		AND date IN ('1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612')
		AND  callresult NOT IN (2,3,4)  ";
 
		$q = "	SELECT count(*) 
		FROM thomcalltracking
		WHERE acct in ($acctmap) 
		AND (callername NOT LIKE '%industrial quick%' && callername NOT LIKE '%INDUSTRIAL QUICK SEARCH%') 
		AND date IN ('1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612') ";
		my $sth = $dbh->prepare($q);	
		if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 		while (my $row = $sth->fetchrow_arrayref)
		{ 
			$tot   = $$row[0];
		}
		$sth->finish; 
	#}

   
	print wf "$acct\t";
	print wf "$comp\t";
        print wf "$tot\t";
	print wf "$inq\t";
	print wf "$sol\t";
	print wf "$other\t";
	print wf "\n"; 
  
	print "$z) $record\t$tot\t$inq\t$sol\t$other\n";
	print "------------------------------------------------------------------------\n";
	$z++;
}

close(wf);
  
$dbh->disconnect;
 
print "\n\nDone...\n\n";
