#!/usr/bin/perl
#
 


$fdate   = $ARGV[0]; 
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

use DBI;
require "/usr/wt/trd-reload.ph";

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);  
$outfile  = "NonCatConversionslog.txt";
$outfile2 = "NonCatConversions$yy.txt";
  
# ----- Direct Profile Views -------- #
 $file[0]   = "brand_search:NonCatBrandSearch";
 $file[1]   = "company_name_search:NonCatCompanyNameSearch";
 $file[2]   = "external_search:NonCatExternalSearch";
 	#$file[3]   = "product_search:NonCatProductSearch";
  
# ----- Indirect Profile Views -------- #
 $file[3]   = "supplier_compare:NonCatSupplierCompare";
 $file[4]   = "preview_ad_quickview:NonCatPreviewAdQuickview";
 $file[5]   = "branch_location:NonCatBranchLocation";

# ----- Links to Websites -------- #
 $file[6]   = "news_release_links_website:NonCatNewsReleaseLinksWebsite";
 	#$file[7]   = "product_search_links_website:NonCatProductSearchLinksWebsite";
 	#$file[7]   = "pdf_view_links_website:NonCatPDFViewLinksWebsite";
 $file[7]  = "brand_ad_links_website:NonCatBrandAdLinksWebsite";
 $file[8]  = "all_links_website:NonCatAllLinksWebsite";
 
# ----- News Release Views -------- #
 $file[9]  = "tnet_news:NonCattnetNews";
 $file[10]  = "tnet_directory:NonCattnetDirectory";

# ----- Links to Catalog/Cad -------- #
 $file[11]  = "link_catalog_cad:NonCatLinkCatalogCAD";
 $file[12]  = "cad_library:NonCatCADLibrary";

# ----- Catalog Page Views -------- #
 $file[13]  = "catalog_solution_activity:NonCatCatalogSolutionActivity";
 $file[14]  = "product_search_item_detail_view:NonCatProductSearchItemDetailView";

# ----- Emails to Supplier -------- #
 $file[15]  = "directory_email:NonCatDirectoryEmail";
 	#$file[16]  = "product_search_email:NonCatProductSearchEmail";
 $file[16]  = "news_email:NonCatNewsEmail";
 
# ----- Emails to Colleague & MyThomas Saves -------- #
 $file[17]  = "total_emails_colleague_mythomas_saves:NonCatTotalEmailsColleagueMyThomasSaves";
 
# ----- Custom Company Profile Actions -------- #
 $file[18]  = "total_custom_company_profile_actions:NonCatTotalCustomCompanyProfileActions";

# ----- Map Views -------- #
 $file[19]  = "map_views:NonCatMapViews";

# ----- Print Requests -------- #
 	#$file[20]  = "profile_print_requests:NonCatProfilePrintRequests"; 
  
# ----- Catalog Page Views NEW Additions -------- #
 $file[20]  = "product_search_product_line_view:NonCatProductSearchProductLineView"; 
 $file[21]  = "capabilities:NonCatCapabilities"; 
    

# Delete from tables
$query = "delete from thomNonCatConversionslog";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;
           
$query = "delete from thomNonCatConversions$yy where fdate='$fdate'";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
$sth->finish;

# Load files into log file
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
foreach $file (@file)        
 {                               
   ($type,$f) = split(/\:/, $file);
   $infile    = $fyear . "/" . $f . "-" . $fdate . ".txt";
   print "$infile\n";
   open(rf, "$infile")  || die (print "Could not open $infile\n");
   while (!eof(rf))
    {
      $instr = <rf>;
      chop($instr);
 
      ($dt,$acct,$cnt) = split(/\t/,$instr);
      print wf "$dt\t$acct\t$cnt\t$type\n"; 
      $dt = $acct = $cnt = ""; 
   } 
   close(rf); 
 }
close(wf);



system("mysqlimport -diL thomas $DIR/$outfile"); 

  
# Query and load summary table
$query  = " select fdate, acct, ";
$query .= " sum(if(type='brand_search',cnt,0))                 as  brand_search, ";
$query .= " sum(if(type='company_name_search',cnt,0))          as  company_name_search, ";
$query .= " sum(if(type='external_search',cnt,0))              as  external_search, ";
$query .= " sum(if(type='product_search',cnt,0))               as  product_search, ";
$query .= " sum(if(type='supplier_compare',cnt,0))             as  supplier_compare, ";
$query .= " sum(if(type='preview_ad_quickview',cnt,0))         as  preview_ad_quickview, ";
$query .= " sum(if(type='branch_location',cnt,0))              as  branch_location, ";
$query .= " sum(if(type='news_release_links_website',cnt,0))   as  news_release_links_website  , ";
$query .= " sum(if(type='product_search_links_website',cnt,0)) as  product_search_links_website, ";
$query .= " sum(if(type='pdf_view_links_website',cnt,0))       as  pdf_view_links_website, ";
$query .= " sum(if(type='brand_ad_links_website',cnt,0))       as  brand_ad_links_website, ";
$query .= " sum(if(type='all_links_website',cnt,0))            as  all_links_website, ";
$query .= " sum(if(type='tnet_news',cnt,0))               as  tnet_news, ";
$query .= " sum(if(type='tnet_directory',cnt,0))          as  tnet_directory, ";
$query .= " sum(if(type='link_catalog_cad',cnt,0))             as  link_catalog_cad, ";
$query .= " sum(if(type='cad_library',cnt,0))                  as  cad_library, ";
$query .= " sum(if(type='catalog_solution_activity   ',cnt,0)) as  catalog_solution_activity, ";
$query .= " sum(if(type='product_search_item_detail_view',cnt,0)) as  product_search_item_detail_view, ";
$query .= " sum(if(type='directory_email',cnt,0))              as  directory_email, ";
$query .= " sum(if(type='product_search_email',cnt,0))         as  product_search_email, ";
$query .= " sum(if(type='news_email',cnt,0))                   as  news_email, ";
$query .= " sum(if(type='total_emails_colleague_mythomas_saves',cnt,0)) as  total_emails_colleague_mythomas_saves, ";
$query .= " sum(if(type='total_custom_company_profile_actions ',cnt,0)) as  total_custom_company_profile_actions, ";
$query .= " sum(if(type='map_views',cnt,0))                     as  map_views, ";
$query .= " sum(if(type='profile_print_requests',cnt,0))        as  profile_print_requests, ";
$query .= " sum(if(type='product_search_product_line_view',cnt,0))  as  product_search_product_line_view, ";
$query .= " sum(if(type='capabilities',cnt,0))                      as  capabilities ";
$query .= " from thomNonCatConversionslog       ";
$query .= " where fdate='$fdate' and acct>0   ";
$query .= " group by acct ";
open(wf,  ">$outfile2")  || die (print "Could not open $outfile2\n");
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
  print wf "$$row[0]\t";    # date
  print wf "$$row[1]\t";    # acct
  print wf "$$row[2]\t";    # brand_search
  print wf "$$row[3]\t";    # company_name_search
  print wf "$$row[4]\t";    # external_search
  print wf "$$row[5]\t";    # product_search
  print wf "$$row[6]\t";    # supplier_compare
  print wf "$$row[7]\t";    # preview_ad_quickview
  print wf "$$row[8]\t";    # branch_location
  print wf "$$row[9]\t";    # news_release_links_website
  print wf "$$row[10]\t";   # product_search_links_website
  print wf "$$row[11]\t";   # pdf_view_links_website
  print wf "$$row[12]\t";   # brand_ad_links_website
  print wf "$$row[13]\t";   # all_links_website
  print wf "$$row[14]\t";   # tnet_news
  print wf "$$row[15]\t";   # tnet_directory
  print wf "$$row[16]\t";   # link_catalog_cad
  print wf "$$row[17]\t";   # cad_library
  print wf "$$row[18]\t";   # catalog_solution_activity
  print wf "$$row[19]\t";   # product_search_item_detail_view
  print wf "$$row[20]\t";   # directory_email
  print wf "$$row[21]\t";   # product_search_email
  print wf "$$row[22]\t";   # news_email
  print wf "$$row[23]\t";   # total_emails_colleague_mythomas_saves
  print wf "$$row[24]\t";   # total_custom_company_profile_actions
  print wf "$$row[25]\t";   # map_views
  print wf "$$row[26]\t";   # profile_print_requests
  print wf "$$row[27]\t";   # product_search_product_line_view
  print wf "$$row[28]\n";   # capabilities
 }       
$sth->finish;
close(wf);
 
system("mysqlimport -iL thomas $DIR/$outfile2");
#system("rm -f $outfile"); 
#system("rm -f $outfile2"); 

$rc = $dbh->disconnect;

exit;


