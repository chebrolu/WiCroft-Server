/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iitb.cse;

import static com.iitb.cse.ClientConnection.acceptConnection;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Enumeration;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.Getter;
import lombok.Setter;
import org.apache.log4j.BasicConfigurator;

import org.apache.log4j.PropertyConfigurator;
import java.io.File;

/**
 *
 * @author cse
 */
public class initilizeServer extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    public static ServerSocket listenSocket = null;
    public static int threadNo = 0;

    @Getter
    @Setter
    public static DBManager dbManager = null;
    @Getter
    @Setter
    public static ConcurrentHashMap<String, DeviceInfo> allConnectedClients;
    @Getter
    @Setter
    public static ConcurrentHashMap<String, String> allBssidInfo;
    @Getter
    @Setter
    public static ConcurrentHashMap<String, Session> UserNameToSessionMap;
    @Getter
    @Setter
    public static ConcurrentHashMap<String, Integer> UserNameToInstacesMap;
    public static org.apache.log4j.Logger logger;

    @Getter
    @Setter
    public static long startwakeUpDuration = 0;
    @Getter
    @Setter
    public static long wakeUpDuration = 0;
    @Getter
    @Setter
    public static String wakeUpFilter = "";
    @Getter
    @Setter
    public static ConcurrentHashMap<String, Integer> wakeUpClients = new ConcurrentHashMap<String, Integer>();
    @Getter
    @Setter
    public static ConcurrentHashMap<String, String> wakeUpTimerFilteredClients = new ConcurrentHashMap<String, String>();

    /*
        This function will be called once the apache tomcat server starts...
     */
    public void init() throws ServletException {

        /*
            Logger configuration : see log4j.properties for configuration informations
         */
        BasicConfigurator.configure();;
        logger = org.apache.log4j.Logger.getLogger(initilizeServer.class);

        if (!Constants.logfileLocation.endsWith("/")) {
            Constants.logfileLocation = Constants.logfileLocation + "/";
        }
        // specify path for log4j location
        String log4jConfigFile = Constants.logfileLocation + "log4j.properties";
        PropertyConfigurator.configure(log4jConfigFile);

        logger.info("***********Wicroft Server starting...************");
        allConnectedClients = new ConcurrentHashMap<String, DeviceInfo>();
        allBssidInfo = new ConcurrentHashMap<String, String>();
        UserNameToSessionMap = new ConcurrentHashMap<>();
        UserNameToInstacesMap = new ConcurrentHashMap<>();


        /*
            Creating Wicroft experiment directory
         */
        File dir = new File(Constants.experimentDetailsDirectory);
        if (!dir.exists()) {
            try {
                dir.mkdirs();
                logger.info("Wicroft Directory : " + Constants.experimentDetailsDirectory + " Created");
            } catch (Exception ex) {
                logger.error("Exception", ex);
            }
        } else {
            //logger.info("Wicroft Directory : " + Constants.experimentDetailsDirectory + " Exists");
            logger.info("Wicroft Directory : " + Constants.experimentDetailsDirectory + " Exists");
        }

        /*
            Creating Database connection
         */
        dbManager = new DBManager();
        boolean stat = dbManager.createConnection();
        if (stat) {
            logger.info("DB connection successful");

        } else {
            logger.info("Unable to create DB connection");
        }

        /*
            Starting thread to open a connection socket
         */
        Runnable run = new Runnable() {
            @Override
            public void run() {
                ClientConnection.startlistenForClients();
            }
        };

        Thread t = new Thread(run);
        t.start();

    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet wicroft</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet wicroft at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
