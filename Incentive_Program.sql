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

#	Coordinators – va stoca informatiile cu privire la coordonatorii de agenti de vanzari

CREATE TABLE coordinators 
(ID_Employee INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
ID_AG INT NOT NULL,	
FirstName VARCHAR(30) NOT NULL, 
LastName VARCHAR(30) NOT NULL, 
DateOfBirth DATE,
HireDate DATE NOT NULL,  
CONSTRAINT FOREIGN KEY (ID_AG) REFERENCES Agencies(ID));

#	Sales Agents – va stoca informatiile cu privire la agentii de vanzari din subordinea coordonatorilor

CREATE TABLE sales_agents 
(ID_Employee INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
ID_CO INT NOT NULL,    	
ID_AG INT NOT NULL, 
FirstName VARCHAR(30) NOT NULL,  
LastName VARCHAR(30) NOT NULL, 	
DateOfBirth DATE, 
HireDate DATE NOT NULL,    
CONSTRAINT FOREIGN KEY (ID_CO) REFERENCES Coordinators(ID_Employee), 
CONSTRAINT FOREIGN KEY (ID_AG) REFERENCES Agencies(ID));

#	SA_CO_AG – va fi un tabel de legatura intre Sales_Agents, Coordinators, Agencies si Policies_Issued 

 CREATE TABLE SA_CO_AG 
 (ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  
 ID_SA INT NOT NULL,  
 ID_CO INT NOT NULL, 
 ID_AG INT NOT NULL, 
 CONSTRAINT FOREIGN KEY (ID_SA) REFERENCES 	Sales_Agents(ID_Employee), 
 CONSTRAINT FOREIGN KEY (ID_CO) REFERENCES 	Coordinators(ID_Employee), 
 CONSTRAINT FOREIGN KEY (ID_AG) REFERENCES Agencies(ID));
 
#	Policies_Issued – cuprinde situatia politelor incheiate de catre agentii de vanzari 

CREATE TABLE policies_issued 
(ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  
ID_SA_CO_AG INT NOT NULL, 
ClientName VARCHAR(50) NOT NULL,  
Policy_Number VARCHAR(50) NOT NULL, 
DateOfPolicy DATE, 
StatusOfPolicy ENUM('in force', 'canceled'),  
Insurance_premium DECIMAL(10 , 2 ) DEFAULT 0, 
Currency VARCHAR(4) DEFAULT 'RON',
CONSTRAINT FOREIGN KEY (ID_SA_CO_AG) REFERENCES SA_CO_AG(ID)); 

#	Se vor popula tabelele create cu optiunea INSERT: 

INSERT INTO agencies VALUES 
(1, 'Insurance Agency 1', 'General Vasile Milea Blvd., No. 4', '555444222', 'agency1@ins.com'),
(2, 'Insurance Agency 2', 'Iuliu Maniu Blvd., No. 19', '555444223', 'agency2@ins.com');

select * from agencies;

INSERT INTO coordinators VALUES 
(10, 1, 'Aguilar', 'Dalia-Elaine', '2003-02-28', '2020-09-15'), 
(11, 2, 'Meyer', 'Tanya','1970-01-20', '2023-09-15');

select * from coordinators;

INSERT INTO sales_agents  VALUES 
(1000, 10, 1, 'Hall','Alisa','1994-07-04', '2015-07-22'),  
(1001, 10, 1,  'Goodine', 'Robert','1988-05-04', '2017-12-08'), 
(1002, 10, 1, 'Griffin','Robert', '1986-12-05','2018-05-01'), 
(1003, 11, 2,  'Bracken','Janice', '1981-12-08', '2018-01-01'), 
(1004, 11, 2,  'Huetter','Peter','1969-12-02', '2017-10-07');

select * from sales_agents;

INSERT INTO SA_CO_AG VALUES 
(40 ,1000, 10, 1), 
(41, 1001, 10, 1), 
(42 ,1002, 10, 1), 
(43 ,1003, 11, 2), 
(44 ,1004, 11, 2);

select * from SA_CO_AG;

 INSERT INTO policies_issued(ID, ID_SA_CO_AG, ClientName, Policy_Number, DateOfPolicy, StatusOfPolicy, Insurance_premium) values 
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

select * from policies_issued;

# Se va adauga o noua coloana numita NumberOfMonths in tabela Sales_Agents:

ALTER TABLE Sales_Agents ADD COLUMN NumberOfMonths VARCHAR(15) AFTER HireDate;

SHOW COLUMNS FROM Sales_Agents;

#	Se va redenumi tabela Coordinators in Sales_Manager:

ALTER TABLE Coordinators RENAME Sales_Manager;

#	Se vor sterge din tabelul policies_issued inregistarile pentru ID = 133 si policy_number = 'ACL2005' 

DELETE FROM policies_issued 
WHERE ID = 133 
and Policy_Number = 'ACL2005';	

#	Se va actualiza coloana NumberOfMonths din tabelul Sales_Agents prin calculrea lunilor in cadrul companiei la 30.09.2023, pentru agentii cu ID intre 1000 si 1006:
		
UPDATE Sales_Agents 
SET NumberOfMonths = TIMESTAMPDIFF(MONTH, HireDate,'2023-09-30') 
WHERE ID_Employee between 1000 and 1006;

#	Returnati toate informatiile din tabelul Sales_Agents: 

SELECT * FROM Sales_Agents;

# 	Returnati agentii din tabelul Sales_Agents cu NumberOfMonths > 60 luni 

SELECT id_employee, firstname, lastname, numberofmonths 
from Sales_Agents 
where NumberOfMonths>60 
order by lastname 
limit 5 ;

#	Returnati agentii al caror FirstName contin '%nic%' sau Hiredate '%2018%' si dateofbirth = '1981-12-08'

select* from Sales_Agents 
where (FirstName like '%nic%' or HireDate like '%2018%') 
and dateofbirth = '1981-12-08';

#	Returnati pentru fiecare agent valoarea MIN, MAX, SUM, AVG a primei de asigurare pentru politele cu status “in force”

SELECT CONCAT(sa.FirstName, ' ', sa.LastName) AS AgentName,	
MIN(insurance_premium), MAX(insurance_premium), SUM(insurance_premium),
AVG(insurance_premium) 
FROM policies_issued pi, sales_agents sa, SA_CO_AG sca
where statusofpolicy = 'in force' and sa.ID_employee = sca.ID_SA
and sca.ID = pi.ID_SA_CO_AG  
GROUP BY AgentName;


# Returnati numarul de polite incheiate in fiecare luna   

SELECT DATE_FORMAT(DateOfPolicy, '%Y-%m') AS MonthYear,
       COUNT(Policy_Number) AS PoliciesIssued
FROM policies_issued
GROUP BY DATE_FORMAT(DateOfPolicy, '%Y-%m');

#	Returnati numarul de agenti la nivel de agentie folosind instructiunea CROSS JOIN 

Select ag.Agency_Name as Agency, 
count(sa.ID_Employee) as AgentsNumber
FROM Agencies ag
CROSS JOIN Sales_Agents sa
WHERE ag.ID = sa.ID_AG
GROUP BY
    ag.Agency_Name
order BY AgentsNumber desc;


#	Returnati numarul de polite incheiate la nivel de agent folosind instructiunea JOIN 

SELECT
    ag.Agency_Name AS Agency,
    CONCAT(sm.FirstName, ' ', sm.LastName) AS SalesManagerName,
    CONCAT(sa.FirstName, ' ', sa.LastName) AS AgentName,
    COUNT(pi.policy_number) AS PolicyNumber
FROM
    Agencies ag
    JOIN SA_CO_AG sca ON ag.ID = sca.ID_AG
    JOIN Sales_Manager sm ON sm.ID_Employee = sca.ID_CO
    JOIN Sales_Agents sa ON sa.ID_Employee = sca.ID_SA
    JOIN policies_issued pi ON sca.ID = pi.ID_SA_CO_AG
GROUP BY
    ag.Agency_Name,
    SalesManagerName,
    AgentName;

#	Returnati Sales Managerii si fiecare agent asignat acestuia folosind instructiunea LEFT JOIN 

SELECT 
	CONCAT(sm.FirstName, ' ', sm.LastName) AS SalesManagerName, 
	CONCAT(sa.FirstName, ' ', sa.LastName) AS AgentName 
FROM Sales_Manager sm
	 LEFT JOIN Sales_Agents sa ON sm.ID_employee = sa.ID_CO
     ORDER BY SalesManagerName;
     
#	Returnati Agentiile si Sales Managerii precum si informatiile acestora folosind instrctiunea RIGHT JOIN 

SELECT * from Agencies ag right join sales_manager sm on ag.id = sm.ID_AG;


# 	Returnati Agentiile cu >= 1 Sales Manageri folosind instructiunea INNER JOIN

SELECT
    ag.Agency_Name AS Agency,
    COUNT(sm.ID_employee) AS SalesManagerNo
FROM
    Agencies ag
INNER JOIN Sales_Manager sm ON ag.ID = sm.ID_AG
GROUP BY
    Agency
HAVING
    SalesManagerNo >= 1
ORDER BY
    SalesManagerNo;

#	Returnati agentii de vanzari angajati in 2018

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
WHERE ID_SA_CO_AG IN (SELECT ID FROM SA_CO_AG WHERE ID_SA = 1004);


