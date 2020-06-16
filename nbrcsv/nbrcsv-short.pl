#!/usr/bin/perl
#
#
 
# need to adjust these each month
$rdate = " '1503','1504','1505','1506','1507','1508','1509','1510','1511','1512','1601', '1602' ";
$addquery = "  sum(if(date='2015',q2,0)) + sum(if(date='2015',q3,0)) + sum(if(date='2015',q4,0)) +  sum(if(date='2016',q1,0))   ";

$rdate = " '1507','1508','1509','1510','1511','1512','1601', '1602','1603','1604','1605','1606' ";
$addquery = "   sum(if(date='2015',q3,0)) + sum(if(date='2015',q4,0)) +  sum(if(date='2016',q1,0)) + sum(if(date='2016',q2,0))  ";

 
$rdate = " '1510','1511','1512','1601', '1602','1603','1604','1605','1606','1607','1608','1609' ";
$addquery = "   sum(if(date='2015',q4,0)) + sum(if(date='2016',q1,0)) +  sum(if(date='2016',q2,0)) + sum(if(date='2016',q3,0))  ";

 
$rdate = " '1601','1602','1603','1604','1605','1606','1607','1608','1609','1610','1611','1612' ";
$addquery = "  sum(if(date='2016',q1,0)) +  sum(if(date='2016',q2,0)) + sum(if(date='2016',q3,0)) + sum(if(date='2016',q4,0))  ";
    
$rdate = " '1607','1608','1609','1610','1611','1612','1701','1702','1703', '1704','1705','1706'   ";
$addquery = "  sum(if(date='2016',q3,0)) + sum(if(date='2016',q4,0)) + sum(if(date='2017',q1,0)) + sum(if(date='2017',q2,0)) ";
 
$rdate = " '1610','1611','1612','1701','1702','1703', '1704','1705','1706','1707','1708','1709' ";
$addquery = " sum(if(date='2016',q4,0)) + sum(if(date='2017',q1,0)) + sum(if(date='2017',q2,0)) + sum(if(date='2017',q3,0))  ";
  
   
use DBI;
require "/usr/wt/trd-reload.ph";

$epoc = time();
$year=31536000;
$year=31622400; # with leap day 
$oneyearago = ( $epoc - $year ); 
$debug="2";
             
 
# Get headings 
$query = " SELECT heading, description AS d FROM tgrams.headings WHERE heading>'0' ORDER BY d";
#$query .= " limit 25 ";  
#$query = " SELECT heading, description AS d FROM tgrams.headings WHERE heading in (45330503, 50550409, 74351008, 43277201, 45340403) ";
#$query = " SELECT heading, description AS d FROM tgrams.headings WHERE heading=700500  ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
	$record[$i] = "$$row[0]\t$$row[1]";
	$i++;
}
$sth->finish;
 
$outfile  = "nbrcsv_short.txt"; 
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        
 
print wf "category\tdescription\tcov\tadv\tfree\tbold\trank1\trank2\trank3\trank4\trank5\trank6\trank7\trank8\trank9\trank10\t";
print wf "cov_us_year\t";
print wf "cov_conversions_year\n";
 
# loop through each heading
$l=1;   
foreach $record (@record)
{ 
	($category,$description) = split(/\t/,$record);
	print "$l. $description\n";  
          
	# loop through all covs for each heading, get ranks for first 10 places
	$query = "SELECT cov,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10 FROM tgrams.position WHERE heading ='$category' GROUP BY cov";   
	if($debug==1) { print "\n$query\n"; }
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
  	{     
	$coverage =  $$row[0];
	$rank1    =  $$row[1];
	$rank2    =  $$row[2];
	$rank3    =  $$row[3];
	$rank4    =  $$row[4];
	$rank5    =  $$row[5];
	$rank6    =  $$row[6];
	$rank7    =  $$row[7];
	$rank8    =  $$row[8];
	$rank9    =  $$row[9];
	$rank10   =  $$row[10];

	if($rank1  eq "")  { $rank1  = "0"; }  # set to zero if empty,less errors on import
	if($rank2  eq "")  { $rank2  = "0"; } 
	if($rank3  eq "")  { $rank3  = "0"; } 
	if($rank4  eq "")  { $rank4  = "0"; } 
	if($rank5  eq "")  { $rank5  = "0"; } 	
	if($rank6  eq "")  { $rank6  = "0"; } 
	if($rank7  eq "")  { $rank7  = "0"; } 
	if($rank8  eq "")  { $rank8  = "0"; } 
	if($rank9  eq "")  { $rank9  = "0"; } 
	if($rank10 eq "")  { $rank10 = "0"; } 
  
	# get advs and freelisters
	$subq = "SELECT adv, cnt_headin FROM  tgrams.covprodhd WHERE heading='$category' AND area='$coverage' "; 
	if($debug==1) { print "\n$subq\n"; }
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $substh->fetchrow_arrayref) 
	{ 
		$adv  = $$row[0]; 
		$free = $$row[1] - $adv ;	
	}  
	$substh->finish;
	if($adv eq "")  { $adv  = "0"; }
      	if($free eq "") { $free = "0"; }
   
	# get bold listers
	$subq = "SELECT count(*) FROM  tgrams.position WHERE heading='$category' AND cov='$coverage' AND pop='0' AND adv>'' "; 
	if($debug==1) { print "\n$subq\n"; }
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{   
		$bold  = $$row[0]; 
	}  
	$substh->finish;
	if($bold eq "") { $bold = "0"; }     
   
  
	# coverage user sessions rolling 4 quarters 
	if($coverage eq "NA") {$covflag="n"}
	else                  {$covflag=$coverage;}
	$subq = "SELECT $addquery FROM  thomsummaryu WHERE heading='$category' AND covflag='$covflag' ";
	if($debug==1) { print "\n$subq\n"; } 
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{                           
		$cov_us_year  = $$row[0]; 
	}   
	$substh->finish;
	if($cov_us_year eq "") { $cov_us_year = "0"; }     
 

	# coverage conversions rolling 4 quarter
	if($coverage eq "NA") {$covflag="n"}
	else                  {$covflag=$coverage;}
	$subq = "SELECT $addquery FROM  thomsummaryc WHERE heading='$category' AND covflag='$covflag' ";
	if($debug==1) { print "\n$subq\n"; } 
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{                           
		$cov_conversions_year  = $$row[0]; 
	}   
	$substh->finish;
	if($cov_conversions_year eq "") { $cov_conversions_year = "0"; }     

 
	print wf "$category\t";
	print wf "$description\t";
	print wf "$coverage\t";
	print wf "$adv\t";
	print wf "$free\t";
	print wf "$bold\t";
	print wf "$rank1\t";
	print wf "$rank2\t";
	print wf "$rank3\t";
	print wf "$rank4\t";
	print wf "$rank5\t";
	print wf "$rank6\t";
	print wf "$rank7\t";
	print wf "$rank8\t";
	print wf "$rank9\t";
	print wf "$rank10\t";
	print wf "$cov_us_year\t";
	print wf "$cov_conversions_year\n";

	$adv = $free = $bold = "0";
	$rank1 = $rank2 = $rank3 = $rank4 = $rank5 = $rank6 = $rank7 = $rank8 = $rank9 = $rank10 = "0";
	$converted_us_1 = $converted_us_2 = $converted_us_3 = $converted_us_4 = $converted_us_5 = "0";
	$converted_us_6 = $converted_us_7 = $converted_us_8 = $converted_us_9 = $converted_us_10 = "0";
	$sales_inquiry_rfqs = $cov_converted_us_year = $cov_converted_us_sessions_percent_cat_site_converted_us = "0";
	$cov_us_year = $cov_us_percent_cat_site_us = $cov_conversions_year = $cov_conversions_percent_cat_site_conversions = "0";  
	$category_site_user_sessions = $category_site_conversions = "0";
	} 
	$sth->finish;

	$l++;
}  
   
close(wf);
$rc = $dbh->disconnect;

system("mysqlimport -dL thomas $outfile");

print "\n\nDone...\n\n";
