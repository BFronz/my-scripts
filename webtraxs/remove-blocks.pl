#!/usr/bin/perl
# 

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;} 

$fyear     = "20" . substr($fdate, 0, 2);
$yy        =  substr($fdate, 0, 2);
$mm        =  substr($fdate, 2, 2);

$table     = " webtraxs_cross ";
 
use DBI;
$dbh      = DBI->connect("dbi:mysql:thomas:localhost", "", "");

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

 
$query = "SELECT orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$ISPS   .= "'$$row[0]',";
	$count++;
}   
$sth->finish;

print "\nTotal blocks: $count\n";

chop($ISPS);
     
updateTable(" DELETE FROM $table WHERE visitor IN ( $ISPS ) ");

print "\nDone...\n";
