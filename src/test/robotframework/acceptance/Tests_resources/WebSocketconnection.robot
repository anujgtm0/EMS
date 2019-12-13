*** Settings ***
Library    String
Library    WebSocketClient
Documentation  A resource file containing login/logout keywords
Library		Selenium2Library
Library    Collections
Library		DatabaseLibrary 

*** Variables ***
${DBHost}         localhost
${DBName}         ems_flyway
${DBPass}         root
${DBPort}         3306
${DBUser}         root
 ${str1}=    [2,"988746","StopTransaction",{"idTag":"123456","meterStop":2000,"timestamp":"2015-06-30T09:50:37.000Z","transactionId":
 ${str2}=    ,"reason":"EmergencyStop","transactionData":[]}]
${my_websocket}
${Delay}    2s
${stoptmessage}
${RemoteStartRequest}
** Keywords **
Get TransactionID From Table
   
    ${queryResult1}  Query    select max(session_id) from evse_session;
    ${TID}=    Set Variable    ${queryResult1[0][0]}  
    Set Global Variable    ${TID}  
    ${str3}=    Catenate    SEPARATOR=    ${TID}    ${str2}   
    ${stoptmessage}=    Catenate    SEPARATOR=    ${str1}    ${str3}    
    Set Global Variable    ${stoptmessage}         
        

Establish Database Connection
    
    Connect To Database    pymysql    ${DBName}    ${DBUser}    ${DBPass}    ${DBHost}    ${DBPort}
Connect to server
     ${my_websocket}=    WebSocketClient.Connect    ws://localhost:8887/1234
     Set Global Variable    ${my_websocket}
BootNotificationRequest
    [Arguments]  &{Bootmessage}
    WebSocketClient.Send    ${my_websocket}    &{Bootmessage}[bootmessage]
    ${result}=    WebSocketClient.Recv    ${my_websocket}
    Log  ${result}
     Should Contain    ${result}    Accepted
     sleep    ${Delay}
   # WebSocketClient.Close    ${my_websocket}
Log in to our application with
	[Arguments]    &{login_values}
	
    Open Browser   &{login_values}[url]   &{login_values}[browser]
     Maximize Browser Window
    Login To Application   &{login_values}
    
Login To Application
    [Arguments]   &{login_values}
     Open Browser   &{login_values}[url]   &{login_values}[browser]
     Maximize Browser Window
    Input text   xpath=//input[@formcontrolname='username']    &{login_values}[user]
    sleep  ${Delay}
    Input password   xpath=//input[contains(@formcontrolname,'password')]   &{login_values}[password]
    Click button     xpath=//button[contains(.,'Login')]
    sleep    ${Delay}
     Wait Until Page Contains    Total Locations
    
    
StartTransactionRequest
    [Arguments]  &{StartMessage}
      WebSocketClient.Send    ${my_websocket}    &{StartMessage}[startmessage]
     ${result}=    WebSocketClient.Recv    ${my_websocket}
     Log  ${result}
     Should Contain    ${result}    Accepted
      sleep    ${Delay}
      
StopTransactionRequest
   
      WebSocketClient.Send    ${my_websocket}    ${stoptmessage}
     ${result}=    WebSocketClient.Recv    ${my_websocket}
     Log  ${result}
      Should Contain    ${result}    Accepted
      sleep    ${Delay}
      
Go to Charge station list
    Click Link    xpath=//a[contains(.,'Charge Management')]
    sleep    ${Delay}    
    Wait Until Page Contains    Charge Stations

    
Back to Dashboard
    Click Link    xpath=//a[contains(.,'Dashboard')]
    sleep    ${Delay}  
    Wait Until Page Contains    Total Locations
    
Go to Session Summary
    Click Link    xpath=//a[contains(.,'Reports')]
    sleep    ${Delay}
    Wait Until Page Contains    Session Summary
    
Show OCPP Logs
    Click Link    xpath=//a[contains(.,'OCPP Logs')]
    sleep    ${Delay}
    Wait Until Page Contains    OCPP Logs
    
EVSE-Search By Name
    Input text    xpath=//input[@placeholder='Search']    MODEL1_INST1
    Click button    xpath=//button[contains(.,'Submit')]    
    sleep    ${Delay}
    Wait Until Page Contains    MODEL1_INST1    timeout=10s
    
EVSE-Search By StationID
    Input text    xpath=//input[@placeholder='Search']    S1
    Click button    xpath=//button[contains(.,'Submit')]    
    sleep    ${Delay}
    Wait Until Page Contains    S1    timeout=10s
    
EVSE-Search By Location
    Input text    xpath=//input[@placeholder='Search']     Sec 153
    Click button    xpath=//button[contains(.,'Submit')]    
    sleep    ${Delay}
    Wait Until Page Contains     Sec 153    timeout=10s
    
Select Datepicker Date
    [Documentation]     Select given day from datepicker
    # [Arguments]     ${dateElem}     ${expectedMonthYear}    ${clickElement}
    Click button  xpath=//button[@aria-label='Open calendar']        # open the datepicker
    ${monthyear}=   Get Datepicker MonthYear
    :FOR    ${Index}    IN RANGE    1   31
    \   Run Keyword If  '${monthyear}' == 'NOV 2019'   Exit For Loop
    \   Click Link   xpath=//div[@class='mat-button-ripple mat-ripple mat-button-ripple-round']
    \   ${monthyear}=   Get Datepicker MonthYear
    Click Link    14

Get Datepicker MonthYear
    [Documentation]     Return current month + year from datepicker
    [Return]    ${monthyear}
    ${monthyear}=    Get Text  //span[@class='mat-button-wrapper']
    
Search Logs by MessageType:Boot Notification
    Click Element    xpath=//div[@class='mat-form-field-infix']/mat-select[@placeholder='Message Type']
    Click Element    xpath=//span[@class='mat-option-text'][contains(.,'Boot Notification')]
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Submit')]
    sleep    ${Delay}    
    Page Should Not Contain Element    Stop Transaction    Start Transaction    Status Notification
    Click button    xpath=//button[@class='btn_flat mat-button mat-button-base'][contains(.,'Reset')]
    
Search Logs by MessageType:Start Transaction
    Click Element    xpath=//div[@class='mat-form-field-infix']/mat-select[@placeholder='Message Type']
    Click Element    xpath=//span[@class='mat-option-text'][contains(.,'Start Transaction')]
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Submit')]
    sleep    ${Delay}    
    Page Should Not Contain Element    Stop Transaction    Boot Notification    Status Notification
    Click button    xpath=//button[@class='btn_flat mat-button mat-button-base'][contains(.,'Reset')]
    
Search Logs by MessageType:Stop Transaction
    Click Element    xpath=//div[@class='mat-form-field-infix']/mat-select[@placeholder='Message Type']
    Click Element    xpath=//span[@class='mat-option-text'][contains(.,'Stop Transaction')]
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Submit')]
    sleep    ${Delay}    
    Page Should Not Contain Element    Start Transaction    Boot Notification    Status Notification
    Click button    xpath=//button[@class='btn_flat mat-button mat-button-base'][contains(.,'Reset')]
    
Search Logs by MessageType:Status Notification
    Click Element    xpath=//div[@class='mat-form-field-infix']/mat-select[@placeholder='Message Type']
    Click Element    xpath=//span[@class='mat-option-text'][contains(.,'Status Notification')]
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Submit')]
    sleep    ${Delay}    
    Page Should Not Contain Element    Start Transaction    Boot Notification    Stop Transaction
    
Remote Start Request:Accepted
    [Arguments]  &{StartMessage}
    Click Element    xpath=//mat-row[@class='mat-row ng-star-inserted'][contains(.,'MODEL1_INST1')]//a[@mattooltip='Remote Start']
    sleep    ${Delay}
    Input text    xpath=//input[contains(@placeholder,'RFID')]    123456
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Start')]
     ${RemoteStartRequest}=    WebSocketClient.Recv    ${my_websocket}
    @{words}    Split String    ${RemoteStartRequest}    separator=,    max_split=-1
    &{RequestData}=  Create Dictionary  MessageID=@{words}[1]  CommandName=@{words}[2]
     ${RemoteStartResponse}=    Catenate    SEPARATOR=    [3,    &{RequestData}[MessageID]   
     ${RemoteStartResponse}=    Catenate    SEPARATOR=    ${RemoteStartResponse}    ,{"status":"Accepted"}]
    WebSocketClient.Send    ${my_websocket}    ${RemoteStartResponse}
    sleep    ${Delay}    
    Page Should Contain Element    Available
    
    
Remote Start Request:Rejected
    Click Element    xpath=//mat-row[@class='mat-row ng-star-inserted'][contains(.,'MODEL1_INST1')]//a[@mattooltip='Remote Start']
    Input text    xpath=//input[contains(@placeholder,'RFID')]    123456
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Start')]
     ${RemoteStartRequest}=    WebSocketClient.Recv    ${my_websocket}
    @{words}    Split String    ${RemoteStartRequest}    separator=,    max_split=-1
    &{RequestData}=  Create Dictionary  MessageID=@{words}[1]  CommandName=@{words}[2]
     ${RemoteStartResponse}=    Catenate    SEPARATOR=    [3,    &{RequestData}[MessageID]   
     ${RemoteStartResponse}=    Catenate    SEPARATOR=    ${RemoteStartResponse}    ,{"status":"Rejected"}]
     Set Global Variable    ${RemoteStartResponse}
    WebSocketClient.Send    ${my_websocket}    ${RemoteStartResponse}
    sleep    ${Delay} 
    Page Should Not Contain Element    Available
    
            
    
Remote Stop Request:Accepted
    Click Element    xpath=//mat-row[@class='mat-row ng-star-inserted'][contains(.,'MODEL1_INST1')]//a[@mattooltip='Remote Stop']
    sleep    ${Delay}
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Stop')]
     ${RemoteStopRequest}=    WebSocketClient.Recv    ${my_websocket}
    @{words}    Split String    ${RemoteStopRequest}    separator=,    max_split=-1
    &{RequestData}=  Create Dictionary  MessageID=@{words}[1]  CommandName=@{words}[2]
     ${RemoteStopResponse}=    Catenate    SEPARATOR=    [3,    &{RequestData}[MessageID]   
     ${RemoteStopResponse}=    Catenate    SEPARATOR=    ${RemoteStopResponse}    ,{"status":"Accepted"}]
    WebSocketClient.Send    ${my_websocket}    ${RemoteStopResponse}
    sleep    ${Delay} 
    Page Should Contain Element    Busy
    
Remote Stop Request:Rejected
    Click Element    xpath=//mat-row[@class='mat-row ng-star-inserted'][contains(.,'MODEL1_INST1')]//a[@mattooltip='Remote Stop']
    sleep    ${Delay}
    Click Element    xpath=//span[@class='mat-button-wrapper'][contains(.,'Stop')]
     ${RemoteStopRequest}=    WebSocketClient.Recv    ${my_websocket}
    @{words}    Split String    ${RemoteStopRequest}    separator=,    max_split=-1
    &{RequestData}=  Create Dictionary  MessageID=@{words}[1]  CommandName=@{words}[2]
     ${RemoteStopResponse}=    Catenate    SEPARATOR=    [3,    &{RequestData}[MessageID]   
     ${RemoteStopResponse}=    Catenate    SEPARATOR=    ${RemoteStopResponse}    ,{"status":"Rejected"}]
    WebSocketClient.Send    ${my_websocket}    ${RemoteStopResponse}
    sleep    ${Delay} 
    Page Should Not Contain Element    Available
    

     
    
   
    
    


    
