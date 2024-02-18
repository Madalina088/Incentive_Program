drop database if exists incentive_program;

create database incentive_program;

use incentive_program;

#	Agencies – va stoca informatiile cu privire la agentiile companiei

CREATE TABLE agencies 
(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
Agency_Name VARCHAR(50) NOT NULL, 
Adress VARCHAR(70) NOT NULL, 
PhoneNumber VARCHAR(30), 
EmailAdress VARCHAR(30));

#	Coordinators – va stoca informatiile cu privire la coordonatori de agenti din vanzari

CREATE TABLE coordinators 
(ID_Employee INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
ID_AG INT NOT NULL,	
FirstName VARCHAR(30) NOT NULL, 
LastName VARCHAR(30) NOT NULL, 
DateOfBirth DATE,HireDate DATE NOT NULL,  
CONSTRAINT FOREIGN KEY (ID_AG) REFERENCES Agencies(ID));

#	Sales Agents – va stoca informatiile cu privier la agentii de vanzari din subordinea coordonatorilor

CREATE TABLE sales_agents 
(ID_Employee INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
ID_CO INT NOT NULL,    	
ID_AG INT NOT NULL, 
FirstName VARCHAR(30) NOT NULL,  
LastName VARCHAR(30) NOT NULL, 	
DateOfBirth DATE, HireDate DATE NOT NULL,    
CONSTRAINT FOREIGN KEY (ID_CO) REFERENCES Coordinators(ID_Employee), 
CONSTRAINT FOREIGN KEY (ID_AG) REFERENCES Agencies(ID));

#	Link_Table – va fi un tabel de legatura intre Agencies, Coordinators, Sales_Agents si Policies_Issued 

 CREATE TABLE link_table 
 (ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  
 ID_SA INT NOT NULL,  
 ID_CO INT NOT NULL, 
 ID_AG INT NOT NULL, 
 CONSTRAINT FOREIGN KEY (ID_SA) REFERENCES 	Sales_Agents(ID_Employee), 
 CONSTRAINT FOREIGN KEY (ID_CO) REFERENCES 	Coordinators(ID_Employee), 
 CONSTRAINT FOREIGN KEY (ID_AG) REFERENCES Agencies(ID));
 
# Policies_Issued – cuprinde situatia politelor incheiate de catre agentii de asigurare 

CREATE TABLE policies_issued 
(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  
ID_Link INT NOT NULL, ClientName VARCHAR(50) NOT NULL,  
Policy_Number VARCHAR(50) NOT NULL, 
DateOfPolicy DATE, 
StatusOfPolicy ENUM('in force', 'canceled'),  
Insurance_premium DECIMAL(10 , 2 ) DEFAULT 0, 
Currency VARCHAR(4) DEFAULT 'RON',
CONSTRAINT FOREIGN KEY (ID_Link) REFERENCES link_table (ID)); 

# Se vor popula tabelele create cu optiunea INSERT: 

INSERT INTO agencies VALUES 
(1, 'Insurance Agency 1', 'General Vasile Milea Blvd., No. 4', '555444222', 'agency1@ins.com'),
(2, 'Insurance Agency 2', 'Iuliu Maniu Blvd., No. 19', '555444223', 'agency2@ins.com');

INSERT INTO coordinators VALUES 
(10, 1, 'Aguilar', 'Dalia-Elaine', '2003-02-28', '2020-09-15'), 
(11, 2, 'Meyer', 'Tanya','1970-01-20', '2023-09-15');

INSERT INTO sales_agents  VALUES 
(1000, 10, 1, 'Hall','Alisa','1994-07-04', '2015-07-22'),  
(1001, 10, 1,  'Goodine', 'Robert','1988-05-04', '2017-12-08'), 
(1002, 10, 1, 'Griffin','Robert', '1986-12-05','2018-05-01'), 
(1003, 11, 2,  'Bracken','Janice', '1981-12-08', '2018-01-01'), 
(1004, 11, 2,  'Huetter','Peter','1969-12-02', '2017-10-07');

INSERT INTO link_table VALUES 
(40 ,1000, 10, 1), 
(41, 1001, 10, 1), 
(42 ,1002, 10, 1), 
(43 ,1003, 11, 2), 
(44 ,1004, 11, 2);

 INSERT INTO policies_issued(ID, ID_Link, ClientName, Policy_Number, DateOfPolicy, StatusOfPolicy, Insurance_premium) values 
 (133, 40, 'Bentz Jodi','ACL2005', '2023-09-18', 'in force', '500.60'), 
 (134, 40, 'Bevan Tom','ACL2006', '2023-09-19', 'in force', '98.00'), 
 (137, 41, 'Board Tim','ACL2007', '2023-07-22', 'in force', '64.45'), 
 (138, 42, 'Boone Antonyo','ACL2008', '2023-07-23', 'in force', '88.77'), 
 (139, 43, 'Brooks Gary','ACL2009', '2023-07-24', 'in force', '22.50'), 
 (140, 43, 'Brown Wayne','ACL2001', '2023-07-25', 'canceled', '0.00'), 
 (141, 43, 'Bui Yvonne','ACL2002', '2023-07-26', 'in force', '58.60'), 
 (142, 43, 'Burris Wayne','PAD005', '2023-08-27', 'in force', '47.20'), 
 (143, 44, 'Butta Tom','PAD004', '2023-07-28', 'in force', '99.00'), 
 (144, 44, 'Caine Tommy','PAD003', '2023-07-29', 'in force', '99.00');

# Se va adauga o noua coloana numita NumberOfMonths in tabela Sales_Agents:

ALTER TABLE Sales_Agents ADD COLUMN NumberOfMonths VARCHAR(15) AFTER HireDate;

#	Se va redenumi tabela Coordinators in Sales_Manager:

ALTER TABLE Coordinators RENAME Sales_Manager;

#	Se vor sterge din tabelul policies_issued  inregistarile pentru ID = 133 si policy_number = 'ACL2005' 

DELETE FROM policies_issued 
WHERE ID = 133 
and Policy_Number = 'ACL2005';	

#	Se va popula coloana NumberOfMonths din tabelul Sales_Agents prin calculrea vechimii la 30.09.2023:
		
UPDATE Sales_Agents SET NumberOfMonths = TIMESTAMPDIFF(MONTH, HireDate,'2023-09-30')WHERE ID_Employee between 1000 and 1006;

#	Returnati toate informatiile din tabelul Sales_Agents: 

SELECT * FROM Sales_Agents;

# 	Returnati agentii din tabelul Sales_Agents cu NumberOfMonths > 60 luni 

SELECT id_employee, firstname, lastname, numberofmonths from Sales_Agents where NumberOfMonths>60 order by lastname limit 5 ;

#	Returnati agentii al caror FirstName contin '%nic%' sau Hiredate '%2018%' si dateofbirth = '1981-12-08'

select* from Sales_Agents where (FirstName like '%nic%' or HireDate like '%2018%') and dateofbirth = '1981-12-08';

#Returnati pentru fiecare agent valoarea MIN, MAX, SUM, AVG a primei de asigurare pentru politele cu status “in force”

SELECT CONCAT(Sales_Agents.FirstName, ' ', Sales_Agents.LastName) AS AgentName,	
MIN(insurance_premium), MAX(insurance_premium), SUM(insurance_premium), 
AVG(insurance_premium) FROM policies_issued, sales_agents, link_table  
where statusofpolicy = 'in force' and Sales_Agents.ID_employee = link_table.ID_SA    
and link_table.ID = policies_issued.id_link  
GROUP BY AgentName;


#Returnati numarul de polite incheiate in fiecare luna   

SELECT DATE_FORMAT(DateOfPolicy, '%Y-%m') AS MonthYear,
       COUNT(Policy_Number) AS PoliciesIssued
FROM policies_issued
GROUP BY DATE_FORMAT(DateOfPolicy, '%Y-%m');

# Returnati numarul de agenti la nivel de agentie 

Select Agencies.Agency_Name as Agency, 
count(Sales_Agents.ID_Employee) as AgentsNumber
FROM Agencies
CROSS JOIN Sales_Agents
WHERE Agencies.ID = Sales_Agents.ID_AG
GROUP BY
    Agencies.Agency_Name
order BY AgentsNumber desc;


# Returnati numarul de polite incheiate la nivel de agent 

SELECT
    Agencies.Agency_Name AS Agency,
    CONCAT(Sales_Manager.FirstName, ' ', Sales_Manager.LastName) AS SalesManagerName,
    CONCAT(Sales_Agents.FirstName, ' ', Sales_Agents.LastName) AS AgentName,
    COUNT(policy_number) AS PolicyNumber
FROM
    Agencies
    JOIN link_table ON Agencies.ID = link_table.ID_AG
    JOIN Sales_Manager ON Sales_Manager.ID_Employee = link_table.ID_CO
    JOIN Sales_Agents ON Sales_Agents.ID_Employee = link_table.ID_SA
    JOIN policies_issued ON link_table.ID = policies_issued.ID_Link
GROUP BY
    Agencies.Agency_Name,
    SalesManagerName,
    AgentName;

#	Returnati Sales Managerii si fiecare agent asignat acestuia 

SELECT 
	CONCAT(Sales_Manager.FirstName, ' ', Sales_Manager.LastName) AS SalesManagerName, 
	CONCAT(Sales_Agents.FirstName, ' ', Sales_Agents.LastName) AS AgentName 
FROM Sales_Manager
	 LEFT JOIN Sales_Agents ON Sales_Manager.ID_employee=Sales_Agents.ID_CO
     ORDER BY SalesManagerName;
     
#	Returnati Agentiile si Sales Managerii precum si informatiile acestora

SELECT * from Agencies right join sales_manager on agencies.id=sales_manager.ID_AG;


# 	Returnati Agentiile cu >= 1 Sales Manageri 

SELECT
    Agencies.Agency_Name AS Agency,
    COUNT(Sales_Manager.ID_employee) AS SalesManagerNo
FROM
    Agencies
INNER JOIN Sales_Manager ON Agencies.ID = Sales_Manager.ID_AG
GROUP BY
    Agency
HAVING
    SalesManagerNo >= 1
ORDER BY
    SalesManagerNo;

#Returnati agentii de vanzari angajati in 2018

 select id_employee, firstname, lastname 
 from sales_agents
 where hiredate in(select hiredate from sales_agents where extract(year from hiredate) = 2018);
 
#	Returnati agentii de vanzari care apartin de agentia Insurance Agency 1

 SELECT id_employee, FirstName, LastName
FROM sales_agents
WHERE ID_AG IN (SELECT ID FROM Agencies WHERE Agency_Name = 'Insurance Agency 1');

#	Returnati clientii si politele care apartin de Sales Agent cu ID=1004

SELECT ClientName, Policy_Number
FROM policies_issued
WHERE ID_Link IN (SELECT ID FROM link_table WHERE ID_SA = 1004);


