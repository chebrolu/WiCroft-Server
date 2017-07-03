<%-- 
    Document   : saveExperiment
    Created on : 7 Jun, 2017, 2:48:35 AM
    Author     : ratheeshkv
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Wicroft</title>
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
            int userId = DBManager.getUserId(username);
            int expid = DBManager.getNextExpId(username);
            String expNumber = "";
            String expName = "";
            String expLoc = "";
            String expDesc  = "";
            String OldorNew  = "";// chooseFileLater expselectNewFile expselectOldFile
            String expUploadOldfileName = "";    
            String expUploadNewfileName = "";
            String expNewfileId = "";
            String expNewFileName = "";
            String expNewFileDesc = "";
            int saveExpStatus = -1;

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

                       if (item.getFieldName().equals("expNumber")) {
                           expNumber = item.getString();
                       } else if(item.getFieldName().equals("expName")){
                           expName = item.getString();
                       } else if(item.getFieldName().equals("expLoc")){
                           expLoc =  item.getString();
                       }else if (item.getFieldName().equals("expDesc")) {
                           expDesc = item.getString();                            
                       } else if (item.getFieldName().equals("OldorNew")) {
                           OldorNew = item.getString();
                       } else if (item.getFieldName().equals("expUploadOldfileName")) {
                           expUploadOldfileName = item.getString();
                       }  else if (item.getFieldName().equals("expUploadNewfileName")) {
                           expUploadNewfileName = item.getString();
                       } else if (item.getFieldName().equals("expNewfileId")) {
                           expNewfileId = item.getString();
                       } else if (item.getFieldName().equals("expNewFileName")) {
                           expNewFileName = item.getString();
                       } else if (item.getFieldName().equals("expNewFileDesc")) {
                           expNewFileDesc = item.getString();
                       } 

                   } else {
                       
                            if(OldorNew.equalsIgnoreCase("expselectNewFile")){
                            if (Constants.experimentDetailsDirectory.endsWith("/")) {
                                file = new File(Constants.experimentDetailsDirectory +username+"/"+ Constants.controlFile+"/"+expNewfileId);
                            } else {
                                file = new File(Constants.experimentDetailsDirectory + "/"+username+"/"+ Constants.controlFile+"/"+expNewfileId);
                            }

                            if (!file.exists()) {
                                file.mkdirs();
                            }

                            if(!expNewFileName.endsWith(".txt")){
                                expNewFileName = expNewFileName+".txt";            
                            }       
                            if (item.getName() != null) {
                                out.write("<br>Location  : "+item.getName()+" "+expNewFileName);
                                file = new File(file.getAbsolutePath() + "/"+expNewFileName);                                
                                item.write(file);
                            }
                            // Update to DB
                                DBManager.addControlFileInfo(expNewFileName, expNewFileDesc, username, expNewfileId); ;
                            }
                    }
                 }
               
               if(OldorNew.equalsIgnoreCase("expselectOldFile")){
                   String fid_fname []= expUploadOldfileName.split("#");
                   expNewfileId = fid_fname[0];
                   expNewFileName = fid_fname[1];
                   Experiment exp = new Experiment(userId,expid, expName, expLoc, expDesc, Integer.parseInt(expNewfileId), expNewFileName, 0);
                   saveExpStatus = DBManager.saveExperiment(exp);
               }else if(OldorNew.equalsIgnoreCase("expselectNewFile")){
                   Experiment exp = new Experiment(userId,expid,expName, expLoc, expDesc,  Integer.parseInt(expNewfileId), expNewFileName, 0);
                   saveExpStatus = DBManager.saveExperiment(exp);
               }else if(OldorNew.equalsIgnoreCase("chooseFileLater")){
                   Experiment exp = new Experiment(userId,expid, expName, expLoc, expDesc,-1, "nofile", 0);
                   saveExpStatus = DBManager.saveExperiment(exp);                   
               }
               
// Experiment(int userid,String name,String location,String description,int fileid,String filename,int status,int expid)               
// insert into experiments(userid,name,location,description,fileid,filename,status,expid,creationtime) values()               
               
             } catch (FileUploadException ex) {
                 out.write(ex.toString());
             } catch (Exception ex) {
                 out.write(ex.toString());
             }
            
           response.sendRedirect("configExperiment.jsp?saveExpStatus="+saveExpStatus);

        }}

        %>
    </body>
</html>
