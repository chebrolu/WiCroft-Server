<%-- 
    Document   : deviceInformation
    Created on : 7 Oct, 2016, 8:00:12 PM
    Author     : ratheeshkv
--%>

<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.ServletOutputStream" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import= "java.io.File" %>


<%
    String path = (String) request.getParameter("path");
    String fileid = (String) request.getParameter("fileid");
    String name = (String) request.getParameter("name");

    String filename = path + "" + fileid + "/" + name;
    System.out.println("File name : "+filename);

    response.setHeader("Content-Disposition", "attachment;filename=" + fileid + "-" + name);

    File file = new File(filename);
    FileInputStream fileIn = new FileInputStream(file);
    ServletOutputStream out1 = response.getOutputStream();

    IOUtils.copy(fileIn, out1);

    fileIn.close();
    out1.flush();
    out1.close();

%>

