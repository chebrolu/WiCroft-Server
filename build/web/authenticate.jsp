<%-- 
    Document   : authenticate
    Created on : 12 Jul, 2016, 10:24:40 PM
    Author     : ratheeshkv
--%>

<%@page import="com.iitb.cse.DBManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>CrowdSource</title>
        <link rel="stylesheet" href="/serverplus/css/table.css">    </head>
    <body>
        <%
            
            /***
            * -1 for no user exist (authentication failure)
            * -2 for database issues
            *  non zero (>0) userId
            */
              String username = request.getParameter("name").trim();
              String password = request.getParameter("pwd").trim();
              int userId = DBManager.authenticate(username, password);
              if(userId > 0){
                  session.setAttribute("currentUser", username);
                  session.setAttribute("currentUserId", Integer.toString(userId));
              }else {
                  session.setAttribute("currentUser", null);
                  session.setAttribute("currentUserId", null);
                  session.setAttribute("loginStatus", Integer.toString(userId));
              }
              response.sendRedirect("index.jsp");              
        %>
    </body>
</html>







