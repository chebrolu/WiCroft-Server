<%-- 
    Document   : logout
    Created on : 7 Sep, 2016, 1:52:31 AM
    Author     : ratheeshkv
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
        <title>Wicroft</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <%            
            
            if(session.getAttribute("currentUser")== null){
                response.sendRedirect("login.jsp");
            }else{
                
            if (request.getParameter("logout").equalsIgnoreCase("logout")) {    
         	   /* try {
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
                }
                */

                
                String username = (String)session.getAttribute("currentUser");
                Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
                initilizeServer.getUserNameToSessionMap().remove(username);
                session.setAttribute("currentUser", null);
                session.setAttribute("currentUserId", null);

                response.sendRedirect("login.jsp");

            } 

            }
        %>
    </body>
</html>
