<%-- 
    Document   : experimentDeviceInformation
    Created on : 9 Oct, 2016, 4:03:02 PM
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
            //response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
                String username = (String)session.getAttribute("currentUser");
                Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
                
                  if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
                String expid = request.getParameter("expid");
                
            %>







            <div id="page-wrapper">

                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">
                            <%
                                String macAddress = request.getParameter("macAddr");
                                String expId = request.getParameter("expId");
                                out.write("<h2 class='heading'>Client Details</h2>");
                                out.write("<h4 class='heading'>Experiment No. : " + expId + "</h4><br/><br/>");
                            %>
                        </h1>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>

                <div class="row">

                    <br>

                    <%
//                        out.write("<h4 class='heading'>MacAddress : " + macAddress + "</h4><br/><br/>");
                        ResultSet rs = DBManager.getExperimentDetails(expId, username, macAddress);

                        if (rs != null) {
                            while (rs.next()) {

                    %>


                    <div class="col-lg-6">
                        <div class="panel panel-green">
                            <div class="panel-heading">
                                Client Connection Details
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>IP Address</th>
                                                <th>Port</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>     
                                                <th>RSSI</th>                                                
                                                <th>Link Speed</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%                                          
                                                  out.write("<tr><td>" + rs.getString(1) + "</td><td>" + rs.getString(2) + "</td><td>" + rs.getString(3) + "</td>"
                                                        + "<td>" + rs.getString(4) + "</td><td>" + rs.getString(5) + "</td><td>" + rs.getString(6) + "</td></tr>");
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
                </div>
                <!--end Row -->




                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                Device Details
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>Mac Address</th>
                                                <th>Storage Space</th>
                                                <th>Memory</th>
                                                <th>No. of Cores</th>
                                                <th>Processor Speed</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                out.write("<tr><td>" + macAddress + "</td><td>" + rs.getString(7) + "</td><td>" + rs.getString(8) + "</td><td>" + rs.getString(9) + "</td><td>" + rs.getString(10) + "</td></tr>");

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
                </div>
                <!--end Row -->


                <%   }
                } else {

                %>

                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">Forms</h1>
                    </div>
                </div>
                <%     }

                %>







            </div>

            <%
              }  }
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

<!--      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>-->


    </body>

</html>
