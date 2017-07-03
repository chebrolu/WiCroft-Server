<%-- 
    Document   : index
    Created on : 12 Jul, 2016, 10:12:40 PM
    Author     : ratheeshkv
--%>

<%@page import="com.iitb.cse.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wicroft</title>
        <link rel="stylesheet" href="/wicroft/css/login.css">
        <link type="text/css" rel="stylesheet" href="./css/frontPage.css" />
    </head>
    <body>


        <%
            if (session.getAttribute("currentUser") == null) {
                
                String loginStatus = (String) session.getAttribute("loginStatus");
                String status = "";
                
                if(loginStatus.equalsIgnoreCase("-1")){
                    status = "wrong_credentials";
                }else if(loginStatus.equalsIgnoreCase("-2")){
                    status = "db_exception";
                }else{
                    status = "success";
                }
                response.sendRedirect("login.jsp?loginStatus="+status);

            } else {

                final String _session = session.getAttribute("currentUser").toString();
                response.sendRedirect("frontpage.jsp");
        %>

        <p>
            Server started
        </p>

        <%               
             }
        %>

    </body>
</html>
