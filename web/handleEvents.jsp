<%-- 
    Document   : handleEvents
    Created on : 7 Mar, 2017, 2:34:00 PM
    Author     : cse
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
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
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
            if (request.getParameter("event") != null && request.getParameter("event").equalsIgnoreCase("clearlist")) {
//                mySession.getConnectedClients().clear();

                Enumeration<String> macs =   mySession.getSelectedConnectedClients().keys();
                  while(macs.hasMoreElements()){
                      String mac = macs.nextElement();
                      initilizeServer.getAllConnectedClients().remove(mac);
                  }
                //mySession.getSelectedConnectedClients().clear();
                response.sendRedirect("frontpage.jsp");
            }

            
            if (request.getParameter("event") != null && request.getParameter("event").equalsIgnoreCase("clearallbssidlist")) {
//                mySession.getConnectedClients().clear();
                mySession.getSelectedConnectedClients().clear();
                mySession.getSelectedBssidInfo().clear();
                initilizeServer.getAllBssidInfo().clear();
                response.sendRedirect("settings.jsp");
            }


            
            if (request.getParameter("event") != null && request.getParameter("event").equalsIgnoreCase("exitChangeApReq")) {
                mySession.setChangeApRunning(false);
                response.sendRedirect("apchangeStatusDetails.jsp?closewindow=true");
            }

            if (request.getParameter("event") != null && request.getParameter("event").equalsIgnoreCase("exitControlFileSending")) {
                mySession.setSendingControlFile(false);
                response.sendRedirect("sendControlFile.jsp");
            }
            
            if (request.getParameter("event") != null && request.getParameter("event").equalsIgnoreCase("stopreqlogfile")) {
                mySession.setFetchingLogFiles(false);
                response.sendRedirect("utilities.jsp");
            }
            
            
        }}

        %>


    </body>
</html>
