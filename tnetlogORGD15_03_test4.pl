#!/bin/sh
#



FILE="preprocessing.txt";

echo "select acct,org,isp,tinid from thomtnetlogORGflagExtra"  | mysql -As thomas > ${FILE}

echo "Done...";
exit;




FILE="webtraxs_cross.bak.mar";

echo "select * from thomwebtraxs_cross"  | mysql -As thomas > ${FILE}

echo "Done...";
exit;

exit;

#rm -f /opt/tnet/${FILE}

#echo "select org, if(latitude='0.0001', 'R', '') from tnetlogORGSITED14M where isp='N' and block='N' group by org"  | mysql -As thomas > ${FILE}

   
echo "alter table main_history add  vfax varchar(20) NOT NULL default ''           " | mysql -As tgrams
echo "alter table main_history add  vtollfreefax varchar(20) NOT NULL default ''  "  | mysql -As tgrams
echo "alter table main_history add  allstates varchar(255) NOT NULL default ''     " | mysql -As tgrams
echo "alter table main_history add  trackphone varchar(20) NOT NULL default ''  " | mysql -As tgrams
 
echo "Done...";
exit;
