<?
 // php -q iptest.php
 
 $ip="12.147.193.6";

 $wtdbserver = "";  // or localhost
 $wtdbuser = "";
 $wtdbpassword = "";
 $wtdb = $wtdbname = "pphlogger";
 $wtusers = "pphl_users";
 $wtdbconn = mysql_connect($wtdbserver, $wtdbuser, $wtdbpassword);
 if (!$wtdbconn) { die('Not connected : ' . mysql_error()); }

 mysql_select_db($wtdb, $wtdbconn)
         or die("Database select failed<p>\n");
  
   $q = "SELECT l.*";
   $q .= " FROM ipmapping AS m, iplookup AS l";
   $q .= " WHERE m.ipfrag=substring_index('$ip[$i]','.',2) AND m.ipstart=l.ipstart AND m.ipend=l.ipend";
   $q .= " AND inet_aton('$ip[$i]') BETWEEN l.ipstart AND l.ipend";
   $q .= " ORDER BY l.ipstart";
   $result = mysql_query($q);
   if (mysql_numrows($result) == 1)
   {
     $ccode = mysql_result($result, 0, "country_code");
     $cname = mysql_result($result, 0, "country_name");
     $reg = mysql_result($result, 0, "region");
     $city = mysql_result($result, 0, "city");
     $lat = mysql_result($result, 0, "latitude");
     $long = mysql_result($result, 0, "longitude");
     $zip = mysql_result($result, 0, "zipcode");
     $isp = mysql_result($result, 0, "isp_name");
     $domain = mysql_result($result, 0, "domain_name");
   }
 
  echo "IP Info: $domain $isp $cname  $ccode ";
?>
 
