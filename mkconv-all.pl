#!/usr/bin/perl
#
# Makes conversion report A - L

use DBI;
$dbh      = DBI->connect("", "", "");

$outfile = "convall.txt"; 
$column  = "Q1 2007";
$column = "Q1-Q2 2007";
$column = "Q1-Q2-Q3 2007";
$column = "Q1-Q2-Q3-Q4 2007";
$rlet    =  " '3','A','B','C','D','E','F','G','H','I','J','K','L'  ";

  
system("rm -f $outfile");
open(wf,  ">$outfile")  || die (print "Could not open $outfile\n");

# us - User Sessions 
# pv - Profiles Viewed  
# pc - Product Catalog Page's Viewed 
# lw - Links to Supplier's Website 
# em - E-mail Sent to Supplier 
# mi - Links to More Info 
# ec - E-mail Sent to Colleague 
# mt - Save Results to MyThomas 
# cd - Links to CADRegister 
# lc - Links to Catalogs 
 
print wf "tnt.com - Category Summary Report\n";
print wf "$column\n";     
                             
print wf "\t$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "$column\t";
print wf "Year-End 2006\t";
print wf "Year-End 2006\t";
print wf "Year-End 2005\t";
print wf "Year-End 2005\n";

print wf "Description\t";
print wf "Links to Your Website\t";
print wf "Profiles Viewed\t";
print wf "Links to Catalog\t";
print wf "Product Catalog Page's Viewed\t";
print wf "Links to More Info\t";
print wf "E-mail Sent to Supplier\t";
print wf "E-mail Sent to Colleague\t";
print wf "Save Results to MyThomas\t";
print wf "Links to CADRegister\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\t";
print wf "Total Conversions\t";
print wf "Total User Sessions\n";
           
# All headings in array     
$query  = " select description, heading from tgrams.headings where left(description, 1) in ($rlet) order by description ";
#$query .= " limit 10 ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {   
  $$row[0] =~ s/\,//g;
  $hd[$i]="$$row[0]|$$row[1]";
  $i++;
 }
$sth->finish;
  

$i=0; 
foreach $hd (@hd)         
 {                               
   ($d,$h) = split(/\|/,$hd);                       
 
   # Get Total 2005 US 
#   $query  = " select  sum(cnt) from thomquickUS05  where covflag='t' and heading='$h' and date in ($rdate05) "; 
    $query = " select * from thomconvall ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $y2005US = $$row[0];
     if($y2005US eq "") {$y2005US=0;}
    }
   $sth->finish;
 
   # Get Total 2006 US 
   $query  = " select  sum(cnt) from thomquickUS06 where heading='$h' and covflag='t' and date in ($rdate06) ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {       
     $y2006US = $$row[0];
     if($y2006US eq "") {$y2006US=0;}
    }
   $sth->finish;

   # Get Total 2007 US 
   $query  = " select  sum(cnt) from thomquickUS07 where heading='$h' and covflag='t' and date in ($rdate07) ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {       
     $y2007US = $$row[0];
     if($y2007US eq "") {$y2007US=0;}
    }
   $sth->finish;

   # Get Total 2008 US
   $query  = " select  sum(cnt) from thomquickUS08 where heading='$h' and covflag='t' and date in ($rdate08) ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {
     $y2008US = $$row[0];
     if($y2008US eq "") {$y2008US=0;}
    }
   $sth->finish;
  
   # Get Total 2005 conversions 
   $query  = " select  sum(cd + ec + em + lw + mi + mt + pc + pv) from qlog05Y where covflag='t' and acct>0 and date in ($rdate05) and heading='$h'  ";
   # Use this query for now
   $query  = " select sum(cnt) from quicklog05Y  "; 
   $query .= " where acct>0 and covflag='t' and type in ('cd','ec','em','lw','mi','mt','pc','pv') and date in ($rdate05) and heading='$h'  ";     
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $y2005 = $$row[0]; 
     if($y2005 eq "") {$y2005=0;}
    }
   $sth->finish;
 
   # Get Total 2006 conversions 
   $query  = " select  sum(cd + ec + em + lw + mi + mt + pc + pv) from qlog06Y where  covflag='t' and acct>0 and date in ($rdate06) and heading='$h'  ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    {      
     $y2006 = $$row[0]; 
     if($y2006 eq "") {$y2006=0;}
    }
   $sth->finish;
 
                  
   # 2007 conversions
   $query = " select ";
   $query .= "sum(pv) as pv, ";
   $query .= "sum(pc) as pc, ";
   $query .= "sum(lw) as lw, ";
   $query .= "sum(mi) as mi, ";
   $query .= "sum(em) as em, ";
   $query .= "sum(ec) as ec, ";
   $query .= "sum(mt) as mt, ";                                    
   $query .= "sum(cd) as cd,   ";
   $query .= "sum(lc) as lc   ";
   $query .= "from  qlog07Y  where heading='$h' and covflag='t' and date in ( $rdate07 ) and acct>0 ";
   my $sth = $dbh->prepare($query);
   if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
   while (my $row = $sth->fetchrow_arrayref)
    { 
      $pv = $$row[0];
      $pc = $$row[1];
      $lw = $$row[2];
      $mi = $$row[3];
      $em = $$row[4];
      $ec = $$row[5];
      $mt = $$row[6];
      $cd = $$row[7];
      $lc = $$row[8];
  
      if($pv eq "") { $pv = 0; }   
      if($pc eq "") { $pc = 0; }   
      if($lw eq "") { $lw = 0; }   
      if($mi eq "") { $mi = 0; }   
      if($em eq "") { $em = 0; }   
      if($ec eq "") { $ec = 0; }   
      if($mt eq "") { $mt = 0; }   
      if($cd eq "") { $cd = 0; }   
      if($lc eq "") { $lc = 0; }   

      $qtotal = $pv + $pc + $lw + $mi + $em + $ec + $mt + $cd + $lc;
      if($qtotal eq "") { $qtotal =0; }
    }  
   $sth->finish;
 
   # Description
   # Links to Your Website
   # Profiles Viewed
   # Links to Catalog
   # Product Catalog Page's Viewed
   # Links to More Info
   # E-mail Sent to Supplier
   # E-mail Sent to Colleague
   # Save Results to MyThomas
   # Links to CADRegister
   # 2007 Total Conversions
   # 2007 Total User Sessions
   # 2006 Total Conversions
   # 2006 Total User Sessions
   # 2007 Total Conversions
   # 2007 Total User Sessions\n";   
 
   print wf "$d\t$lw\t$pv\t$lc\t$pc\t$mi\t$em\t$ec\t$mt\t$cd\t$qtotal\t$y2007US\t$y2006\t$y2006US\t$y2005\t$y2005US\n";   
 
   $pv = $pc = $lc = $lw = $mi = $em = $ec = $mt = $cd = $qtotal = $y2005 = $y2006 = $y2007 = $y2005US = $y2006US = $y2007US = "";

  $i++;
  #if ($i%1000 == 0) { print "$i\r"; }
  print "$i $d\n";
 }
close(wf);

$dbh->disconnect;
