--DONT EVER RUN THIS ON PROD!

BEGIN 
INSERT INTO ttsusers (usr_fname, usr_lname,usr_userid,usr_sysadmin,usr_windows_userid, usr_password) 
VALUES ('Kirkland' , 'Brown' , 'kibrown' , 'Y' , 'thekag\kibrown', '' ) 
INSERT INTO ttsgroupasgn (grp_id, usr_userid) VALUES ('FB ADMIN','kibrown') 
INSERT INTO ttsgroupasgn (grp_id, usr_userid) VALUES ('FB FIND','kibrown') 
INSERT INTO ttsgroupasgn (grp_id, usr_userid) VALUES ('FB DATA ENTRY','kibrown') 
INSERT INTO ttsgroupasgn (grp_id, usr_userid) VALUES ('FB SEND TO FQ','kibrown') 
INSERT INTO ttsgroupasgn (grp_id, usr_userid) VALUES ('DS BASIC USER','kibrown') 
END 
GO