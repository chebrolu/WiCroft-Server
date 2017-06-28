<%-- 
    Document   : deleteExperiments
    Created on : 29 Jan, 2017, 12:51:59 PM
    Author     : cse
//updateAppClients
--%>


<%@page import="java.sql.ResultSet"%>
<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="java.util.concurrent.CopyOnWriteArrayList"%>
<%@page import="com.iitb.cse.Utils"%>
<%@page import="com.mysql.jdbc.Util"%>
<%@page import="org.eclipse.jdt.internal.compiler.impl.Constant"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CrowdSource</title>
        <link rel="stylesheet" href="/serverplus/css/table.css">    </head>
    <body>

        <!--<br/><a href='getPendingLogFiles.jsp'>Back</a><br/><br/>-->
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

            String [] expid =  request.getParameterValues("selectedclients");

            if(expid != null){
                for(String eid : expid){
                    out.write("\n"+eid);
                    DBManager.deleteExperiment(Integer.parseInt(eid),username);
                }
            }
            response.sendRedirect("experimentDetails.jsp");
        }}

        %>
    </body>
</html>
