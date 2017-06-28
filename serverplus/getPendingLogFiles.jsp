
<%@page import="java.sql.ResultSet"%>
<%@page import="com.iitb.cse.DBManager"%>
<%-- 
    Document   : getPendingLogFiles
    Created on : 29 Jul, 2016, 3:25:54 PM
    Author     : ratheeshkv
--%>


<%@page import="com.sun.java.swing.plaf.windows.resources.windows"%>
<%@page import="java.util.concurrent.CopyOnWriteArrayList"%>
<%@page import="com.iitb.cse.Utils"%>
<%@page import="com.mysql.jdbc.Util"%>
<%@page import="org.eclipse.jdt.internal.compiler.impl.Constant"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.iitb.cse.DeviceInfo"%>
<%@page import="com.iitb.cse.Constants"%>
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
        <link href="/serverplus1/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

        <!-- MetisMenu CSS -->
        <link href="/serverplus1/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="/serverplus1/dist/css/sb-admin-2.css" rel="stylesheet">

        <!-- Morris Charts CSS -->
        <link href="/serverplus1/vendor/morrisjs/morris.css" rel="stylesheet">

        <!-- Custom Fonts -->
        <link href="/serverplus1/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

        <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
            <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
            <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
        <![endif]-->

    </head>

    <body>

        <%
//            response.setIntHeader("refresh", 5); // refresh in every 5 seconds
        %>

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
                    <a class="navbar-brand" href="frontpage.jsp">CrowdSource Application - SERVER</a>
                </div>
                <!-- /.navbar-header -->

                <ul class="nav navbar-top-links navbar-right">

                    <!-- /.dropdown -->
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
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

                <div class="navbar-default sidebar" role="navigation">
                    <div class="sidebar-nav navbar-collapse">
                        <ul class="nav" id="side-menu">

                            <li>
                                <a href="frontpage.jsp"><i class="fa fa-dashboard fa-fw"></i> Dashboard</a>
                            </li>


                            <li>
                                <a href="addExperiment.jsp"><i class="fa fa-table fa-fw"></i> Add Experiment</a>
                            </li>

                            <li>
                                <a href="experimentDetails.jsp"><i class="fa fa-table fa-fw"></i> Experiment Details</a>
                            </li>

                            <li>
                                <a href="apchange.jsp"><i class="fa fa-table fa-fw"></i> Change AccessPoint</a>
                            </li>
                            <li>
                                <a href="getPendingLogFiles.jsp"><i class="fa fa-table fa-fw"></i> Request Log Files</a> 
                            </li>

                                                       <!--
                            <li>
                                <a href="configParameters.jsp"><i class="fa fa-table fa-fw"></i> Configure</a> 
                            </li>
                            -->



                        </ul>
                    </div>
                    <!-- /.sidebar-collapse -->
                </div>
                <!-- /.navbar-static-side -->
            </nav>


            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">Request Log File</h1>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>






                <%
                    //            response.setIntHeader("refresh", 5);
                    if (request.getParameter("getLogFile") != null && request.getParameter("getLogFile").equalsIgnoreCase("getLogFile")) {
                        Constants.currentSession.setFetchingLogFiles(false);
                    }

                    //            Constants.currentSession.setFetchingLogFiles(false);
                    if (Constants.currentSession.isFetchingLogFiles()) {
                        response.sendRedirect("getLogFilesReqStatus.jsp");
                    } else {

                %>


                <form  role="form" action='getLogFiles.jsp' method='post'  onsubmit='return checkFields(this);'>
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="panel panel-default">
                                <div class="panel-heading">

                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-lg-6">


                                            <div class="form-group">
                                                <label>Number of Log Requests Per Round<b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" value='1' id='numclients' name='numclients'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>
                                            <div class="form-group">
                                                <label>Duration between Rounds<i>(in seconds)</i><b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" value='10' id='duration' name='duration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>

                                            <div class="form-group">
                                                <input type='submit' class='btn btn-default' name='getLogFiles' value='Get Log Files' onclick='return checkFields();' >                                                    
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /.row (nested) -->
                                </div>
                                <!-- /.panel-body -->
                            </div>
                            <!-- /.panel -->
                        </div>
                        <!-- /.col-lg-12 -->
                    </div>
                    <!-- /.row -->


                    <div class="row">
                        <div class="col-lg-12">
                            <div class="panel panel-default">
                                <div class="panel-heading">
                                    <b> Connected Clients Information</b>
                                </div>
                                <!-- /.panel-heading -->
                                <div class="panel-body">
                                    <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">

                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Select</th>
                                                <th>Mac Address</th>
                                                <th>SSID</th>
                                                <th>BSSID</th>

                                            </tr>
                                        </thead>
                                        <tbody>


                                            <%                                            ResultSet rs = DBManager.getPendingLogFileList();
                                                int count = 0;

                                                if (rs != null) {
                                                    while (rs.next()) {
                                                        DeviceInfo device = Constants.currentSession.getConnectedClients().get(rs.getString(1));
                                                        if (device != null) {
                                                            count++;

                                                            out.write("<tr><td>" + count + "</td><td><input type='checkbox' name='selected' value='" + "1" + "_" + rs.getString(1) + "'checked/>");
                                                            out.write("</td><td>" + rs.getString(1) + "</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><tr>");

                                                        }
                                                    }
                                                }

                                                if (count == 0) {
                                                    out.write("<tr><td colspan='5'>No Active Clients !!!</td></tr>");
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
                </form>

                <%                    }
                %>




                <!-- /.table-responsive -->

            </div>
            <!-- /.panel-body -->

        </div>
        <!-- /#wrapper -->

        <!-- jQuery -->
        <script src="/serverplus1/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="/serverplus1/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="/serverplus1/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Morris Charts JavaScript -->
        <script src="/serverplus1/vendor/raphael/raphael.min.js"></script>
        <script src="/serverplus1/vendor/morrisjs/morris.min.js"></script>
        <script src="/serverplus1/data/morris-data.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus1/dist/js/sb-admin-2.js"></script>
        <!-- DataTables JavaScript -->
        <script src="/serverplus1/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="/serverplus1/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="/serverplus1/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus1/dist/js/sb-admin-2.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script>
                                                    $(document).ready(function () {
                                                        $('#dataTables-example').DataTable({
                                                            responsive: true
                                                        });
                                                    });
        </script>

        <script>

            function checkFields() {


                if (document.getElementById('numclients').value.match(/^\s+$/i) || document.getElementById('numclients').value == "" || document.getElementById('numclients').value == null) {
                    alert("Number of clients cannot be empty");
                    return false;
                } else if (document.getElementById('duration').value.match(/^\s+$/i) || document.getElementById('duration').value == "" || document.getElementById('duration').value == null) {
                    alert("Duration cannot be empty");
                    return false;
                }

                if (!document.getElementById('numclients').value.match(/^[0-9]+$/i)) {
                    alert("Number of clients : Integer Expected");
                    return false;
                }

                if (!document.getElementById('duration').value.match(/^[0-9]+$/i)) {
                    alert("Duration : Integer Expected");
                    return false;
                }

                var inputElems = document.getElementsByTagName("input"),
                        count = 0;

                for (var i = 0; i < inputElems.length; i++) {
                    if (inputElems[i].type == "checkbox" && inputElems[i].checked == true) {
                        count++;
                    }
                }

                if (count == 0) {
                    alert("No clients selected-");
                    return false;
                }



                if (document.getElementsByName("selected").length <= 0) {
                    alert("No clients selected");
                    return false;
                } else {
                    return true;
                }


            }

        </script>

    </body>

</html>