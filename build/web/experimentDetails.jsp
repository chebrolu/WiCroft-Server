<%-- 
    Document   : experimentDetails
    Created on : 23 Jul, 2016, 10:53:25 AM
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
            //response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{

    %>


            <div id="page-wrapper">
                <div class="row">
                    <br/> 

                    <div class="col-lg-12">
                        <!-- /.panel-heading -->
                        <div class="panel-body form-group">
                                <table border="0" cellpadding ="1000" >
                                <tr>
                                    <th style="visibility: hidden;"> Color &nbsp;</th>
                                    <th style="visibility: hidden;">Exp Status</th><th style="visibility: hidden;"> Color &nbsp;</th>
                                    <th style="visibility: hidden;"> Color &nbsp;</th>
                                    <th style="visibility: hidden;">Exp Status</th><th style="visibility: hidden;"> Color &nbsp;</th>
                                    <th style="visibility: hidden;"> Color &nbsp;</th>
                                    <th style="visibility: hidden;">Exp Status</th>
                                </tr>
                                    <tr><td bgcolor="green"></td><td>&nbsp;Completed Experiment</td><td></td>
                                    <td bgcolor="yellow"></td><td>&nbsp;Running Experiment</td><td></td>
                                    <td bgcolor="red"></td><td>&nbsp;Saved Experiment</td></tr>
                                </table>
                        </div>
                        <!-- .panel-body -->
                    <!-- /.panel -->
                </div>

                    <div class="col-lg-12">
                    <form action="deleteExperiments.jsp" method="get">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <b> Experiment History</b> &emsp;&emsp;
                                <input type="submit" name="delete"   class='btn btn-default' style="color: #357EC7;font-weight: normal;" value="Delete Saved Experiment">
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <!-- <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example"> -->
                                <!-- <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example"> -->
                                <table class="table table-striped" style="overflow: auto;width: 100%; height:500px;display: block" >
 <!-- expid,name,date_format(starttime,'%d:%m:%Y %H:%i:%s'),date_format(endtime,'%d:%m:%Y %H:%i:%s'),location,description,fileid,filename,status,creationtime  -->

                                    <thead>
                                        <tr>
                                            <th  style="display: none">#</th>
                                            <th>Select</th>
                                            <th>Exp No.</th>
                                            <th>Control File</th>
                                            <th>Exp Name</th>
                                            <th>Creation Time</th>
                                            <th>Start Time</th>
                                            <th>End Time</th>
                                            <th>Exp Location</th>
                                            <th>Description</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <%
                                               ResultSet rs = DBManager.getAllExperimentDetails(username);
                                               String path = Constants.experimentDetailsDirectory;
                                               if (!path.endsWith("/")) {
                                                   path = path + "/";
                                               }
                                               if (!path.startsWith("/")) {
                                                   path = "/" + path;
                                               }
                                               path = path +username+ "/controlFile/";
                                               if (rs != null) {
                                                   while (rs.next()) {
                                                   String status = "";
                                                   if(rs.getString(9).trim().equals("0")){
                                                        status = "<td bgcolor='red'><b style='display:none'>" + rs.getString(9) + "</b></td>";
                                                   }else if(rs.getString(9).trim().equals("1")){
                                                        status = "<td bgcolor='yellow'><b style='display:none'>" + rs.getString(9) + "</b></td>";
                                                   }else if(rs.getString(9).trim().equals("2")){
                                                        status = "<td bgcolor='green'><b style='display:none'>" + rs.getString(9) + "</b></td>";
                                                   }

                                    
                                    // id, starttime, endtime, name,location,description,fileid,filename                                                   

                                               out.write("<tr><td  style='display: none'></td>"
                                               +((rs.getString(9).trim().equals("0"))?"<td><input type='checkbox' name='selectedclients' value='"+rs.getString(1)+"'/></td>":"<td></td>")
                                               +"<td>"+ ((rs.getString(9)==null || rs.getString(9).equals("0"))?rs.getString(1):"<a href=\"experimentView.jsp?expid="+ rs.getString(1) + "\">" + rs.getString(1) + "</a>" )+"</td>"
                                               +"<td>"+((rs.getString(7)==null || rs.getString(7).trim().equals("-1"))?"-No File Chosen-":"<a href=\"download.jsp?path=" + path + "&fileid=" + rs.getString(7) + "&name="+rs.getString(8)+" \" >" + "File ID:"+rs.getString(7)+ "</a>")+"</td>"
                                               +"<td>" + rs.getString(2) + "</td>"
                                               +"<td>" + rs.getString(10) + "</td>"
                                               +"<td>" + ((rs.getString(3)==null||rs.getString(3).trim().equals(""))?"Not Started":rs.getString(3)) + "</td>"
                                               +"<td>" + ((rs.getString(4)==null||rs.getString(4).trim().equals(""))?"Not Stopped":rs.getString(4)) + "</td>"
                                               +"<td>" + ((rs.getString(5)==null || rs.getString(5).trim().equals(""))?"-no info-":rs.getString(5)) + "</td>"
                                               +"<td>" + ((rs.getString(6)==null || rs.getString(6).trim().equals(""))?"-no-info-":rs.getString(6)) + "</td>"
                                               + status
                                               +"</tr>");

                                                   }
                                               }

                                        %>  

                                    </tbody>
                                </table>
                                <!-- /.table-responsive -->

                            </div>
                            <!-- /.panel-body -->
                        </div>
                        </form>
                        <!-- /.panel -->
                    </div>


                    


                    <!-- /.col-lg-12 -->
                </div>
                <!--end Row -->

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
