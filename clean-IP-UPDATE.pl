#!/usr/bin/perl
# 
 
$table   = $ARGV[0];
$field   = $ARGV[1];
if($table eq "") { print "\n\nForgot to add table or visitor name\n\n"; exit;} 
if($field eq "") { $field = " ip "; }

print "\n$table\n";
   
use DBI; 
require "/usr/wt/trd-reload.ph";

sub updateTable
{ 
	$q = $_[0];
	#print "\n\n$q\n\n"; 
	#print "\nUpdating $table\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}   
  
$query = "select ip  from thomorg_suppressIP";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$$row[0] =~ s/([\(\"])/\\$1/gi;   
	$$row[0] =~ s/([\)\"])/\\$1/gi;   
	$IP   .= "'$$row[0]',";
	$count++; 
}    
$sth->finish;
chop($IP);
print "\nTotal IP: $count\n";
updateTable("UPDATE $table SET block='Y' WHERE $field IN ( $IP ) ");    
    
print "\nDone...\n";
