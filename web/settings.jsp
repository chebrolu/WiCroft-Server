<%-- 
    Document   : settings
    Created on : 30 May, 2017, 11:52:27 PM
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
            function selectBssids() {
                if (document.getElementById("choose").checked == true) {
                    var list = document.getElementsByName("selectedbssids");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = true;
                    }
                } else {
                    var list = document.getElementsByName("selectedbssids");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = false;
                    }
                }
            }
            
            function selectNewBssids() {
                if (document.getElementById("choosenew").checked == true) {
                    var list = document.getElementsByName("selectnewbssids");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = true;
                    }
                } else {
                    var list = document.getElementsByName("selectnewbssids");
                    for (var i = 0; i < list.length; i++) {
                        list[i].checked = false;
                    }
                }
            }
        </script>
    </head>
    <body>
        
        <%
            if(session.getAttribute("currentUser")== null){
                response.sendRedirect("login.jsp");
            }else{
                
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);

              if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{
            
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

            <!-- .panel-heading -->
            <br><br><br>
            <div class="panel-body">
                <div class="panel-group" id="accordion">

                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">DashBoard Settings</a>
                            </h4>
                        </div>
                        <div id="collapseTwo" class="panel-collapse collapse">
                            <div class="panel-body">
                                
                                <form action="setBssidList.jsp" method="get">
                                
                                <div class="row">
                                    
                                    
                                    <div class="col-lg-5"  >
                                    <table  style="overflow: auto;width: 100%; height:400px;display: block"  class="table table-striped table-bordered table-hover">

                                    <!-- <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example"> -->
                                    <!-- <thead style="display: block"> -->
                                        <tr><b>Selected BSSIDs</b></tr>
                                        <tr>
                                            <th  style="display: none">#</th>
                                            <th>Select&nbsp;&nbsp;<input id="choose" type='checkbox' name="selectallbssids" checked onchange="selectBssids(this);"/></th>
                                            <th>No.</th>
                                            <th>SSID</th>
                                            <th>BSSID</th>         
                                        </tr>
                                    <!-- </thead>
                                    <tbody > -->
                                        <%

                                                Enumeration<String> bssList1 = mySession.getSelectedBssidInfo().keys();
                                                ConcurrentHashMap<String, CopyOnWriteArrayList<String>> ssid_bssid1 = new ConcurrentHashMap<String, CopyOnWriteArrayList<String>>();

                                                while (bssList1.hasMoreElements()) {
                                                    String bssid = bssList1.nextElement();
                                                    String ssid = initilizeServer.allBssidInfo.get(bssid);

                                                    if (ssid_bssid1.get(ssid) == null) {
                                                        CopyOnWriteArrayList<String> bssidlist = new CopyOnWriteArrayList<String>();
                                                        bssidlist.add(bssid);
                                                        ssid_bssid1.put(ssid, bssidlist);
                                                    } else {
                                                        CopyOnWriteArrayList<String> bssidlist = ssid_bssid1.get(ssid);
                                                        bssidlist.add(bssid);
                                                        ssid_bssid1.put(ssid, bssidlist);
                                                    }
                                                }

                                                Enumeration<String> ssidList1 = ssid_bssid1.keys();
                                                int count1 = 0 ;    
                                                while (ssidList1.hasMoreElements()) {
                                                    
                                                    String ssid = ssidList1.nextElement();
                                                    CopyOnWriteArrayList<String> bssidlist = ssid_bssid1.get(ssid);

                                                    for (int i = 0; i < bssidlist.size(); i++) {
                                                        count1 += 1;                                                                    
                                                        System.out.println(ssid + " : " + bssidlist.get(i));
                                                        out.write("<tr><td><input type='checkbox' name='selectedbssids' value='"+bssidlist.get(i)+"' checked/></td><td>"+count1+"</td><td>"+ssid+"</td><td>"+bssidlist.get(i)+"</td></tr>");
                                                    }
                                                }
                                        %>  

                                    <!-- </tbody> -->
                                </table>
                                </div>
                                        
                                        
                                    <div class="col-lg-5" >
                                        <table  style="overflow: auto;height:400px;display: block"  class="table table-striped table-bordered table-hover" >

                                        <!-- <table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example"> -->
                                    <!-- <thead style="display: block"> -->
                                        <tr><b>All Available BSSIDs</b></tr>
                                        <tr>
                                            <th  style="display: none">#</th>
                                            <th>Select&nbsp;&nbsp;<input  id="choosenew" type='checkbox' name="selectallnewbssids" onchange="selectNewBssids(this);"/></th>
                                            <th>No.</th>
                                            <th>SSID</th>
                                            <th>BSSID</th>         
                                        </tr>
                                    
                                        <%

                                                Enumeration<String> bssList = initilizeServer.allBssidInfo.keys();
                                                ConcurrentHashMap<String, CopyOnWriteArrayList<String>> ssid_bssid = new ConcurrentHashMap<String, CopyOnWriteArrayList<String>>();

                                                while (bssList.hasMoreElements()) {
                                                    String bssid = bssList.nextElement();
                                                    String ssid = initilizeServer.allBssidInfo.get(bssid);

                                                    if (ssid_bssid.get(ssid) == null) {
                                                        CopyOnWriteArrayList<String> bssidlist = new CopyOnWriteArrayList<String>();
                                                        bssidlist.add(bssid);
                                                        ssid_bssid.put(ssid, bssidlist);
                                                    } else {
                                                        CopyOnWriteArrayList<String> bssidlist = ssid_bssid.get(ssid);
                                                        bssidlist.add(bssid);
                                                        ssid_bssid.put(ssid, bssidlist);
                                                    }
                                                }

                                                Enumeration<String> ssidList = ssid_bssid.keys();
                                                int count = 0 ;    
                                                while (ssidList.hasMoreElements()) {
                                                    
                                                    String ssid = ssidList.nextElement();
                                                    CopyOnWriteArrayList<String> bssidlist = ssid_bssid.get(ssid);

                                                    for (int i = 0; i < bssidlist.size(); i++) {
                                                        count += 1;                                                                    
                                                        System.out.println(ssid + " : " + bssidlist.get(i));
                                                        if(mySession.getSelectedBssidInfo().get(bssidlist.get(i))!=null){
                                                            out.write("<tr><td></td><td>"+count+"</td><td>"+ssid+"</td><td>"+bssidlist.get(i)+"</td></tr>");
                                                        }else{
                                                            out.write("<tr><td><input type='checkbox' name='selectnewbssids' value='"+bssidlist.get(i)+"'/></td><td>"+count+"</td><td>"+ssid+"</td><td>"+bssidlist.get(i)+"</td></tr>");
                                                        }
                                                    }
                                                }

                                        %>  

                                    <!-- </tbody> -->
                                </table>
                                  </div>
                                        
                                <div class="col-lg-2">
                                   <input type='submit' class='btn btn-default' style="background-color: green ;color: white;border-color:green" value='Update List'>
                                    <br> <br> 
                                  <a href="handleEvents.jsp?event=clearallbssidlist" class='btn btn-default' style="background-color: #e74c3c ;color: white;border-color:#e74c3c">Clear All List</a>
                                    
                                </div>
                                </div>  
                                </form>
                            </div>
                        </div>
                    </div>


                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Account Settings</a>
                            </h4>
                        </div>
                        
            <div id="collapseOne" class="panel-collapse collapse">
                <div class="panel-body">
                        <%
//                                    String user = (String) session.getAttribute("currentUser");
                                
                        if(username.equals("admin")){
                            %>
                    
                            
                <div class="panel-body">
                <!-- Nav tabs -->
                <ul class="nav nav-pills">
                    <li class="active">
                    <a href="#create" data-toggle="tab">Create Account</a>
                    </li>
                    <li><a href="#delete" data-toggle="tab">Delete Account</a>
                    </li>
                    <li><a href="#changepwd" data-toggle="tab">Change Password</a>
                    </li>
<!--                                <li><a href="#settings" data-toggle="tab">Settings</a>
                    </li>-->
                </ul>
                <!-- Tab panes -->
                
                
                    
                <div class="tab-content">
                    <br/><br/>
                    
                    <div class="form-group col-lg-4 tab-pane fade in active" id="create">
                    <form action='accountSettings.jsp' method='get' onsubmit="return checkCreateAccFields()">    
                        <table   class="table  table-hover">
                            <tr><td>UserName</td><td><input class="form-control" id="createAccusername" type='text' name='newusername'/></td></tr>
                            <tr><td>Password</td><td><input class="form-control" id="createAccpwd" type='password' name='newpassword'/></td></tr>
                            <tr><td></td><td><input class='btn btn-danger' type='submit' name='action' value='Create Account'/></td></tr>
                        </table>
                    </form>
                    </div>
                    
                    
                    
                    <div class="col-lg-4 tab-pane fade" id="delete">
                    <form action='accountSettings.jsp' method='get' onsubmit="return checkDeleteAccFields()">
                        <!-- <input type="text" style="visibility: hidden;" name="currentUser" value="<%=username%>"> -->
                          <table   class="table table-hover">
                           <input class="form-control" type='text' id='currentUserName' style="visibility: hidden;" readonly="readonly" value="<%=username%>" />
                            <tr><td>UserName</td><td><input class="form-control" id="deleteAccusername" type='text' name='username'/></td></tr>
                            <tr><td>Password</td><td><input class="form-control" id="deleteAccpwd" type='password' name='password'/></td></tr>
                            <tr><td></td><td><input  class='btn btn-danger' type='submit'  name='action' value='Delete Account'/></td></tr>
                        </table>
                    </form>
                    </div>
                    
                    
                    
                    <div class="col-lg-4 tab-pane fade" id="changepwd">
                    <form action='accountSettings.jsp' method='get' onsubmit="return checkChangePwdFields()">
                          <table   class="table table-hover">
                           <tr><td> UserName</td><td><input class="form-control" type='text' name='' readonly="readonly" value="<%=username%>" /></td></tr>
                            <tr><td>Password</td><td><input class="form-control" id="changepwd1" type='password' name='oldpassword'/></td></tr>
                            <tr><td>New &nbsp;Password</td><td><input class="form-control" id="changepwd2" type='password' name='resetpassword'/></td></tr>
                            <tr><td></td><td><input  class='btn btn-danger' type='submit'  name='action' value='Change Password'/></td></tr>
                        </table>
                    </form> 
                    </div>
                    

                </div>
                </div></div></div></div></div>
                
                <%
                    String action =  request.getParameter("action");
                    String status =  request.getParameter("status");
                    String message = "";
                    if(action!= null && status != null && !action.trim().equals("") && !status.trim().equals("") ){
                        boolean success = true;
                        int statusCode =  Integer.parseInt(status);
                        if(action.equals("createaccount")){
                            switch (statusCode) {
                                case 1:
                                    message = "User account successfully created";
                                    success = true;
                                    break;
                                case -1:
                                    message = "Username already exists";
                                    success = false;
                                    break;
                                case -2:
                                    message = "Database Error";
                                    success = false;                                                
                                    break;
                                case -3:
                                    message = "Internal Error";
                                    success = false;                                                
                                    break;
                            }             
                            
                            if(success){%>
                                <div class="col-lg-4 alert alert-success alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }else{
                            %>  
                                <div class="col-lg-4 alert alert-danger alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }
                            
                        }else if(action.equals("deleteaccount")){
                            switch (statusCode) {
                                case 1:
                                    message = "User account successfully deleted";
                                    success = true;                                                
                                    break;
                                case -1:
                                    message = "User Account does not exists";
                                    success = false;                                                
                                    break;
                                case -2:
                                    message = "Database Error";
                                    success = false;                                                
                                    break;
                                case -3:
                                    message = "Internal Error";
                                    success = false;                                                
                                    break;
                            }

                            if(success){%>
                                <div class="col-lg-4 alert alert-success alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }else{
                            %>
                                <div class="col-lg-4 alert alert-danger alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }

                        }else if(action.equals("changepwd")){
                            switch (statusCode) {
                                case 1:
                                    message = "Password successfully changed";
                                    success = true;                                                
                                    break;
                                case -1:
                                    message = "Password is not matching";
                                    success = false;                                                
                                    break;
                                case -2:
                                    message = "Database Error";
                                    success = false;                                                
                                    break;
                                case -3:
                                    message = "Internal Error";
                                    success = false;                                                
                                    break;
                            }

                            if(success){%>
                                <div class="col-lg-4 alert alert-success alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }else{
                            %>
                                <div class="col-lg-4 alert alert-danger alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }

                        }
                    }
                
                %>
                    
                    <%
                        }else{
                    %>
                    
                    <div class="panel-body">
                <!-- Nav tabs -->
                <ul class="nav nav-tabs">
                    
                    <li class="active"><a href="#changepwd" data-toggle="tab">Change Password</a>
                    </li>
                 <!--    <li><a href="#settings" data-toggle="tab">Settings</a>
                    </li> -->
                </ul>
                <!-- Tab panes -->
                
                <form action='accountSettings.jsp' method='get'>
                    
                <div class="tab-content">
                    <br/><br/>
                   
                    
                    <div class="col-lg-4 " id="changepwd">
                          <table   class="table table-striped table-bordered table-hover">
                            <tr><td> UserName</td><td><input class="form-control" type='text' name='' readonly="readonly" value="<%=username%>" /></td></tr>
                            <tr><td>Password</td><td><input type='password' name='oldpassword'/></td></tr>
                            <tr><td>New &nbsp;Password</td><td><input type='password' name='resetpassword'/></td></tr>
                            <tr><td></td><td><input type='submit'  name='action' value='Change Password'/></td></tr>
                        </table>
                    </div>
                </div>
                </form>
            </div>
            </div></div></div></div>
                    

                    <%
                    String action =  request.getParameter("action");
                    String status =  request.getParameter("status");
                    String message = "";
                    if(action!= null && status != null && !action.trim().equals("") && !status.trim().equals("") ){
                        boolean success = true;
                        int statusCode =  Integer.parseInt(status);
                         if(action.equals("changepwd")){
                            switch (statusCode) {
                                case 1:
                                    message = "Password successfully changed";
                                    success = true;                                                
                                    break;
                                case -1:
                                    message = "Password is not matching";
                                    success = false;                                                
                                    break;
                                case -2:
                                    message = "Database Error";
                                    success = false;                                                
                                    break;
                                case -3:
                                    message = "Internal Error";
                                    success = false;                                                
                                    break;
                            }

                            if(success){%>
                                <div class="col-lg-4 alert alert-success alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }else{
                            %>
                                <div class="col-lg-4 alert alert-danger alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                            <%
                            }

                        }
                    }
                %>
                        <%
                        }}
                        %>
                        </div>
                    </div>
                </div>
            </div>
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

        <script>
            $(document).ready(function () {
                $('#dataTables-example1').DataTable({
                    responsive: true
                });
            });
        </script>



<!--        <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                // refresh();

            });
        </script>-->


        <script type="text/javascript">
            
  /*      if(document.getElementById('newusername').value==null || document.getElementById('newusername').value=="" || 
                document.getElementById('newpassword').value==null || document.getElementById('newpassword').value=="" ||
                document.getElementById('pwd').value==null || document.getElementById('pwd').value==""
                ){
                alert("Fields cannot be empty");
                return false;
            }else if(document.getElementById('newusername').value.indexOf(' ') >= 0){
                alert("Username : Spaces are not allowed");
                return false;

            }else if(document.getElementById('newpassword').value.indexOf(' ') >= 0){
                alert("Password : Spaces are not allowed");
                return false;
                
            }else if(document.getElementById('pwd').value.indexOf(' ') >= 0){
                alert("Re-enter Password : Spaces are not allowed");
                return false;
                
            }else if(document.getElementById('newusername').value.length > 8){
                alert("Username : Max 8 characters allowed");
                return false;
                
            }else if(document.getElementById('newusername').value.match(/^[a-zA-Z0-9]+$/)==null){
                alert("Username : Only digits and alphabets allowed");
                return false;
                
            }else if(document.getElementById('newpassword').value != document.getElementById('pwd').value){
                alert("Passwords are not matching");
                return false;
            }

*/
        

        function checkCreateAccFields(){

            a = document.getElementById("createAccusername").value;
            b = document.getElementById("createAccpwd").value;

            if(a==null||a==""||b==null||b==""){
                alert("Fields cannot be empty");
                return false;
            }else if(a.indexOf(' ') >= 0){
                alert("Username : Spaces are not allowed");
                return false;

            }else if(b.indexOf(' ') >= 0){
                alert("Password : Spaces are not allowed");
                return false;
                
            }else if(a.length > 8){
                alert("Username : Max 8 characters allowed");
                return false;
                
            }else if(a.match(/^[a-zA-Z0-9]+$/)==null){
                alert("Username : Only digits and alphabets allowed");
                return false;
                
            }

            
            return true;
        }

        function checkDeleteAccFields(){

            a = document.getElementById("deleteAccusername").value;
            b = document.getElementById("deleteAccpwd").value;
            c = document.getElementById("currentUserName").value;

            if(a==c){   
                alert("You cannot delete current account!!!");
                return false;
            }else  if(a==null||a==""||b==null||b==""){
                alert("Fields cannot be empty");
                return false;
            }else if(a.indexOf(' ') >= 0){
                alert("Username : Spaces are not allowed");
                return false;

            }else if(b.indexOf(' ') >= 0){
                alert("Password : Spaces are not allowed");
                return false;
                
            }else if(a.length > 8){
                alert("Username : Max 8 characters allowed");
                return false;
                
            }else if(a.match(/^[a-zA-Z0-9]+$/)==null){
                alert("Username : Only digits and alphabets allowed");
                return false;
                
            }
            
            
            
            return true;
        } 

        function checkChangePwdFields(){

            a = document.getElementById("changepwd1").value;
            b = document.getElementById("changepwd2").value;

            if(a==null||a==""||b==null||b==""){
                alert("Fields cannot be empty");
                return false;
            }else if(a.indexOf(' ') >= 0){
                alert("Password : Spaces are not allowed");
                return false;

            }else if(b.indexOf(' ') >= 0){
                alert("New Password : Spaces are not allowed");
                return false;
                
            }

            return true;
        }

        </script>
        <%
            }
        %>

    </body>
</html>
