<%-- 
    Document   : accountSettings.jsp
    Created on : 1 Jun, 2017, 1:36:34 PM
    Author     : cse
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
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        
        <%
        
        String action = request.getParameter("action");
        
        if (action.equals("signup")) {

            String userName = request.getParameter("newusername");
            String password = request.getParameter("newpassword");
//            System.out.println("1");
            int status = DBManager.createAccount(userName, password);
//            out.write("status : "+status);
            response.sendRedirect("signup.jsp?&status="+status);
        } else if (action.equals("Create Account")) {

            String userName = request.getParameter("newusername");
            String password = request.getParameter("newpassword");
//            System.out.println("1");
            int status = DBManager.createAccount(userName, password);
//            out.write("status : "+status);
            response.sendRedirect("settings.jsp?action=createaccount&status="+status);
        } else if (action.equals("Delete Account")) {

            String userName = request.getParameter("username");
            String password = request.getParameter("password");
//            System.out.println("2");
            int status = DBManager.deleteAccount(userName, password);
//            out.write("status : "+status);
            response.sendRedirect("settings.jsp?action=deleteaccount&status="+status);
        } else if (action.equals("Change Password")) {
            
            String userName = (String)session.getAttribute("currentUser");//
            String oldpassword = request.getParameter("oldpassword");
            String newpassword = request.getParameter("resetpassword");
//            out.write("3 :"+password+":");
            int status = DBManager.changePassword(userName, oldpassword, newpassword);
//            out.write("status : "+status);
            response.sendRedirect("settings.jsp?action=changepwd&status="+status);
        } else {
            System.out.println("4");
        }
        
        %>
            
                
    </body>
</html>
