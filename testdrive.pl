#!/usr/bin/perl
#

$fdate   = $ARGV[0];
if($fdate eq "") {print "\n\nForgot to add date yymm\n\n"; exit;}

$fyear    = "20" . substr($fdate, 0, 2);
$yy       =  substr($fdate, 0, 2);
$mm       =  substr($fdate, 2, 2);
$quicklog = "thomqlog" . $yy . "Y";
$quickus  = "thomquickUS" . $yy ;
#$orgtable = "thomtnetlogORGCATN" .  $yy . "_" $mm; // use for < 2008 
#$orgtable = "thomtnetlogORGCATD" .  $yy . "_" $mm; 
$orgtable = "thomtnetlogORGCATD" . $yy . "_" . $mm ;
$outfile  = "testdrive_cnts.txt"; 
 
system("rm -f $outfile");
open(wf, ">$outfile")  || die (print "Could not open $outfile\n");        

use DBI;
require "/usr/wt/trd-reload.ph";
 
$query = "select trim(org) as org from thomtnetlogORGflag where isp='Y' || block='Y' ";
my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 {
  $$row[0] =~ s/^\s+//;
  $$row[0] =~ s/\s+$//;
  $$row[0] =~ tr/[A-Z]/[a-z]/;
  $badorg{$$row[0]}  = $$row[0];
 }
$sth->finish;


# Get super cats
$z=0;
$placeholder=""; 
$query  = " select keyword,trim(name) from tgrams.browselist where homepage=1 and display=1 and browse=1 and parent=0 ";
#$query .= "and keyword=157 ";
$query .= "group by name";
#print "$query\n";
#$query .= " limit 3 ";

#$query  = " select keyword,trim(name) from browselist where homepage=1 and display=1 and browse=1 and parent=0  and keyword=256 group by name";
#$query .= " limit 1 ";

#print "\n\n$query\n\n"; exit;



my $sth = $dbh->prepare($query);
if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
while (my $row = $sth->fetchrow_arrayref)
 { 
   $supernum  = $$row[0];
   $supername = $$row[1];
  
   # Now get sub cats 
   $subq ="select keyword, name from tgrams.browselist where parent='$supernum' and display!='' order by name ";
   #$subq ="select keyword, name from browselist where parent='157' and keyword=255 and display!='' order by name ";
  
   my $subr = $dbh->prepare($subq);
   if (!$subr->execute) { print "Error" . $tbh->errstr . "\n"; }
   while (my $srow = $subr->fetchrow_arrayref)
    { 
     $subnum   = $$srow[0];
     $subname  = $$srow[1];
 
     # check for lower teer
     $subq2 = "select count(*) as n from tgrams.browselist where parent=$subnum and display>''";
     my $subr2 = $dbh->prepare($subq2);
     if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
     while (my $srow2 = $subr2->fetchrow_arrayref)
      {  $count   = $$srow2[0]; }  
     $subr2->finish; 

     if($count ne 0)
       { 

         $subq2 = "select keyword, name from tgrams.browselist where parent=$subnum and display>'' order by name";
         my $subr2 = $dbh->prepare($subq2);
         if (!$subr2->execute) { print "Error" . $tbh->errstr . "\n"; }
         while (my $srow2 = $subr2->fetchrow_arrayref)
          {    
           $subnum2   = $$srow2[0];
           $subname2  = $$srow2[1];
           $record[$z] = "$supername\t$supernum\t$subname\t$subname2\t$subnum2";
           #print "$supername\t$supernum\t$subname\t$subname2\t$subnum2\n";
           $z++;  
           $subnum2 =""; $subname2="";
          }
         $subr2->finish;

       }
      else
        {

         $record[$z] = "$supername\t$supernum\t$subname\t$placeholder\t$subnum";
         #print "$supername\t$supernum\t$subname\t$placeholder\t$subnum\n";
         $z++;   
         $subname="";  $subnum="";          

        }

  
     $count = 0 ;
   }
   $subr->finish;



  $supername=""; $supernum=""; 
  $i++;
 }
$sth->finish;
print "\nTotal Super Categories: $i \n";
print "Total Sub Categories: $z \n\n";
 

# Now get headings & counts 
$a=1;
foreach $record (@record)
 {  
  ($supername,$supernum,$subname,$subname2,$subnum) = split(/\t/,$record);
   print "$a $supername\t$supernum\t$subname\t$subname2\t$subnum\n";


  # Now get each heading  
  $query  = " SELECT heading FROM tgrams.browseheads WHERE keyword=$subnum group by heading ";
  # print "$query\n";

  $j=0;
  my $sth = $dbh->prepare($query); 
  if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
  while (my $row = $sth->fetchrow_arrayref)
   { 
    $heading[$subnum] .= "$$row[0],";  
    $j++;
   } 
  $sth->finish;
  chop($heading[$subnum]);
  $headingct[$subnum] = $j;

  if($headingct[$subnum] ne 0)
   {
     # Get each adv/free  
     $query  = " select sum(cnt_headin) as comps, sum(adv) as adv  from tgrams.covprodhd where area='NA' and heading in($heading[$subnum]) ";
     my $sth = $dbh->prepare($query);  
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      { 
       $comps[$subnum] = "$$row[0]";  
       $adv[$subnum]   = "$$row[1]";  
      } 
     $sth->finish;
 
     # Get conv
     $query  = "select  sum(cd + cl + ec + em + lw + mi + mt + pc + pv + lc + vv + dv + iv + sm + pp + mv) as conv from $quicklog where date='$fdate' and covflag='t' and heading in ($heading[$subnum]) and acct>0 ";
     my $sth = $dbh->prepare($query);   
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {    
       $conv[$subnum] = "$$row[0]";
      } 
     $sth->finish;
     #print "\n\n $query \n\n";
 
     $query  = "select sum(cnt) from $quickus where date='$fdate' and covflag='t' and heading in ($heading[$subnum])  ";
     my $sth = $dbh->prepare($query);    
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {  
       $uses[$subnum] = "$$row[0]";   
      } 
     $sth->finish;
     #print "\n\n $query \n\n";

     # Get Visitors 
     $stop=0; 
     # use for < 2008 
     #$query  = "select trim(org), sum(cnt) as n from $orgtable where date='$fdate' and heading in ($heading[$subnum]) group by org order by n desc";
     $query  = "select trim(org), sum(cnt) as n from $orgtable where date='$fdate' and oid>'' and isp='N' and block='N' and heading in ($heading[$subnum]) group by org order by n desc";
     #print "\n\n $query \n\n";      
     my $sth = $dbh->prepare($query);    
     if (!$sth->execute) { print "Error" . $dbh->errstr . "<BR>\n"; exit(0); }
     while (my $row = $sth->fetchrow_arrayref)
      {     
       $$row[0] =~ s/^\s+//;
       $$row[0] =~ s/\s+$//;
       $$row[0] =~ tr/[A-Z]/[a-z]/; 
       # might as well leave this check up for > 2008 can hurt
       if($badorg{$$row[0]} eq "" and $stop<26) { $visit[$subnum] .= "$$row[0]|";  $stop++; }
      }  
     $sth->finish;
 
          
     #$heading[$subnum] =~ s/\,/\, /g;
               
     print wf "$fdate\t$supername\t$supernum\t$subname\t$subname2\t$subnum\t$headingct[$subnum]\t";
     print wf "$comps[$subnum]\t$adv[$subnum]\t$uses[$subnum]\t$conv[$subnum]\t0\t$visit[$subnum]\n";

    }

   $supername="";
   $supernum="";
   $subname="";
   $subname2="";
   $subnum="";
   $headingct[$subnum]="";
   $comps[$subnum]=""; 
   $adv[$subnum]="";
   $uses[$subnum]="";
   $conv[$subnum]="";
   $heading[$subnum]="";   
   $visit[$subnum]="";
   $a++;
}

 
close(wf);
$rc = $dbh->disconnect;
  
system("mysqlimport -rL tgrams $DIR/$outfile");
 
#print "\nTry to copy file to remote servers\n"; 
#system("scp $outfile orion:/tmp");
#system("scp $outfile libra:/tmp");

print "\n\nDone...\n\n";
