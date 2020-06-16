<?
/*****************************************************************************
 * File:        NetAcuity.php
 * Author:      Digital Envoy
 * Program:     NetAcuity PHP API
 * Version:     4.11
 * Date:        07/21/2004
 * 
 * Copyright 2000-2005, Digital Envoy, Inc.  All rights reserved.
 *
 * This library is provided as an access method to the NetAcuity software
 * provided to you under License Agreement from Digital Envoy Inc.
 * You may NOT redistribute it and/or modify it in any way without express
 * written consent of Digital Envoy, Inc.
 *
 * Address bug reports and comments to:  tech-support@digitalenvoy.net
 *
 *
 *
 * Description: This class can be used to interfaces to the NetAcuity server.
 * 
 * Revision Histroy:
 * ---------------------------
 * 
 * $Log: NetAcuity.php,v $
 * Revision 1.7  2005/01/05 19:00:33  tmcneese
 * Update comments, copyright and version.
 *
 * Revision 1.6  2004/10/28 14:12:09  rcabrera
 * Adding Canadian Zip Support
 *
 * Revision 1.5  2004/08/04 18:38:24  tmcneese
 * Cleanup.
 *
 * Revision 1.4  2004/08/04 18:14:29  tmcneese
 * Support for new geo fields.
 *
 * Revision 1.3  2004/08/03 21:45:35  tmcneese
 * Added support for the second language field in the language database.
 *
 * Revision 1.2  2004/07/29 18:04:26  tmcneese
 * Added commments.
 *
 * Revision 1.1  2004/07/29 15:39:15  tmcneese
 * Updated PHP API to support new databases and XML interface into
 * the NetAcuity Server.
 *
 *
 *
 *
 ****************************************************************************/ 

define ("NA_UDP_PORT",         5400);
define ("MAX_RESPONSE_SIZE",   1496);

define ("RAW_DEFAULT",         1);
define ("NA_GEO_DB",           3);
define ("NA_SIC_DB",           5);
define ("NA_DOMAIN_DB",        6);
define ("NA_ZIP_DB",           7);
define ("NA_ISP_DB",           8);
define ("NA_HOME_BIZ_DB",      9);
define ("NA_ASN_DB",          10);
define ("NA_LANGUAGE_DB",     11);
define ("NA_PROXY_DB",        12);
define ("NA_ISANISP_DB",      14);
define ("NA_COMPANY_DB",      15);
define ("NA_DEMOGRAPHICS_DB", 17);
define ("NA_NAICS_DB",        18);
define ("NA_CBSA_DB",         19);


// 
// NetAcuity - Main NetAcuity API class. This class is the parent of
//             all of the database specific sub classes.
//
class NetAcuity
{
  var $isDebugOn = FALSE; 
  var $timeout;
  var $id;
  var $naVersion;
  var $naServerIPAddr;
  var $errorCode;
  var $errorMessage;

  // NOTE : --- THE FOLLOWING WERE LEFT IN FOR BACKWARD COMPATIBILITY.   ---
  //            THEY WILL BE REMOVED IN FUTURE RELEASES.
  //            USE THE DATABASE SPECIFC CLASS.
  var $country;
  var $country_conf;
  var $region;
  var $region_conf;
  var $city;
  var $city_conf;
  var $connectionSpeed;
  var $metro_code;
  var $latitude;
  var $longitude;
  var $response_size;
  var $num_response_fields;
  var $raw_response;
  var $domain;
  var $sic;
  var $area_code;
  var $zip;
  var $zip_code_text;
  var $current_offset;
  var $in_dst;
  var $isp;
  var $home_biz;
  // END NOTE --- END OF BACKWARD COMPATIBILITY ---

  // Constructor
  function NetAcuity()
  {
    // Initialize Various Objects
    $this->timeout        = 1;    // Seconds.
    $this->id             = 0;
    $this->naServerIPAddr = 0;
  }

  /* To turn on debugging..not much debugging in this code. */
  function debugOn()
  {
    $this->isDebugOn = true;
  }

  /* Shut the Debugging off */
  function debugOff()
  {
    $this->isDebugOn = false;
  }

  /* Call to write out debugging code. */
  function debug($message)
  {
    if ($this->isDebugOn == true)
    {
      echo($message);
    }
  }

  function set_server_addr($naServerIPAddr)
  {
    $this->naServerIPAddr = $naServerIPAddr;
  }

  function set_id($id)
  {
    $this->id = $id;
  }

  function set_timeout($timeout)
  {
    $this->timeout = $timeout; // Seconds
  }


  /* Sets the default response for the different queries. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED  ---
  function set_default($db_code)
  {
      if ($db_code == NA_GEO_DB)
      {
          /* Default response for Geo DB query */ 
          // Initialize responses
         $this->country         = "?";
         $this->country_conf    = 0; 
         $this->region          = "?";
         $this->region_conf     = 0;
         $this->city            = "?";
         $this->city_conf       = 0;
         $this->connectionSpeed = "?";
         $this->metro_code      = 0;
         $this->latitude        = 0.0;
         $this->longitude       = 0.0;
      }
      elseif ($db_code == NA_DOMAIN_DB)
      {
          /* Default response for Domain DB query */ 
          $this->domain = "?";
      }
      elseif ($db_code == NA_SIC_DB)
      {
          /* Default response for SIC DB query */
          $this->sic = 0;
      }
      elseif ($db_code == NA_ZIP_DB)
      {
          $this->area_code      = 0;
          $this->zip_code       = 0;
          $this->current_offset = 9999;
          $this->is_dst         = "?";
          $this->zip_code_text  = "?";
      }
      elseif ($db_code == NA_ISP_DB)
      {
          $this->isp = "?";
      }
      elseif ($db_code == NA_HOME_BIZ_DB)
      {
          $this->home_biz = "?";
      }
      elseif ($db_code == RAW_DEFAULT)
      {
          /* Default for using the raw function */
          $this->response_size       = 0;
          $this->num_response_fields = 0;
          $this->raw_response        = "NA;";
      }
  }

  /* Query the NA DB and get back the raw response. 
   * can use the get functions below to retrieve the information.
   * The function will give the size of the response (including the '\n'
   * that is appended to the end of the response), the number of fields in
   * in the response, and the response itself.
  */
  function na_query_raw($incomingIPAddr, $db_feature)
  {   
      $this->set_default(RAW_DEFAULT);
      if (($db_feature >= 500) || ($db_feature < 1))
      {
          $this->debug("NetAcuity Error db feature code not define correctly.<BR>"); 
          return 0;
      }

      $naFd = fsockopen("udp://" . $this->naServerIPAddr, 
            NA_UDP_PORT, $errno, $errstr, $this->timeout);

      if(!$naFd)
      {
          $this->debug("NetAcuity Error (" . $errno . ")" 
                       . $errstr . "<br>");
      
          return 0;
      }

      $requestBuffer = sprintf("%d;%d;%s\r\n", 
                   $db_feature, $this->id , $incomingIPAddr);
      
      fputs($naFd, $requestBuffer);
      $start          = time();
      socket_set_timeout($naFd, $this->timeout);

      $sizeFieldsBuff = fread($naFd, 4);

      if ($sizeFieldsBuff == FALSE)
      {
          //$this->debug("Error in fread from socket<br>");
          return 0;
      }
      
      $size_bin                  = substr($sizeFieldsBuff, 0, 2);
      $size                      = unpack("nsize", $size_bin);
      $this->response_size       = $size["size"];
      $fields_bin                = substr($sizeFieldsBuff, 2, 2);
      $num_fields                = unpack("nfields", $fields_bin);
      $this->num_response_fields = $num_fields["fields"];
     
      if ($size["size"] > 0)
      {
          $response = fgets($naFd, $size["size"]);
          //$response = substr($responseBuff, 4, $size["size"]);
      }
      // For the possible "NA" response from querying an unloaded db    
      else
      {
          // For the possible "NA" response from querying an unloaded db    
          $response = fgets($naFd, 3);
      }

      $this->raw_response = $response; 
      fclose($naFd);
      return 1;
  }

  function getErrorCode()
  {
      return($this->errorCode);
  }

  function getErrorMessage()
  {
      return ($this->errorMessage);
  }

  function isError($returnObject)
  {
      return (is_object($returnObject) &&
             (get_class($returnObject) == NETACUITY_ERROR ||
             is_subclass_of($returnObject, NETACUITY_ERROR)));
  }

  /* Returns the size of the raw response. */
  function get_size()
  {
      return ($this->response_size);
  }
  /* Returns the number of fields in the raw response */
  function get_num_fields()
  {
      return ($this->num_response_fields);
  }
  /* Returns the raw response itself */
  function get_raw_response()
  {
      return ($this->raw_response);
  }

  // -----------------------------------------------------------------------
  // NOTE --- THE FOLLOWING FUNCTIONS ARE LEFT IN FOR BACKWARD COMPATIBLITY.
  //          THE WILL BE REMOVED IN A FUTURE RELEASE.
  //          USE THE DATABASE SPECIFIC CLASS.
  // -----------------------------------------------------------------------


  /*
   * Parses the information for the Geo function into country, region,
   * city, etc.
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function parse_geo($geo_response)
  {
      if(strlen($geo_response) < 5)
      {
          return 0;  // Timeout
      }
      
      if(($field = strtok($geo_response, ";")) == null)
      {
          return 0;
      }
      else
      {
          $this->country = substr($field,0,3);
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->region = substr($field,0,31);
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->city = substr($field,0,31);
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->connectionSpeed = substr($field, 0,10);
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->country_conf = $field;
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->region_conf = $field;
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->city_conf = $field;
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->metro_code = $field;
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->latitude = $field;
      }

      if(($field = strtok(";")) == null)
      {
          return 0;
      }
      else
      {
          $this->longitude = $field;
      }
      return 1;
  }

  /* This function queries the NA Geo DB.
   * The response is put in the varibales that can be
   * returned using the get functions below.
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function na_query_geo($ip_addr)
  {
      $ret = $this->na_query_raw($ip_addr, NA_GEO_DB);
      $this->set_default(NA_GEO_DB);
      if ((!$ret) || ($this->response_size == 0))
      {
          return 0;
      }

      if ($this->parse_geo($this->raw_response) == 0)
      {
          return 0;
      }
      return 1;
  }

  /* This function queries the NA Sic Db.
   * The sic variable is filled in and can be returned
   * by using the get_sic() function below.
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function na_query_sic($ip_addr)
  {
      $ret = $this->na_query_raw($ip_addr, NA_SIC_DB);
      $this->set_default(NA_SIC_DB);
      if ((!$ret) || ($this->response_size == 0))
      { 
          return 0;
      }

      if(($this->sic = strtok($this->raw_response, ";")) == null)
      {
          return 0;
      }
      return 1;
  }
  
  /* This function queries the NA Domain DB.
   * The domain variable is returned and will be returned
   * using the get_domain() function below.
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function na_query_domain($ip_addr)
  {
      $ret = $this->na_query_raw($ip_addr, NA_DOMAIN_DB);
      $this->set_default(NA_DOMAIN_DB);
      if ((!$ret) || ($this->response_size == 0))
      { 
          return 0;
      }

      if(($this->domain = strtok($this->raw_response, ";")) == null)
      {
          return 0;
      }
      return 1;
  }
  /* This function queries the NA Zip DB.
   * The area_code, zip, and timezone information
   * is filled in.
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function na_query_zip($ip_addr)
  {
      $ret = $this->na_query_raw($ip_addr, NA_ZIP_DB);
      $this->set_default(NA_ZIP_DB);
      if ((!ret) || ($this->response_size == 0))
      {
          return 0;
      }
          
      if(($this->area_code = strtok($this->raw_response, ";")) == null)
      {
          return 0;
      }

      if(($this->zip = strtok(";")) == null)
      {
          return 0;
      }

      if(($this->current_offset = strtok(";")) == null)
      {
          return 0;
      }

      if(($this->in_dst = strtok(";")) == null)
      {
          return 0;
      }
      
      if ($this->get_num_fields() > 4)
      {
          if(($this->zip_code_text = strtok(";")) == null)
          {
              return 0;
          }
      }      
      return 1;

  }

  /* This function queries the NA ISP DB
   * The ISP variable is filled in.
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function na_query_isp($ip_addr)
  {
      $ret = $this->na_query_raw($ip_addr, NA_ISP_DB);
      $this->set_default(NA_ISP_DB);
      if ((!ret) || ($this->response_size == 0))
      {
          return 0;
      }
          
      if(($this->isp = strtok($this->raw_response, ";")) == null)
      {
          return 0;
      }
      return 1;
   }

  /* This function queries the NA Home/Biz DB
   * The home_biz variable is filled in
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function na_query_home_biz($ip_addr)
  {
      $ret = $this->na_query_raw($ip_addr, NA_HOME_BIZ_DB);
      $this->set_default(NA_HOME_BIZ_DB);
      if ((!ret) || ($this->response_size == 0))
      {
          return 0;
      }

      if(($this->home_biz = strtok($this->raw_response, ";")) == null)
      {
          return 0;
      }

      return 1;
  }
  
  
  /*******************************************************************
   * The following "get" function should be used to get the
   * information from the NA DB queried after performing the query
   * with the functions above.
   *******************************************************************

  /* Returns the SIC */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_sic()
  {
      return ($this->sic);
  }

  /* Returns the domain after querying the   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_domain()
  {
      return ($this->domain);
  }

  /* Returns the country after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_country()
  {
      return ($this->country);
  }

  /* Returns the country confidence after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_country_conf()
  {
      return ($this->country_conf);
  }

  /* Returns the region after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_region()
  {
      return ($this->region);
  }

  /* Returns the region confidence after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_region_conf()
  {
      return ($this->region_conf);
  }

  /* Returns the city after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_city()
  {
      return ($this->city);
  }

  /* Returns the city confidence after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_city_conf()
  {
      return ($this->city_conf);
  }

  /* Returns the connection speed after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_connectionSpeed()
  {
      return ($this->connectionSpeed);
  }

  /* Returns the metro code after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_metro_code()
  {
      return ($this->metro_code);
  }

  /* Returns the latitude after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_latitude()
  {
      return ($this->latitude);
  }

  /* Returns the longitude after querying the NA Geo DB. */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_longitude()
  {
      return ($this->longitude);
  } 

  /* Returns the area_code after querying the NA Zip Db */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_area_code()
  {
      return ($this->area_code);
  }

  /* Returns the zip after querying the NA Zip Db */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_zip()
  {
      return ($this->zip);
  }

  /* Returns the current offset for Timezone from UTC (GMT) */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_current_offset()
  {
      return ($this->current_offset);
  }

  /* Returns whether the ip is in daylight savings time or not
   * after querying the NetAcuity ZIP Db
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_in_dst()
  {
      return ($this->in_dst);
  }

  /* Returns whether the ip is in daylight savings time or not
   * after querying the NetAcuity ZIP Db
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_zip_code_text()
  {
      return ($this->zip_code_text);
  }

  
  /* Returns the isp after querying the NetAcuity ISP Db */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_isp()
  {
      return ($this->isp);
  }

  /* Returns whether the ip is a home or business after querying
   * the NetAcuity Home/Biz Db
   */
  // NOTE --- LEFT IN FOR BACKWARD COMPATIBILITY. WILL BE REMOVED ---
  function get_home_biz()
  {
      return ($this->home_biz);
  }
}

// SUBCLASSES

//
// NetAcuityGeo - Class to query the geography database.
//
class NetAcuityGeo  extends NetAcuity
{
    var $country;
    var $country_conf;
    var $region;
    var $region_conf;
    var $city;
    var $city_conf;
    var $connectionSpeed;
    var $metro_code;
    var $latitude;
    var $longitude;
    var $countryCode;
    var $regionCode;
    var $cityCode;
    var $continentCode;

    function NetAcuityGeo()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$country               = "?";
        $this->$country_conf          = 0;
        $this->$region                = "?";
        $this->$region_conf           = 0;
        $this->$city                  = "?";
        $this->$city_conf             = 0;
        $this->$connectionSpeed       = "?";
        $this->$metro_code            = 0;
        $this->$latitude              = 0.0;
        $this->$longitude             = 0.0;
        $this->$countryCode           = 0; 
        $this->$regionCode            = 0;
        $this->$cityCode              = 0;
        $this->$continentCode         = 0;
    }

    //
    // parse() - Parse the response from the NetAcuity Server.
    function parse()
    {
        if(strlen($this->raw_response) < 5)
        {
            return 0;  // Timeout
        }

        if(($field = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }
        else
        {
            $this->country = substr($field,0,3);
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->region = substr($field,0,31);
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->city = substr($field,0,31);
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->connectionSpeed = substr($field, 0,10);
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->country_conf = $field;
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->region_conf = $field;
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->city_conf = $field;
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->metro_code = $field;
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->latitude = $field;
        }

        if(($field = strtok(";")) == null)
        {
            return 0;
        }
        else
        {
            $this->longitude = $field;
        }

        if ( ($field = strtok(";") ) == null)
        {
            return 1;
        }
        else
        {
            $this->countryCode = $field;
        }

        if ( ($field = strtok(";") ) == null)
        {
            return 0;
        }
        else
        {
            $this->regionCode = $field;
        }

        if ( ($field = strtok(";") ) == null)
        {
            return 0;
        }
        else
        {
            $this->cityCode = $field;
        }

        if ( ($field = strtok(";") ) == null)
        {
            return 0;
        }
        else
        {
            $this->continentCode = $field;
        }

        return 1;
    }

    //
    // Query the NetAcuity Server's geo database.
    //
    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_GEO_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    // Get functions
    function getCountry()
    {
        return $this->country;
    }

    function getCountryConf()
    {
        return $this->country_conf;
    }

    function getRegion()
    {
        return $this->region;
    }

    function getRegionConf()
    {
        return $this->region_conf;
    }

    function getCity()
    {
        return $this->city;
    }

    function getCityConf()
    {
        return $this->city_conf;
    }

    function getConnectionSpeed()
    {
        return $this->connectionSpeed;
    }

    function getMetroCode()
    {
        return $this->metro_code;
    }

    function getLatitude()
    {
        return $this->latitude;
    }

    function getLongitude()
    {
        return $this->longitude;
    }

    function getCountryCode()
    {
        return $this->countryCode;
    }

    function getRegionCode()
    {
        return $this->regionCode;
    }

    function getCityCode()
    {
        return $this->cityCode;
    }

    function getContinentCode()
    {
        return $this->continentCode;
    }
}

//
// NetAcuitySic - Query the SIC database. 
//
class NetAcuitySic  extends NetAcuity
{
    var $sicCode;

    function NetAcuitySic()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$sicCode = 0;
    }

    function parse()
    {
        if(($this->sicCode = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_SIC_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getSicCode()
    {
        return $this->sicCode;
    }
}

//
// NetAcuityDomain - Query the Domain database.
//
class NetAcuityDomain extends NetAcuity
{
    var $domain;

    function NetAcuityDomain()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$domain = "?";
    }

    function parse()
    {
        if(($this->domain = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_DOMAIN_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getDomain()
    {
        return $this->domain;
    }
}

//
// NetAcuityZip - Query the 'Zip Timezone, Area code' database.
//
class NetAcuityZip extends NetAcuity
{
    var $areaCode;
    var $zip;
    var $currentOffset;
    var $inDST;
    var $zipCodeText;
    
    function NetAcuityZip()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$areadCode     = 0;
        $this->$zip           = 0;
        $this->$currentOffset = 0;
        $this->$inDST         = "?";
        $this->zipCodeText    = "?";
    }

    function parse()
    {
        if(($this->areaCode = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        if(($this->zip = strtok(";")) == null)
        {
            return 0;
        }

        if ( ($this->currentOffset = strtok(";") ) == null )
        {
            return 0;
        }

        if ( ( $this->inDST = strtok(";") ) == null )
        {
            return 0;
        }
       
        if ($this->get_num_fields() > 4)
        {
            if ( ( $this->zipCodeText = strtok(";") ) == null )
            {
                return 0;
            }
        }
        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_ZIP_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getAreaCode()
    {
        return $this->areaCode;
    }

    function getZip()
    {
        return $this->zip;
    }

    function getCurrentOffset()
    {
        return $this->currentOffset;
    }

    function getInDST()
    {
        return $this->inDST;
    }

    function getZipCodeText()
    {
        return $this->zipCodeText;
    }
}

//
// NetAcuityISP - Query the ISP database.
//
class NetAcuityISP extends NetAcuity
{
    var $isp;

    function NetAcuityISP()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$naicsCode = 0;
    }

    function parse()
    {
        if(($this->isp = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_ISP_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getISP()
    {
        return $this->isp;
    }
}

//
// NetAcuityHomeBiz - Query the Home business database.
//
class NetAcuityHomeBiz extends NetAcuity
{
    var $homeBiz;

    function NetAcuityHomeBiz()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->homeBiz = "?";
    }

    function parse()
    {
        if(($this->homeBiz = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_HOME_BIZ_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getHomeBiz()
    {
        return $this->homeBiz;
    }
}

//
// NetAcuityASN - Query the ASN database.
//
class NetAcuityASN extends NetAcuity
{
    var $asn;
    var $asnOwner;

    function NetAcuityASN()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$asn      = 0;
        $this->$asnOwner = "?";
    }

    function parse()
    {
        if(($this->asn = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        if(($this->asnOwner = strtok( ";")) == null)
        {
            return 0;
        }
        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_ASN_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getAsn()
    {
        return $this->asn;
    }

    function getAsnOwner()
    {
        return $this->asnOwner;
    }
}

//
// NetAcuityLanguage - Query the Language database.
//
class NetAcuityLanguage extends NetAcuity
{
    var $language;
    var $secondaryLanguage;

    function NetAcuityLanguage()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$language          = "?";
        $this->$secondaryLanguage = "?";
    }

    function parse()
    {
        if(($this->language = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        if( ($this->secondaryLanguage = strtok(";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_LANGUAGE_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getLanguage()
    {
        return $this->language;
    }

    function getSecondaryLanguage()
    {
        return $this->secondaryLanguage;
    }
}

//
// NetAcuityProxy - Query the Proxy database.
//
class NetAcuityProxy extends NetAcuity
{
    var $proxyType;

    function NetAcuityProxy()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$proxyType = "?";
    }

    function parse()
    {
        if(($this->proxyType = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_PROXY_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getProxyType()
    {
        return $this->proxyType;
    }
}

//
// NetAcuityIsAnISP - Query the IsAnIsp database.
//
class NetAcuityIsAnISP extends NetAcuity
{
    var $isAnISP;

    function NetAcuityIsAnISP()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$isAnISP = "?";
    }

    function parse()
    {
        if(($this->isAnISP = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_ISANISP_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getIsAnISP()
    {
        return $this->isAnISP;
    }
}

//
// NetAcuityCompany - Query the company database.
//
class NetAcuityCompany extends NetAcuity
{
    var $company;

    function NetAcuityCompany()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$company = "?";
    }

    function parse()
    {
        if(($this->company = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_COMPANY_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getCompany()
    {
        return $this->company;
    }
}

//
// NetAcuityDemographics - Query the demographics database.
//
class NetAcuityDemographics extends NetAcuity
{
    var $rank;
    var $households;
    var $women;
    var $w18to34;
    var $w35to49;
    var $men;
    var $m18to34;
    var $m35to49;
    var $teens;
    var $kids;

    function NetAcuityDemographics()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$rank         = 0;
        $this->$households   = 0;
        $this->$women        = 0;
        $this->$w18to34      = 0;
        $this->$w35to49      = 0;
        $this->$men          = 0;
        $this->$m18to34      = 0;
        $this->$m35to49      = 0;
        $this->$teens        = 0;
        $this->$kids         = 0;
    }

    function parse()
    {
        if ( ($this->rank = strtok($this->raw_response, ";") ) == null )
        {
            return 0;
        }

        if ( ( $this->households = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->women = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->w18to34 = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->w35to49 = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->men = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->m18to34 = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->m35to49 = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->teens = strtok(";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->kids = strtok(";" ) ) == null )
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_DEMOGRAPHICS_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getRank()
    {
        return $this->rank;
    }

    function getHouseholds()
    {
        return $this->households;
    }

    function getWomen()
    {
        return $this->women;
    }

    function getW18to34()
    {
        return $this->w18to34;
    }

    function getW35to49()
    {
        return $this->w35to49;
    }

    function getMen()
    {
        return $this->men;
    }

    function getM18to34()
    {
        return $this->m18to34;
    }

    function getM35to49()
    {
        return $this->m35to49;
    }

    function getTeens()
    {
        return $this->teens;
    }

    function getKids()
    {
        return $this->kids;
    }
}

//
// NetAcuityNaics - Query the NAICS database.
//
class NetAcuityNaics extends NetAcuity
{
    var $naicsCode;

    function NetAcuityNaics()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$naicsCode = 0;
    }

    function parse()
    {
        if(($this->naicsCode = strtok($this->raw_response, ";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_NAICS_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getNaicsCode()
    {
        return $this->naicsCode;
    }
}

//
// NetAcuityCbsa - Query the CBSA database.
//
class NetAcuityCbsa extends NetAcuity
{
    var $cbsaCode;
    var $cbsaTitle;
    var $cbsaType;
    var $csaCode;
    var $csaTitle;
    var $mdCode;
    var $mdTitle;

    function NetAcuityCbsa()
    {
        $this->setVariables();
    }

    function setVariables()
    {
        $this->$cbsaCode  = 0;
        $this->$cbsaTitle = "?";
        $this->$cbsaType  = "?";
        $this->$csaCode   = 0;
        $this->$csaTitle  = "?";
        $this->$mdCode    = 0;
        $this->$mdTitle   = "?";
    }

    function parse()
    {
        if ( ( $this->cbsaCode = strtok($this->raw_response, ";" ) ) == null )
        {
            return 0;
        }

        if ( ( $this->cbsaTitle = strtok(";")) == null)
        {
            return 0;
        }

        if ( ( $this->cbsaType = strtok(";")) == null)
        {
            return 0;
        }

        if ( ( $this->csaCode = strtok(";")) == null)
        {
            return 0;
        }

        if ( ( $this->csaTitle = strtok(";")) == null)
        {
            return 0;
        }

        if ( ( $this->mdCode = strtok(";")) == null)
        {
            return 0;
        }

        if ( ( $this->mdTitle = strtok(";")) == null)
        {
            return 0;
        }

        return 1;
    }

    function query($queryIP)
    {
        $this->setVariables();
        $ret = $this->na_query_raw($queryIP, NA_CBSA_DB);
        if ((!$ret) || ($this->response_size == 0))
        {
            return 0;
        }

        if ($this->parse($this->raw_response) == 0)
        {
            return 0;
        }
        return 1;
    }

    function getCbsaCode()
    {
        return $this->cbsaCode;
    }

    function getCbsaTitle()
    {
        return $this->cbsaTitle;
    }

    function getCbsaType()
    {
        return $this->cbsaType;
    }

    function getCsaCode()
    {
        return $this->csaCode;
    }

    function getCsaTitle()
    {
        return $this->csaTitle;
    }

    function getMdCode()
    {
        return $this->mdCode;
    }

    function getMdTitle()
    {
        return $this->mdTitle;
    }
}

//
// NetAcuityXML - XML Query into the NetAcuity Server.
//                This class allows for the querying of
//                the NetAcuity Server using XML.
//
class NetAcuityXML
{
    var $serverAddress;
    var $apiID;
    var $timeOut;
    var $response;
    var $responseTable;

    function NetAcuityXML($pServerAddress, $pApiID, $pTimeOut)
    {
        $this->serverAddress = $pServerAddress;
        $this->apiID         = $pApiID;
        $this->timeOut       = $pTimeOut;
    }

    function query($queryIP, $dbFeatureCode, $transactionID)
    {
        // Build the query packet.
        $queryString = "<request trans-id=\"" . $transactionID . "\" "
                     . "ip=\"" . $queryIP . "\" "
                     . "api-id=\"" . $this->apiID . "\" >";

        // For each database request, build an xml tag for that
        // database feature code.
        // The format is as follows
        // <query db="<feature code>" />
        // Where <feature code> is a valid feature code nunber.
        $featureCode  = strtok($dbFeatureCode, "," );

        while ( $featureCode != NULL) 
        {
            if ( $featureCode >= 500 and $featureCode < 3 )
            {
                // Bad feature number.
                $this->response = "<response trans-id=\"" . $transactionID . "\" "
                          . "ip=\"" . $queryIP . "\" "
                          . "error=\"request for feature " . $featureCode
                          . " is invalid\" />";
                return 0;
            }

            $queryString = $queryString . "<query db=\"" . $featureCode 
                         . "\" />";

            $featureCode = strtok(",");
        }

        $queryString = $queryString . "</request>";


        // Send the response
        $naFd = fsockopen("udp://" . $this->serverAddress, NA_UDP_PORT, $errno, $errstr, $this->timeOut);

        if (!naFd )
        {
            $this->response = "<response trans-id=\"" . $transactionID . "\" "
                      . "ip=\"" . $queryIP . "\" "
                      . "error=\"Unable to connect to NetAcuity Server.\" />";
            return 0;
        }

        fputs($naFd, $queryString);
        socket_set_timeout($naFd, $this->timeOut);

        // The server might send multiple packets back.
        $isDone           = 0;
        $totalPacket      = 0;
        $lastTotalPacket  = 0;
        $packetNumber     = 0;
        $lastPacketNumber = 0;
        $i                = 0;
        while ( !$isDone)
        {
            $responseBuffer = fread($naFd, MAX_RESPONSE_SIZE);
            if ($responseBuffer == FALSE)
            {
                $this->response = "<response trans-id=\"" . $transactionID . "\" "
                          . "ip=\"" . $queryIP . "\" "
                          . "error=\"Reading from UDP socket.\" />";
                fclose($naFd);
                return 0;
            }
            $tempResponse = $responseBuffer;
            $packetNumber = intval(substr($responseBuffer, 0, 2));
            $totalPacket  = intval(substr($responseBuffer, 2, 4));

            // Make sure to get all the packets in order.
            if ( ( $packetNumber - 1) != lastPacketNumber )
            {
                $this->response = "<response trans-id=\"" . $transactionID . "\" "
                          . "ip=\"" . $queryIP . "\" "
                          . "error=\"Packets received out of order.\" />";
                fclose($naFd);
                return 0;
            }

            $lastPacketNumber = $packetNumber;
            $this->response   = $this->response . substr($responseBuffer, 4);
                          
            if ( $packetNumber == $totalPacket )
            {
                $isDone = 1;
            }

            $i++;
            if ($i == 10)
            {
                $isDone = 1;
            }
        }

        fclose($naFd);

        return 1;
    }

    function parse()
    {
        $responseString    = substr($this->response, 10);
        $tokenArray        = explode("\" ", $responseString);
        $arraySize         = count($tokenArray);

        for ($i = 0; $i < $arraySize; $i++)
        {
            $currentToken  = $tokenArray[$i];
            $equalToken    = explode("=\"", $currentToken);
            $equalSize     = count($equalToken);
            if ($equalSize == 2)
            {
                $parameter = $equalToken[0];
                $value     = $equalToken[1];
                $this->responseTable[$parameter] = $value;
            }
            else if ( $equalSize == 1 && substr($equalToken[0], 0, 2) == "/>")
            {
                return 1;
            }
            else 
            {
                echo "equalSize = $equalSize <br>\n";
                echo "token = $equalToken[0] <br>\n";
                return 0;
            }
        }
        return 1;
    }

    function queryAndParse($queryIP, $dbFeatureCode, $transactionID)
    {
        $returnCode = $this->query($queryIP, $dbFeatureCode, $transactionID);
        if ( $returnCode == 0)
        {
            return 0;
        }

        // Parse the result into a hash.
        $returnCode =  $this->parse();
        if ( $returnCode == 0)
        {
            $this->response = "<response trans-id=\"" . $transactionID . "\" "
                            . "ip=\"" . $queryIP . "\" "
                            . "error=\"Parse error.\" />";
            return 0;
        }
        return 1;
    }

    function getResponse()
    {
        return $this->response;
    }

    function getResponseTable()
    {
        return $this->responseTable;
    }
}

?>
