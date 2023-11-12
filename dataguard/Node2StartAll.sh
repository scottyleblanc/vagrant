# .bashrc
. oraenv <<EOF
cdb1
EOF

lsnrctl start

sqlplus / as sysdba <<EOF
startup mount; 
exit;
EOF


# add any additional db below
. oraenv <<EOF
cdb2
EOF

sqlplus / as sysdba <<EOF
startup;
exit;
EOF