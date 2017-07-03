/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iitb.cse;

import java.io.BufferedWriter;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.simple.parser.ContainerFactory;
import org.json.simple.parser.JSONParser;

/**
 *
 * @author ratheeshkv
 */
class ConnectionInfo {

    String ip_addr;
    int port;

    public ConnectionInfo(String ip_addr, int port) {
        this.ip_addr = ip_addr;
        this.port = port;
    }

}

public class ClientConnection {

    private static ClientConnection connObj = new ClientConnection();
    private static Object synchObj = new Object();

    static boolean acceptConnection = true;

    /*
        Create a socket and listen for clients to connect
    */
    public static synchronized void startlistenForClients() {
        try {
            
            /*
                If socket with port number is already open, then close it
            */
            if (initilizeServer.listenSocket != null) {
                try {
                    initilizeServer.logger.info("Closing listening socket");
                    initilizeServer.listenSocket.close();
                    initilizeServer.listenSocket = null;
                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception",ex);;
                }

                try {
                    Thread.sleep(5000);
                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception",ex);;
                }
                startlistenForClients();
            }

            /*Creating new socket for clients to connect */
            initilizeServer.listenSocket = new ServerSocket(Constants.ConnectionPORT);
            while (true) {
                initilizeServer.logger.info("Listening for Client to Connect on PORT " + Constants.ConnectionPORT);
                // accept a client connection
                final Socket sock = initilizeServer.listenSocket.accept();
                initilizeServer.logger.info("Client Connected ......");
                Runnable r = new Runnable() {
                    @Override
                    public void run() {
                        initilizeServer.threadNo++;
                        ClientConnection.handleConnection(sock, initilizeServer.threadNo);
                    }
                };
                // serve the connected client
                Thread t = new Thread(r);
                t.start();
            }
        } catch (IOException ex) {
            initilizeServer.logger.error("Exception",ex);;
        }
    }

    /*
        Read from socket
    */
    public static String readFromStream(Socket socket, DataInputStream din, DataOutputStream dos) throws IOException {

        if (socket != null) {
            initilizeServer.logger.info("Trying to read from socket (blocking...) My Socket:" + socket);
            String data = "";
            int length = din.readInt();
            for (int i = 0; i < length; ++i) {
                data += (char) din.readByte();
            }
            return data;
        } else {
            return null;
        }
    }

    /*
        Write to socket
    */
    public static int writeToStream(DeviceInfo d, String json) throws IOException {

        if (d.socket != null) {
            initilizeServer.logger.info("Writing to socket [Mac:" + d.getMacAddress());
            int response = 200;
            d.outStream.writeInt(json.length());
            d.outStream.writeBytes(json);
            d.outStream.flush();
            return response;
        } else {
            initilizeServer.logger.info("Null Socket : Mac = " + d.macAddress);
            return 408;
        }
    }

    /*
        Thread for a client, all meesages are received from client
    */
    static void handleConnection(Socket sock, int tid) {

        try {
            int count = 0;
            boolean newConnection = true;
            String ip_add = sock.getInetAddress().toString();
            String[] _ip_add = ip_add.split("/");

            String macAddress = "";
            DeviceInfo myDevice = null;
            InputStream in = sock.getInputStream();
            OutputStream out = sock.getOutputStream();
            DataInputStream dis = new DataInputStream(in);
            DataOutputStream dos = new DataOutputStream(out);

            while (true) {
                // Read message from socket
                String receivedData = ClientConnection.readFromStream(sock, dis, dos).trim();
                if (receivedData == null || receivedData.equals("")) {
                    initilizeServer.logger.info("[Empty/Null Data][" + tid + "]");
                } else {

                    receivedData = receivedData.replace(":true,", ":\"true\",");
                    receivedData = receivedData.replace(":false,", ":\"false\",");

                    initilizeServer.logger.info("Received :" + receivedData);

                    Map<String, String> jsonMap = null;
                    JSONParser parser = new JSONParser();

                    
                    ContainerFactory containerFactory = new ContainerFactory() {

                        @SuppressWarnings("rawtypes")
                        @Override
                        public List creatArrayContainer() {
                            return new LinkedList();
                        }

                        @SuppressWarnings("rawtypes")
                        @Override
                        public Map createObjectContainer() {
                            return new LinkedHashMap();
                        }
                    };

                    try {
                        // string to JSON parser
                        jsonMap = (Map<String, String>) parser.parse(receivedData, containerFactory);

                        if (jsonMap != null) {

                            String action = jsonMap.get(Constants.action);
                            // heartbeat message
                            if (action.compareTo(Constants.heartBeat) == 0 || action.compareTo(Constants.heartBeat1) == 0 || action.compareTo(Constants.heartBeat2) == 0) {

                                macAddress = jsonMap.get(Constants.macAddress);
                                DeviceInfo device = initilizeServer.allConnectedClients.get(jsonMap.get(Constants.macAddress));

                                if (macAddress != null && !macAddress.equalsIgnoreCase("") ) {
                                    
                                   if(device != null){
                                    
                                    device.setSocket(sock);
                                    device.setInpStream(dis);
                                    device.setOutStream(dos);
//------------------------------------------------------------------------------                                    
// Logic for sending 'wake up' timer to clients
//
                                    try {
                                        long wakeUptime = (initilizeServer.getWakeUpDuration()) - ((System.currentTimeMillis()) - initilizeServer.getStartwakeUpDuration()) / 1000;
                                        // wakeup timer is on, and clients is not in foreground
                                        if (wakeUptime > 0 && !Boolean.parseBoolean(jsonMap.get(Constants.isInForeground))) {
                                            // wakeup timer set on BSSID
                                            if (initilizeServer.getWakeUpFilter().equalsIgnoreCase("bssid")) {

                                                if (initilizeServer.getWakeUpClients().get(jsonMap.get(Constants.bssid)) != null) {
                                                    String jsonString = Utils.getWakeUpClientsJson(Long.toString(wakeUptime));
                                                    Thread sendData = new Thread(new SendData(device, 9, jsonString));
                                                    sendData.start();
                                                    initilizeServer.logger.info("Reply to HearBeat : Sending WakeUp time : " + wakeUptime + "[ " + macAddress + " ]");

                                                }
                                            // wakeup timer set on SSID
                                            } else if (initilizeServer.getWakeUpFilter().equalsIgnoreCase("ssid")) {

                                                if (initilizeServer.getWakeUpClients().get(jsonMap.get(Constants.ssid)) != null) {
                                                    String jsonString = Utils.getWakeUpClientsJson(Long.toString(wakeUptime));
                                                    Thread sendData = new Thread(new SendData(device, 9, jsonString));
                                                    sendData.start();
                                                    initilizeServer.logger.info("Reply to HearBeat : Sending WakeUp time : " + wakeUptime + "[ " + macAddress + " ]");

                                                }
                                            // wakeup timer set for all clients
                                            } else if (initilizeServer.getWakeUpFilter().equalsIgnoreCase("setToAll")) {
                                                String jsonString = Utils.getWakeUpClientsJson(Long.toString(wakeUptime));
                                                Thread sendData = new Thread(new SendData(device, 9, jsonString));
                                                sendData.start();
                                                initilizeServer.logger.info("Reply to HearBeat : Sending WakeUp time : " + wakeUptime + "[ " + macAddress + " ]");
                                            // wakeup timer set for a specific client
                                            } else if (initilizeServer.getWakeUpFilter().equalsIgnoreCase("clientSpecific")) {

                                                if (initilizeServer.getWakeUpClients().get(jsonMap.get(Constants.macAddress)) != null) {
                                                    String jsonString = Utils.getWakeUpClientsJson(Long.toString(wakeUptime));
                                                    Thread sendData = new Thread(new SendData(device, 9, jsonString));
                                                    sendData.start();
                                                    initilizeServer.logger.info("Reply to HearBeat : Sending WakeUp time : " + wakeUptime + "[ " + macAddress + " ]");

                                                }

                                            }

                                        } else {
                                            initilizeServer.logger.info("N0-Reply to HearBeat : WakeUp time : " + wakeUptime + " ForGround : " + jsonMap.get(Constants.isInForeground) + " [ " + macAddress + " ]");
                                        }
                                    } catch (Exception ex) {
                                        initilizeServer.logger.error("Exception",ex);;
                                    }}

                                    String appversion = jsonMap.get(Constants.appversion);
                                    String deviceName = "";
                                    try {
                                        deviceName = jsonMap.get(Constants.devicename);
                                    } catch (Exception ex) {
                                        initilizeServer.logger.error("Exception",ex);;
                                    }

                                    String androidVersion = "";

                                    try {
                                        androidVersion = jsonMap.get(Constants.androidVersion);
                                    } catch (Exception ex) {
                                        initilizeServer.logger.error("Exception",ex);;
                                    }

                                      // userinfo update to database
                                    DBManager.updateAppUserHeartBeatInfo(macAddress, appversion, deviceName, androidVersion);

                                    if (device == null) { // Newconnection, first message from socket

                                        DeviceInfo newDevice = new DeviceInfo();
                                        newDevice.setIp(jsonMap.get(Constants.ip));
                                        newDevice.setAppversion(appversion);
                                        newDevice.setPort(Integer.parseInt(jsonMap.get(Constants.port)));
                                        newDevice.setMacAddress(jsonMap.get(Constants.macAddress));
                                        newDevice.setBssid(jsonMap.get(Constants.bssid));
                                        newDevice.setSsid(jsonMap.get(Constants.ssid));
                                        newDevice.setProcessorSpeed(Integer.parseInt(jsonMap.get(Constants.processorSpeed)));
                                        newDevice.setLinkSpeed(jsonMap.get(Constants.linkSpeed));
                                        newDevice.setRssi(jsonMap.get(Constants.rssi));
                                        newDevice.setNumberOfCores(Integer.parseInt(jsonMap.get(Constants.numberOfCores)));
                                        newDevice.setMemory(Integer.parseInt(jsonMap.get(Constants.memory)));
                                        newDevice.setStorageSpace(Integer.parseInt(jsonMap.get(Constants.storageSpace)));
                                        newDevice.setBssidList(jsonMap.get(Constants.bssidList).split(";"));
                                        try {
                                            newDevice.setInForeground(Boolean.parseBoolean(jsonMap.get(Constants.isInForeground)));
                                        } catch (Exception ex) {
                                            initilizeServer.logger.error("Exception",ex);;
                                        }

                                        try {
                                            newDevice.setDeviceName(jsonMap.get(Constants.devicename));
                                        } catch (Exception ex) {
                                            initilizeServer.logger.error("Exception",ex);;
                                        }

                                        try {
                                            newDevice.setAndroidVersion(jsonMap.get(Constants.androidVersion));
                                        } catch (Exception ex) {
                                            initilizeServer.logger.info("JSON parsing exception3 : " + ex.toString());
                                            initilizeServer.logger.error("Exception",ex);;

                                        }

                                 
                                        Date date = Utils.getCurrentTimeStamp();
                                        newDevice.setLastHeartBeatTime(date);
                                        newDevice.setInpStream(dis);
                                        newDevice.setOutStream(dos);
                                        newDevice.setConnectionStatus(true);
                                        newDevice.setThread(Thread.currentThread());
                                        newDevice.setSocket(sock);
                                        newDevice.setGetlogrequestsend(false);

                                        /*
                                        remaining parameters needs to be added!!!
                                         */
                                        initilizeServer.allConnectedClients.put(jsonMap.get(Constants.macAddress), newDevice);

                                    } else // subsequent heartbeats /  reconnection from same client
                                    {
                                        if (newConnection) { // reconnection from same client

                                            if (device.thread != null) {
                                                device.thread.interrupt();
                                                initilizeServer.logger.info("Interrupting old thread, MAC:"+jsonMap.get(Constants.macAddress));
                                            }

                                            DeviceInfo newDevice = new DeviceInfo();
                                            newDevice.setIp(jsonMap.get(Constants.ip));
                                            newDevice.setAppversion(appversion);
                                            newDevice.setPort(Integer.parseInt(jsonMap.get(Constants.port)));
                                            newDevice.setMacAddress(jsonMap.get(Constants.macAddress));
                                            newDevice.setBssid(jsonMap.get(Constants.bssid));
                                            newDevice.setSsid(jsonMap.get(Constants.ssid));
                                            newDevice.setProcessorSpeed(Integer.parseInt(jsonMap.get(Constants.processorSpeed)));
                                            newDevice.setLinkSpeed(jsonMap.get(Constants.linkSpeed));
                                            newDevice.setRssi(jsonMap.get(Constants.rssi));
                                            newDevice.setNumberOfCores(Integer.parseInt(jsonMap.get(Constants.numberOfCores)));
                                            newDevice.setMemory(Integer.parseInt(jsonMap.get(Constants.memory)));
                                            newDevice.setStorageSpace(Integer.parseInt(jsonMap.get(Constants.storageSpace)));
                                            newDevice.setBssidList(jsonMap.get(Constants.bssidList).split(";"));

                                            try {
                                                newDevice.setInForeground(Boolean.parseBoolean(jsonMap.get(Constants.isInForeground)));
                                            } catch (Exception ex) {
                                                initilizeServer.logger.error("Exception",ex);;
                                            }

                                            try {
                                                newDevice.setDeviceName(jsonMap.get(Constants.devicename));
                                            } catch (Exception ex) {
                                                initilizeServer.logger.error("Exception",ex);;
                                            }

                                            try {
                                                newDevice.setAndroidVersion(jsonMap.get(Constants.androidVersion));
                                            } catch (Exception ex) {
                                                initilizeServer.logger.error("Exception",ex);;

                                            }

                                     
                                            Date date = Utils.getCurrentTimeStamp();
                                            newDevice.setLastHeartBeatTime(date);
                                            newDevice.setInpStream(dis);
                                            newDevice.setOutStream(dos);
                                            newDevice.setSocket(sock);

                                            newDevice.setThread(Thread.currentThread());
                                            newDevice.setConnectionStatus(true);
                                            newDevice.setGetlogrequestsend(false);
                                           
                                            initilizeServer.allConnectedClients.remove(device.macAddress);
                                            initilizeServer.allConnectedClients.put(jsonMap.get(Constants.macAddress), newDevice);


                                        } else { // heartbeat


                                            Date date = Utils.getCurrentTimeStamp();
                                            device.setAppversion(appversion);
                                            device.setIp(jsonMap.get(Constants.ip));
                                            device.setPort(Integer.parseInt(jsonMap.get(Constants.port)));
                                            device.setMacAddress(jsonMap.get(Constants.macAddress));
                                            device.setBssid(jsonMap.get(Constants.bssid));
                                            device.setSsid(jsonMap.get(Constants.ssid));

                                            try {
                                                device.setInForeground(Boolean.parseBoolean(jsonMap.get(Constants.isInForeground)));
                                            } catch (Exception ex) {
                                                initilizeServer.logger.error("Exception",ex);;
                                            }

                                            try {
                                                device.setDeviceName(jsonMap.get(Constants.devicename));
                                            } catch (Exception ex) {
                                                initilizeServer.logger.error("Exception",ex);;
                                            }

                                            try {
                                                device.setAndroidVersion(jsonMap.get(Constants.androidVersion));
                                            } catch (Exception ex) {
                                                initilizeServer.logger.error("Exception",ex);;
                                            }
                                            device.setLastHeartBeatTime(date);
                                            device.setInpStream(dis);
                                            device.setOutStream(dos);
                                            device.setSocket(sock);
                                            device.setConnectionStatus(true);
                                        }
                                    }
//------------------  Getting all BSSID lists : For dashboard settings                        

                                    initilizeServer.allBssidInfo.put(jsonMap.get(Constants.bssid), jsonMap.get(Constants.ssid));

                                    /*
                                    String bssidL = jsonMap.get(Constants.bssidList);
                                    if (bssidL != null) {
                                        bssidL = bssidL.trim();
                                        if (!bssidL.equals("")) {
                                            String[] bss = bssidL.split(";");
                                            String ssid = "";
                                            String bssid = "";
                                            for (int i = 0; i < bss.length; i++) {
                                                String info[] = bss[i].split(",");
                                                try {
                                                    ssid = info[0].trim();
                                                } catch (Exception ex) {
                                                    initilizeServer.logger.info("BssidList Update index:0 " + ex.toString());
                                                }
                                                try {
                                                    bssid = info[1].trim();
                                                } catch (Exception ex) {
                                                    initilizeServer.logger.info("BssidList Update index:1 " + ex.toString());
                                                }
                                                initilizeServer.allBssidInfo.put(bssid, ssid);
                                            }
                                        }
                                    }
                                     */

//------------------          
                                }
                                
                            } 
                            /*
                                Experiment Over messge
                            */
                            else if (action.compareTo(Constants.experimentOver) == 0) {

                                
                                macAddress = jsonMap.get(Constants.macAddress);
                                
                                DeviceInfo device = initilizeServer.allConnectedClients.get(jsonMap.get(Constants.macAddress));

                                if (device == null) { // new connection

                                    DeviceInfo newDevice = new DeviceInfo();
                                    newDevice.setIp(jsonMap.get(Constants.ip));
                                    newDevice.setPort(Integer.parseInt(jsonMap.get(Constants.port)));
                                    newDevice.setMacAddress(jsonMap.get(Constants.macAddress));
                                    newDevice.setInpStream(dis);
                                    newDevice.setOutStream(dos);
                                    newDevice.setSocket(sock);
                                    newDevice.setThread(Thread.currentThread());
                                    newDevice.setGetlogrequestsend(false);
                                    newDevice.setConnectionStatus(true);

                                    newDevice.setExpOver(1); //

                                    String[] info = jsonMap.get(Constants.experimentNumber).split("_");

                                    if (DBManager.updateExperimentOverStatus(Integer.parseInt(info[0]), newDevice.getMacAddress(), Integer.parseInt(info[1]))) {
                                        initilizeServer.logger.info("ExpOver : DB Update Success");
                                    } else {
                                        initilizeServer.logger.info("ExpOver : DB Update Failed");
                                    }

                                    initilizeServer.allConnectedClients.put(jsonMap.get(Constants.macAddress), newDevice);

                                } else if (newConnection) { // reconnction from the same client

                                    if (device.thread != null) {
                                        device.thread.interrupt();
                                        initilizeServer.logger.info("Interrupting old thread, MAC: " +jsonMap.get(Constants.macAddress));
                                    }

                                    DeviceInfo newDevice = new DeviceInfo();
                                    newDevice.setIp(jsonMap.get(Constants.ip));
                                    newDevice.setPort(Integer.parseInt(jsonMap.get(Constants.port)));
                                    newDevice.setMacAddress(jsonMap.get(Constants.macAddress));
                                    newDevice.setInpStream(dis);
                                    newDevice.setOutStream(dos);
                                    newDevice.setSocket(sock);

                                    newDevice.setThread(Thread.currentThread());
                                    newDevice.setGetlogrequestsend(false);
                                    newDevice.setConnectionStatus(true);

                                    newDevice.setExpOver(1); //

                                    String[] info = jsonMap.get(Constants.experimentNumber).split("_");

                                    if (DBManager.updateExperimentOverStatus(Integer.parseInt(info[0]), newDevice.getMacAddress(), Integer.parseInt(info[1]))) {
                                        initilizeServer.logger.info("ExpOver1 : DB Update Success MAC["+device.getMacAddress()+"]");
                                    } else {
                                        initilizeServer.logger.info("ExpOver1 : DB Update Failed MAC["+device.getMacAddress()+"]");
                                    }

                                    initilizeServer.allConnectedClients.remove(device.macAddress);
                                    initilizeServer.allConnectedClients.put(jsonMap.get(Constants.macAddress), newDevice);


                                } else {

                                    // alread connected client (not the first message)
                                    device.setConnectionStatus(true);
                                    device.setSocket(sock);
                                    device.setExpOver(1); //

                                    String[] info = jsonMap.get(Constants.experimentNumber).split("_");

                                    if (DBManager.updateExperimentOverStatus(Integer.parseInt(info[0]), device.getMacAddress(), Integer.parseInt(info[1]))) {
                                        initilizeServer.logger.info("ExpOver2 : DB Update Success MAC["+device.getMacAddress()+"]");
                                    } else {
                                        initilizeServer.logger.info("ExpOver2 : DB Update Failed MAC["+device.getMacAddress()+"]");
                                    }

                                }

                            }
                            /*
                                Experiment ACK messge
                            */
                            else if (action.compareTo(Constants.expacknowledgement) == 0) {

                                String[] info = jsonMap.get(Constants.experimentNumber).split("_");

                                int userid = Integer.parseInt(info[0]);
                                int expNumber = Integer.parseInt(info[1]);
                                
                                if (macAddress != null && !macAddress.equals("")) {
                                    DeviceInfo device = initilizeServer.allConnectedClients.get(macAddress);

                                    if (DBManager.updateExpStartReqSendStatus(expNumber, macAddress, 2, "Received Exp Ack", userid)) {
                                        initilizeServer.logger.info("ExpAck : " + expNumber + " DB update Success MAC["+macAddress+"]");
                                    } else {
                                        initilizeServer.logger.info("ExpAck : " + expNumber + " DB update Failed MAC["+macAddress+"]");
                                    }
                                }
                                //              }
                            } 
                            /*
                                Control file ACK messge
                            */
                            else if (action.compareTo(Constants.controlFileacknowledgement) == 0) {
                                try {

                                    String[] user_fileid = jsonMap.get(Constants.fileId).split("_");
                                    int userid = Integer.parseInt(user_fileid[0]);
                                    int fileid = Integer.parseInt(user_fileid[1]);
                                    if (macAddress != null && !macAddress.equals("")) {
                                        DeviceInfo device = initilizeServer.allConnectedClients.get(macAddress);
                                        if (DBManager.updateControlFileReceivingDetails(userid, fileid, macAddress, 2, "Ctrl File Ack received")) {
                                            initilizeServer.logger.info(" Control File Ack : MAC: " + macAddress + " Fid: " + fileid + " DB updated Successfully");
                                        } else {
                                            initilizeServer.logger.info(" Control File Ack : MAC: " + macAddress + " Fid: " + fileid + " DB updation Failed");
                                        }
                                    }
                                } catch (Exception ex) {
                                    initilizeServer.logger.error("Exception",ex);;
                                }
                            }
                            /*
                                User details (email)
                            */
                            else if (action.compareTo(Constants.userEmail) == 0) {

                                macAddress = jsonMap.get(Constants.macAddress);
                                if (macAddress != null && !macAddress.equalsIgnoreCase("")) {
                                    String email = jsonMap.get(Constants.email);
                                    if(DBManager.updateAppUserInfo(email, macAddress)){
                                        initilizeServer.logger.info("UserInfo MAC: " + macAddress + " DB update Success");
                                    }else{
                                        initilizeServer.logger.info("UserInfo MAC: " + macAddress + " DB update Failed");
                                    }
                                }

                            } else {
                                initilizeServer.logger.info("[" + tid + "] Some Other Operation...");
                            }
                            newConnection = false;
                        }
                    } catch (Exception ex) {
                        initilizeServer.logger.error("Exception",ex);;
                    }
                }

                try {
                    Thread.sleep(5000);  // wait for interrupt
                } catch (InterruptedException ex) {
                    initilizeServer.logger.error("Exception",ex);;
                    try {
                        sock.close();
                    } catch (IOException ex1) {
                        initilizeServer.logger.error("Exception",ex1);;
                    }
                    break; //
                }
            }

        } catch (IOException ex) {
            initilizeServer.logger.error("Exception",ex);;
            try {
                sock.close();
            } catch (IOException ex1) {
                initilizeServer.logger.error("Exception",ex1);;
            }
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception",ex);;
            try {
                sock.close();
            } catch (IOException ex1) {
                initilizeServer.logger.error("Exception",ex1);;
            }
        }

    }
}
