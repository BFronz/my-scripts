#!/usr/bin/perl
#
#

use DBI;
use POSIX;
$dbh = DBI->connect("", "", "");

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}
$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);

sub PrintQ
{
 $q = $_[0];
# print "\n$q\n";
}

$outfile = "all-advertisers-" . $fdate . "-data-new.txt";
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");

print wf "Company\t";
print wf "TGRAMS#\t";

# Columns from Visitor Activity Report
print wf "Total Links to Website\t";
print wf "Total Profile Views\t";
print wf "Total Emails to Supplier\t";
print wf "Total Emails to Colleague\t";
print wf "Total CCP Actions\t";
print wf "Total Links to Catalog\t";
print wf "Total on tnet Catalog Page Views\t";
print wf "Total on tnet Catalog RFI/RFO/RFQ\t";
print wf "Total News Release Views\t";
print wf "Total News Release Links to Website\t";
print wf "Total Ad Clicks\t";
print wf "At Category Links to Website\t";
print wf "At Category Profile Views\t";
print wf "At Category Emails to Supplier\t";
print wf "At Category Emails to Colleague\t";
print wf "At Category CCP Actions\t";
print wf "At Category Links to Catalog\t";
print wf "At Category on tnet Catalog Page Views\t";
print wf "Total Non-Category Conversion Count\t";

# Columns from Supplier Non-Category Conversion Report
print wf "Non-Category Brand Search\t";
print wf "Non-Category Company Name Search\t";
print wf "Non-Category External Search\t";
print wf "Non-Category Product Search\t";
print wf "Non-Category Supplier Compare\t";
print wf "Non-Category Preview Ad Quickview\t";
print wf "Non-Category Branch Location\t";
print wf "Non-Category General Links to Website\t";
print wf "Non-Category News Release Links to Website\t";
print wf "Non-Category Product Search Links to Website\t";
print wf "Non-Category PDF View Links to Website\t";
print wf "Non-Category Brand Ad Links to Website\t";
print wf "Non-Category tnet News\t";
print wf "Non-Category General Links to Catalog\t";
print wf "Non-Category CAD Library\t";
print wf "Non-Category Catalog Solution Activity\t";
print wf "Non-Category Product Search Item Detail & Product Line Views\t";
print wf "Non-Category Directory Email\t";
print wf "Non-Category Product Search Email\t";
print wf "Non-Category News Email\t";
print wf "Non-Category Total emails to Colleague & MyThomas Saves\t";
print wf "Non-Category Total Custom Company Profile Actions\t";
print wf "Non-Category Map Views\t";
print wf "Non-Category Profile Print Requests\t";
print wf "Non-Category Total Non-Category Conversions\n";

$i=0;
$query  = "SELECT company,acct FROM tgrams.main WHERE adv>'' and acct>0  ";
#$query  .= "AND acct='10111455' "; # for testing
$query  .= "ORDER BY company ";
# $query  .= "LIMIT 10 "; # for testing
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $record[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;

$z=1;
foreach $record (@record)
{
 print "$z) $record\n";
 ($comp,$acct) = split(/\|/,$record);

 $acctmap = "0";
 $q = "SELECT dupe FROM tgrams.main_map WHERE prime='$acct' ";
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $acctmap = "$$row[0],";
  }
 $sth->finish;
 $acctmap .= $acct;

 $links = $profile = $email = $ecoll = $ccp = $linkscatalog = $total_top_conv = $total_top_cad =  $total_top_prodcat = 0;
 $q  = "SELECT sum(ln) AS links, sum(pv) AS profile, sum(ca) AS email, ";
 $q .= "sum(ec) AS ecoll,  sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) AS ccp, ";
 #$q .= "sum(lc) AS linkscatalog, ";
 $q .= "SUM(lc)+SUM(cl)  AS linkscatalog, ";
 $q .= "sum(pv) + sum(ln) + sum(cl) + sum(cv) + sum(ec) + sum(ca) + sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) + sum(lc) as tot , "; 
 $q .= "sum(cd) as cad , ";
 $q .= "sum(pc) as prodcat ";
 $q .= "FROM tnetlogARTU$yy WHERE acct in ($acctmap) and date = '$fdate' and covflag='t' ";
 PrintQ($q); 
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $links              = $$row[0];
   $profile            = $$row[1];
   $email              = $$row[2];
   $ecoll              = $$row[3];
   $ccp                = $$row[4];
   $linkscatalog       = $$row[5];
   $total_top_conv     = $$row[6];
   $total_top_cad      = $$row[7];
   $total_top_prodcat  = $$row[8];
  } 
 $sth->finish;

 $totalpageviews = $totalemailpage = 0;
 $q  = "SELECT SUM(totalpageviews) AS totalpageviews, sum(totalInq + totalordrfqs) as totalemailpage ";
 $q .= "FROM thomflat_catnav_summmary$yy WHERE tgramsid IN ($acctmap) AND isactive='yes' AND date='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $totalpageviews = $$row[0];
   $totalemailpage = $$row[1];
  }
 $sth->finish;
 if($totalpageviews eq "") { $totalpageviews = "0";} if($totalemailpage eq "") {$totalemailpage = "0";}


 $newsviews = $linksweb = $totnews = 0;
 $q = "SELECT sum(nsv) AS newsviews, sum(nlw)  AS linksweb,  sum(nsv) + sum(ncc) + sum(nes) + sum(nlw) AS totnews FROM thomnews_conversions$yy WHERE acct IN ($acctmap) AND date='$fdate' ";
 PrintQ($q); 
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $newsviews = $$row[0];
   $linksweb  = $$row[1];
   $totnews   = $$row[2]; 
  }
 if($newsviews eq ""){$newsviews = "0";} if($linksweb eq ""){$linksweb = "0";}  if($totnews eq ""){$totnews = "0";} 

 $adclicks = 0;
 $q = "SELECT sum(BannerClicks) AS adclicks FROM thomnews_ad_cat$yy WHERE AdvertiserCid in ($acctmap) AND date='$fdate' AND badimg='N' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks = $$row[0];
  }
 $q = "SELECT sum(clicks) AS adclicks FROM thomtnetlogADviewsServer$yy WHERE acct IN ($acctmap) AND adtype ='pai' AND fdate='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
  }
 $q = "SELECT sum(clicks) AS adclicks FROM thomtnetlogADviewsServer$yy WHERE acct IN ($acctmap) AND adtype ='bad' AND fdate='$fdate' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $adclicks += $$row[0];
  }


 $qtable  = "qlog" . $yy . "Y";
 $hdlinks = $hdprofile = $hdemail = $hdecoll = $hdccp = $hdlinkscatalog = $hdlinksviews = 0;
 $q  = "SELECT sum(lw) AS links,  sum(pv) AS profile, sum(em) as email, sum(ec) as ecoll, ";
 $q .= "sum(vv) + sum(dv) + sum(iv) + sum(sm) + sum(pp) + sum(mv) AS ccp, ";
 $q .= "sum(lc) + sum(cd) AS linkcatalog, sum(pc) AS catalogviews ";
 $q .= "FROM $qtable AS u, headings_history AS h ";
 $q .= "WHERE acct IN ($acctmap) AND u.heading=h.heading AND date='$fdate' AND covflag='t' ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {
   $hdlinks        = $$row[0];
   $hdprofile      = $$row[1];
   $hdemail        = $$row[2];
   $hdecoll        = $$row[3];
   $hdccp          = $$row[4];
   $hdlinkscatalog = $$row[5];
   $hdlinksviews   = $$row[6];
  }
 $sth->finish;


  
 $total_conversions  = $total_non_cat_conversions = $total_non_cat_conv = 0;
 $total_conversions  = $total_top_conv + $totnews + $adclicks + $totalpageviews +  $totalemailpage ;
 $total_non_cat      = $hdlinks + $hdprofile + $hdemail + $hdecoll + $hdccp + $hdlinkscatalog + $hdlinksviews;
 $total_non_cat_conversions = $total_conversions - $total_non_cat ;
  #print "\nT: $total_conversions\n";  print "HD: $total_non_cat\n"; print "$total_non_cat_conversions\n";
   
 
 $brand_search                          = $company_name_search       = $external_search        = $product_search  = 0;
 $supplier_compare                      = $preview_ad_quickview      = $branch_location        = $news_release_links_website = 0;
 $product_search_links_website          = $pdf_view_links_website    = $brand_ad_links_website = 0;
 $all_links_website                     = $tnet_news            = $tnet_directory    = $link_catalog_cad = 0;
 $cad_library                           = $catalog_solution_activity = $product_search_item_detail_view = 0;
 $directory_email                       = $product_search_email       = $news_email = 0;
 $total_emails_colleague_mythomas_saves = $total_custom_company_profile_actions = $map_views = 0;
 $profile_print_requests                = $product_search_product_line_view = $capabilities = $noncattotal = 0;
 $q  = "SELECT ";
 $q .= "sum(brand_search) as brand_search, ";
 $q .= "sum(company_name_search) as company_name_search,";
 $q .= "sum(external_search) as external_search,";
 $q .= "sum(product_search) as product_search, ";
 $q .= "sum(supplier_compare) as supplier_compare, ";
 $q .= "sum(preview_ad_quickview) as preview_ad_quickview, ";
 $q .= "sum(branch_location) as branch_location, ";
 $q .= "sum(news_release_links_website) as news_release_links_website, ";
 $q .= "sum(product_search_links_website) as product_search_links_website, ";
 $q .= "sum(pdf_view_links_website) as pdf_view_links_website, ";
 $q .= "sum(brand_ad_links_website) as brand_ad_links_website, ";
 $q .= "sum(all_links_website) as all_links_website, ";
 $q .= "sum(tnet_news) as tnet_news, ";
 $q .= "sum(tnet_directory) as tnet_directory, ";
 $q .= "sum(link_catalog_cad) as link_catalog_cad, ";
 $q .= "sum(cad_library) as cad_library, ";
 $q .= "sum(catalog_solution_activity) as catalog_solution_activity, ";
 $q .= "sum(product_search_item_detail_view) as product_search_item_detail_view, ";
 $q .= "sum(directory_email) as directory_email, ";
 $q .= "sum(product_search_email) as product_search_email, ";
 $q .= "sum(news_email) as news_email, ";
 $q .= "sum(total_emails_colleague_mythomas_saves) as total_emails_colleague_mythomas_saves, ";
 $q .= "sum(total_custom_company_profile_actions) as total_custom_company_profile_actions, ";
 $q .= "sum(map_views) as map_views, ";
 $q .= "sum(profile_print_requests) as profile_print_requests, ";
 $q .= "sum(product_search_product_line_view) as product_search_product_line_view, ";
 $q .= "sum(capabilities) as capabilities, ";
 $q .= "brand_search + company_name_search + external_search + product_search + supplier_compare +
        preview_ad_quickview + branch_location + news_release_links_website + product_search_links_website +
        pdf_view_links_website + brand_ad_links_website + all_links_website + tnet_news + tnet_directory +
        link_catalog_cad + cad_library + catalog_solution_activity + product_search_item_detail_view +
        directory_email + product_search_email + news_email + total_emails_colleague_mythomas_saves +
        total_custom_company_profile_actions + map_views + profile_print_requests + product_search_product_line_view AS noncattotal ";
 $q .= "FROM thomNonCatConversions$yy ";
 $q .= "WHERE acct in ($acctmap) AND fdate='$fdate' ";
 $q .= "GROUP BY acct ";
 PrintQ($q);
 my $sth = $dbh->prepare($q);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {
  $brand_search                           = $$row[0];
  $company_name_search                    = $$row[1];
  $external_search                        = $$row[2];
  $product_search                         = $$row[3];
  $supplier_compare                       = $$row[4];
  $preview_ad_quickview                   = $$row[5];
  $branch_location                        = $$row[6];
  $news_release_links_website             = $$row[7];
  $product_search_links_website           = $$row[8];
  $pdf_view_links_website                 = $$row[9];
  $brand_ad_links_website                 = $$row[10];
  $all_links_website                      = $$row[11];
  $tnet_news                         = $$row[12];
  $tnet_directory                    = $$row[13];
  $link_catalog_cad                       = $$row[14];
  $cad_library                            = $$row[15];
  $catalog_solution_activity              = $$row[16];
  $product_search_item_detail_view        = $$row[17];
  $directory_email                        = $$row[18];
  $product_search_email                   = $$row[19];
  $news_email                             = $$row[20];
  $total_emails_colleague_mythomas_saves  = $$row[21];
  $total_custom_company_profile_actions   = $$row[22];
  $map_views                              = $$row[23];
  $profile_print_requests                 = $$row[24];
  $product_search_product_line_view       = $$row[25];
  $capabilities                           = $$row[26];
  $noncattotal                            = $$row[27];
 }
 $sth->finish;

 $general_links = 0;
 $general_links =  $all_links_website - ($news_release_links_website + $product_search_links_website + $pdf_view_links_website + $brand_ad_links_website);

 $product_search_tot = 0;
 $product_search_tot = $product_search_item_detail_view + $product_search_product_line_view;

 $noncattotal -=  ($news_release_links_website + $product_search_links_website + $pdf_view_links_website + $brand_ad_links_website) ;
 
 print wf "$comp\t";                                  # company
 print wf "$acct\t";                                  # acct

 print wf "$links\t";                                 # Total Links to Website
 print wf "$profile\t";                               # Total Profile Views
 print wf "$email\t";                                 # Total Emails to Supplier
 print wf "$ecoll\t";                                 # Total Emails to Colleague
 print wf "$ccp\t";                                   # Total CCP Actions
 print wf "$linkscatalog\t";                          # Total Links to Catalog
 print wf "$totalpageviews\t";                        # Total on tnet Catalog Page Views
 print wf "$totalemailpage\t";                        # Total on tnet Catalog RFI/RFO/RFQ
 print wf "$newsviews\t";                             # Total News Release Views
 print wf "$linksweb\t";                              # Total News Release Links to Website
 print wf "$adclicks\t";                              # Total Ad Clicks
 print wf "$hdlinks\t";                               # At Category Links to Website
 print wf "$hdprofile\t";                             # At Category Profile Views
 print wf "$hdemail\t";                               # At Category Emails to Supplier
 print wf "$hdecoll\t";                               # At Category Emails to Colleague
 print wf "$hdccp\t";                                 # At Category CCP Actions
 print wf "$hdlinkscatalog\t";                        # At Category Links to Catalog
 print wf "$hdlinksviews\t";                          # At Category on tnet Catalog Page Views
 print wf "$total_non_cat_conversions\t";             # Total Non-Category Conversion Count

 print wf "$brand_search\t";                          # Brand Search
 print wf "$company_name_search\t";                   # Company Name Search
 print wf "$external_search\t";                       # External Search
 print wf "$product_search\t";                        # Product Search

 print wf "$supplier_compare\t";                      # Supplier Compare
 print wf "$preview_ad_quickview\t";                  # Preview Ad Quickview
 print wf "$branch_location\t";                       # Branch Location

 print wf "$general_links\t";                         # General Links to Website
 print wf "$news_release_links_website\t";            # News Release Links to Website
 print wf "$product_search_links_website\t";          # Product Search Links to Website
 print wf "$pdf_view_links_website\t";                # PDF View Links to Website
 print wf "$brand_ad_links_website\t";                # Brand Ad Links to Website

 print wf "$tnet_news\t";                        # tnet News

 print wf "$link_catalog_cad\t";                      # General Links to Catalog
 print wf "$cad_library\t";                           # CAD Library

 print wf "$catalog_solution_activity\t";             # Catalog Solution Activity
 print wf "$product_search_tot\t";                    # Product Search Item Detail & Product Line Views

 print wf "$directory_email\t";                       # Directory Email
 print wf "$product_search_email\t";                  # Product Search Email
 print wf "$news_email\t";                            # News Email

 print wf "$total_emails_colleague_mythomas_saves\t"; # Total emails to Colleague & MyThomas Saves

 print wf "$total_custom_company_profile_actions\t";  # Total Custom Company Profile Actions

 print wf "$map_views\t";                             # Map Views

 print wf "$profile_print_requests\t";                # Profile Print Requests

 print wf "$noncattotal\t";                           # Total Non-Category Conversions\n";

 print wf "\n";

 $z++;
}

close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
