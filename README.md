# Incentive_Program

Short description

It is desired to implement an evaluation project for sales employees, called "incentive program" which addresses coordinators and sales agents to encourage sales and motivate them. 
For this evaluation to be possible it is necessary to create a database whose purpose is to store data for an insurance company.
In an insurance company there are several sales agencies. Each coordinator belongs to a certain agency and each coordinator has sales agents under him. For evaluation, the number of policies issued by each insurance agent will be taken into account. 

To be able to extract the necessary information, it will be necessary to create  the following tables:
1. 'Agencies' which will contain the following columns: ID, Agency_Name, Adress, PhoneNumber, EmailAdress;
2. 'Coordinator' which will contain the following columns: ID, ID_AG, FirstName, LastName, DateOfBirth, HireDate;
3. 'Sales_Agents'  which will contain the following columns: ID, ID_CO, ID_AG, FirstName, LastName, DateOfBirth, HireDate;
4. 'Link_Table' which will contain the following columns: ID, ID_SA, ID_CO, ID_AG;
5. 'Policies_Issued' which will contain the following columns: ID, ID_Link, ClientName, Policy_Number, DateOfPolicy, StatusOfPolicy, Insurance_premium, Currency;
