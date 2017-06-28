<%-- 
    Document   : setBssidList.jsp
    Created on : 1 Jun, 2017, 1:00:07 AM
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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>


        <%
            
//            Constants.currentSession.allBssidInfo.clear();

            if(session.getAttribute("currentUser")== null){
                response.sendRedirect("login.jsp");
            }else{
                
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            
            mySession.getSelectedBssidInfo().clear();
            String currentBssids[] = request.getParameterValues("selectedbssids");
            
            if(currentBssids != null){
                for (String bssid : currentBssids) { 
                    String ssid = initilizeServer.allBssidInfo.get(bssid);
                    if(ssid != null){
//                      Constants.currentSession.allBssidInfo.put(bssid, ssid);
                        mySession.getSelectedBssidInfo().put(bssid, ssid);
                    }
                }
            }
            
            String newBssids[] = request.getParameterValues("selectnewbssids");
            
            if(newBssids != null){
                for (String bssid : newBssids) { 
                    String ssid = initilizeServer.allBssidInfo.get(bssid);
                    if(ssid != null){
//                        Constants.currentSession.allBssidInfo.put(bssid, ssid);
                          mySession.getSelectedBssidInfo().put(bssid, ssid);
                    }
                }
            }
            
        response.sendRedirect("settings.jsp");
            }}
        %>

    </body>
</html>
