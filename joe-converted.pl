#!/usr/bin/perl
#
#


use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
#$debug=1;

$now_string = localtime;
print "$now_string\n\n";

$rdate = " '1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512' ";
$i=0; 

$outfile = "converted2015.txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "description\tcategory #\tconverted user session count\tsupplier evaluation count\tsuper categories  category  map\n";

# put headings in an array 
$query  =  "SELECT heading, description FROM tgrams.headings ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$heading{$$row[0]} = $$row[1];
	$i++; 
}
$sth->finish;
 
# get converted visits
$query  =  "SELECT heading, convertedvisits FROM thomtnetloghdgCovConvM  ";
$query  .= "WHERE date in ($rdate) AND heading > 0 AND cov='NA'  ";
$query  .= " LIMIT 500  ";
my $sth = $dbh->prepare($query);  
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{
	$cat[$i]="$$row[0]\t$$row[1]\n";
	$i++;
} 
$sth->finish;
  

$j=1;
foreach $cat (@cat)
 {

	($hd,$converted_visitor) = split(/\t/,$cat);
	$description = $heading{$hd}; 
	print "$j) $description\t$hd\n";
  
=for comment
	$q  = "SELECT heading FROM thomtnetlogORGCATD15M  WHERE org='$org' GROUP BY heading  ";
	if($debug eq 1) { print " $q\n\n"; }
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
	{
		$org =~ s/&amp;/&/g;
		print wf "$org\t$cat[$$row[0]]\n";
	}
	$sth->finish;
=cut 

 	$j++;
}

close(wf);

$dbh->disconnect;

$now_string = localtime;
print "$now_string"; 
 
print "\nDone...";
