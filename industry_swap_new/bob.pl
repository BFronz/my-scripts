#!/usr/bin/perl
# 

$table         = $ARGV[0];
$fdate         = $ARGV[1];
 
if($table eq "" || $fdate eq "") {print "\n\nForgot to add table or date\n\n"; exit;}

if($table =~ /adcvmaster/ || $table =~ /tnetlogADviewsServerOrg/)  { $usedate = "fdate"; }
else                                                               { $usedate = "date";  }
 
use DBI;
require "/usr/wt/trd-reload.ph";  
print "UPDATING CHARON";   
 
# Use to update po 
# $data_source = "dbi:mysql:thomas:po.rds.c.net";
# $user        = ;
# $auth        = ;
# $dbh         = DBI->connect($data_source, $user, $auth);
# PRINT "UPDATING po";   
 
if($usedate eq "") { $usedate = "date";  }

print "\n$table\t$fdate\t$usedate\n";  

$fdate = "'$fdate'";

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

updateTable("UPDATE $table SET industry='Engineering Services'			WHERE  industry IN ('Engineering/Architectural/R&D Svc') ");

updateTable("UPDATE $table SET industry='Manufacturing'			        WHERE  industry IN ('Furniture','Hardware','HVAC Equipment Manufacturing','Manufacturing, Electronic Equipment/Components','Manufacturing, Industrial/Commercial Machinery/Automation Equipment','Manufacturing, Instruments (Measure/Control/Test/Analyze)','Manufacturing, Mechanical Equipment/Components','Manufacturing, Aircraft/Aerospace','Manufacturing, Electronic Equipment/Components','Manufacturing, Food','Manufacturing, Industrial/Commercial Machinery/Automation Equipment','Manufacturing, Instruments (Measure/Control/Test/Analyze)','Manufacturing, Mechanical Equipment/Components','Manufacturing, Other','Manufacturing, Primary Metal Industries') ");

updateTable("UPDATE $table SET industry='Aerospace &amp; Defense'	        WHERE  industry = 'Aerospace & Defense' ");

updateTable("UPDATE $table SET industry='Consumer Goods &amp; Services'	        WHERE  industry = 'Consumer Goods & Services' ");

updateTable("UPDATE $table SET industry='Energy &amp; Utilities'	        WHERE  industry = 'Energy & Utilities' ");

updateTable("UPDATE $table SET industry='Printing &amp; Publishing'	        WHERE  industry = 'Printing & Publishing' ");

updateTable("UPDATE $table SET industry='Agriculture'		                WHERE  industry IN ('Agriculture/Forestry/Fishing','Agriculture/Forestry') ");

updateTable("UPDATE $table SET industry='Business Services'	                WHERE  industry IN ('Financial Services','Financial/Insurance/Real Estate','Accounting/Resrch/Mngment Srvcs','Accounting/Research/Management Services','Business services')  ");

updateTable("UPDATE $table SET industry='Education'	                        WHERE  industry = 'Education/Library' ");

updateTable("UPDATE $table SET industry='Facilities &amp; Property Management'  WHERE  industry IN ('Real Estate' ,'Facilities & Property Management') ");

updateTable("UPDATE $table SET industry='Food &amp; Beverage'	                WHERE  industry IN ('Food Service Operations','Food Processing','Food & Beverage') ");

updateTable("UPDATE $table SET industry='Government &amp; Military'	        WHERE  industry IN ('Government','Government/Military', 'Government & Military') ");

updateTable("UPDATE $table SET industry='Healthcare &amp; Medical'	        WHERE  industry IN ('Medical','Healthcare & Medical' ) ");

updateTable("UPDATE $table SET industry='Other'		                        WHERE  industry IN ('Associations','Hospitality & Travel','Hospitality &amp; Travel','Media & Entertainment','Media &amp; Entertainment','NA','Recreation','Unclassified','Other/Consultants','Personal Services','Industry','Services','Basic','Detailed')  ");

updateTable("UPDATE $table SET industry='Retail &amp; Distribution'	        WHERE  industry IN ('Distributors/Wholesaler','Wholesale Trade/Distributors','Retail Trade','Retail & Distribution','Retail & Distribution') ");

updateTable("UPDATE $table SET industry='Software &amp; Technology'		WHERE  industry IN ('Technology','Software & Technology')  ");

updateTable("UPDATE $table SET industry='Textiles'			        WHERE  industry = 'Apparel'  ");

updateTable("UPDATE $table SET industry='Agriculture'			        WHERE  industry = 'Garden'  ");

updateTable("UPDATE $table SET industry='Transportation &amp; Logistics'        WHERE  industry IN ('Trans./Communication/Utilities', 'Transportation & Logistics') ");

updateTable("UPDATE $table SET industry='Agriculture'	                        WHERE  industry = 'Home &amp; Garden' AND subindustry ='Landscaping' ");

updateTable("UPDATE $table SET industry='Manufacturing'	                        WHERE  industry = 'Home &amp; Garden' AND subindustry ='Home Furnishings' ");

updateTable("UPDATE $table SET industry='Manufacturing'	                        WHERE  industry = 'Home &amp; Garden' AND subindustry ='Machinery' ");

updateTable("UPDATE $table SET industry='Marine'	                        WHERE  industry = 'Aerospace &amp; Defense' AND subindustry ='Ship Building' ");


print "\n$table Finished...\n";
