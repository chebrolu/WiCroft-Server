<%-- 
    Document   : signup
    Created on : 10 Jun, 2017, 6:03:40 PM
    Author     : ratheeshkv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>



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

    <!-- Custom Fonts -->
    <link href="/wicroft/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <br/><br/>    <br/><br/>

    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                
                <div class="login-panel panel panel-default">

                    <div class="panel-heading">
                        <h3 class="panel-title" style="align-content: center;"><img src="/wicroft/images/wicroft-web.png" alt="Wicroft" height="42" width="42"/> &emsp;WiCroft Application - SERVER</h3>
                    </div>
                    <div class="panel-body">
                        
                        <form role="form"  action="accountSettings.jsp?action=signup" method="post" onsubmit="return checkFields()">
                            <fieldset>
                                <div class="form-group">
                                   New Username <b style="color: red">*</b><input class="form-control" placeholder="Username (max 8 characters [digits, alphabets])" id='newusername' name="newusername" type="text" autofocus>
                                </div>
                                <div class="form-group">
                                    Password <b style="color: red">*</b><input class="form-control" placeholder="Password" id='newpassword' name="newpassword" type="password" value="">
                                </div>

                                <div class="form-group">
                                    Re-enter Password <b style="color: red">*</b><input class="form-control" placeholder="Password" id='pwd' name="pwd" type="password" value="">
                                </div>
                               
                                <input class="btn btn-lg btn-success btn-block" type="submit" value="Sign Up">
                                <div class="form-group" style="text-align: center;padding-top:8px;">
                                <a href="login.jsp">Login</a>
                                </div>
                            </fieldset>
                        </form>
                    </div>


                    <div>
                        <% 
                        String status =  request.getParameter("status");
                        if(status != null && !status.trim().equals("")){
                        int statusCode =  Integer.parseInt(status);
                        String message = "";
                        boolean success = false;
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
                                <div class="col-lg-12 alert alert-success alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%
                                out.write(message);
                                %>  
                                </div>
                            <%
                            }else{
                            %>
                                <div class="col-lg-12 alert alert-danger alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                                <%
                                out.write(message);
                                %>  
                                </div>
                            <%
                            }
                            
                        }

                        %>
                    </div>

                </div>
                    
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="/wicroft/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/wicroft/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/wicroft/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/wicroft/dist/js/sb-admin-2.js"></script>
    
<!--          <script type="text/javascript">
            $(document).ready(function () {
                $('#links').load('navigation.html');
                refresh();

            });
        </script>-->

        <script type="text/javascript">
            
        function checkFields(){

            if(document.getElementById('newusername').value==null || document.getElementById('newusername').value=="" || 
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

            document.getElementById('newusername').value
            //document.getElementById('newpassword').value
            //document.getElementById('pwd').value

            return true;
        }
        </script>
</body>
</html>

