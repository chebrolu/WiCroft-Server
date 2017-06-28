

<%-- 
    Document   : controlFileStatus
    Created on : 17 Jan, 2017, 11:24:21 PM
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

            function check() {



                count = 0;

                var list = document.getElementsByName("selected");
                for (var i = 0; i < list.length; i++) {
                    if (list[i].checked == true) {
                        count++;
                    }
                }

//                alert("HAI" + count);

                if (count === 0) {
                    alert("No client selected");
                    return false;
                }
                return true;


//                document.getElementById('error').style.display = 'none';
//
//                if (document.getElementById("expName").value == null || document.getElementById("expName").value == "") {
//                    //alert("ExprimentName cannot be empty");
//                    document.getElementById('error').style.display = 'block';
//                    return false;
//                }
//
//                if (document.getElementById("fileupload").value == null || document.getElementById("fileupload").value == "") {
//                    alert("Choose Control file");
//                    return false;
//                } else {
//                    return true;
//                }

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
            
            if(mySession.isSendCtrlFileRunning()){                
                response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            }

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
                        <h2 class="page-header">Control File Status </h2>
                        <h3>File ID &nbsp;:&nbsp;<%=fileid%></h3>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>


                <div class="row">
                    <div class="col-lg-5">

                            <div class="panel-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover">
                                        <tbody>
                                            <%

                                                
                                                 
                                           
                                                
                                                int total = mySession.getSendCtrlFileSelectedClients().size();//mySession.getSendCtrlFileFilteredClients().size();
                                                int success = 0;//mySession.getControlFileSendingSuccessClients().size();
                                                int failed = 0;//mySession.getControlFileSendingFailedClients().size();;

                                                int pending = 0;

                                                //pending = total - (success + failed);                                                

                                                ResultSet rs1 = DBManager.getControlFileUserInfo(userid, Integer.parseInt(fileid));
                                                if(rs1 != null){
                                                    while(rs1.next()){
                                                        String mac = rs1.getString("macaddr");                                                        
                                                        if(mySession.getSendCtrlFileSelectedClients().contains(mac)){
                                                            if(rs1.getString("status").equals("0")){
                                                                pending += 1;
                                                            }
                                                            else if(rs1.getString("status").equals("1")){
                                                                failed += 1;
                                                            }   
                                                            else if(rs1.getString("status").equals("2")){
                                                                success +=1;
                                                            }
                                                        }
                                                    }
                                                }

                                              //  total = pending + success + failed;                                                
                                                


                                                out.write("<tr>"+
                                                "<td>Total Number of Clients Selected </td>"+
                                                "<td>"+ (total > 0 ? "<a href='controlFileSummary.jsp?reqType=total'>" + total + "</a>" : "0")+"</td>"+
                                                "<td>&nbsp;</td>"+
                                                "<td>&nbsp;</td>"+
                                                "</tr>");

                                                out.write("<tr>"+
                                                "<td>Control File Sending </td>"+
                                                "<td> Success &emsp;" + (success > 0 ? "<a href='controlFileSummary.jsp?reqType=success&fileid="+fileid+"&filename="+filename+"'>" + success + "</a>" : 0) + "&nbsp;</td>");

                                                out.write("<td> Pending &emsp;" + (pending > 0 ? "<a href='controlFileSummary.jsp?reqType=pending&fileid="+fileid+"&filename="+filename+"'>" + pending + "</a>" : 0) + "&nbsp;</td>");

                                                out.write("<td> Failed &emsp;" + (failed > 0 ? "<a href='controlFileSummary.jsp?reqType=failed&fileid="+fileid+"&filename="+filename+"'>" + failed + "</a>" : 0) + "&nbsp;</td></tr>");
                                                
                                            %>              
                                        </tbody>
                                    </table>
                                </div>
                                <!-- /.table-responsive -->
                            <!-- /.panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>
                  

                </div>
                <!--end Row -->

                <form role="form" action="controlFileRetryStatus.jsp"  method="post" onsubmit="return check();">
                    <input type="text" style="visibility: hidden;" name="newFileId" value="<%=fileid%>">
                    <input type="text" style="visibility: hidden;" name="newFileName" value="<%=filename%>">

                    <div class="row">
                        <div class="col-lg-10">
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <b>Request status</b> &emsp;&emsp;

                                     <a style="color: 357CE7;text-decoration: none" href="configExperiment.jsp" ><button type="button" class="btn btn-default">Exit Page</button></a>

                                </div>
                                <!-- /.panel-heading -->
                                <div class="panel-body">
                                    <table width="100%" class="table table-striped table-bordered table-hover" >
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Select <input id="choose"  checked type="checkbox" name='test' onchange="selectCheckBox(this);"></th>
                                                <th>Mac Address</th>
                                                <th>BSSID</th>
                                                <th>SSID</th>
                                                <th>Send Date</th>
                                                <th>Ack Received</th>
                                                <th>No. of Retry</th>
                                                <th>Request Status</th> 
                                                <th>Last HeartBeat</th>
                                                
                                            </tr>
                                        </thead>
                                        <tbody>


                                            <%
                                                
                                                ResultSet rs = DBManager.getControlFileUserInfo(userid, Integer.parseInt(fileid));
                                                int count = 0;
                                                
                                                if(rs != null){
                                                    while(rs.next()){
                                                        String mac = rs.getString("macaddr");
                                                        
                                                        if(mySession.getSendCtrlFileSelectedClients().contains(mac)){

                                                        count++;     
                                                                    
                                                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
//                                                        out.write("<tr><td>" + count + "</td><td><input type='checkbox' name='selected' value='" + device.getMacAddress() + "'></td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>" + (rs.getString("filesenddate")==null?"---":rs.getString("filesenddate")) + "</td><td>" + (rs.getString("filereceiveddate")==null?"---":rs.getString("filereceiveddate")) + "</td><td>" + rs.getString("retry") + "</td><td>" + mySession.getSendCtrlFileFilteredClients().get(mac) + "</td><td>"+device.getLastHeartBeatTime()+"</td></tr>"); 

                                                        out.write("<tr><td>" + count + "</td><td><input type='checkbox' name='selected' value='" + device.getMacAddress() + "'></td><td>" + device.getMacAddress() + "</td><td>" + device.getBssid() + "</td><td>" + device.getSsid() + "</td><td>" + (rs.getString("filesenddate")==null?"---":rs.getString("filesenddate")) + "</td><td>" + (rs.getString("filereceiveddate")==null?"-No-":"Yes") + "</td><td>" + rs.getString("retry") + "</td><td>" + mySession.getSendCtrlFileFilteredClients().get(mac) + "</td><td>"+device.getLastHeartBeatTime()+"</td></tr>"); 

                                                        }
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



                         <%
                      
                        if(!mySession.isSendCtrlFileRunning()){

                        %>

                    <div class="col-lg-2">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                Log Retry 
                            </div>
                            <!-- /.panel-heading -->
                            <div class="panel-body">
                                <div class="form-group">
                                <label>Number of Log Requests<br/> Per Round<b style='color: red'>*</b></label>
                                <input  class="form-control" type="text" value='5' id='numclients' name='ctrlFileNumClients'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                </div>

                                <div class="form-group">
                                    <label>Duration between Rounds<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                    <input  class="form-control" type="text" value='10' id='duration' name='ctrlFileDuration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                </div>

                                <div class="form-group">
                                    <!--<input type='submit' class='btn btn-default' value='Retry Log Request' onclick='return checkFields();' >-->                                                    
                                    <input type='submit' class='btn btn-default' value='Retry Log Request' >                                                    
                                </div>

                            </div>
                            <!-- .panel-body -->
                        </div>
                        <!-- /.panel -->
                    </div>
                    <%
                        }
                    %>


                    </div> 
                </form>






            </div>
            <!-- /#page-wrapper -->
        </div>

            <%
                        
                }}
            %>

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




