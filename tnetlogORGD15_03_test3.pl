#!/usr/bin/perl
# 

   

use DBI;
require "/usr/wt/trd-reload.ph";

sub queryTable
{  
	$query = $_[0];
	#print "\n\n$query\n\n"; 
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{ 
		print"$$row[0]\t$$row[1]\n\n";
	}
	$sth->finish;

	sleep(1);
}   

$query = "SELECT org FROM thomtnetlogORGD15_03_test3 WHERE org>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$$row[0] =~ s/([\(\"])/\\$1/gi;   
	$$row[0] =~ s/([\)\"])/\\$1/gi;   
	$FLDS   .= "'$$row[0]',";
	$count++;
}    
$sth->finish;
chop($FLDS);

print "\nTotal $count\n";
queryTable(" select  'nonisp adv: ',        count(*) from  tnetlogORGD15_03_test2 where org in ($FLDS) and isp='N' and tinid='' and adv>''  ");    
queryTable(" select  'nonisp freelister: ', count(*) from  tnetlogORGD15_03_test2 where org in ($FLDS) and isp='N' and tinid='' and adv=''  ");    
 
queryTable(" select  'nonisp adv: ',        count(*) from  tnetlogORGD15_03_test2 where org in ($FLDS) and isp='Y' and tinid='' and adv>''  ");    
queryTable(" select  'nonisp freelister: ', count(*) from  tnetlogORGD15_03_test2 where org in ($FLDS) and isp='Y' and tinid='' and adv=''  ");           
 

print "\nDone...\n";
