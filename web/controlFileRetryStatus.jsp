<%-- 
    Document   : controlFileRetryStatus
    Created on : 23 Mar, 2017, 2:20:00 AM
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

        <br/><a href='getPendingLogFiles.jsp'>Back</a><br/><br/>
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

                String newFileId = request.getParameter("newFileId");
                String newFileName = request.getParameter("newFileName");
                String ctrlFileNumClients = request.getParameter("ctrlFileNumClients");
                String ctrlFileDuration = request.getParameter("ctrlFileDuration");

                String macs[] = request.getParameterValues("selected");
                mySession.getSendCtrlFileSelectedClients().clear();
                for(String mac : macs){
                    mySession.getSendCtrlFileSelectedClients().add(mac);    
                }

           Utils.reSendControlFile(newFileId,newFileName,ctrlFileNumClients,ctrlFileDuration,username,mySession);
           response.sendRedirect("controlFileStatus.jsp?fileid="+newFileId+"&filename="+newFileName);
       }
            }
        %>
    </body>
</html>
