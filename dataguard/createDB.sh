
# -- -----------------------------------------------------------------------------
# -- File Name:   : createDB.sh
# -- -----------------------------------------------------------------------------

export ORACLE_BASE=/u01/app/oracle
export ORA_INVENTORY=/u01/app/oraInventory
export ORACLE_HOME_EXT=product/19.0.0/dbhome_1

export ORACLE_SID=cdb2
export DB_NAME=${ORACLE_SID}
export PDB_NAME=rman

export DB_DOMAIN=world
if [ "${DB_DOMAIN}" != "" ]; then
  export DB_DOMAIN_STR=".${DB_DOMAIN}"
else
  export DB_DOMAIN_STR=
fi

export SYS_PASSWORD="S1sPassword1!"
export PDB_PASSWORD="PdbPassword1!"

export DATA_DIR=/u01/oradata
export NODE1_DB_UNIQUE_NAME=${ORACLE_SID}

dbca -silent -createDatabase                                                 \
  -templateName General_Purpose.dbc                                          \
  -sid ${ORACLE_SID}                                                         \
  -responseFile NO_VALUE                                                     \
  -gdbname ${DB_NAME}${DB_DOMAIN_STR}                                        \
  -characterSet AL32UTF8                                                     \
  -sysPassword ${SYS_PASSWORD}                                               \
  -systemPassword ${SYS_PASSWORD}                                            \
  -createAsContainerDatabase true                                            \
  -numberOfPDBs 1                                                            \
  -pdbName ${PDB_NAME}                                                       \
  -pdbAdminPassword ${PDB_PASSWORD}                                          \
  -databaseType MULTIPURPOSE                                                 \
  -automaticMemoryManagement false                                           \
  -totalMemory 2048                                                          \
  -storageType FS                                                            \
  -datafileDestination "${DATA_DIR}"                                         \
  -redoLogFileSize 50                                                        \
  -emConfiguration NONE                                                      \
  -initparams db_name=${DB_NAME},db_unique_name=${NODE1_DB_UNIQUE_NAME}      \
  -ignorePreReqs


echo "******************************************************************************"
echo "Set the PDB to auto-start." `date`
echo "******************************************************************************"
sqlplus / as sysdba <<EOF
ALTER SYSTEM SET db_create_file_dest='${DATA_DIR}';
ALTER SYSTEM SET db_create_online_log_dest_1='${DATA_DIR}';
ALTER PLUGGABLE DATABASE ${PDB_NAME} OPEN;
ALTER PLUGGABLE DATABASE ${PDB_NAME} SAVE STATE;
ALTER SYSTEM RESET local_listener;
exit;
EOF

echo "******************************************************************************"
echo "Configure archivelog mode, standby logs and flashback." `date`
echo "******************************************************************************"
mkdir -p ${ORACLE_BASE}/fast_recovery_area

sqlplus / as sysdba <<EOF

-- Set recovery destination.
alter system set db_recovery_file_dest_size=20G;
alter system set db_recovery_file_dest='${ORACLE_BASE}/fast_recovery_area';

-- Enable archivelog mode.
SHUTDOWN IMMEDIATE;
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

ALTER DATABASE FORCE LOGGING;
-- Make sure at least one logfile is present.
ALTER SYSTEM SWITCH LOGFILE;
exit;
EOF

echo "******************************************************************************"
echo "Create an RMAN catalog." `date`
echo "******************************************************************************"

sqlplus / as sysdba <<EOF
alter session set container=rman;

create tablespace rmancatalog datafile '/u01/oradata/CDB2/rman/rmancatalog.dbf'
size 32M autoextend on next 64k;

create user rmancatalog identified by rmancatalog;
alter user rmancatalog default tablespace rmancatalog;
alter user rmancatalog temporary tablespace temp;
-- -----------------------------------------------------------------------------
--  RMANCATALOG requires the following grants
-- -----------------------------------------------------------------------------
alter user rmancatalog quota unlimited on rmancatalog;
grant RECOVERY_CATALOG_OWNER to rmancatalog;
grant create session to rmancatalog;
exit;
EOF
