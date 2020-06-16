$dbfdir = "/usr3/trdaily";

$rootdir = "/www/thomas";

$db = "trdaily";
$data_source = "dbi:mysql:$db:localhost";
$user = "";
$auth = "";

$MAXWORDLEN = 10;

$rgnname{"02"} = "gdv";
$rgnname{"04"} = "ene";
$rgnname{"07"} = "wne";
$rgnname{"08"} = "ga";
$rgnname{"09"} = "ncts";
$rgnname{"10"} = "gm";
$rgnname{"11"} = "no";
$rgnname{"12"} = "uny";
$rgnname{"13"} = "ov";
$rgnname{"14"} = "cc";
$rgnname{"15"} = "tglf";
$rgnname{"16"} = "txok";
$rgnname{"17"} = "gc";
$rgnname{"18"} = "scal";
$rgnname{"19"} = "ncal";
$rgnname{"20"} = "gf";
$rgnname{"21"} = "se";
$rgnname{"22"} = "nyj";
$rgnname{"23"} = "pnw";

$Trgnname{"02"} = "gdv";
$Trgnname{"04"} = "ene";
$Trgnname{"07"} = "wne";
$Trgnname{"08"} = "ga";
$Trgnname{"09"} = "ncts";
$Trgnname{"10"} = "gm";
$Trgnname{"11"} = "no";
$Trgnname{"12"} = "uny";
$Trgnname{"13"} = "ov";
$Trgnname{"14"} = "macc";
$Trgnname{"15"} = "tlg";
$Trgnname{"16"} = "nto";
$Trgnname{"17"} = "gc";
$Trgnname{"18"} = "scal";
$Trgnname{"19"} = "ncal";
#$Trgnname{"20"} = "gf";
$Trgnname{"20"} = "gfl";
$Trgnname{"21"} = "se";
$Trgnname{"22"} = "nyj";
$Trgnname{"23"} = "pnw";

#$co_name = "XXX I. B. M.";
#$co_name = "XXX I.B.M.";
#$co_name = "R & R Uniforms, Inc.";
#$co_name = "U.S. Chrome Corp. of Pennsylvania";
#$co_name = "Haye's Modems";

sub MakeCleanName
{
  local($_c) = @_;

  # Add a leading & trailing space
  $_c = " $_c ";
  # Convert to lowercase
  $_c =~ tr/A-Z/a-z/;
  # Remove extra spaces
  $_c =~ s/ +/ /g;
  # Remove hyphens & single quotes
  $_c =~ s/[-\']//g;

  # Reduce I.B.M. or I. B. M. to ibm
  if ($_c =~ / (([a-z]\. ?)+) /)
  {
    $_match = $1;
    $_fix = $_match;
    $_fix =~ s/[ \.]//g;
    $_match =~ s/\./\\./;
    $_c =~ s/$_match/$_fix/g;
  }

  # Remove anything other than a letter, number or space
  $_c =~ s/[^A-Za-z0-9 ]//g;
  # Remove extra spaces again
  $_c =~ s/ +/ /g;

  $_c;
}

sub EdmstCleanName
{
  local($c) = @_;
  $c = " " . lc($c) . " ";

  # Single letters with periods are special cases
  if ($c =~ /(( \w\.)+)/)
  {
    local($match) = $1;
    local($fix) = $match;
    $fix =~ s/[ \.]//g;
    #$c =~ s/$match/ $fix/g;
    $c =~ s/ ${fix}\./ $fix/g;
  }

  # Hypens, Slashes to spaces
  $c =~ s/[\-\/]/ /g;
  # "'s" is removed
  #$c =~ s/\'s / /g;
  $c =~ s/\'s,? / s /g;
  # Remove single quotes
  $c =~ s/[-\']//g;
  # Remove anything other than a letter, number or space
  $c =~ s/[^A-Za-z0-9 ]//g;
  # Remove extra spaces
  $c =~ s/\s+/ /g;

  # Reduce consecutive single-char words to be one word
  if ($c =~ /(( \w)+) /)
  {
    local($match) = $1;
    local($fix) = $match;
    $fix =~ s/ //g;
    $c =~ s/$match/ $fix/g;
  }

  # Remove extra spaces
  $c =~ s/ +/ /g;

  $c;
}

sub EdmstCleanNameOld
{
  local($_c) = @_;

  # Add a leading & trailing space
  $_c = " $_c ";
  # Convert to lowercase
  $_c =~ tr/A-Z/a-z/;
  # Hypens, Slashes to spaces
  $_c =~ s/[\-\/]/ /g;
  # Remove extra spaces
  $_c =~ s/ +/ /g;
  # "'s" is removed
  #$_c =~ s/\'s / /g;
  $_c =~ s/\'s,? / s /g;
  # Remove single quotes
  $_c =~ s/[-\']//g;

  # Reduce I.B.M. or I. B. M. to ibm
  if ($_c =~ / (([a-z]\. ?)+) /)
  {
    $_match = $1;
    $_fix = $_match;
    $_fix =~ s/[ \.]//g;
    $_match =~ s/\./\\./;
    $_c =~ s/$_match/$_fix/g;
  }

  # Remove anything other than a letter, number or space
  $_c =~ s/[^A-Za-z0-9 ]//g;
  # Remove extra spaces again
  $_c =~ s/ +/ /g;

  $_c;
}

sub MakeHeadDesc
{
  local($d) = @_;

  # Capitalize Heading Description
  $d = lc($d);
  @words = split(/ +/, $d);
  $d = "";
  $j = 0;
  while ($j < @words)
  {
    if ($j > 0) { $d .= " "; }
    if ($words[$j] =~ /^\(/)
    {
      $words[$j] = substr($words[$j], 1, length($words[$j])-1);
      $d .= "(";
    }
    $d .= ucfirst($words[$j]);
    $j++;
  }

  # certain substrings in heading must be capitalized
  # only on word-boudaries
  # ac, cad, cae, cam, cnc, dc, edm, emi, iso
  # Added: CD, CD-ROM, LCD, HVAC, CMM
  $d =~ s/\bac\b/AC/gi;
  $d =~ s/\bcad\b/CAD/gi;
  $d =~ s/\bcae\b/CAE/gi;
  $d =~ s/\bcam\b/CAM/gi;
  $d =~ s/\bcnc\b/CNC/gi;
  $d =~ s/\bdc\b/DC/gi;
  $d =~ s/\bedm\b/EDM/gi;
  $d =~ s/\bemi\b/EMI/gi;
  $d =~ s/\biso\b/ISO/gi;
  $d =~ s/\bcd\b/CD/gi;
  $d =~ s/\bcd\-rom\b/CD-ROM/gi;
  $d =~ s/\bcd\-i\b/CD-I/gi;
  $d =~ s/\blcd\b/LCD/gi;
  $d =~ s/\bhvac\b/HVAC/gi;
  $d =~ s/\bcmm\b/CMM/gi;

  # Added: scr, ups, rops, nc, ndt, rf, cip, hip, cvd, pvd, abs
  $d =~ s/\bscr\b/SCR/gi;
  $d =~ s/\bups\b/UPS/gi;
  $d =~ s/\brops\b/ROPS/gi;
  $d =~ s/\bnc\b/NC/gi;
  $d =~ s/\bndt\b/NDT/gi;
  $d =~ s/\brf\b/RF/gi;
  $d =~ s/\bcip\b/CIP/gi;
  $d =~ s/\bhip\b/HIP/gi;
  $d =~ s/\bcvd\b/CVD/gi;
  $d =~ s/\bpvd\b/PVD/gi;
  $d =~ s/\babs\b/ABS/gi;
  $d =~ s/\bpvc\b/PVC/gi;
  $d =~ s/\brtm\b/RTM/gi;
  $d =~ s/\brfi\b/RFI/gi;

  # Added: I.D., O.D., A.C., D.C., E.D.M.
  $d =~ s/i\.d\./I.D./gi;
  $d =~ s/o\.d\./O.D./gi;
  $d =~ s/a\.c\./A.C./gi;
  $d =~ s/d\.c\./D.C./gi;
  $d =~ s/e\.d\.m\./E.D.M./gi;

  $d;
}



sub CleanField {           
 my $data=shift;           
 $data =~ s/[[:punct:]]//g;
 $data	=~ s/Ã//g;         
 $data	=~ s/â€“//g;       
 $data	=~ s/â„¢//g;       
 $data	=~ s/“//g;         
 $data	=~ s/â€œ//g;       
 $data	=~ s/”//g;         
 $data	=~ s/â€//g;       
 $data	=~ s/•//g;         
 $data	=~ s/â€¢//g;       
 $data	=~ s/â€™//g;       
 $data	=~ s/â—//g;       
 $data	=~ s/Â//g;         
 $data	=~ s/ \? //g;      
 $data	=~ s/Ã±//g;        
 $data	=~ s/Ã§//g;        
 $data	=~ s/'//g;         
 $data	=~ s/<//g;         
 $data	=~ s/>//g;         
 $data	=~ s/“//g;         
 $data	=~ s/”//g;         
 $data	=~ s/„//g;         
 $data	=~ s/‘//g;         
 $data	=~ s/’//g;         
 $data	=~ s/‚//g;         
 $data	=~ s/«//g;         
 $data	=~ s/»//g;         
 $data	=~ s/‹//g;         
 $data	=~ s/›//g;         
 $data	=~ s/˜//g;         
 $data	=~ s/¨//g;         
 $data	=~ s/ˆ//g;         
 $data	=~ s/´//g;         
 $data	=~ s/¸//g;         
 $data	=~ s/¯//g;         
 $data	=~ s/–//g;         
 $data	=~ s/—//g;         
 $data	=~ s/…//g;         
 $data	=~ s/•//g;         
 $data	=~ s/·//g;         
 $data	=~ s/°//g;         
 $data	=~ s/‰//g;         
 $data	=~ s/'//g;         
 $data	=~ s/¢//g;         
 $data	=~ s/£//g;         
 $data	=~ s/¤//g;         
 $data	=~ s/¥//g;         
 $data	=~ s/€//g;         
 $data	=~ s/ƒ//g;         
 $data	=~ s/™//g;         
 $data	=~ s/®//g;         
 $data	=~ s/©//g;         
 $data	=~ s/À//g;         
 $data	=~ s/Á//g;         
 $data	=~ s/Â//g;         
 $data	=~ s/Ã//g;         
 $data	=~ s/Ä//g;         
 $data	=~ s/Å//g;         
 $data	=~ s/Æ"//g;        
 $data	=~ s/Ç//g;         
 $data	=~ s/È//g;         
 $data	=~ s/É//g;         
 $data	=~ s/Ê//g;         
 $data	=~ s/Ë//g;         
 $data	=~ s/Ì//g;         
 $data	=~ s/Í//g;         
 $data	=~ s/Î//g;         
 $data	=~ s/Ï//g;         
 $data	=~ s/Ð//g;         
 $data	=~ s/Ñ//g;         
 $data	=~ s/Ò//g;         
 $data	=~ s/Ó//g;         
 $data	=~ s/Ô//g;         
 $data	=~ s/Õ//g;         
 $data	=~ s/Ö//g;         
 $data	=~ s/Ø//g;         
 $data	=~ s/Ù//g;         
 $data	=~ s/Ú//g;         
 $data	=~ s/Œ//g;         
 $data	=~ s/Š//g;         
 $data	=~ s/Û//g;         
 $data	=~ s/Ü//g;         
 $data	=~ s/Ý//g;         
 $data	=~ s/Ÿ//g;         
 $data	=~ s/Þ//g;         
 $data	=~ s/ß//g;         
 $data	=~ s/¿//g;         
 $data	=~ s/¡//g;         
 $data	=~ s/†//g;         
 $data	=~ s/‡//g;         
 $data	=~ s/¶//g;         
 $data	=~ s/¦//g;         
 $data	=~ s/§//g;         
 $data	=~ s/¼//g;         
 $data	=~ s/½//g;         
 $data	=~ s/¾//g;         
 $data	=~ s/¹//g;         
 $data	=~ s/²//g;         
 $data	=~ s/³//g;         
 $data	=~ s/ª//g;         
 $data	=~ s/º//g;         
 $data	=~ s/à//g;         
 $data	=~ s/á//g;         
 $data	=~ s/â//g;         
 $data	=~ s/ã//g;         
 $data	=~ s/ä//g;         
 $data	=~ s/å//g;         
 $data	=~ s/æ//g;         
 $data	=~ s/ç//g;         
 $data	=~ s/è//g;         
 $data	=~ s/é//g;         
 $data	=~ s/ê//g;         
 $data	=~ s/ë//g;         
 $data	=~ s/ì//g;         
 $data	=~ s/í//g;         
 $data	=~ s/î//g;         
 $data	=~ s/ï//g;         
 $data	=~ s/ð//g;         
 $data	=~ s/ñ//g;         
 $data	=~ s/ò//g;         
 $data	=~ s/ó//g;         
 $data	=~ s/ô//g;         
 $data	=~ s/õ//g;         
 $data	=~ s/ö//g;         
 $data	=~ s/ø//g;         
 $data	=~ s/œ//g;         
 $data	=~ s/š//g;         
 $data	=~ s/ù//g;         
 $data	=~ s/ú//g;         
 $data	=~ s/û//g;         
 $data	=~ s/ü//g;         
 $data	=~ s/ý//g;         
 $data	=~ s/ÿ//g;         
 $data	=~ s/þ//g;         
 $data	=~ s/~//g;         
 $data	=~ s/˜//g;         
 $data	=~ s/±//g;         
 $data	=~ s/×//g;         
 $data	=~ s/÷//g;         
 $data	=~ s/ß//g;         
 $data	=~ s/µ//g;         
 $data	=~ s/¬//g;         
 $data	=~ s/µ//g;         
 $data	=~ s/ó//g;         
 $data	=~ s/á//g;         
 return $data;             
}                          
