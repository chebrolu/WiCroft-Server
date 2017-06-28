<%-- 
    Document   : utilities
    Created on : 30 May, 2017, 10:56:19 PM
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


            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
            Utils.getSelectedConnectedClients(mySession);
            ConcurrentHashMap<String, String> apConnection = Utils.getAccessPointConnectionDetails(mySession);
            mySession.setCurrentAction("");
        %>





            <div id="page-wrapper">
        
        
        
        <div class="row">
                <div class="col-lg-9">
                    
                        <!-- .panel-heading -->
                        <br><br><br>
                        <div class="panel-body">
                            <div class="panel-group" id="accordion">
                                
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Set Wake Up Timer</a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse">
                                        <div class="panel-body">

                                    <form action="wakeupClientsStatus.jsp" target="_blank" method="get">
                                    <div class="row">
                                        <div class="col-lg-7">
                                        <table border="0">
                                            <tr>
                                                <!--<td><input type="radio" name='wakeup' value='addnew' onchange="newtimer();"/></td>-->
                                                <td>New Timer &nbsp;&nbsp;: &nbsp;&nbsp;</td>
                                                <td><input class="form-control" type="number" id ='newTimer' name='newtime' value='10' min="1" max="10000000" /></td>
                                                <td>&nbsp;&nbsp;Seconds</td>
                                            </tr>


                                            <tr>
                                            <td>Filter &nbsp;&nbsp;: &nbsp;&nbsp;</td><td><br>
                                             <div class="form-group">
                                                <!--<label>Selects</label>-->
                                                <select class="form-control" name='filter' id='filter' onchange="_check(this)">
                                                    <option value="none" selected="selected" >--select--</option>
                                                    <option value="bssid" >BSSID</option>
                                                    <option value="ssid" >SSID</option>
                                                    <option value="setToAll" >Set to All</option>
                                                    <option value="clientSpecific"  >Select Specific Clients</option>
                                                </select>
                                            </div></td><td></td><td></td>
                                            </tr>


                                                <tr>
                                            <td></td>
                                            <td> 
                                        <!--<label>Selects</label>-->
                                        <select class="form-control" name='bssid' id='selectonbssid' style="display: none;width: 300px" multiple size='10'>
                                            <%  Enumeration<String> _bssidList = Utils.getAllBssids(mySession);
                                                while (_bssidList.hasMoreElements()) {
                                                    String bssid = _bssidList.nextElement();
                                                    if(bssid != null && bssid.trim().length()>0){
                                                        
                                                    
                                                     String ssid_count = apConnection.get(bssid);
                                                     String info[] = ssid_count.split("#");
                                            
                                                    out.write("<option value=\"" + bssid + "\">" + bssid +" -- "+ info[0]+"</option>");
                                                    }
                                                }
                                            %>
                                        </select>
                                        </td><td></td><td></td>
                                        </tr>


                                        <tr>
                                            <td></td>
                                            <td> 
                                        <!--<label>Selects</label>-->
                                        <select class="form-control" name='ssid' id='selectonssid' style="display: none" multiple size='10'>
                                            <%
                                                Enumeration<String> _ssidList = Utils.getAllSsids(mySession);
                                                while (_ssidList.hasMoreElements()) {
                                                    String ssid = _ssidList.nextElement();
                                                    if(ssid != null && ssid.trim().length()>0){
                                                         out.write("<option value=\"" + ssid + "\">" + ssid + "</option>");
                                                    }
                                                    
                                                   
                                                }
                                            %>
                                        </select>
                                         </td><td></td><td></td>
                                        </tr>

                                                


                                    <tr>
                                        <td></td>
                                        <td> 
                                      <a   class="form-control" name='selectClient' id='selectonclients' style="display: none;text-decoration: none;" href="selectClients.jsp?module=wakeUpTimer" target="_blank" >Select &nbsp; Clients &nbsp;</a>
                                    
                                        </td><td id='selectedclients' style="display: none" ></td><td></td>
                                    </tr>

                                                    <tr>
                                                        <td></td>
                                                        <td><br><input class='btn btn-default' type="submit" value="Start Timer"/></td>
                                                        <td></td><td></td>
                                                    </tr>
                                                </table>
                                        </div>

                                        <div class="col-lg-3">
                                        <br>
                                        <div class="form-group">
                                        <%
                                            if(mySession.isWakeUpTimerRunning()){
                                         %>
                                              <a style="color: white;text-decoration: none" target="_blank" href="wakeupClientsView.jsp"><button type="button" class="btn btn-primary">View &nbsp; Timer</button></a>  
                                        <%
                                            }
                                        %>
                                        </div>
                                        </div>




                                        </div>
                                        </form>


                                        </div>
                                    </div>
                                </div>
                                
                                
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">Wicroft App Update</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse">
                                        <div class="panel-body">
                                        <div class="row">
                                        <div class="col-lg-3">

                                        <a style="color: black;text-decoration: none" target="_blank" href="selectClients.jsp?module=appUpdate"><button type="button" class="btn btn-default">Select &nbsp; Clients</button></a>  

                                        
                                        <br><br>
                                        <form action="updateAppHandler.jsp" method="get" target="_blank">
                                        
                                        <input class='btn btn-default'  type="submit" value="Send Update Notification"/>
                                        </div> 
                                        </form>
                                        <%
                                        if(mySession.isAppUpdateRunning()){
                                        %>
                                        <div class="col-lg-3">
                                        <!-- <br> -->

                                        <a style="color: white;text-decoration: none" target="_blank" href="updateAppStatus.jsp"><button type="button" class="btn btn-primary">View &nbsp; Status</button></a>  

                                        
                                        </div> 

                                        <%
                                            }
                                        %>
                                         
                                        </div>
                                        </div>
                                    </div>
                                </div>
                                
                                
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Request Log Files</a>
                                        </h4>
                                    </div>
                            <div id="collapseThree" class="panel-collapse collapse">
                            <div class="panel-body">
                                
                                <form action="getLogFiles.jsp" target="_blank" method="get">
                                <input type="hidden" name="retryLogFile" value="false" />

                                
                                <div class="row">
                                        <div class="col-lg-3">

                                        <div class="form-group">
                                        <a style="color: black;text-decoration: none" target="_blank" href="selectClients.jsp?module=ReqLogFiles"><button type="button" class="btn btn-default">Select &nbsp; Clients</button></a>
                                        </div>

                                        <div class="form-group">
                                            <label>Number of Log Requests<br/> Per Round<b style='color: red'>*</b></label>
                                            <input  class="form-control" type="text" value='5' id='numclients' name='reqLogNumClients'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                        </div>
                                        
                                        <div class="form-group">
                                            <label>Duration between Rounds<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                            <input  class="form-control" type="text" value='10' id='duration' name='reqLogDuration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                        </div>

                                        <div class="form-group">
                                            <input type='submit' class='btn btn-default' name='getLogFiles' value='Get Log Files' onclick='return checkFields();' >                                                    
                                        </div>

                                        </div>

                                        <div class="col-lg-3">
                                        <div class="form-group">
                                        <a style="color: white;text-decoration: none" target="_blank" href="getLogFilesReqStatus.jsp"><button type="button" class="btn btn-primary">View &nbsp; Status</button></a>  
                                        </div>
                                        </div>

                                    </div>
                                    </form>
                                            
                                            
                                            
                                            
                                        </div>
                                    </div>
                                </div>
                                

                                <div>
                                	<%
                                                    //out.write("<p>"+mySession.getWakeupValue()+"</p>");
                                                %>
                                </div>
                                
                            </div>
                        </div>
                        <!-- .panel-body -->
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->


            <div class="col-lg-3">
                    <br><br>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Alerts
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div id="load_me"><%@ include file="viewSelectedClients.jsp" %></div>   
                        </div>
                        <!-- .panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                
            </div>
        
        
        
        
        
        
        
        

        
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

         <script type="text/javascript">
        var auto_refresh = setInterval(
        function ()
        {
        $('#load_me').load('viewSelectedClients.jsp').fadeIn("slow");
        }, 2000); // autorefresh the content of the div after
                   //every 1000 milliseconds(1sec)
        </script>



        <script type="text/javascript">
            
            function _check() {

                // alert("'"+document.getElementById('filter').value+"'");
                //   alert(document.getElementById('filter').value);
                if (document.getElementById('filter').value == "bssid") {
                    document.getElementById('selectonbssid').style.display = 'block';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonclients').style.display = 'none';
                    document.getElementById('selectedclients').style.display = 'none';

                } else if (document.getElementById('filter').value == "ssid") {
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'block';
                    document.getElementById('selectonclients').style.display = 'none';
                                        document.getElementById('selectedclients').style.display = 'none';
                } else if (document.getElementById('filter').value == "clientSpecific") {

                document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonclients').style.display = 'block';
                                        document.getElementById('selectedclients').style.display = 'block';

                } else if (document.getElementById('filter').value == "setToAll") {
                     document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonclients').style.display = 'none';
                                        document.getElementById('selectedclients').style.display = 'none';
                } else if (document.getElementById('filter').value == "none") {
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonclients').style.display = 'none';
                    document.getElementById('selectedclients').style.display = 'none';
                }
            }



        </script>
        
        
    </body>
</html>
