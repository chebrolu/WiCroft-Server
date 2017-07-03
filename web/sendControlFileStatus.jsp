<%-- 
    Document   : sendControlFileStatus
    Created on : 17 Jan, 2017, 9:23:16 PM
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
            String sendFileOption = "";
            String oldFileName = "";
            String newFileId = "";
            String newFile = "";
            String newFileName = "";
            String ctrlFileNumClients = "";
            String ctrlFileDuration = "";
            String newFileDesc = "";

                boolean multipart = ServletFileUpload.isMultipartContent(request);
                DiskFileItemFactory factory = new DiskFileItemFactory();
                factory.setSizeThreshold(50 * 1024 * 1024);
                File file;//= new File("/home/cse/Desktop/");
                ServletFileUpload upload = new ServletFileUpload(factory);
                upload.setSizeMax(50 * 1024 * 1024);

                try {
                    List fileitem = upload.parseRequest(request);
                    Iterator itr = fileitem.iterator();
                    int index = 0;
                    while (itr.hasNext()) {

                        FileItem item = (FileItem) itr.next();

                        if (item.isFormField()) {
                            
                            if (item.getFieldName().equals("sendFileOption")) {
                                sendFileOption = item.getString();
                            } else if(item.getFieldName().equals("ctrlFileNumClients")){
                                ctrlFileNumClients = item.getString();
                            } else if(item.getFieldName().equals("ctrlFileDuration")){
                                ctrlFileDuration =  item.getString();
                            }else if (item.getFieldName().equals("oldFileName")) {
                                oldFileName = item.getString();                            
                            } else if (item.getFieldName().equals("newFileId")) {
                                newFileId = item.getString();
                            } else if (item.getFieldName().equals("newFileName")) {
                                newFileName = item.getString();
                            } else if (item.getFieldName().equals("newFileDesc")) {
                                newFileDesc = item.getString();
                            }
                            
                        } else {
                            if (Constants.experimentDetailsDirectory.endsWith("/")) {
                                file = new File(Constants.experimentDetailsDirectory +username+"/"+ Constants.controlFile+"/"+newFileId);
                            } else {
                                file = new File(Constants.experimentDetailsDirectory + "/"+username+"/"+ Constants.controlFile+"/"+newFileId);
                            }

                            if (!file.exists()) {
                                file.mkdirs();
                            }
                            
                            if(!newFileName.endsWith(".txt")){
                                newFileName = newFileName+".txt";            
                            }       

                            if (item.getName() != null) {
                                out.write("<br>Location  : "+item.getName()+" "+newFileName);
                                file = new File(file.getAbsolutePath() + "/"+newFileName);                                
                                item.write(file);
                            }
                        }
                    }
                } catch (FileUploadException ex) {
                    out.write(ex.toString());
                } catch (Exception ex) {
                    out.write(ex.toString());
                }

                
                if(sendFileOption.equalsIgnoreCase("sendNewFile")){
                    DBManager.addControlFileInfo(newFileName, newFileDesc, username, newFileId); ;
                }
                
                 if(sendFileOption.equalsIgnoreCase("sendOldFile")){
                    String [] file1 = oldFileName.split("#");
                    newFileId = file1[0];
                    newFileName = file1[1];
                }

                

                Utils.sendControlFile(newFileId,newFileName,ctrlFileNumClients,ctrlFileDuration,username,mySession);
                response.sendRedirect("controlFileStatus.jsp?fileid="+newFileId+"&filename="+newFileName);


        }}

        %>
    </body>
</html>

