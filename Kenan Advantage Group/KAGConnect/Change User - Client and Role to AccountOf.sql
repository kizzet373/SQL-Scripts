DECLARE @UserId INT = -1,
		@RoleId INT = 22,
		@ClientId INT = 423

UPDATE Security_User
SET ClientId = @ClientId
WHERE UserId=@UserId

update security_UserRole
SET RoleId = @RoleId
WHERE UserId=@UserId

SELECT top 1 * FROM Security_User
where UserId=@UserId

SELECT top 1 * FROM Security_UserRole
WHERE UserId=@UserId


