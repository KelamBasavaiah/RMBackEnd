create database dbReleaseManagementProject
use dbReleaseManagementProject
create table tblEmployee(S_No int identity primary key,employee_id 
as 'E'+right('0000'+cast(S_No as varchar(4)),3)
persisted not null unique,
employee_name varchar(50),
employee_mailid varchar(50))
create table tblLogin(Emp_Id varchar(4) constraint fk_emp_id references tblEmployee(employee_id),
username varchar(20) constraint pk_userName primary key,password varchar(20))
insert into tblEmployee values('Employee10','murugesanthamizhlni@gmail.com')
insert into tblLogin values('E002','User2','1234')
insert into tblLogin values('E003','User3','1234')
insert into tblLogin values('E004','User4','1234')
insert into tblLogin values('E005','User5','1234')
insert into tblLogin values('E006','User6','1234')
insert into tblLogin values('E007','User7','1234')
insert into tblLogin values('E008','User8','1234')
insert into tblLogin values('E009','User9','1234')
insert into tblLogin values('E010','User10','1234')
delete from tblProjectDetails where P_Name='project1'
select * from tblLogin
select * from tblProjectDetails
select * from tblRole
select * from tblAssignProjectTable
select * from tblModule
select * from tblBug
select * from tblEmployee
create table tblProjectDetails(p_id int identity primary key,project_Id as 'P'+right('0000'+cast(p_id as varchar(10)),3)
persisted not null unique,P_Name varchar(40),P_Description varchar(70),P_Startdate date,p_EndDate date)
delete from tblModule where moduleId='M015'
delete from tblProjectDetails where project_Id='P024'
update tblModule set module_name='Test Module4' where moduleId='M006'
create table tblModule(m_Id int identity primary key,moduleId as 'M' +right('0000' +cast(m_id as varchar(10)),3) persisted
not null unique,
projectId varchar(4) constraint fk_pid references tblProjectDetails(project_Id),
module_name varchar(20),
module_Description varchar(70),module_status varchar(40),from_date date,to_date date)


create table tblRole(employee_id varchar(4) constraint fk_eid references tblEmployee(employee_id),
role varchar(50),Assigned_Module_or_Project_Id varchar(20)  )


create table tblBug(b_Id int identity primary key,bug_Id as 'B' +right('0000' +cast(b_id as varchar(10)),3)persisted not null unique,
module_Id varchar(4) constraint fk_mid references tblModule(moduleId),bugname varchar(50),
bug_status varchar(50))


create table tblAssignProjectTable(module_Id varchar(4) constraint fk_moid references tblModule(moduleId),
employee_Id varchar(4) constraint fk_emid references tblEmployee(employee_id),
from_date date,to_date date)

Create table tblAdmin(username varchar(20),password varchar(20))
insert into tblAdmin values('admin','1234')
---------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------
create proc proc_Adminlogin(@un varchar(20),@pass varchar(20))
as
begin
select * from tblAdmin where username = @un and password= @pass
end



create proc proc_Userlogin(@user varchar(20),@pwd varchar(20))
as
begin
select* from tblLogin
where username=@user and password=@pwd
end

-----------------------------------------------------------------developer------------------------------------------------
create proc Proc_DeveloperProjectDetails(@userName varchar(10))
as
begin
Select project_Id, P_Name,P_Description,P_Startdate,P_EndDate from tblProjectDetails pd join
tblModule m on m.projectId = pd.project_Id join tblRole tr
on m.moduleId = tr.Assigned_Module_or_Project_Id
where employee_id in
(select Emp_Id from tblLogin where username=@userName) and role='Developer'
end


--query to display module details for the given Project name--
create proc Proc_GetModulesForDeveloper(@P_Id varchar(40),@username varchar(20))
as 
begin
select moduleId, module_name,module_Description,module_status,from_date,to_date from tblModule m join 
tblProjectDetails pd on pd.project_Id =  m.projectId join tblRole ta on ta.Assigned_Module_or_Project_Id=m.moduleId
where m.projectId =@p_Id and employee_Id=(select Emp_Id from tblLogin where username=@userName) and role='Developer'
end

execute Proc_GetModulesForDeveloper 'project1','user2'

update tblModule set module_status='In Progress(D)' where moduleId='M001'
--query to update module status to manager--
alter proc proc_UpdateModuleStatusToManagerFromDeveloper(@module_Id varchar(20))
as
begin
update tblModule set module_status='Completed By Developer' where moduleId=@module_Id
end

execute proc_UpdateModuleStatusToManagerFromDeveloper 'mod6'
---------------------------------------------dev part 2-----------------------------------------------------------------
--//Joining Two Tables (Bug and Module Table) and creating stord procedure for it//
create proc proc_GetModuleNamesandBugstatusandBugnames(@username varchar(10))
as
begin
select m.moduleId, m.module_name,b.bug_status,b.bugname
from tblModule as m
join tblBug as b on 
m.moduleId=b.module_Id
join tblRole tr
on m.moduleId = tr.Assigned_Module_or_Project_Id
where employee_id in
(select Emp_Id from tblLogin where username=@userName) and role='Developer' and bug_status='Bug Present'
end
--//execguting the stord procedure//
exec proc_GetModuleNamesandBugstatusandBugnames @employeeId='E001'

--//Geting the modulename and module description from module table//
alter proc proc_GetAllBugModules( @moduleId varchar(50))
as
begin
select moduleId, module_name,module_Description
from tblModule where moduleId=@moduleId
end
--//execguting the  stored procedure//
exec proc_GetAllBugModules 'M001'

--//Updating ModuleStatus//

--//Update BugStatus To the Tester//
create proc proc_UpdateBugStatusToTester(@moduleId varchar(10),@bugStatus varchar(10))
as
begin
update tblBug set bug_status=@bugStatus where module_Id=@moduleId
end
--//execguting the stored procedure//
exec proc_UpdateBugStatusToTester @bug_Id='B001',@bugStatus='Bug Fixed'



-----------------------------------------------------------tester1------------------------------------------------------------
create proc Proc_GetProjectDetailsForTester(@UserName varchar(30))
as
begin
Select project_Id, P_Name,P_Description,P_Startdate,P_EndDate from tblProjectDetails pd join
tblModule m on m.projectId = pd.project_Id join tblRole tr
on m.moduleId = tr.Assigned_Module_or_Project_Id
where employee_id in
(select Emp_Id from tblLogin where username=@userName) and role='Tester'
end
exec Proc_GetProjectDetailsForTester 'user5' 

execute Proc_EmployeeProjectDetails 'Tamizhni'

alter proc Proc_GetModulesForTester(@P_Id varchar(50),@username varchar(20))
as 
begin
select moduleId, module_name,module_Description,module_status,from_date,to_date from tblModule m join 
tblProjectDetails pd on pd.project_Id =  m.projectId 
join tblRole ta on ta.Assigned_Module_or_Project_Id=m.moduleId
where m.projectId =@P_Id and employee_Id=(select Emp_Id from tblLogin where username=@userName) and role='Tester'
end
exec Proc_GetModulesForTester 'P006','User2'

alter proc proc_UpdateModuleStatusByTester(@module_Id varchar(20))
as
begin
update tblModule set module_status='Completed by Tester' where moduleId=@module_Id
end

exec proc_UpdateModuleStatus 'mod3'
select * from tblModule
------------------------------------------------tester2----------------------------------------------------------------------
--get fixed modules
alter proc testerBugFixModule (@username varchar(30))
as begin
select moduleId, module_name,bugname,bug_status from tblBug b
join tblModule m on b.module_Id=m.moduleId join
tblRole tr
on m.moduleId = tr.Assigned_Module_or_Project_Id
where employee_id in
(select Emp_Id from tblLogin where username=@userName) and role='Tester' and bug_status='Bug Fixed'
end

exec  testerBugFixModule 'user2'


create proc proc_testerBugModules(@modulename varchar(30))
as
begin
select moduleId,module_name,module_Description,module_status from tblModule tbm join tblBug tb 
on tb.module_Id=tbm.moduleId where bug_status='Bug Fixed' and module_name=@modulename
end


-- create Bug
select * from tblModule
select * from tblBug 

alter proc proc_createBug (@module_Id varchar(20) ,@bug_name varchar(30),@bug_status varchar(50)	)			 
as 
begin  
insert into tblBug values (@module_Id,@bug_name,@bug_status)
end

exec proc_createBug @module_name='modulee',@bug_name='ffff',@bug_status='check'

update tblBug set bug_status='Bug Fixed' where bug_Id='B007'

-------------------------------------------------------manager--------------------------------------------------------------------------
alter proc proc_GetAllAssignedModulesForManager(@projectId varchar(10))
as
begin
select P_Name,module_name,module_status,moduleId
from tblProjectDetails tp join tblModule tm on tp.project_Id=tm.projectId where tp.project_Id=@projectId and
module_status='In Progress(D)' or module_status='In Progress(T)' or module_status='Completed By Developer' or
module_status='Completed by Tester'

end
exec proc_GetAllAssignedModulesForManager 'P003'
----------------------------------------------------------------------------------------------------------------
create proc proc_EmpId
as
begin
select employee_name,Assigned_Module_or_Project_Id from tblRole tb join
tblEmployee te on tb.employee_id=te.employee_id  where tb.role='Developer'
end
exec proc_EmpId
--------------------------------------------------------------------------------------------------------------
create proc proc_TesterID
as
begin
select employee_name,Assigned_Module_or_Project_Id from tblRole tb join
tblEmployee te on tb.employee_id=te.employee_id  where tb.role='Tester'
end
exec proc_TesterID
------------------------------------------------------------------------------------------------------------------------
create proc proc_GetProjectId(@userName varchar(40))
as
begin 
select Assigned_Module_or_Project_Id,P_Name from tblRole tr join tblProjectDetails tp on tr.Assigned_Module_or_Project_Id=tp.project_Id
where employee_id in
(select Emp_Id from tblLogin where username=@userName) and role='Manager'
end
------------------------------------------------------------------------------------------------------------------------------
create proc proc_GetEmployeesWithRole
as
begin
select * from tblRole
end
exec proc_GetProjectId 'user1'
--------------------------------------------------------------------------------------------------------------------------------------
create proc proc_GetEmployeeName(@EmployeeId varchar(10))
as
begin
select employee_name from tblEmployee where employee_id=@EmployeeId
end
-------------------------------------------------------------------------------------------------------------------------------------
create proc proc_GetAllEmployees
as
begin
select * from tblEmployee
end
--------------------------------------------------------------------------------------------------------------------------------------
create proc proc_GetAllModuleDetails
as
begin
select moduleId,module_name from tblModule
end
exec proc_GetAllModuleDetails
--------------------------------------------------------------------------------------------------------------------------------------
create proc proc_GetAllAssignedEmployees
as
begin
select * from tblEmployee where employee_id in (select employee_Id from tblAssignProjectTable)
end
exec proc_GetAllAssignedEmployees 
------------------------------------------------------------------------------------------------------
create proc proc_AssignProjecttoEmployee(@ModuleId varchar(10),@EmployeeId varchar(10),@EmpstartDate varchar(30),@EmpEndDate varchar(30))
as
begin
insert into tblAssignProjectTable values(@ModuleId,@EmployeeId,@EmpstartDate,@EmpEndDate)
end
--------------------------------------------------------------------------------------------------------------------------
create proc proc_UpdateModuleStatus(@moduleId varchar(40),@moduleStatus varchar(40))
as
begin
update tblModule set module_status=@moduleStatus where moduleId=@moduleId
end
---------------------------------------------------------------------------------------------------------------------------
create proc proc_InsertRole(@EmpId varchar(10),@Role varchar(30),@projectId varchar(10))
as
begin
insert into tblRole values(@EmpId,@Role,@projectId)
end
--------------------------------------------------------------------------------------------------------------------------------
create proc proc_GetCompletedModules(@projectId varchar(10))
as
begin
select P_Name,module_name,module_status,moduleId
from tblProjectDetails tp join tblModule tm on tp.project_Id=tm.projectId where tp.project_Id=@projectId and module_status='Completed' 
end 
exec proc_GetCompletedModules 'P006'
select * from tblModule
----------------------------------------------------------------------------------------------------------------------------
create proc proc_GetModuleCount(@projectId varchar(10))
as
begin
select count(moduleId) from tblModule where projectId=@projectId
end
exec proc_GetModuleCount 'P001'
--------------------------------------------------------------------
create proc proc_GetProjectCount(@projectName varchar(50))
as
begin
select count(project_Id) from tblProjectDetails where P_Name=@projectName
end
-----------------------------------------------------------------------------------
create proc proc_GetModuleCountToInsert(@moduleName varchar(50))
as
begin
select count(moduleId) from tblModule where module_name=@moduleName
end
---------------------------------------------------------------------------------------------------------------
create proc proc_GetCompletedmodulesCount(@ProjectId varchar(10))
as
begin
select count(moduleId) from tblModule where projectId=@ProjectId and module_status='Completed'
end
exec  proc_GetCompletedmodulesCount 'P001'
----------------------------------------------------------------------------------------------------------------------------------
create proc proc_UpdateCompletedModuleStatus(@projectId varchar(10))
as
begin
update tblModule set module_status='Module Completed' where projectId=@projectId
end
exec proc_UpdateCompletedModuleStatus 'Project1'
----------------------------------------------------------------------------------------------------------------------------------
select * from tblProjectDetails
create proc proc_GetCompletedProjects(@projectId varchar(20))
as
begin 
select p_Name,P_Description,P_Startdate,p_EndDate from tblProjectDetails where project_Id=@projectId
end
exec  proc_GetCompletedProjects 'user1'
-----------------------------------------------------------------------------------------------------------------------------
alter proc proc_GetCompletedModuleCount(@projectId varchar(10))
as
begin 
select count(moduleId) from tblModule where projectId=@ProjectId and module_status='Completed'
end
select * from tblModule
exec proc_GetCompletedModuleCount 'P006'
-----------------------------------------------Manager First part -----------------------------------------------------------------------------
create proc proc_GetProjectsId(@projectname varchar(40))
as
begin
select project_Id from tblProjectDetails where P_Name=@projectname
end
--------------------------------------------get project date------------------------------
alter proc proc_GetProjectDate(@projectId varchar(10))
as
begin
select P_EndDate from tblProjectDetails where P_Name=@projectId
end
select * from tblProjectDetails
----------------get all modules----------------------
create proc proc_GetAllModules(@projectId varchar(40))
as
begin
select moduleId, module_name,module_Description,module_status,from_date,to_date from tblModule 
where projectId =@projectId and module_status='Not Started'
end
----------------------------get all projects------------------------
create proc proc_GetAllProjects(@username varchar(20))
as
begin
select project_Id, P_Name,P_Description,P_Startdate,p_EndDate from tblProjectDetails where project_Id in(select project_Id from tblrole where role='manager' and employee_Id in(select  Emp_Id from tblLogin where username=@username))
end
--------------------------------get Employee id------------------------------
create proc proc_GetEmployeeId(@username varchar(20))
as
begin
select Emp_Id from tblLogin where username=@username
end
------------------------------------------------------------------------------------------
create proc proc_GetEmployeeIdForName(@empname varchar(20))
as
begin
select employee_id from tblEmployee where employee_name=@empname
end
-------------------------------------get Project Id----------------------
create proc proc_GetProjectId(@username varchar(20))
as
begin
select Emp_Id from tblLogin where username=@username
end
---------------------------------------Get Projects Id-----------------
create proc proc_GetProjectsId(@projectname varchar(40))
as
begin
select p_Idwithchar from tblProjectDetails where P_Name=@projectname
end
---------------------------------insert modules---------------------
create proc proc_InsertModules(@projectid varchar(10),@module_name varchar(20),@module_description varchar(70),
@module_status varchar(40),@from_date datetime,@to_date datetime)
as
begin
insert into tblModule values(@projectid,@module_name,@module_description,@module_status,@from_date,@to_date)
end
-----------------------------------------insert roles---------------------------------------------
create proc proc_InsertRoleForManager(@empid varchar(20),@role varchar(50),@proj_id varchar(4))
as
begin
insert into tblRole values(@empid ,@role,@proj_id)
end
exec proc_InsertRole 'E001','Manager','P001'
--------------------------------------insert projects-----------------------------
create proc proc_InsertProjects(@projectname varchar(40),@projectdescription varchar(70),@fromdate datetime,@todate datetime)
as
begin
insert into tblProjectDetails values (@projectname,@projectdescription,@fromdate,@todate)
end
------------------------------------mail-------------------------------------------

exec proc_GetEmail 'User3'
select * from tblEmployee
select * from tblLogin
-----------------------------update password--------------------------------
alter  proc proc_GetEmail(@uname varchar(20))

as
begin
select employee_mailid from tblEmployee where employee_id in(select Emp_Id from tblLogin where username=@uname)
end
create proc proc_UpdatePassword(@uname varchar(20),@pass varchar(20))

as
begin
update tblLogin set password=@pass where username=@uname
end
select * from tblLogin
-------------------------------------admin--------------------------------------------------
alter proc proc_GetAllEmployeeForAdmin
as
begin
select * from tblEmployee 
end
select * from tblEmployee

go
go