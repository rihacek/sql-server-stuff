/*
    this is a collection of commands that should get our database 
    back into shape after playing with this repo
*/

--remove the tables and views
if OBJECT_ID('vMySecretView') is not null
    begin
        drop view vMySecretView
        if OBJECT_ID('vMySecretView') is null 
            print '** Dropped vMySecretView.'
    end
    else print '** No vMySecretView to drop'
go

if OBJECT_ID('vColumnPermissions') is not null
    begin
        drop view vColumnPermissions
        if OBJECT_ID('vColumnPermissions') is null 
            print '** Dropped vColumnPermissions.'
    end
    else print '** No vColumnPermissions to drop'
go

if OBJECT_ID('tColumnPermissions') is not null
    begin
        drop table tColumnPermissions
        if OBJECT_ID('tColumnPermissions') is null
            print '** Dropped tColumnPermissions.'
    end
    else print '** No tColumnPermissions to drop'
go

--make sure that no seesions are running as that user. if so, close your windows/etc
SELECT session_id
FROM sys.dm_exec_sessions
WHERE login_name = 'RegularUser'

--remove the user 
if USER_ID('RegularUser') is not null
    begin
	drop user [RegularUser]
	if USER_ID('RegularUser') is null
		print '** Dropped User::RegularUser'
	end
else print '** No RegularUser User to drop'

--then the login
if SUSER_ID('RegularUser') is not null
    begin
	drop login [RegularUser]
	if SUSER_ID('RegularUser') is null
		print '** Dropped Login::RegularUser'
	end
else print '** No RegularUser Login to drop'