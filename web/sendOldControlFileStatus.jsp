<%-- 
    Document   : sendOldControlFileStatus
    Created on : 8 Jun, 2017, 1:31:56 AM
    Author     : ratheeshkv
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="java.util.logging.Level"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="com.iitb.cse.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wicroft</title>
        <link rel="stylesheet" href="/wicroft/css/table.css">
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

            out.write(request.getParameter("ctrlFileNumClients")+"<br>");    
            out.write(request.getParameter("ctrlFileDuration")+"<br>");    
            out.write(request.getParameter("oldFileId")+"<br>");    

    //  String fileid, String file_name, String newOrOld, String numclients, String duration, String username, Session mySession)        

            String val [] = request.getParameter("oldFileId").split("#");

            String newFileId = val[0];
            String newFileName = val[1];
            String sendFileOption = "old";
            String ctrlFileNumClients = request.getParameter("ctrlFileNumClients");
            String ctrlFileDuration = request.getParameter("ctrlFileDuration");
            //Utils.sendOldControlFile(newFileId,newFileName,ctrlFileNumClients,ctrlFileDuration,username,mySession);
            Utils.sendControlFile(newFileId,newFileName,ctrlFileNumClients,ctrlFileDuration,username,mySession);
            response.sendRedirect("controlFileStatus.jsp?fileid="+newFileId+"&filename="+newFileName);
            }}

        %>
        
    </body>
</html>
