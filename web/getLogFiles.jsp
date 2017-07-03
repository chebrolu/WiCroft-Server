<%-- 
    Document   : getLogFiles
    Created on : 31 Jul, 2016, 3:56:07 PM
    Author     : ratheeshkv
--%>

<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.iitb.cse.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wicroft</title>
        <link rel="stylesheet" href="/wicroft/css/table.css">    </head>
    <body>

        <%


        if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            
            if(request.getParameter("retryLogFile").equals("true")){
                mySession.getRequestLogFileSelectedClients().clear();
                String name[] = request.getParameterValues("selected");
                for (String mac : name) { // 1_macAddress form
                    mySession.getRequestLogFileSelectedClients().add(mac);
                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                    device.setDetails("---");
                }
            }else{
                for(int i=0;i<mySession.getRequestLogFileSelectedClients().size();i++){
                    String mac = mySession.getRequestLogFileSelectedClients().get(i);
                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                    device.setDetails("---");
                }
            }
            
            int numOfClients = Integer.parseInt(request.getParameter("reqLogNumClients"));
            int roundDuration = Integer.parseInt(request.getParameter("reqLogDuration"));
            Utils.requestLogFiles(numOfClients, roundDuration, mySession);

            response.sendRedirect("getLogFilesReqStatus.jsp");
        }}

        %>
    </body>
</html>
