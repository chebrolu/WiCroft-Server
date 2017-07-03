

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
<html>
    <head>
        <Title>Just A Test</Title>
        <script type="text/javascript" src="jquery.min.js"></script>
        <script type="text/javascript">
        var auto_refresh = setInterval(
        function ()
        {
        $('#load_me').load('time.jsp?module=test').fadeIn("slow");
        }, 1000); // autorefresh the content of the div after
                   //every 1000 milliseconds(1sec)
        </script>
   </head>
    <body>
    Time : <div id="load_me"> <%@ include file="time.jsp" %></div>
    random stuff random stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuff
    random stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuff
    random stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuffrandom stuff
    </body>
</html>