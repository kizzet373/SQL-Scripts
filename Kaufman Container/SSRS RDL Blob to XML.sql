select convert(varchar(max), convert(varbinary(max), content))
from catalog
where content is not null