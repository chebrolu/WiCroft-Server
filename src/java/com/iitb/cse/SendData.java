/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iitb.cse;

import lombok.Getter;
import lombok.Setter;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ratheeshkv
 */
public class SendData extends Thread {

    final int startExp = 0;
    final int stopExp = 1;
    final int refresh = 2;
    final int apsetting = 3;
    final int getLogFile = 4;
    final int heartBeat = 5;
    final int serverConf = 6;
    final int sendControlFile = 7;
    final int sendUpdateReq = 8;
    final int wakeUpClient = 9;
    final int retryControlFile = 10;
    final int expRetry = 11;
    final int wakeUpTimer = 12;

    int expID;
    DeviceInfo device;
    int whatToDo;
    String jsonString;
//    String message;
    String file_id;
    Session mySession;
    int userId;
//    String file_name;

    public SendData(Session mySession, DeviceInfo device, int whatToDo, String jsonString, String file_id, int userId) {

        this.mySession = mySession;
        this.device = device;
        this.whatToDo = whatToDo;
        this.jsonString = jsonString;
        this.file_id = file_id;
        this.userId = userId;
    }

    public SendData(Session mySession, DeviceInfo device, int whatToDo, String jsonString, String file_id) {

        this.mySession = mySession;
        this.device = device;
        this.whatToDo = whatToDo;
        this.jsonString = jsonString;
        this.file_id = file_id;
    }

    public SendData(Session mySession, DeviceInfo device, int whatToDo, String jsonString) {
        this.mySession = mySession;
        this.device = device;
        this.whatToDo = whatToDo;
        this.jsonString = jsonString;
    }

    public SendData(DeviceInfo device, int whatToDo, String jsonString) {
        this.device = device;
        this.whatToDo = whatToDo;
        this.jsonString = jsonString;
    }

    @Override
    public void run() {

        switch (whatToDo) {

            /*
                Sending change AP request
            */
            case apsetting:
                initilizeServer.logger.info("Inside Sending APSettings...mac: " + device.macAddress + " " + device.socket);
                int status;
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        mySession.getChangeApFilteredClients().put(device.getMacAddress(), "Successfully sent");
                        initilizeServer.logger.info("APsettings : Successfully sent AP conf file mac:" + device.getMacAddress());

                    } else {
                        mySession.getChangeApFilteredClients().put(device.getMacAddress(), "Unable to send : Issue with Writing into Socket");
                        initilizeServer.logger.info("APsettings : Unable to send AP Conf file mac:" + device.getMacAddress());
                    }
                } catch (IOException ex) {
                    mySession.getChangeApFilteredClients().put(device.getMacAddress(), "Exception : " + ex.toString());
                    initilizeServer.logger.info("SOcket Error : Sending AP conf file failed mac:" + device.getMacAddress());
                }
                break;

            /*
                Sending start experiment request
            */
            case startExp:

                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        initilizeServer.logger.info("Start Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Successfully sent file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.addExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, file_id, userId, 0, "Experiment Request Sent Successfully and Waiting for Ack")) {
                            initilizeServer.logger.info("Start Experiment: Insert to DataBase Success");
                        } else {
                            initilizeServer.logger.info("Start Experiment: Insert to DataBase Failed");
                        }
                    } else {
                        initilizeServer.logger.info("Start Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " : Unable to send file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.addExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, file_id, userId, 1, "Start Experiment Request Failed : Socket Error")) {
                            initilizeServer.logger.info("Start Experiment: Insert to DataBase Success");
                        } else {
                            initilizeServer.logger.info("Start Experiment: Insert to DataBase Failed");
                        }
                    }
                } catch (IOException ex) {
                    initilizeServer.logger.info("SOcket Error Exp:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Sending Control file failed mac: " + device.getMacAddress() + Utils.getCurrentTimeStamp());
                    initilizeServer.logger.info("Start Experiment: : Unable to send request");
                    if (DBManager.addExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, file_id, userId, 1, "Start Experiment Request Failed : Exception " + ex.toString())) {
                        initilizeServer.logger.info("Start Experiment: Insert to DataBase Success");
                    } else {
                        initilizeServer.logger.info("Start Experiment: Insert to DataBase Failed");
                    }
                }

                break;
                
            /*
                Sending start experiment retry request
            */

            case expRetry:

                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        initilizeServer.logger.info("Retry Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Successfully sent file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.updateExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, userId, 0, "Experiment Retry Request Sent Successfully and Waiting for Ack")) {
                            initilizeServer.logger.info("Retry Experiment: Insert to DataBase Success");
                        } else {
                            initilizeServer.logger.info("Retry Experiment: Insert to DataBase Failed");
                        }
                    } else {
                        initilizeServer.logger.info("Retry Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " : Unable to send file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.updateExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, userId, 1, "Retry Experiment Request Failed : Socket Error")) {
                            initilizeServer.logger.info("Retry Experiment: Insert to DataBase Success");
                        } else {
                            initilizeServer.logger.info("Retry Experiment: Insert to DataBase Failed");
                        }
                    }
                } catch (IOException ex) {
                    initilizeServer.logger.info("SOcket Error Exp:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Sending exp request failed mac: " + device.getMacAddress() + Utils.getCurrentTimeStamp());
                    initilizeServer.logger.info("Retry Experiment: : Unable to send request");
                    if (DBManager.updateExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, userId, 1, "Retry Experiment Request Failed : Exception " + ex.toString())) {
                        initilizeServer.logger.info("Retry Experiment: Insert to DataBase Success");
                    } else {
                        initilizeServer.logger.info("Retry Experiment: Insert to DataBase Failed");
                    }
                }
                break;

                /*
                    Sending stop experiment request
                */
            case stopExp:

                initilizeServer.logger.info("Inside Stop Experiment ...");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        initilizeServer.logger.info("Stop Experiment:" + expID + " Successfully sent  file mac:" + device.getMacAddress() + " " + Utils.getCurrentTimeStamp());

                    } else {
                        initilizeServer.logger.info("Stop Experiment :" + expID + " Unable to send file mac:" + device.getMacAddress() + " " + Utils.getCurrentTimeStamp());
                    }
                } catch (IOException ex) {
                    initilizeServer.logger.info("SOcket Error :" + expID + " Sending Stop Exp failed mac:" + device.getMacAddress() + " " + Utils.getCurrentTimeStamp());
                }
                break;

                /*
                    sending log files request
                */
            case getLogFile:
                initilizeServer.logger.info("Inside Get Log File Request..");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        mySession.getRequestLogFileFilteredClients().put(device.getMacAddress(), "Request Sent Successfully");
                        initilizeServer.logger.info("Get Log File request Successfully sent " + device.macAddress + " " + Utils.getCurrentTimeStamp());
                    } else {
                        mySession.getRequestLogFileFilteredClients().put(device.getMacAddress(), "Request Sending failed : write to socket failed");
                        initilizeServer.logger.info("Get Log File request Sending Failed" + device.macAddress + " " + Utils.getCurrentTimeStamp());
                    }
                } catch (IOException ex) {
                    mySession.getRequestLogFileFilteredClients().put(device.getMacAddress(), "Exception : " + ex.toString());
                    initilizeServer.logger.info("SOcket Error : Sending GetLog Request Exp failed " + " " + Utils.getCurrentTimeStamp());
                }
                break;

                /*
                    For setting heartbeat duration 
                */
            case heartBeat:
                initilizeServer.logger.info("Inside Sending HEARTBEAT duration..");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        device.setGetlogrequestsend(true);
                        device.setDetails("\nNew HeartBeat duration sent");
                        initilizeServer.logger.info("New HeartBeat duration Successfully sent ");
                    } else {
                        device.setGetlogrequestsend(false);
                        device.setDetails("\nNew HeartBeat duration Sending Failed");
                        initilizeServer.logger.info("New HeartBeat duration Sending Failed");
                    }
                } catch (IOException ex) {
                    device.setGetlogrequestsend(false);
                    device.setDetails("\nSOcket Error : New HeartBeat duration Sending Exp failed " + ex.toString());
                    initilizeServer.logger.info("SOcket Error : New HeartBeat duration Sending Exp failed ");
                }
                break;
                
                /*
                    Senidng requests to change server configuration
                */
            case serverConf:
                initilizeServer.logger.info("Inside Sending ServerConfiguration ..");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        device.setGetlogrequestsend(true);
                        device.setDetails("\nServerConfiguration request sent");
                        initilizeServer.logger.info("ServerConfiguration request Successfully sent ");
                    } else {
                        device.setGetlogrequestsend(false);
                        device.setDetails("\nServerConfiguration request Sending Failed");
                        initilizeServer.logger.info("ServerConfiguration request Sending Failed");
                    }
                } catch (IOException ex) {
                    device.setGetlogrequestsend(false);
                    device.setDetails("\nSOcket Error : Sending ServerConfiguration Request Exp failed " + ex.toString());
                    initilizeServer.logger.info("SOcket Error : Sending ServerConfiguration Request Exp failed ");
                }
                break;
                /*
                    Sending control file 
                */
            case sendControlFile:

                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        mySession.getControlFileSendingSuccessClients().put(device.getMacAddress(), "");
                        String stat = "Successfully Sent";
                        initilizeServer.logger.info("Control File :" + expID + " File Successfully sent [mac:" + device.getMacAddress() + "]" + " " + Utils.getCurrentTimeStamp());
                        if (DBManager.addControlFileSendingDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 0, "File Sent Successfully")) {
                            initilizeServer.logger.info("COntrol file DB update success");
                            stat += "<br> DB Updated";
                        } else {
                            initilizeServer.logger.info("COntrol file DB update failed");
                            stat += "<br> DB Update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);

                    } else {

                        mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                        String stat = "Sending failed, Write to Socket failed";
                        initilizeServer.logger.info("Control File :" + expID + " Unable to send file [mac:" + device.getMacAddress() + "]");
                        if (DBManager.addControlFileSendingDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending(write to socket) Failed")) {
                            initilizeServer.logger.info("COntrol file DB update success");
                            stat += "<br> DB Updated";
                        } else {
                            initilizeServer.logger.info("COntrol file DB update failed");
                            stat += "<br> DB Update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                    }
                } catch (IOException ex) {
                    mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                    String stat = "Exception : " + ex.toString();

                    initilizeServer.logger.info("SOcket Error : Sending Control file:" + expID + " failed MAC:  " + device.macAddress);
                    if (DBManager.addControlFileSendingDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending Failed: Sock Exception")) {
                        initilizeServer.logger.info("COntrol file DB update success");
                        stat += "<br> DB Updated";
                    } else {
                        initilizeServer.logger.info("COntrol file DB update failed");
                        stat += "<br> DB Update failed";
                    }
                    mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                }

                break;

                /*
                    Retry sending control file
                */
            case retryControlFile:
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        String stat = "Successfully Sent";
                        mySession.getControlFileSendingSuccessClients().put(device.getMacAddress(), "");
                        initilizeServer.logger.info("Control File :" + expID + " File Successfully sent [mac:" + device.getMacAddress() + "]" + " " + Utils.getCurrentTimeStamp());
                        if (DBManager.addControlFileRetryDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 0, "File Send successfully")) {
                            initilizeServer.logger.info("COntrol file DB update success");
                            stat += "<br> DB updated";
                        } else {
                            initilizeServer.logger.info("COntrol file DB update failed");
                            stat += "<br> DB update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                    } else {
                        String stat = "Sending failed : Write to socket";

                        mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                        initilizeServer.logger.info("Control File :" + expID + " Unable to send file [mac:" + device.getMacAddress() + "]");

                        if (DBManager.addControlFileRetryDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending(write to socket) Failed")) {
                            initilizeServer.logger.info("COntrol file DB update success");
                            stat += "<br> DB updated";
                        } else {
                            initilizeServer.logger.info("COntrol file DB update failed");
                            stat += "<br> DB update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                    }
                } catch (IOException ex) {
                    String stat = "Exception : " + ex.toString();

                    mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                    initilizeServer.logger.info("SOcket Error : Sending Control file:" + expID + " failed MAC:  " + device.macAddress);
                    if (DBManager.addControlFileRetryDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending Failed: Sock Exception")) {
                        initilizeServer.logger.info("COntrol file DB update success");
                        stat += "<br> DB updated";
                    } else {
                        initilizeServer.logger.info("COntrol file DB update failed");
                        stat += "<br> DB update failed";
                    }
                    mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                }

                break;

                /*
                    Send app update request
                */
            case sendUpdateReq:

                try {
                    String macAddr = device.getMacAddress();
                    try {

                        status = ClientConnection.writeToStream(device, jsonString);

                        if (status == Constants.responseOK) {
                            initilizeServer.logger.info("Send Update : SUCCESS [mac:" + macAddr + "]");

                            mySession.getAppUpdateFilteredClients().put(macAddr, "Sent Successfully");

                        } else {
                            initilizeServer.logger.info("Send Update : FAILED [mac:" + macAddr + "]");
                            mySession.getAppUpdateFilteredClients().put(macAddr, "Sending Failed : Write to socket failed...");

                        }
                    } catch (IOException ex) {
                        initilizeServer.logger.info("Send Update : FAILED [mac:" + macAddr + "]");
                        mySession.getAppUpdateFilteredClients().put(macAddr, "Exception: " + ex.toString());
                    }
                } catch (Exception ex) {
                    initilizeServer.logger.info("Send Update : FAILED [mac:" + device.getMacAddress() + "]");
                }

                break;

                /*  
                    Sending Wakeup timer 
                */
            case wakeUpClient:
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        initilizeServer.logger.info("WakeUp Request : Sent Successfully [mac:" + device.getMacAddress() + "]");
                        initilizeServer.getWakeUpTimerFilteredClients().put(device.getMacAddress(), "Sent Successfully");
                    } else {
                        initilizeServer.logger.info("WakeUp Request : Unable to send [mac:" + device.getMacAddress() + "]");
                        initilizeServer.getWakeUpTimerFilteredClients().put(device.getMacAddress(), "Sock Err: Sending failed");
                    }
                } catch (IOException ex) {
                    initilizeServer.logger.info("SOcket Error : Sending WakeUp request failed mac:" + device.macAddress);
                    initilizeServer.getWakeUpTimerFilteredClients().put(device.getMacAddress(), ex.toString());
                }

                break;

        }
    }
}
