<%-- 
    Document   : getLogFilesReqStatus
    Created on : 7 Sep, 2016, 3:28:40 PM
    Author     : ratheeshkv
--%>


<%@page import="java.sql.ResultSet"%>
<%@page import="com.iitb.cse.DBManager"%>
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

        <script>
            function selectCheckBox() {
                if (document.getElementById("choose").checked == true) {
                    var list = document.getElementsByName("selected");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = true;
                    }
                } else {
                    var list = document.getElementsByName("selected");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = false;
                    }
                }
            }

            function checkField() {
                count = 0;
                var list = document.getElementsByName("selected");
                for (var i = 0; i < list.length; i++) {
                    if (list[i].checked == true) {
                        count++;
                    }
                }

                if (count === 0) {
                    alert("No client selected");
                    return false;
                }
                return true;

            }

        </script>

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
                    CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
                    if(mySession.isReqLogFileRunning()){
                        response.setIntHeader("refresh", 5); // refresh in every 5 seconds
                }
            
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
            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <h3 class="page-header">Log Request Status &emsp; <button  class="btn btn-danger
                        " onclick="self.close()">Exit Page</button></h3>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>

                <form  role="form" action='getLogFiles.jsp' method='get'  onsubmit='return checkField(this);'>

                <%
                    if(!mySession.isReqLogFileRunning()){
                %>  

                <div class="col-lg-6">
                        <br><br>
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Log Request Retry 
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">


                            <table>
                                <tr><td>No. of requests per round</td><td>&emsp;:&emsp;</td><td><input  class="form-control" type="number" min='1' max='10000' value='5' id='numclients' name='reqLogNumClients'/></td></tr>
                                <tr><td>&emsp;</td><td></td></tr>
                                <tr><td>Duration between rounds</td><td>&emsp;:&emsp;</td><td><input  class="form-control" type="number" min='1' max='10000' value='10' id='duration' name='reqLogDuration'/></td></tr>
                                <tr><td>&emsp;</td><td></td></tr>
                                <tr><td><td></td></td><td><input type='submit' class='btn btn-danger' value='Retry Log Request' ></td></tr>
                            </table>

                            </div>
                            <!-- .panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>
                    
                    <%
                        }
                    %>


                <!-- /.row -->
                
                <input type="hidden" name="retryLogFile" value="true" />

                    <div class="row">
                        <div class="col-lg-12"><br><br><br>
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <b> Selected Clients Information</b>&emsp;&emsp;

                                    
                                </div>
                                <!-- /.panel-heading -->
                                <div class="panel-body">
                                    <table width="100%" class="table table-striped table-bordered table-hover">

                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Select <input id="choose"  checked type="checkbox" name='test' onchange="selectCheckBox(this);
                                                                  "></th>
                                                <th>Mac Address</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>Connection</th>
                                                 <th>Status</th>
                                                <th>Files Received</th>

                                            </tr>
                                        </thead>
                                        <tbody>

                <%
                  int count = 0;
                  for(int i=0;i<mySession.getRequestLogFileSelectedClients().size();i++){
                        String macAddr = mySession.getRequestLogFileSelectedClients().get(i);
                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddr);
                        count += 1;
                          if (activeClient.contains(device)) {
                          out.write("<tr><td>" + count + "</td><td><input type='checkbox' name='selected' value='" + macAddr + "'></td><td>" + macAddr + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td><b style='color:green'>Active</b></td><td>" + (mySession.getRequestLogFileFilteredClients().get(macAddr)==null?"-no info-":mySession.getRequestLogFileFilteredClients().get(macAddr)) + "</td><td>"+(device.getDetails()==""?"-no info-":device.getDetails())+"</td></tr>");

                            } else {
                            out.write("<tr><td>" + count + "</td><td><input type='checkbox' name='selected' value='" + macAddr + "'></td><td>" + macAddr + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td><b style='color:red'>Passive</b></td><td>" + (mySession.getRequestLogFileFilteredClients().get(macAddr)==null?"-no info-":mySession.getRequestLogFileFilteredClients().get(macAddr)) + "</td><td>"+(device.getDetails()==""?"-no info-":device.getDetails())+"</td></tr>");

                       }
                  }

                                            %>   
                                        </tbody>
                                    </table>

                                </div>
                                <!-- /.panel-body -->
                            </div>
                            <!-- /.panel -->
                        </div>
                        <!-- /.col-lg-12 -->
                    </div>

                </form>




                <!-- /.table-responsive -->

            </div>
            <!-- /.panel-body -->

        </div>


             <%
                        }}
                    %>





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

        <script>


        </script>

<!--      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>-->



    </body>

</html>