<%-- 
    Document   : viewSelectedClients
    Created on : 9 Jun, 2017, 12:41:16 PM
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
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<html>
    <head>
        <Title>Just A Time</Title>
         
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

                /*
                long time = (mySession.getWakeUpDuration()) - ((System.currentTimeMillis()) -mySession.getStartwakeUpDuration()) / 1000;
                long t = time;
                long hour = 0, min = 0, sec = 0;
                if (time >= 3600) {
                    hour = time / 3600;
                    time = time % 3600;
                }
                if (time >= 60) {
                    min = time / 60;
                    time = time % 60;
                }
                sec = time;

                if (t > 0) {

                    out.write("<div class=\"alert alert-success alert-dismissable\">\n" +
"                    <div class=\"row\">\n" +
"                        <div class=\"col-xs-3\">\n" +
"                            <i class=\"fa fa-clock-o fa-5x\"></i>\n" +
"                        </div>\n" +
"                        <div class=\"col-xs-9 text-right\">\n" +
"                            <div class=\"huge\">"+hour+"h &nbsp;"+min+"m&nbsp; "+sec+"s </div>\n" +
"                            <div>Current Wake Up Timer</div>\n" +
"                        </div>\n" +
"                    </div>\n" +
"                    </div></div>");
                  


                }else{
                // timer expired

                    out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +
"                    <div class=\"row\">\n" +
"                        <div class=\"col-xs-3\">\n" +
"                            <i class=\"fa fa-clock-o fa-5x\"></i>\n" +
"                        </div>\n" +
"                        <div class=\"col-xs-9 text-right\">\n" +
"                            <div>Timer Expired!!!</div>\n" +
"                        </div>\n" +
"                    </div>\n" +
"                    </div></div>");

                }
                */

                DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss dd/MM/yyyy");
                Date date = new Date();
              //  System.out.println(dateFormat.format(date)); //2016/11/16 12:08:43

                


              //  System.out.println("WWW ["+mySessn.getCurrentAction()+"]");
                if(mySessn.getCurrentAction().equalsIgnoreCase("changeApSettings")){
                    //out.write("changeApSettings:"+mySessn.getChangeApSelectedClients().size());\

                    if(mySessn.getChangeApSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Change Accesspoint</h5><h4> Total clients selected : "+mySessn.getChangeApSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Change Accesspoint </h5><h4> <b>No Clients selected</b></h4>"+
"                       </div>");
                    }


                }else if(mySessn.getCurrentAction().equalsIgnoreCase("sendControlFile")){
                  //  out.write(mySessn.getSendCtrlFileSelectedClients().size());      

                    if(mySessn.getSendCtrlFileSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Send Control File </h5><h4> Total clients selected : "+mySessn.getSendCtrlFileSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Send Control File  </h5><h4> <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else if(mySessn.getCurrentAction().equalsIgnoreCase("startExperiment")){
                    //out.write(mySessn.getStartExpSelectedClients().size());                


                    if(mySessn.getStartExpSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Start Experiment </h5><h4> Total clients selected : "+mySessn.getStartExpSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Start Experiment </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }


                }else if(mySessn.getCurrentAction().equalsIgnoreCase("wakeUpTimer")){
                    //out.write(mySessn.getWakeUpTimerSelectedClients().size());                


                    if(mySessn.getWakeUpTimerSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>WakeUp Timer </h5><h4> Total clients selected : "+mySessn.getWakeUpTimerSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>WakeUp Timer </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }



                }else if(mySessn.getCurrentAction().equalsIgnoreCase("appUpdate")){
                    //out.write(mySessn.getAppUpdateSelectedClients().size());                
                    
                    if(mySessn.getAppUpdateSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Wicroft App Update </h5><h4> Total clients selected : "+mySessn.getAppUpdateSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Wicroft App Update </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }




                }else if(mySessn.getCurrentAction().equalsIgnoreCase("ReqLogFiles")){
                    //out.write(mySessn.getRequestLogFileSelectedClients().size());                
       
                    if(mySessn.getRequestLogFileSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Request Log Files </h5><h4>  Total clients selected : "+mySessn.getRequestLogFileSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Request Log Files  </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else if(mySessn.getCurrentAction().equalsIgnoreCase("reUseControlFile")){
                 //   out.write(mySessn.getSendOldCtrlFileSelectedClients().size());                

                    if(mySessn.getSendCtrlFileSelectedClients().size() > 0){
                        out.write("<div class=\"alert alert-success alert-dismissable\">\n" +

"                        <h5>Sent Existing Control File </h5><h4>  Total clients selected : "+mySessn.getSendCtrlFileSelectedClients().size()+" </h4><a href=\"#\" class=\"alert-link\">View Clients</a>.\n" +
"                       </div>");
                    }else{
                        out.write("<div class=\"alert alert-danger alert-dismissable\">\n" +

"                       <h5>Sent Existing Control File   </h5><h4>  <b>No Clients selected</b></h4>"+
"                       </div>");
                    }

                }else{
                    //out.write("RATHEESH");
                    

                }

                out.write("<div class=\"alert alert-info alert-dismissable\">\n<h5>Server Time </h5><b><h4>"+ dateFormat.format(date) +"</b></h4></div>");

                    /*
                        long time = (mySession.getWakeUpDuration()) - ((System.currentTimeMillis()) - mySession.getStartwakeUpDuration()) / 1000;
                        long t = time;
                        //                    out.write("<br>"+time+"<br>")

                        long hour = 0, min = 0, sec = 0;
                        if (time >= 3600) {
                            hour = time / 3600;
                            time = time % 3600;
                        }

                        if (time >= 60) {
                            min = time / 60;
                            time = time % 60;
                        }

                        sec = time;
                        System.out.println("TIMER : "+t);
                        if(t>0){
                        out.write("<div class=\"alert alert-info alert-dismissable\">\n<h5>Timer </h5><b><h4>"+ dateFormat.format(date) +"</b></h4></div>");
                        }else{
                        out.write("<div class=\"alert alert-info alert-dismissable\">\n<h5>No Time </h5><b><h4>"+ dateFormat.format(date) +"</b></h4></div>");
                        }
                    */

            }}

 %>



    </body>
</html>