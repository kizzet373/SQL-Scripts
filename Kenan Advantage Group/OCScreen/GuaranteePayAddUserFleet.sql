--GuaranteePay User Fleet Query.
--Update the variables, and execute the query. 

--ttsuser record exists for johwright means the record was already there
--ttsuser record added for johwright means it added it

--(0 row(s) affected) or less than means that user was already assigned to the terminal(s)

--Server:  KAGDC1SQL03 
--Database: TMW_PROD

--Update these values.  ---------------------------------------------
--This info should be provided from the user that created the ticket (Sara or Debbie)

DECLARE @FirstName VARCHAR(10) = 'Kirk',
        @LastName VARCHAR(20) = 'Brown',
        @Username VARCHAR(20) = 'Kibrown', --User's Windows' Login without domain 'shawk' 'zneslon' etc...
        @Email VARCHAR(128) = 'Kirk.Brown@thekag.com',
        @Fleets VARCHAR(MAX) = '510971';   --Supports single or comma-delimited fleets   '530271'   or   '530271,530272,530273'
		
---------------------------------------------------------------------


IF
(
    SELECT 1 FROM dbo.ttsusers WITH (NOLOCK) WHERE usr_userid = @Username
) = 1
BEGIN
    PRINT 'ttsuser record exists for ' + @Username;
END;
ELSE
BEGIN
    INSERT INTO dbo.ttsusers
    (
        usr_fname,
        usr_mname,
        usr_lname,
        usr_userid,
        usr_password,
        usr_localini,
        usr_pwexp_dt,
        usr_pwexp_flag,
        usr_pwexp_period,
        usr_sysadmin,
        usr_type1,
        usr_mail_address,
        usr_thirdparty,
        usr_supervisor,
        usr_lgh_type1,
        usr_candeletepay,
        usr_booking_terminal,
        usr_contact_number,
        usr_dateformat,
        usr_timeformat,
        usr_printinvoices,
        usr_windows_userid,
        usr_type2,
        usr_contact_fax,
        encrypt_password_flag,
        encrypt_password_status,
        usr_DSTApplies,
        usr_GMTDelta,
        usr_TZMins,
        usr_maxlockcount,
        usr_usedatecalendar,
        usr_Imagepath,
        usr_executing_terminal,
        usr_pwdchange
    )
    VALUES
    (   @FirstName,            -- usr_fname - char(10)
        NULL,                  -- usr_mname - char(1)
        @LastName,             -- usr_lname - char(20)
        @Username,             -- usr_userid - char(20)
        'NOTUSED',             -- usr_password - char(20)
        NULL,                  -- usr_localini - char(35)
        GETDATE(),             -- usr_pwexp_dt - datetime
        '',                    -- usr_pwexp_flag - char(1)
        90,                    -- usr_pwexp_period - int
        'N',                   -- usr_sysadmin - char(1)
        '',                    -- usr_type1 - varchar(6)
        @Email,                -- usr_mail_address - varchar(128)
        'UNKNOWN',             -- usr_thirdparty - varchar(12)
        'N',                   -- usr_supervisor - char(1)
        'UNK',                 -- usr_lgh_type1 - varchar(6)
        'N',                   -- usr_candeletepay - char(1)
        'UNK',                 -- usr_booking_terminal - varchar(12)
        NULL,                  -- usr_contact_number - varchar(25)
        'mm/dd/yy',            -- usr_dateformat - char(15)
        'hh:mm',               -- usr_timeformat - char(15)
        'N',                   -- usr_printinvoices - char(1)
        'THEKAG\' + @Username, -- usr_windows_userid - varchar(128)
        '',                    -- usr_type2 - varchar(6)
        NULL,                  -- usr_contact_fax - varchar(25)
        NULL,                  -- encrypt_password_flag - char(1)
        NULL,                  -- encrypt_password_status - varchar(6)
        NULL,                  -- usr_DSTApplies - char(1)
        NULL,                  -- usr_GMTDelta - smallint
        NULL,                  -- usr_TZMins - smallint
        NULL,                  -- usr_maxlockcount - int
        NULL,                  -- usr_usedatecalendar - char(1)
        NULL,                  -- usr_Imagepath - varchar(100)
        NULL,                  -- usr_executing_terminal - varchar(12)
        'N'                    -- usr_pwdchange - char(1)
        );
    PRINT 'ttsuser record added for ' + @Username;
END;




INSERT INTO dbo.FuelRelations
(
    RelType,
    Terminal,
    BillTo,
    Pickup,
    Delivery,
    Supplier,
    DeliveryState,
    StringValue,
    DecimalValue,
    LastUpdate,
    LastUpdateby,
    Commodity,
    Cmd_class,
    LearnedCount,
    AccountOf
)
SELECT 'USRFLEET',
       lf.abbr,
       '',
       '',
       '',
       '',
       '',
       @Username,
       '0.00',
       GETDATE(),
       SUSER_SNAME(),
       '',
       '',
       '2.00',
       ''
FROM dbo.labelfile lf WITH
    (NOLOCK)
WHERE UPPER(lf.labeldefinition) = 'FLEET'
      AND lf.retired = 'N'
      --AND lf.abbr NOT IN ( '00000', 'UNK' )
      AND lf.abbr IN
          (
              SELECT value FROM dbo.CSVStringsToTable_fn(@Fleets)
          )
      AND lf.abbr NOT IN
          (
				SELECT Terminal
				FROM dbo.FuelRelations
				WHERE StringValue = @Username
				AND RelType='USRFLEET'
				AND Terminal IN
				(
					SELECT value FROM dbo.CSVStringsToTable_fn(@Fleets)
				)
          )
ORDER BY lf.abbr;