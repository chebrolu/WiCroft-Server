<%-- 
    Document   : apchangeStatus
    Created on : 24 Jul, 2016, 12:37:05 AM
    Author     : ratheeshkv
--%>

<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.Constants"%>
<%@page import="com.iitb.cse.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CrowdSource</title>
        <link rel="stylesheet" href="/serverplus/css/table.css">
    </head>
    <body>


        <%
            
                  
        if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
            //response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
                  
              
            String ssid = request.getParameter("_ssid");
            String timer = request.getParameter("_timer");
            String name = request.getParameter("_username");
            String pwd = request.getParameter("_password");
            String sec = request.getParameter("_security");
            
            String setting = "USERNAME=" + name.trim() + "\nPASSWORD=" + pwd.trim() + "\nTIMER=" + timer.trim() + "\nSSID=" + ssid.trim() + "\nSECURITY=" + sec.trim();
            Utils.sendApSettings(setting, mySession);
//          response.sendRedirect("apchangeStatusDetails.jsp");
            response.sendRedirect("configExperiment.jsp");
              }
        }
        
        %>


    </body>
</html>
