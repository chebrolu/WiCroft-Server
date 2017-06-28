<%-- 
    Document   : experimentStatus
    Created on : 28 Jul, 2016, 5:29:38 PM
    Author     : cse
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

                
                <!-- /.navbar-static-side -->
                
                 <div id="links" class="navbar-default sidebar" role="navigation">
                </div>
            </nav>


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
                          response.setIntHeader("refresh", 3);
                %>

                <div id="page-wrapper">
                    <div class="row">
                        <div class="col-lg-12">
                            <h1 class="page-header">Experiment Status</h1>
                        </div>
                    </div>

                <%
                    int expId = Integer.parseInt(mySession.getLastConductedExpId());
                    ResultSet rs = DBManager.getExpStartStatus(expId,username);
                  
                    int success = 0;
                    int failed = 0;
                    int pending = 0;

                    if (rs != null) {
                        while (rs.next()) {
                            //   out.write("\n->" + rs.getString(1) + "" + rs.getString(2));
                            if (rs.getString(1).equals("0")) {
                                pending = Integer.parseInt(rs.getString(2));
                            } else if (rs.getString(1).equals("1")) {
                                failed = Integer.parseInt(rs.getString(2));
                            } else if (rs.getString(1).equals("2")) {
                                success = Integer.parseInt(rs.getString(2));
                            }
                        }
                    }
                    int total = mySession.getStartExpSelectedClients().size();// pending + success + failed ;
                    pending =  total - success - failed;
                    int expOver = DBManager.getExperimentOverCount(expId,username);

                %>

            <div class="row">
                <div class="col-lg-6">
                    <div class="panel panel-info">
                        <div class="panel-heading">
                            
                            <% 
                out.write("<h3>Experiment No. " + expId + "</h3>");
                            %>
                        </div>
                    </div>
                </div>
            </div>

              
                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                               Experiment Status
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover">
                                        <tbody>
<%
out.write("<tr><td>Total Number of Clients Selected </td><td><a href='experimentSummary.jsp?reqType=total&expid="+expId+"'>" + total + "</a></td><td>&nbsp;</td><td>&nbsp;</td></tr>");
out.write("<td> Experiment Request Sending </td><td> Success &emsp;" + (success > 0 ? "<a href='experimentSummary.jsp?reqType=success&expid="+expId+"'>" + success + "</a>" : 0) + "&nbsp;</td>");
out.write("<td> Pending &emsp;" + (pending > 0 ? "<a href='experimentSummary.jsp?reqType=pending&expid="+expId+"'>" + pending + "</a>" : 0) + "&nbsp;</td>");
out.write("<td> Failed &emsp;" + (failed > 0 ? "<a href='experimentSummary.jsp?reqType=failed&expid="+expId+"'>" + failed + "</a>" : 0) + "&nbsp;</td></tr>");
out.write("<tr><td>Experiment Over </td><td>" + (expOver > 0 ? "<a href='experimentSummary.jsp?reqType=expOver&expid="+expId+"'>"+ expOver + "</a>" : 0) + "</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
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
 





                <%
                    if(mySession.isExperimentRunning()){
                %>


                <form role="form" action='experimentOver.jsp' method='post'>
                <div class="form-group">
                    <input type='submit' class='btn btn-default' name='stopExp' value='Stop Experiment'>
                </div>
                </form>



                <%
                    }
                %>


 


            </div>
            <%
                }}
            %>
            <!-- /#page-wrapper -->

        </div>
        <!-- /#wrapper -->

        <!-- jQuery -->
        <script src="/serverplus/vendor/jquery/jquery.min.js"></script>

        <!-- Bootstrap Core JavaScript -->
        <script src="/serverplus/vendor/bootstrap/js/bootstrap.min.js"></script>

        <!-- Metis Menu Plugin JavaScript -->
        <script src="/serverplus/vendor/metisMenu/metisMenu.min.js"></script>

        <!-- Morris Charts JavaScript -->
        <script src="/serverplus/vendor/raphael/raphael.min.js"></script>
        <script src="/serverplus/vendor/morrisjs/morris.min.js"></script>
        <script src="/serverplus/data/morris-data.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus/dist/js/sb-admin-2.js"></script>
        <!-- DataTables JavaScript -->
        <script src="/serverplus/vendor/datatables/js/jquery.dataTables.min.js"></script>
        <script src="/serverplus/vendor/datatables-plugins/dataTables.bootstrap.min.js"></script>
        <script src="/serverplus/vendor/datatables-responsive/dataTables.responsive.js"></script>

        <!-- Custom Theme JavaScript -->
        <script src="/serverplus/dist/js/sb-admin-2.js"></script>

        <!-- Page-Level Demo Scripts - Tables - Use for reference -->
        <script>
            $(document).ready(function () {
                $('#dataTables-example').DataTable({
                    responsive: true
                });
            });
        </script>

      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>


    </body>

</html>