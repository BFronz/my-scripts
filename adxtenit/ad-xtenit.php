<?php
date_default_timezone_set('EST');
error_reporting(0);
$link = mysql_pconnect('',  '', '');
if (!$link) {
    die('Not connected : ' . mysql_error());
}

$db_selected = mysql_select_db('thomas', $link);
if (!$db_selected) {
    die ('Select db  : ' . mysql_error());
}

$fdate=$argv[1];

$readfile = "ad_xtenit_data.xml";
if (!($rf = fopen($readfile, "r"))) {  die("could not open XML input"); }

$writefile = "ad_xtenit_data.txt";
if (!($wf = fopen($writefile, "w"))) {  die("could not open XML output"); }

$writefile2 = "ad_xtenit_data_user.txt";
if (!($wf2 = fopen($writefile2, "w"))) {  die("could not open XML output"); }

function ParseLine ($tag){
 global $oneline;

 //if($tag=="ad_views_without_images") { echo "tag: $tag\t$oneline\n"; }
 //if( eregi( "<$tag>", $oneline) )

 if(preg_match("/<$tag>/", $oneline) )
  { 
   //if($tag=="ad_views_without_images") { echo "tag: $tag\toneline: $oneline\n"; } 	 
   $val = ereg_replace("<$tag>",  "", $oneline);
   $val = ereg_replace("</$tag>", "", $val);
   $val = trim($val);
   return $val;
 }
}


function toHTML($val){
        //Replace decoded HTML tags with spaces
        $val    = eregi_replace("&lt;","<",$val);
        $val    = eregi_replace("&gt;",">",$val);
        $val    = eregi_replace("&amp;","&",$val);
        $val    = eregi_replace("&quot;","\"",$val);
        $val    = preg_replace("/<.*?>/", " ", $val);
        return $val;
}

$query  = "select id, acct from thomad_xtenit_id";
$result = mysql_query($query);  
for($i=0; $i < mysql_numrows($result); $i++)
 {  
  $idd           = mysql_result($result, $i, "id");
  $account[$idd] = mysql_result($result, $i, "acct");
  //echo "$idd: $account[$idd]\n";
 }  
 
while (!feof($rf) )
{
 $oneline = fgets($rf, 10000);
 $oneline = trim($oneline);
 #print "$oneline\n";                  
    
 
 if( eregi(" xid=", $oneline) ) 
 { 
   $pts = explode(" ", $oneline); 
   $xid = $pts[2]; 
 
   $xid = preg_replace("/xid=/", "", $xid);
   $xid = preg_replace("/\"/", "", $xid);
   $xid = preg_replace("/\s\s+/", "", $xid);  
   //echo "XID: $xid\n";	
   $acct    = $account[$xid];	
   $thisxid = $xid; 	
   unset($pts);
  } 
  
        
  //if(!$id                ) { $id                = ParseLine ("id");                }
  //if(!$xid               ) { $xid               = ParseLine ("xid");               }
  //if(!$type              ) { $type              = ParseLine ("type");              }
  if(!$places            ) { $places            = ParseLine ("places");            }
  if(!$client            ) { $client            = ParseLine ("client");            }
  if(!$advertisername        ) { $advertisername        = ParseLine ("advertisername");        }
  if(!$alttext           ) { $alttext           = ParseLine ("alttext");           }
  //if(!$msgtext           ) { $msgtext           = ParseLine ("msgtext");           }
  if(!$gifurl            ) { $gifurl            = ParseLine ("gifurl");            }
  if(!$linkurl           ) { $linkurl           = ParseLine ("linkurl");           }
  if(!$lastmod           ) { $lastmod           = ParseLine ("lastmod");           }
  if(!$poster            ) { $poster            = ParseLine ("poster");            }
  if(!$approver          ) { $approver          = ParseLine ("approver");          }
  if(!$extra             ) { $extra             = ParseLine ("extra");             }
  if(!$match             ) { $match             = ParseLine ("match");             }
  if(!$status            ) { $status            = ParseLine ("status");            }
  if(!$startdate         ) { $startdate         = ParseLine ("startdate");         }
  if(!$enddate           ) { $enddate           = ParseLine ("enddate");           }
  if(!$target            ) { $target            = ParseLine ("target");            }
  if(!$clickthrough      ) { $clickthrough      = ParseLine ("clickthrough");      }
  if(!$clickcount        ) { $clickcount        = ParseLine ("clickcount");        }
  if(!$prefrence         ) { $prefrence         = ParseLine ("prefrence");         }
  if(!$summary           ) { $summary           = ParseLine ("summary");           }
  if(!$placements        ) { $placements        = ParseLine ("ad_placecount");             } //
  if(!$delivered         ) { $delivered         = ParseLine ("ad_delivered");              } //
  if(!$uniqueviews       ) { $uniqueviews       = ParseLine ("mail_unique_opened");        } //
  if(!$uniqueclicks      ) { $uniqueclicks      = ParseLine ("ad_unique_clicks");          } 
  if(!$totalclicks       ) { $totalclicks       = ParseLine ("ad_clicks");                  }
  if(!$jobclicknoopen    ) { $jobclicknoopen    = ParseLine ("jobclicknoopen");    }
  if(!$uniquejobclicks   ) { $uniquejobclicks   = ParseLine ("uniquejobclicks");   }
  if(!$totalviews        ) { $totalviews        = ParseLine ("ad_views_with_images");      } //
  if(!$noimageviews      ) { $noimageviews      = ParseLine ("ad_views_without_images");   } //
  if(!$combinedtotalviews) { $combinedtotalviews= ParseLine ("ad_total_views");                 } //
  if(!$campaign          ) { $campaign          = ParseLine ("campaign");                 } //
  
  //if($totalviews) {echo "totalviews: $totalviews\t $xid \n";}

  if( eregi("<msgtext>", $oneline) )  {$msg=1;}
  if($msg)  { preg_replace('/\s+/S', " ", $oneline);  $msgtexta .= $oneline; } 
  if( eregi("</msgtext>", $oneline) ) { $msgtext = $msgtexta; $msg=$msgtexta="";  }

  
  # write main data 
  //if ( ereg("</ad>", $oneline)  ) 
  if ( ereg("</placements>", $oneline)  ) 
   {               

    if($msgtext) 
     {  
      $msgtext =  ereg_replace("\n", "", $msgtext);
      $msgtext =  ereg_replace("\t", "", $msgtext);
      $msgtext =  ereg_replace("<msgtext>", "", $msgtext);  
      $msgtext =  ereg_replace("</msgtext>", "", $msgtext);  
      $msgtext =  toHTML($msgtext); 
      $msgtext =  trim($msgtext); 
      
      /* 
      $flds    = explode("&gt;", $msgtext);
      for($n=0; $n<count($flds); $n++)
       { 
        if( eregi("title", $flds[$n]) ){ $key = $n+1;  $title = $flds[$key]; }
        if( eregi("alt=",  $flds[$n]) ){ $key = $n+1;  $hdd   = $flds[$key]; }
        echo "$flds[$n]\n";
       } 
      unset($flds);    
      */      
     }   
 
   /*
   if($account[$xid]!=""){	
    print "xid: $xid\n";
    print "acct: $account[$xid]\n";
    print "date: $fdate\n";
    print "place;$placements\n";
    print "del: $delivered\n";
    print "Uview: $uniqueviews\n";
    print "Uclicks: $uniqueclicks\n";
    print "tf: $totalclicks\n";
    print "Job: $jobclicknoopen\n";
    print "Ujc: $uniquejobclicks\n";
    print "tv: $totalviews\n";
    print "no: $noimageviews\n";
    print "comb: $combinedtotalviews\n";
    sleep(1);	
    } 
   */	
  
  
    //fputs($wf,  "$fdate\t$xid\t$account[$xid]\t$id\t$type\t$places\t$client\t$advertiser\t$alttext\t$msgtext\t$gifurl\t$linkurl\t$lastmod\t$poster\t$approver\t$extra\t$match\t$status\t$startdate\t$enddate\t$target\t$clickthrough\t$clickcount\t$prefrence\t$summary\t$placements\t$delivered\t$uniqueviews\t$uniqueclicks\t$totalclicks\t$jobclicknoopen\t$uniquejobclicks\t$totalviews\t$noimageviews\t$combinedtotalviews\t$title\t$hdd\n"); 
 
    //print "$fdate\t$thisxid\tacct:$acct\t$id\t$type\t$totalviews\t$noimageviews\t$combinedtotalviews\n"; 	
    //fputs($wf,  "$fdate\t$thisxid\t$acct\t$id\t$type\t$places\t$client\t$advertisername\t$alttext\t$msgtext\t$gifurl\t$linkurl\t$lastmod\t$poster\t$approver\t$extra\t$match\t$status\t$startdate\t$enddate\t$target\t$clickthrough\t$clickcount\t$prefrence\t$summary\t$placements\t$delivered\t$uniqueviews\t$uniqueclicks\t$totalclicks\t$jobclicknoopen\t$uniquejobclicks\t$totalviews\t$noimageviews\t$combinedtotalviews\t$title\t$hdd\t$campaign\n"); 

    print "$fdate\t$thisxid\tacct:$client\t$id\t$type\t$totalviews\t$noimageviews\t$combinedtotalviews\n"; 	
    fputs($wf,  "$fdate\t$thisxid\t$client\t$id\t$type\t$places\t$client\t$advertisername\t$alttext\t$msgtext\t$gifurl\t$linkurl\t$lastmod\t$poster\t$approver\t$extra\t$match\t$status\t$startdate\t$enddate\t$target\t$clickthrough\t$clickcount\t$prefrence\t$summary\t$placements\t$delivered\t$uniqueviews\t$uniqueclicks\t$totalclicks\t$jobclicknoopen\t$uniquejobclicks\t$totalviews\t$noimageviews\t$combinedtotalviews\t$title\t$hdd\t$campaign\n"); 
    
  
	$title=$hdd=$type=$places=$client=$advertisername=$alttext=$msgtext=$gifurl=$linkurl=$lastmod=$poster=$approver=$extra=$match=$status=$startdate=$enddate=$target=$clickthrough=$clickcount=$prefrence=$summary=$placements=$delivered=$uniqueviews=$uniqueclicks=$totalclicks=$jobclicknoopen=$uniquejobclicks=$totalviews=$noimageviews=$combinedtotalviews=$campaign=""; 
  
   }   
           


  # write user data
  if ( eregi("<entry >",  $oneline) )  { $startuser = 1;  }   
  if ( eregi("</entry>", $oneline) )  { $startuser = ""; }
  if($startuser == 1)
   {   
 
    if(!$firstname)   { $firstname   = ParseLine ("firstname");}
    if(!$lastname)    { $lastname    = ParseLine ("lastname");}
    if(!$companyname) { $companyname = ParseLine ("companyname");}
    if(!$country)     { $country     = ParseLine ("country");}
    if(!$zipcode)     { $zipcode     = ParseLine ("zipcode");}
    if(!$cookie)      { $cookie      = ParseLine ("cookie");}
    if(!$jobfunction) { $jobfunction = ParseLine ("jobfunction");  }
    if(!$industry)    { $industry    = ParseLine ("industry");  }

    /* 
    if( eregi( "<record email", $oneline) )
    {
     $flds = explode("=",$oneline);
     $user_email =   ereg_replace("\"",  "", trim($flds[1]));
     $user_email =   ereg_replace(" action",  "", trim($user_email));
     unset($flds);
    }

    if( eregi( "<email delivery", $oneline) )
    {
     $flds = explode("=",$oneline);
     $user_del = ereg_replace("\"",  "", trim($flds[1]));
     $user_del = ereg_replace("freq", "", trim($user_del));
     $user_del = ereg_replace("/>", "", trim($user_del));

     $user_freq = ereg_replace("\"",  "", trim($flds[2]));
     $user_freq = ereg_replace("/>", "", trim($user_freq)); 

     unset($flds);
    }
    */

    if ( eregi("</user>", $oneline)  )
     {       
      //echo "$fdate\t$thisxid\t$acct\t$lastname\t$companyname\n";
     //fputs($wf2, "$fdate\t$xid\t$account[$xid]\t$id\t$firstname\t$lastname\t$companyname\t$country\t$zipcode\t$cookie\t$jobfunction\t$industry\t$user_email\t$user_del\t$user_freq\n");
	fputs($wf2, "$fdate\t$thisxid\t$acct\t$id\t$firstname\t$lastname\t$companyname\t$country\t$zipcode\t$cookie\t$jobfunction\t$industry\t$user_email\t$user_del\t$user_freq\n");
      $firstname=$lastname=$companyname=$country=$zipcode=$cookie=$jobfunction=$industry=$user_email=$user_del=$user_freq ="";
     }   
   } 

  # Remove temp id used in user data                                
  //if ( ereg("</ad>", $oneline) ) { $xid = $id = ""; }  
 

}

fclose($rf);
fclose($wf);
fclose($wf2);

  /*
  Placements  <ad_placecount>
  Total Delivered <ad_delivered>
  Unique Views w/Images  <mail_unique_opened>
  Unique Views No Image   <mail_unique_no_opened>
  Total Unique Views  <ad_views_with_images>
  Total Views w/Images   <ad_views_with_images>
  Total No Image Views   <ad_views_without_images>
  Combined Total Views <ad_total_views> 
  Unique Clicks  <ad_unique_clicks>
  Total Clicks   <ad_clicks>
  
  Per Brian McFadden 8/24/11
  Placements              - <ad_placecount>            - placements
  Total Delivered         - <ad_delivered>             - delivered 
  Unique Views w/Images   - <ad_views_with_images>     - totalviews
  Unique Views No Image   - <ad_views_without_images>  - noimageviews
  Total Unique Views - We do not provide directly but assume <ad_views_with_images> + <ad_views_without_images>  - totalviews + noimageviews 
  Total Views w/Images -  We dont provide  
  Total No Image Views - We dont provide
  Combined Total Views - <ad_total_views>  - combinedtotalviews   
  Unique Clicks  - <ad_unique_clicks>      - uniqueclicks  
  Total Clicks  - <ad_clicks>              - totalclicks
 
  Placements              <ad_placecount>              $placements  
  Total Delivered         <ad_delivered>               $delivered   
  Unique Views w/Images   <mail_unique_opened>         $uniqueviews  
  Unique Views No Image   <mail_unique_no_opened>      $noimageviews
  Total Unique Views      <ad_views_with_images>       $totaluniqueviews = $uniqueviews + $noimageviews;    
  Total Views w/Images    <ad_views_without_images>    $totalviews
  Total No Image Views    <ad_views_without_images>    $totalnoimageviews = $combinedtotalviews - $totalviews;
  Combined Total Views    <ad_total_views>             $combinedtotalviews
  Unique Clicks           <ad_unique_clicks>           $uniqueclicks  
  Total Clicks            <ad_clicks>                  $combinedtotalviews  
  */
?>

