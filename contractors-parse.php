#!/usr/bin/php
<?php
error_reporting(0);
$HERE="/home/tnet/src/contractors";

$infile  = "$HERE/data/contractor_cmg.txt";
$outfile = "$HERE/data/contractors.txt";  

$rf = fopen($infile, "r") or exit("Unable to open input file $infile\n");
$of = fopen($outfile, "w") or exit("Unable to open output file $outfile\n");
 
$id = 1; 
while ($line = fgets($rf, 4096))
 {
   $line = trim($line);
   list (
   $username,
   $lname,
   $fname,
   $mi,
   $prefix,
   $suffix,
   $gender,
   $contractor_no,
   $territory,
   $user_group,
   $active_ind,
   $p_street1,
   $p_street2,
   $p_city,
   $p_state,
   $p_zip,
   $phone,
   $fax,
   $email,
   $cell) = split("\,", $line);

   $ID              = $id;
   $USERNAME        = trim($username);
   $PASSWORD        = "";
   $COMMENTS        = "";
   $DISABLED        = 0;
   $LNAME           = trim($lname);
   $FNAME           = trim($fname);
   $MI              = trim($mi);
   $PREFIX          = trim($prefix);
   $SUFFIX          = trim($suffix);
   $GENDER          = trim($gender);
   $TITLE           = "";
   $CONTRACTOR_NO   = trim($contractor_no);
   $TERRITORY       = trim($territory);
   $USER_GROUP      = trim($user_group);
   $ACTIVE_IND      = trim($active_ind);
   $P_STREET1       = trim($p_street1);
   $P_STREET2       = trim($p_street2);
   $P_CITY          = trim($p_city);
   $P_STATE         = trim($p_state);
   $P_ZIP           = trim($p_zip);
   $P_SAO           = "";
   $U_STREET1       = "";
   $U_STREET2       = "";
   $U_CITY          = "";
   $U_STATE         = "";
   $U_ZIP           = "";
   $U_SAO           = "";
   $H_STREET1       = "";
   $H_STREET2       = "";
   $H_CITY          = "";
   $H_STATE         = "";
   $H_ZIP           = "";
   $H_SAO           = "";
   $TELEPHONE1      = trim($phone);
   $TELEPHONE2      = "";
   $TELEPHONE3      = "";
   $TELEPHONE_SAO   = "";
   $FAX1            = trim($fax);
   $FAX2            = "";
   $FAX3            = "";
   $FAX_SAO         = "";
   $EMAIL1          = trim($email);
   $EMAIL2          = "";
   $EMAIL3          = "";
   $HOME1           = "";
   $HOME2           = "";
   $HOME3           = "";
   $T_F1            = "";
   $T_F2            = "";
   $T_F3            = "";
   $T_F_SAO         = "";
   $T_VM1           = "";
   $T_VM2           = "";
   $T_VM3           = "";
   $T_VM_SAO        = "";
   $PAGER1          = "";
   $PAGER2          = "";
   $PAGER3          = "";
   $CELL1           = trim($cell);
   $CELL2           = "";
   $CELL3           = "";
   $TERR_CO_NAME    = "";
   $CLONE_OF        = "";
   $MOVE_DATE       = "0000-00-00 00:00:00";
   $STARGATE_GROUP  = "";
   $modified_by     = "";
   $created_date    = "0000-00-00 00:00:00";
 

   if( !preg_match("/http/",$USERNAME) && !preg_match("/subject line/",$USERNAME) && $USERNAME!="") {
   echo "$id\t$FNAME $LNAME\t$USERNAME\t$CONTRACTOR_NO\t$USER_GROUP\n";
   fputs($of, "$ID\t$USERNAME\t$PASSWORD\t$COMMENTS\t$DISABLED\t$LNAME\t$FNAME\t$MI\t$PREFIX\t$SUFFIX\t$GENDER\t$TITLE\t");
   fputs($of, "$CONTRACTOR_NO\t$TERRITORY\t$USER_GROUP\t$ACTIVE_IND\t$P_STREET1\t$P_STREET2\t$P_CITY\t$P_STATE\t$P_ZIP\t");
   fputs($of, "$P_SAO\t$U_STREET1\t$U_STREET2\t$U_CITY\t$U_STATE\t$U_ZIP\t$U_SAO\t$H_STREET1\t$H_STREET2\t$H_CITY\t");
   fputs($of, "$H_STATE\t$H_ZIP\t$H_SAO\t$TELEPHONE1\t$TELEPHONE2\t$TELEPHONE3\t$TELEPHONE_SAO\t$FAX1\t$FAX2\t$FAX3\t");
   fputs($of, "$FAX_SAO\t$EMAIL1\t$EMAIL2\t$EMAIL3\t$HOME1\t$HOME2\t$HOME3\t$T_F1\t$T_F2\t$T_F3\t$T_F_SAO\t$T_VM1\t");
   fputs($of, "$T_VM2\t$T_VM3\t$T_VM_SAO\t$PAGER1\t$PAGER2\t$PAGER3\t$CELL1\t$CELL2\t$CELL3\t$TERR_CO_NAME\t$CLONE_OF\t");
   fputs($of, "$MOVE_DATE\t$STARGATE_GROUP\t$modified_by\t$created_date\n");
   $id++;
   }
 } 
fclose($fp);
fclose($fp);
?> 
