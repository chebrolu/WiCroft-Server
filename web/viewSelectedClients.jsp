<%-- 
    Document   : viewSelectedClients
    Created on : 9 Jun, 2017, 12:41:16 PM
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
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<html>
    <head>
        <title>Wicroft</title>
         
   </head>
    <body>
    
 <%         if(session.getAttribute("currentUser")==null){
                response.sendRedirect("login.jsp");
            }else{

                String uname = (String)session.getAttribute("currentUser");
                Session mySessn = initilizeServer.getUserNameToSessionMap().get(uname);
                  if(mySessn == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{


                DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
                Date date = new Date();
                if(mySessn.getCurrentAction().equalsIgnoreCase("changeApSettings")){

                    if(mySessn.getChangeApSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Change Accesspoint</h5><h4> Total clients selected : "+mySessn.getChangeApSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Change Accesspoint </h5><h4> <b>No Clients selected</b></h4>"+
"                       </div>");
                    }


                }else if(mySessn.getCurrentAction().equalsIgnoreCase("sendControlFile")){

                    if(mySessn.getSendCtrlFileSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Send Control File </h5><h4> Total clients selected : "+mySessn.getSendCtrlFileSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Send Control File  </h5><h4> <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else if(mySessn.getCurrentAction().equalsIgnoreCase("startExperiment")){

                    if(mySessn.getStartExpSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Start Experiment </h5><h4> Total clients selected : "+mySessn.getStartExpSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Start Experiment </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }


                }else if(mySessn.getCurrentAction().equalsIgnoreCase("wakeUpTimer")){

                    if(mySessn.getWakeUpTimerSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>WakeUp Timer </h5><h4> Total clients selected : "+mySessn.getWakeUpTimerSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>WakeUp Timer </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else if(mySessn.getCurrentAction().equalsIgnoreCase("appUpdate")){
                    
                    if(mySessn.getAppUpdateSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Wicroft App Update </h5><h4> Total clients selected : "+mySessn.getAppUpdateSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Wicroft App Update </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else if(mySessn.getCurrentAction().equalsIgnoreCase("ReqLogFiles")){
       
                    if(mySessn.getRequestLogFileSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Request Log Files </h5><h4>  Total clients selected : "+mySessn.getRequestLogFileSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Request Log Files  </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else if(mySessn.getCurrentAction().equalsIgnoreCase("reUseControlFile")){

                    if(mySessn.getSendCtrlFileSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Sent Existing Control File </h5><h4>  Total clients selected : "+mySessn.getSendCtrlFileSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\"></a>\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Sent Existing Control File   </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else{

                }

                out.write("<div class=\"alert alert-success alert-dismissable\">\n<h5>Server Time </h5><b><h4>"+ dateFormat.format(date) +"</b></h4></div>");


            }}

 %>

    </body>
</html>