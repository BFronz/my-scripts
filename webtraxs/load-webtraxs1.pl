#!/usr/bin/perl
#

 
use DBI;
require "/usr/wt/trd-reload.ph";
 

           
# Get Webtraxs accounts
$query = "SELECT distinct(acct) FROM tgrams.webtraxs_accts  ";
#$query .= "WHERE acct=643553 "; $REPLACE=1;
$query .= " limit 10 ";


$query = "select acct from tgrams.webtraxs_accts where  acct in (98524,400881,453634,699663,871837,1175670,1244710,1280986,10019341,10029783,10034892,10034892,30182859,699663,871837,1175670,1280986,150059,473565) ";   $REPLACE=1;  # hack to run one acct                
$query = "select distinct acct from tgrams.webtraxs_accts where acct in (699663, 871837, 1280986)  ";   $REPLACE=1;  
$query = "select distinct acct from tgrams.webtraxs_accts where acct in (871837)  ";   $REPLACE=1;  
$query = "select distinct acct from tgrams.webtraxs_accts where acct>0 ";   $REPLACE=""; 

open(wfe, ">Error.txt")  || die (print "Could not open Error.txt\n");            
  
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {  
  $acct[$i] = "$$row[0]";
 $i++;
 }
$sth->finish;

print "\nQ: $query\n\n";

$rc = $dbh->disconnect;
 
$outfile = "webtraxs_cross.txt"; 
$infile  = "webtraxs.txt"; 
$j = 1;  
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");            
foreach $acct (@acct)
 {
  print "$j)\t$acct\n";
     
  $url="http://clients.dev.webtraxs.com/data/CrossReport.php?acct=$acct";    
  $U="Rs";
  $P="vcmg";  
 
  print "$url\n\n";
  $cmd = "wget  --no-check-certificate --timeout=300 --tries=2   \"$url\" --user=$U --password=$P -O $infile ";
  system("$cmd"); 
   
  open(rf, "$infile")  || die (print "Could not open infile\n");
  while (!eof(rf))
   { 
     $line = <rf>;
     chop($line);
     $line =~ s/^\s+//;
     $line =~ s/\s+$//;

     #print "$line\n\n";
     #if($line !~ /Database select failed/ ) { print wf "$acct\t$line\t\t0\t0\n"; }
     if($line =~ /Error/ ) { print wfe "$line\n$url\n\n"; }  	
     if($line =~ /GATEWAY_TIMEOUT/ ) { print wfe "$line\n$url\n\n"; }  	
     ($visitor, $city, $state, $country, $initial_tnet_visit, $initial_tnet_category, $initial_tnet_category_des, $webtraxs_session_start, $referer, $search_term, $page_views, $isp) = split(/\t/,$line);	

      if($isp ne "Y") 
	{  
		print wf "$acct\t";
		print wf "$visitor\t$city\t$state\t$country\t$initial_tnet_visit\t$initial_tnet_category\t$initial_tnet_category_des\t$webtraxs_session_start\t$referer\t$search_term\t$page_views\t";
		print wf "0\t0\n"; 
		
      		#print "visitor: $visitor\tisp: $isp\n\n";
	}
  
	$visitor = $city = $state = $country = $initial_tnet_visit = $initial_tnet_category = $initial_tnet_category_des = $webtraxs_session_start = $referer = $search_term = $page_views = $isp = "";     

    }
   close(rf); 

  system ("rm webtraxs.txt"); 
  $j++;
  #sleep(1);
  #select(undef, undef, undef, 0.25);
 } 
 
close(wf); 
close(wfe); 


   
if($REPLACE eq 1) { system("mysqlimport -L thomas -r $DIR/webtraxs/$outfile"); }
else              { system("mysqlimport -L thomas -d $DIR/webtraxs/$outfile"); }
    
$rc = $dbh->disconnect;   

 
print "\n\nload-webtraxs1 completed...\n\n";
