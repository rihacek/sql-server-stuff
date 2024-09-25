/*
    let's start with a user who can see our data
*/

--grant them select on our objects
grant select on object::tColumnPermissions to RegularUser;
go
grant select on object::vColumnPermissions to RegularUser;
go

--and confirm that they see our data
execute as user = 'RegularUser';
select ThisId, ThisAvailableColumn, ThisPrivateColumn from tColumnPermissions;
select ThisId, ThisAvailableColumn, ThisPrivateColumn from vColumnPermissions;
revert;

-- restrict access to ThisPrivateColumn in the table
deny select (ThisPrivateColumn) on OBJECT::tColumnPermissions to RegularUser;
go

--check our table (should fail)
execute as user = 'RegularUser';
select ThisId, ThisAvailableColumn, ThisPrivateColumn from tColumnPermissions;
revert;

--check our table without the blocked column (looks good)
execute as user = 'RegularUser';
select ThisId, ThisAvailableColumn from tColumnPermissions;
revert;

--check our view (uh oh.)
execute as user = 'RegularUser';
select ThisId, ThisAvailableColumn, ThisPrivateColumn from vColumnPermissions;
revert;

/*
    conclusion: views do not inherit permissions from tables that they are based on,
    but we may have other creative ways to implement the restrictions that we're 
    looking for.
*/

--let's give access back to our test user
grant select on object::tColumnPermissions to RegularUser;
go



