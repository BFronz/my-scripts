#!/usr/bin/perl
#
#
 
$supercat  = $ARGV[0];
if($supercat eq "") {print "\n\nForgot to add date supercat (family)\n\n"; exit;}
   

#$debug=1;
 
use DBI;
$dbh      = DBI->connect("", "", "");

 
$outfile = $supercat . "-activity-data-new.txt" ;
open(wf,  ">mk-category/$outfile")  || die (print "Could not open $outfile\n");  
 


print wf  "category\tnumber\t"; 

print wf "Q1 2012 US\t";
print wf "Q1 2012 Conv\t";

print wf "Q2 2012 US\t";
print wf "Q2 2012 Conv\t";

print wf "Q3 2012 US\t";
print wf "Q3 2012 Conv\t";

print wf "Q4 2012 US\t";
print wf "Q4 2012 Conv\t";

print wf "Q1 2013 US\t";
print wf "Q1 2013 Conv\n";

 
$rdate12_1 = " '1201','1202','1203' "; 
$rdate12_2 = " '1204','1205','1206' ";
$rdate12_3 = " '1207','1208','1209' ";
$rdate12_4 = " '1210','1211','1212' ";
$rdate13_1 = " '1301','1302','1303' ";
 
# get all categories under super cat 
$query = "select distinct(b.heading), description ";
$query .= "from tgrams.browsehead_report as b, tgrams.headings as h where  famname='$supercat' and b.heading=h.heading ";
#$query .= "limit 1 "; 
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $record[$i] = "$$row[0]|$$row[1]";
 $i++;
}  
$sth->finish;
if($debug eq 1) { print "\n$query\n"; }
print "\nTotal headings: $i\t\n";

$j=1;
foreach $record (@record)   #  main loop
{  
 ($h,$des) = split(/\|/,$record);
 
 print "$j of $i)\t$supercat:\t$des\t$h\t\n";  
 
 $query  = " select description, heading from tgrams.headings where heading = '$h' ";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 if (my $row = $sth->fetchrow_arrayref) {  $des = $$row[0]; } 
 $sth->finish;
 if($debug eq 1) { print "\n$query\n"; }

       
 ### user sessions
 $query = "select                                                           
 sum( if(date = '1201' || date = '1202' || date = '1203',cnt,0 )),
 sum( if(date = '1204' || date = '1205' || date = '1206',cnt,0 )),
 sum( if(date = '1207' || date = '1208' || date = '1209',cnt,0 )),
 sum( if(date = '1210' || date = '1211' || date = '1212',cnt,0 )) 
 from thomquickUS12  where heading='$h' and covflag='t'  ";  
 my $sth = $dbh->prepare($query); 
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {  
   $q12012US = $$row[0];
   $q22012US = $$row[1];
   $q32012US = $$row[2];
   $q42012US = $$row[3];
  }
 $sth->finish;
 if($debug eq 1) { print "\n$query\n"; }
 

 $query = "select                                                           
 sum( if(date = '1301' || date = '1302' || date = '1303',cnt,0 )),
 sum( if(date = '1304' || date = '1305' || date = '1306',cnt,0 )),
 sum( if(date = '1307' || date = '1308' || date = '1309',cnt,0 )),
 sum( if(date = '1310' || date = '1311' || date = '1312',cnt,0 )) 
 from thomquickUS13  where heading='$h' and covflag='t'  ";  
 my $sth = $dbh->prepare($query); 
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
  {  
   $q12013US = $$row[0];
   $q22013US = $$row[1];
   $q32013US = $$row[2];
   $q42013US = $$row[3];
  }
 $sth->finish;
if($debug eq 1) { print "\n$query\n"; }
    
 ### conversions 
 $query = "select
 sum( if(date = '1201' || date = '1202' || date = '1203', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1204' || date = '1205' || date = '1206', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1207' || date = '1208' || date = '1209', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1210' || date = '1211' || date = '1212', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )) 
 from  qlog12Y  where heading='$h'  and covflag='t'   "; 
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
  $q12012C = $$row[0];
  $q22012C = $$row[1];
  $q32012C = $$row[2];
  $q42012C = $$row[3];
 } 
 $sth->finish;
 if($debug eq 1) { print "\n$query\n"; }
 

 $query = "select
 sum( if(date = '1301' || date = '1302' || date = '1303', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1304' || date = '1305' || date = '1306', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1307' || date = '1308' || date = '1309', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1310' || date = '1311' || date = '1312', pv +  pc + lw + em + ec + lc + vv + dv + iv + sm + pp + mv,0 ))
 from  qlog13Y  where heading='$h'  and covflag='t'   "; 
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 { 
  $q12013C = $$row[0];
  $q22013C = $$row[1];
  $q32013C = $$row[2];
  $q42013C = $$row[3];
 }
 $sth->finish;  
 if($debug eq 1) { print "\n$query\n"; }


 print wf  "$des\t$h\t"; 

 print wf "$q12012US\t";
 print wf "$q12012C\t";

 print wf "$q22012US\t";
 print wf "$q22012C\t";

 print wf "$q32012US\t";
 print wf "$q32012C\t";

 print wf "$q42012US\t";
 print wf "$q42012C\t";

 print wf "$q12013US\t";
 print wf "$q12013C\n";


 
 $j++;

} # end main loop

close(wf);
 

$dbh->disconnect;

print "\n\nDone...\n\n";
