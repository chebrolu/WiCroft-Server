<%-- 
    Document   : configExperiment
    Created on : 30 May, 2017, 11:05:26 PM
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
//            response.setIntHeader("refresh", 5); // refresh in every 5 seconds
            
            String username = (String)session.getAttribute("currentUser");
            Session mySession = initilizeServer.getUserNameToSessionMap().get(username);
            

            if(mySession == null){
            session.setAttribute("currentUser",null);
            response.sendRedirect("login.jsp");

            }else{

            CopyOnWriteArrayList<DeviceInfo> activeClient = Utils.activeClients(mySession);
            Utils.getSelectedConnectedClients(mySession);
            int userId = DBManager.getUserId(username);
            
            int expid = Integer.parseInt(request.getParameter("expid"));
            String fileid = request.getParameter("fileid");
            String filename = request.getParameter("filename");

            ResultSet rs = DBManager.getSavedExperimentsDetails(userId, expid);


        
           %>



         <div id="page-wrapper">
        
        
        
        <div class="row">
                <div class="col-lg-9">
                <div class="panel-body">
                <div class="panel-group" id="accordion">
           
                        <br><br><br>
                                    <%
                                        if(rs != null && rs.next()){
                                    %>

                                    <form action="startSavedExperiment.jsp" method="get">
                                    <div class="form-group col-lg-2">
                                        <label>Experiment Number</label>
                                        <input class="form-control" type="text" name="expNumber" value='<%=expid%>' readonly="readonly">
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label>Experiment Name<b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" id="expName" name="expName" value="<%=rs.getString(1)%>" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label>Experiment Location</label>
                                        <input class="form-control" type="text" name="expLoc" value="<%=rs.getString(2)%>"/>
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label>Description</label>
                                        <textarea class="form-control" name="expDesc" rows="1" cols="15" style="resize:none;overflow-y: scroll"><%=rs.getString(3)%></textarea>
                                    </div>

                                    <div class="rows">
                                    <div class="form-group col-lg-3">                                    
                                    <%
                                    if(fileid==null || fileid.equals("-1")){
                                    %>
                                    <div class="form-group"  id='expOldFileUpload'>
                                                <label  id='OldFIleLabel' >Choose Control File <b style='color: red'>*</b></label>
                                                <%
                                                    ResultSet rs3 = DBManager.getMyControlFiles(username);  
                                                     out.write("<select class='form-control' id='startNewExpSelectFile' onchange='startNewExpCall(this)' name='expfileIdName'>");
                                                             out.write("<option value='choosefile' selected='selected' disabled>Choose File</option>");                                 
                                                             if(rs3 != null){
                                                                 while(rs3.next()){
                                                                     out.write("<option value='"+rs3.getString("fileid")+"#"+rs3.getString("filename")+"' id='"+rs3.getString("fileid")+"'>"+rs3.getString("fileid")+"&emsp;|&emsp;"+rs3.getString("filename")+"&emsp;|&emsp;"+rs3.getString("filedate")+"</option>");
                                                                     }
                                                              }
                                                               out.write("</select>");    
                                                %>
                                    </div>
                                    <div class="form-group" id='startNewExpSelectClients'  style='display: none'>
                                    <!-- <a href="selectClients.jsp?module=sendControlFile">Select &nbsp; Clients</a>                                                 -->
                                    </div>
                                    <%
                                    }else{
                                    %>
                                    <div class="form-group" >
                                    <label>Selected Control File </label>

                                    <input type="text" readonly="readonly" name="saved_fileid_filename" value="ID : <%=fileid%> <%=filename%>">
                                    <input type="text" readonly="readonly" style="visibility: hidden;" name="expfileIdName" value="<%=fileid%>#<%=filename%>">

                                    <a style='color: white;text-decoration: none' href='selectClients.jsp?module=startExperiment&fileid=<%=fileid%>'  target='_blank'><button type='button' class='btn btn-primary'>Select &nbsp; Clients</button></a>
                                    </div>

                                    <%
                                    }
                                    %>



                                    

                                    <div class="form-group">
                                        <label>Number of file send<br/> Per Round<b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" value='5' id='numclients' name='expnbrClientsPerRound'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    <div class="form-group">
                                        <label>Duration between Rounds<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" value='10' id='duration' name='exproundDuration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>


                                    <div class="form-group">
                                        <input type="submit" class="btn btn-default panel panel-green" id='getclient' name='startExp' value="Start Experiment"/>

                                        
                                    </div>
                                    </div>

                                    <div class="form-group col-lg-3" >
                                     <div class="form-group">
                                        <label>Experiment Timeout<i>(in seconds)</i><b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" id="expName" name="expTimeOut" value="300" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div> <br>

                                     <div class="form-group">
                                        <label>Log backgroung traffic</i><b style='color: red'>*</b></label>
                                        <select name="logBgTraffic" class="form-control">
                                            <option value="false">Yes</option>
                                            <option value="true">No</option>
                                        </select>
                                    </div>
                                    </div>
                                    <div class="form-group col-lg-4" >
                                     <div class="form-group">
                                        <label>Experiment Ack Waiting time<i>(in seconds)</i><b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" id="expName" name="expAckWaitTime" value="30" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div> 

                                     <div class="form-group">
                                        <label>Exp Schedule Time for Retry Request<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" id="expName" name="expRetryStartTime" value="60" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    </div>
                                    </div>
                                    </form> 
                                    <%
                                    }
                                    %>



                </div>
                </div>  
                </div>
              
                

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
                    </div>
                </div>



            </div>
         </div>
                                            
        <%
            }
            }
        %>
            
            <!-- /#page-wrapper -->

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
                // refresh();

            });
        </script>


       <script type="text/javascript">
        var auto_refresh = setInterval(
        function ()
        {
        $('#load_me').load('viewSelectedClients.jsp?currentEvent=changeApSettings').fadeIn("slow");
        }, 1000); 

        // autorefresh the content of the div after
                   //every 1000 milliseconds(1sec)
        </script>

            
        

        <script type="text/javascript">
        function currentEvent(){
            // alert("HAI RATHEESH");
        }
        </script>



 
        
        
        
        <script type="text/javascript">
            
              function startNewExpCall(){
                // choosefile

                if(document.getElementById('startNewExpSelectFile').value == "choosefile"){
                    document.getElementById('startNewExpSelectClients').style.display = 'none';
                }else{
                    document.getElementById('startNewExpSelectClients').style.display = 'block';
                    document.getElementById('startNewExpSelectClients').innerHTML = "<a style='color: white;text-decoration: none' href='selectClients.jsp?module=startExperiment&fileid="+document.getElementById('startNewExpSelectFile').value+"'  target='_blank'><button type='button' class='btn btn-primary'>Select &nbsp; Clients</button></a>";
                }
                // alert(document.getElementById('startNewExpSelectFile').value);
                

            }

        </script>
        
        
        
        
        
        
        
        
    </body>
</html>
