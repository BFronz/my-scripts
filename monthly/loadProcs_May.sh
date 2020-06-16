#!/bin/bash
#
#  Load Sales Resource procs from xml grab into log files
curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_drilldown_new_combined_ip&nat=0&fmt=1"  -o orgDomainVisitsDrill.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_ciddrilldown_new_combined_ip&nat=0&fmt=1"  -o advOrgVisitsDrill.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_ciddrilldown_new_cov_combined_ip&nat=0&fmt=1" -o advOrgVisitsDrillCov.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_hdgdrilldown_new&nat=0&fmt=1" -o OrgVisitsCatDrillOrig.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_hdgdrilldown_new_cov&nat=0&fmt=1" -o OrgVisitsCatDrillCovOrig.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_hdgdrilldown_new_combined_ip&nat=0&fmt=1" -o OrgVisitsCatDrillNew.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_hdgdrilldown_new_cov_combined_ip&nat=0&fmt=1" -o OrgVisitsCatDrillCovNew.xml 

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_psorg_combined_ip&nat=0&fmt=1" -o advPSOrgDrill.xml &

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_cid_catnav_org_combined_ip&nat=0&fmt=1"  -o CatFlatVisitors.xml &

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_cid_catnav_org_cov_combined_ip&nat=0&fmt=1" -o CatFlatVisitorsCov.xml &

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=N&start=05/01/2014&end=06/01/2014&dset=v_drilldown_new_combined_ip&nat=0&fmt=1" -o news_orgDomainVisitsDrill.xml &

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=N&start=05/01/2014&end=06/01/2014&dset=v_ciddrilldown_new_combined_ip&nat=0&fmt=1" -o news_advOrgVisitsDrill.xml &

curl -sS  "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=N&start=05/01/2014&end=06/01/2014&dset=v_ciddrilldown_new_cov_combined_ip&nat=0&fmt=1" -o news_advOrgVisitsDrillCov.xml &

curl -sS "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_orgcid_new&nat=0&fmt=1" -o advOrgVisits.xml &

curl -sS "http://thomasxml.insightrocket.com/xmlgrab2.pl?site=T&start=05/01/2014&end=06/01/2014&dset=v_orgdomhdg_new&nat=0&fmt=1" -o  catorgvisits.xml &



