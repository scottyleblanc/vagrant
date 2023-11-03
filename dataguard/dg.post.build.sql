-- changes to make post build 
connect sys/"S1sPassword1!"@cdb1 as sysdba
alter user sysdg identified by oracle account unlock;
grant sysdg to sysdg;

connect sys/"S1sPassword1!"@cdb1_stby as sysdba
alter database flashback on;
