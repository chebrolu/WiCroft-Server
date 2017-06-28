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

            case apsetting:
                System.out.println("\nInside Sending APSettings...mac: " + device.macAddress + " " + device.socket);
                int status;
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        mySession.getChangeApFilteredClients().put(device.getMacAddress(), "Successfully sent");
                        System.out.println("\nAPsettings : Successfully sent AP conf file mac:" + device.getMacAddress());

                    } else {
                        mySession.getChangeApFilteredClients().put(device.getMacAddress(), "Unable to send : Issue with Writing into Socket");
                        System.out.println("\nAPsettings : Unable to send AP Conf file mac:" + device.getMacAddress());
                    }
                } catch (IOException ex) {
                    mySession.getChangeApFilteredClients().put(device.getMacAddress(), "Exception : " + ex.toString());
                    System.out.println("\nSOcket Error : Sending AP conf file failed mac:" + device.getMacAddress());
                }
                break;

            case startExp:

                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        System.out.println("\nStart Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Successfully sent file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.addExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, file_id, userId, 0, "Experiment Request Sent Successfully and Waiting for Ack")) {
                            System.out.println("\nStart Experiment: Insert to DataBase Success");
                        } else {
                            System.out.println("\nStart Experiment: Insert to DataBase Failed");
                        }
                    } else {
                        System.out.println("\nStart Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " : Unable to send file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.addExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, file_id, userId, 1, "Start Experiment Request Failed : Socket Error")) {
                            System.out.println("\nStart Experiment: Insert to DataBase Success");
                        } else {
                            System.out.println("\nStart Experiment: Insert to DataBase Failed");
                        }
                    }
                } catch (IOException ex) {
                    System.out.println("\nSOcket Error Exp:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Sending Control file failed mac: " + device.getMacAddress() + Utils.getCurrentTimeStamp());
                    System.out.println("\nStart Experiment: : Unable to send request");
                    if (DBManager.addExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, file_id, userId, 1, "Start Experiment Request Failed : Exception " + ex.toString())) {
                        System.out.println("\nStart Experiment: Insert to DataBase Success");
                    } else {
                        System.out.println("\nStart Experiment: Insert to DataBase Failed");
                    }
                }

                /*
                synchronized (session.startExpTCounter) {
                    session.startExpTCounter--;
                    System.out.println("run() " + tid + ": value of startExpTCounter = " + session.startExpTCounter);
                
                }*/
                break;

            case expRetry:

                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        System.out.println("\nRetry Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Successfully sent file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.updateExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, userId, 0, "Experiment Retry Request Sent Successfully and Waiting for Ack")) {
                            System.out.println("\nRetry Experiment: Insert to DataBase Success");
                        } else {
                            System.out.println("\nRetry Experiment: Insert to DataBase Failed");
                        }
                    } else {
                        System.out.println("\nRetry Experiment:" + Integer.parseInt(mySession.getLastConductedExpId()) + " : Unable to send file mac:" + device.getMacAddress() + Utils.getCurrentTimeStamp());
                        if (DBManager.updateExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, userId, 1, "Retry Experiment Request Failed : Socket Error")) {
                            System.out.println("\nRetry Experiment: Insert to DataBase Success");
                        } else {
                            System.out.println("\nRetry Experiment: Insert to DataBase Failed");
                        }
                    }
                } catch (IOException ex) {
                    System.out.println("\nSOcket Error Exp:" + Integer.parseInt(mySession.getLastConductedExpId()) + " Sending exp request failed mac: " + device.getMacAddress() + Utils.getCurrentTimeStamp());
                    System.out.println("\nRetry Experiment: : Unable to send request");
                    if (DBManager.updateExperimentDetails(Integer.parseInt(mySession.getLastConductedExpId()), device, userId, 1, "Retry Experiment Request Failed : Exception " + ex.toString())) {
                        System.out.println("\nRetry Experiment: Insert to DataBase Success");
                    } else {
                        System.out.println("\nRetry Experiment: Insert to DataBase Failed");
                    }
                }

                /*
                synchronized (session.startExpTCounter) {
                    session.startExpTCounter--;
                    System.out.println("run() " + tid + ": value of startExpTCounter = " + session.startExpTCounter);
                
                }*/
                break;

            case stopExp:

                System.out.println("\nInside Stop Experiment ...");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        System.out.println("\nStop Experiment:" + expID + " Successfully sent  file mac:" + device.getMacAddress() + " " + Utils.getCurrentTimeStamp());

                    } else {
                        System.out.println("\nStop Experiment :" + expID + " Unable to send file mac:" + device.getMacAddress() + " " + Utils.getCurrentTimeStamp());
                    }
                } catch (IOException ex) {
                    System.out.println("\nSOcket Error :" + expID + " Sending Stop Exp failed mac:" + device.getMacAddress() + " " + Utils.getCurrentTimeStamp());
                }

                /*synchronized (session.stopExpTCounter) {
                    System.out.println("run() " + tid + ": value of stopExpTCounter = " + session.stopExpTCounter);
                    session.stopExpTCounter--;
                }*/
                break;

            case refresh:

                System.out.println("\nInside Refresh Registration ...");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);

                    if (status == Constants.responseOK) {
                        System.out.println("\nRefresh Registration: Successfully sent file " + " " + Utils.getCurrentTimeStamp());
                    } else {
                        System.out.println("\nRefresh Registration : Unable to send file " + " " + Utils.getCurrentTimeStamp());
                    }
                } catch (IOException ex) {
                    System.out.println("\nSOcket Error : Sending Refresh Exp failed " + " " + Utils.getCurrentTimeStamp());
                }

                /*synchronized (session.refreshTCounter) {
                    session.DecrementRefreshTCounter();
                    System.out.println("value of refreshTCounter=" + session.refreshTCounter);
                }*/
                break;

            case getLogFile:
                System.out.println("\nInside Get Log File Request..");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        mySession.getRequestLogFileFilteredClients().put(device.getMacAddress(), "Sent Successfully");
                        System.out.println("\nGet Log File request Successfully sent " + device.macAddress + " " + Utils.getCurrentTimeStamp());
                    } else {
                        mySession.getRequestLogFileFilteredClients().put(device.getMacAddress(), "Sending failed : write to socket failed");
                        System.out.println("\nGet Log File request Sending Failed" + device.macAddress + " " + Utils.getCurrentTimeStamp());
                    }
                } catch (IOException ex) {
                    mySession.getRequestLogFileFilteredClients().put(device.getMacAddress(), "Exception : " + ex.toString());
                    System.out.println("\nSOcket Error : Sending GetLog Request Exp failed " + " " + Utils.getCurrentTimeStamp());
                }
                break;

            case heartBeat:
                System.out.println("\nInside Sending HEARTBEAT duration..");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        device.setGetlogrequestsend(true);
                        device.setDetails("\nNew HeartBeat duration sent");
                        System.out.println("\nNew HeartBeat duration Successfully sent ");
//                        DBManager.updateGetLogFileRequestStatus(expID, device.macAddress, 1);
                    } else {
                        device.setGetlogrequestsend(false);
                        device.setDetails("\nNew HeartBeat duration Sending Failed");
                        System.out.println("\nNew HeartBeat duration Sending Failed");
//                        DBManager.updateGetLogFileRequestStatus(expID, device.macAddress, 2);
                    }
                } catch (IOException ex) {
                    device.setGetlogrequestsend(false);
                    device.setDetails("\nSOcket Error : New HeartBeat duration Sending Exp failed " + ex.toString());
                    System.out.println("\nSOcket Error : New HeartBeat duration Sending Exp failed ");
                }
                break;
            case serverConf:
                System.out.println("\nInside Sending ServerConfiguration ..");
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        device.setGetlogrequestsend(true);
                        device.setDetails("\nServerConfiguration request sent");
                        System.out.println("\nServerConfiguration request Successfully sent ");
//                        DBManager.updateGetLogFileRequestStatus(expID, device.macAddress, 1);
                    } else {
                        device.setGetlogrequestsend(false);
                        device.setDetails("\nServerConfiguration request Sending Failed");
                        System.out.println("\nServerConfiguration request Sending Failed");
//                        DBManager.updateGetLogFileRequestStatus(expID, device.macAddress, 2);
                    }
                } catch (IOException ex) {
                    device.setGetlogrequestsend(false);
                    device.setDetails("\nSOcket Error : Sending ServerConfiguration Request Exp failed " + ex.toString());
                    System.out.println("\nSOcket Error : Sending ServerConfiguration Request Exp failed ");
                }

                /* System.out.println("\nInside GetLogFile Request ...");
                status = ClientConnection.writeToStream(device, jsonString, message);
                if (status == Constants.responseOK) {

                    System.out.println("\nGetLogFile : Successfully sent Json file ");
                    Utils.addSendLogRequestDetails(session.getCurrentExperiment(), device.getMacAddress(), "SUCCESS");
                    Experiment e = Main.getRunningExperimentMap().get(session.getCurrentExperiment());
                    e.SFIncrement();//
                    device.setGetlogrequestsend("SUCCESS");
                } else {

                    System.out.println("\nGetLogFile : Unable to send Json file ");
                    Utils.addSendLogRequestDetails(session.getCurrentExperiment(), device.getMacAddress(), "ERROR Code : " + status + "");
                    device.setGetlogrequestsend("ERROR Code : " + status);
                }
                 */
                break;

            case sendControlFile:

                try {
//                  controlFileReceviedClients

                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {

                        mySession.getControlFileSendingSuccessClients().put(device.getMacAddress(), "");

                        String stat = "Successfully Sent";

                        System.out.println("\nControl File :" + expID + " File Successfully sent [mac:" + device.getMacAddress() + "]" + " " + Utils.getCurrentTimeStamp());
                        if (DBManager.addControlFileSendingDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 0, "File Sent Successfully")) {
                            System.out.println("\nCOntrol file DB update success");
                            stat += "<br> DB Updated";
                        } else {
                            System.out.println("\nCOntrol file DB update failed");
                            stat += "<br> DB Update failed";
                        }

                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);

                    } else {

                        mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");

                        String stat = "Sending failed, Write to Socket failed";
                        System.out.println("\nControl File :" + expID + " Unable to send file [mac:" + device.getMacAddress() + "]");

                        if (DBManager.addControlFileSendingDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending(write to socket) Failed")) {
                            System.out.println("\nCOntrol file DB update success");
                            stat += "<br> DB Updated";
                        } else {
                            System.out.println("\nCOntrol file DB update failed");
                            stat += "<br> DB Update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                    }
                } catch (IOException ex) {
                    mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                    String stat = "Exception : " + ex.toString();

                    System.out.println("\nSOcket Error : Sending Control file:" + expID + " failed MAC:  " + device.macAddress);
                    if (DBManager.addControlFileSendingDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending Failed: Sock Exception")) {
                        System.out.println("\nCOntrol file DB update success");
                        stat += "<br> DB Updated";
                    } else {
                        System.out.println("\nCOntrol file DB update failed");
                        stat += "<br> DB Update failed";
                    }
                    mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                }

                break;

            case retryControlFile:
                try {
//                  controlFileReceviedClients

                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        String stat = "Successfully Sent";
                        mySession.getControlFileSendingSuccessClients().put(device.getMacAddress(), "");
                        System.out.println("\nControl File :" + expID + " File Successfully sent [mac:" + device.getMacAddress() + "]" + " " + Utils.getCurrentTimeStamp());
                        if (DBManager.addControlFileRetryDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 0, "File Send successfully")) {
                            System.out.println("\nCOntrol file DB update success");
                            stat += "<br> DB updated";
                        } else {
                            System.out.println("\nCOntrol file DB update failed");
                            stat += "<br> DB update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                    } else {
                        String stat = "Sending failed : Write to socket";

                        mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                        System.out.println("\nControl File :" + expID + " Unable to send file [mac:" + device.getMacAddress() + "]");

                        if (DBManager.addControlFileRetryDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending(write to socket) Failed")) {
                            System.out.println("\nCOntrol file DB update success");
                            stat += "<br> DB updated";
                        } else {
                            System.out.println("\nCOntrol file DB update failed");
                            stat += "<br> DB update failed";
                        }
                        mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                    }
                } catch (IOException ex) {
                    String stat = "Exception : " + ex.toString();

                    mySession.getControlFileSendingFailedClients().put(device.getMacAddress(), "");
                    System.out.println("\nSOcket Error : Sending Control file:" + expID + " failed MAC:  " + device.macAddress);
                    if (DBManager.addControlFileRetryDetails(userId, Integer.parseInt(file_id), device.getMacAddress(), 1, "File Sending Failed: Sock Exception")) {
                        System.out.println("\nCOntrol file DB update success");
                        stat += "<br> DB updated";
                    } else {
                        System.out.println("\nCOntrol file DB update failed");
                        stat += "<br> DB update failed";
                    }
                    mySession.getSendCtrlFileFilteredClients().put(device.getMacAddress(), stat);
                }

                break;

            case sendUpdateReq:

                try {
                    String macAddr = device.getMacAddress();
                    try {

                        status = ClientConnection.writeToStream(device, jsonString);

                        if (status == Constants.responseOK) {
                            System.out.println("\nSend Update : SUCCESS [mac:" + macAddr + "]");
//                            mySession.getUpdateAppClients().put(macAddr, "Success");

                            mySession.getAppUpdateFilteredClients().put(macAddr, "Sent Successfully");

                        } else {
                            System.out.println("\nSend Update : FAILED [mac:" + macAddr + "]");
//                            mySession.getUpdateAppClients().put(macAddr, "Failed");
                            mySession.getAppUpdateFilteredClients().put(macAddr, "Sending Failed : Write to socket failed...");

                        }
                    } catch (IOException ex) {
                        System.out.println("\nSend Update : FAILED [mac:" + macAddr + "]");
                        mySession.getAppUpdateFilteredClients().put(macAddr, "Exception: " + ex.toString());
//                        mySession.getUpdateAppClients().put(macAddr, "Failed Exception: " + ex.toString());

                    }
                } catch (Exception ex) {
                    System.out.println("\nSend Update : FAILED [mac:" + device.getMacAddress() + "]");
                }

                break;

            case wakeUpClient:
                try {
                    status = ClientConnection.writeToStream(device, jsonString);
                    if (status == Constants.responseOK) {
                        System.out.println("\nWakeUp Request : Sent Successfully [mac:" + device.getMacAddress() + "]");
                        initilizeServer.getWakeUpTimerFilteredClients().put(device.getMacAddress(), "Sent Successfully");
                    } else {
                        System.out.println("\nWakeUp Request : Unable to send [mac:" + device.getMacAddress() + "]");
                        initilizeServer.getWakeUpTimerFilteredClients().put(device.getMacAddress(), "Sock Err: Sending failed");
                    }
                } catch (IOException ex) {
                    System.out.println("\nSOcket Error : Sending WakeUp request failed mac:" + device.macAddress);
                    initilizeServer.getWakeUpTimerFilteredClients().put(device.getMacAddress(), ex.toString());
                }

                break;

        }
    }
}
