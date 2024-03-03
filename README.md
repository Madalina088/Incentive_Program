# Database Project for Incentive Program #

The scope of this project is to use all the SQL knowledge gained throught the Software Testing course and apply them in practice.

Application under test: **Incentive_Program**

Tools used: MySQL Workbench

#### Database description: ####

It is desired to implement an evaluation project for sales employees, called "Incentive Program" which addresses coordinators and sales agents to encourage sales and motivate them. 

For this evaluation to be possible it is necessary to create a database whose purpose is to store data for an insurance company.

In an insurance company there are several sales agencies. Each coordinator belongs to a certain agency and each coordinator has sales agents under him. For evaluation, the number of policies issued by each insurance sales agents will be taken into account. 


### 1. Database Schema ###

You can find below the database schema that was generated through Reverse Engineer and which contains all the tables and the relationships between them.
  
The tables are connected in the following way:


- **Agencies** is connected with **Coordinator** through a **one to many** relationship which was implemented through **Agencies.ID** as a primary key and **Coordinator.ID_AG** as a foreign key
  
- **Agencies** is connected with **Sales_Agents** through a **one to many** relationship which was implemented through **Agencies.ID** as a primary key and **Sales_Agents.ID_AG** as a foreign key
  
- **Agencies** is connected with **SA_CO_AG** through a **one to many** relationship which was implemented through **Agencies.ID** as a primary key and **SA_CO_AG.ID_AG** as a foreign key
  
- **Coordinators** is connected with **Sales_Agents** through a **one to many** relationship which was implemented through **Coordinators.ID_Employee** as a primary key and **Sales_Agents.ID_CO** as a foreign key
  
- **Coordinators** is connected with **SA_CO_AG** through a **one to many** relationship which was implemented through **Coordinators.ID_Employee** as a primary key and **SA_CO_AG.ID_CO** as a foreign key
  
- **Sales_Agents** is connected with **SA_CO_AG** through a **one to many** relationship which was implemented through **Sales_Agents.ID_Employee** as a primary key and **SA_CO_AG.ID_SA** as a foreign key
  
- **SA_CO_AG** is connected with **Policies_Issued** through a **one to many** relationship which was implemented through **ID.SA_CO_AG** as a primary key and **Policies_Issued.ID_SA_CO_AG** as a foreign key


### 2.	Database Queries ###

### 2.1	DDL (Data Definition Language) ###

  The following instructions were written in the scope of CREATING the structure of the database (CREATE INSTRUCTIONS)

- create database:
  
create database incentive_program;

- create table "agencies":

<p>create table agencies (<br>
id int not null auto_increment primary key, <br>
agency_name varchar(50) not null, <br>
adress varchar(70) not null, <br>
phonenumber varchar(30), <br>
emailadress varchar(30));<br>
  
- create table "coordinators":
  
<p>create table coordinators (<br>
id_employee int not null auto_increment primary key, <br>
id_ag int not null,	<br>
firstname varchar(30) not null, <br>
lastname varchar(30) not null, <br>
dateofbirth date,<br>
hiredate date not null,  <br>
constraint foreign key (id_ag) references agencies(id));<br>

- create table "sales_agents":
  
<p>create table sales_agents (<br>
id_employee int not null auto_increment primary key, <br>
id_co int not null,    	<br>
id_ag int not null, <br>
firstname varchar(30) not null,  <br>
lastname varchar(30) not null, 	<br>
dateofbirth date, <br>
hiredate date not null,    <br>
constraint foreign key (id_co) references coordinators(id_employee), <br>
constraint foreign key (id_ag) references agencies(id));<br>

- create table "SA_CO_AG":
  
<p>create table sa_co_ag ( <br>
id int not null auto_increment primary key,  <br>
id_sa int not null,  <br>
id_co int not null, <br>
id_ag int not null, <br>
constraint foreign key (id_sa) references sales_agents(id_employee), <br>
constraint foreign key (id_co) references 	coordinators(id_employee), <br>
constraint foreign key (id_ag) references agencies(id));<br>

- create table "policies_issued":
  
<p>create table policies_issued( <br>
id int not null auto_increment primary key,  <br>
id_sa_co_ag int not null, <br>
clientname varchar(50) not null,  <br>
policy_number varchar(50) not null, <br>
dateofpolicy date, <br>
statusofpolicy enum('in force', 'canceled'),  <br>
insurance_premium decimal(10 , 2 ) default 0, <br>
currency varchar(4) default 'ron',<br>
constraint foreign key (id_sa_co_ag) references sa_co_ag(id));<br>

  
  After the database and the tables have been created, a few ALTER instructions were written in order to update the structure of the database, as described below:


- add a new column named "NumberOfMonths" in the table "Sales_Agents":

alter table sales_agents add column numberofmonths varchar(15) after hiredate;

- rename the table from "Coordinators" in "Sales_Manager":

alter table coordinators rename sales_manager;


### 2.2	DML (Data Manipulation Language) ###

  In order to be able to use the database I populated the tables with various data necessary in order to perform queries and manipulate the data. 
  
  In the testing process, this necessary data is identified in the Test Design phase and created in the Test Implementation phase. 

  Below you can find all the insert instructions that were created in the scope of this project:
  
- insert records in the table "agencies"
  
<p>insert into agencies values <br>
(1, 'Insurance Agency 1', 'General Vasile Milea Blvd., No. 4', '555444222', 'agency1@insurance.com'),<br>
(2, 'Insurance Agency 2', 'Iuliu Maniu Blvd., No. 19', '555444223', 'agency2@insurance.com');<br>

- insert records in the table "coordinators"

<p>insert into coordinators values <br>
(10, 1, 'Aguilar', 'Dalia-Elaine', '2003-02-28', '2020-09-15'), <br>
(11, 2, 'Meyer', 'Tanya','1970-01-20', '2023-09-15');<br>

- insert records in the table "sales_agents"

<p>insert into sales_agents values <br>
(1000, 10, 1, 'Hall','Alisa','1994-07-04', '2015-07-22'), <br>
(1001, 10, 1,  'Goodine', 'Robert','1988-05-04', '2017-12-08'), <br>
(1002, 10, 1, 'Griffin','Robert', '1986-12-05','2018-05-01'), <br>
(1003, 11, 2,  'Bracken','Janice', '1981-12-08', '2018-01-01'), <br>
(1004, 11, 2,  'Huetter','Peter','1969-12-02', '2017-10-07');<br>

- insert records in the table "SA_CO_AG"
  
<p>insert into SA_CO_AG values <br>
(40 ,1000, 10, 1), <br>
(41, 1001, 10, 1), <br>
(42 ,1002, 10, 1), <br>
(43 ,1003, 11, 2), <br>
(44 ,1004, 11, 2);<br>

- insert records in the table "policies_issued"

<p>insert into policies_issued(ID, ID_SA_CO_AG, ClientName, Policy_Number, DateOfPolicy, StatusOfPolicy, Insurance_premium) values<br> 
 (134, 40, 'Bevan Tom','ACL2006', '2023-09-19', 'in force', '98.00'), <br>
 (137, 41, 'Board Tim','ACL2007', '2023-07-22', 'in force', '64.45'), <br>
 (138, 42, 'Boone Antonyo','ACL2008', '2023-07-23', 'in force', '88.77'), <br>
 (139, 43, 'Brooks Gary','ACL2009', '2023-07-24', 'in force', '22.50'), <br>
 (140, 43, 'Brown Wayne','ACL2001', '2023-07-25', 'canceled', '0.00'), <br>
 (141, 43, 'Bui Yvonne','ACL2002', '2023-07-26', 'in force', '58.60'), <br>
 (142, 43, 'Burris Wayne','PAD005', '2023-08-27', 'in force', '47.20'), <br>
 (143, 44, 'Butta Tom','PAD004', '2023-07-28', 'in force', '99.00'), <br>
 (144, 44, 'Caine Tommy','PAD003', '2023-07-29', 'in force', '99.00');<br>
  
  After the insert, in order to prepare the data to be better suited for the testing process, I updated some data in the following way:
  
- update the NumberOfMonths column from the Sales_Agents table by calculating the months within the company on 30.09.2023, for the sales agents with id between 1000 and 1006:
  
<p>update sales_agents <br>
set numberofmonths = timestampdiff(month, hiredate,'2023-09-30') <br>
where id_employee between 1000 and 1006;<br>

 ### 2.3	DQL (Data Query Language) ###

After the testing process, I deleted the data that was no longer relevant in order to preserve the database clean: 

- delete records from Policies_Issued table for ID = 133 and Policy_Number = 'ACL200005

delete from policies_issued 
where ID = 133 
and Policy_Number = 'ACL2005';	

In order to simulate various scenarios that might happen in real life I created the following queries that would cover multiple potential real-life situations:

- extract data from the table Sales_Agents:

select * from Sales_Agents;

- return the sales agents from the Sales_Agents table with NumberOfMonths > 60 months

<p>select id_employee, firstname, lastname, numberofmonths  <br>
from Sales_Agents  <br>
where NumberOfMonths>60  <br>
order by lastname  <br>
limit 5 ;  <br>

- extract from the sales agents table, the agent whose FirstName contains '%nic%' or Hiredate '%2018%' and dateofbirth = '1981-12-08'

<p>select* from Sales_Agents <br>
where (FirstName like '%nic%' or HireDate like '%2018%') <br>
and dateofbirth = '1981-12-08';<br>

- displays for each sales agent MIN, MAX, SUM, AVG value of the insurance premium for issued and in force insurance policies

<p>select concat(sa.firstname, ' ', sa.lastname) as agentname,	<br>
min(insurance_premium), max(insurance_premium), sum(insurance_premium),<br>
avg(insurance_premium) <br>
from policies_issued pi, sales_agents sa, sa_co_ag sca<br>
where statusofpolicy = 'in force' and sa.id_employee = sca.id_sa<br>
and sca.id = pi.id_sa_co_ag  <br>
group by agentname;<br>

- display the number of policies issued monthly
  
<p>select date_format(dateofpolicy, '%y-%m') as monthyear,<br>
count(policy_number) as policiesissued<br>
from policies_issued<br>
group by date_format(dateofpolicy, '%y-%m');<br>

- display the total number of agents at agency level using CROSS JOIN instruction 

<p>select ag.Agency_Name as Agency, <br>
count(sa.ID_Employee) as AgentsNumber<br>
from Agencies ag<br>
cross join Sales_Agents sa<br>
where ag.ID = sa.ID_AG<br>
group by<br>
    ag.Agency_Name<br>
order BY AgentsNumber desc;<br>

- display the number of policies issued at agent level using JOIN instruction

<p>select<br>
ag.Agency_Name AS Agency,<br>
concat(sm.FirstName, ' ', sm.LastName) AS SalesManagerName,<br>
concat(sa.FirstName, ' ', sa.LastName) AS AgentName,<br>
count(pi.policy_number) AS PolicyNumber<br>
from Agencies ag<br>
join SA_CO_AG sca ON ag.ID = sca.ID_AG<br>
join Sales_Manager sm ON sm.ID_Employee = sca.ID_CO<br>
join Sales_Agents sa ON sa.ID_Employee = sca.ID_SA<br>
join policies_issued pi ON sca.ID = pi.ID_SA_CO_AG<br>
group by<br>
ag.Agency_Name,<br>
SalesManagerName,<br>
AgentName;<br>

- display the Sales Managers and each agent assigned to him using the LEFT JOIN instruction

<p>select <br>
concat(sm.FirstName, ' ', sm.LastName) AS SalesManagerName, <br>
concat(sa.FirstName, ' ', sa.LastName) AS AgentName <br>
from Sales_Manager sm<br>
left join Sales_Agents sa ON sm.ID_employee = sa.ID_CO<br>
order by SalesManagerName;<br>

- display the Agencies and Sales Managers and their information using the RIGHT JOIN instruction

select * from Agencies ag right join sales_manager sm on ag.id = sm.ID_AG;

- display Agencies with >= 1 Sales Managers using the INNER JOIN instruction

<p>select <br>
ag.Agency_Name AS Agency,<br>
count(sm.ID_employee) AS SalesManagerNo<br>
from Agencies ag<br>
inner join Sales_Manager sm ON ag.ID = sm.ID_AG<br>
group by<br>
Agency<br>
having<br>
SalesManagerNo >= 1<br>
order by<br>
SalesManagerNo;<br>

- display the sales agents hired in 2018

<p>select id_employee, firstname, lastname <br>
from sales_agents<br>
where hiredate in(select hiredate from sales_agents where extract(year from hiredate) = 2018);<br>

- display the the sales agents from Insurance Agency 1

<p>select id_employee, FirstName, LastName<br>
from sales_agents<br>
where ID_AG IN (SELECT ID FROM Agencies WHERE Agency_Name = 'Insurance Agency 1');<br>

- display the clients and policies that belong to the Sales Agent with ID=1004

<p>select ClientName, Policy_Number<br>
from policies_issued<br>
where ID_SA_CO_AG IN (SELECT ID FROM SA_CO_AG WHERE ID_SA = 1004);<br>

### 2.	Conclusions ###


Working on this project "Incentive Program", I succeed to use the SQL knowledge acquired through software testing course and apply them in practice, as follows: 

- how to create and update a database using Data Definition Language (create, alter, rename)
- how to create and update information from a database using Data Manipulation Language (insert, update, delete)
- how to retrieve information efficiently from a database using Data Query Language  (select used with where, join, group by, having, order by)

