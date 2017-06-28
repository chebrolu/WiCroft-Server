<%-- 
    Document   : controlFileSummary
    Created on : 21 Jan, 2017, 6:25:26 PM
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
            response.setIntHeader("refresh", 5);
                    String para = request.getParameter("reqType");
                    System.out.println(para);
            int userid = DBManager.getUserId(username);
            String fileid = request.getParameter("fileid");
            String filename = request.getParameter("filename");
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

               
                <!-- /.navbar-static-side -->
                
                 <div id="links" class="navbar-default sidebar" role="navigation">
                </div>
                
            </nav>

            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">Control File Sending Status</h1>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>


                <%              
 

                if (para.equals("total")) {

                %>

                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Total Clients
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Mac Address</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>STATUS</th>                                                

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                int count = 0;
                                                for(int i=0;i<mySession.getSendCtrlFileSelectedClients().size();i++){
                                                    count++;
                                                    String mac = mySession.getSendCtrlFileSelectedClients().get(i);
                                                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                    out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+mySession.getSendCtrlFileFilteredClients().get(mac)+"</td></tr>");
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
                </div>
                <!--end Row -->

                <%} else if (para.equals("success")) {%>



                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Control File sending : Success
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Mac Address</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>Status</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%  
                                            

                                                
                                                ResultSet rs1 = DBManager.getControlFileUserInfo(userid, Integer.parseInt(fileid));
                                                 int count = 0;                  
                                                if(rs1 != null){
                                                    while(rs1.next()){
                                                        String mac = rs1.getString("macaddr");                                                        
                                                        if(mySession.getSendCtrlFileSelectedClients().contains(mac)){
                                                             if(rs1.getString("status").equals("2")){
                                                             count++;
                                                                 DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                    out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+rs1.getString("statusmessage")+"</td></tr>");


                                                            }
                                                        }
                                                    }
                                                }


                                               /* int count = 0;                                        
                                                Enumeration<String> macs = mySession.getControlFileSendingSuccessClients().keys();
                                                while(macs.hasMoreElements()){
                                                    count++;
                                                    String mac = macs.nextElement();
                                                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                    out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+mySession.getSendCtrlFileFilteredClients().get(mac)+"</td></tr>");
                                                }*/
        
       
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





                <%} else if (para.equals("pending")) {%>





                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Control File sending : Pending
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Mac Address</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>Status</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                               

                                              out.write("HAI");
                                                
                                                ResultSet rs1 = DBManager.getControlFileUserInfo(userid, Integer.parseInt(fileid));
                                                 int count = 0;                  
                                                if(rs1 != null){
                                                    while(rs1.next()){
                                                        String mac = rs1.getString("macaddr");                                                        
                                                        if(mySession.getSendCtrlFileSelectedClients().contains(mac)){
                                                             if(rs1.getString("status").equals("0")){
                                                             count++;
                                                                 DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                    out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+rs1.getString("statusmessage")+"</td></tr>");


                                                            }
                                                        }
                                                    }
                                                }




                                                /*
                                                int count =0;
                                                for(int i=0;i<mySession.getSendCtrlFileSelectedClients().size();i++){
                                                    count++;
                                                    String mac = mySession.getSendCtrlFileSelectedClients().get(i);
                                                    if(mySession.getControlFileSendingSuccessClients().get(mac)== null && mySession.getControlFileSendingFailedClients().get(mac)==null){
                                                        
                                                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                    out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+mySession.getSendCtrlFileFilteredClients().get(mac)+"</td></tr>");
                                                    }
                                                }
                                                */
                                                
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






                <%  } else if (para.equals("failed")) {%>










                <div class="row">
                    <div class="col-lg-6">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Control File sending : Failed
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Mac Address</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>Status</th>

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                                

                                                ResultSet rs1 = DBManager.getControlFileUserInfo(userid, Integer.parseInt(fileid));
                                                 int count = 0;                  
                                                if(rs1 != null){
                                                    while(rs1.next()){
                                                        String mac = rs1.getString("macaddr");                                                        
                                                        if(mySession.getSendCtrlFileSelectedClients().contains(mac)){
                                                             if(rs1.getString("status").equals("1")){
                                                             count++;
                                                                 DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                    out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+rs1.getString("statusmessage")+"</td></tr>");


                                                            }
                                                        }
                                                    }
                                                }

                                                 /*int count =0;
                                                
                                                 Enumeration<String> macs = mySession.getControlFileSendingFailedClients().keys();
                                                    while(macs.hasMoreElements()){
                                                        count++;
                                                        String mac = macs.nextElement();
                                                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                                        out.write("<tr><td>" + count + "</td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>"+mySession.getSendCtrlFileFilteredClients().get(mac)+"</td></tr>");
                                                }*/

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
                }
                }}
                %>






            </div>
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