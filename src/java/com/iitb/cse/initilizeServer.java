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
    
    @Getter @Setter public static long startwakeUpDuration = 0;
    @Getter @Setter public static long wakeUpDuration = 0;
    @Getter @Setter public static String  wakeUpFilter = "";
    @Getter @Setter public static ConcurrentHashMap<String, Integer> wakeUpClients = new ConcurrentHashMap<String, Integer>();
    @Getter @Setter public static ConcurrentHashMap<String, String > wakeUpTimerFilteredClients = new ConcurrentHashMap<String, String >();
        
//    @Getter @Setter public static ConcurrentHashMap<String, DeviceInfo> connectedClients;

    public void init() throws ServletException {

        System.out.println("***********Wicroft Server starting...************");
        allConnectedClients = new ConcurrentHashMap<String, DeviceInfo>();
        allBssidInfo = new ConcurrentHashMap<String, String>();
        UserNameToSessionMap = new ConcurrentHashMap<>();
        UserNameToInstacesMap = new ConcurrentHashMap<>();
//      connectedClients = new ConcurrentHashMap<>();

        File dir = new File(Constants.experimentDetailsDirectory);
        if (!dir.exists()) {
            try {
                dir.mkdirs();
                System.out.println("Wicroft Directory : " + Constants.experimentDetailsDirectory + " Created");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        } else {
            System.out.println("Wicroft Directory : " + Constants.experimentDetailsDirectory + " Exists");
        }

        dbManager = new DBManager();
        boolean stat = dbManager.createConnection();
        if (stat) {
            System.out.println("DB connection successful");
        } else {
            System.out.println("Unable to create DB connection");
        }

        Runnable run = new Runnable() {
            @Override
            public void run() {
                ClientConnection.startlistenForClients();
            }
        };

        Thread t = new Thread(run);
        t.start();

//        Constants.dbManager = new DBManager();
//        Constants.dbManager.createConnection();
//
//        try {
//
//            connectionSocket = new ServerSocket(Constants.ConnectionPORT);
//            while (true) {
//                System.out.println("Listeninig on port.............");
//                System.out.println("\nListening for Client to Connect on PORT " + Constants.ConnectionPORT + "......[" + Utils.getCurrentTimeStamp() + "]");
//                final Socket sock = connectionSocket.accept();
//                System.out.println("\nClient COnnected ...... [" + Utils.getCurrentTimeStamp() + "]");
//                Runnable r = new Runnable() {
//                    @Override
//                    public void run() {
//                        threadNo++;
//                        ClientConnection.handleConnection(sock, threadNo);
//                    }
//                };
//
//                Thread t = new Thread(r);
//
//                t.start();
//
//            }
//        } catch (IOException ex) {
//            ex.printStackTrace();
//
//        }
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
