*** Settings ***
Documentation  A resource file containing the application specific keywords
Resource    ../Tests_resources/WebSocketconnection.robot
# Resource    ../../../lib/DBConnection.robot
Resource    ../regression/Regression1_config.robot
# Suite setup  Create Testdata for script


** Keywords **
# Create Testdata for script
    # Log in to our application with  &{login_details}
    

*** Test Cases ***
Login To Application
    Login To Application    &{login_details}
    
Go to Charge station list
    Go to Charge station list
    
Connect to server
    Connect to server
    
Establish Database Connection
    Establish Database Connection
    

Verify Boot Notification is sent Successfully
    
    BootNotificationRequest  &{Bootmessage}
    Reload Page
    
Remote Start Request
     Remote Start Request:Accepted    &{StartMessage}
     
Verify Transaction is Started Successfully
      StartTransactionRequest  &{StartMessage}
      Reload Page
     
Remote Stop Request:Accepted
    Remote Stop Request:Accepted
         
EVSE-Search By Name
    EVSE-Search By Name
    Click button    xpath=//button[contains(.,'Reset')]
    
EVSE-Search By StationID
    EVSE-Search By StationID
    Click button    xpath=//button[contains(.,'Reset')]
    
EVSE-Search By Location
    EVSE-Search By Location
    Click button    xpath=//button[contains(.,'Reset')]
    
Back to Dashboard
    Back to Dashboard
 
    
Go to Session Summary
    Go to Session Summary
    
  
Show OCPP Logs
    Show OCPP Logs
    
Search Logs by MessageType:Boot Notification
    Search Logs by MessageType:Boot Notification
    
Search Logs by MessageType:Start Transaction
    Search Logs by MessageType:Start Transaction
    
Search Logs by MessageType:Stop Transaction
    Search Logs by MessageType:Stop Transaction
    
Search Logs by MessageType:Status Notification
    Search Logs by MessageType:Status Notification
    

    
    

    

 
    	