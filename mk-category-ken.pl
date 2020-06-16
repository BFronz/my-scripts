#!/usr/bin/perl
#

$h = 45340403;  # Machining
#$h = 77211605;  # Springs
#$h = 17092552;  # Compressors

#$debug=1;

use DBI;
$dbh      = DBI->connect("", "", "");
 
$outfile = "CateogryData-".  $h  .".txt"; 
$rdate12_1 = " '1201','1202','1203' "; 
$rdate12_2 = " '1204','1205','1206' ";
$rdate12_3 = " '1207','1208','1209' ";
$rdate12_4 = " '1210','1211','1212' ";
$rdate13_1 = " '1301','1302','1303' ";
      
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");
  

$query  = " select description, heading from tgrams.headings where heading = '$h' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
if (my $row = $sth->fetchrow_arrayref) {  $des = $$row[0]; } 
$sth->finish;
if($debug eq 1) { print "\n$query\n"; }
print "\n$des\t$h\n";  
      
### user sessions
 $query = "select                                                           
 sum( if(date = '1201' || date = '1202' || date = '1203',us,0 )),
 sum( if(date = '1204' || date = '1205' || date = '1206',us,0 )),
 sum( if(date = '1207' || date = '1208' || date = '1209',us,0 )),
 sum( if(date = '1210' || date = '1211' || date = '1212',us,0 )) 
 from thomqlog12Y where heading='$h' and covflag='t'  ";  
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
 sum( if(date = '1301' || date = '1302' || date = '1303',us,0 )),
 sum( if(date = '1304' || date = '1305' || date = '1306',us,0 )),
 sum( if(date = '1307' || date = '1308' || date = '1309',us,0 )),
 sum( if(date = '1310' || date = '1311' || date = '1312',us,0 )) 
 from thomqlog13Y where heading='$h' and covflag='t'  ";  
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
 sum( if(date = '1201' || date = '1202' || date = '1203', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1204' || date = '1205' || date = '1206', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1207' || date = '1208' || date = '1209', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1210' || date = '1211' || date = '1212', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )) 
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
 sum( if(date = '1301' || date = '1302' || date = '1303', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1304' || date = '1305' || date = '1306', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1307' || date = '1308' || date = '1309', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 )),
 sum( if(date = '1310' || date = '1311' || date = '1312', pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv,0 ))
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


print wf "Category\tCategory #\n";
print wf "$des\t$h\n";
print wf "\n";

print wf "q1 2012 User Sessions\tq2 2012 User Sessions\tq3 2012 User Sessions\tq4 2012 User Sessions\tq1 2013 User Sessions\n";
print wf "$q12012US\t$q22012US\t$q32012US\t$q42012US\t$q12013US\n";
print wf "\n";  
                      
print wf "q1 2012 Conversions\tq2 2012 Conversions\tq3 2012 Conversions\tq4 2012 Conversions\tq1 2013 Conversions\n";    
print wf "$q12012C\t$q22012C\t$q32012C\t$q42012C\t$q12013C\n";
print wf "\n";
 
 
### visitors
$i=0;
$query = "select org, sum(cnt) as cnt, city, country, state, zip ";
$query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_1) and org>'' and isp='N' and block='N' and org!='-'  ";
$query .= "group by org order by cnt desc, org ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $q12012V[$i] = $$row[0];
 $i++;
}
$sth->finish;  
if($debug eq 1) { print "\n$query\n"; }
 
$i=0;
$query = "select org, sum(cnt) as cnt, city, country, state, zip ";
$query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_2) and org>''  and isp='N' and block='N' and org!='-'  ";
$query .= "group by org order by cnt desc, org ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
 $q22012V[$i] = $$row[0];
 $i++;
}
$sth->finish;  
if($debug eq 1) { print "\n$query\n"; }
 
$i=0;
$query = "select org, sum(cnt) as cnt, city, country, state, zip ";
$query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_3) and org>''  and isp='N' and block='N' and org!='-'  ";
$query .= "group by org order by cnt desc, org ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
 $q32012V[$i] = $$row[0];
 $i++;
}
$sth->finish;  
if($debug eq 1) { print "\n$query\n"; }
 
$i=0;
$query = "select org, sum(cnt) as cnt, city, country, state, zip ";
$query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate12_4) and org>''  and isp='N' and block='N' and org!='-'  ";
$query .= "group by org order by cnt desc, org ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
 $q42012V[$i] = $$row[0];
 $i++;
}
$sth->finish;  
if($debug eq 1) { print "\n$query\n"; }

$i=0;
$query = "select org, sum(cnt) as cnt, city, country, state, zip ";
$query .= "from thomtnetlogORGCATDM where heading='$h' and date in ($rdate13_1) and org>''  and isp='N' and block='N' and org!='-'  ";
$query .= "group by org order by cnt desc, org ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{   
 $q12013V[$i] = $$row[0];
 $i++;
}
$sth->finish;  
if($debug eq 1) { print "\n$query\n"; }
 
print wf "\n";
print wf "q1 2012 Visitor\tq2 2012 Visitor\tq3 2012 Visitor\tq4 2012 Visitor\tq1 2013 Visitor\n";
for (my $i=0; $i <= 50; $i++) { 
print wf "$q12012V[$i]\t$q22012V[$i]\t$q32012V[$i]\t$q42012V[$i]\t$q12013V[$i]\n";
} 

 
### companies
print wf "\n";                  
print wf "Q1 2012\n";                  
print wf "Company\tAcct\tQ1 2012 User sessions\tQ1 2012 Conversions\n";
$q = "select company, q.acct, sum(us) as us, sum(pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv) as conv
from qlog12Y as q, tgrams.main as m
where    
q.acct=m.acct
and date in ($rdate12_1) 
and heading='$h' 
and covflag='t'
group by q.acct
order by company, us desc  ";
my $sth = $dbh->prepare($q); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $comp = $$row[0];
 $acct = $$row[1]; 
 $us   = $$row[2];
 $conv = $$row[3];
 print wf "$comp\t$acct\t$us\t$conv\n";
} 
$sth->finish;
if($debug eq 1) { print "\n$q\n"; }
   

 
print wf "\n";                  
print wf "Q2 2012\n";                  
print wf "Company\tAcct\tQ2 2012 User sessions\tQ2 2012 Conversions\n";
$q = "select company, q.acct, sum(us) as us, sum(pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv) as conv
from qlog12Y as q, tgrams.main as m
where    
q.acct=m.acct
and date in ($rdate12_2) 
and heading='$h' 
and covflag='t'
group by q.acct
order by company, us desc  ";
my $sth = $dbh->prepare($q); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $comp = $$row[0];
 $acct = $$row[1]; 
 $us   = $$row[2];
 $conv = $$row[3];
 print wf "$comp\t$acct\t$us\t$conv\n";
} 
$sth->finish;
if($debug eq 1) { print "\n$q\n"; }
 
 
print wf "\n";
print wf "Q3 2012\n";                  
print wf "Company\tAcct\tQ3 2012 User sessions\tQ3 2012 Conversions\n";
$q = "select company, q.acct, sum(us) as us, sum(pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv) as conv
from qlog12Y as q, tgrams.main as m
where    
q.acct=m.acct
and date in ($rdate12_3) 
and heading='$h' 
and covflag='t'
group by q.acct
order by company, us desc  ";
my $sth = $dbh->prepare($q); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $comp = $$row[0];
 $acct = $$row[1]; 
 $us   = $$row[2];
 $conv = $$row[3];
 print wf "$comp\t$acct\t$us\t$conv\n";
} 
$sth->finish;
if($debug eq 1) { print "\n$q\n"; }
 
print wf "\n";
print wf "Q4 2012\n";                  
print wf "Company\tAcct\tQ4 2012 User sessions\tQ4 2012 Conversions\n";
$q = "select company, q.acct, sum(us) as us, sum(pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv) as conv
from qlog12Y as q, tgrams.main as m
where    
q.acct=m.acct
and date in ($rdate12_4) 
and heading='$h' 
and covflag='t'
group by q.acct
order by company, us desc  ";
my $sth = $dbh->prepare($q); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $comp = $$row[0];
 $acct = $$row[1]; 
 $us   = $$row[2];
 $conv = $$row[3];
 print wf "$comp\t$acct\t$us\t$conv\n";
} 
$sth->finish;
if($debug eq 1) { print "\n$q\n"; }
 
print wf "\n";
print wf "Q1 2013\n";
print wf "Company\tAcct\tQ1 2013 User Sessions\tQ1 2013 Conversions\n";
$q = "select company, q.acct, sum(us) as us, sum(pv +  pc + lw + em + ec + mt + cd + lc + vv + dv + iv + sm + pp + mv) as conv
from qlog13Y as q, tgrams.main as m
where   
q.acct=m.acct
and date in ($rdate13_1) 
and heading='$h' 
and covflag='t'
group by q.acct
order by company, us desc ";
my $sth = $dbh->prepare($q); 
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
{  
 $comp = $$row[0];
 $acct = $$row[1]; 
 $us   = $$row[2];
 $conv = $$row[3];
 print wf "$comp\t$acct\t$us\t$conv\n";
} 
$sth->finish;
if($debug eq 1) { print "\n$q\n"; }
  


close(wf);

$dbh->disconnect;

print "\n\nDone...\n\n";
