#!/usr/bin/perl
#

$table         = $ARGV[0];

if($table eq "") {print "\n\nForgot to add table \n\n"; exit;}

if($table =~ /adcvmaster/ || $table =~ /tnetlogADviewsServerOrg/)  { $usedate = "fdate"; }
else                                                               { $usedate = "date";  }

# change these dates if needed
$rdate  = " '1401','1402','1403','1404','1405','1406','1407','1408','1409','1410','1411','1412'  ";
$rdate .= " ,'1501','1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512' ";
$rdate .= " ,'1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612' ";

print "\n$table\t$usedate\n";

use DBI;
# require "/usr/wt/trd-reload.ph";

# Use to update po
 $data_source = "dbi:mysql:thomas:po.rds.c.net";
 $user        = ;
 $auth        = ;
 $dbh         = DBI->connect($data_source, $user, $auth);
 print "Updating po DB\n";	

sub updateTable
{  
	$q = $_[0];
#	print "\n\n$q\n\n";
#	print "\nUpdating $table\n";
	my $sth = $dbh->prepare($q);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "\n"; exit(0); }
	$sth->finish;
	sleep(1);
}



updateTable("UPDATE $table SET industry='Engineering Services'			WHERE $usedate IN ($rdate) AND  industry IN ('Engineering/Architectural/R&D Svc') ");

updateTable("UPDATE $table SET industry='Manufacturing'			        WHERE $usedate IN ($rdate) AND  industry IN ('Furniture','Hardware','HVAC Equipment Manufacturing','Manufacturing, Electronic Equipment/Components','Manufacturing, Industrial/Commercial Machinery/Automation Equipment','Manufacturing, Instruments (Measure/Control/Test/Analyze)','Manufacturing, Mechanical Equipment/Components','Manufacturing, Aircraft/Aerospace','Manufacturing, Electronic Equipment/Components','Manufacturing, Food','Manufacturing, Industrial/Commercial Machinery/Automation Equipment','Manufacturing, Instruments (Measure/Control/Test/Analyze)','Manufacturing, Mechanical Equipment/Components','Manufacturing, Other','Manufacturing, Primary Metal Industries') ");

updateTable("UPDATE $table SET industry='Aerospace &amp; Defense'	        WHERE $usedate IN ($rdate) AND  industry = 'Aerospace & Defense' ");

updateTable("UPDATE $table SET industry='Consumer Goods &amp; Services'	        WHERE $usedate IN ($rdate) AND  industry = 'Consumer Goods & Services' ");

updateTable("UPDATE $table SET industry='Energy &amp; Utilities'	        WHERE $usedate IN ($rdate) AND  industry = 'Energy & Utilities' ");

updateTable("UPDATE $table SET industry='Printing &amp; Publishing'	        WHERE $usedate IN ($rdate) AND  industry = 'Printing & Publishing' ");

updateTable("UPDATE $table SET industry='Agriculture'		                WHERE $usedate IN ($rdate) AND  industry IN ('Agriculture/Forestry/Fishing','Agriculture/Forestry') ");

updateTable("UPDATE $table SET industry='Business Services'	                WHERE $usedate IN ($rdate) AND  industry IN ('Financial Services','Financial/Insurance/Real Estate','Accounting/Resrch/Mngment Srvcs','Accounting/Research/Management Services','Business services')  ");

updateTable("UPDATE $table SET industry='Education'	                        WHERE $usedate IN ($rdate) AND  industry = 'Education/Library' ");

updateTable("UPDATE $table SET industry='Facilities &amp; Property Management'  WHERE $usedate IN ($rdate) AND  industry IN ('Real Estate' ,'Facilities & Property Management') ");

updateTable("UPDATE $table SET industry='Food &amp; Beverage'	                WHERE $usedate IN ($rdate) AND  industry IN ('Food Service Operations','Food Processing','Food & Beverage') ");

updateTable("UPDATE $table SET industry='Government &amp; Military'	        WHERE $usedate IN ($rdate) AND  industry IN ('Government','Government/Military', 'Government & Military') ");

updateTable("UPDATE $table SET industry='Healthcare &amp; Medical'	        WHERE $usedate IN ($rdate) AND  industry IN ('Medical','Healthcare & Medical' ) ");

updateTable("UPDATE $table SET industry='Other'		                        WHERE $usedate IN ($rdate) AND  industry IN ('Associations','Hospitality & Travel','Hospitality &amp; Travel','Media & Entertainment','Media &amp; Entertainment','NA','Recreation','Unclassified','Other/Consultants','Personal Services','Industry','Services','Basic','Detailed')  ");

updateTable("UPDATE $table SET industry='Retail &amp; Distribution'	        WHERE $usedate IN ($rdate) AND  industry IN ('Distributors/Wholesaler','Wholesale Trade/Distributors','Retail Trade','Retail & Distribution','Retail & Distribution') ");

updateTable("UPDATE $table SET industry='Software &amp; Technology'		WHERE $usedate IN ($rdate) AND  industry IN ('Technology','Software & Technology')  ");

updateTable("UPDATE $table SET industry='Textiles'			        WHERE $usedate IN ($rdate) AND  industry = 'Apparel'  ");

updateTable("UPDATE $table SET industry='Agriculture'			        WHERE $usedate IN ($rdate) AND  industry = 'Garden'  ");

updateTable("UPDATE $table SET industry='Transportation &amp; Logistics'        WHERE $usedate IN ($rdate) AND  industry IN ('Trans./Communication/Utilities', 'Transportation & Logistics') ");

updateTable("UPDATE $table SET industry='Agriculture'	                        WHERE $usedate IN ($rdate) AND  industry = 'Home &amp; Garden' AND subindustry ='Landscaping' ");

updateTable("UPDATE $table SET industry='Manufacturing'	                        WHERE $usedate IN ($rdate) AND  industry = 'Home &amp; Garden' AND subindustry ='Home Furnishings' ");

updateTable("UPDATE $table SET industry='Manufacturing'	                        WHERE $usedate IN ($rdate) AND  industry = 'Home &amp; Garden' AND subindustry ='Machinery' ");

updateTable("UPDATE $table SET industry='Marine'	                        WHERE $usedate IN ($rdate) AND  industry = 'Aerospace &amp; Defense' AND subindustry ='Ship Building' ");


print "\n$table Finished...\n";
