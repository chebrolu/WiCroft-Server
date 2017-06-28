

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
        <Title>Just A Time</Title>
         
   </head>
    <body>
    
    <%
     if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
//            response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
            String uname = (String)session.getAttribute("currentUser");
            Session mySssn = initilizeServer.getUserNameToSessionMap().get(uname);

    %>


    <b>[Server Time &nbsp;:&nbsp; <%
                        Date date = new Date();
                        out.write(date.toString());
                        out.write("["+mySssn.getChangeApSelectedClients().size()+"]");
                        // System.out.println("HAHAHA");
    %> ]<br>

    <!-- [Total clients : <% out.write(mySssn.getChangeApSelectedClients().size());%>] -->




    </b>
    <%
        }
    %>

    </body>
</html>