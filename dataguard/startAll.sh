#!/bin/bash
export HOST=`hostname -s`
NODE1="ol8-19-dg1"
NODE2="ol8-19-dg2"

if test "$HOST" = "$NODE1" 
then
# set env vars for cdb1
echo "$NODE1"
. oraenv <<EOF
cdb1
EOF
# start listener
lsnrctl start
# startup the database - open it, assume it is the primary
sqlplus / as sysdba <<EOF
startup;
exit;
EOF

elif test "$HOST" = "$NODE2" 
then 

# set env vars for cdb1
echo "$NODE2"
. oraenv <<EOF
cdb1
EOF
# start listener
lsnrctl start
# startup mount the database (assumes it is in standby and non adg)
sqlplus / as sysdba <<EOF
startup mount; 
exit;
EOF
# same for other databases on the host
. oraenv <<EOF
cdb2
EOF
sqlplus / as sysdba <<EOF
startup;
exit;
EOF

else
echo "$HOST not part of this setup"
fi
