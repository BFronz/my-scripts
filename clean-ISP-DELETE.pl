#!/usr/bin/perl
# 

$table         = $ARGV[0];
$visitortype   = $ARGV[1];
if($table eq "" || $visitortype eq "") {print "\n\nForgot to add table or visitor name\n\n"; exit;} 

print "\n$table\t$visitortype\n";
   

use DBI;
require "/usr/wt/trd-reload.ph";

sub updateTable
{
	$q = $_[0];
	#print "\n\n$q\n\n";
	print "\nUpdating $table by delete\n";
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
	$count++;
}   
$sth->finish;
chop($ISPS);
print "\nTotal ISPs: $count\n";
updateTable(" DELETE FROM $table WHERE $visitortype IN ( $ISPS ) ");
 
 

$query = "SELECT orgblock FROM thomtnetlogORGflagBLOCK   WHERE orgblock>'' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
        $$row[0] =~ s/([\\\'\"])/\\$1/gi;
        $BLOCKS   .= "'$$row[0]',";
        $countb++;
}
$sth->finish;
print "\nTotal blocks: $countb\n";
chop($BLOCKS);
updateTable(" DELETE FROM $table WHERE $visitortype IN ( $BLOCKS ) ");


print "\nDone...\n";
