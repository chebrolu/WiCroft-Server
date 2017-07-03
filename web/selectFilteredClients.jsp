<%-- 
    Document   : selectSelectedClients
    Created on : 4 Jun, 2017, 4:57:29 PM
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

         if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
            CopyOnWriteArrayList<String> selectedMacs = new CopyOnWriteArrayList<String>();
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            
            if(mySession == null){
                session.setAttribute("currentUser",null);
                response.sendRedirect("login.jsp");

            }else{

            String macs[] = request.getParameterValues("selectedclient");    
            String module = request.getParameter("module");    
  
            if(module.equalsIgnoreCase("changeApSettings")){
                mySession.getChangeApSelectedClients().clear();
                if(macs != null){
                    for(String mac : macs){
                        mySession.getChangeApSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("changeApSettings");
            }else if(module.equalsIgnoreCase("sendControlFile")){
                mySession.getSendCtrlFileSelectedClients().clear();
                if(macs != null){
                    for(String mac : macs){
                        mySession.getSendCtrlFileSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("sendControlFile");

            }else if(module.equalsIgnoreCase("startExperiment")){
                mySession.getStartExpSelectedClients().clear();
                if(macs != null){
                    for(String mac : macs){
                        mySession.getStartExpSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("startExperiment");
            }else if(module.equalsIgnoreCase("wakeUpTimer")){
                mySession.getWakeUpTimerSelectedClients().clear();
                if(macs != null){
                    for(String mac : macs){
                        mySession.getWakeUpTimerSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("wakeUpTimer");
            }else if(module.equalsIgnoreCase("appUpdate")){
                mySession.getAppUpdateSelectedClients().clear();
                if(macs != null){
                    for(String mac : macs){
                        mySession.getAppUpdateSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("appUpdate");
            }else if(module.equalsIgnoreCase("ReqLogFiles")){
                mySession.getRequestLogFileSelectedClients().clear();
                if(macs != null){
                    for(String mac : macs){
                        mySession.getRequestLogFileSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("ReqLogFiles");
            }else if(module.equalsIgnoreCase("reUseControlFile")){
                mySession.getSendCtrlFileSelectedClients().clear();
                
                if(macs != null){
                    for(String mac : macs){
                        mySession.getSendCtrlFileSelectedClients().add(mac);
                    }
                }
                mySession.setCurrentAction("reUseControlFile");
            }

            response.sendRedirect("selectClients.jsp?closewindow=true");
        }
         }
        %>
            
    </body>
</html>
