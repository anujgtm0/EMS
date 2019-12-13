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
Connect to server
    Connect to server
    
Establish Database Connection
    Establish Database Connection
    

Verify Boot Notification is sent Successfully
    
    BootNotificationRequest  &{Bootmessage}
    
Go to Charge station list
    Go to Charge station list
    
Remote Start Request
     Remote Start Request:Accepted    &{StartMessage}
     
Verify Transaction is Started Successfully
      StartTransactionRequest  &{StartMessage}
      Reload Page
         
Go to Charge station list
    Go to Charge station list
    
Remote Stop Request:Accepted
    Remote Stop Request:Accepted
    
Get TransactionID From Table
    Get TransactionID From Table
    
Verify Transaction is stopped Successfully
    StopTransactionRequest 
    Reload Page
    

    
    

    

 
    	