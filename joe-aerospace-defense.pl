#!/usr/bin/perl
#
#
  

use DBI;
require "/usr/wt/trd-reload.ph";

$unixtime    = time();
$debug=1;

    
$rdatelable = "June2016";   
$table = "thomtnetlogORGCATDInfo";
$countrylable = "NorthAmerica";    
$industry = "'Aerospace &amp; Defense'"; $subindustry = "All";                $subindustrylable="All";             $qdates = " '1606' ";  $country =" 'United States','Mexico','Canada' ";
$industry = "'Aerospace &amp; Defense'"; $subindustry = "'Aircraft'";         $subindustrylable="Aircraft";        $qdates = " '1606' ";  $country =" 'United States','Mexico','Canada' ";
$industry = "'Aerospace &amp; Defense'"; $subindustry = "'Defense Systems'";  $subindustrylable="DefenseSystems"; $qdates = " '1606' ";  $country =" 'United States','Mexico','Canada' ";
$industry = "'Aerospace &amp; Defense'"; $subindustry = "'Ship Building'";    $subindustrylable="ShipBuilding";   $qdates = " '1606' ";  $country =" 'United States','Mexico','Canada' ";
$industry = "'Aerospace &amp; Defense'"; $subindustry = "'Space'";            $subindustrylable="Space";           $qdates = " '1606' ";  $country =" 'United States','Mexico','Canada' ";
 
   
$i=0;   

$outfile = "Aerospace-Defense" .  "-"  .  $subindustrylable . "-"  .  $rdatelable . "-" . $countrylable . ".txt";
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");
print wf "Category ID\tCategory Name\tUser Session Count\n";
   
     
$query  = "SELECT h.heading,  h.description, sum(cnt) AS n  ";
$query .= "FROM $table AS o, tgrams.headings AS h ";
$query .= "WHERE h.heading=o.heading AND o.acct = 0 AND o.country IN ($country) AND o.date IN ($qdates) ";
$query .= "AND industry IN ($industry) ";
if($subindustry ne "All") { $query .= "AND subindustry IN ($subindustry) ";  }
$query .= "GROUP BY h.heading ";
$query .= "ORDER BY n DESC, h.description ";
$query .= "LIMIT 100 ";
   
$j=1;
if($debug eq 1) { print "\n$query\n\n"; }
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
	{  
		print "$j.\t$$row[0]\t$$row[1]\t$$row[2]\n";
		print wf "$$row[0]\t";
 		print wf "$$row[1]\t";
		print wf "$$row[2]\n";
		$j++;
	}
$sth->finish;		


close(wf);

$dbh->disconnect;
 
 
print "\nDone...";
