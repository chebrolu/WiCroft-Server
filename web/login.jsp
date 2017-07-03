<%-- 
    Document   : login
    Created on : 12 Jul, 2016, 10:37:30 PM
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
                
                
                <% 
                  if (session.getAttribute("currentUser") == null) {
                 %>  
                
                <div class="login-panel panel panel-default">

                    <div class="panel-heading">
                        <h3 class="panel-title" style="align-content: center;"><img src="/wicroft/images/wicroft-web.png" alt="Wicroft" height="42" width="42"/> &emsp;WiCroft Application - SERVER</h3>
                    </div>
                    <div class="panel-body">
                        
                    
                        
                        <form role="form"  action="authenticate.jsp" method="post">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" placeholder="username" name="name" type="text" autofocus>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" placeholder="Password" name="pwd" type="password" value="">
                                </div>
                                <div class="form-group">
                                    <label>
                                        <a href="signup.jsp">Sign Up</a>
                                    </label>
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <input class="btn btn-lg btn-success btn-block" type="submit" value="Login">
                                <!--<a href="authenticate.jsp" class="btn btn-lg btn-success btn-block">Login</a>-->
                            </fieldset>
                        </form>
                    </div>
                    
                    <div>
                        <% 
                        String loginStatus = request.getParameter("loginStatus");
                        if(loginStatus != null){
                           if(loginStatus.equalsIgnoreCase("wrong_credentials")){
                                out.write("<b style='color:red;'>Wrong Credentials</b>");
                            }else if(loginStatus.equalsIgnoreCase("db_exception")){
                                out.write("<b style='color:red;'>Database Exception, Login Failed</b>");
                            }else{
                            }
                        }
                        %>
                    </div>

                </div>
                      
                 <%
                     
                  } else{
                      response.sendRedirect("frontpage.jsp");
                  }
                
                %>
                    
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
        </script>
-->

</body>

</html>








