DECLARE
	@InsertString VARCHAR(MAX),
	@BusinessObjectTypeId INT = 3,
	@ClientId INT = 2, 
	@DeleteClientAssignments BIT = 1,
	@DeleteUserAssignments BIT = 1,
	@AssignSites BIT = 1,
	@AssignNotifications BIT = 1,
	@UserSiteString VARCHAR(MAX) = 'COST1167	DUPRHU	dispatchhu@duprelogistics.com
COST1172	DUPRDU	dispatchdu@duprelogistics.com
COST1201	DUPRDU	dispatchdu@duprelogistics.com
COST1330	DUPRHU	dispatchhu@duprelogistics.com
COST630	DUPRNA	dispatchna@duprelogistics.com
COST675	DUPRHU	dispatchhu@duprelogistics.com
MOCKDAL	DUPRDFW	dispatchda@duprelogistics.com
NUSTSAN1	DUPRSA	dispatchsa@duprelogistics.com
NUSTSAN2	DUPRSA	dispatchsa@duprelogistics.com
OAKFSAN	DUPRSA	dispatchsa@duprelogistics.com
PN011910	DUPRDFW	dispatchda@duprelogistics.com
PN029610	DUPRHU	dispatchhu@duprelogistics.com
PN029710	DUPRHU	dispatchhu@duprelogistics.com
PN037610	DUPRBI	dispatchbi@duprelogistics.com
PN626510	DUPRHU	dispatchhu@duprelogistics.com
PN627310	DUPRDFW	dispatchda@duprelogistics.com
PN629810	DUPRDFW	dispatchda@duprelogistics.com
PN718010	DUPRDFW	dispatchda@duprelogistics.com
SE22005	DUPRDFW	dispatchda@duprelogistics.com
SE22033	DUPRHU	dispatchhu@duprelogistics.com
SE36309	DUPRDFW	dispatchda@duprelogistics.com
SE36310	DUPRDFW	dispatchda@duprelogistics.com
SE36346	DUPRDFW	dispatchda@duprelogistics.com
SE36373	DUPRDFW	dispatchda@duprelogistics.com
SE36378	DUPRDFW	dispatchda@duprelogistics.com
SE36509	DUPRHU	dispatchhu@duprelogistics.com
SE36511	DUPRHU	dispatchhu@duprelogistics.com
SE36513	DUPRHU	dispatchhu@duprelogistics.com
SE36544	DUPRHU	dispatchhu@duprelogistics.com
SE40518	DUPRSA	dispatchsa@duprelogistics.com
SE40521	DUPRSA	dispatchsa@duprelogistics.com
SE40536	DUPRSA	dispatchsa@duprelogistics.com
SE40537	DUPRSA	dispatchsa@duprelogistics.com
SE40538	DUPRSA	dispatchsa@duprelogistics.com
SE40539	DUPRSA	dispatchsa@duprelogistics.com
SE40540	DUPRSA	dispatchsa@duprelogistics.com
SE40543	DUPRSA	dispatchsa@duprelogistics.com
SE40547	DUPRSA	dispatchsa@duprelogistics.com
SE40560	DUPRSA	dispatchsa@duprelogistics.com
SE40561	DUPRSA	dispatchsa@duprelogistics.com
SE40563	DUPRSA	dispatchsa@duprelogistics.com
SE40564	DUPRSA	dispatchsa@duprelogistics.com
SE40565	DUPRSA	dispatchsa@duprelogistics.com
SE40566	DUPRSA	dispatchsa@duprelogistics.com
SE40568	DUPRSA	dispatchsa@duprelogistics.com
SE40569	DUPRSA	dispatchsa@duprelogistics.com
SE40570	DUPRSA	dispatchsa@duprelogistics.com
SE40578	DUPRSA	dispatchsa@duprelogistics.com
SE40579	DUPRSA	dispatchsa@duprelogistics.com
SE40939	DUPRHU	dispatchhu@duprelogistics.com
SE40950	DUPRHU	dispatchhu@duprelogistics.com
SE40953	DUPRHU	dispatchhu@duprelogistics.com
SE40957	DUPRHU	dispatchhu@duprelogistics.com
SE40958	DUPRHU	dispatchhu@duprelogistics.com
SE40960	DUPRHU	dispatchhu@duprelogistics.com
SE40961	DUPRHU	dispatchhu@duprelogistics.com
SE40980	DUPRHU	dispatchhu@duprelogistics.com
SE40994	DUPRHU	dispatchhu@duprelogistics.com
SE40995	DUPRHU	dispatchhu@duprelogistics.com
SE40999	DUPRHU	dispatchhu@duprelogistics.com
SE41008	DUPRHU	dispatchhu@duprelogistics.com
SE41014	DUPRHU	dispatchhu@duprelogistics.com
SE410140	DUPRHU	dispatchhu@duprelogistics.com
SE41018	DUPRHU	dispatchhu@duprelogistics.com
SE41019	DUPRHU	dispatchhu@duprelogistics.com
SE410190	DUPRHU	dispatchhu@duprelogistics.com
SE410220	DUPRSA	dispatchsa@duprelogistics.com
SE41032	DUPRHU	dispatchhu@duprelogistics.com
SE410320	DUPRSH	dispatchsh@duprelogistics.com
SE410340	DUPRSH	dispatchsh@duprelogistics.com
SE410350	DUPRSH	dispatchsh@duprelogistics.com
SE41042	DUPRHU	dispatchhu@duprelogistics.com
SE41056	DUPRHU	dispatchhu@duprelogistics.com
SE41057	DUPRHU	dispatchhu@duprelogistics.com
SE41096	DUPRHU	dispatchhu@duprelogistics.com
SE41097	DUPRHU	dispatchhu@duprelogistics.com
SE59517	DUPRDFW	dispatchda@duprelogistics.com
SE59907	DUPRDFW	dispatchda@duprelogistics.com
SE59909	DUPRHU	dispatchhu@duprelogistics.com
SE70711	DUPRDFW	dispatchda@duprelogistics.com
SE70716	DUPRDFW	dispatchda@duprelogistics.com
SE70717	DUPRDFW	dispatchda@duprelogistics.com
SE70735	DUPRDFW	dispatchda@duprelogistics.com
SE70745	DUPRDFW	dispatchda@duprelogistics.com
SE70747	DUPRDFW	dispatchda@duprelogistics.com
SE70752	DUPRDFW	dispatchda@duprelogistics.com
SE70756	DUPRDFW	dispatchda@duprelogistics.com
SE70762	DUPRDFW	dispatchda@duprelogistics.com
SE71194	DUPRDFW	dispatchda@duprelogistics.com
SE71200	DUPRDFW	dispatchda@duprelogistics.com
SE71201	DUPRDFW	dispatchda@duprelogistics.com
SE71219	DUPRDFW	dispatchda@duprelogistics.com
SE71239	DUPRDFW	dispatchda@duprelogistics.com
SE71243	DUPRDFW	dispatchda@duprelogistics.com
SE71254	DUPRDFW	dispatchda@duprelogistics.com
SE71256	DUPRDFW	dispatchda@duprelogistics.com
SE71300	DUPRDFW	dispatchda@duprelogistics.com
SE71301	DUPRDFW	dispatchda@duprelogistics.com
SE71302	DUPRDFW	dispatchda@duprelogistics.com
SE71306	DUPRDFW	dispatchda@duprelogistics.com
SE71312	DUPRDFW	dispatchda@duprelogistics.com
SE71316	DUPRDFW	dispatchda@duprelogistics.com
SE71317	DUPRDFW	dispatchda@duprelogistics.com
SE71401	DUPRDFW	dispatchda@duprelogistics.com
SE71427	DUPRDFW	dispatchda@duprelogistics.com
SE71429	DUPRDFW	dispatchda@duprelogistics.com
SE71432	DUPRDFW	dispatchda@duprelogistics.com
SE71443	DUPRDFW	dispatchda@duprelogistics.com
SE71446	DUPRDFW	dispatchda@duprelogistics.com
SE71449	DUPRDFW	dispatchda@duprelogistics.com
SE71458	DUPRDFW	dispatchda@duprelogistics.com
SE71460	DUPRDFW	dispatchda@duprelogistics.com
SE71475	DUPRDFW	dispatchda@duprelogistics.com
SE71476	DUPRDFW	dispatchda@duprelogistics.com
SE71481	DUPRDFW	dispatchda@duprelogistics.com
SE71510	DUPRDFW	dispatchda@duprelogistics.com
SE71511	DUPRDFW	dispatchda@duprelogistics.com
SE71518	DUPRDFW	dispatchda@duprelogistics.com
SE71522	DUPRDFW	dispatchda@duprelogistics.com
SE71525	DUPRDFW	dispatchda@duprelogistics.com
SE80037	DUPRDFW	dispatchda@duprelogistics.com
SE80057	DUPRHU	dispatchhu@duprelogistics.com
SE80079	DUPRDFW	dispatchda@duprelogistics.com
SE80080	DUPRHU	dispatchhu@duprelogistics.com
SE80084	DUPRDFW	dispatchda@duprelogistics.com
SE80085	DUPRHU	dispatchhu@duprelogistics.com
SE80086	DUPRDFW	dispatchda@duprelogistics.com
SE80094	DUPRDFW	dispatchda@duprelogistics.com
SE81038	DUPRDFW	dispatchda@duprelogistics.com
SE81056	DUPRDFW	dispatchda@duprelogistics.com
SE81063	DUPRDFW	dispatchda@duprelogistics.com
SE81064	DUPRHU	dispatchhu@duprelogistics.com
SE81077	DUPRHU	dispatchhu@duprelogistics.com
SE81091	DUPRHU	dispatchhu@duprelogistics.com
SE81110	DUPRDFW	dispatchda@duprelogistics.com
SE81127	DUPRHU	dispatchhu@duprelogistics.com
SE81222	DUPRDFW	dispatchda@duprelogistics.com
SE81239	DUPRDFW	dispatchda@duprelogistics.com
SE81241	DUPRDFW	dispatchda@duprelogistics.com
SE90480	DUPRDFW	dispatchda@duprelogistics.com
SE90722	DUPRDFW	dispatchda@duprelogistics.com
SE90752	DUPRDFW	dispatchda@duprelogistics.com
SE90753	DUPRDFW	dispatchda@duprelogistics.com
SE90758	DUPRDFW	dispatchda@duprelogistics.com
SE90871	DUPRDFW	dispatchda@duprelogistics.com
WASTNEW3	DUPRSA	dispatchsa@duprelogistics.com
' --Should be ObjectId /tab Username /tab NotificationEmail /newline


--REMOVES ALL LEADING WHITESPACE CHARACTERS FROM RAW DATA STRING
WHILE (SUBSTRING(@UserSiteString,1,1) IN (CHAR(9),CHAR(10),CHAR(13),CHAR(32)))
BEGIN
	PRINT 'Leading'
	SET @UserSiteString = SUBSTRING(@UserSiteString,2,DATALENGTH(@UserSiteString) - 1)
END


--REMOVES ALL TRAILING WHITESPACE CHARACTERS FROM RAW DATA STRING
WHILE (SUBSTRING(@UserSiteString,DATALENGTH(@UserSiteString),1) IN (CHAR(9),CHAR(10),CHAR(13),CHAR(32)))
BEGIN
	PRINT 'Trailing'
	SET @UserSiteString = SUBSTRING(@UserSiteString,1,DATALENGTH(@UserSiteString) - 1)
END


--CONVERT RAW DATA TO SQL VALUES FOR DYNAMIC INSERT STATEMENT
SET @InsertString = CONCAT('(''',REPLACE(REPLACE(REPLACE(@UserSiteString,CHAR(9),''','''),CHAR(10),''),CHAR(13),CONCAT(''',0,',@ClientId,', ',@BusinessObjectTypeId,'), (''')),CONCAT(''',0,',@ClientId,', ',@BusinessObjectTypeId,')'))
SELECT @InsertString


--INSERT VALUES INTO TEMP TABLE
IF OBJECT_ID('tempdb..#User_SiteTable','U') IS NOT NULL
DROP TABLE #User_SiteTable;
CREATE TABLE #User_SiteTable (ObjectId VARCHAR(50), Username VARCHAR(30), NotificationEmail VARCHAR(50), UserId INT, ClientId INT, BusinessObjectTypeId INT)

EXEC('
	INSERT INTO #User_SiteTable
	VALUES ' + @InsertString)


--UPDATE USERIDS BASED ON SECURITY_USER TABLE
UPDATE #User_SiteTable
SET #User_SiteTable.UserId = Security_User.UserId
FROM #User_SiteTable
INNER JOIN Security_User
ON #User_SiteTable.Username = Security_User.Username


SELECT * FROM #User_SiteTable


--DELETE ANY SITE ASSIGNMENTS FROM THE CLIENT
IF (@DeleteClientAssignments = 1)
BEGIN
	BEGIN TRAN
	
	DELETE
	FROM dbo.SecurityAssignment
	WHERE ClientId = (SELECT DISTINCT ClientId FROM #User_SiteTable)
	AND BusinessObjectTypeId = @BusinessObjectTypeId

	COMMIT TRAN
END


--DELETE ANY SITE ASSIGNMENTS FROM THE USER
IF(@DeleteUserAssignments = 1)
BEGIN
	BEGIN TRAN

	DELETE
	FROM dbo.SecurityAssignment
	WHERE UserId IN (SELECT DISTINCT Security_User.UserId FROM #User_SiteTable INNER JOIN Security_User ON #User_SiteTable.Username = Security_User.Username)
	AND BusinessObjectTypeId = @BusinessObjectTypeId

	COMMIT TRAN
END


--ASSIGN SITES TO USERS
IF(@AssignSites = 1)
BEGIN
	BEGIN TRAN
	
	INSERT INTO dbo.SecurityAssignment(
	UserId
	, ClientId
	, BusinessObjectTypeId
	, ObjectId --TMW cmp_id
	)
	SELECT #User_SiteTable.UserId, 0 AS ClientID, #User_SiteTable.BusinessObjectTypeId, #User_SiteTable.ObjectId --*** CLIENT ID MUST BE 0 ***
	FROM #User_SiteTable
	INNER JOIN dbo.vwCompany WITH(NOLOCK)
	ON #User_SiteTable.ObjectId = dbo.vwCompany.CompanyId
	WHERE vwCompany.IsActive = 'Y'
	AND vwCompany.IsConsignee = 'Y'

	COMMIT TRAN
END




DECLARE @AdminAccountId INT = 1259,
	@MessageTypeId INT = 11,
	@EventTypeId INT = 10,
	@AlertTypeId INT = 13

--CREATE NOTIFICATIONS
IF(@AssignNotifications = 1)
BEGIN
	BEGIN TRAN

	DELETE FROM NotificationSubscription
	WHERE EXISTS(
		SELECT 1
		FROM #User_SiteTable
		INNER JOIN UserAlertProfile
		ON	UserAlertProfile.UserAlertProfileId = NotificationSubscription.UserAlertProfileId
			AND UserAlertProfile.UserId = @AdminAccountId
			AND UserAlertProfile.ProfileName = CONCAT(#User_SiteTable.Username, ' Emails')
			AND UserAlertProfile.MessageDestination = #User_SiteTable.NotificationEmail
		WHERE #User_SiteTable.ObjectId = NotificationSubscription.ConsigneeId
	)
	
	DELETE FROM UserAlertProfile
	WHERE EXISTS(
		SELECT 1
		FROM #User_SiteTable
		WHERE UserAlertProfile.UserId = @AdminAccountId
			AND UserAlertProfile.ProfileName = CONCAT(#User_SiteTable.Username, ' Emails')
			AND MessageDestination = #User_SiteTable.NotificationEmail
	)

	INSERT INTO UserAlertProfile (UserId, ProfileName, MessageTypeId, MessageDestination, StartTime, EndTime, IsDeleted, CreatedByUserId, CreatedOn, ModifiedByUserId, ModifiedOn)
	SELECT
		@AdminAccountId, CONCAT(MAX(#User_SiteTable.Username), ' Emails'), 11, MAX(#User_SiteTable.NotificationEmail), NULL, NULL, 0, @AdminAccountId, GETDATE(), @AdminAccountId, GETDATE()
	FROM #User_SiteTable
	GROUP BY #User_SiteTable.UserId

	INSERT INTO NotificationSubscription (UserAlertProfileId, ConsigneeId, EventTypeId, AlertTypeId, IsDeleted, CreatedByUserId, CreatedOn, ModifiedByUserId, ModifiedOn) 
	SELECT MAX(UserAlertProfile.UserAlertProfileId), #User_SiteTable.ObjectId, @EventTypeId, @AlertTypeId, 0, @AdminAccountId, GetDate(), @AdminAccountId, GetDate()
	FROM #User_SiteTable
	INNER JOIN UserAlertProfile
	ON 
		UserAlertProfile.UserId = @AdminAccountId
		AND UserAlertProfile.ProfileName = CONCAT(#User_SiteTable.Username, ' Emails')
		AND MessageDestination = #User_SiteTable.NotificationEmail
	GROUP BY #User_SiteTable.ObjectId
	COMMIT TRAN
END



DROP TABLE #User_SiteTable;




