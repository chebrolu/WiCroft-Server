<%-- 
    Document   : wakeupClientsStatus
    Created on : 10 Mar, 2017, 3:36:23 PM
    Author     : cse
--%>
<%@page import="java.lang.Long"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.concurrent.CopyOnWriteArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
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
                  
              
            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
            
            String duration = request.getParameter("newtime");
            String filter = request.getParameter("filter");
            out.write("<br> "+duration);
            out.write("<br> "+filter);

            mySession.setWakeUpFilter(filter);
            mySession.setWakeUpDuration(Long.parseLong(duration));
            mySession.setStartwakeUpDuration(System.currentTimeMillis());

            initilizeServer.setStartwakeUpDuration(System.currentTimeMillis());
            initilizeServer.setWakeUpFilter(filter);
            initilizeServer.setWakeUpDuration(Long.parseLong(duration));

            if(filter.equalsIgnoreCase("bssid")){

                mySession.getWakeUpTimerSelectedClients().clear();            
                String arr[] = request.getParameterValues("bssid");
                for (int i = 0; i < arr.length; i++) {
                    mySession.getWakeUpTimerSelectedClients().add(arr[i]);
                    initilizeServer.getWakeUpClients().put(arr[i], 1); 
                }

            }else if(filter.equalsIgnoreCase("ssid")){

                mySession.getWakeUpTimerSelectedClients().clear();
                String arr[] = request.getParameterValues("ssid");
                for (int i = 0; i < arr.length; i++) {
                    mySession.getWakeUpTimerSelectedClients().add(arr[i]);
                    initilizeServer.getWakeUpClients().put(arr[i], 1); 
                }

            }else if(filter.equalsIgnoreCase("setToAll")){

                mySession.getWakeUpTimerSelectedClients().clear();
                Enumeration<String> macs = mySession.getSelectedConnectedClients().keys();
                while(macs.hasMoreElements()){
                    mySession.getWakeUpTimerSelectedClients().add(macs.nextElement());
                }

            }else if(filter.equalsIgnoreCase("clientSpecific")){
                    // already selected clients
                for(int i=0;i<mySession.getWakeUpTimerSelectedClients().size();i++){
//                      System.out.println("Cllient "+mySession.getWakeUpTimerSelectedClients().get(i));
                    initilizeServer.getWakeUpClients().put(mySession.getWakeUpTimerSelectedClients().get(i), 1); 
                }
            }

//        for(int i=0;i<mySession.getWakeUpTimerSelectedClients().size();i++){
//            System.out.println("Cllient "+mySession.getWakeUpTimerSelectedClients().get(i));
//        }
    
            Utils.sendWakeUpRequest(filter, duration, mySession);            
            response.sendRedirect("wakeupClientsView.jsp");

            }}

        %>
    </body>
</html>
