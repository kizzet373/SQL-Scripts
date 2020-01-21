/*=====BusinessObjectTypeIds=====

6 = Carrier

8 = Desk

9 = Driver

10 = Subsidiary

11 = Terminal

22 = Document Type

101 = Bill To

102 = Consignee

103 = Shipper

104 = Supplier

105 = Account Of

===============================*/


DECLARE 
	@UserID INT = 4664, 
	@BusinessObjectTypeId INT = '102',
	@ClientID INT = 221


--TOGGLES
DECLARE 
	@DeleteClientAssignments BIT = 1,
	@DeleteUserAssignments BIT = 1,
	@Insert

 

--Delete any site assignments from the Client

BEGIN TRAN

DELETE

FROM dbo.SecurityAssignment

WHERE ClientId = @ClientID

AND BusinessObjectTypeId = @BusinessObjectTypeId

COMMIT TRAN

 

--Delete any site assignments from the User

BEGIN TRAN

DELETE

FROM dbo.SecurityAssignment

WHERE UserId = @UserID

AND BusinessObjectTypeId = @BusinessObjectTypeId

COMMIT TRAN

 

--Assign new sites to User

BEGIN TRAN

INSERT INTO dbo.SecurityAssignment(

UserId

, ClientId

, BusinessObjectTypeId

, ObjectId --TMW cmp_id

)

SELECT @UserID AS UserID, 0 AS ClientID, @BusinessObjectTypeId AS BusinessObjectTypeID, co.CompanyId --*** CLIENT ID MUST BE 0 ***

FROM dbo.vwCompany co WITH(NOLOCK)

WHERE co.IsActive = 'Y'

AND co.IsConsignee = 'Y'

AND co.CompanyId IN (
'SE410320',
'SE410340',
'SE410350'
)

ORDER BY 1

COMMIT TRAN