<%-- 
    Document   : selectClientsHandler
    Created on : 4 Jun, 2017, 1:47:21 PM
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

        <%

            if(session.getAttribute("currentUser")==null){
                response.sendRedirect("login.jsp");
            }else{


//          mySession.getChangeApSelectedClients().clear();

            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            
            
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            String filter = request.getParameter("filter");
            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
            CopyOnWriteArrayList<String> temp1 = new CopyOnWriteArrayList<String>();
            CopyOnWriteArrayList<String> temp2 = new CopyOnWriteArrayList<String>();
            String module = request.getParameter("module");
            String fileId = request.getParameter("fileid");

            out.write(module+"\n");
            out.write(fileId+"\n");


            

            out.write(module);

            if(module.equalsIgnoreCase("reUseControlFile")){

                
                int userId = DBManager.getUserId(username);
                ResultSet rs = DBManager.getUserMacHavingCtrlFile(userId, Integer.parseInt(fileId));
                CopyOnWriteArrayList<String> clientsHaveFile = new CopyOnWriteArrayList<String>();

                if (rs != null) {
                    try {
                        while (rs.next()) {
                            String mac = rs.getString("macaddr");
                            clientsHaveFile.add(mac);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }


                if(filter.equals("bssid")){
                


                String [] bssids =  request.getParameterValues("bssid");
                CopyOnWriteArrayList<String> bssidList = new CopyOnWriteArrayList<String>();

                if(bssids != null){
                    for(String bss : bssids){
                    System.out.print("BSS"+bss);
                        bssidList.add(bss);
                    }
                }


                //String bssid = request.getParameter("bssid");
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
             

                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(!clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device) && device!= null && device.getBssid()!= null && bssidList.contains(device.getBssid())) {
                                temp1.add(mac);
                            }else if(device!= null && device.getBssid() != null && bssidList.contains(device.getBssid())){
                                temp2.add(mac);
                            }
                        }
                    }
                }


            }else if(filter.equals("ssid")){
                //String ssid = request.getParameter("ssid");

                String [] ssids =  request.getParameterValues("ssid");
                CopyOnWriteArrayList<String> ssidList = new CopyOnWriteArrayList<String>();

                if(ssids != null){
                    for(String ss : ssids){

                        ssidList.add(ss);
                    }
                }

                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
               
                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(!clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device) && device!= null && device.getSsid()!= null && ssidList.contains(device.getSsid())) {
                                temp1.add(mac);
                            }else if(device!= null && device.getSsid() != null && ssidList.contains(device.getSsid())){
                                temp2.add(mac);
                            }
                        }
                    }
                }
             

            }else if(filter.equals("random")){
                
                int random = Integer.parseInt(request.getParameter("random"));
                int clientsNum = 0;
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
 
                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(!clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(clientsNum < random && activeClient != null && activeClient.contains(device)){
                                clientsNum += 1;
                                temp1.add(mac);
                            }else if(clientsNum < random){
                                clientsNum += 1;
                                temp2.add(mac);
                            }
                        }
                    }
                }

            }else if(filter.equals("manual")){
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();

                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(!clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device)){
                                temp1.add(mac);
                            }else{
                                temp2.add(mac);
                            }
                        }
                    }
                }

                
            }else{
                System.out.println(filter);
            }

//                mySession.getSendOldCtrlFileSelectedClients().clear();
                mySession.getSendCtrlFileSelectedClients().clear();
                for(int i=0;i<temp1.size();i++){
//                    mySession.getSendOldCtrlFileSelectedClients().add(temp1.get(i));
                    mySession.getSendCtrlFileSelectedClients().add(temp1.get(i));
                }
                for(int i=0;i<temp2.size();i++){
                    mySession.getSendCtrlFileSelectedClients().add(temp2.get(i));
//                    mySession.getSendOldCtrlFileSelectedClients().add(temp2.get(i));
                }

                response.sendRedirect("selectClients.jsp?module="+module+"&fileid="+fileId);


            }else if(module.equalsIgnoreCase("startExperiment")){


                int userId = DBManager.getUserId(username);
                ResultSet rs = DBManager.getUserMacHavingCtrlFile(userId, Integer.parseInt(fileId));
                CopyOnWriteArrayList<String> clientsHaveFile = new CopyOnWriteArrayList<String>();

                if (rs != null) {
                    try {
                        while (rs.next()) {
                            String mac = rs.getString("macaddr");
                            clientsHaveFile.add(mac);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }


                




              if(filter.equals("bssid")){
                


                String [] bssids =  request.getParameterValues("bssid");
                CopyOnWriteArrayList<String> bssidList = new CopyOnWriteArrayList<String>();

                if(bssids != null){
                    for(String bss : bssids){
                    System.out.print("BSS"+bss);
                        bssidList.add(bss);
                    }
                }


                //String bssid = request.getParameter("bssid");
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
             

                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device) && device!= null && device.getBssid()!= null && bssidList.contains(device.getBssid())) {
                                temp1.add(mac);
                            }else if(device!= null && device.getBssid() != null && bssidList.contains(device.getBssid())){
                                temp2.add(mac);
                            }
                        }
                    }
                }


            }else if(filter.equals("ssid")){
                //String ssid = request.getParameter("ssid");

                String [] ssids =  request.getParameterValues("ssid");
                CopyOnWriteArrayList<String> ssidList = new CopyOnWriteArrayList<String>();

                if(ssids != null){
                    for(String ss : ssids){
                    
                        ssidList.add(ss);
                    }
                }

                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
               
                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device) && device!= null && device.getSsid()!= null && ssidList.contains(device.getSsid())) {
                                temp1.add(mac);
                            }else if(device!= null && device.getSsid() != null && ssidList.contains(device.getSsid())){
                                temp2.add(mac);
                            }
                        }
                    }
                }
             

            }else if(filter.equals("random")){
                
                int random = Integer.parseInt(request.getParameter("random"));
                int clientsNum = 0;
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
 
                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(clientsNum < random && activeClient != null && activeClient.contains(device)){
                                clientsNum += 1;
                                temp1.add(mac);
                            }else if(clientsNum < random){
                                clientsNum += 1;
                                temp2.add(mac);
                            }
                        }
                    }
                }

            }else if(filter.equals("manual")){
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();

                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        if(clientsHaveFile.contains(mac)){
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device)){
                                temp1.add(mac);
                            }else{
                                temp2.add(mac);
                            }
                        }
                    }
                }

                
            }else{
                System.out.println(filter);
            }

                mySession.getStartExpSelectedClients().clear();
                for(int i=0;i<temp1.size();i++){
                    mySession.getStartExpSelectedClients().add(temp1.get(i));
                }
                for(int i=0;i<temp2.size();i++){
                    mySession.getStartExpSelectedClients().add(temp2.get(i));
                }

                response.sendRedirect("selectClients.jsp?module="+module+"&fileid="+fileId);
                
            



            }else{


            if(filter.equals("bssid")){
                


                String [] bssids =  request.getParameterValues("bssid");
                CopyOnWriteArrayList<String> bssidList = new CopyOnWriteArrayList<String>();

                if(bssids != null){
                    for(String bss : bssids){
                    System.out.print("BSS"+bss);
                        bssidList.add(bss);
                    }
                }


                //String bssid = request.getParameter("bssid");
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
             

                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device) && device!= null && device.getBssid()!= null && bssidList.contains(device.getBssid())) {
                                temp1.add(mac);
                            }else if(device!= null && device.getBssid() != null && bssidList.contains(device.getBssid())){
                                temp2.add(mac);
                            }
                    }
                }


            }else if(filter.equals("ssid")){
                //String ssid = request.getParameter("ssid");

                String [] ssids =  request.getParameterValues("ssid");
                CopyOnWriteArrayList<String> ssidList = new CopyOnWriteArrayList<String>();

                if(ssids != null){
                    for(String ss : ssids){
                    
                        ssidList.add(ss);
                    }
                }

                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
               
                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        
                            DeviceInfo device = client.get(mac);
                            if(activeClient != null && activeClient.contains(device) && device!= null && device.getSsid()!= null && ssidList.contains(device.getSsid())) {
                                temp1.add(mac);
                            }else if(device!= null && device.getSsid() != null && ssidList.contains(device.getSsid())){
                                temp2.add(mac);
                            }
                    }
                }
             

            } else if(filter.equals("random")){
                
                int random = Integer.parseInt(request.getParameter("random"));
                int clientsNum = 0;
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();
 
                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        DeviceInfo device = client.get(mac);
                        if(clientsNum < random && activeClient != null && activeClient.contains(device)){
                            clientsNum += 1;
                            temp1.add(mac);
                        }else if(clientsNum < random){
                            clientsNum += 1;
                            temp2.add(mac);
                        }
                    }
                }

            }else if(filter.equals("manual")){
                
                ConcurrentHashMap<String, DeviceInfo> client = mySession.getSelectedConnectedClients();
                Enumeration<String> clientsMac = client.keys();

                if(clientsMac!=null){
                    while(clientsMac.hasMoreElements()){
                        String mac = clientsMac.nextElement();
                        DeviceInfo device = client.get(mac);
                        if(activeClient != null && activeClient.contains(device)){
                            temp1.add(mac);
                        }else{
                            temp2.add(mac);
                        }
                    }
                }

                
            }else{
                System.out.println(filter);
            }






                if(module.equalsIgnoreCase("changeApSettings")){
                    mySession.getChangeApSelectedClients().clear();

                    for(int i=0;i<temp1.size();i++){
                        mySession.getChangeApSelectedClients().add(temp1.get(i));
                    }
                    for(int i=0;i<temp2.size();i++){
                        mySession.getChangeApSelectedClients().add(temp2.get(i));
                    }

                }else if(module.equalsIgnoreCase("sendControlFile")){
                      mySession.getSendCtrlFileSelectedClients().clear();
                    for(int i=0;i<temp1.size();i++){
                        mySession.getSendCtrlFileSelectedClients().add(temp1.get(i));
                    }
                    for(int i=0;i<temp2.size();i++){
                        mySession.getSendCtrlFileSelectedClients().add(temp2.get(i));
                    }

                }else if(module.equalsIgnoreCase("startExperiment")){
                    mySession.getStartExpSelectedClients().clear();
                    for(int i=0;i<temp1.size();i++){
                        mySession.getStartExpSelectedClients().add(temp1.get(i));
                    }
                    for(int i=0;i<temp2.size();i++){
                        mySession.getStartExpSelectedClients().add(temp2.get(i));
                    }

                }else if(module.equalsIgnoreCase("wakeUpTimer")){
                    mySession.getWakeUpTimerSelectedClients().clear();
                    for(int i=0;i<temp1.size();i++){
                        mySession.getWakeUpTimerSelectedClients().add(temp1.get(i));
                    }
                    for(int i=0;i<temp2.size();i++){
                        mySession.getWakeUpTimerSelectedClients().add(temp2.get(i));
                    }

                }else if(module.equalsIgnoreCase("appUpdate")){
                    mySession.getAppUpdateSelectedClients().clear();
                    for(int i=0;i<temp1.size();i++){
                        mySession.getAppUpdateSelectedClients().add(temp1.get(i));
                    }
                    for(int i=0;i<temp2.size();i++){
                        mySession.getAppUpdateSelectedClients().add(temp2.get(i));
                    }

                }else if(module.equalsIgnoreCase("ReqLogFiles")){
                    mySession.getRequestLogFileSelectedClients().clear();
                    for(int i=0;i<temp1.size();i++){
                        mySession.getRequestLogFileSelectedClients().add(temp1.get(i));
                    }
                    for(int i=0;i<temp2.size();i++){
                        mySession.getRequestLogFileSelectedClients().add(temp2.get(i));
                    }
                }
                response.sendRedirect("selectClients.jsp?module="+module);
            }

        
        }}
        %>

    </body>
</html>
