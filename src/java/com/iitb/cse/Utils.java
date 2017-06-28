/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iitb.cse;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.Scanner;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import lombok.Getter;
import lombok.Setter;
import org.json.simple.JSONObject;

/**
 *
 * @author ratheeshkv
 */
public class Utils {

    @SuppressWarnings("unchecked")

    static String getApSettingsFileJson(String message) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.sendApSettings);
        String[] apConf = message.split("\n");
        System.out.println(apConf.length);

        for (int i = 0; i < apConf.length; i++) {
            String[] apInfo = apConf[i].trim().split("=");
            if (apInfo[0].equalsIgnoreCase("USERNAME")) {

                if (apInfo.length == 1) {

                    obj.put(Constants.username, "");
                } else {
                    String _usrname = apInfo[1].trim();
                    obj.put(Constants.username, _usrname);
                }

            } else if (apInfo[0].equalsIgnoreCase("PASSWORD")) {

                if (apInfo.length == 1) {
                    //String _usrname = apInfo[1].trim();
                    obj.put(Constants.password, "");
                } else {
                    String _passwd = apInfo[1].trim();
                    obj.put(Constants.password, _passwd);
                }

            } else if (apInfo[0].equalsIgnoreCase("TIMER")) {

                if (apInfo.length == 1) {
//                    obj.put(Constants.bssid, "");
                    obj.put(Constants.timer, "");
                } else {
                    String _bssid = apInfo[1].trim();
//                    obj.put(Constants.bssid, _bssid);
                    obj.put(Constants.timer, _bssid);
                }

            } else if (apInfo[0].equalsIgnoreCase("SSID")) {

                if (apInfo.length == 1) {
                    obj.put(Constants.ssid, "");
                } else {
                    String _ssid = apInfo[1].trim();
                    obj.put(Constants.ssid, _ssid);
                }

            } else if (apInfo[0].equalsIgnoreCase("SECURITY")) {

                if (apInfo.length == 1) {
                    obj.put("security", "");
                } else {
                    String _sec = apInfo[1].trim();
                    obj.put("security", _sec);
                }

            }
        }

        //obj.put(Constants.message,message);
        //	obj.put(Constants.textFileFollow, Boolean.toString(true));
        //	obj.put(Constants.serverTime, Long.toString(Calendar.getInstance().getTimeInMillis()));
        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    /**
     * genetated and returns the String in Json format. String contains
     * information about the action for sending AP settings file This string is
     * later sent to filtered devices.
     */
    @SuppressWarnings("unchecked")
    static String getControlFileJson(String message, int userId, String fileId) {//, String timeout, String logBgTraffic) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.sendControlFile);
        obj.put(Constants.textFileFollow, Boolean.toString(true));
        //    obj.put(Constants.serverTime, Long.toString(Calendar.getInstance().getTimeInMillis()));
        obj.put(Constants.message, message);
        obj.put(Constants.fileId, userId + "_" + fileId);
//        obj.put(Constants.timeout, timeout);
//        obj.put("selectiveLog", logBgTraffic);
        String jsonString = obj.toJSONString();

        //      Date obj1 = new Date(Long.parseLong((String) obj.get(Constants.serverTime)));
        System.out.println("HAI : " + jsonString);//+ obj1);
        return jsonString;
    }

    @SuppressWarnings("unchecked")
    static String getWakeUpClientsJson(String time) {//, String timeout, String logBgTraffic) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.wakeup);
        obj.put(Constants.duration, time);
        String jsonString = obj.toJSONString();
        System.out.println("HAI : " + jsonString);//+ obj1);
        return jsonString;
    }

    @SuppressWarnings("unchecked")
    static String getExperimentJson(String message, String timeout, String logBgTraffic) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.sendControlFile);
        obj.put(Constants.textFileFollow, Boolean.toString(true));
        obj.put(Constants.serverTime, Long.toString(Calendar.getInstance().getTimeInMillis()));
        obj.put(Constants.message, message);
        obj.put(Constants.timeout, timeout);
        obj.put("selectiveLog", logBgTraffic);
        String jsonString = obj.toJSONString();

        Date obj1 = new Date(Long.parseLong((String) obj.get(Constants.serverTime)));

        System.out.println(jsonString + obj1);
        return jsonString;
    }

    @SuppressWarnings("unchecked")
    static String getExpJson(String timeout, String expStartTime, String logBgTraffic, String file_id, int expID, int userID) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.startExp);
        obj.put(Constants.textFileFollow, Boolean.toString(true));
        obj.put(Constants.serverTime, Long.toString(Calendar.getInstance().getTimeInMillis()));
//        obj.put(Constants.message, message);
        obj.put(Constants.timeout, timeout);
        obj.put(Constants.expStartTime, expStartTime);
        obj.put(Constants.fileId, userID+"_"+file_id);
        obj.put(Constants.experimentid, userID + "_" + expID);
        obj.put("selectiveLog", logBgTraffic);
        String jsonString = obj.toJSONString();

        Date obj1 = new Date(Long.parseLong((String) obj.get(Constants.serverTime)));

        System.out.println(jsonString + obj1);
        return jsonString;
    }

    @SuppressWarnings("unchecked")
    static String getHeartBeatDuration(String duration) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, "hbDuration");
        obj.put("heartbeat_duration", duration);
        obj.put("hbDuration", duration);

        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    @SuppressWarnings("unchecked")
    static String getServerConfiguration(String serverIP, String serverPORT, String connectionPORT) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, "action_changeServer");
//        hbDuration

        if (serverIP != null && !serverIP.trim().equalsIgnoreCase("")) {
            obj.put("serverip", serverIP);
        } else {
            obj.put("serverip", "");
        }

        if (serverPORT != null && !serverPORT.trim().equalsIgnoreCase("")) {
            obj.put("serverport", serverPORT);
        } else {
            obj.put("serverport", "");
        }

        if (connectionPORT != null && !connectionPORT.trim().equalsIgnoreCase("")) {
            obj.put("connectionport", connectionPORT);
        } else {
            obj.put("connectionport", "");
        }

        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    /**
     * genetated and returns the String in Json format. String contains
     * information that the experiment has been stopped by experimenter This
     * string is later sent to filtered devices.
     */
    @SuppressWarnings("unchecked")
    static String getStopSignalJson() {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.stopExperiment);
        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    /**
     * genetated and returns the String in Json format. String contains
     * information that the experiment has been stopped by experimenter This
     * string is later sent to filtered devices.
     */
    @SuppressWarnings("unchecked")
    static String getLogFilesJson(int expID) {
        JSONObject obj = new JSONObject();
        //{action:getLogFile}
        obj.put(Constants.action, Constants.getLogFiles);
        //obj.put(Constants.action, "action_updateAvailable");
        obj.put(Constants.expID, Integer.toString(expID));
        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    @SuppressWarnings("unchecked")
    static String getUpdateReqJson() {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, "action_updateAvailable");
        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    /**
     * genetated and returns the String in Json format. String contains
     * information that the experimentee wants to ping the devices and refresh
     * the list of registered devices This string is later sent to registered
     * devices.
     */
    @SuppressWarnings("unchecked")
    static String getRefreshRegistrationJson() {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.refreshRegistration);
        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    /**
     * genetated and returns the String in Json format. String contains
     * information that all the registration has been cleared by experimenter
     * This string is later sent to filtered devices.
     */
    @SuppressWarnings("unchecked")
    static String getClearRegistrationJson() {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.clearRegistration);
        String jsonString = obj.toJSONString();
        System.out.println(jsonString);
        return jsonString;
    }

    public static Date getCurrentTimeStamp() {
        Date date = Calendar.getInstance().getTime();
        return date;
    }

    public static void getClientBasedOnBssid() {

    }

    public static void createSession(String username, int userId) {

        /* Session doesnot exists*/
        if (initilizeServer.getUserNameToSessionMap().get(username) == null) {
            Session session = new Session(username, userId);
//          mySession = session;
            initilizeServer.getUserNameToSessionMap().put(username, session);
            initilizeServer.getUserNameToInstacesMap().put(username, 1);
            System.out.println("Creating a new session");
        } else {
            System.out.println("Session for User already exists");
//                    mySession = initilizeServer.getUserNameToSessionMap().get(userId);
            Utils.updateLoginInstances(username, 1);
        }

//        if (mySession == null) {
//            mySession = new Session(user, userId);
//            System.out.println("\n New Session created");
//        } else {
//            System.out.println("\n Use existing Session");
//        }
    }

    public static void clearSession() {
//        mySession = null;
//        System.out.println("\n Session cleared");
    }

    public static Enumeration<String> getAllBssids(Session mySession) {

        Enumeration<String> bssidList = null;
        try {
            ConcurrentHashMap<String, Boolean> obj = new ConcurrentHashMap<String, Boolean>();
            ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
            Enumeration<String> macList = clients.keys();
            if (clients != null) {
                while (macList.hasMoreElements()) {
                    String macAddr = macList.nextElement();
                    DeviceInfo device = clients.get(macAddr);
                    obj.put(device.getBssid(), Boolean.TRUE);

                }
            }
            bssidList = obj.keys();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return bssidList;
    }

    public static Enumeration<String> getAllSsids(Session mySession) {

        //
        //
        Enumeration<String> ssidList = null;
        try {
            ConcurrentHashMap<String, Boolean> obj = new ConcurrentHashMap<String, Boolean>();
            ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();
            

            if (clients != null) {
                Enumeration<String> macList = clients.keys();
                while (macList.hasMoreElements()) {
                    String macAddr = macList.nextElement();
                    DeviceInfo device = clients.get(macAddr);
                    obj.put(device.getSsid(), Boolean.TRUE);
                }
            }

            ssidList = obj.keys();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return ssidList;
    }

    public static void getSelectedConnectedClients(Session mySession) {

        try {
            mySession.getSelectedConnectedClients().clear();
            ConcurrentHashMap<String, DeviceInfo> clients = initilizeServer.getAllConnectedClients();
            if (clients != null) {
                Enumeration<String> macList = clients.keys();
                while (macList.hasMoreElements()) {
                    String macAddr = macList.nextElement();
                    DeviceInfo device = clients.get(macAddr);
                    if (device != null && device.getBssid() != null && mySession.getSelectedBssidInfo().get(device.getBssid()) != null) {
                        mySession.getSelectedConnectedClients().put(macAddr, device);
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static CopyOnWriteArrayList<DeviceInfo> activeClients(Session mySession) {

        getSelectedConnectedClients(mySession);

        CopyOnWriteArrayList<DeviceInfo> activeClients = new CopyOnWriteArrayList<DeviceInfo>();
        try {
//          ConcurrentHashMap<String, DeviceInfo> clients = initilizeServer.getAllConnectedClients();
            ConcurrentHashMap<String, DeviceInfo> clients = mySession.getSelectedConnectedClients();

            if (clients != null) {
                Enumeration<String> macList = clients.keys();

                if (macList != null) {

                    while (macList.hasMoreElements()) {
                        String macAddr = macList.nextElement();

                        if (macAddr != null) {

                            DeviceInfo device = clients.get(macAddr);
                            if (device != null && device.getBssid() != null && mySession.getSelectedBssidInfo().get(device.getBssid()) != null && (Utils.getCurrentTimeStamp().getTime() - device.getLastHeartBeatTime().getTime()) / 1000 <= Constants.heartBeatAlive) {
                                activeClients.add(device);
                            }
                        }
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return activeClients;
    }

    public static String generateLine(Calendar cal, String mode, String type, String link) {
        String line = type + " ";

        line += cal.get(Calendar.YEAR) + " ";
        line += cal.get(Calendar.MONTH) + " ";
        line += cal.get(Calendar.DAY_OF_MONTH) + " ";
        line += cal.get(Calendar.HOUR_OF_DAY) + " ";
        line += cal.get(Calendar.MINUTE) + " ";
        line += cal.get(Calendar.SECOND) + " ";
        line += cal.get(Calendar.MILLISECOND) + " ";
        line += mode + " ";
        line += link;
        return line + "\n";
    }

    public static String generateLine(Calendar cal, String mode, String type, String link, String size) {
        String line = type + " ";

        line += cal.get(Calendar.YEAR) + " ";
        line += cal.get(Calendar.MONTH) + " ";
        line += cal.get(Calendar.DAY_OF_MONTH) + " ";
        line += cal.get(Calendar.HOUR_OF_DAY) + " ";
        line += cal.get(Calendar.MINUTE) + " ";
        line += cal.get(Calendar.SECOND) + " ";
        line += cal.get(Calendar.MILLISECOND) + " ";
        line += mode + " ";
        line += link + " ";
        line += size;
        return line + "\n";
    }

    public static boolean startExperiment(int expId, String timeout, String logBgTraffic, Session mySession) {

        try {
            File file = null;
            File file1 = null;

            if (Constants.experimentDetailsDirectory.endsWith("/")) {
                file = new File(Constants.experimentDetailsDirectory + mySession.getCurrentExperimentId() + "/" + Constants.configFile);
                file1 = new File(Constants.experimentDetailsDirectory + mySession.getCurrentExperimentId());
            } else {
                file = new File(Constants.experimentDetailsDirectory + "/" + mySession.getCurrentExperimentId() + "/" + Constants.configFile);
                file1 = new File(Constants.experimentDetailsDirectory + "/" + mySession.getCurrentExperimentId());
            }

            if (file.exists()) {
                Charset charset = Charset.forName("UTF-8");
                String line = null;

                String[] data = new String[1000];//
                int index = 0;
                data[index] = "";
                try {
                    BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                    Calendar cal = Calendar.getInstance();
                    while ((line = reader.readLine()) != null) {

                        System.out.println("\nLENGTH : " + line.length());

                        if (line.isEmpty() || line.trim().equals("")) {
                            System.out.println("\nCASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            System.out.println("\nCASE2");
                            data[index] = expId + "\n" + data[index];
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            System.out.println("\nCASE3");
                            data[index] = expId + "\n" + data[index];
                            index++;
                            data[index] = "";
                            continue;
                        }

                        String[] lineVariables = line.split(" ");

                        //	int offset = Integer.parseInt(lineVariables[1]);
                        //	cal.add(Calendar.SECOND, offset);
//****************************************************
                        double time = Double.parseDouble(lineVariables[1]);

                        int sec = (int) time;
                        double rem = time % 1;
                        int remainder = (int) (rem * 1000);
                        //       Calendar cal = Calendar.getInstance();
                        //   System.out.println("\nSec : " + sec + "\nMiSec : " + remainder + "\nTime : " + cal.getTime());
                        int flag = 0;
                        if (remainder < 100) {
                            flag = 1;
                            remainder = remainder + 100;
                            cal.add(Calendar.SECOND, sec);
                            cal.add(Calendar.MILLISECOND, remainder);
                            cal.add(Calendar.MILLISECOND, -100);
                        } else {
                            cal.add(Calendar.SECOND, sec);
                            cal.add(Calendar.MILLISECOND, remainder);
                        }

//****************************************************
                        if (lineVariables.length == 5) {
                            //       System.out.println("\nINSIDE");
                            data[index] += generateLine(cal, lineVariables[2], lineVariables[0], lineVariables[3], lineVariables[4]);
                        } else {
                            //    System.out.println("\nOUTSIDE");
                            data[index] += generateLine(cal, lineVariables[2], lineVariables[0], lineVariables[3]);
                        }

                        if (flag == 1) {
                            cal.add(Calendar.SECOND, -1 * sec);
                            cal.add(Calendar.MILLISECOND, -1 * remainder);
                            cal.add(Calendar.MILLISECOND, 100);
                        } else {
                            cal.add(Calendar.SECOND, -1 * sec);
                            cal.add(Calendar.MILLISECOND, -1 * remainder);
                        }

                    }

                    data[index] = expId + "\n" + data[index];

                } catch (IOException ex) {
//                    System.out.println(ex.toString());
                    return false;
                }

                int controlFileIndex = 0;
                for (DeviceInfo d : mySession.getFilteredClients()) {

                    if (controlFileIndex >= mySession.getFilteredClients().size()) {
                        break;
                    } else if (data[controlFileIndex] != null) {

                        String jsonString = Utils.getExperimentJson(data[controlFileIndex], timeout, logBgTraffic);
                        System.out.println("\njsonString : " + jsonString);
                        System.out.println("\nControl FIle : " + data[controlFileIndex]);

                        /* Locally keep the corresponding control file to each client*/
                        PrintWriter writer;
                        try {

                            writer = new PrintWriter(file1 + "/" + d.macAddress + "_confFile");
                            writer.write(data[controlFileIndex]);
                            writer.flush();
                            writer.close();
                        } catch (FileNotFoundException ex) {
//                            System.out.println("\nException : " + ex.toString());
                            return false;
                        }

                        //writer.close();
                        System.out.println("\nDevice Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                        Thread sendData = new Thread(new SendData(mySession, d, 0, jsonString, data[controlFileIndex]));
                        sendData.start();
                    } else {
                        break;
                    }
                    controlFileIndex++;
                }
            } else {
                return false;
                //System.out.println("\nConfig FIle not found in location : " + Constants.experimentDetailsDirectory + mySession.getCurrentExperimentId());
            }

        } catch (Exception ex) {
            return false;
        }
        return true;
    }

// Utils.startNewExperiment(expNumber, expName, expLoc, expDesc, expFileId, expFileName, startExpNumClients, startExpDuration,  expAckWaitTime, expRetryStartTime, expTimeOut, logBgTraffic, username, mySession);
    public static boolean startNewExperiment(final int expNumber, final String expName, final String expLoc, final String expDesc, final int expFileId, final String expFileName, final int nbrClientsPerRound, final int roundDuration, final int expAckWaitTime, final int expRetryStartTime, final int expTimeOut, final String logBgTraffic, final String username, final Session mySession, final int nbrOfClients) {

        boolean status = false;
        mySession.setExperimentRunning(true);
        
        
        
        mySession.setLastConductedExpId(Integer.toString(expNumber));
    
        
                
        final int userId = DBManager.getUserId(username);
        try {

            Runnable run = new Runnable() {
                @Override
                public void run() {

                    int numberOfRounds = (int) Math.ceil((double) nbrOfClients / nbrClientsPerRound);
                    int totalTime = (numberOfRounds - 1) * roundDuration + expAckWaitTime + expRetryStartTime;

                    int numReqSend = 0;
                    int roundNbr = 0;

                    for (int i = 0; i < mySession.getStartExpSelectedClients().size(); i++) {
                        String macAddr = mySession.getStartExpSelectedClients().get(i);
                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddr);
                        int expStartAfter = totalTime - (roundNbr * roundDuration);
                        String jsonString = Utils.getExpJson(Integer.toString(expTimeOut), Integer.toString(expStartAfter), logBgTraffic, Integer.toString(expFileId), expNumber, userId);

                        Thread sendData = new Thread(new SendData(mySession, device, 0, jsonString, Integer.toString(expFileId), userId));
                        sendData.start();
                        numReqSend++;

                        if (numReqSend == nbrClientsPerRound) {
                            roundNbr++;
                            numReqSend = 0;
                            try {
                                Thread.currentThread().sleep(roundDuration * 1000);;
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }
                    }

                    try {
                        Thread.currentThread().sleep(expAckWaitTime * 1000);;
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                    ResultSet rs = DBManager.getAllPendingExpReqMacAddress(expNumber, username);

                    if (rs != null) {
                        try {
                            while (rs.next()) {
                                String macAddr = rs.getString(1);
                                DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddr);
                                String jsonString = Utils.getExpJson(Integer.toString(expTimeOut), Integer.toString(expRetryStartTime), logBgTraffic, Integer.toString(expFileId), expNumber, userId);
                                Thread sendData = new Thread(new SendData(mySession, device, 11, jsonString, Integer.toString(expFileId), userId));
                                sendData.start();
                            }
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                    }
                }
            };
            Thread t = new Thread(run);
            t.start();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return status;
    }

//    public static boolean startExp(int expId, String timeout, String logBgTraffic, String file_id) {
    public static boolean startExp(final int expId, final String expBuffTime, final String nbrReq, final String roundDur, final String timeout, final String logBgTraffic, final String file_id, final Session mySession) {

        try {

            Runnable run = new Runnable() {
                @Override
                public void run() {
                    int reqPerRound = 0;
                    int roundNbr = 0;
                    int expTime = Integer.parseInt(expBuffTime);
                    int roundDuration = Integer.parseInt(roundDur);
                    int controlFileIndex = 0;
                    try {

                        for (DeviceInfo d : mySession.getFilteredClients()) {
                            if (controlFileIndex >= mySession.getFilteredClients().size()) {
                                break;
                            } else {
                                int time = (expTime - (roundNbr * roundDuration));
                                int expSTartTime = time > 0 ? time : 0;
                                String jsonString = Utils.getExpJson(timeout, Integer.toString(expSTartTime), logBgTraffic, file_id, expId, 1);
                                System.out.println("\njsonString : " + jsonString);
                                System.out.println("\nDevice Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
//                    Thread sendData = new Thread(new SendData(expId, d, 0, jsonString, ""));
                                Thread sendData = new Thread(new SendData(mySession, d, 0, jsonString, file_id));
                                sendData.start();
                                reqPerRound++;
                            }
                            controlFileIndex++;

                            if (reqPerRound >= Integer.parseInt(nbrReq)) {
                                Thread.currentThread().sleep(Integer.parseInt(roundDur));
                                roundNbr++;
                                reqPerRound = 0;
                            }
                        }
                    } catch (Exception ex) {
                        System.out.println("\nException ex" + ex.toString());
                    }
                }
            };
            Thread t = new Thread(run);
            t.start();

        } catch (Exception ex) {
            return false;
        }
        return true;
    }

    public static void reSendControlFile(final String fileid, final String file_name, final String numclients, final String duration, final String username, final Session mySession) {//, String timeout, String logBgTraffic) {

        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    _reSendControlFile(fileid, file_name, numclients, duration, username, mySession);
                } catch (Exception ex) {
                    System.out.println("\nException ex" + ex.toString());
                }
            }
        };
        Thread t = new Thread(run);
        t.start();
    }

    public static boolean _reSendControlFile(String fileid, String file_name, String numclients, String duration, String username, Session mySession) {//, String timeout, String logBgTraffic) {

        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);
        fileid = fileid.trim();
        file_name = file_name.trim();
        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);
        mySession.setSendCtrlFileRunning(true);

        mySession.setCurrentControlFileId(fileid);
        mySession.setCurrentControlFileName(file_name);

        mySession.getSendCtrlFileFilteredClients().clear();
        mySession.getControlFileSendingSuccessClients().clear();
        mySession.getControlFileSendingFailedClients().clear();

        try {
            File file = null;
            File file1 = null;

            if (Constants.experimentDetailsDirectory.endsWith("/")) {
                file = new File(Constants.experimentDetailsDirectory + username + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                file1 = new File(Constants.experimentDetailsDirectory + username + "/" + Constants.controlFile + "/" + fileid + "/clients");
            } else {
                file = new File(Constants.experimentDetailsDirectory + "/" + username + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                file1 = new File(Constants.experimentDetailsDirectory + "/" + username + "/" + Constants.controlFile + "/" + fileid + "/clients");
            }

            if (file.exists()) {
                Charset charset = Charset.forName("UTF-8");
                String line = null;

                String[] data = new String[1000];//
                int index = 0;
                data[index] = "";
                try {
                    BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                    Calendar cal = Calendar.getInstance();
                    while ((line = reader.readLine()) != null) {
                        System.out.println("\nLENGTH : " + line.length());
                        if (line.isEmpty() || line.trim().equals("")) {
                            System.out.println("\nCASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            System.out.println("\nCASE2");
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            System.out.println("\nCASE3");
                            index++;
                            data[index] = "";
                            continue;
                        } else {
                        }
                        data[index] += line + "\n";
                    }
                    System.out.println("\nEXIT FROM LOOP");
                } catch (IOException ex) {
                    return false;
                }

                int controlFileIndex = 0;

                String mac = "";

                int numberOfClientReqs = 0;
                int totalNumberOfClientReqs = 0;
                int userId = DBManager.getUserId(username);

                for (int i = 0; i < mySession.getSendCtrlFileSelectedClients().size(); i++) {
                    String macAddr = mySession.getSendCtrlFileSelectedClients().get(i);
                    DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddr);
                    mySession.getSendCtrlFileFilteredClients().put(macAddr, "Sending...");
                    if (data[controlFileIndex] != null) {

                        File file2 = new File(file1 + "/" + macAddr + "_" + fileid + "_confFile");
                        String jsonString = "";

                        if (file2.exists()) {
                            System.out.println("\nReusing OLD control file :" + file2);
                            Scanner scanner = new Scanner(file2);
                            String filedata = "";
                            while (scanner.hasNextLine()) {
                                if (filedata.length() == 0) {
                                    filedata = scanner.nextLine();
                                } else {
                                    filedata += "\n" + scanner.nextLine();
                                }
                            }
                            System.out.println("Control FIle: " + filedata);
                            jsonString = Utils.getControlFileJson(filedata, userId, fileid);//, timeout, logBgTraffic);
                        } else {

                            System.out.println("\nFOUR" + "\n\n" + data[controlFileIndex]);
                            jsonString = Utils.getControlFileJson(data[controlFileIndex], userId, fileid);//, timeout, logBgTraffic);
                            System.out.println("\njsonString : " + jsonString);
                            System.out.println("\nControl FIle : " + data[controlFileIndex]);

                            /* Locally keep the corresponding control file to each client*/
                            PrintWriter writer;

                            if (!file1.exists()) {
                                file1.mkdirs();
                            }

                            try {
                                writer = new PrintWriter(file1 + "/" + macAddr + "_" + fileid + "_confFile");
                                writer.write(data[controlFileIndex]);
                                writer.flush();
                                writer.close();
                            } catch (Exception ex) {
                                System.out.println("\nException : " + ex.toString());
                                ex.printStackTrace();
                                return false;
                            }
                            controlFileIndex++;
                        }
                        //writer.close();
                        Thread sendData = new Thread(new SendData(mySession, device, 10, jsonString, fileid, DBManager.getUserId(username)));
                        sendData.start();
                        numberOfClientReqs++;

                        if (numberOfClientReqs == Integer.parseInt(numclients)) {
                            numberOfClientReqs = 0;
                            try {
                                Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
                            } catch (InterruptedException ex) {
                                System.out.println(ex.toString());
                            }
                        }

                    } else {
                        break;
                    }

                }

                try {
                    Thread.sleep(7 * 1000); // seconds
                    mySession.setSendCtrlFileRunning(false);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

            } else {
                return false;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            System.out.println("\nException Ex : " + ex.toString());
            return false;
        }
        return true;
    }

    public static void ireSendControlFile(final String fileid, final String file_name, final String numclients, final String duration, final Session mySession) {//, String timeout, String logBgTraffic) {
        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    _ireSendControlFile(fileid, file_name, numclients, duration, mySession);
                } catch (Exception ex) {
                    System.out.println("\nException ex" + ex.toString());
                }
            }
        };
        Thread t = new Thread(run);
        t.start();
    }

    public static boolean _ireSendControlFile(String fileid, String file_name, String numclients, String duration, Session mySession) {//, String timeout, String logBgTraffic) {
        

        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);
        fileid = fileid.trim();
        file_name = file_name.trim();
        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);
        try {
            File file = null;
            File file1 = null;

            if (Constants.experimentDetailsDirectory.endsWith("/")) {
                file = new File(Constants.experimentDetailsDirectory + Constants.controlFile + "/" + fileid + "/" + file_name);
                file1 = new File(Constants.experimentDetailsDirectory + Constants.controlFile + "/" + fileid + "/clients");
            } else {
                file = new File(Constants.experimentDetailsDirectory + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                file1 = new File(Constants.experimentDetailsDirectory + "/" + Constants.controlFile + "/" + fileid + "/clients");
            }

            if (file.exists()) {
                Charset charset = Charset.forName("UTF-8");
                String line = null;

                String[] data = new String[1000];//
                int index = 0;
                data[index] = "";
                try {
                    BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                    Calendar cal = Calendar.getInstance();
                    while ((line = reader.readLine()) != null) {
                        System.out.println("\nLENGTH : " + line.length());
                        if (line.isEmpty() || line.trim().equals("")) {
                            System.out.println("\nCASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            System.out.println("\nCASE2");
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            System.out.println("\nCASE3");
                            index++;
                            data[index] = "";
                            continue;
                        } else {
                        }
                        data[index] += line + "\n";
                    }
                    System.out.println("\nEXIT FROM LOOP");
                } catch (IOException ex) {
                    return false;
                }

                System.out.println("\nSIZE : " + mySession.getFilteredClients().size());
                int controlFileIndex = 0;

                System.out.println("\nONE");

                String mac = "";

                int numberOfClientReqs = 0;
                int totalNumberOfClientReqs = 0;

                for (DeviceInfo d : mySession.getFilteredClients()) {

                    System.out.println("\nTWO");
                    if (controlFileIndex >= mySession.getFilteredClients().size()) {
                        System.out.println("\nTHREE");
                        break;
                    } else if (data[controlFileIndex] != null) {

                        File file2 = new File(file1 + "/" + d.macAddress + "_" + fileid + "_confFile");
                        String jsonString = "";

                        if (file2.exists()) {
                            System.out.println("\nReusing OLD control file :" + file2);
                            Scanner scanner = new Scanner(file2);
                            String filedata = "";
                            while (scanner.hasNextLine()) {
                                if (filedata.length() == 0) {
                                    filedata = scanner.nextLine();
                                } else {
                                    filedata += "\n" + scanner.nextLine();
                                }
                            }
                            System.out.println("Control FIle: " + filedata);
                            jsonString = Utils.getControlFileJson(filedata, 1, fileid);//, timeout, logBgTraffic);
                        } else {

                            System.out.println("\nFOUR" + "\n\n" + data[controlFileIndex]);
                            jsonString = Utils.getControlFileJson(data[controlFileIndex], 1, fileid);//, timeout, logBgTraffic);
                            System.out.println("\njsonString : " + jsonString);
                            System.out.println("\nControl FIle : " + data[controlFileIndex]);

                            /* Locally keep the corresponding control file to each client*/
                            PrintWriter writer;

                            if (!file1.exists()) {
                                file1.mkdirs();
                            }

                            try {
                                writer = new PrintWriter(file1 + "/" + d.macAddress + "_" + fileid + "_confFile");
                                writer.write(data[controlFileIndex]);
                                writer.flush();
                                writer.close();
                            } catch (FileNotFoundException ex) {
                                System.out.println("\nException : " + ex.toString());
                                ex.printStackTrace();
                                return false;
                            }
                            controlFileIndex++;
                        }
                        //writer.close();
                        System.out.println("\nDevice Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                        Thread sendData = new Thread(new SendData(mySession, d, 7, jsonString, data[controlFileIndex]));
                        sendData.start();
                        numberOfClientReqs++;
                        totalNumberOfClientReqs++;

//                        if (mySession.getFilteredClients().size() > totalNumberOfClientReqs && numberOfClientReqs == Integer.parseInt(numclients)) {
//                            numberOfClientReqs = 0;
//                            try {
//                                Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
//                            } catch (InterruptedException ex) {
//                                System.out.println(ex.toString());
//                            }
//                        }
                    } else {
                        break;
                    }

                }

                try {
                    Thread.sleep(7 * 1000); // seconds
                    mySession.setSendingControlFileStatus(false);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }

            } else {

                return false;
                //System.out.println("\nConfig FIle not found in location : " + Constants.experimentDetailsDirectory + mySession.getCurrentExperimentId());
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            System.out.println("\nException EXXX : " + ex.toString());
            return false;
        }
        return true;
    }

    //**************************************************************************************************************************************
    public static void _sendControlFile(final String fileid, final String file_name, final String newOrOld, final String numclients, final String duration) {//, String timeout, String logBgTraffic) {

        System.out.println("\n***********THREAD NAME : " + Thread.currentThread().getName());
        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
//                    _sendControlFile(fileid, file_name, newOrOld, numclients, duration);
                    System.out.println("TESTING SERVER");

                } catch (Exception ex) {
                    System.out.println("\nException ex" + ex.toString());
                }
            }
        };
        Thread t = new Thread(run);
        t.start();
    }

    public static void sendOldControlFile(final String fileid, final String file_name, final String numclients, final String duration, final String username, final Session mySession) {

        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    File file = null;
                    File file1 = null;

                    if (Constants.experimentDetailsDirectory.endsWith("/")) {
                        file = new File(Constants.experimentDetailsDirectory + username + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                        file1 = new File(Constants.experimentDetailsDirectory + username + "/" + Constants.controlFile + "/" + fileid + "/clients");
                    } else {
                        file = new File(Constants.experimentDetailsDirectory + "/" + username + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                        file1 = new File(Constants.experimentDetailsDirectory + "/" + username + "/" + Constants.controlFile + "/" + fileid + "/clients");
                    }
                    System.out.println("File : " + file);
                    System.out.println("File1 : " + file1);

                    if (file.exists()) {
                        Charset charset = Charset.forName("UTF-8");
                        String line = null;
                        int userId = DBManager.getUserId(username);
                        String[] data = new String[1000];//
                        int index = 0;
                        data[index] = "";
                        try {
                            BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                            Calendar cal = Calendar.getInstance();
                            while ((line = reader.readLine()) != null) {

//                                System.out.println("\nLENGTH : " + line.length());
                                if (line.isEmpty() || line.trim().equals("")) {
//                                    System.out.println("\nCASE1");
                                    continue;
                                } else if (line.trim().equals("*****\n")) {
//                                    System.out.println("\nCASE2");
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else if (line.trim().equals("*****")) {
//                                    System.out.println("\nCASE3");
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else {
                                }
                                data[index] += line + "\n";
                            }
                        } catch (IOException ex) {
                            System.out.println(ex.toString());
                        }

                        int controlFileIndex = 0;

                        for (int i = 0; i < mySession.getSendOldCtrlFileSelectedClients().size(); i++) {

                            String mac = mySession.getSendOldCtrlFileSelectedClients().get(i);
                            int nbrOfReq = 0;

                            if (data[controlFileIndex] != null) {

                                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                String jsonString = Utils.getControlFileJson(data[controlFileIndex], userId, fileid);
                                PrintWriter writer;

                                if (!file1.exists()) {
                                    file1.mkdirs();
                                }

                                try {
                                    writer = new PrintWriter(file1 + "/" + device.macAddress + "_" + fileid + "_confFile");
                                    writer.write(data[controlFileIndex]);
                                    writer.flush();
                                    writer.close();
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                }

                                Thread sendData = new Thread(new SendData(mySession, device, 7, jsonString, fileid, userId));

                                sendData.start();
                                nbrOfReq++;

                                if (nbrOfReq == Integer.parseInt(numclients)) {
                                    nbrOfReq = 0;
                                    try {
                                        System.out.println("\nSLEEPING");
                                        Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
                                    } catch (InterruptedException ex) {
                                        System.out.println(ex.toString());
                                    }
                                }
                                controlFileIndex += 1;
                                nbrOfReq += 1;
                            }
                        }

                        try {
                            Thread.sleep(7 * 1000); // seconds
                            mySession.setSendingControlFileStatus(false);
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }

                    } else {
                        // file does not exist
                        System.out.println("File not exists: " + file);

                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                    System.out.println("\nException EXXX : " + ex.toString());
                }

            }
        };

        Thread t = new Thread(run);
        t.start();

    }

    public static void sendControlFile(final String fileid, final String file_name, final String numclients, final String duration, final String username, final Session mySession) {//, String timeout, String logBgTraffic) {

        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);
        mySession.setSendCtrlFileRunning(true);

        mySession.setCurrentControlFileId(fileid);
        mySession.setCurrentControlFileName(file_name);

        mySession.getSendCtrlFileFilteredClients().clear();
        mySession.getControlFileSendingSuccessClients().clear();
        mySession.getControlFileSendingFailedClients().clear();

        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    File file = null;
                    File file1 = null;

                    if (Constants.experimentDetailsDirectory.endsWith("/")) {
                        file = new File(Constants.experimentDetailsDirectory + username + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                        file1 = new File(Constants.experimentDetailsDirectory + username + "/" + Constants.controlFile + "/" + fileid + "/clients");
                    } else {
                        file = new File(Constants.experimentDetailsDirectory + "/" + username + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                        file1 = new File(Constants.experimentDetailsDirectory + "/" + username + "/" + Constants.controlFile + "/" + fileid + "/clients");
                    }
                    System.out.println("File : " + file);
                    System.out.println("File1 : " + file1);

                    if (file.exists()) {
                        Charset charset = Charset.forName("UTF-8");
                        String line = null;
                        int userId = DBManager.getUserId(username);
                        String[] data = new String[1000];//
                        int index = 0;
                        data[index] = "";
                        try {
                            BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                            Calendar cal = Calendar.getInstance();
                            while ((line = reader.readLine()) != null) {

                                if (line.isEmpty() || line.trim().equals("")) {
                                    continue;
                                } else if (line.trim().equals("*****\n")) {
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else if (line.trim().equals("*****")) {
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else {
                                }
                                data[index] += line + "\n";
                            }
                        } catch (IOException ex) {
                            System.out.println(ex.toString());
                        }

                        int controlFileIndex = 0;

                        for (int i = 0; i < mySession.getSendCtrlFileSelectedClients().size(); i++) {

                            String mac = mySession.getSendCtrlFileSelectedClients().get(i);
                            mySession.getSendCtrlFileFilteredClients().put(mac, "Sending...");

                            int nbrOfReq = 0;
                            if (data[controlFileIndex] != null) {

                                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                                String jsonString = Utils.getControlFileJson(data[controlFileIndex], userId, fileid);
                                PrintWriter writer;

                                if (!file1.exists()) {
                                    file1.mkdirs();
                                }

                                try {
                                    writer = new PrintWriter(file1 + "/" + device.macAddress + "_" + fileid + "_confFile");
                                    writer.write(data[controlFileIndex]);
                                    writer.flush();
                                    writer.close();
                                } catch (Exception ex) {
                                    ex.printStackTrace();
                                }

                                Thread sendData = new Thread(new SendData(mySession, device, 7, jsonString, fileid, userId));

                                sendData.start();
                                nbrOfReq++;

                                if (nbrOfReq == Integer.parseInt(numclients)) {
                                    nbrOfReq = 0;
                                    try {
                                        System.out.println("\nSLEEPING");
                                        Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
                                    } catch (InterruptedException ex) {
                                        System.out.println(ex.toString());
                                    }
                                }
                                controlFileIndex += 1;
                                nbrOfReq += 1;
                            }
                        }

                        try {
                            Thread.sleep(7 * 1000); // seconds
                            mySession.setSendCtrlFileRunning(false);
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }

//                        
//                        
//                        System.out.println("\nSIZE : " + mySession.getSendCtrlFileSelectedClients().size());
//                        
//
//                        System.out.println("\nONE");
//
//                        String mac = "";
//                        ConcurrentHashMap<String, Integer> Clients = DBManager.getControlFileUserInfo(fileid);
//
//
//                        int numberOfClientReqs = 0;
//                        int totalNumberOfClientReqs = 0;
//
//                        //for (DeviceInfo d : mySession.getSendCtrlFileSelectedClients()) {
//                            for(int i=0;i<mySession.getSendCtrlFileSelectedClients().size();i++){
//                                DeviceInfo d = initilizeServer.getAllConnectedClients().get(mySession.getSendCtrlFileSelectedClients().get(i));
//
//                            System.out.println("\nTHREAD NAME : " + Thread.currentThread().getName());
//
//                            if (newOrOld.equalsIgnoreCase("selectOldFile") && Clients.get(d.getMacAddress()) != null) {
//                                System.out.println("\nSending COntrol FIle : Mac :" + d.getMacAddress() + " already have file : " + fileid);
//                            } else {
//
//                                System.out.println("\nTWO");
//                                if (controlFileIndex >= mySession.getSendCtrlFileSelectedClients().size()) {
//                                    System.out.println("\nTHREE");
//                                    break;
//                                } else if (data[controlFileIndex] != null) {
//                                    System.out.println("\nFOUR" + "\n\n" + data[controlFileIndex]);
//                                    String jsonString = Utils.getControlFileJson(data[controlFileIndex], fileid);//, timeout, logBgTraffic);
//                                    System.out.println("\njsonString : " + jsonString);
//                                    System.out.println("\nControl FIle : " + data[controlFileIndex]);
//
//                                    /* Locally keep the corresponding control file to each client*/
//                                    PrintWriter writer;
//
//                                    if (!file1.exists()) {
//                                        file1.mkdirs();
//                                    }
//
//                                    try {
//
//                                        writer = new PrintWriter(file1 + "/" + d.macAddress + "_" + fileid + "_confFile");
//                                        writer.write(data[controlFileIndex]);
//                                        writer.flush();
//                                        writer.close();
//                                    } catch (FileNotFoundException ex) {
//                                        System.out.println("\nException : " + ex.toString());
//                                        ex.printStackTrace();
////                                return false;
//                                    }
//
//                                    //writer.close();
//                                    System.out.println("\nDevice Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
//                                    Thread sendData = new Thread(new SendData(mySession, d, 7, jsonString, data[controlFileIndex]));
//                                    sendData.start();
//                                    numberOfClientReqs++;
//                                    totalNumberOfClientReqs++;
//                                    if (mySession.getSendCtrlFileSelectedClients().size() > totalNumberOfClientReqs && numberOfClientReqs == Integer.parseInt(numclients)) {
//                                        numberOfClientReqs = 0;
//                                        try {
//                                            System.out.println("\nSLEEPING");
//                                            Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
//                                        } catch (InterruptedException ex) {
//                                            System.out.println(ex.toString());
//                                        }
//                                    }
//
//                                } else {
//                                    break;
//                                }
//                                controlFileIndex++;
//                            }
//                        }
//
//                        try {
//                            Thread.sleep(5 * 1000); // seconds
//                            mySession.setSendingControlFileStatus(false);
//                        } catch (Exception ex) {
//                            ex.printStackTrace();
//                        }
                    } else {
                        // file does not exist
                        System.out.println("File not exists: " + file);

                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                    System.out.println("\nException EXXX : " + ex.toString());
                }

            }
        };

        Thread t = new Thread(run);
        t.start();

//        return true;
    }

    public static void isendControlFile(final String fileid, final String file_name, final String newOrOld, final String numclients, final String duration, final Session mySession) {//, String timeout, String logBgTraffic) {

        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);

        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    File file = null;
                    File file1 = null;

                    if (Constants.experimentDetailsDirectory.endsWith("/")) {
                        file = new File(Constants.experimentDetailsDirectory + Constants.controlFile + "/" + fileid + "/" + file_name);
                        file1 = new File(Constants.experimentDetailsDirectory + Constants.controlFile + "/" + fileid + "/clients");
                    } else {
                        file = new File(Constants.experimentDetailsDirectory + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                        file1 = new File(Constants.experimentDetailsDirectory + "/" + Constants.controlFile + "/" + fileid + "/clients");
                    }

                    if (file.exists()) {
                        Charset charset = Charset.forName("UTF-8");
                        String line = null;

                        String[] data = new String[1000];//
                        int index = 0;
                        data[index] = "";
                        try {
                            BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                            Calendar cal = Calendar.getInstance();
                            while ((line = reader.readLine()) != null) {

                                System.out.println("\nLENGTH : " + line.length());

                                if (line.isEmpty() || line.trim().equals("")) {
                                    System.out.println("\nCASE1");
                                    continue;
                                } else if (line.trim().equals("*****\n")) {
                                    System.out.println("\nCASE2");
                                    //     data[index] = fileid + "\n" + data[index];
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else if (line.trim().equals("*****")) {
                                    System.out.println("\nCASE3");
                                    //      data[index] = fileid + "\n" + data[index];
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else {
                                    // System.out.println("\nLine : " + line.trim());
                                }

                                data[index] += line + "\n";

                            }

                            System.out.println("\nEXIT FROM LOOP");

                            //data[index] = fileid + "\n" + data[index];
                        } catch (IOException ex) {
                            System.out.println(ex.toString());

//                    System.out.println(ex.toString());
//                    return false;
                        }

                        System.out.println("\nSIZE : " + mySession.getFilteredClients().size());
                        int controlFileIndex = 0;

                        System.out.println("\nONE");

//                ResultSet rs1 = DBManager.getControlFileUserInfo(fileid);
                        String mac = "";
                        ConcurrentHashMap<String, Integer> Clients = null;// DBManager.getControlFileUserInfo(fileid,1);
                        //new ConcurrentHashMap<String, Integer>();

//-------------------------------------------------                
//                try {
//                    mac = rs1.getString("maclist").trim();
//                    if (mac != null && mac != "") {
//                        String[] macList = mac.split(" ");
//
//                        for (int i = 0; i < macList.length; i++) {
//                            Clients.put(macList[i], i);
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    System.out.println("SQL Exception : " + ex.toString());
//                }
//-------------------------------------------------
                        int numberOfClientReqs = 0;
                        int totalNumberOfClientReqs = 0;
//                        int userId = DBManager.getUserId(file_name)

                        for (DeviceInfo d : mySession.getFilteredClients()) {

                            System.out.println("\nTHREAD NAME : " + Thread.currentThread().getName());

                            if (newOrOld.equalsIgnoreCase("selectOldFile") && Clients.get(d.getMacAddress()) != null) {
                                System.out.println("\nSending COntrol FIle : Mac :" + d.getMacAddress() + " already have file : " + fileid);
                            } else {

                                System.out.println("\nTWO");
                                if (controlFileIndex >= mySession.getFilteredClients().size()) {
                                    System.out.println("\nTHREE");
                                    break;
                                } else if (data[controlFileIndex] != null) {
                                    System.out.println("\nFOUR" + "\n\n" + data[controlFileIndex]);
                                    String jsonString = Utils.getControlFileJson(data[controlFileIndex], 1, fileid);//, timeout, logBgTraffic);
                                    System.out.println("\njsonString : " + jsonString);
                                    System.out.println("\nControl FIle : " + data[controlFileIndex]);

                                    /* Locally keep the corresponding control file to each client*/
                                    PrintWriter writer;

                                    if (!file1.exists()) {
                                        file1.mkdirs();
                                    }

                                    try {

                                        writer = new PrintWriter(file1 + "/" + d.macAddress + "_" + fileid + "_confFile");
                                        writer.write(data[controlFileIndex]);
                                        writer.flush();
                                        writer.close();
                                    } catch (FileNotFoundException ex) {
                                        System.out.println("\nException : " + ex.toString());
                                        ex.printStackTrace();
//                                return false;
                                    }

                                    //writer.close();
                                    System.out.println("\nDevice Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                                    Thread sendData = new Thread(new SendData(mySession, d, 7, jsonString, data[controlFileIndex]));
                                    sendData.start();
                                    numberOfClientReqs++;
                                    totalNumberOfClientReqs++;
//                                    if (mySession.getFilteredClients().size() > totalNumberOfClientReqs && numberOfClientReqs == Integer.parseInt(numclients)) {
//                                        numberOfClientReqs = 0;
//                                        try {
//                                            System.out.println("\nSLEEPING");
//                                            Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
//                                        } catch (InterruptedException ex) {
//                                            System.out.println(ex.toString());
//                                        }
//                                    }

                                } else {
                                    break;
                                }
                                controlFileIndex++;
                            }
                        }

                        try {
                            Thread.sleep(5 * 1000); // seconds
                            mySession.setSendingControlFileStatus(false);
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }

                    } else {

                    }

                } catch (Exception ex) {
                    ex.printStackTrace();
                    System.out.println("\nException EXXX : " + ex.toString());
//            return false;
                }

            }
        };

//        run = new Runnable() {
//            @Override
//            public void run() {
//                for (int i = 0; i < 10; i++) {
//                    System.out.println("HAIII");
//                }
//
//            }
//        };
        Thread t = new Thread(run);
        t.start();

//        return true;
    }

    //**************************************************************************************************************************************

    /*
    
    
    public static void sendControlFile(final String fileid, final String file_name, final String newOrOld, final String numclients, final String duration) {//, String timeout, String logBgTraffic) {
        
        System.out.println("\n***********THREAD NAME : "+Thread.currentThread().getName());
        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    _sendControlFile(fileid, file_name, newOrOld, numclients, duration);
                } catch (Exception ex) {
                    System.out.println("\nException ex" + ex.toString());
                }
            }
        };
        Thread t = new Thread(run);
        t.start();
    }

    public static void _sendControlFile(String fileid, String file_name, String newOrOld, String numclients, String duration) {//, String timeout, String logBgTraffic) {

        System.out.println("\nFile ID=" + fileid + " Name=" + file_name);
        try {
            File file = null;
            File file1 = null;

            if (Constants.experimentDetailsDirectory.endsWith("/")) {
                file = new File(Constants.experimentDetailsDirectory + Constants.controlFile + "/" + fileid + "/" + file_name);
                file1 = new File(Constants.experimentDetailsDirectory + Constants.controlFile + "/" + fileid + "/clients");
            } else {
                file = new File(Constants.experimentDetailsDirectory + "/" + Constants.controlFile + "/" + fileid + "/" + file_name);
                file1 = new File(Constants.experimentDetailsDirectory + "/" + Constants.controlFile + "/" + fileid + "/clients");
            }

            if (file.exists()) {
                Charset charset = Charset.forName("UTF-8");
                String line = null;

                String[] data = new String[1000];//
                int index = 0;
                data[index] = "";
                try {
                    BufferedReader reader = Files.newBufferedReader(file.toPath(), charset);
                    Calendar cal = Calendar.getInstance();
                    while ((line = reader.readLine()) != null) {

                        System.out.println("\nLENGTH : " + line.length());

                        if (line.isEmpty() || line.trim().equals("")) {
                            System.out.println("\nCASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            System.out.println("\nCASE2");
                            //     data[index] = fileid + "\n" + data[index];
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            System.out.println("\nCASE3");
                            //      data[index] = fileid + "\n" + data[index];
                            index++;
                            data[index] = "";
                            continue;
                        } else {
                            // System.out.println("\nLine : " + line.trim());
                        }

                        
                        data[index] += line + "\n";

                    }

                    System.out.println("\nEXIT FROM LOOP");

                    //data[index] = fileid + "\n" + data[index];
                } catch (IOException ex) {
                    System.out.println(ex.toString());
                            
//                    System.out.println(ex.toString());
//                    return false;
                }

                System.out.println("\nSIZE : " + mySession.getFilteredClients().size());
                int controlFileIndex = 0;

                System.out.println("\nONE");

//                ResultSet rs1 = DBManager.getControlFileUserInfo(fileid);
                String mac = "";
                ConcurrentHashMap<String, Integer> Clients = DBManager.getControlFileUserInfo(fileid);
                //new ConcurrentHashMap<String, Integer>();

//-------------------------------------------------                
//                try {
//                    mac = rs1.getString("maclist").trim();
//                    if (mac != null && mac != "") {
//                        String[] macList = mac.split(" ");
//
//                        for (int i = 0; i < macList.length; i++) {
//                            Clients.put(macList[i], i);
//                        }
//                    }
//
//                } catch (SQLException ex) {
//                    System.out.println("SQL Exception : " + ex.toString());
//                }
//-------------------------------------------------
                int numberOfClientReqs = 0;
                int totalNumberOfClientReqs = 0;

                for (DeviceInfo d : mySession.getFilteredClients()) {
                    
                     System.out.println("\nTHREAD NAME : "+Thread.currentThread().getName());

                    if (newOrOld.equalsIgnoreCase("selectOldFile") && Clients.get(d.getMacAddress()) != null) {
                        System.out.println("\nSending COntrol FIle : Mac :" + d.getMacAddress() + " already have file : " + fileid);
                    } else {

                        System.out.println("\nTWO");
                        if (controlFileIndex >= mySession.getFilteredClients().size()) {
                            System.out.println("\nTHREE");
                            break;
                        } else if (data[controlFileIndex] != null) {
                            System.out.println("\nFOUR" + "\n\n" + data[controlFileIndex]);
                            String jsonString = Utils.getControlFileJson(data[controlFileIndex], fileid);//, timeout, logBgTraffic);
                            System.out.println("\njsonString : " + jsonString);
                            System.out.println("\nControl FIle : " + data[controlFileIndex]);

                            
                            PrintWriter writer;

                            if (!file1.exists()) {
                                file1.mkdirs();
                            }

                            try {

                                writer = new PrintWriter(file1 + "/" + d.macAddress + "_" + fileid + "_confFile");
                                writer.write(data[controlFileIndex]);
                                writer.flush();
                                writer.close();
                            } catch (FileNotFoundException ex) {
                                System.out.println("\nException : " + ex.toString());
                                ex.printStackTrace();
//                                return false;
                            }

                            //writer.close();
                            System.out.println("\nDevice Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                            Thread sendData = new Thread(new SendData(Integer.parseInt(fileid), d, 7, jsonString, data[controlFileIndex]));
                            sendData.start();
                            numberOfClientReqs++;
                            totalNumberOfClientReqs++;
                            if (mySession.getFilteredClients().size() > totalNumberOfClientReqs && numberOfClientReqs == Integer.parseInt(numclients)) {
                                numberOfClientReqs = 0;
                                try {
                                    System.out.println("\nSLEEPING");
                                    Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
                                } catch (InterruptedException ex) {
                                    System.out.println(ex.toString());
                                }
                            }

                        } else {
                            break;
                        }
                        controlFileIndex++;
                    }
                }
            } else {

            }

        } catch (Exception ex) {
            ex.printStackTrace();
            System.out.println("\nException EXXX : " + ex.toString());
//            return false;
        }
//        return true;
    }
    
    
     */
    public static boolean startRandomExperiment(int expId, int numberOfClients) {
        return false;
    }

    public static void sendApSettings(String settings, Session mySession) {

        mySession.setChangeApRunning(true);
        String jsonString = Utils.getApSettingsFileJson(settings);
        CopyOnWriteArrayList<String> clients = mySession.getChangeApSelectedClients();
        mySession.getChangeApFilteredClients().clear();
        for (int i = 0; i < clients.size(); i++) {
            DeviceInfo device = initilizeServer.getAllConnectedClients().get(clients.get(i));
            mySession.getChangeApFilteredClients().put(clients.get(i), "Sending...");
            Thread sendData = new Thread(new SendData(mySession, device, 3, jsonString));
            sendData.start();
        }
    }

    public static void sendAppUpdateRequest(Session mySession) {

        mySession.setAppUpdateRunning(true);
        mySession.getAppUpdateFilteredClients().clear();

        CopyOnWriteArrayList<String> clients = mySession.getAppUpdateSelectedClients();
        for (int i = 0; i < clients.size(); i++) {
            String mac = clients.get(i);
            mySession.getAppUpdateFilteredClients().put(mac, "Sending...");
            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
            String jsonString = getUpdateReqJson();
            Thread sendData = new Thread(new SendData(mySession, device, 8, jsonString));
            sendData.start();
        }
    }

    public static ConcurrentHashMap<String, String> getAccessPointConnectionDetails(Session mySession) {

        ConcurrentHashMap<String, String> apConnection = new ConcurrentHashMap<String, String>();
        Enumeration macList = mySession.selectedConnectedClients.keys();

        while (macList.hasMoreElements()) {
            String macAddr = (String) macList.nextElement();
            DeviceInfo device = mySession.selectedConnectedClients.get(macAddr);
            CopyOnWriteArrayList<DeviceInfo> activeclients = activeClients(mySession);

            if (!device.getBssid().equals("") && !device.getBssid().equalsIgnoreCase("bssid") && device.getBssid() != null) {
                if (apConnection.get(device.getBssid()) == null) {

                    if (activeclients.contains(device)) {
                        apConnection.put(device.getBssid(), device.getSsid() + "#1#1#0");
                    } else {
                        apConnection.put(device.getBssid(), device.getSsid() + "#1#0#1");
                    }

                } else {
                    String ssid_count = apConnection.get(device.getBssid());
                    int count = Integer.parseInt(ssid_count.split("#")[1]);
                    count++;

                    int activecount = Integer.parseInt(ssid_count.split("#")[2]);
                    int passivecount = Integer.parseInt(ssid_count.split("#")[3]);

                    if (activeclients.contains(device)) {
                        activecount++;
                    } else {
                        passivecount++;
                    }

                    apConnection.put(device.getBssid(), device.getSsid() + "#" + Integer.toString(count) + "#" + Integer.toString(activecount) + "#" + Integer.toString(passivecount));
                }
            }
        }
        return apConnection;
    }


    /*public static ConcurrentHashMap<String, String> getAccessPointConnectionDetails() {

        ConcurrentHashMap<String, String> apConnection = new ConcurrentHashMap<String, String>();
        Enumeration macList = mySession.selectedConnectedClients.keys();

        while (macList.hasMoreElements()) {
            String macAddr = (String) macList.nextElement();
            DeviceInfo device = mySession.selectedConnectedClients.get(macAddr);

            if (apConnection.get(device.getBssid()) == null) {
                apConnection.put(device.getBssid(), device.getSsid() + "#1");
            } else {
                String ssid_count = apConnection.get(device.getBssid());
                int count = Integer.parseInt(ssid_count.split("#")[1]);
                count++;
                apConnection.put(device.getBssid(), device.getSsid() + "#" + Integer.toString(count));
            }
        }
        return apConnection;
    }*/
    public static int getClientListForLogRequest(int expId) {

        System.out.println("\nGetLogFile Request ExpID : " + expId);
        CopyOnWriteArrayList<String> clients = DBManager.getClientsForLogRequest(expId);

        String[] list = new String[clients.size()];

        for (int i = 0; i < clients.size(); i++) {
            list[i] = clients.get(i);
            list[i] = expId + "_" + list[i];
            System.out.println("\nGetLogFile Request CLient " + list[i]);
        }

//        Utils.requestLogFiles(5, 5, list);
        return clients.size();

    }

    public static void requestLogFiles(final int clientsPerRound, final int roundGap, final Session mySession) {

//        mySession.setFetchingLogFiles(true);
        mySession.setReqLogFileRunning(true);

        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    int requested = 0;

                    for (int i = 0; i < mySession.getRequestLogFileSelectedClients().size(); i++) {

                        mySession.getRequestLogFileFilteredClients().clear();
                        String macAddr = mySession.getRequestLogFileSelectedClients().get(i);
                        mySession.getRequestLogFileFilteredClients().put(macAddr, "Sending...");

                        String json = Utils.getLogFilesJson(1);
                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddr);
                        System.out.println("Req File Mac : " + macAddr + " Json : " + json + " Time : " + Utils.getCurrentTimeStamp());

                        Thread sendData = new Thread(new SendData(mySession, device, 4, json));
                        sendData.start();
                        requested++;
                        if (requested == clientsPerRound) {
                            requested = 0;
                            try {
//                                System.out.println("");
                                Thread.sleep(roundGap * 1000); // seconds
                            } catch (InterruptedException ex) {
                                System.out.println(ex.toString());
                            }
                        }

                    }

                    try {
                        Thread.sleep(7000);
                        mySession.setReqLogFileRunning(false);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }

                } catch (Exception ex) {
                    System.out.println("\nException ex" + ex.toString());
                }
            }
        };

        Thread t = new Thread(run);
        t.start();
//        mySession.setFetchingLogFiles(false);

//            int totalClients = clientList.length;
//            if (clientsPerRound >= mySession.getGetLogFilefFilteredDevices().size()) {
//
//                Enumeration<String> macList = mySession.getGetLogFilefFilteredDevices().keys();
//                while (macList.hasMoreElements()) {
//                    String macAddr = macList.nextElement();
//                    String json = Utils.getLogFilesJson(1);
//                    DeviceInfo d = mySession.getConnectedClients().get(macAddr);
//                    System.out.println("\nMac Addr : " + macAddr);
//                    System.out.println("\nJson : " + json);
//                    Thread sendData = new Thread(new SendData(1, d, 4, json));
//                    sendData.start();
//                }
//                for (String client : clientList) {
//
//                    String value[] = client.split("_");
//                    int expID = Integer.parseInt(value[0]);
//                    String macAddr = value[1];
//                    String json = Utils.getLogFilesJson(expID);
//                    DeviceInfo d = mySession.getConnectedClients().get(macAddr);
//                    System.out.println("\nMac Addr : " + macAddr);
//                    System.out.println("\nJson : " + json);
//                    Thread sendData = new Thread(new SendData(expID, d, 4, json));
//                    sendData.start();
//                }
//            } else {
//
//                int requested = 0;
//
//                Enumeration<String> macList = mySession.getGetLogFilefFilteredDevices().keys();
//                while (macList.hasMoreElements()) {
//                    String macAddr = macList.nextElement();
//                    String json = Utils.getLogFilesJson(1);
//                    DeviceInfo d = mySession.getConnectedClients().get(macAddr);
//                    System.out.println("\nMac Addr : " + macAddr);
//                    System.out.println("\nJson : " + json);
//                    Thread sendData = new Thread(new SendData(1, d, 4, json));
//                    sendData.start();
//                    requested++;
//
//                    if (requested == clientsPerRound) {
//                        requested = 0;
//                        try {
//                            Thread.sleep(roundGap * 1000); // seconds
//                        } catch (InterruptedException ex) {
//                            System.out.println(ex.toString());
//                        }
//                    }
//                }
//                while (totalClients > 0) {
//
//                    if (totalClients > clientsPerRound) {
//
//                        for (int i = 0; i < clientsPerRound; i++) {
//                            String value[] = clientList[index].split("_");
//                            int expID = Integer.parseInt(value[0]);
//                            String macAddr = value[1];
//                            String json = Utils.getLogFilesJson(expID);
//                            DeviceInfo d = mySession.getConnectedClients().get(macAddr);
//                            System.out.println("\nMac Addr : " + macAddr);
//                            System.out.println("\nJson : " + json);
//                            Thread sendData = new Thread(new SendData(expID, d, 4, json));
//                            sendData.start();
//                            index++;
//                        }
//                        totalClients = totalClients - clientsPerRound;
//                    } else {
//
//                        for (int i = 0; i < totalClients; i++) {
//
//                            String value[] = clientList[index].split("_");
//                            int expID = Integer.parseInt(value[0]);
//                            String macAddr = value[1];
//                            String json = Utils.getLogFilesJson(expID);
//                            DeviceInfo d = mySession.getConnectedClients().get(macAddr);
//                            System.out.println("\nMac Addr : " + macAddr);
//                            System.out.println("\nJson : " + json);
//                            Thread sendData = new Thread(new SendData(expID, d, 4, json));
//                            sendData.start();
//                            index++;
//                        }
//                        totalClients = 0;
//                    }
//
//                    try {
//                        Thread.sleep(roundGap * 1000); // seconds
//                    } catch (InterruptedException ex) {
//                        System.out.println(ex.toString());
//                    }
//                }
    }

    public static void sendStopExperiment(int expid, String username, Session mySession) {

        
          
                  
                  

//        DBManager.updateStopExperiment(expid);
        DBManager.stopExperiment(username,expid);
        String jsonString = Utils.getStopSignalJson();
        
        for(int i=0;i<mySession.getStartExpSelectedClients().size();i++){
            String mac = mySession.getStartExpSelectedClients().get(i);
            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
            Thread sendData = new Thread(new SendData(mySession, device, 1, jsonString));
            sendData.start();
        }
    }

    public static void sendHeartBeatDuration(String duration, Session mySession) {

        String jsonString = Utils.getHeartBeatDuration(duration);
        for (DeviceInfo d : mySession.getConfigFilteredDevices()) {
            Thread sendData = new Thread(new SendData(mySession, d, 5, jsonString));
            sendData.start();
        }
    }

    public static void sendServerConfiguration(String serverIP, String serverPORT, String connectionPORT, Session mySession) {

        String jsonString = Utils.getServerConfiguration(serverIP, serverPORT, connectionPORT);
        for (DeviceInfo d : mySession.getConfigFilteredDevices()) {
            Thread sendData = new Thread(new SendData(mySession, d, 6, jsonString));
            sendData.start();
        }
    }

    public static void sendWakeUpRequest(String filter, String duration, Session mySession) {

        // mySession.getWakeUpTimerSelectedClients().contains();
        // mySession.setSendingWakeUpRequest(true);
        mySession.setWakeUpTimerRunning(true);
        getSelectedConnectedClients(mySession);
        String jsonString = Utils.getWakeUpClientsJson(duration);

        initilizeServer.getWakeUpTimerFilteredClients().clear();

        if (filter.equalsIgnoreCase("bssid")) {

            Enumeration<String> macs = mySession.getSelectedConnectedClients().keys();
            while (macs.hasMoreElements()) {
                String mac = macs.nextElement();
                
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                if (mySession.getWakeUpTimerSelectedClients().contains(device.getBssid())) {
                    initilizeServer.getWakeUpTimerFilteredClients().put(mac, "Sending...");
                    Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                    sendData.start();
                }
            }

        } else if (filter.equalsIgnoreCase("ssid")) {

            Enumeration<String> macs = mySession.getSelectedConnectedClients().keys();
            while (macs.hasMoreElements()) {
                String mac = macs.nextElement();
                initilizeServer.getWakeUpTimerFilteredClients().put(mac, "Sending...");
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                if (mySession.getWakeUpTimerSelectedClients().contains(device.getSsid())) {
                    Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                    sendData.start();
                }
            }

        } else if (filter.equalsIgnoreCase("clientSpecific")) { // based on mac address "Set TO all' 

            CopyOnWriteArrayList<String> clients = mySession.getWakeUpTimerSelectedClients();
            for (int i = 0; i < clients.size(); i++) {
                String mac = clients.get(i);
                initilizeServer.getWakeUpTimerFilteredClients().put(mac, "Sending...");
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                sendData.start();
            }

            /*
            Enumeration<String> macs = mySession.getSelectedConnectedClients().keys();
            while (macs.hasMoreElements()) {
                String mac = macs.nextElement();
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                if(mySession.getWakeUpTimerSelectedClients().contains(mac)){
                    Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                    sendData.start();
                }
            }
             */
        } else { // based on mac address "Set TO all' 

            Enumeration<String> macs = mySession.getSelectedConnectedClients().keys();
            while (macs.hasMoreElements()) {
                String mac = macs.nextElement();
                initilizeServer.getWakeUpTimerFilteredClients().put(mac, "Sending...");
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                sendData.start();
            }
        }
//        mySession.setSendingWakeUpRequest(false);
    }

    /**
     *
     * @param session
     * @param UserID
     * @param update Needs to be synchronized update is +ve or -ve
     */
    public static void updateLoginInstances(String username, int update) {

        try {
            int instance = initilizeServer.getUserNameToInstacesMap().get(username);
            initilizeServer.getUserNameToInstacesMap().put(username, update + instance);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}


// getStopSignalJson
