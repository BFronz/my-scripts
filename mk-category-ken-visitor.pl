#!/usr/bin/perl
#
#
  
$supercat  = $ARGV[0];
if($supercat eq "") {print "\n\nForgot to add date supercat (family)\n\n"; exit;}
   

#$debug=1;
 
use DBI;
$dbh      = DBI->connect("", "", "");

                                 
$outfile = $supercat . "-visitor-data-new.txt" ;
open(wf,  ">mk-category/$outfile")  || die (print "Could not open $outfile\n");
print wf "quarter\tcategory\tnumber\tvisitor\tcity\tstate\tzip\tdomain\tvisits\n";
     
$rdate12_1 = " '1201','1202','1203' "; 
$rdate12_2 = " '1204','1205','1206' ";
$rdate12_3 = " '1207','1208','1209' ";
$rdate12_4 = " '1210','1211','1212' ";
$rdate13_1 = " '1301','1302','1303' ";

# get all categories under super cat
$query = "select distinct(b.heading), description ";
$query .= "from tgrams.browsehead_report as b, tgrams.headings as h where  famname='$supercat' and b.heading=h.heading ";
#$query .= "limit 5 ";
my $sth = $dbh->prepare($query); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $record[$i] = $$row[0];
 $i++;
}  
$sth->finish;
if($debug eq 1) { print "\n$query\n"; }
print "\nTotal headings: $i\t\n";

$j=1;
foreach $record (@record)   #  main loop
{ 
 ($h,$des) = split(/\|/,$record);

 $query  = " select description, heading from tgrams.headings where heading = '$h' ";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 if (my $row = $sth->fetchrow_arrayref) {  $des = $$row[0]; } 
 $sth->finish;
 if($debug eq 1) { print "\n$query\n"; }

 print "$j of $i)\t$supercat:\t$des\t$h\t\n";  
       
  
 ### visitors
 #  "quarter\tcategory\tnumber\tvisitor\tcity\tstate\tzip\tdomain\tvisits\n"; 

 $query = "select org, sum(cnt) as cnt, city, state, zip, domain ";
 $query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_1) and org>'' and isp='N' and block='N' and org!='-'  ";
 $query .= "group by org order by cnt desc, org  limit 50 ";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
  if( $$row[2] eq "-" ) { $$row[2]=""; }  if( $$row[3] eq "-" ) { $$row[3]=""; }  if( $$row[4] eq "-" ) { $$row[4]=""; }  if( $$row[5] eq "-" || $$row[5] eq "?" ) { $$row[5]=""; }     
  print wf "Q12012\t$des\t$h\t$$row[0]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[1]\n";
 }    
 $sth->finish;  
 if($debug eq 1) { print "\n$query\n"; }

            
 $query = "select org, sum(cnt) as cnt, city, state, zip, domain ";
 $query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_2) and org>''  and isp='N' and block='N' and org!='-'  ";
 $query .= "group by org order by cnt desc, org  limit 50";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
  if( $$row[2] eq "-" ) { $$row[2]=""; }  if( $$row[3] eq "-" ) { $$row[3]=""; }  if( $$row[4] eq "-" ) { $$row[4]=""; }  if( $$row[5] eq "-" || $$row[5] eq "?" ) { $$row[5]=""; }    
  print wf "Q22012\t$des\t$h\t$$row[0]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[1]\n"; 
 }  
 $sth->finish;  
 if($debug eq 1) { print "\n$query\n"; }

 

 $query = "select org, sum(cnt) as cnt, city, state, zip, domain  ";
 $query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_3) and org>''  and isp='N' and block='N' and org!='-'  ";
 $query .= "group by org order by cnt desc, org  limit 50";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
  if( $$row[2] eq "-" ) { $$row[2]=""; }  if( $$row[3] eq "-" ) { $$row[3]=""; }  if( $$row[4] eq "-" ) { $$row[4]=""; }  if( $$row[5] eq "-" || $$row[5] eq "?" ) { $$row[5]=""; }   
  print wf "Q32012\t$des\t$h\t$$row[0]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[1]\n"; 
 }  
 $sth->finish;  
 if($debug eq 1) { print "\n$query\n"; }

 

 $query = "select org, sum(cnt) as cnt, city, state, zip, domain  ";
 $query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_4) and org>''  and isp='N' and block='N' and org!='-'  ";
 $query .= "group by org order by cnt desc, org  limit 50";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
  if( $$row[2] eq "-" ) { $$row[2]=""; }  if( $$row[3] eq "-" ) { $$row[3]=""; }  if( $$row[4] eq "-" ) { $$row[4]=""; }  if( $$row[5] eq "-" || $$row[5] eq "?" ) { $$row[5]=""; }   
  print wf "Q42012\t$des\t$h\t$$row[0]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[1]\n"; 
 }    
 $sth->finish;  
 if($debug eq 1) { print "\n$query\n"; }

 

 $query = "select org, sum(cnt) as cnt, city, state, zip, domain  ";
 $query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate13_1) and org>''  and isp='N' and block='N' and org!='-'  ";
 $query .= "group by org order by cnt desc, org  limit 50";
 my $sth = $dbh->prepare($query);
 if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
 while (my $row = $sth->fetchrow_arrayref)
 {   
  if( $$row[2] eq "-" ) { $$row[2]=""; }  if( $$row[3] eq "-" ) { $$row[3]=""; }  if( $$row[4] eq "-" ) { $$row[4]=""; }  if( $$row[5] eq "-" || $$row[5] eq "?"  ) { $$row[5]=""; }   
  print wf "Q12013\t$des\t$h\t$$row[0]\t$$row[2]\t$$row[3]\t$$row[4]\t$$row[5]\t$$row[1]\n"; 
 } 
 $sth->finish;  
 if($debug eq 1) { print "\n$query\n"; }



 $j++;

} # end main loop

close(wf);
 
$dbh->disconnect;

print "\n\nDone...\n\n";
