<%-- 
    Document   : startExpStatus
    Created on : 18 Jan, 2017, 2:00:11 AM
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
            
            
            response.setIntHeader("refresh", 5); 
            
            out.write("<h2>Experiment No. "+Constants.currentSession.getCurrentExperimentId()+"</h2>");
            
                String file_name = null;
                String file_id = null;
                String exp_name = null;
                String exp_loc = null;
                String exp_desc = null;
                Vector<String> selectedClients = new Vector<String>();
                int exp_number = 0;
                String timeout = null;
                String logBgTraffic = null;
                String expBuffTime = null, nbrReq = null, roundDur = null;

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
                            out.write("<br/>Name : " + item.getFieldName());

                            if (item.getFieldName().equals("file_name")) {
                                String[] file1 = item.getString().split("_");                                
                                file_name = file1[1];
                                file_id = file1[0];
                            } else if (item.getFieldName().equals("exp_name")) {
                                exp_name = item.getString();
                            } else if (item.getFieldName().equals("exp_loc")) {
                                exp_loc = item.getString();
                            } else if (item.getFieldName().equals("exp_desc")) {
                                exp_desc = item.getString();
                            } else if (item.getFieldName().equals("expBuffTime")) {
                                expBuffTime = item.getString();
                            } else if (item.getFieldName().equals("nbrReq")) {
                                nbrReq = item.getString();
                            } else if (item.getFieldName().equals("roundDur")) {
                                roundDur = item.getString();
                            } else if (item.getFieldName().equals("selectedclient")) {
                                selectedClients.add(item.getString());
                                index++;
                            } else if (item.getFieldName().equals("exp_number")) {
                                exp_number = Integer.parseInt(item.getString());
                            } else if (item.getFieldName().equals("timeout")) {
                                timeout =  item.getString();
                            } else if (item.getFieldName().equals("bglog")) {
                                logBgTraffic =  item.getString();
                            }
                            
                            
                        }
                    }
                } catch (FileUploadException ex) {
                    out.write(ex.toString());
                } catch (Exception ex) {
                    out.write(ex.toString());
                }

                
                Experiment experiment = new Experiment(exp_number, exp_name, exp_loc, exp_desc);

                if (DBManager.addExperiment(experiment, file_id, file_name)) {
                    System.out.println("<br/>DB Succss : Experiment added");
                } else {
                    System.out.println("<br/>DB Failed : Adding Experiment Failed");
                }                
                
                if (Constants.experimentDetailsDirectory.endsWith("/")) {
                    file = new File(Constants.experimentDetailsDirectory + exp_number);
                } else {
                    file = new File(Constants.experimentDetailsDirectory + "/" + exp_number);
                }

                if (!file.exists()) {
                    file.mkdirs();
                }
                
                System.out.println("Exp Directory : "+file+" Created");
                            
                Constants.currentSession.getFilteredClients().clear();

                if (selectedClients != null) {
                    for (int i = 0; i < selectedClients.size(); i++) {
                        out.write("<br/> Client " + (i + 1) + selectedClients.get(i));
                        Constants.currentSession.getFilteredClients().add(Constants.currentSession.getConnectedClients().get(selectedClients.get(i)));
                    }
                } else if (session.getAttribute("filter").equals("random")) {
                    Enumeration<String> mac_list = Constants.currentSession.getConnectedClients().keys();
                    int i = 0;
                    while (mac_list.hasMoreElements() && i < (Integer) session.getAttribute("clientcount")) {
                        Constants.currentSession.getFilteredClients().add(Constants.currentSession.getConnectedClients().get(mac_list.nextElement()));
                        i++;
                    }
                }
  
                if(Utils.startExp(experiment.getNumber(), expBuffTime, nbrReq, roundDur, timeout,logBgTraffic,file_id)){
                    
                    Constants.currentSession.setExperimentRunning(true);
                    Constants.currentSession.setCurExperiment(experiment);
                    response.sendRedirect("experimentStatus.jsp");
                    
                }else{
                    out.write("<h2>Starting Experiment Failed</h2>");
                    Constants.currentSession.setExperimentRunning(false);
                     response.sendRedirect("failedExperiment.jsp");
                    
                }

        %>
    </body>
</html>

