/*
    we do not want to manage individual views. 
    
    can we isolate view columns that are based on the table columns 
    on which we want to restrict access? 
*/

SELECT 
    col.name AS [Column Name], 
    v.name AS [View Name],
	col.object_id as [Object ID]
FROM 
    sys.columns as col 
INNER JOIN 
    sys.views as v 
ON 
    col.object_id = v.object_id 
WHERE 
    col.name LIKE '%Private%' 
ORDER BY 
    [View Name], [Column Name];

    

--narrowing things down: any views that reference a specific table
SELECT distinct
referencing_object_name = o.name, 
referencing_object_type_desc = o.type_desc, 
referenced_object_name = referenced_entity_name, 
referenced_object_type_desc =so1.type_desc 
FROM sys.sql_expression_dependencies sed 
INNER JOIN sys.views o 
	ON sed.referencing_id = o.object_id 
LEFT OUTER JOIN sys.views so1 
	ON sed.referenced_id =so1.object_id 
WHERE referenced_entity_name = 'tColumnPermissions'
/*
    this provides a nice, quick list that provides a filtered foundatio for future work
        * would need to be dynamic to include table > view > view > view... for example
*/

--views that have a specific column name (just a string!) in their definition
SELECT * FROM   INFORMATION_SCHEMA.VIEWS 
WHERE  VIEW_DEFINITION like '%ThisPrivateColumn%'
/*
    this could be helpful, and it appears to be as far as RedGate SQL Search can go as well.
    gotchas:
        * views can be so dynamic that a single view column might reference many table columns
        * views might also reference other views without ever including the original table name in the DDL
            * we could solve this with a self-referring CTE all the way back to a source column
*/

/*
    can i build a view based on a column that i do not have select to?
*/

--make sure that our user can create views
grant alter on SCHEMA::dbo to RegularUser;
grant execute on SCHEMA::dbo to RegularUser;
grant delete on SCHEMA::dbo to RegularUser;
grant create view to RegularUser;

--and test
execute as user = 'RegularUser';
go
create view vMySecretView as
select ThisID
    ,ThisAvailableColumn
    ,ThisPrivateColumn 
from tColumnPermissions;
go
revert;

--drop the view
drop view vMySecretView;

--deny the user select on the column
deny select (ThisPrivateColumn) on OBJECT::tColumnPermissions to RegularUser;
go

--as the user, create a view based on the restricted column
execute as user = 'RegularUser';
go
create view vMySecretView as
select ThisID
    ,ThisAvailableColumn
    ,ThisPrivateColumn 
from tColumnPermissions;

/*
    At this point, nobody is able to see this View. All selects were granted explicitly, and
    this view has not been included, so Permissions are empty.
    Where does our specific environment start - explicit grants? This makes all the difference.
*/

revert;