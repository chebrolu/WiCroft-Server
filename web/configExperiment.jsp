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
            mySession.setCurrentAction("");
        
           %>



            <div id="page-wrapper">
        
        
        
        <div class="row">
                <div class="col-lg-9">
                    
                        <%

                        String saveExpStatus =  request.getParameter("saveExpStatus");

                        if(saveExpStatus != null && !saveExpStatus.trim().equals("")){
                            if(!saveExpStatus.trim().equals("-1")){
                                String message = "Experiment Saved as &nbsp;<b>Experiment No : "+saveExpStatus+"</b>";
                                %>
                                <div class="form-group col-lg-4 alert alert-success alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                                <%
                            }else{
                                String message = "Unable to save Experiment";
                                %>
                                <div class="form-group col-lg-4 alert alert-danger alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%=message%>  
                                </div>
                                <%
                            }
                        }





                        %>

                        <!-- .panel-heading -->
                        <br><br><br>
                        <div class="panel-body">
                            <div class="panel-group" id="accordion">
                                
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Create Experiment</a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            
                                    <form action="saveExperiment.jsp"  method="post"  enctype="multipart/form-data" > 
                                    <div class="row">
                                            <div class="form-group col-lg-2">
                                                <label>Experiment Number</label>
                                                <input class="form-control" type="text" name="expNumber" value='<%=DBManager.getNextExpId(username)%>' readonly="readonly">
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <label>Experiment Name<b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" id="expName" name="expName" value="sample exp" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <label>Experiment Location</label>
                                                <input class="form-control" type="text" name="expLoc" value="lab"/>
                                            </div>
                                            <div class="form-group col-lg-3">
                                                <label>Description</label>
                                                <textarea class="form-control" name="expDesc" rows="1" cols="15" style="resize:none;overflow-y: scroll"></textarea>
                                            </div>
                                            
                                   
                                            <div class="form-group col-lg-3">
                                                <label>Control File <b style='color: red'>*</b></label>
                                                <select class="form-control" name='OldorNew' id='OldorNew' onchange="expCheck(this)">
                                                    <option value="chooseFileLater" selected="selected" >Choose File Later</option>
                                                    <option value="expselectNewFile" >New Control File</option>
                                                    <option value="expselectOldFile" >Reuse Control file</option>
                                                </select>
                                            </div>    
                                                

                                            <div class="form-group col-lg-5"  id='expOldFileUpload' style='display: none'>
                                                <label  id='OldFIleLabel' >Choose Control File <b style='color: red'>*</b></label>
                                                <%
                                                    ResultSet rs = DBManager.getMyControlFiles(username);  
                                                     out.write("<select class='form-control' id='fileName' name='expUploadOldfileName'>");
                                                             out.write("<option value='' disabled>Choose File</option>");                                 
                                                             out.write("<option value='' disabled>FileID | Name&emsp; &emsp;&emsp;|&emsp;&emsp; CreationTime</option>");                                 
                                                             if(rs != null){
                                                                 while(rs.next()){
                                                                    
 //                                                                    out.write("<option value='"+rs.getString("1")+"'>"+rs.getString("1")+"&emsp;|&emsp;"+rs.getString("2")+"&emsp;|&emsp;"+rs.getString("3")+"&emsp;|&emsp;"+rs.getString("4")+"</option>");
 //                                                                    out.write("<option value='"+rs.getString("fileid")+"_"+rs.getString("filename")+"'>"+rs.getString("fileid")+"&emsp;|&emsp;"+rs.getString("filename")+"&emsp;|&emsp;"+rs.getString("filedate")+"&emsp;|&emsp;"+rs.getString("description")+"</option>");
                                                                     out.write("<option value='"+rs.getString("fileid")+"#"+rs.getString("filename")+"'>"+rs.getString("fileid")+"&emsp;|&emsp;"+rs.getString("filename")+"&emsp;|&emsp;"+rs.getString("filedate")+"</option>");
                                                                   
                                                                     }
                                                              }
                                                               out.write("</select>");    
                                                %>
                                            </div>

                                            <div class="form-group col-lg-3" id='expNewFileUpload' style='display: none'>
                                                <label>New FileID<b style='color: red'>*</b></label>
                                                <input class="form-control"  type="text" readonly="readonly" value="<%=DBManager.nextFileId(username)%>" name="expNewfileId">
                                                <label>File Name <b style='color: red'>*</b></label>
                                                <input type="text" class="form-control" value="controlfile.txt" name="expNewFileName">
                                                <label>File Description <b style='color: red'>*</b></label>
                                                <textarea class="form-control" name="expNewFileDesc" rows="1" cols="15" style="resize:none;overflow-y: scroll"></textarea>
                                                <label>Upload New File<b style='color: red'>*</b></label>
                                                <input type="file"  class="form-control"" name="expUploadNewfileName">
                                            </div>

                                            </div> 

                                            <div class="row">
                                            <div class="form-group col-lg-2">
                                                <input type="submit" class="btn btn-default panel panel-green" id='getclient' name='getclient' value="Save Experiment"/> 
                                            </div>
                                            </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                
                                
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" onclick="currentEvent()">Change Accesspoint</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse">
                                        <div class="panel-body">

                                        <%
                                    if(!mySession.isExperimentRunning()){
                                    %>
                                            
                                            <div class="row">


                                            <form action="apchangeStatus.jsp" method="get">

                                            <div class="col-lg-3">
        
                                            <div class="form-group">
                                                <label>SSID<b style='color: red'>*</b></label>
                                                <input class="form-control" type='text' id='ssid'  name='_ssid'/>
                                            </div>

                                            <!--
                                            <div class="form-group">
                                                <label>Security Type<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='security' name='_security'/>
                                                <p class="help-block">example :- eap, wep, open, wpa-psk</p>
                                            </div>
                                            -->

                                            <div class="form-group">
                                                <label>Security Type<b style='color: red'>*</b></label>
                                                <select class="form-control" name='_security' id='security' onchange="apcheck(this)">
                                                    <option value="open" >OPEN</option>
                                                    <option value="wep" >WEP</option>
                                                    <option value="wpa-psk" >WPA-PSK</option>
                                                    <option value="eap" selected="selected">EAP</option>
                                                </select>
                                            </div> 


                                            

                                            <div class="form-group">
                                                <label id='uname'>Username<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='username' name='_username'/>
                                            </div>

                                            <div class="form-group">
                                                <label id='pwd'>Password<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='password' name='_password'/>
                                            </div>


                                          

                                            <div class="form-group">
                                                <label>Timer&nbsp;(Seconds)<b style='color: red'>*</b></label>
                                                <input  class="form-control" type='text' id='bssid' name='_timer'/>
                                            </div>

                                            <div class="form-group">
                                        <input class='btn btn-default' type='submit' value='Send AP Settings'  onclick='return checkFields();'>
                                            </div>
                                        </div>

                                        <div class="col-lg-3">
                                        
                                        <br>
                                        <div class="form-group">
                                        <a style="color: white;text-decoration: none" href="selectClients.jsp?module=changeApSettings" target="_blank" ><button type="button" class="btn btn-primary">Select &nbsp; Clients</button></a>


                                        </div>
                                        <div class="form-group">
                                        <%
                                            if(mySession.isChangeApRunning()){
                                         %>
                                              <a style="color: white;text-decoration: none" target="_blank" href="apchangeStatusDetails.jsp"><button type="button" class="btn btn-primary">View &nbsp; Status</button></a>  
                                        <%
                                            }
                                        %>
                                            
                                        </div>

                                        </div>

                                        



                                        </form>
                                    </div>



                                            <%
                                        }else{
                                            %>
                                              <div class="form-group col-lg-8">
                                                <p style="font-size: 20px;color: red">Experiment [Number : <%=mySession.getLastConductedExpId()%>] &nbsp; Running</p>
                                                <p style="font-size: 20px">&emsp;
                                                <a href="experimentStatus.jsp?expid=<%=mySession.getLastConductedExpId()%>" target="_blank"><button class=" btn btn-primary">View Status</button></a></p>
                                            </div>
                                        <%
                                            }
                                        %>
                                            
                                            
                                        </div>
                                    </div>
                                </div>
                                
                                
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Send Control File</a>
                                        </h4>
                                    </div>




                        <div id="collapseThree" class="panel-collapse collapse">



                                      
                        <div class="panel-body">
                            <!-- Nav tabs -->

                              <%
                                    if(!mySession.isExperimentRunning()){
                                    %>


                            <ul class="nav nav-tabs">
                                <li class="active"><a href="#home" data-toggle="tab">Send New Control File</a>
                                </li>
                                <li><a href="#profile" data-toggle="tab">Reuse Control File</a>
                                </li>
                            </ul>

                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div class="tab-pane fade in active" id="home">
                                    <br>
                                    <form action="sendControlFileStatus.jsp"  method="post"  enctype="multipart/form-data" onsubmit="return check();">
                                    <input type="text" style="visibility: hidden;" name="sendFileOption" value="sendNewFile">
                                        <div class="col-lg-5">
                                            <div class="form-group">
                                                <label>File ID<b style='color: red'>*</b></label>
                                                <b><input type="text" class="form-control" id="newFileId" name="newFileId" style='border: none;' value="<%=DBManager.nextFileId(username)%>" readonly="readonly"></b>
                                            </div>

                                            <div class="form-group">
                                                <label>File Name<b style='color: red'>*</b></label>
                                                <input type="text" class="form-control" id="newFileId" name="newFileName" value="controlfile.txt">
                                            </div>

                                            <div class="form-group">
                                                <label>Upload New File<b style='color: red'>*</b></label>
                                                <input type="file" class="form-control" id="newFileId" name="newFile">
                                            </div>

                                            <div class="form-group">
                                                <label>Description<b style='color: red'>*</b></label>
                                        <textarea name="newFileDesc" class="form-control" rows="1" cols="25" style="resize:none;overflow-y: scroll"></textarea>
                                            </div>
                                            </div>

                                            <br>
                                            <div class="col-lg-5">

                                            <div class="form-group">
                                            <a style="color: white;text-decoration: none" href="selectClients.jsp?module=sendControlFile" target="_blank" ><button type="button" class="btn btn-primary">Select &nbsp; Clients</button></a>
                                            </div>


                                            <div class="form-group">
                                                <label>Number of file send<br/> Per Round<b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" value='5' id='numclients' name='ctrlFileNumClients'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>
                                            <div class="form-group">
                                                <label>Duration between Rounds<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" value='10' id='duration' name='ctrlFileDuration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>


                                            <div class="form-group col-lg-4">
                                                <input  class="form-control" type="submit" value='Send File'/>
                                            </div>
                                            </div>
                                    </form>
                                            <%
                                            if(mySession.getCurrentControlFileId() != null && !mySession.getCurrentControlFileId().equals("")&& mySession.getCurrentControlFileName()!=null && !mySession.getCurrentControlFileName().equals("")){
                                            %>
                                            <div class="col-lg-2">
                                            <div class="form-group">
                                            <a style="color: white;text-decoration: none" href="controlFileStatus.jsp?fileid=<%=mySession.getCurrentControlFileId()%>&filename=<%=mySession.getCurrentControlFileName()%>" target="_blank" ><button type="button" class="btn btn-primary">View &nbsp; Status</button></a>
                                            </div></div>
                                            <%
                                            }
                                            %>
                                </div> 



                                <div class="tab-pane fade" id="profile">
                                <br>
                                    <form action="sendOldControlFileStatus.jsp" method="get">
                                    <input type="text" style="visibility: hidden;" name="sendFileOption" value="sendOldFile">
                                    
                                            <div class="col-lg-5">

                                             <div class="form-group">
                                                <label>Choose File<b style='color: red'>*</b></label>
                                                 <%
                                                ResultSet rs1 = DBManager.getMyControlFiles(username);  
                                                    out.write("<select class='form-control'id='oldFileId' onchange='crtlfileOnchange(this)' name='oldFileId'>");
                                                             out.write("<option value='choosefile' disabled selected='selected'>Choose File</option>");                                 
                                                             if(rs1 != null){
                                                                 while(rs1.next()){
                                                                     out.write("<option value='"+rs1.getString("fileid")+"#"+rs1.getString("filename")+"'>"+rs1.getString("fileid")+"&emsp;|&emsp;"+rs1.getString("filename")+"&emsp;|&emsp;"+rs1.getString("filedate")+"</option>");
                                                                     }

                                                              }
                                                    out.write("</select>");    
                                                %>

                                                
                                            </div>

                                            <div class="form-group" id='selectClientsOldCtrlFile'  style='display: none'>
                                            </div>


                                            <div class="form-group">
                                                <label>Number of file send<br/> Per Round<b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" value='5' id='numclients' name='ctrlFileNumClients'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>

                                            <div class="form-group">
                                                <label>Duration between Rounds<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                                <input  class="form-control" type="text" value='10' id='duration' name='ctrlFileDuration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                            </div>

                                            <div class="form-group">
                                                <input type="submit" class="btn btn-default panel panel-green" id='getclient' name='getclient' value="Send File"/>
                                            </div>
                                            </div>



                                    </form>

                                            <%
                                            if(mySession.getCurrentControlFileId() != null && !mySession.getCurrentControlFileId().equals("")&& mySession.getCurrentControlFileName()!=null && !mySession.getCurrentControlFileName().equals("")){
                                            %>
                                            <div class="col-lg-2">
                                            <div class="form-group">
                                            <a style="color: white;text-decoration: none" href="controlFileStatus.jsp?fileid=<%=mySession.getCurrentControlFileId()%>&filename=<%=mySession.getCurrentControlFileName()%>" target="_blank" ><button type="button" class="btn btn-primary">View &nbsp; Status</button></a>
                                            </div></div>
                                            <%
                                            }
                                            %>



                                </div> 


                            </div>
                            <%
                            }else{
                                %>
                                  <div class="form-group col-lg-8">
                                    <p style="font-size: 20px;color: red">Experiment [Number : <%=mySession.getLastConductedExpId()%>] &nbsp; Running</p>
                                    <p style="font-size: 20px">&emsp;
                                    <a href="experimentStatus.jsp?expid=<%=mySession.getLastConductedExpId()%>" target="_blank"><button class=" btn btn-primary">View Status</button></a></p>
                                </div>
                            <%
                                }
                            %>



                        </div>

                                </div>
                            </div>

                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseFour">Start Experiment</a>
                                        </h4>
                                    </div>
                                    <div id="collapseFour" class="panel-collapse collapse">
                                        <!-- <div class="row"> 
                                        <div class="form-group col-lg-3">
                                            <label>Select</label>
                                            <select name="startOrLoadExp" class="form-control" id="startOrLoadExp" onchange="startExp(this)">
                                                <option value="loadSavedExp">Load Saved Experiment</option>
                                                <option value="createNewExp" selected="selected">Create New Experiment</option>
                                            </select>
                                        </div>
                                        <div class="form-group col-lg-3">
                                            <input type='submit' class='btn btn-default' value='Start Experiment'  onclick='return checkFields();' >
                                        </div>
                                        </div> -->

                                <div class="panel-body">
                                    <!-- Nav tabs -->
                                    <ul class="nav nav-tabs">
                                        <li class="active"><a href="#home2" data-toggle="tab">Start New Experiment</a>
                                        </li>
                                        <li><a href="#profile2" data-toggle="tab">Start Saved Experiment</a>
                                        </li>
                                    </ul>

                                    <!-- Tab panes -->
                                    <div class="tab-content">

                                    
                                    <div class="tab-pane fade  in active" id="home2">
                                    <br>
                                    <%
                                    if(!mySession.isExperimentRunning()){
                                    %>
                                    <form action="startExperiment.jsp" method="get">

                                    <div class="form-group col-lg-2">
                                        <label>Experiment Number</label>
                                        <input class="form-control" type="text" name="expNumber" value='<%=DBManager.getNextExpId(username)%>' readonly="readonly">
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label>Experiment Name<b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" id="expName" name="expName" value="sample exp" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label>Experiment Location</label>
                                        <input class="form-control" type="text" name="expLoc" value="lab"/>
                                    </div>
                                    <div class="form-group col-lg-3">
                                        <label>Description</label>
                                        <textarea class="form-control" name="expDesc" rows="1" cols="15" style="resize:none;overflow-y: scroll"></textarea>
                                    </div>

                                    <div class="rows">
                                    <div class="form-group col-lg-3" >
                                    
                                    <div class="form-group"  id='expOldFileUpload'>
                                                <label  id='OldFIleLabel' >Choose Control File <b style='color: red'>*</b></label>
                                                <%
                                                    ResultSet rs3 = DBManager.getMyControlFiles(username);  
                                                     out.write("<select class='form-control' id='startNewExpSelectFile' onchange='startNewExpCall(this)' name='expfileIdName'>");
                                                             out.write("<option value='choosefile' selected='selected' disabled>Choose File</option>");                                 
                                                             if(rs3 != null){
                                                                 while(rs3.next()){
                                                                    
 //                                                                    out.write("<option value='"+rs.getString("1")+"'>"+rs.getString("1")+"&emsp;|&emsp;"+rs.getString("2")+"&emsp;|&emsp;"+rs.getString("3")+"&emsp;|&emsp;"+rs.getString("4")+"</option>");
 //                                                                    out.write("<option value='"+rs.getString("fileid")+"_"+rs.getString("filename")+"'>"+rs.getString("fileid")+"&emsp;|&emsp;"+rs.getString("filename")+"&emsp;|&emsp;"+rs.getString("filedate")+"&emsp;|&emsp;"+rs.getString("description")+"</option>");
                                                                     out.write("<option value='"+rs3.getString("fileid")+"#"+rs3.getString("filename")+"' id='"+rs3.getString("fileid")+"'>"+rs3.getString("fileid")+"&emsp;|&emsp;"+rs3.getString("filename")+"&emsp;|&emsp;"+rs3.getString("filedate")+"</option>");
                                                                   
                                                                     }
                                                              }
                                                               out.write("</select>");    
                                                %>
                                    </div>

                                    <div class="form-group" id='startNewExpSelectClients'  style='display: none'>
                                    <!-- <a href="selectClients.jsp?module=sendControlFile">Select &nbsp; Clients</a>                                                 -->
                                    </div>

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
                                    }   else{
                                    %>

                                     <div class="form-group col-lg-8">
                                        <p style="font-size: 20px;color: red">Experiment [Number : <%=mySession.getLastConductedExpId()%>] &nbsp; Running</p>
                                        <p style="font-size: 20px"><a href="experimentOver.jsp?stopExp=stopExp"><button class=" btn btn-danger">Stop Experiment</button></a> &emsp;
                                        <a href="experimentStatus.jsp?expid=<%=mySession.getLastConductedExpId()%>" target="_blank"><button class=" btn btn-primary">View Status</button></a></p>

                                         
                                    </div>

                                    <%
                                    }
                                    %>
                                    </div>

                                    <!-- Start saved experiements -->
                                    <div class="tab-pane fade" id="profile2">
                                    <br><br>
                                    

                                    <div class="form-group col-lg-5">

                                    <%
                                    if(!mySession.isExperimentRunning()){
                                    %>

                                    <div class="form-group col-lg-12" id="savedExpDetails">
                                    <label>Choose a Saved experiment <b style='color: red'>*</b></label>
                                       <%
                                            ResultSet rs2 = DBManager.getAllSavedExperimentsDetails(userId);
                                            int count = 0;
                                             out.write("<select class='form-control' id='selectSavedExpId' onchange='selectSavedExp(this)' name='expUploadOldfileName'>");
                                             out.write("<option value='choosefile' selected='selected' disabled>Choose Experiment</option>");  
                                             out.write("<option value='' disabled>ExpID &emsp;|&emsp; ExpName &emsp;|&emsp; Saved Date&emsp;</option>");  

                                              if (rs2 != null) {
                                                   while (rs2.next()) {
                                                    count += 1;
                                                    out.write("<option value='"+rs2.getString(1)+"#"+rs2.getString(5)+"#"+rs2.getString(6)+"'>"+rs2.getString(1)+"&nbsp;&emsp;&emsp;&emsp;|&emsp;"+rs2.getString(2)+"&emsp;|&emsp;"+rs2.getString(7)+"&emsp;</option>");
                                                   }
                                               }

                                               out.write("</select>");
                                                   
                                        %>                                      
                                    </div>

                                    <div class="form-group col-lg-12" id='loadSavedExp' > </div>
                                    </div>


                                    <br>
                                  <div class="form-group row" id='displaySavedExpDetails'>
                                   
                                 <!--    <div class="form-group col-lg-4" >
                                    <div class="form-group">
                                        <label>Experiment Number</label>
                                        <input class="form-control" type="text" name="expNumber" value='<%=DBManager.getNextExpId(username)%>' readonly="readonly">
                                    </div>
                                    <div class="form-group">
                                        <label>Experiment Name<b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" id="expName" name="expName" value="sample exp" /><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    <div class="form-group">
                                        <label>Experiment Location</label>
                                        <input class="form-control" type="text" name="expLoc" value="lab"/>
                                    </div>
                                    <div class="form-group">
                                        <label>Description</label>
                                        <textarea class="form-control" name="expDesc" rows="1" cols="15" style="resize:none;overflow-y: scroll"></textarea>
                                    </div>
                                    </div>
                                      
                                    <div class="form-group col-lg-4" >  
                                    <div class="form-group"  id='expOldFileUpload'>
                                                <label  id='OldFIleLabel' >Choose Control File <b style='color: red'>*</b></label>
                                                <%
                                                    ResultSet rs4 = DBManager.getControlFileInfo(username);  
                                                     out.write("<select class='form-control' id='startNewExpSelectFile' onchange='startNewExpCall(this)' name='expUploadOldfileName'>");
                                                             out.write("<option value='choosefile' selected='selected' disabled>Choose File</option>");                                 
                                                             if(rs4 != null){
                                                                 while(rs4.next()){
                                                                     out.write("<option value='"+rs4.getString("fileid")+"' id='"+rs4.getString("fileid")+"'>"+rs4.getString("fileid")+"&emsp;|&emsp;"+rs4.getString("filename")+"&emsp;|&emsp;"+rs4.getString("filedate")+"</option>");
                                                                   
                                                                     }
                                                              }
                                                               out.write("</select>");    
                                                %>
                                    </div>
                                    <div class="form-group" id='startNewExpSelectClients'  style='display: none'>
                                    </div>
                                    <div class="form-group">
                                        <label>Number of file send<br/> Per Round<b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" value='5' id='numclients' name='ctrlFileNumClients'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    <div class="form-group">
                                        <label>Duration between Rounds<br><i>(in seconds)</i><b style='color: red'>*</b></label>
                                        <input  class="form-control" type="text" value='10' id='duration' name='ctrlFileDuration'/><i style='color:red;display: none' id='error'>Field Cannot be Empty</i>
                                    </div>
                                    <div class="form-group">
                                        <input type="submit" class="btn btn-default panel panel-green" id='getclient' name='startExp' value="Start Experiment"/>
                                    </div>
                                    </div> -->
                                    <%
                                }else{
                                    %>

                                      <div class="form-group col-lg-8">
                                        <p style="font-size: 20px;color: red">Experiment [Number : <%=mySession.getLastConductedExpId()%>] &nbsp; Running</p>
                                        <p style="font-size: 20px">&emsp;
                                        <a href="experimentStatus.jsp?expid=<%=mySession.getLastConductedExpId()%>" target="_blank"><button class=" btn btn-primary">View Status</button></a></p>

                                         
                                    </div>

                                <%
                                    }
                                %>

                                  </div>
                                    </div>









                                </div>
                            </div>
                        </div>


                                </div>
                            </div>
                        </div>
                        <!-- .panel-body -->
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-9 -->
                
                

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
            }
            }
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


        
            function selectSavedExp(){
              //  alert(document.getElementById("selectSavedExpId").value);
                // document.getElementById('displaySavedExpDetails').style.display = 'block';

                var expid_fileid_arr = (document.getElementById("selectSavedExpId").value).split("#");

                document.getElementById('loadSavedExp').innerHTML = "<br><a style='color: white;text-decoration: none' href='loadExperiment.jsp?expid="+expid_fileid_arr[0]+"&fileid="+expid_fileid_arr[1]+"&filename="+expid_fileid_arr[2]+"' ><button type='button' class='btn btn-primary'>Load &nbsp; Experiment</button></a>";

            }


 //startNewExpSelectFile startNewExpSelectClients

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
 // startExp startOrLoadExp loadSavedExp createNewExp savedExpDetails

            function crtlfileOnchange(){
                // <a href="selectClients.jsp?module=sendControlFile">Select &nbsp; Clients</a>                                                 -->
                // alert(document.getElementById('oldFileId').value);
                if(document.getElementById('oldFileId').value == "choosefile"){
                    document.getElementById('selectClientsOldCtrlFile').style.display = 'none';
                }else{
                    document.getElementById('selectClientsOldCtrlFile').style.display = 'block';
                    document.getElementById('selectClientsOldCtrlFile').innerHTML = "<a style='color: white;text-decoration: none' href='selectClients.jsp?module=reUseControlFile&fileid="+document.getElementById('oldFileId').value+"' target='_blank'  ><button type='button' class='btn btn-primary'>Select &nbsp; Clients</button></a>";

                }
            } 


            function startExp(){
                if(document.getElementById('startOrLoadExp').value == "loadSavedExp"){
                    document.getElementById('savedExpDetails').style.display = 'block';
                }else if(document.getElementById('startOrLoadExp').value == "createNewExp"){
                    document.getElementById('savedExpDetails').style.display = 'none';
                }
            }
     
            function expCheck() {

                if(document.getElementById('OldorNew').value == "chooseFileLater"){
                    document.getElementById('expOldFileUpload').style.display = 'none';
                    document.getElementById('expNewFileUpload').style.display = 'none';
                }else if(document.getElementById('OldorNew').value == "expselectNewFile"){
                    document.getElementById('expOldFileUpload').style.display = 'none';
                    document.getElementById('expNewFileUpload').style.display = 'block';
                }else if(document.getElementById('OldorNew').value == "expselectOldFile"){
                    document.getElementById('expOldFileUpload').style.display = 'block';
                    document.getElementById('expNewFileUpload').style.display = 'none';
                }
            }

            function _sendFile(){

                // alert(document.getElementById('selectClientsNewCtrlFile').style.display);
                // alert(document.getElementById('selectClientsOldCtrlFile').style.display);

                if (document.getElementById('sendFile').value == "sendNewFile") {
                        document.getElementById('chooseOldFileLabel').style.display = 'none';
                        document.getElementById('chooseNewFileId').style.display = 'block';
                        // document.getElementById('chooseNewFileUpload').style.display = 'block';
                        // document.getElementById('chooseNewFileName').style.display = 'block';

                        document.getElementById('selectClientsNewCtrlFile').style.display = 'block';
                        document.getElementById('selectClientsOldCtrlFile').style.display = 'none';

                        // selectClientsOldCtrlFile

                    // document.getElementById('chooseOldFileLabel').style.display = 'none';
                    // document.getElementById('oldFileId').style.display = 'none';
                    // document.getElementById('chooseNewFileLabel').style.display = 'block';
                    // document.getElementById('newFileId').style.display = 'block';  

                }else if (document.getElementById('sendFile').value == "sendOldFile") {
                        document.getElementById('chooseOldFileLabel').style.display = 'block';
                        document.getElementById('chooseNewFileId').style.display = 'none';
                        // document.getElementById('chooseNewFileUpload').style.display = 'none';
                        // document.getElementById('chooseNewFileName').style.display = 'none';
                        

                        document.getElementById('selectClientsNewCtrlFile').style.display = 'none';
                        // document.getElementById('selectClientsOldCtrlFile').style.display = 'block';

                    // document.getElementById('chooseOldFileLabel').style.display = 'block';   
                    // document.getElementById('oldFileId').style.display = 'block';
                    // document.getElementById('chooseNewFileLabel').style.display = 'none';
                    // document.getElementById('newFileId').style.display = 'none';  

                }

            }

            function apcheck(){
                //alert(document.getElementById('security').value);

                if(document.getElementById('security').value=='open'){
                    document.getElementById('username').style.display = 'none';
                    document.getElementById('password').style.display = 'none';
                    document.getElementById('uname').style.display = 'none';
                    document.getElementById('pwd').style.display = 'none';
                }else if(document.getElementById('security').value=='wep'){
                    document.getElementById('username').style.display = 'none';
                    document.getElementById('password').style.display = 'block';
                    document.getElementById('uname').style.display = 'none';
                    document.getElementById('pwd').style.display = 'block';
                }else if(document.getElementById('security').value=='wpa-psk'){
                    document.getElementById('username').style.display = 'none';
                    document.getElementById('password').style.display = 'block';
                    document.getElementById('uname').style.display = 'none';
                    document.getElementById('pwd').style.display = 'block';
                }else if(document.getElementById('security').value=='eap'){
                    document.getElementById('username').style.display = 'block';
                    document.getElementById('password').style.display = 'block';
                    document.getElementById('uname').style.display = 'block';
                    document.getElementById('pwd').style.display = 'block';

                }
            }

            function _check() {
                //   alert(document.getElementById('filter').value);
                if (document.getElementById('filter').value == "bssid") {
                    document.getElementById('selectonbssid').style.display = 'block';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('random').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';
                } else if (document.getElementById('filter').value == "ssid") {
                    document.getElementById('selectonssid').style.display = 'block';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('random').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';
                } else if (document.getElementById('filter').value == "manual") {

                    document.getElementById('random').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';

                } else if (document.getElementById('filter').value == "random") {
                    document.getElementById('random').style.display = 'block';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('getclient').style.display = 'block';
                } else {
                    document.getElementById('random').style.display = 'none';
                    document.getElementById('selectonssid').style.display = 'none';
                    document.getElementById('selectonbssid').style.display = 'none';
                    document.getElementById('getclient').style.display = 'none';
                }
            }


        </script>
        
        
        
        
        
        
        
        
        
        
        
        
    </body>
</html>
