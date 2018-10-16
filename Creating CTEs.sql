WITH Table1 (PokeID, PokeName)
AS
(	
	SELECT 1, 'bulb' UNION ALL
	SELECT 2, 'ivy' UNION ALL
	SELECT 3, 'venu' UNION ALL
	SELECT 4, 'charman' UNION ALL
	SELECT 5, 'charmel' UNION ALL
	SELECT 6, 'charz' UNION ALL
	SELECT 7, 'squirt' UNION ALL
	SELECT 8, 'wart' UNION ALL
	SELECT 9, 'blast'
),

Table2 (PokeID, ColorID) 
AS
(
	SELECT 1, 1 UNION ALL
	SELECT 2, 2 UNION ALL
	SELECT 3, 3 UNION ALL
	SELECT 4, 4 UNION ALL
	SELECT 5, 5 UNION ALL
	SELECT 6, 6 UNION ALL
	SELECT 7, 7 UNION ALL
	SELECT 8, 8 UNION ALL
	SELECT 9, 9
),

Table3 (ColorID, ColorName)
AS
(
	SELECT 1, 'Green' UNION ALL
	SELECT 2, 'Green' UNION ALL
	SELECT 3, 'Green' UNION ALL
	SELECT 4, 'Orange' UNION ALL
	SELECT 5, 'Red' UNION ALL
	SELECT 6, 'Orange' UNION ALL
	SELECT 7, 'Blue' UNION ALL
	SELECT 8, 'Blue' UNION ALL
	SELECT 9, 'Blue'
)
SELECT 
	Table1.PokeID
	,PokeName
	,ColorName

From Table1 

left outer join Table2 
on Table1.PokeID = Table2.PokeID

left outer join Table3
on Table2.ColorID = Table3.ColorID
