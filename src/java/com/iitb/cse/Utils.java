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

    /*
        JSON message for change AP request
    */
    static String getApSettingsFileJson(String message) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.sendApSettings);
        String[] apConf = message.split("\n");
        initilizeServer.logger.info(apConf.length);

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
                    obj.put(Constants.password, "");
                } else {
                    String _passwd = apInfo[1].trim();
                    obj.put(Constants.password, _passwd);
                }

            } else if (apInfo[0].equalsIgnoreCase("TIMER")) {
                if (apInfo.length == 1) {
                    obj.put(Constants.timer, "");
                } else {
                    String _bssid = apInfo[1].trim();
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

        String jsonString = obj.toJSONString();
        initilizeServer.logger.info(jsonString);
        return jsonString;
    }

    /**
     * JSON Message for sending control file
     * genetated and returns the String in Json format. String contains
     * information about the action for sending AP settings file This string is
     * later sent to filtered devices.
     */
    @SuppressWarnings("unchecked")
    static String getControlFileJson(String message, int userId, String fileId) {//, String timeout, String logBgTraffic) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.sendControlFile);
        obj.put(Constants.textFileFollow, Boolean.toString(true));
        obj.put(Constants.message, message);
        obj.put(Constants.fileId, userId + "_" + fileId);
        String jsonString = obj.toJSONString();
        initilizeServer.logger.info("HAI : " + jsonString);//+ obj1);
        return jsonString;
    }

    /*
        JSON message for sending wakeup timer
    */
    
    @SuppressWarnings("unchecked")
    static String getWakeUpClientsJson(String time) {//, String timeout, String logBgTraffic) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.wakeup);
        obj.put(Constants.duration, time);
        String jsonString = obj.toJSONString();
        initilizeServer.logger.info("HAI : " + jsonString);//+ obj1);
        return jsonString;
    }

    /*
        JSON message for start experiment request
    */
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
        initilizeServer.logger.info(jsonString + obj1);
        return jsonString;
    }

    /*
        JSON message for start experiment request
    */
    @SuppressWarnings("unchecked")
    static String getExpJson(String timeout, String expStartTime, String logBgTraffic, String file_id, int expID, int userID) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.startExp);
        obj.put(Constants.textFileFollow, Boolean.toString(true));
        obj.put(Constants.serverTime, Long.toString(Calendar.getInstance().getTimeInMillis()));
        obj.put(Constants.timeout, timeout);
        obj.put(Constants.expStartTime, expStartTime);
        obj.put(Constants.fileId, userID+"_"+file_id);
        obj.put(Constants.experimentid, userID + "_" + expID);
        obj.put("selectiveLog", logBgTraffic);
        String jsonString = obj.toJSONString();
        Date obj1 = new Date(Long.parseLong((String) obj.get(Constants.serverTime)));
        initilizeServer.logger.info(jsonString + obj1);
        return jsonString;
    }
    
    /*
        JSON message for setting heartbeat duration
    */
    @SuppressWarnings("unchecked")
    static String getHeartBeatDuration(String duration) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, "hbDuration");
        obj.put("heartbeat_duration", duration);
        obj.put("hbDuration", duration);
        String jsonString = obj.toJSONString();
        initilizeServer.logger.info(jsonString);
        return jsonString;
    }

    /*
        JSON message for sending server configuration
    */
    @SuppressWarnings("unchecked")
    static String getServerConfiguration(String serverIP, String serverPORT, String connectionPORT) {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, "action_changeServer");

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
        initilizeServer.logger.info(jsonString);
        return jsonString;
    }

    /**
     * JSON Message for stopping experiment
     * genetated and returns the String in Json format. String contains
     * information that the experiment has been stopped by experimenter This
     * string is later sent to filtered devices.
     */
    @SuppressWarnings("unchecked")
    static String getStopSignalJson() {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, Constants.stopExperiment);
        String jsonString = obj.toJSONString();
        initilizeServer.logger.info(jsonString);
        return jsonString;
    }

    /**
     * JSON message for requesting log files
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
        initilizeServer.logger.info(jsonString);
        return jsonString;
    }

    /*
        JSON message for sending app update request
    */
    @SuppressWarnings("unchecked")
    static String getUpdateReqJson() {
        JSONObject obj = new JSONObject();
        obj.put(Constants.action, "action_updateAvailable");
        String jsonString = obj.toJSONString();
        initilizeServer.logger.info(jsonString);
        return jsonString;
    }
 
    /*
        Current date and time
    */
    public static Date getCurrentTimeStamp() {
        Date date = Calendar.getInstance().getTime();
        return date;
    }

    /*
        Create/reuse a user session
    */
    public static void createSession(String username, int userId) {
        /* Session doesnot exists*/
        if (initilizeServer.getUserNameToSessionMap().get(username) == null) {
            Session session = new Session(username, userId);
            initilizeServer.getUserNameToSessionMap().put(username, session);
            initilizeServer.getUserNameToInstacesMap().put(username, 1);
            initilizeServer.logger.info("Creating a new session");
        } else {
            initilizeServer.logger.info("Session for User already exists");
            Utils.updateLoginInstances(username, 1);
        }
    }

    /*
        Get all BSSIDs
    */
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
            initilizeServer.logger.error("Exception",ex);
        }
        return bssidList;
    }

    /*
        Get all SSIDs
    */
    public static Enumeration<String> getAllSsids(Session mySession) {

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
            initilizeServer.logger.error("Exception",ex);
        }

        return ssidList;
    }

    /*
        Get all clients connected to selected BSSIDs from dashboard setting
    */
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
            initilizeServer.logger.error("Exception",ex);
        }
    }

    /*
        Get all Avtive clients
    */
    public static CopyOnWriteArrayList<DeviceInfo> activeClients(Session mySession) {

        getSelectedConnectedClients(mySession);
        CopyOnWriteArrayList<DeviceInfo> activeClients = new CopyOnWriteArrayList<DeviceInfo>();
        try {
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
            initilizeServer.logger.error("Exception",ex);
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

                        initilizeServer.logger.info("LENGTH : " + line.length());

                        if (line.isEmpty() || line.trim().equals("")) {
                            initilizeServer.logger.info("CASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            initilizeServer.logger.info("CASE2");
                            data[index] = expId + "\n" + data[index];
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            initilizeServer.logger.info("CASE3");
                            data[index] = expId + "\n" + data[index];
                            index++;
                            data[index] = "";
                            continue;
                        }

                        String[] lineVariables = line.split(" ");
                        double time = Double.parseDouble(lineVariables[1]);

                        int sec = (int) time;
                        double rem = time % 1;
                        int remainder = (int) (rem * 1000);
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
                            data[index] += generateLine(cal, lineVariables[2], lineVariables[0], lineVariables[3], lineVariables[4]);
                        } else {
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
                    return false;
                }

                int controlFileIndex = 0;
                for (DeviceInfo d : mySession.getFilteredClients()) {

                    if (controlFileIndex >= mySession.getFilteredClients().size()) {
                        break;
                    } else if (data[controlFileIndex] != null) {

                        String jsonString = Utils.getExperimentJson(data[controlFileIndex], timeout, logBgTraffic);
                        initilizeServer.logger.info("jsonString : " + jsonString);
                        initilizeServer.logger.info("Control FIle : " + data[controlFileIndex]);

                        /* Locally keep the corresponding control file to each client*/
                        PrintWriter writer;
                        try {

                            writer = new PrintWriter(file1 + "/" + d.macAddress + "_confFile");
                            writer.write(data[controlFileIndex]);
                            writer.flush();
                            writer.close();
                        } catch (FileNotFoundException ex) {
                            return false;
                        }

                        //writer.close();
                        initilizeServer.logger.info("Device Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                        Thread sendData = new Thread(new SendData(mySession, d, 0, jsonString, data[controlFileIndex]));
                        sendData.start();
                    } else {
                        break;
                    }
                    controlFileIndex++;
                }
            } else {
                return false;
            }

        } catch (Exception ex) {
            return false;
        }
        return true;
    }

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
                                initilizeServer.logger.error("Exception",ex);
                            }
                        }
                    }

                    try {
                        Thread.currentThread().sleep(expAckWaitTime * 1000);;
                    } catch (Exception ex) {
                        initilizeServer.logger.error("Exception",ex);
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
                            initilizeServer.logger.error("Exception",ex);
                        }
                    }
                }
            };
            Thread t = new Thread(run);
            t.start();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception",ex);
        }

        return status;
    }

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
                                initilizeServer.logger.info("jsonString : " + jsonString);
                                initilizeServer.logger.info("Device Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
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
                        initilizeServer.logger.info("Exception ex" + ex.toString());
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
                    initilizeServer.logger.info("Exception ex" + ex.toString());
                }
            }
        };
        Thread t = new Thread(run);
        t.start();
    }

    public static boolean _reSendControlFile(String fileid, String file_name, String numclients, String duration, String username, Session mySession) {//, String timeout, String logBgTraffic) {

        initilizeServer.logger.info("File ID=" + fileid + " Name=" + file_name);
        fileid = fileid.trim();
        file_name = file_name.trim();
        initilizeServer.logger.info("File ID=" + fileid + " Name=" + file_name);
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
                        initilizeServer.logger.info("LENGTH : " + line.length());
                        if (line.isEmpty() || line.trim().equals("")) {
                            initilizeServer.logger.info("CASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            initilizeServer.logger.info("CASE2");
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            initilizeServer.logger.info("CASE3");
                            index++;
                            data[index] = "";
                            continue;
                        } else {
                        }
                        data[index] += line + "\n";
                    }
                    initilizeServer.logger.info("EXIT FROM LOOP");
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
                            initilizeServer.logger.info("Reusing OLD control file :" + file2);
                            Scanner scanner = new Scanner(file2);
                            String filedata = "";
                            while (scanner.hasNextLine()) {
                                if (filedata.length() == 0) {
                                    filedata = scanner.nextLine();
                                } else {
                                    filedata += "\n" + scanner.nextLine();
                                }
                            }
                            initilizeServer.logger.info("Control FIle: " + filedata);
                            jsonString = Utils.getControlFileJson(filedata, userId, fileid);//, timeout, logBgTraffic);
                        } else {

                            initilizeServer.logger.info("FOUR" + "\n\n" + data[controlFileIndex]);
                            jsonString = Utils.getControlFileJson(data[controlFileIndex], userId, fileid);//, timeout, logBgTraffic);
                            initilizeServer.logger.info("jsonString : " + jsonString);
                            initilizeServer.logger.info("Control FIle : " + data[controlFileIndex]);

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
                                initilizeServer.logger.info("Exception : " + ex.toString());
                                initilizeServer.logger.error("Exception",ex);
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
                                initilizeServer.logger.info(ex.toString());
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
                    initilizeServer.logger.error("Exception",ex);
                }

            } else {
                return false;
            }

        } catch (Exception ex) {
            initilizeServer.logger.error("Exception",ex);
            initilizeServer.logger.info("Exception Ex : " + ex.toString());
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
                    initilizeServer.logger.info("Exception ex" + ex.toString());
                }
            }
        };
        Thread t = new Thread(run);
        t.start();
    }
    
    /*
    
    */
    public static boolean _ireSendControlFile(String fileid, String file_name, String numclients, String duration, Session mySession) {//, String timeout, String logBgTraffic) {
        

        initilizeServer.logger.info("File ID=" + fileid + " Name=" + file_name);
        fileid = fileid.trim();
        file_name = file_name.trim();
        initilizeServer.logger.info("File ID=" + fileid + " Name=" + file_name);
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
                        initilizeServer.logger.info("LENGTH : " + line.length());
                        if (line.isEmpty() || line.trim().equals("")) {
                            initilizeServer.logger.info("CASE1");
                            continue;
                        } else if (line.trim().equals("*****\n")) {
                            initilizeServer.logger.info("CASE2");
                            index++;
                            data[index] = "";
                            continue;
                        } else if (line.trim().equals("*****")) {
                            initilizeServer.logger.info("CASE3");
                            index++;
                            data[index] = "";
                            continue;
                        } else {
                        }
                        data[index] += line + "\n";
                    }
                    initilizeServer.logger.info("EXIT FROM LOOP");
                } catch (IOException ex) {
                    return false;
                }

                initilizeServer.logger.info("SIZE : " + mySession.getFilteredClients().size());
                int controlFileIndex = 0;

                initilizeServer.logger.info("ONE");

                String mac = "";

                int numberOfClientReqs = 0;
                int totalNumberOfClientReqs = 0;

                for (DeviceInfo d : mySession.getFilteredClients()) {

                    initilizeServer.logger.info("TWO");
                    if (controlFileIndex >= mySession.getFilteredClients().size()) {
                        initilizeServer.logger.info("THREE");
                        break;
                    } else if (data[controlFileIndex] != null) {

                        File file2 = new File(file1 + "/" + d.macAddress + "_" + fileid + "_confFile");
                        String jsonString = "";

                        if (file2.exists()) {
                            initilizeServer.logger.info("Reusing OLD control file :" + file2);
                            Scanner scanner = new Scanner(file2);
                            String filedata = "";
                            while (scanner.hasNextLine()) {
                                if (filedata.length() == 0) {
                                    filedata = scanner.nextLine();
                                } else {
                                    filedata += "\n" + scanner.nextLine();
                                }
                            }
                            initilizeServer.logger.info("Control FIle: " + filedata);
                            jsonString = Utils.getControlFileJson(filedata, 1, fileid);//, timeout, logBgTraffic);
                        } else {

                            initilizeServer.logger.info("FOUR" + "\n\n" + data[controlFileIndex]);
                            jsonString = Utils.getControlFileJson(data[controlFileIndex], 1, fileid);//, timeout, logBgTraffic);
                            initilizeServer.logger.info("jsonString : " + jsonString);
                            initilizeServer.logger.info("Control FIle : " + data[controlFileIndex]);

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
                                initilizeServer.logger.info("Exception : " + ex.toString());
                                initilizeServer.logger.error("Exception",ex);
                                return false;
                            }
                            controlFileIndex++;
                        }
                        //writer.close();
                        initilizeServer.logger.info("Device Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                        Thread sendData = new Thread(new SendData(mySession, d, 7, jsonString, data[controlFileIndex]));
                        sendData.start();
                        numberOfClientReqs++;
                        totalNumberOfClientReqs++;

                    } else {
                        break;
                    }

                }

                try {
                    Thread.sleep(7 * 1000); // seconds
                    mySession.setSendingControlFileStatus(false);
                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception",ex);
                }

            } else {

                return false;
            }

        } catch (Exception ex) {
            initilizeServer.logger.error("Exception",ex);
            initilizeServer.logger.info("Exception EXXX : " + ex.toString());
            return false;
        }
        return true;
    }

    //**************************************************************************************************************************************
    public static void _sendControlFile(final String fileid, final String file_name, final String newOrOld, final String numclients, final String duration) {//, String timeout, String logBgTraffic) {

        initilizeServer.logger.info("***********THREAD NAME : " + Thread.currentThread().getName());
        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    initilizeServer.logger.info("TESTING SERVER");

                } catch (Exception ex) {
                    initilizeServer.logger.info("Exception ex" + ex.toString());
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
                    initilizeServer.logger.info("File : " + file);
                    initilizeServer.logger.info("File1 : " + file1);

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
                            initilizeServer.logger.info(ex.toString());
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
                                    initilizeServer.logger.error("Exception",ex);
                                }

                                Thread sendData = new Thread(new SendData(mySession, device, 7, jsonString, fileid, userId));

                                sendData.start();
                                nbrOfReq++;

                                if (nbrOfReq == Integer.parseInt(numclients)) {
                                    nbrOfReq = 0;
                                    try {
                                        initilizeServer.logger.info("SLEEPING");
                                        Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
                                    } catch (InterruptedException ex) {
                                        initilizeServer.logger.info(ex.toString());
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
                            initilizeServer.logger.error("Exception",ex);
                        }

                    } else {
                        // file does not exist
                        initilizeServer.logger.info("File not exists: " + file);

                    }

                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception",ex);
                    initilizeServer.logger.info("Exception EXXX : " + ex.toString());
                }

            }
        };

        Thread t = new Thread(run);
        t.start();

    }

    public static void sendControlFile(final String fileid, final String file_name, final String numclients, final String duration, final String username, final Session mySession) {//, String timeout, String logBgTraffic) {

        initilizeServer.logger.info("File ID=" + fileid + " Name=" + file_name);
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
                    initilizeServer.logger.info("File : " + file);
                    initilizeServer.logger.info("File1 : " + file1);

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
                            initilizeServer.logger.info(ex.toString());
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
                                    initilizeServer.logger.error("Exception",ex);
                                }

                                Thread sendData = new Thread(new SendData(mySession, device, 7, jsonString, fileid, userId));

                                sendData.start();
                                nbrOfReq++;

                                if (nbrOfReq == Integer.parseInt(numclients)) {
                                    nbrOfReq = 0;
                                    try {
                                        initilizeServer.logger.info("SLEEPING");
                                        Thread.sleep(Integer.parseInt(duration) * 1000); // seconds
                                    } catch (InterruptedException ex) {
                                        initilizeServer.logger.info(ex.toString());
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
                            initilizeServer.logger.error("Exception",ex);
                        }
                    } else {
                        initilizeServer.logger.info("File not exists: " + file);
                    }

                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception",ex);
                    initilizeServer.logger.info("Exception EXXX : " + ex.toString());
                }

            }
        };

        Thread t = new Thread(run);
        t.start();
    }

    public static void isendControlFile(final String fileid, final String file_name, final String newOrOld, final String numclients, final String duration, final Session mySession) {//, String timeout, String logBgTraffic) {

        initilizeServer.logger.info("File ID=" + fileid + " Name=" + file_name);

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

                                initilizeServer.logger.info("LENGTH : " + line.length());

                                if (line.isEmpty() || line.trim().equals("")) {
                                    initilizeServer.logger.info("CASE1");
                                    continue;
                                } else if (line.trim().equals("*****\n")) {
                                    initilizeServer.logger.info("CASE2");
                                    //     data[index] = fileid + "\n" + data[index];
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else if (line.trim().equals("*****")) {
                                    initilizeServer.logger.info("CASE3");
                                    //      data[index] = fileid + "\n" + data[index];
                                    index++;
                                    data[index] = "";
                                    continue;
                                } else {
                                    // initilizeServer.logger.info("Line : " + line.trim());
                                }

                                data[index] += line + "\n";

                            }

                            initilizeServer.logger.info("EXIT FROM LOOP");

                        } catch (IOException ex) {
                            initilizeServer.logger.info(ex.toString());

                        }

                        initilizeServer.logger.info("SIZE : " + mySession.getFilteredClients().size());
                        int controlFileIndex = 0;

                        initilizeServer.logger.info("ONE");

                        String mac = "";
                        ConcurrentHashMap<String, Integer> Clients = null;// DBManager.getControlFileUserInfo(fileid,1);
          
                        int numberOfClientReqs = 0;
                        int totalNumberOfClientReqs = 0;

                        for (DeviceInfo d : mySession.getFilteredClients()) {

                            initilizeServer.logger.info("THREAD NAME : " + Thread.currentThread().getName());

                            if (newOrOld.equalsIgnoreCase("selectOldFile") && Clients.get(d.getMacAddress()) != null) {
                                initilizeServer.logger.info("Sending COntrol FIle : Mac :" + d.getMacAddress() + " already have file : " + fileid);
                            } else {

                                initilizeServer.logger.info("TWO");
                                if (controlFileIndex >= mySession.getFilteredClients().size()) {
                                    initilizeServer.logger.info("THREE");
                                    break;
                                } else if (data[controlFileIndex] != null) {
                                    initilizeServer.logger.info("FOUR" + "\n\n" + data[controlFileIndex]);
                                    String jsonString = Utils.getControlFileJson(data[controlFileIndex], 1, fileid);//, timeout, logBgTraffic);
                                    initilizeServer.logger.info("jsonString : " + jsonString);
                                    initilizeServer.logger.info("Control FIle : " + data[controlFileIndex]);

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
                                        initilizeServer.logger.info("Exception : " + ex.toString());
                                        initilizeServer.logger.error("Exception",ex);
                                    }

                                    initilizeServer.logger.info("Device Info : IP " + d.ip + " Port " + d.port + " Mac " + d.macAddress);
                                    Thread sendData = new Thread(new SendData(mySession, d, 7, jsonString, data[controlFileIndex]));
                                    sendData.start();
                                    numberOfClientReqs++;
                                    totalNumberOfClientReqs++;

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
                            initilizeServer.logger.error("Exception",ex);
                        }

                    } else {

                    }

                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception",ex);
                    initilizeServer.logger.info("Exception EXXX : " + ex.toString());
//            return false;
                }

            }
        };


        Thread t = new Thread(run);
        t.start();
    }

    
    /*
        Sending AP change requests
    */
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
    /*
        Send App update requests
    */
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

    /*
        Get Accesspoint wise information, it is shown in dashboard
    */
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

 
    public static int getClientListForLogRequest(int expId) {

        initilizeServer.logger.info("GetLogFile Request ExpID : " + expId);
        CopyOnWriteArrayList<String> clients = DBManager.getClientsForLogRequest(expId);

        String[] list = new String[clients.size()];

        for (int i = 0; i < clients.size(); i++) {
            list[i] = clients.get(i);
            list[i] = expId + "_" + list[i];
            initilizeServer.logger.info("GetLogFile Request CLient " + list[i]);
        }
        return clients.size();
    }

    /*
        Sending request for log files
    */
    public static void requestLogFiles(final int clientsPerRound, final int roundGap, final Session mySession) {

        mySession.setReqLogFileRunning(true);

        Runnable run = new Runnable() {
            @Override
            public void run() {

                try {
                    int requested = 0;
                    mySession.getRequestLogFileFilteredClients().clear();
                    for (int i = 0; i < mySession.getRequestLogFileSelectedClients().size(); i++) {
                        
                        String macAddr = mySession.getRequestLogFileSelectedClients().get(i);
                        mySession.getRequestLogFileFilteredClients().put(macAddr, "Sending...");

                        String json = Utils.getLogFilesJson(1);
                        DeviceInfo device = initilizeServer.getAllConnectedClients().get(macAddr);
                        initilizeServer.logger.info("Req File Mac : " + macAddr + " Json : " + json + " Time : " + Utils.getCurrentTimeStamp());

                        Thread sendData = new Thread(new SendData(mySession, device, 4, json));
                        sendData.start();
                        requested++;
                        if (requested == clientsPerRound) { // checking a round is finished, if yes sleep for duration b/w rounds
                            requested = 0;
                            try {
                                Thread.sleep(roundGap * 1000); // duration b/w rounds
                            } catch (InterruptedException ex) {
                                initilizeServer.logger.info(ex.toString());
                            }
                        }

                    }
                    // sleep for sometime to get log files, after this the retry option will appear in UI
                    try {
                        Thread.sleep(7000);
                        mySession.setReqLogFileRunning(false);
                    } catch (Exception ex) {
                        initilizeServer.logger.error("Exception",ex);
                    }

                } catch (Exception ex) {
                    initilizeServer.logger.info("Exception ex" + ex.toString());
                }
            }
        };

        Thread t = new Thread(run);
        t.start();
    }

    /*
        Sending stop experiment requests
    */
    public static void sendStopExperiment(int expid, String username, Session mySession) {

        DBManager.stopExperiment(username,expid);
        String jsonString = Utils.getStopSignalJson();
        for(int i=0;i<mySession.getStartExpSelectedClients().size();i++){
            String mac = mySession.getStartExpSelectedClients().get(i);
            DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
            Thread sendData = new Thread(new SendData(mySession, device, 1, jsonString));
            sendData.start();
        }
    }

    /*
        Sending new heartbeat duration
    */
    public static void sendHeartBeatDuration(String duration, Session mySession) {

        String jsonString = Utils.getHeartBeatDuration(duration);
        for (DeviceInfo d : mySession.getConfigFilteredDevices()) {
            Thread sendData = new Thread(new SendData(mySession, d, 5, jsonString));
            sendData.start();
        }
    }

    /*
        Sending server configurations
    */
    public static void sendServerConfiguration(String serverIP, String serverPORT, String connectionPORT, Session mySession) {

        String jsonString = Utils.getServerConfiguration(serverIP, serverPORT, connectionPORT);
        for (DeviceInfo d : mySession.getConfigFilteredDevices()) {
            Thread sendData = new Thread(new SendData(mySession, d, 6, jsonString));
            sendData.start();
        }
    }
    
    /*
        Send wake up timer
    */

    public static void sendWakeUpRequest(String filter, String duration, Session mySession) {

        mySession.setWakeUpTimerRunning(true);
        getSelectedConnectedClients(mySession);
        String jsonString = Utils.getWakeUpClientsJson(duration);

        initilizeServer.getWakeUpTimerFilteredClients().clear();
        /*
            Setting wakeup timer based on BSSID
        */
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

        } 
        /*
            Setting wakeup timer based on SSID
        */
        else if (filter.equalsIgnoreCase("ssid")) {

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

        } 
        /*
            Setting wakeup timer on set of clients
        */
        else if (filter.equalsIgnoreCase("clientSpecific")) { // based on mac address "Set TO all' 

            CopyOnWriteArrayList<String> clients = mySession.getWakeUpTimerSelectedClients();
            for (int i = 0; i < clients.size(); i++) {
                String mac = clients.get(i);
                initilizeServer.getWakeUpTimerFilteredClients().put(mac, "Sending...");
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                sendData.start();
            }

        } else { // set wakeup timer to all clients

            Enumeration<String> macs = mySession.getSelectedConnectedClients().keys();
            while (macs.hasMoreElements()) {
                String mac = macs.nextElement();
                initilizeServer.getWakeUpTimerFilteredClients().put(mac, "Sending...");
                DeviceInfo device = initilizeServer.getAllConnectedClients().get(mac);
                Thread sendData = new Thread(new SendData(mySession, device, 9, jsonString));
                sendData.start();
            }
        }
    }

    /**
     * Update the number of login instances for an user
     * @param session
     * @param UserID
     * @param update Needs to be synchronized update is +ve or -ve
     */
    public static void updateLoginInstances(String username, int update) {

        try {
            int instance = initilizeServer.getUserNameToInstacesMap().get(username);
            initilizeServer.getUserNameToInstacesMap().put(username, update + instance);
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception",ex);
        }
    }
}


