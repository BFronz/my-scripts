#!/usr/bin/perl
#
#
 
use DBI;
 
# charon data
require "/usr/wt/trd-reload.ph";

sub PrintQ 
{
	$q = $_[0];
	#print "\n$q\n";
} 
                      
$fdate = "1610";  
$yy    =  substr($fdate, 0, 2);
 
$outfile = "reg-visitor-" .  $fdate . ".txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
  
print wf "Account Number\t";
print wf "Account Name\t";
print wf "Total Co/Orgs (unique name & geo)\t";
print wf "Total Starred Reg Users (unique name & geo)\n";

$i=0; 
$query  = "SELECT company, acct, adv FROM tgrams.main WHERE adv>'' and acct>0  ";
#$query  .= "AND acct='30452968' "; # for testing
$query  .= "ORDER BY company ";
#$query  .= "LIMIT 10 "; # for testing
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$record[$i]="$$row[0]\t$$row[1]\t$$row[2]";
	$i++;
}
$sth->finish;

$z=1;
foreach $record (@record)
{
	print "$z) $record\n"; 
	($comp,$acct,$adv) = split(/\t/,$record);

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
  
	# org data
	$query  =  "select count(distinct(concat(org,city,state,zip))) from thomtnetlogORGDAllM   where   acct in ($acctmap) and date='$fdate' and  isp='N' ";
	PrintQ($query);	
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
        	$orgs = $$row[0];
	}
	$sth->finish;
  
	# registry data
	$query  = "select count(distinct(concat(org,city,state,zip))) from thomtnetlogORGDAllM   ";
	$query .= "where acct in ($acctmap) and date='$fdate' and isp='N' and (longitude='0.0001' || longitude='0.0002' )   ";
	PrintQ($query);
	my $sth = $dbh->prepare($query);  
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{ 
        	$regs = $$row[0];
	}
	$sth->finish;
  
	if($orgs eq "")    {$orgs   = "0";}
	if($regs eq "")    {$regs   = "0";}
  
	print wf "$acct\t";              # Account Number
	print wf "$comp\t";              # Account Name
	print wf "$orgs\t"; 
	print wf "$regs\n"; 

	$orgs = $regs = "0";
 
	$z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
