#!/usr/bin/perl
#
use utf8;

#use Text::Unidecode;
 
$fld = "Nässjö";
 
print "in: $fld\n";
                                            
                                            
sub CleanForeign {                          
 ($x) = @_;                                 
 $x =~ s/á/a/g;
 $x =~ s/ã/a/g;
 $x =~ s/å/A/g;
 $x =~ s/À/A/g;
 $x =~ s/Â/A/g;
 $x =~ s/Ä/A/g;
 $x =~ s/Å/A/g;
 $x =~ s/è/E/g;
 $x =~ s/ê/E/g;
 $x =~ s/È/E/g;
 $x =~ s/Ê/E/g;
 $x =~ s/ì/i/g;
 $x =~ s/î/i/g;
 $x =~ s/Ì/I/g;
 $x =~ s/Î/I/g;
 $x =~ s/ò/o/g;
 $x =~ s/ô/o/g;
 $x =~ s/ö/o/g;
 $x =~ s/ø/o/g;
 $x =~ s/Ò/O/g;
 $x =~ s/Ô/O/g;
 $x =~ s/Ö/O/g;
 $x =~ s/Ø/O/g;
 $x =~ s/ù/u/g;
 $x =~ s/û/u/g;
 $x =~ s/Ù/U/g;
 $x =~ s/Û/U/g;
 $x =~ s/Ÿ/Y/g;
 $x =~ s/ç/b/g;
 $x =~ s/ß/B/g;
 $x =~ s/Ī/I/g;
 $x =~ s/ĭ/i/g;
 $x =~ s/à/a/g;
 $x =~ s/â/a/g;
 $x =~ s/ä/a/g;
 $x =~ s/æ/a/g;
 $x =~ s/Á/A/g;
 $x =~ s/Ã/A/g;
 $x =~ s/Æ/E/g;
 $x =~ s/é/e/g;
 $x =~ s/ë/e/g;
 $x =~ s/É/E/g;
 $x =~ s/Ë/E/g;
 $x =~ s/í/i/g;
 $x =~ s/ï/i/g;
 $x =~ s/Í/I/g;
 $x =~ s/Ï/I/g;
 $x =~ s/ó/o/g;
 $x =~ s/õ/o/g;
 $x =~ s/œ/o/g;
 $x =~ s/Ó/O/g;
 $x =~ s/Õ/O/g;
 $x =~ s/ú/u/g;
 $x =~ s/ü/u/g;
 $x =~ s/Ú/U/g;
 $x =~ s/Ü/U/g;
 $x =~ s/¥/Y/g;
 $x =~ s/Ç/C/g;
 $x =~ s/ñ/n/g;
 $x =~ s/Ī/I/g;
 $x =~ s/Į/I/g; 
 return($x);                                
}                                           
                                            
$fldnew = &CleanForeign($fld); 
       
#$fldnew= unidecode($fld);
 
print "clean $fldnew\n";

exit;                                     


#require "trd-reload.ph";

#use DBI;
#$dbh      = DBI->connect("", "", "");


#$ip="65.185.92.191";

#@flds =  &GetIP2Data($ip);  

 
#print "$flds[0]\n$flds[1]\t$flds[2]\t$flds[3]\n\n";
