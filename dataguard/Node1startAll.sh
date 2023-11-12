# .bashrc
. oraenv <<EOF
cdb1
EOF
sqlplus / as sysdba <<EOF
startup;
exit;
EOF
lsnrctl start