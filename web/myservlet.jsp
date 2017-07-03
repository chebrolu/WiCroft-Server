<%-- 
    Document   : myservlet
    Created on : 4 Jun, 2017, 10:27:36 AM
    Author     : ratheeshkv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wicroft</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            mySession.setWakeupValue("");
            if(request.getParameter("myselect").equals("1")){
                mySession.setWakeupValue("ONE On my cold fusion page what I want to do is click one of the options from my  statement. After doing so I want to see a richtextbox be dynamically filled with a matching record in my database from the value of the item I clicked. I also want it to do the same for a checkbox, and authors object");
            }else if(request.getParameter("myselect").equals("2")){
                mySession.setWakeupValue("TWO On my cold fusion page what I want to do is click one of the options from my  statement. After doing so I want to see a richtextbox be dynamically filled with a matching record in my database from the value of the item I clicked. I also want it to do the same for a checkbox, and authors object");
            }else if(request.getParameter("myselect").equals("3")){
                mySession.setWakeupValue("THREE On my cold fusion page what I want to do is click one of the options from my  statement. After doing so I want to see a richtextbox be dynamically filled with a matching record in my database from the value of the item I clicked. I also want it to do the same for a checkbox, and authors object");
            }else if(request.getParameter("myselect").equals("4")){
                mySession.setWakeupValue("FOUR On my cold fusion page what I want to do is click one of the options from my  statement. After doing so I want to see a richtextbox be dynamically filled with a matching record in my database from the value of the item I clicked. I also want it to do the same for a checkbox, and authors object");
            }
            response.sendRedirect("utilities.jsp");
              }
            %>
    </body>
</html>
