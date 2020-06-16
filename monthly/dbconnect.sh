#!/bin/sh
#

#
# transfer a tables with create
#


function server {

 case $1 in
  'libra' )
    HOST="--host=libra.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'gemini' )
    HOST="--host=gemini.ec2.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'scorpio' )
    HOST="--host=scorpio.ec2.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'slice4' )
    HOST="--host=slice4.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'orion' )
    HOST="--host=orion.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'castor' )
    HOST="--host=castor.rds.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'pollux' )
    HOST="--host=pollux.rds.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'prodps' )
    HOST="--host=db.prod.ps.tnt.com"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'bweb01' )
    HOST="--host=bweb01.prod.tnt.com"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'taurus' )
    HOST="--host=taurus.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'crater' )
    HOST="--host=crater.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'po' )
    HOST="--host=po.rds.c.net"; USER="-ureporting -preporting"
  ;;

  'IRmaster' )
   HOST="--host=tnet-rpt-ec2-db1.tnt.com"; USER="-u -poJCt40EL" 
  ;;

  'IRclone' )
   HOST="--host=TNET-RPT-RDS-DB1.tnt.com"; USER="-u -poJCt40EL" 
  ;;

  'smith' )
   HOST="--host=smith.news.c.net"; USER="-u -pq07UIA6V"
  ;;

  'isotope' )
    HOST="--host=isotope.rds.c.net"; USER="-utnet -p7zLdNrISma6Uft"
  ;;

  'charon' )
    HOST="--host="; USER="-u -p"
  ;;

 esac

 echo "${HOST} ${USER}"
 
}

function copytable { 

FROMDB=$1
FROMTABLE=$2
if [ -z $3 ]
 then 
  TODB=${FROMDB} 
 else
  TODB=$3
fi

STARTTIME="$(date +%s)"

echo "${FROMDB}.${FROMTABLE} --> ${TODB}.${FROMTABLE}"
mysqldump --opt --quick --single-transaction ${FROMHOST} ${FROMDB} ${FROMTABLE} | mysql ${TOHOST} ${TODB};
# echo "mysqldump --opt --quick --single-transaction ${FROMHOST} ${FROMDB} ${FROMTABLE} "

ENDTIME="$(date +%s)"
SECONDS="$(expr $ENDTIME - $STARTTIME)"
echo ${SECONDS} seconds

} 


# FROMHOST=`server libra` 
# TOHOST=`server scorpio`

# copytable tgrams taxonomy tgrams
# copytable prodsearch itemattribs made2spec

