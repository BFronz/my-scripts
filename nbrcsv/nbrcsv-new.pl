#!/usr/bin/perl
#
#

# need to adjust these each month
$rdate = " '1502','1503','1504','1505','1506','1507','1508','1509','1510','1511','1512','1601' ";
$addquery = "   sum(if(date='2015',q1,0)) + sum(if(date='2015',q2,0)) + sum(if(date='2015',q3,0)) + sum(if(date='2015',q4,0))   ";

use DBI;
require "/usr/wt/trd-reload.ph";

$epoc = time();
$year=31536000;
$year=31622400; # with leap day 
$oneyearago = ( $epoc - $year ); 
$debug="2";
             

 
# Get headings 
$query = " SELECT * FROM thomnbrcsv_short  ORDER BY description, cov ";
#$query .= " limit 50 ";  
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
	$record[$i] = "$$row[0]\t$$row[1]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[6]\t$$row[7]\t$$row[8]\t$$row[9]\t$$row[10]\t$$row[11]\t$$row[12]\t$$row[13]\t$$row[14]\t$$row[15]\t$$row[16]\t$$row[17]";
	$i++;
}
$sth->finish;
 

$outfile  = "nbrcsv.txt"; 
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        

print wf "category\tdescription\tcov\tadv\tfree\tbold\trank1\trank2\trank3\trank4\trank5\trank6\trank7\trank8\trank9\trank10\t";
print wf "converted_us_1\tconverted_us_2\tconverted_us_3\tconverted_us_4\tconverted_us_5\tconverted_us_6\tconverted_us_7\t";
print wf "converted_us_8\tconverted_us_9\tconverted_us_10\tsales_inquiry_rfqs\tcov_converted_us_year\t";
print wf "cov_converted_us_sessions_percent_cat_site_converted_us\tcov_us_year\tcov_us_percent_cat_site_us\t";
print wf "cov_conversions_year\tcov_conversions_percent_cat_site_conversions\t";
print wf "category_site_user_sessions\tcategory_site_conversions\n";

# loop through each heading
$l=1;   
foreach $record (@record)
{ 
	($category,$description,$cov,$adv,$free,$bold,$rank1,$rank2,$rank3,$rank4,$rank5,$rank6,$rank7,$rank8,$rank9,$rank10,$cov_us_year,$cov_conversions_year) = split(/\t/,$record);
	print "$l. $description\t $cov\n";  
           
  
        # get converted user sessions  then calculate converted us ratios, 1 - 10 place
	$subq = "SELECT  sum(convertedvisits) FROM thomtnetloghdgCovConvM WHERE heading='$category' AND cov='$cov'  AND date in ($rdate) ";	
	if($debug==1) { print "\n$subq\n"; }
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{     
		$cov_converted_us_year = $$row[0]; 
 	}  
	$substh->finish;     
	if($cov_converted_us_year eq "") { $cov_converted_us_year="0"; }

	$converted_us_1     =  sprintf("%.1f", $cov_converted_us_year / ($rank1 + 1) ); 
	$converted_us_2     =  sprintf("%.1f", $cov_converted_us_year / ($rank2 + 1) ); 
	$converted_us_3     =  sprintf("%.1f", $cov_converted_us_year / ($rank3 + 1) ); 
	$converted_us_4     =  sprintf("%.1f", $cov_converted_us_year / ($rank4 + 1) ); 
	$converted_us_5     =  sprintf("%.1f", $cov_converted_us_year / ($rank5 + 1) ); 
	$converted_us_6     =  sprintf("%.1f", $cov_converted_us_year / ($rank6 + 1) ); 
	$converted_us_7     =  sprintf("%.1f", $cov_converted_us_year / ($rank7 + 1) ); 
	$converted_us_8     =  sprintf("%.1f", $cov_converted_us_year / ($rank8 + 1) ); 
	$converted_us_9     =  sprintf("%.1f", $cov_converted_us_year / ($rank9 + 1) ); 
	$converted_us_10    =  sprintf("%.1f", $cov_converted_us_year / ($rank10 + 1) );
      
	if($converted_us_1  eq "" ) {$converted_us_1  = "0.0";}
	if($converted_us_2  eq "" ) {$converted_us_2  = "0.0";}
	if($converted_us_3  eq "" ) {$converted_us_3  = "0.0";}
	if($converted_us_4  eq "" ) {$converted_us_4  = "0.0";}
	if($converted_us_5  eq "" ) {$converted_us_5  = "0.0";}
	if($converted_us_6  eq "" ) {$converted_us_6  = "0.0";}	
	if($converted_us_7  eq "" ) {$converted_us_7  = "0.0";}
	if($converted_us_8  eq "" ) {$converted_us_8  = "0.0";}
	if($converted_us_9  eq "" ) {$converted_us_9  = "0.0";}
	if($converted_us_10 eq "" ) {$converted_us_10 = "0.0";}
 

	# sales inquery  RFQ	
 	$subq = "SELECT count(*) FROM tgrams.contacts WHERE heading='$category' AND ccovarea='$cov' AND created>='$oneyearago' AND buy>=2";
	if($debug==1) { print "\n$subq\n"; }
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{   
		$sales_inquiry_rfqs  = $$row[0]; 
	}   
	$substh->finish;
	if($sales_inquiry_rfqs eq "") {  $sales_inquiry_rfqs = "0"; }    

  
	# next row: Coverage Converted User Sessions Rolling 4 Quarter - use  $cov_converted_us_year from above
 

	# Coverage Converted User Sessions % of Category Site Converted User Sessions
	$subq = "SELECT sum(convertedvisits) FROM thomtnetloghdgCovConvM WHERE heading='$category'  AND date in ($rdate) ";
	if($debug==1) { print "\n$subq\n"; } 
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{       
		$category_site_converted_user_sessions  = $$row[0]; 
	}   
	$substh->finish;     
	if($category_site_converted_user_sessions eq "") { $category_site_converted_user_sessions= "0"; }
 
	if($category_site_converted_user_sessions > 0 ) 
		{ 
			$cov_converted_us_sessions_percent_cat_site_converted_us = sprintf("%.3f", ($cov_converted_us_year / $category_site_converted_user_sessions) ); 
		}
	else
		{
			$cov_converted_us_sessions_percent_cat_site_converted_us = "0.000"; 
		}
	#print " $cov_converted_us_year / $category_site_converted_user_sessions = $cov_converted_us_sessions_percent_cat_site_converted_us\n ";
   
 
 

	# coverage user sessions % of category site user sessions
	$subq = "SELECT $addquery FROM  thomsummaryu WHERE heading='$category' AND covflag='t' ";
	if($debug==1) { print "\n$subq\n"; } 
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{                           
		$category_site_user_sessions = $$row[0]; 
	}   
	$substh->finish;     
	if($category_site_user_sessions eq "") { $category_site_user_sessions="0"; } 
        if( $category_site_user_sessions > 0)
	{
		$cov_us_percent_cat_site_us =  sprintf("%.3f", ($cov_us_year / $category_site_user_sessions) );
	} 
	else
	{
		$cov_us_percent_cat_site_us = "0.000"
	}
	#print "$cov_us_year / $category_site_user_sessions = $cov_us_percent_cat_site_us\n"; 
  
 
	# coverage conversions % of category site conversions
	$subq = "SELECT $addquery FROM  thomsummaryc WHERE heading='$category' AND covflag='t' ";
	if($debug==1) { print "\n$subq\n"; } 
	my $substh = $dbh->prepare($subq);
	if (!$substh->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	if (my $row = $substh->fetchrow_arrayref) 
	{                           
		$category_site_conversions = $$row[0]; 
	}   
	$substh->finish;     
	if($category_site_conversions eq "") { $category_site_conversions="0"; } 
        if( $category_site_conversions > 0 )
	{  
		$cov_conversions_percent_cat_site_conversions =  sprintf("%.3f", ($cov_conversions_year / $category_site_conversions) );
	} 
	else
	{
		$cov_conversions_percent_cat_site_conversions = "0.000"
	}	  
	#print "$cov_conversions_year / $category_site_conversions = $cov_conversions_percent_cat_site_conversions\n";
                                        
	print wf "$category\t";
	print wf "$description\t";
	print wf "$cov\t";
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
	print wf "$converted_us_1\t";
	print wf "$converted_us_2\t";
	print wf "$converted_us_3\t";
	print wf "$converted_us_4\t";
	print wf "$converted_us_5\t";
	print wf "$converted_us_6\t";
	print wf "$converted_us_7\t";
	print wf "$converted_us_8\t";
	print wf "$converted_us_9\t";
	print wf "$converted_us_10\t";
	print wf "$sales_inquiry_rfqs\t";
	print wf "$cov_converted_us_year\t";
	print wf "$cov_converted_us_sessions_percent_cat_site_converted_us\t";
	print wf "$cov_us_year\t";
	print wf "$cov_us_percent_cat_site_us\t";
	print wf "$cov_conversions_year\t";
	print wf "$cov_conversions_percent_cat_site_conversions\t";

	print wf "$category_site_user_sessions\t"; 
	print wf "$category_site_conversions\n";

	$adv = $free = $bold = "0";
	$rank1 = $rank2 = $rank3 = $rank4 = $rank5 = $rank6 = $rank7 = $rank8 = $rank9 = $rank10 = "0";
	$converted_us_1 = $converted_us_2 = $converted_us_3 = $converted_us_4 = $converted_us_5 = "0";
	$converted_us_6 = $converted_us_7 = $converted_us_8 = $converted_us_9 = $converted_us_10 = "0";
	$sales_inquiry_rfqs = $cov_converted_us_year = $cov_converted_us_sessions_percent_cat_site_converted_us = "0";
	$cov_us_year = $cov_us_percent_cat_site_us = $cov_conversions_year = $cov_conversions_percent_cat_site_conversions = "0";  
	$category_site_user_sessions = $category_site_conversions = "0";


	$l++;
}  
   
close(wf);
$rc = $dbh->disconnect;

system("mysqlimport -dL thomas $outfile");

print "\n\nDone...\n\n";
