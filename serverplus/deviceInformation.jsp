<%-- 
    Document   : deviceInformation
    Created on : 7 Oct, 2016, 8:00:12 PM
    Author     : cse
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.iitb.cse.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CrowdSource</title>
        <link rel="stylesheet" href="/serverplus/css/table.css"> 
    </head>
    <body>


        <br/><a href='homepage.jsp'>Back</a><br/><br/>


        <%
            String macAddress = request.getParameter("macAddr");
            DeviceInfo device = Constants.currentSession.getConnectedClients().get(macAddress);

        %>

        <table border='1'>
            <caption><h3>Connection Information</h3></caption>
            <tr>
                <th>IP Address</th>    
                <th>Port Number</th>    
                <th>BSSID</th>    
                <th>SSID</th>    
                <th>RSSI</th>    
                <th>Link Speed</th>    
            </tr>

            <tr>
                <td><% out.write(device.getIp()); %></td>
                <td><% out.write(Integer.toString(device.getPort())); %></td>
                <td><% out.write(device.getBssid()); %></td>
                <td><% out.write(device.getSsid()); %></td>
                <td><% out.write(device.getRssi()); %></td>
                <td><% out.write(device.getLinkSpeed()); %></td>           
            </tr>   
        </table>
        <br/><br/>

        <table border='1'>
            <caption><h3>Device Information</h3></caption>
            <tr>
                <th>Mac Address</th>    
                <th>Processor Speed</th>    
                <th>Number of Cores</th>    
                <th>Memory</th>    
                <th>Storage Space</th>    
            </tr>

            <tr>
                <td><% out.write(device.getMacAddress()); %></td>
                <td><% out.write(Integer.toString(device.getProcessorSpeed())); %></td>
                <td><% out.write(Integer.toString(device.getNumberOfCores())); %></td>
                <td><% out.write(Integer.toString(device.getMemory())); %></td>
                <td><% out.write(Integer.toString(device.getStorageSpace())); %></td>
            </tr>   
        </table>
        <br/><br/>

        <table border='1'>
            <caption><h3>Near BSS Information</h3></caption>

            <tr>
                <th>No.</th>
                <th>SSID</th>
                <th>BSSID</th>
                <th>RSSI</th>
            </tr>
            <tr>

                <%
                    String bssList[] = device.getBssidList();
    //              out.write("Length : "+bssList.length);
                    if (bssList == null || bssList.length == 0) {
                        out.write("<tr><td colspan='4'>No Information</td></tr>");
                    } else {
                        int slNo = 0;
                        for (int i = 0; i < bssList.length; i++) {
                            slNo++;
                            String info[] = bssList[i].split(",");
                            if (info.length == 3) {
                                out.write("<tr><td>" + slNo + "</td><td>" + info[0] + "</td><td>" + info[1] + "</td><td>" + info[2] + "</td></tr>");
                            } else {
                                out.write("<tr><td colspan='4'>No Information</td></tr>");
                            }
                        }
                    }


                %>

            </tr>   
        </table>


    </body>
</html>
