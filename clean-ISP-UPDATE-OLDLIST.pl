#!/usr/bin/perl
# 

$table         = $ARGV[0];
$visitortype   = $ARGV[1];
if($table eq "" || $visitortype eq "") {print "\n\nForgot to add table or visitor name\n\n"; exit;} 
   
use DBI;
$dbh      = DBI->connect(":", "", "");

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

$query = "SELECT org FROM thomtnetlogORGflag  WHERE org>'' AND isp='Y' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
	$$row[0] =~ s/([\\\'\"])/\\$1/gi;   
	$$row[0] =~ s/([\(\"])/\\$1/gi;   
	$$row[0] =~ s/([\)\"])/\\$1/gi;   
	$ISPS   .= "'$$row[0]',";
	$count++;
}    
$sth->finish;
chop($ISPS);
print "\nTotal ISPs: $count\n";
updateTable("UPDATE $table SET ISP='Y' WHERE $visitortype IN ( $ISPS ) "); 

   

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
#updateTable("UPDATE $table SET block='Y' WHERE $visitortype IN ( $BLOCKS ) ");
  
 

print "\nDone...\n";
