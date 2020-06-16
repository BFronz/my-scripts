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
	print "\nUpdating $table\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}   


#updateTable("UPDATE $table SET block='Y' WHERE $visitortype like '%asshole%' || $visitortype like '%fuck%' ");
#updateTable("UPDATE $table SET block='Y' WHERE $visitortype = 'Big Cock Inc'  ");
#updateTable("UPDATE $table SET block='Y' WHERE $visitortype in ('bullshit drilling','rheas shit')  ");
#updateTable("UPDATE $table SET block='Y' WHERE $visitortype = 'none of your business manufacturing'  ");
updateTable("UPDATE $table SET block='Y' WHERE $visitortype = 'allen.arakelian\@gmail.com'  ");

print "\nDone...\n";
