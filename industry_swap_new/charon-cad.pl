#!/usr/bin/perl
# 

$table         = $ARGV[0];
$fdate         = $ARGV[1];
$usedate       = $ARGV[2];	


if($table eq "" || $fdate eq "") {print "\n\nForgot to add table or date\n\n"; exit;}

print "\n$table\t$fdate\n";   

use DBI;
require "/usr/wt/trd-reload.ph";

#$data_source = "dbi:mysql:thomas:po.rds.c.net";
#$user        = ;
#$auth        = ;
#$dbh         = DBI->connect($data_source, $user, $auth);

if($usedate eq "") { $usedate = "date";  }

 
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


updateTable("UPDATE $table SET industry='AGRICULTURE'		             WHERE $usedate = '$fdate' AND industry = 'AGRICULTURE/FORESTRY/FISHING' ");
                                                                                
updateTable("UPDATE $table SET industry='BUSINESS SERVICES'	             WHERE $usedate = '$fdate' AND industry IN ('FINANCIAL SERVICES','FINANCIAL/INSURANCE/REAL ESTATE','ACCOUNTING/RESRCH/MNGMENT SRVCS','ACCOUNTING/RESEARCH/MANAGEMENT SERVICES')  ");
                                                                                
updateTable("UPDATE $table SET industry='EDUCATION'	                     WHERE $usedate = '$fdate' AND industry = 'EDUCATION/LIBRARY' ");

updateTable("UPDATE $table SET industry='FACILITIES & PROPERTY MANAGEMENT'   WHERE $usedate = '$fdate' AND industry = 'REAL ESTATE' ");

updateTable("UPDATE $table SET industry='FOOD & BEVERAGE'	             WHERE $usedate = '$fdate' AND industry IN ('FOOD SERVICE OPERATIONS','FOOD PROCESSING') ");
                                                                                
updateTable("UPDATE $table SET industry='GOVERNMENT & MILITARY'	             WHERE $usedate = '$fdate' AND industry IN ('GOVERNMENT','GOVERNMENT/MILITARY') ");
                                                                                
updateTable("UPDATE $table SET industry='HEALTHCARE & MEDICAL'	             WHERE $usedate = '$fdate' AND industry = 'MEDICAL'  ");
                                                                                
updateTable("UPDATE $table SET industry='MANUFACTURING'			     WHERE $usedate = '$fdate' AND industry IN ('FURNITURE','HARDWARE','HVAC EQUIPMENT MANUFACTURING') ");

updateTable("UPDATE $table SET industry='OTHER'		                     WHERE $usedate = '$fdate' AND industry IN ('ASSOCIATIONS','HOSPITALITY & TRAVEL','HOSPITALITY &AMP; TRAVEL','MEDIA & ENTERTAINMENT','MEDIA &AMP; ENTERTAINMENT','NA','RECREATION','UNCLASSIFIED','OTHER/CONSULTANTS','PERSONAL SERVICES')  ");
                                                                                
updateTable("UPDATE $table SET industry='RETAIL & DISTRIBUTION'	             WHERE $usedate = '$fdate' AND industry IN ('DISTRIBUTORS/WHOLESALER','WHOLESALE TRADE/DISTRIBUTORS','RETAIL TRADE') ");

updateTable("UPDATE $table SET industry='SOFTWARE & TECHNOLOGY'		     WHERE $usedate = '$fdate' AND industry = 'TECHNOLOGY'  ");
                                                                                
updateTable("UPDATE $table SET industry='TEXTILES'			     WHERE $usedate = '$fdate' AND industry = 'APPAREL'  ");

updateTable("UPDATE $table SET industry='TRANSPORTATION & LOGISTICS'         WHERE $usedate = '$fdate' AND industry = 'TRANS./COMMUNICATION/UTILITIES' ");

updateTable("UPDATE $table SET industry='AGRICULTURE'	                     WHERE $usedate = '$fdate' AND industry = 'HOME &AMP; GARDEN' AND SUBINDUSTRY ='LANDSCAPING' ");

updateTable("UPDATE $table SET industry='MANUFACTURING'	                     WHERE $usedate = '$fdate' AND industry = 'HOME &AMP; GARDEN' AND SUBINDUSTRY ='HOME FURNISHINGS' ");

updateTable("UPDATE $table SET industry='MANUFACTURING'	                     WHERE $usedate = '$fdate' AND industry = 'HOME &AMP; GARDEN' AND SUBINDUSTRY ='MACHINERY' ");

updateTable("UPDATE $table SET industry='MARINE'	                     WHERE $usedate = '$fdate' AND industry = 'AEROSPACE &AMP; DEFENSE' AND SUBINDUSTRY ='SHIP BUILDING' ");

 
print "\n$table Finished...\n";
