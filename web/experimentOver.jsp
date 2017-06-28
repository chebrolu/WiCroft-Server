<%-- 
    Document   : experimentOver
    Created on : 2 Aug, 2016, 2:07:56 AM
    Author     : cse
--%>

<%@page import="com.iitb.cse.Utils"%>
<%@page import="com.iitb.cse.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CrowdSource</title>
        <link rel="stylesheet" href="/serverplus/css/table.css">    </head>
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
            if (request.getParameter("stopExp") != null) {
                mySession.setExperimentRunning(false);
                Utils.sendStopExperiment(Integer.parseInt(mySession.getLastConductedExpId()), username, mySession); 
                
                response.sendRedirect("configExperiment.jsp");
            }
        }}
        %>

    </body>
</html>
