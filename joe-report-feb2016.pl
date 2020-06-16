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
             
$outfile  = "top_50_accts_media_dollar_spend.txt"; 
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        

print wf "Account Number\tAccount Name\tCategory\tRank\tRank Points\tEst Rank 1\tEst Rank 2\tEst Rank 3\t";
print wf "Est Rank 4\tEst Rank 5\tEst Rank 6\tEst Rank 7\tEst Rank 8\tEst Rank 9\tEst Rank 10\n";

  
$query = " SELECT company,acct,ad_dollars FROM tgrams.main WHERE adv>'' ORDER BY ad_dollars DESC LIMIT 50";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{ 
	$record[$i] = "$$row[0]\t$$row[1]\t$$row[2]";
	#print "$record[$i]\n";
	$i++;
}
$sth->finish;


 
# loop through each heading
$l=1;   
foreach $record (@record) 
{  
	($account_name, $account_number, $addollars) = split(/\t/,$record);
	print "$l. $account_name\t$account_number\t$addollars\n";  
           
	$query  = "SELECT p.heading, h.description,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,pos,pop ";
	$query .= "FROM tgrams.position AS p, tgrams.headings AS h  ";
	$query .= "WHERE p.cov='NA' AND p.acct='$account_number' AND p.heading=h.heading group by p.heading ";
	$query .= "ORDER BY description ";   
	if($debug==1) { print "\n$query\n"; }
	my $sth = $dbh->prepare($query);
	if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
	while (my $row = $sth->fetchrow_arrayref)
  	{      
	$heading       =  $$row[0];
	$category      =  $$row[1];
	$est_rank_1    =  $$row[2];
	$est_rank_2    =  $$row[3];
	$est_rank_3    =  $$row[4];
	$est_rank_4    =  $$row[5];
	$est_rank_5    =  $$row[6];
	$est_rank_6    =  $$row[7];
	$est_rank_7    =  $$row[8];
	$est_rank_8    =  $$row[9];
	$est_rank_0    =  $$row[10];
	$est_rank_10   =  $$row[11]; 
	$rank          =  $$row[12]; 
	$rank_points   =  $$row[13]; 
   
        if($est_rank_1  eq "")  { $est_rank_1  = "0"; }
        if($est_rank_2  eq "")  { $est_rank_2  = "0"; }
        if($est_rank_3  eq "")  { $est_rank_3  = "0"; }
        if($est_rank_4  eq "")  { $est_rank_4  = "0"; }
        if($est_rank_5  eq "")  { $est_rank_5  = "0"; }
        if($est_rank_6  eq "")  { $est_rank_6  = "0"; }
        if($est_rank_7  eq "")  { $est_rank_7  = "0"; }
        if($est_rank_8  eq "")  { $est_rank_8  = "0"; }
        if($est_rank_9  eq "")  { $est_rank_9  = "0"; }
        if($est_rank_10 eq "")  { $est_rank_10 = "0"; }
        if($rank  eq "")  { $rank  = "0"; }  
        if($rank_points   eq "")  { $rank_points   = "0"; }  

	print wf "$account_number\t";
	print wf "$account_name\t";	
	print wf "$category\t";
	print wf "$rank\t";
	print wf "$rank_points\t";
	print wf "$est_rank_1\t";
	print wf "$est_rank_2\t";
	print wf "$est_rank_3\t";
	print wf "$est_rank_4\t";
	print wf "$est_rank_5\t";
	print wf "$est_rank_6\t";
	print wf "$est_rank_7\t";
	print wf "$est_rank_8\t";
	print wf "$est_rank_9\t";
	print wf "$est_rank_10\t";
	print wf "$addollars\n";
 	 
	$category       ="";
	$rank           =0;
	$rank_points    =0;
	$est_rank_1     =0;
	$est_rank_2     =0;
	$est_rank_3     =0;
	$est_rank_4     =0;
	$est_rank_5     =0;
	$est_rank_6     =0;
	$est_rank_7     =0;
	$est_rank_8     =0;
	$est_rank_9     =0;
	$est_rank_10    =0;
 
	} 
	$sth->finish;

	$l++;
}  
   
close(wf);
$rc = $dbh->disconnect;



print "\n\nDone...\n\n";
