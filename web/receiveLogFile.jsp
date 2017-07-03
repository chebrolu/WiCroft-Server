<%-- 
    Document   : processAction
    Created on : 22 Jul, 2016, 3:12:54 PM
    Author     : ratheeshkv
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="com.iitb.cse.*" %>

<%

    String expID = null, macAddress = null;

    File file;
    int maxFileSize = 100 * 1024 * 1024;
    int maxMemSize = 100 * 1024 * 1024;
    String filePath = Constants.experimentDetailsDirectory;
    String oldAppLogs = "";
   

    String expDir = "";
    // Verify the content type
    String contentType = request.getContentType();
    if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) {

        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(100 * maxFileSize);

//        factory.setRepository(100 * maxFileSize);
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(maxFileSize);
        try {
            List fileItems = upload.parseRequest(request);

            Iterator i = fileItems.iterator();

            while (i.hasNext()) {

                FileItem fi = (FileItem) i.next();
                if (fi.isFormField()) {

                    String fieldName = fi.getFieldName();
                    String fieldValue = fi.getString();
                    System.out.println("File Upload :=>  Field name: " + fieldName + ", Field value: " + fieldValue);

                    if (fieldName.equals(Constants.getExpID())) {
                        expID = fieldValue;
                    } else if (fieldName.equals(Constants.getMacAddress())) {
                        macAddress = fieldValue;
                    }
                }
            }

            if (expID == null || macAddress == null) {
                System.out.println("File Upload :=> Error while getting parameters");
            } else {

                expDir = filePath;
                File theDir = new File(filePath);
                if (!theDir.exists()) {
                    theDir.mkdirs();
                }
                
                System.out.println("Location : "+theDir.getAbsolutePath());
                System.out.println("Exp ID  : "+expID);
                System.out.println("MacAddress : "+macAddress);
                
                if (!expID.contains("Debug_logs") && !expID.contains("ConnectionLog") ) {
                    // expID = uid_expid
                    String []uid_expid = expID.split("_");
                    
                    if(uid_expid.length==2){  // New app 
                            String username = DBManager.getUserName(Integer.parseInt(uid_expid[0]));
                            expID =  uid_expid[1];

                            if (DBManager.updateFileReceivedField(Integer.parseInt(expID), macAddress,Integer.parseInt(uid_expid[0]))) {
                                System.out.println("File Upload :=> " + expID + " Successfully");
                            } else {
                                System.out.println("Upload Fil DB update failed");
                                response.setStatus(response.SC_REQUEST_URI_TOO_LONG);
                                System.out.println("File Upload :=>  Failed");
                            }
                            

                    
                     if (filePath.endsWith("/")) {
                        filePath = filePath +username+"/expLogs/"+expID + "/";
                    } else {
                        filePath = filePath + "/" + username+"/expLogs/"+expID + "/";
                    }
                    
                    theDir = new File(filePath);
                    if (!theDir.exists()) {
                        theDir.mkdirs();
                    }
                    
                     i = fileItems.iterator();

                    String fileName = "";

                    while (i.hasNext()) {
                        FileItem fi = (FileItem) i.next();
                        if (!fi.isFormField()) {
                            fileName = macAddress;
                            boolean isInMemory = fi.isInMemory();
                            long sizeInBytes = fi.getSize();
                            if (fileName.lastIndexOf("\\") >= 0) {
                                file = new File(filePath
                                        + fileName.substring(fileName.lastIndexOf("\\")));
                            } else {
                                file = new File(filePath
                                        + fileName.substring(fileName.lastIndexOf("\\") + 1));
                            }
                            fi.write(file);
                        }
                    }

                    System.out.println("File Upload :=> " + expID + "(debug) " + macAddress + " Successfully");
                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddress);
                    System.out.println("Device : "+device);
                    device.setLogFileReceived(true);
                    String details = device.getDetails();
                    details += " , Received [" + expID + "]";
                    System.out.println("\nDetails : " + details);
                    device.setDetails(details);
                }else { // old app
                        System.out.println("File Upload[Old App] :=> " + expID + "(debug) " + macAddress + " Failed");
                        response.setStatus(response.SC_REQUEST_URI_TOO_LONG);
                    }


                } else { //  Dedug and connection logs

                    if (filePath.endsWith("/")) {
                        filePath = filePath + expID + "/";
                    } else {
                        filePath = filePath + "/" + expID + "/";
                    }
                    
                    theDir = new File(filePath);
                    if (!theDir.exists()) {
                        theDir.mkdirs();
                    }
                    
                    i = fileItems.iterator();

                    String fileName = "";

                    while (i.hasNext()) {
                        FileItem fi = (FileItem) i.next();
                        if (!fi.isFormField()) {
                            fileName = macAddress;
                            boolean isInMemory = fi.isInMemory();
                            long sizeInBytes = fi.getSize();
                            if (fileName.lastIndexOf("\\") >= 0) {
                                file = new File(filePath
                                        + fileName.substring(fileName.lastIndexOf("\\")));
                            } else {
                                file = new File(filePath
                                        + fileName.substring(fileName.lastIndexOf("\\") + 1));
                            }
                            fi.write(file);
                        }
                    }
    
                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddress.split("_")[0]);
                    System.out.println("Device : "+device);
                    device.setLogFileReceived(true);
                    String details = device.getDetails();
                    details += " , Received [" + expID + "]";
                    System.out.println("\nDetails : " + details);
                    device.setDetails(details);
                    System.out.println("File Upload :=> " + expID + "(debug) " + macAddress + " Successfully");
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.setStatus(response.SC_REQUEST_URI_TOO_LONG);
            
            System.out.println(ex);
        }
} 

%>
 