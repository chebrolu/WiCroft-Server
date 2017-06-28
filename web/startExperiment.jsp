<%-- 
    Document   : startExperiment
    Created on : 22 Jul, 2016, 5:59:41 PM
    Author     : cse
--%>

<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="java.util.concurrent.CopyOnWriteArrayList"%>
<%@page import="com.iitb.cse.*"%>
<%@page import="com.mysql.jdbc.Util"%>
<%@page import="org.eclipse.jdt.internal.compiler.impl.Constant"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.Constants"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>



<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">

        <title>CrowdSource-ServerHandler</title>

        <!-- Bootstrap Core CSS -->
        <link href="/serverplus/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="/serverplus/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="/serverplus/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Morris Charts CSS -->
        <link href="/serverplus/vendor/morrisjs/morris.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="/serverplus/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>


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
            int expNumber = Integer.parseInt(request.getParameter("expNumber"));
            String expName  = request.getParameter("expName");
            String expLoc = request.getParameter("expLoc");
            String expDesc = request.getParameter("expDesc");
            
            int nbrClientsPerRound = Integer.parseInt(request.getParameter("expnbrClientsPerRound"));
            int roundDuration = Integer.parseInt(request.getParameter("exproundDuration"));
            int expAckWaitTime = Integer.parseInt(request.getParameter("expAckWaitTime"));
            int expRetryStartTime = Integer.parseInt(request.getParameter("expRetryStartTime"));
            int expTimeOut = Integer.parseInt(request.getParameter("expTimeOut"));
            String logBgTraffic = request.getParameter("logBgTraffic");

            String [] fields  =  request.getParameter("expfileIdName").split("#");
            int expFileId = Integer.parseInt(fields[0]);
            String expFileName = fields[1];
            int clientCount = mySession.getStartExpSelectedClients().size();
            Experiment exp = new Experiment(DBManager.getUserId(username),expNumber,expName,expLoc,expDesc,expFileId,expFileName,1);
            DBManager.startExperiment(exp);

//          DBManager.stopExperiment(username, expNumber);

            Utils.startNewExperiment(expNumber, expName, expLoc, expDesc, expFileId, expFileName, nbrClientsPerRound, roundDuration,  expAckWaitTime, expRetryStartTime, expTimeOut, logBgTraffic, username, mySession, clientCount);


           response.sendRedirect("experimentStatus.jsp");
            

            
        }
        }
        %>
    </body>
</html>
