create or replace  PROCEDURE SystemSet_Update(
	emailserver_1  varchar2 , 
	debugmode_2   char , 
	logleaveday_3  smallint ,
	defmailuser_4  varchar2,
	defmailpassword_5  varchar2,
	pop3server_6  varchar2 ,
	filesystem_7 varchar2 ,
	filesystembackup_8 varchar2 ,
	filesystembackuptime_9 integer,
	needzip_10 char ,
	needzipencrypt_11 char ,
	defmailserver_12 varchar2 ,
	defmailfrom_13 varchar2 ,
	defneedauth_14 char ,
	smsserver_15 varchar2 ,
	licenseRemind_17 char ,
	remindUsers_18 varchar2 ,
	remindDays_19 varchar2 , 
	emailfilesize_20 integer,
	 flag out integer, 
	 msg out varchar2,
	 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
 update SystemSet set 
        emailserver=emailserver_1 , 
        debugmode=debugmode_2,
        logleaveday=logleaveday_3 ,
        defmailuser=defmailuser_4 , 
        defmailpassword=defmailpassword_5 , 
        pop3server=pop3server_6 ,
        filesystem=filesystem_7,
        filesystembackup=filesystembackup_8 ,
        filesystembackuptime=filesystembackuptime_9 , 
        needzip=needzip_10 , 
        needzipencrypt=needzipencrypt_11 ,
        defmailserver=defmailserver_12 ,
        defmailfrom=defmailfrom_13 ,
        defneedauth=defneedauth_14 ,
        smsserver=smsserver_15 ,
	licenseRemind=licenseRemind_17 ,
	remindUsers=remindUsers_18 ,
	remindDays=remindDays_19 ,
	emailfilesize=emailfilesize_20;
end;
/