<%-- 
    Document   : startExperiment
    Created on : 22 Jul, 2016, 5:59:41 PM
    Author     : ratheeshkv
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
<%@page import="java.util.Date"%>
<html>
    <head>
        <Title>Wicroft</Title>
         
   </head>
    <body>
    
    <%
     if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{

            String uname = (String)session.getAttribute("currentUser");
            Session mySssn = initilizeServer.getUserNameToSessionMap().get(uname);

    %>

    <b>[Server Time &nbsp;:&nbsp; <%
                        Date date = new Date();
                        out.write(date.toString());
                        out.write("["+mySssn.getChangeApSelectedClients().size()+"]");
    %> ]<br>


    </b>
    <%
        }
    %>

    </body>
</html>