<%-- 
    Document   : logout
    Created on : 7 Sep, 2016, 1:52:31 AM
    Author     : cse
--%>

<%@page import="java.util.Enumeration"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.*"%>
<%@page import="com.iitb.cse.ClientConnection"%>
<%@page import="java.io.IOException"%>
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
            
            
            if(session.getAttribute("currentUser")== null){
                response.sendRedirect("login.jsp");
            }else{
                
            if (request.getParameter("logout").equalsIgnoreCase("logout")) {    

              /*  try {
                    initilizeServer.listenSocket.close();
                    Enumeration<String> macs = initilizeServer.getAllConnectedClients().keys();
                    while(macs.hasMoreElements()){
                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(macs.nextElement());
                        try{
                        device.getSocket().close();
                        }catch(Exception ex){
                            ex.printStackTrace();
                        }
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }*/
                
                String username = (String)session.getAttribute("currentUser");
                Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
                initilizeServer.getUserNameToSessionMap().remove(username);
                session.setAttribute("currentUser", null);
                session.setAttribute("currentUserId", null);
                
                

//                out.write(request.getParameter("logout"));

//                ConcurrentHashMap<String, DeviceInfo> clients = Constants.currentSession.getConnectedClients();
//                Enumeration<String> macList = clients.keys();
//                while (macList.hasMoreElements()) {
//                    String macAddr = macList.nextElement();
//                    DeviceInfo device = clients.get(macAddr);
//                    
//                    if (device.getSocket() != null) {
//                        device.getSocket().close();
//                    }
//                    if (device.getInpStream() != null) {
//                        device.getInpStream().close();
//                    }
//
//                    if (device.getOutStream() != null) {
//                        device.getOutStream().close();
//                    }
//                }
//                
//                session.setAttribute("currentUser", null);
//
//                ClientConnection.stoplistenForClients(Constants.currentSession);
                
                
                
                response.sendRedirect("login.jsp");

            } else {
//            out.write("login");
            }
            }
        %>
    </body>
</html>
