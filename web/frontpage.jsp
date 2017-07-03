
<%-- 
    Document   : experimentDetails
    Created on : 23 Jul, 2016, 10:53:25 AM
    Author     : ratheeshkv
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

        <title>Wicroft</title>

        <!-- Bootstrap Core CSS -->
        <link href="/wicroft/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="/wicroft/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="/wicroft/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Morris Charts CSS -->
        <link href="/wicroft/vendor/morrisjs/morris.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="/wicroft/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>
        <div id="wrapper">
            <!-- Navigation -->
            <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="frontpage.jsp">Wicroft Server</a>
                </div>
                <!-- /.navbar-header -->

                <ul class="nav navbar-top-links navbar-right">

                    <!-- /.dropdown -->
                    <li class="dropdown">

                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <%= session.getAttribute("currentUser") %>
                            <i class="fa fa-user fa-fw"></i> <i class="fa fa-caret-down"></i>
                        </a>
                        <ul class="dropdown-menu dropdown-user">

                            <li class="divider"></li>
                            <li>

                                <a href="logout.jsp?logout=logout"><i class="fa fa-sign-out fa-fw"></i> Logout</a>
                            </li>
                        </ul>
                        <!-- /.dropdown-user -->
                    </li>
                    <!-- /.dropdown -->
                </ul>
                <!-- /.navbar-top-links -->

               
                <!-- /.navbar-static-side -->
                 <div id="links" class="navbar-default sidebar" role="navigation">
                
                <div class="sidebar-nav navbar-collapse">
                        <ul class="nav" id="side-menu">
                            
                            <li>
                                <a href="frontpage.jsp"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                            </li>
                            
                            <li>
                                <a href="configExperiment.jsp"><i class="fa fa-dashboard fa-fw"></i> Experiment Configuration</a>
                            </li>
                            
                            <li>
                                <a href="experimentDetails.jsp"><i class="fa fa-table fa-fw"></i> Experiment History</a>
                            </li>
                            
                            <li>
                                <a href="utilities.jsp"><i class="fa fa-dashboard fa-fw"></i> Utilities</a>
                            </li>
                            
                            <li>
                                <a href="details.jsp"><i class="fa fa-dashboard fa-fw"></i> Details</a>
                            </li>
                            
                            <li>
                                <a href="settings.jsp"><i class="fa fa-dashboard fa-fw"></i> Settings</a>
                            </li>

                        </ul>
                    </div>
                    </div>

            </nav>

        <%
            
            
        if(session.getAttribute("currentUser")==null){
            response.sendRedirect("login.jsp");
        }else{
            response.setIntHeader("refresh", 3); // refresh in every 5 seconds
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
//            Utils.getSelectedConnectedClients(mySession);
            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);

            
            DateFormat dateFormat = new SimpleDateFormat("HH:mm:ss");
            Date date = new Date();
            
         
            
        %>

        

           

            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <h2 class="page-header">Dashboard &emsp;
                            <a href="handleEvents.jsp?event=clearlist" class='btn btn-default' style="background-color: #e74c3c ;color: white;border-color:#e74c3c">Clear Client List</a>
                            </h2>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!-- /.row -->
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-xs-3">
                                        <i class="fa fa-sitemap fa-5x"></i>

                                    </div>
                                    <div class="col-xs-9 text-right">
                                        <div class="huge"><%=mySession.getSelectedConnectedClients().size()%></div>
                                        <div>Total Clients</div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                    
                                    <div class="clearfix"></div>
                                </div>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="panel panel-green">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-xs-3">
                                        <i class="fa  fa-chevron-up  fa-5x"></i>
                                    </div>
                                    <div class="col-xs-9 text-right">
                                        <div class="huge"><%=activeClient.size()%></div>
                                        <div>Active Clients</div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                    
                                    <div class="clearfix"></div>
                                </div>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="panel panel-red">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-xs-3">
                                        <i class="fa fa-chevron-down fa-5x"></i>
                                    </div>
                                    <div class="col-xs-9 text-right">
                                        <div class="huge"><%=(mySession.getSelectedConnectedClients().size() - activeClient.size())%></div>
                                        <div>Passive Clients!</div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                    
                                    <div class="clearfix"></div>
                                </div>
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <div class="row">
                                 <!--    <div class="col-xs-3">
                                        <i class="fa fa-clock-o fa-5x"></i>
                                    </div> -->
                                    <div class="col-xs-9 text-right">
                                        <div class="huge"><b><%=(dateFormat.format(date))%></b></div>
                                        <div>Server Time</div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                    
                                    <div class="clearfix"></div>
                                </div>
                            </a>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="col-lg-8">
                        <div class="panel panel-primary">
                            <div class="panel-heading ">
                                <b> AccessPoint Information </b>
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped" style="overflow: auto;width: 100%; height:150px;display: block" >
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>No.of Clients</th>
                                                <th style="color: green">#Active</th>
                                                <th style="color: red">#Passive</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                ConcurrentHashMap<String, String> apConnection = Utils.getAccessPointConnectionDetails(mySession);
                                                Enumeration detail = apConnection.keys();
                                                boolean flag = false;
                                                int count = 0;
                                                while (detail.hasMoreElements()) {
                                                    flag = true;
                                                    count++;
                                                    String bssid = (String) detail.nextElement();
                                                    String ssid_count = apConnection.get(bssid);
                                                    String info[] = ssid_count.split("#");
                                                    out.write("<tr><td>" + count + "</td><td>" + bssid + "</td><td>" + info[0] + "</td><td>" + info[1] + "</td><td>" + info[2] + "</td><td>" + info[3] + "</td></tr>");

                                                }

                                                if (!flag) {
                                                    out.write("<tr><td colspan='6' >No Clients!!!</td></tr>");
                                                }

                                            %>              

                                        </tbody>
                                    </table>
                                </div>
                                <!-- /.table-responsive -->
                            </div>
                            <!-- /.panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>


                    <%

                        long time = (mySession.getWakeUpDuration()) - ((System.currentTimeMillis()) - mySession.getStartwakeUpDuration()) / 1000;
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
                    %>


                    <div class="col-lg-3 col-md-6">
                        <div class="panel panel-danger">
                            <div class="panel-heading">
                                <div class="row">
                                    <div class="col-xs-3">
                                        <i class="fa fa-clock-o fa-5x"></i>
                                    </div>
                                    <div class="col-xs-9 text-right">
                                        <!-- <div style="font-size: 30px;padding-top:8px;"><b><%=hour%>h &nbsp;<%=min%>m&nbsp; <%=sec%>s </b></div> -->
                                        <div style="font-size: 30px;padding-top:8px;"><b><%=hour%>:<%=min%>:<%=sec%></b></div><br>

                                        <div><b>Wake Up Timer</b></div>
                                    </div>
                                </div>
                            </div>
                            <a href="#">
                                <div class="panel-footer">
                                    <div class="clearfix"></div>
                                </div>
                            </a>
                        </div>
                    </div>              

                    <%  }else{

                            mySession.setWakeUpTimerRunning(false);

                    %>

                    <%
                        }
                    %>

                </div>
                <!--end Row -->

                <br>







                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <b> Clients Information</b>
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <!-- <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example"> -->
                                <table width="100%" class="table table-striped  table-hover" style="overflow: auto;width: 100%; height:225px;display: block">                                

                                    <thead>

                                        <tr>
                                            <th>#</th>
                                            <th>Mac Address</th>
                                            <th>IP Address</th>
                                            <th>SSID</th>
                                            <th>BSSID</th>
                                            <th>Latest HearBeat</th>
                                            <th>Connection Status</th>
                                            <th>Running in Foreground</th>

                                        </tr>
                                    </thead>


                                    <tbody>

                                        <%  ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
                                            

                                            boolean flag1 = false;

                                            if (clients != null) {
                                                Enumeration<String> macList = clients.keys();

                                                int index = 0;
                                                while (macList.hasMoreElements()) {
                                                    flag1 = true;
                                                    String macAddr = macList.nextElement();
                                                    DeviceInfo device = clients.get(macAddr);
                                                    index++;

                                                    if (activeClient != null && activeClient.contains(device)) {
                                                        out.write("<tr><td>" + index + "</td><td><a href=deviceInformation.jsp?macAddr=" + macAddr + ">" + macAddr + "</a></td><td>" + device.getIp() + "</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td><td><b style='color:green'>Active</b></td><td>" +  (device.isInForeground()?"<b style='color:blue'>True</b>":"<b>False</b>")  + "</td></tr>");
                                                    } else {
                                                        out.write("<tr><td>" + index + "</td><td><a href=deviceInformation.jsp?macAddr=" + macAddr + ">" + macAddr + "</a></td><td>" + device.getIp() + "</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td><td><b style='color:red'>Passive</b></td><td>" + (device.isInForeground()?"<b style='color:blue'>True</b>":"<b>False</b>") + "</td></tr>");
                                                    }
                                                    
                                                }
                                                if (!flag1) {
                                                    out.write("<tr><td colspan='8' >No Clients!!!</td></tr>");
                                                }
                                            }
                                        %>   

                                    </tbody>
                                </table>
                                <!-- /.table-responsive -->

                            </div>
                            <!-- /.panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!--end Row -->

            </div>
            <%

               if( initilizeServer.getAllBssidInfo().size() > 0 && mySession.getSelectedBssidInfo().size() == 0){
                out.write("<script type=\"text/javascript\">\n" +
    "            alert(\"New Clients Connected, go to Setting->Dashboard Setting To select BSSID\");\n" +
    "        </script>");
                }

            }
            }
            %>
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->

        <!-- jQuery -->
        <script src="/wicroft/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="/wicroft/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="/wicroft/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Morris Charts JavaScript -->
        <script src="/wicroft/vendor/raphael/raphael.min.js"></script>
        <script src="/wicroft/vendor/morrisjs/morris.min.js"></script>
        <script src="/wicroft/data/morris-data.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/wicroft/dist/js/sb-admin-2.js"></script>
        <!-- DataTables JavaScript -->
        <script src="/wicroft/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="/wicroft/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="/wicroft/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/wicroft/dist/js/sb-admin-2.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script>
            $(document).ready(function () {
                $('#dataTables-example').DataTable({
                    responsive: true
                });
            });
        </script>
<!-- 
      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>
    -->

    </body>

</html>


