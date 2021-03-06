<%-- 
    Document   : apchangeHandler
    Created on : 23 Jul, 2016, 11:46:07 PM
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
                if (document.getElementById("chooseAll").checked == true) {
                    var list = document.getElementsByName("selectedclient");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = true;
                    }
                } else {
                    var list = document.getElementsByName("selectedclient");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = false;
                    }
                }
            }

            function selectCheckBoxActive() {
            }

            function selectCheckBoxPassive() {

            }

        </script>



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


            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">AccessPoint Configuration</h1>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>


                <form role="form" action="apchangeStatus.jsp" method="post" onsubmit="return checkFields(this);">  
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="panel panel-info">
                                <div class="panel-heading">
                                    Parameters
                                </div>
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-lg-6">





                                            <div class="form-group">
                                                <label>SSID<b style='color: red'>*</b></label>
                                                <input class="form-control" type='text' id='ssid'  name='_ssid'/>
                                            </div>


                                            <div class="form-group">
                                                <label>Timer&nbsp;(Seconds)<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='bssid' name='_bssid'/>
                                            </div>

                                            <div class="form-group">
                                                <label>Username<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='username' name='_username'/>
                                            </div>

                                            <div class="form-group">
                                                <label>Password<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='password' name='_password'/>
                                            </div>


                                            <div class="form-group">
                                                <label>Security Type<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='security' name='_security'/>
                                                <p class="help-block">example :- eap, wep, open, wpa-psk</p>
                                            </div>



                                            <div class="form-group">
                                                <input class='btn btn-default' type='submit' value='Send AP Settings'  onclick='return checkFields();'  >
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
        <div class="panel panel-primary">
            <div class="panel-heading">
                <b> Active Clients Information</b>
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <!--<table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">-->
                <table width="100%" class="table table-striped table-bordered table-hover">                                        

                    <thead>
                        <tr>
                            <th>#</th> 
                            <th>

                                Select All<input id="chooseAll"  checked type="checkbox" onchange="selectCheckBox(this);">
                                <!--&nbsp;  <b style="color: green">Active</b> <input id="chooseActive"  checked type="checkbox" onchange="selectCheckBoxActive(this);">-->
                                <!--&nbsp;  <b style="color: red">Passive</b> <input id="choosePassive"  checked type="checkbox" onchange="selectCheckBoxPassive(this);">-->


                            </th>
                            <th>Mac Address</th>
                            <th>Status</th>
                            <th>SSID</th>
                            <th>BSSID</th>
                            <th>Latest HearBeat</th>

                        </tr>
                    </thead>
                    <tbody>


                <%
                                                
                                                
                   session.setAttribute("filter", null);
                   session.setAttribute("clientcount", null);

                   if (request.getParameter("getclient") != null) {

                       if (request.getParameter("filter").equals("bssid")) {

                           ConcurrentHashMap<String, DeviceInfo> clients = Constants.currentSession.getConnectedClients();
                           Enumeration<String> macList = clients.keys();
                           if (clients != null) {

                               if (clients.size() == 0) {
                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
                               } else {
                                   int i = 0;
                                   int flag = 0;
                                   
                                   ConcurrentHashMap<String, String> bssidList = new ConcurrentHashMap<String, String>();
                                   
                                   String arr[] = request.getParameterValues("bssid");
                                   for (int p = 0; p < arr.length; p++) {
                                       if(arr[p].length() > 0){
                                           bssidList.put(arr[p],"1");
                                       }
                                    }
                                   
                                   
                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
                                   
                                   while (macList.hasMoreElements()) {
                                       String macAddr = macList.nextElement();
                                       DeviceInfo device = clients.get(macAddr);

                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
                                       if (activeClient.contains(device)) {
                                               
                                           if (bssidList.get(device.getBssid()) != null){
                                               i++;
                                               flag = 1;
                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                           }
                                       }else{
                                           if(bssidList.get(device.getBssid()) != null){
                                               tempDeviceListMacAddr.add(macAddr);                                                                                             
                                              
                                           }
                                       }
                                   }
                                   
                                   
                                    for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
                                        String mac = tempDeviceListMacAddr.get(j);
                                        DeviceInfo device = clients.get(mac);
                                        
                                        i++;
                                        flag = 1;
                                        out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                    }
                                   
                                   if (flag == 0) {
                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
                                   }
                               }
                           }
                       } else if (request.getParameter("filter").equals("ssid")) {

                           ConcurrentHashMap<String, DeviceInfo> clients = Constants.currentSession.getConnectedClients();
                           Enumeration<String> macList = clients.keys();
                           if (clients != null) {
                               if (clients.size() == 0) {
                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
                               } else {
                                   int i = 0;
                                   int flag = 0;
                                   
                                    ConcurrentHashMap<String, String> ssidList = new ConcurrentHashMap<String, String>();
                                   
                                   String arr[] = request.getParameterValues("ssid");
                                   for (int p = 0; p < arr.length; p++) {
                                       if(arr[p].length() > 0){
                                           ssidList.put(arr[p],"1");
                                       }
                                    }
                                   
                                   
                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
                                   
                                   while (macList.hasMoreElements()) {
                                       String macAddr = macList.nextElement();
                                       DeviceInfo device = clients.get(macAddr);
                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
                                       if (activeClient.contains(device)) {
                                           if (ssidList.get(device.getSsid()) != null) {
                                               i++;
                                               flag = 1;
                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                           }
                                       }else{
                                           
                                           if (ssidList.get(device.getSsid()) != null) {
                                               tempDeviceListMacAddr.add(macAddr);                         
                                           }
                                           
                                       }
                                   }
                                   
                                   
                                   for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
                                        String mac = tempDeviceListMacAddr.get(j);
                                        DeviceInfo device = clients.get(mac);
                                        
                                        i++;
                                        flag = 1;
                                        out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                    }
                                   
                                   if (flag == 0) {
                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
                                   }
                               }
                           }

                       } else if (request.getParameter("filter").equals("manual")) {

                           ConcurrentHashMap<String, DeviceInfo> clients = Constants.currentSession.getConnectedClients();
                           Enumeration<String> macList = clients.keys();
                           if (clients != null) {
                               if (clients.size() == 0) {
                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
                               } else {
                                   int i = 0;
                                   int flag = 0;
                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
                                   
                                   while (macList.hasMoreElements()) {
                                       String macAddr = macList.nextElement();
                                       DeviceInfo device = clients.get(macAddr);
                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
                                       if (activeClient.contains(device)) {
                                           i++;
                                           flag = 1;
                                           out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                       }else{
                                           tempDeviceListMacAddr.add(macAddr);             
                                               
                                       }
                                   }
                                   
                                   for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
                                        String mac = tempDeviceListMacAddr.get(j);
                                        DeviceInfo device = clients.get(mac);
                                        
                                        i++;
                                        flag = 1;
                                        out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                    }
                                   
                                   if (flag == 0) {
                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
                                   }
                               }
                           }

                       } else if (request.getParameter("filter").equals("random")) {

                           ConcurrentHashMap<String, DeviceInfo> clients = Constants.currentSession.getConnectedClients();
                           Enumeration<String> macList = clients.keys();
                           if (clients != null) {
                               if (clients.size() == 0) {
                                   out.write("<tr><td colspan=\"7\">No Clients</td></tr>");
                               } else {
                                   int i = 0;
                                   int count = 0;
                                   int flag = 0;
                                   
                                   CopyOnWriteArrayList<String> tempDeviceListMacAddr = new CopyOnWriteArrayList<String>();
                                    
                                   while (macList.hasMoreElements()) {
                                       String macAddr = macList.nextElement();
                                       DeviceInfo device = clients.get(macAddr);

                                       CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients();
                                       
                                       if (activeClient.contains(device)) {
                                           i++;
                                           count++;
                                           flag = 1;
                                           if (count <= Integer.parseInt(request.getParameter("random"))) {
                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                           } else {
                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\"   name='selectedclient' value=\"" + macAddr + "\"/></td><td>" + macAddr + "</td><td style='color:green'>Active</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                           }
                                       }else{
                                           
                                           tempDeviceListMacAddr.add(macAddr);  
                                       }
                                   }
                                   
                                   for (int j = 0; j < tempDeviceListMacAddr.size(); j++) {
                                        String mac = tempDeviceListMacAddr.get(j);
                                        DeviceInfo device = clients.get(mac);
                                        
                                          i++;
                                           count++;
                                           flag = 1;
                                           if (count <= Integer.parseInt(request.getParameter("random"))) {
                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\" checked  name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                           } else {
                                               out.write("<tr><td>" + i + "</td><td><input type=\"checkbox\"   name='selectedclient' value=\"" + mac + "\"/></td><td>" + mac + "</td><td style='color:red'>Passive</td><td>" + device.getSsid() + "</td><td>" + device.getBssid() + "</td><td>" + device.getLastHeartBeatTime() + "</td></tr>");
                                           } 
                                    }
                                   
                                   if (flag == 0) {
                                       out.write("<tr><td colspan=\"7\">No Active Client</td></tr>");
                                   }
                               }
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
                    </div>
                    <!--end Row -->

                </form>


            </div>




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


        <script>

            function check() {


                if (document.getElementById('ssid').value == "" || document.getElementById('ssid').value == null) {
                    alert("ssid cannot be empty");
                    return false;
                } else {
                    return true;
                }
            }


            function checkFields() {

                if (document.getElementById('ssid').value.match(/^\s+$/i) || document.getElementById('ssid').value == "" || document.getElementById('ssid').value == null) {
                    alert("SSID cannot be empty");
                    return false;
                } else if (document.getElementById('bssid').value.match(/^\s+$/i) || document.getElementById('bssid').value == "" || document.getElementById('bssid').value == null) {
                    alert("Timer cannot be empty");
                    return false;
                } else if (document.getElementById('security').value.match(/^\s+$/i) || document.getElementById('security').value == "" || document.getElementById('security').value == null) {
                    alert("Security Field cannot be empty");
                    return false;
                } else if (!document.getElementById('security').value.match(/\s*eap\s*/i) && !document.getElementById('security').value.match(/\s*wep\s*/i) && !document.getElementById('security').value.match(/\s*open\s*/i) && !document.getElementById('security').value.match(/\s*wpa-psk\s*/i)) {
                    alert("Unknown Security Type");
                    return false;
                } else if (document.getElementById('security').value.match(/eap/i) && (document.getElementById('username').value.match(/^\s+$/i) || document.getElementById('username').value == "" || document.getElementById('username').value == null)) {
                    alert("Username Field cannot be empty");
                    return false;
                } else if (document.getElementById('password').value.match(/^\s+$/i) || document.getElementById('password').value == "" || document.getElementById('password').value == null) {
                    alert("Password Field cannot be empty");
                    return false;
                }

                var inputElems = document.getElementsByTagName("input"),
                        count = 0;

                for (var i = 0; i < inputElems.length; i++) {
                    if (inputElems[i].type == "checkbox" && inputElems[i].checked == true) {
                        count++;
//                        alert("COUNT : " + count);
                    }

                }

                if (count == 0) {
                    alert("No clients selected");
                    return false;
                }


                if (document.getElementsByName("selectedclient").length <= 0) {
                    alert("No clients selected");
                    return false;
                } else {




                    return true;
                }
            }



        </script>

<!--      <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>-->


    </body>

</html>

