*** Settings ***
Documentation  Resource file to have database function
Library		DatabaseLibrary 

*** Variables ***
${DBHost}         localhost
${DBName}         ems_flyway
${DBPass}         root
${DBPort}         3306
${DBUser}         root

** Keywords **
Get TransactionID From Table1
   
    ${TID}=  Query    select max(session_id) from evse_session;  
    Set Global Variable    ${TID}  
        

Establish Database Connection1
    
    Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
    

