	declare @LocalTime datetime = '2019-08-28 08:20:00.000'
	declare @CityCode int = 82695
	declare @TZOffset int
	DECLARE @intYear integer
	DECLARE @strMarch1 varchar(18)
	DECLARE @strNov1 varchar(18)
	DECLARE @DayOfTheWeek integer
	DECLARE @DateDifference integer
	DECLARE @datDSTStarts datetime
	DECLARE @datDSTEnds datetime
	DECLARE @intGMTOffset integer

	/* Calculate when DST begins for the year in question */
	SET @intYear = DATEPART(yyyy, @LocalTime);
	SET @strMarch1 = CONVERT(varchar(18), @intYear) + '0301 02:00:00';
	SET @DayOfTheWeek = DATEPART(dw, @strMarch1); /* Day March 1 falls on in that year */
	SET @DateDifference = 8 - @DayOfTheWeek; /* # of days between that day and the following Sunday ("the first Sunday in April", i.e. when DST begins)*/
	SET @datDSTStarts = DATEADD(dd, @DateDifference+7, @strMarch1);

	/* Calculate when DST is over for the year in question */
	SET @strNov1 = CONVERT(varchar(18), @intYear) + '1101 02:00:00';
	SET @DayOfTheWeek = DATEPART(dw, @strNov1); /* Day Nov 1 falls on in that year */
	SET @DateDifference = 8 - @DayOfTheWeek; /* # of days between that day and the previous Sunday ("the last Sunday in October", i.e. when DST ends) */
	SET @datDSTEnds = DATEADD(dd, @DateDifference, @strNov1);


	--get timezone offset for city table
	select top 1 @TZOffset = 
		CASE WHEN cty_DSTApplies = 'Y' and @LocalTime between @datDSTStarts and @datDSTEnds THEN cty_gmtdelta - 1 ELSE cty_gmtdelta END
		from city with (nolock) where cty_code = @CityCode and cty_gmtdelta is not null

	if @TZOffset is NULL 
	select @TZOffset =  datediff(hh,getdate(), getutcdate())
	
	select @TZOffset
