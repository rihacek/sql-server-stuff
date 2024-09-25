# column-perms: explore hiding specific columns from users
### Initial thoughts:
* How does table grant impact existing views for users?
* What's this look like from a workflow perspective?
* Do we have different impact given different workflows? For example, DENY on an available column vs SELECTs on an unscoped table. 

### Instructions
These are SQL scripts that can be run in order to both create the environment and report on findings. They were build for MS SQL Server, but may also work just fine in other landscapes. 

Run them in a sandbox environment where you have sufficient permissions, and, most importantly, **play around and have fun!**