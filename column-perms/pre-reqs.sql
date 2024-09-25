/*
    Create a space
*/

--let's create our table; nothing fancy
if OBJECT_ID('tColumnPermissions') is not null
begin
    drop table tColumnPermissions
    print '** Dropped tColumnPermissions.'
end
go

create table tColumnPermissions(
    ThisID INT
    ,ThisAvailableColumn VARCHAR(50)
    ,ThisPrivateColumn VARCHAR(50)
);

--and insert some records
insert into tColumnPermissions (
    ThisID
    ,ThisAvailableColumn
    ,ThisPrivateColumn
) values (1, 'Words', 'Secret Words')
    ,(2, 'Spiderman', 'Peter Parker')
    ,(3, 'Superman', 'Clark Kent');

--confirm that our table has data
select ThisId, ThisAvailableColumn, ThisPrivateColumn from tColumnPermissions;

/*
    Create a view that reflects our table
*/
create view vColumnPermissions as
select ThisID
    ,ThisAvailableColumn
    ,ThisPrivateColumn 
from tColumnPermissions;

--confirm that our reflection is operating
select ThisId, ThisAvailableColumn, ThisPrivateColumn from vColumnPermissions;

/*
    Create a user to work with
*/
--build our user
create login RegularUser
with password = 'I am a regular user!';
go

create user RegularUser
for login RegularUser;
go

--and confirm that they see our data
execute as user = 'RegularUser';
select ThisId, ThisAvailableColumn, ThisPrivateColumn from tColumnPermissions;
revert;

--and the view 
execute as user = 'RegularUser';
select ThisId, ThisAvailableColumn, ThisPrivateColumn from vColumnPermissions;
revert;

