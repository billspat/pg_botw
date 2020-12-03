# example .Renviron file for using Azure postgres.   
# Replace <placeholders> with actual values and save as filename .Renviron
# and restart your R session
# use single quotes around DBUSER and DBPASSWORD values. 
DBHOST=<yourservername>.postgres.database.azure.com
DBPORT=5432
DBUSER='<yourdbadminid>n@<yourservername>'
DBPASSWORD='<yourpassword>'
