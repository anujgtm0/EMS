*** Settings ***
Documentation  A resource file containing variables used for script
Resource    ../resources/DBConnection.robot   

*** Variables ***
# Make sure to change level, station id, session id and short_name
&{login_details}  url=http://localhost:8082/ems  browser=chrome  user=superadmin  password=Password@1
${Delay}          2s
&{Bootmessage}  bootmessage=[2,"766590","BootNotification",{"chargePointVendor":"Greenlots","chargePointModel": "VirtualCP","chargePointSerialNumber": "121321331","chargeBoxSerialNumber":"1234","firmwareVersion":"v101alpha","iccid":"iccid","imsi": "imsi","meterType": "Increasing","meterSerialNumber": "B7A4CA2E"}]
&{StartMessage}  startmessage=[2,"867508","StartTransaction",{"connectorId": 1,"idTag": "123456","meterStart": 1000,"timestamp": "2019-11-20T08:50:37.000Z"}]


