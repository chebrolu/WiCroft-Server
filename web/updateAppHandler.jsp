<%-- 
    Document   : updateAppHandler
    Created on : 29 Jan, 2017, 12:51:59 PM
    Author     : cse
//updateAppClients
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
        <title>CrowdSource</title>
        <link rel="stylesheet" href="/serverplus/css/table.css">    </head>
    <body>

        <!--<br/><a href='getPendingLogFiles.jsp'>Back</a><br/><br/>-->
        <%
            
            
                     
        if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
//            response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            Utils.sendAppUpdateRequest(mySession);
            response.sendRedirect("updateAppStatus.jsp");
        }}

//            Constants.currentSession.getUpdateAppClients().clear();
//            String name[] = request.getParameterValues("selected");
//            for (String cl : name) { // 1_macAddress form
//                if(cl!=null && !cl.equalsIgnoreCase("") && cl.trim().length()>0){
//                    DeviceInfo device = Constants.currentSession.getConnectedClients().get(cl);
//                    if(device == null){
//                        Constants.currentSession.getUpdateAppClients().put(cl,"Not Connected");
//                    }else{
//                        Constants.currentSession.getUpdateAppClients().put(cl,"");
//                    }
//                }                
//            }
            
            /*          

            int requestCount = 0;
            if (request.getParameter("fetchLogFile") != null) {
                requestCount = Utils.getClientListForLogRequest(Constants.currentSession.getCurrentExperimentId());
            }

            int expId = Constants.currentSession.getCurrentExperimentId();
            ResultSet rs = DBManager.getLogFileRequestStatus(expId);
            int fileReceived = DBManager.getLogFileReceivedCount(expId);

            int getLogSuccess = 0;
            int getLogFailed = 0;
            int getLogPending = 0;

            if (rs != null) {
                while (rs.next()) {
                    out.write("\n->" + rs.getString(1) + "" + rs.getString(2));
                    if (rs.getString(1).equals("1")) {
                        getLogSuccess = Integer.parseInt(rs.getString(2));
                    } else if (rs.getString(1).equals("2")) {
                        getLogFailed = Integer.parseInt(rs.getString(2));
                    }
                }
            }

            getLogPending = requestCount - getLogSuccess - getLogFailed;

            getLogPending = (getLogPending < 0) ? 0 : getLogPending;

            out.write(
                    "<br/><br/>Fetch Log File Req Success</td><td>" + getLogSuccess + " ");
            out.write(
                    "<br/><br/>Fetch Log File Req Failed</td><td>" + getLogFailed + " ");
            out.write(
                    "<br/><br/><td>Fetch Log File Req Pending</td><td>" + getLogPending + " <br/><br/>");
            int expOver = DBManager.getExperimentOverCount(expId);

            if (fileReceived == expOver && expOver != 0) {

                out.write("<br/><br/><form action='experimentOver.jsp' method='post'>");
                out.write("<tr><td><input type='submit' name='stopExp' value='Stop Experiment'></td><td>All Requested Log FIle received</td</tr>");
                out.write("</form>");

            }
            out.write(
                    "<br/>Duration :" + request.getParameter("duration"));
            out.write(
                    "<br/>No. Of Clients : " + request.getParameter("numclients"));
            
            
             */
       

        

        %>
    </body>
</html>
