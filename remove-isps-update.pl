#!/usr/bin/perl
# 
 
#$fdate   = $ARGV[0];
#if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;} 

$fyear     = "20" . substr($fdate, 0, 2);
$yy        =  substr($fdate, 0, 2);
$mm        =  substr($fdate, 2, 2);


$table     = "tnetlogORGPS13M";
#$table     = "flat_catnav_ORG12";
#$table     = "flat_catnav_ORG13";
#$table     = "newsORGD14";  
#$table     = "newsORGD13";  
#$table     = "newsORGD12";  
#$table     = "newsORGN14";  
#$table     = "newsORGSITED13";  
#$table     = "tnetlogCADIP";  
#$table     = "tnetlogORGN12";  
#$table     = "tnetlogORGCATN12";  
#$table     = "tnetlogORGD14M";  
#$table     = "vtoolM";  

$table     = "flat_catnav_ORG_alt13";  
 
   
use DBI;
$dbh      = DBI->connect("", "", "");

sub updateTable
{
	$q = $_[0];
	#print "\n\n$q\n\n";
	print "\nUpdating $table\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}    

$query = "SELECT org FROM thomtnetlogORGflagExtra WHERE org>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$ISPS   .= "'$$row[0]',";
}   
$sth->finish;

chop($ISPS);
                
#updateTable(" UPDATE $table SET isp='Y' WHERE isp_name IN ( $ISPS ) ");
#updateTable(" UPDATE $table SET isp='Y' WHERE org IN ( $ISPS ) ");
updateTable(" UPDATE $table SET isp='Y' WHERE co IN ( $ISPS ) ");
   
print "\nDone...\n";

