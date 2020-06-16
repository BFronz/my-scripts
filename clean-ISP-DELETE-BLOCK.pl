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
	print "\n\n$q\n\n";
	print "\nUpdating $table by delete\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}   

updateTable(" DELETE FROM $table WHERE $visitortype like '%asshole%' || $visitortype like '%fuck%' ");
  

print "\nDone...\n";
