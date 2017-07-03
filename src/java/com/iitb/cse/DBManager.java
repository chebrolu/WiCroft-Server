/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.iitb.cse;

import static com.iitb.cse.initilizeServer.dbManager;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import lombok.Getter;
import lombok.Setter;

/**
 *
 * @author ratheeshkv
 */
public class DBManager {

    /*
        Database connection object used
     */
    static Connection conn = null;

    /*
        Database connection creation
     */
    public static boolean createConnection() {

        try {
            Class.forName(Constants.JDBC_DRIVER);
        } catch (ClassNotFoundException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }

        try {
            conn = DriverManager.getConnection(Constants.DB_URL, Constants.DB_USER_NAME, Constants.DB_PASSWORD);
            return true;
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
    }

    /*
        Closing database connection
     */
    public void closeConnection() {

        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException ex) {
                initilizeServer.logger.error("Exception", ex);
            }
        }
    }

    /**
     * Authenticate user login
     *
     * @param username
     * @param pwd
     * @return -1 for no user exist (authentication failure) -2 for database
     * issues non zero (>0) userId
     */
    public static int authenticate(String username, String pwd) {

        int status = -1;
        if (initilizeServer.dbManager == null) {
            initilizeServer.dbManager = new DBManager();
            if (!initilizeServer.dbManager.createConnection()) {
                return -2;
            }
        }
        ResultSet rs = null;
        try {

            try {

                PreparedStatement p1 = conn.prepareStatement("select password, userid, instances from users where username=?;");
                p1.setString(1, username);
                initilizeServer.logger.info("Query : " + p1);

                rs = p1.executeQuery();
            } catch (Exception ex) {
                initilizeServer.logger.error("Exception", ex);
                dbManager = new DBManager();
                boolean stat = dbManager.createConnection();
                if (stat) {
                    initilizeServer.logger.info("[Auth] DB connection successful");
                    PreparedStatement p1 = conn.prepareStatement("select password, userid, instances from users where username=?;");
                    p1.setString(1, username);
                    initilizeServer.logger.info("Query : " + p1);
                    rs = p1.executeQuery();
                } else {
                    status = -2;

                }

            }

            if (rs == null || !rs.next()) {
                status = -1;
            } else if (rs != null && pwd.compareTo((String) rs.getString(1)) == 0) {
                /* User exists*/
                int userId = Integer.parseInt(rs.getString(2));
                int instances = Integer.parseInt(rs.getString(3));
                status = userId;

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
        } catch (SQLException ex) {
            status = -2;
            initilizeServer.logger.error("Exception", ex);
        } catch (Exception ex) {
            status = -1;
            initilizeServer.logger.error("Exception", ex);
        }
        return status;
    }

    /*
        Get all distict bssid from client's heartbeat info
     */
    public static ResultSet getAllBssids() {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select distinct  bssid from experimentdetails  where bssid !=\"\" ;");
            rs = p1.executeQuery();

        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
        Get all distict ssid from client's heartbeat info
     */
    public static ResultSet getAllSsids() {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select distinct  ssid from experimentdetails  where bssid !=\"\" ;");
            rs = p1.executeQuery();

        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
        Get all client info
     */
    public static ResultSet getClientList() {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddress,ssid,bssid from experimentdetails order by bssid");
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
        Get all experiment details created by particular user
     */
    public static ResultSet getAllExperimentDetails(String username) {

        ResultSet rs = null;
        try {

            PreparedStatement p1 = conn.prepareStatement("select expid,name,date_format(starttime,'%d:%m:%Y %H:%i:%s'),date_format(endtime,'%d:%m:%Y %H:%i:%s'),location,description,fileid,filename,status,date_format(creationtime,'%d:%m:%Y %H:%i:%s') from experiments where userid=? order by expid desc;");
            p1.setInt(1, DBManager.getUserId(username));
            initilizeServer.logger.info("\nQuery : " + p1.toString());
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }

        return rs;
    }

    /*
        Get details about an experiment created by particular user
     */
    public static ResultSet getExperimentDetails(String expid, String username) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddress,fileid,rssi,ssid,bssid,expreqsenddate,retry,expackreceiveddate,expoverDate,logfilereceived,statusmessage from experimentdetails where userid=? and expid=? order by ssid;");
            p1.setInt(1, DBManager.getUserId(username));
            p1.setInt(2, Integer.parseInt(expid));
            initilizeServer.logger.info("\nQuery : " + p1.toString());
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
          Get client's details about an experiment created by particular user
     */
    public static ResultSet getExperimentDetails(String expid, String username, String macAddress) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select  ipaddress,port,bssid,ssid,rssi,linkspeed,storagespace,memory,numberofcores,processorspeed from experimentdetails where userid=? and expid=? and macaddress=? order by bssid;");
            p1.setInt(1, DBManager.getUserId(username));
            p1.setInt(2, Integer.parseInt(expid));
            p1.setString(3, macAddress);
            initilizeServer.logger.info("\nQuery : " + p1.toString());
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
          start a saved experiment
     */
    public static int startSavedExperiment(Experiment exp) {

        int expId = -1;
        try {

            PreparedStatement p1 = conn.prepareStatement("update experiments set name=?, location=?, description=?, starttime=sysdate(), fileid=?, filename=?, status=?, statusmessage=? where userid=? and expid=?;");
            p1.setString(1, exp.getName());
            p1.setString(2, exp.getLocation());
            p1.setString(3, exp.getDescription());
            p1.setInt(4, exp.getFileid());
            p1.setString(5, exp.getFileName());
            p1.setInt(6, 1);
            p1.setString(7, "Experiment started...");
            p1.setInt(8, exp.getUserid());
            p1.setInt(9, exp.getExpid());
            initilizeServer.logger.info("Query : " + p1.toString());
            expId = exp.getExpid();
            p1.executeUpdate();//executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return expId;
        }

        return expId;
    }

    /*
       Start a new experiment
     */
    public static int startExperiment(Experiment exp) {//, String fileId, String fileName) {

        int expId = -1;
        try {

            PreparedStatement p1 = conn.prepareStatement("insert into experiments(userid,name,location,description,starttime,fileid,filename,status,expid,creationtime,statusmessage) values(?,?,?,?,sysdate(),?,?,?,?,sysdate(),?);");
            p1.setInt(1, exp.getUserid());
            p1.setString(2, exp.getName());
            p1.setString(3, exp.getLocation());
            p1.setString(4, exp.getDescription());
            p1.setInt(5, exp.getFileid());
            p1.setString(6, exp.getFileName());
            p1.setInt(7, 1);
            p1.setInt(8, exp.getExpid());
            p1.setString(9, "Experiment started...");
            initilizeServer.logger.info("Query : " + p1.toString());
            expId = exp.getExpid();
            p1.execute();//executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return expId;
        }

        return expId;
    }

    /*
      Stop a running experiment
     */
    public static int stopExperiment(String username, int expid) {//, String fileId, String fileName) {

        try {

            PreparedStatement p1 = conn.prepareStatement("update experiments set endtime=sysdate(),status=2,statusmessage='exp stopped' where userid=? and expid=?;");
            p1.setInt(1, DBManager.getUserId(username));
            p1.setInt(2, expid);
            initilizeServer.logger.info("Query : " + p1.toString());
            p1.executeUpdate();//executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return expid;
        }

        return expid;
    }

    /*
      Get client's mac address, having pending 'start experiment request'
     */
    public static ResultSet getAllPendingExpReqMacAddress(int expId, String username) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddress from experimentdetails where expid=? and userid=? and status in (0,1);");
            p1.setInt(1, expId);
            p1.setInt(2, DBManager.getUserId(username));
            initilizeServer.logger.info("Query : " + p1.toString());
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
      Save an experiment
     */
    public static int saveExperiment(Experiment exp) {//, String fileId, String fileName) {

        int expId = -1;
        try {

            PreparedStatement p1 = conn.prepareStatement("insert into experiments(userid,name,location,description,fileid,filename,status,creationtime,expid) values(?,?,?,?,?,?,0,sysdate(),?);");
            p1.setInt(1, exp.getUserid());
            p1.setString(2, exp.getName());
            p1.setString(3, exp.getLocation());
            p1.setString(4, exp.getDescription());
            p1.setInt(5, exp.getFileid());
            p1.setString(6, exp.getFileName());
            p1.setInt(7, exp.getExpid());
            initilizeServer.logger.info("Query : " + p1.toString());
            expId = exp.getExpid();
            p1.execute();//executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return expId;
        }
        return expId;
    }

    /*
        Get details about a saved experiment
     */
    public static ResultSet getSavedExperimentsDetails(int userId, int expId) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select name,location,description from experiments where userid=? and expid = ?");
            p1.setInt(1, userId);
            p1.setInt(2, expId);
            initilizeServer.logger.info("\nQuery : " + p1);
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
        Get details about all saved experiments
     */
    public static ResultSet getAllSavedExperimentsDetails(int userId) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select expid,name,location,description,fileid,filename,creationtime from experiments where userid=? and status=0 order by expid desc;");
            p1.setInt(1, userId);
            initilizeServer.logger.info("\nQuery : " + p1);
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    /*
    Update experiment details
     */
    public static boolean updateExperimentDetails(int expNumber, DeviceInfo device, int userid, int status, String statusmsg) {

        try {
            PreparedStatement p1 = conn.prepareStatement("update experimentdetails set retry=1, rssi=?,bssid=?, ssid=?, linkspeed=?, wifisignalstrength=?, ipaddress=?, port=?, status=?, statusmessage=?, expreqsenddate=sysdate()  where expid=? and userid=? and macaddress=?;");
            p1.setString(1, device.getRssi());
            p1.setString(2, device.getBssid());
            p1.setString(3, device.getSsid());
            p1.setString(4, device.getLinkSpeed());
            p1.setInt(5, device.getWifiSignalStrength());
            p1.setString(6, device.getIp());
            p1.setString(7, Integer.toString(device.getPort()));
            p1.setInt(8, status);
            p1.setString(9, statusmsg);
            p1.setInt(10, expNumber);
            p1.setInt(11, userid);
            p1.setString(12, device.getMacAddress());
            initilizeServer.logger.info("\nQuery : " + p1.toString());
            p1.execute();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
        return true;
    }

    public static boolean addExperimentDetails(int expNumber, DeviceInfo device, String file_id, int userid, int status, String statusmsg) {

        try {
            PreparedStatement p1 = conn.prepareStatement("insert into experimentdetails(expid, userid, macaddress, osversion, wifiversion, rssi,bssid, ssid, linkspeed, numberofcores, storagespace, memory,processorspeed , wifisignalstrength, ipaddress, port, fileid , status, statusmessage, expreqsenddate ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate());");
            p1.setInt(1, expNumber);
            p1.setInt(2, userid);
            p1.setString(3, device.getMacAddress());
            p1.setInt(4, Integer.parseInt(device.getOsVersion()));
            p1.setString(5, device.getWifiVersion());
            p1.setString(6, device.getRssi());
            p1.setString(7, device.getBssid());
            p1.setString(8, device.getSsid());
            p1.setString(9, device.getLinkSpeed());
            p1.setInt(10, device.getNumberOfCores());
            p1.setInt(11, device.getStorageSpace());
            p1.setInt(12, device.getMemory());
            p1.setInt(13, device.getProcessorSpeed());
            p1.setInt(14, device.getWifiSignalStrength());
            p1.setString(15, device.getIp());
            p1.setString(16, Integer.toString(device.getPort()));
            p1.setInt(17, Integer.parseInt(file_id));
            p1.setInt(18, status);
            p1.setString(19, statusmsg);
            initilizeServer.logger.info("\nQuery : " + p1.toString());
            p1.execute();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
        return true;
    }

    public static boolean updateExperimentOverStatus(int userid, String macAddress, int expNumber) {

        try {
            PreparedStatement p1 = conn.prepareStatement("update experimentdetails set expover=?,expoverDate=sysdate() where expid=? and macaddress=? and userid=?;");
            p1.setBoolean(1, true);
            p1.setInt(2, expNumber);
            p1.setString(3, macAddress);
            p1.setInt(4, userid);
            initilizeServer.logger.info("\nQuery : " + p1);
            p1.executeUpdate();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
        return true;
    }

    public static boolean updateExpStartReqSendStatus(int expNumber, String macAddress, int statuscode, String statusMsg, int userid) {
        try {
            PreparedStatement p1 = conn.prepareStatement("update experimentdetails set expackreceived=?, expackreceiveddate=sysdate() ,status=?, statusmessage=? where expid=? and macaddress=? and userid=?;");
            p1.setBoolean(1, true);
            p1.setInt(2, statuscode);
            p1.setString(3, statusMsg);
            p1.setInt(4, expNumber);
            p1.setString(5, macAddress);
            p1.setInt(6, userid);
            initilizeServer.logger.info("\nQuery : " + p1);
            p1.executeUpdate();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
        return true;
    }

    public static ResultSet getUserMacHavingCtrlFile(int userid, int fileid) {
        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select distinct macaddr from control_file_user_info where userid=? and fileid=? and status=2;");
            p1.setInt(1, userid);
            p1.setInt(2, fileid);
            initilizeServer.logger.info("Query : " + p1.toString());
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static ResultSet getExpStartStatus(int expid, String username) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select status, count(*) as count from experimentdetails  where expid=? and userid=? group by status");
            p1.setInt(1, expid);
            p1.setInt(2, DBManager.getUserId(username));
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static ResultSet getDetailedExperimentReqStatus(int expid, String username) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddress,bssid,ssid,status,expreqsenddate,retry,expackreceived,expackreceiveddate,expover,expoverDate,statusmessage from experimentdetails where expid=? and userid=?");
            p1.setInt(1, expid);
            p1.setInt(2, DBManager.getUserId(username));
            initilizeServer.logger.info("\nQuery : " + p1);
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static ResultSet getDetailedControlFileStatus(int expid) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement(" select macaddress,controlfilesend,status,bssid,ssid,expover,expoverDate,controlfilesendDate from experimentdetails where expid=? ;");
            p1.setInt(1, expid);
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static ResultSet getLogFileRequestStatus(int expid) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement(" select getlogrequestsend, count(*) as count from experimentdetails  where expid=? and expover=1 group by getlogrequestsend;");
            p1.setInt(1, expid);
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static int getLogFileReceivedCount(int expid) {
        ResultSet rs = null;
        int count = 0;
        try {
            PreparedStatement p1 = conn.prepareStatement(" select  count(*) as count from experimentdetails  where expid=? and expover=1 and filereceived = true ;");
            p1.setInt(1, expid);
            rs = p1.executeQuery();
            if (rs.next()) {
                count = Integer.parseInt(rs.getString("count"));
            }
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return count;
    }

    public static int getExperimentOverCount(int expid, String username) {

        int count = -1;
        try {
            PreparedStatement p1 = conn.prepareStatement("select count(*) as count from  experimentdetails where expover=true and expid=? and userid=?;");
            p1.setInt(1, expid);
            p1.setInt(2, DBManager.getUserId(username));
            ResultSet rs = p1.executeQuery();
            if (rs.next()) {
                count = Integer.parseInt(rs.getString("count"));
            }
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return count;
    }

    public static boolean updateGetLogFileRequestStatus(int expId, String macAddress, int status) {

        try {
            PreparedStatement p1 = conn.prepareStatement("update experimentdetails set getlogrequestsend=" + status + " where expid=? and macaddress=?;");
            p1.setInt(1, expId);
            p1.setString(2, macAddress);
            p1.executeUpdate();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
        return true;
    }

    public static boolean updateFileReceivedField(int expId, String macAddress, int userid) {
        try {
            PreparedStatement p1 = conn.prepareStatement("update experimentdetails set logfilereceived = true , logfilereceiveddate = sysdate() where expid=? and macaddress=? and userid=?;");
            p1.setInt(1, expId);
            p1.setString(2, macAddress);
            p1.setInt(3, userid);
            initilizeServer.logger.info("\nQuery : " + p1);
            p1.executeUpdate();
            return true;
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return false;
        }
    }

    public static ResultSet getPendingLogFileList() {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select distinct macaddress from experimentdetails order by expid desc;");
            rs = p1.executeQuery();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
            return rs;
        }
        return rs;
    }

    public static CopyOnWriteArrayList<String> getClientsForLogRequest(int expId) {

        CopyOnWriteArrayList<String> clients = new CopyOnWriteArrayList<String>();
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddress from experimentdetails where expover=true and getlogrequestsend=0 and expid=?;");
            p1.setInt(1, expId);
            ResultSet rs = p1.executeQuery();
            while (rs.next()) {
                clients.add(rs.getString("macaddress"));
            }
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return clients;
    }

    public static void updateStopExperiment(int expId) {

        try {
            PreparedStatement p1 = conn.prepareStatement("update  experiments  set endtime = sysdate() where id=?;");
            p1.setInt(1, expId);
            p1.executeUpdate();
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
    }

    public static int nextFileId(String username) {

        int fileId = -1;
        int userId = -1;
        try {
            PreparedStatement p1 = conn.prepareStatement("select userid from users where username=?;");
            p1.setString(1, username);
            initilizeServer.logger.info("\nQuery : " + p1);
            ResultSet rs = p1.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    userId = Integer.parseInt(rs.getString(1));
                }
            }
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        if (userId != -1) {
            try {
                int user = 1;
                PreparedStatement p1 = conn.prepareStatement("select ifnull(max(fileid)+1,1) from control_file_info where userid=?");
                p1.setInt(1, userId);
                initilizeServer.logger.info("\nQuery : " + p1);
                ResultSet rs = p1.executeQuery();
                if (rs != null) {
                    while (rs.next()) {
                        fileId = Integer.parseInt(rs.getString(1));
                    }
                }
            } catch (Exception ex) {
                initilizeServer.logger.error("Exception", ex);
            }
        }
        return fileId;
    }

    public static void addControlFileInfo(String fileName, String desc, String username, String newFileId) {

        int userId = -1;
        try {
            PreparedStatement p1 = conn.prepareStatement("select userid from users where username=?;");
            p1.setString(1, username);
            initilizeServer.logger.info("\nQuery : " + p1);
            ResultSet rs = p1.executeQuery();
            if (rs != null) {
                while (rs.next()) {
                    userId = Integer.parseInt(rs.getString(1));
                }
            }
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }

        if (userId != -1) {
            try {
                PreparedStatement p1 = conn.prepareStatement("insert into control_file_info(fileid,userid,filename,description,filedate) values(?,?,?,?,sysdate());");
                p1.setString(1, newFileId);
                p1.setString(2, Integer.toString(userId));
                p1.setString(3, fileName);
                p1.setString(4, desc);
                p1.execute();
            } catch (Exception ex) {
                initilizeServer.logger.error("Exception", ex);
            }
        }
    }

    public static ResultSet getControlFileUserInfo(int userid, int fileid) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddr,filesenddate,filereceiveddate,retry,status,statusmessage from control_file_user_info where fileid=? and userid=?;");
            p1.setInt(1, fileid);
            p1.setInt(2, userid);
            initilizeServer.logger.info("\nQuery : " + p1);
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static boolean addControlFileSendingDetails(int userid, int fileid, String macaddr, int status, String statusmsg) {

        boolean stat = false;
        try {

            ResultSet rs = null;
            try {
                PreparedStatement p1 = conn.prepareStatement("select macaddr from control_file_user_info where fileid=? and userid=? and macaddr=?");
                p1.setInt(1, fileid);
                p1.setInt(2, userid);
                p1.setString(3, macaddr);
                initilizeServer.logger.info("\nQuery : " + p1);
                rs = p1.executeQuery();
                if (rs != null && rs.next()) { // macaddress entry exist, i.e file sending already tried
                    p1 = conn.prepareStatement("update control_file_user_info set retry=retry+1, status=?,statusmessage=?, filesenddate=sysdate(),filereceiveddate=null where fileid=? and userid=? and macaddr=?;");
                    p1.setInt(1, status);
                    p1.setString(2, statusmsg);
                    p1.setInt(3, fileid);
                    p1.setInt(4, userid);
                    p1.setString(5, macaddr);
                    initilizeServer.logger.info("\nQuery : " + p1);
                    p1.execute();
                    stat = true;
                }else{// file sending not tried
                    p1 = conn.prepareStatement("insert into control_file_user_info(fileid,userid,macaddr,filesenddate,status,statusmessage) values(?,?,?,sysdate(),?,?);");
                    p1.setInt(1, fileid);
                    p1.setInt(2, userid);
                    p1.setString(3, macaddr);
                    p1.setInt(4, status);
                    p1.setString(5, statusmsg);
                    initilizeServer.logger.info("\nQuery : " + p1);
                    p1.execute();
                    stat = true;
                }
            } catch (SQLException ex) {
                stat = false;
                initilizeServer.logger.error("Exception", ex);
            }
        } catch (Exception ex) {
            stat = false;
            initilizeServer.logger.error("Exception", ex);
        }
        return stat;
    }

    public static boolean addControlFileRetryDetails(int userid, int fileid, String macaddr, int status, String statusmsg) {

        boolean stat = false;
        try {
            PreparedStatement p1 = conn.prepareStatement("update control_file_user_info set retry=retry+1, status=?,statusmessage=?, filesenddate=sysdate(),filereceiveddate=null where fileid=? and userid=? and macaddr=?;");
            p1.setInt(1, status);
            p1.setString(2, statusmsg);
            p1.setInt(3, fileid);
            p1.setInt(4, userid);
            p1.setString(5, macaddr);

            initilizeServer.logger.info("\nQuery : " + p1);
            p1.execute();
            stat = true;

        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return stat;
    }

    public static boolean updateControlFileReceivingDetails(int userid, int fileid, String macaddr, int status, String statusmessage) {//, int controlFileStatus, String status) {

        boolean stat = false;
        try {
            PreparedStatement p1 = conn.prepareStatement("update control_file_user_info set filereceiveddate=sysdate(), status=?, statusmessage=? where fileid=? and userid=? and macaddr=? ;");

            p1.setInt(1, status);
            p1.setString(2, statusmessage);
            p1.setInt(3, fileid);
            p1.setInt(4, userid);
            p1.setString(5, macaddr);
            initilizeServer.logger.info("\nQuery : " + p1);
            p1.execute();
            stat = true;
        } catch (Exception ex) {
            stat = false;
            initilizeServer.logger.error("Exception", ex);
        }

        return stat;
    }

    public static ResultSet getAllControlFileNames() {
        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select distinct filename from control_file_info;");
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }//select distinct filename from control_file_info

    public static boolean checkUserExists(String macaddress) {

        ResultSet rs = null;
        boolean flag = false;
        try {
            PreparedStatement p1 = conn.prepareStatement("select count(*) from androidappusers where macaddress=?;");
            p1.setString(1, macaddress);
            initilizeServer.logger.info("Query1 : " + p1.toString());
            rs = p1.executeQuery();
            if (rs.next()) {
                if (rs.getString(1).equalsIgnoreCase("1")) {
                    flag = true;
                } else {
                    flag = false;
                }
            } else {
                flag = false;
            }

        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return flag;
    }

    public static boolean updateAppUserInfo(String email, String macaddress) {

        boolean status = false;

        if (checkUserExists(macaddress)) {

            if (email != null && !email.equalsIgnoreCase("")) {
                try {
                    PreparedStatement p1 = conn.prepareStatement(" update androidappusers set email=?, lastheartbeat=sysdate() where macaddress=?;");
                    p1.setString(1, email);
                    p1.setString(2, macaddress);
                    initilizeServer.logger.info("Query1 : " + p1.toString());
                    p1.executeUpdate();
                    status = true;
                } catch (Exception ex) {
                    status = false;
                    initilizeServer.logger.error("Exception", ex);
                }
            } else {
                try {
                    PreparedStatement p1 = conn.prepareStatement(" update androidappusers set lastheartbeat=sysdate() where macaddress=?;");
                    p1.setString(1, macaddress);
                    initilizeServer.logger.info("Query1 : " + p1.toString());
                    p1.executeUpdate();
                    status = true;
                } catch (Exception ex) {
                    status = false;
                    initilizeServer.logger.error("Exception", ex);
                }
            }
        } else {
            try {
                PreparedStatement p1 = conn.prepareStatement("insert into androidappusers(macaddress,email,lastheartbeat) values(?,?,sysdate());");
                p1.setString(1, macaddress);
                p1.setString(2, email);
                initilizeServer.logger.info("Query2 : " + p1.toString());
                p1.executeUpdate();
                status = true;
            } catch (Exception ex) {
                status = false;
                initilizeServer.logger.error("Exception", ex);
            }
        }
        return status;
    }

    public static void updateAppUserHeartBeatInfo(String macaddress, String appversion, String deviceName, String androidVersion) {

        if (checkUserExists(macaddress)) {
            if (appversion != null && !appversion.equalsIgnoreCase("")) {
                try {
                    PreparedStatement p1 = conn.prepareStatement("update androidappusers set lastheartbeat=sysdate(),appversion=? where macaddress=?");
                    p1.setString(1, appversion);
                    p1.setString(2, macaddress);
                    initilizeServer.logger.info("Query1 : " + p1.toString());
                    p1.executeUpdate();
                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception", ex);
                }
            } else {
                try {
                    PreparedStatement p1 = conn.prepareStatement("update androidappusers set lastheartbeat=sysdate() where macaddress=?");
                    p1.setString(1, macaddress);
                    initilizeServer.logger.info("Query4 : " + p1.toString());
                    p1.executeUpdate();
                } catch (Exception ex) {
                    initilizeServer.logger.error("Exception", ex);
                }
            }
        } else {
            try {
                PreparedStatement p1 = conn.prepareStatement("insert into androidappusers(macaddress,email,appversion,devicename,lastheartbeat) values(?,?,?,?,sysdate());");
                p1.setString(1, macaddress);
                p1.setString(2, "");
                p1.setString(3, appversion);
                p1.setString(4, deviceName);
                initilizeServer.logger.info("Query5 : " + p1.toString());
                p1.executeUpdate();
            } catch (Exception ex) {
                initilizeServer.logger.error("Exception", ex);
            }
        }

        if (deviceName != null && !deviceName.equalsIgnoreCase("")) {
            try {
                PreparedStatement p1 = conn.prepareStatement("update androidappusers set  devicename=?  where macaddress=?");
                p1.setString(1, deviceName);
                p1.setString(2, macaddress);
                initilizeServer.logger.info("Query3 : " + p1.toString());
                p1.executeUpdate();
            } catch (Exception ex) {
                initilizeServer.logger.error("Exception", ex);
            }
        }

        if (androidVersion != null && !androidVersion.equalsIgnoreCase("")) {
            try {
                PreparedStatement p1 = conn.prepareStatement("update androidappusers set  androidVersion=?  where macaddress=?");
                p1.setString(1, androidVersion);
                p1.setString(2, macaddress);
                initilizeServer.logger.info("Query6 : " + p1.toString());
                p1.executeUpdate();
            } catch (Exception ex) {
                initilizeServer.logger.error("Exception", ex);
            }
        }

    }

    public static ResultSet getAppUserInfo() {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddress,email,appversion,lastheartbeat,devicename,androidVersion from androidappusers order by lastheartbeat desc;");
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }

        return rs;
    }

    public static int nextFileId() {

        ResultSet rs = null;
        int fileid = 1;
        try {
            PreparedStatement p1 = conn.prepareStatement("select ifnull(max(fileid)+1,1) as fileid from control_file_info;");
            rs = p1.executeQuery();
            if (rs.next()) {
                fileid = Integer.parseInt(rs.getString("fileid"));
            }

        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return fileid;
    }

    public static ResultSet getControlFileInfo() {
        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select fileid,filename,filedate,description from control_file_info order by fileid desc;");
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static ResultSet getMyControlFiles(String username) {
        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select fileid,filename,filedate from control_file_info where userid=? order by fileid desc;");
            p1.setInt(1, DBManager.getUserId(username));
            initilizeServer.logger.info("Query : " + p1.toString());
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static ResultSet getControlFileInfo(String username) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select A.fileid,A.filename,A.filedate, A.description,B.macaddr,count(*) from control_file_info A left join (select * from control_file_user_info where status=2) B on  A.fileid=B.fileid and A.userid=B.userid where A.userid=? group by A.fileid order by fileid desc;");
            p1.setInt(1, DBManager.getUserId(username));
            initilizeServer.logger.info("Query : " + p1.toString());
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static int getNextExpId(String username) {

        int expId = -1;
        int userId = DBManager.getUserId(username);
        try {
            PreparedStatement p1 = conn.prepareStatement("select ifnull(max(expid)+1,1) from  experiments where userid=?;");
            p1.setInt(1, userId);
            ResultSet rs = p1.executeQuery();
            if (rs != null) {
                if (rs.next()) {
                    expId = Integer.parseInt(rs.getString(1));
                }
            }
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }

        return expId;
    }

    public static String getUserName(int userid) {

        String username = "";
        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select username from users where userid=?");
            p1.setInt(1, userid);
            rs = p1.executeQuery();
            if (rs != null && rs.next()) {
                username = rs.getString(1);
            }
        } catch (SQLException ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return username;
    }

    public static int getUserId(String userName) {

        int userId = -1;
        try {
            PreparedStatement p1 = conn.prepareStatement("select userid from users where username=?;");
            p1.setString(1, userName);
            ResultSet rs = p1.executeQuery();
            if (rs != null) {
                if (rs.next()) {
                    userId = Integer.parseInt(rs.getString(1));
                }
            }
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return userId;
    }

    public static ResultSet getControlFileUserInfo(String fileId, String username) {

        ResultSet rs = null;
        try {
            PreparedStatement p1 = conn.prepareStatement("select macaddr,filesenddate,filereceiveddate,retry,status,statusmessage from control_file_user_info where fileid=? and userid=? and status=2;");
            p1.setInt(1, Integer.parseInt(fileId));
            p1.setInt(2, DBManager.getUserId(username));
            initilizeServer.logger.info("\nQuery : " + p1);
            rs = p1.executeQuery();
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
        }
        return rs;
    }

    public static void deleteExperiment(int expid, String username) {

        int status = -1;
        try {
            PreparedStatement p1 = conn.prepareStatement("delete from experiments where expid=? and userid=?;");
            p1.setInt(1, expid);
            p1.setInt(2, DBManager.getUserId(username));
            initilizeServer.logger.info("Query : " + p1);
            p1.execute();
            status = 1;
        } catch (Exception ex) {
            initilizeServer.logger.error("Exception", ex);
            status = -2;
        }
    }

    /**
     *
     * @param username
     * @param password
     * @return -1 User already exists -2 SQL Exception -3 Exception 1 success
     */
    public static int createAccount(String username, String password) {
        int status = -1;

        try {
            PreparedStatement p1 = conn.prepareStatement("select * from users where username = ?;");
            p1.setString(1, username);
            initilizeServer.logger.info("Query : " + p1);
            ResultSet rs = p1.executeQuery();
            if (rs.next()) {
                status = -1;
            } else {
                p1 = conn.prepareStatement("insert into users(username,password,creationdate) values(?,?,sysdate());");
                p1.setString(1, username);
                p1.setString(2, password);
                initilizeServer.logger.info("Query : " + p1);
                p1.executeUpdate();
                status = 1;
            }
        } catch (SQLException ex) {
            status = -2;
            initilizeServer.logger.error("Exception", ex);
        } catch (Exception ex) {
            status = -3;
            initilizeServer.logger.error("Exception", ex);
        }
        return status;

    }

    /**
     *
     * @param username
     * @param password
     * @return -1 No username -2 SQL exception -3 Exception 1 success
     */
    public static int changePassword(String username, String oldpassword, String newPassword) {
        int status = -1;
        try {

            PreparedStatement p1 = conn.prepareStatement("select * from users where username = ? and password=?;");
            p1.setString(1, username);
            p1.setString(2, oldpassword);
            initilizeServer.logger.info("Query : " + p1);
            ResultSet rs = p1.executeQuery();
            if (!rs.next()) {
                status = -1;
            } else {

                p1 = conn.prepareStatement("update users set password =? where username =?;");
                p1.setString(1, newPassword);
                p1.setString(2, username);
                initilizeServer.logger.info("Query : " + p1);
                p1.executeUpdate();
                status = 1;
            }
        } catch (SQLException ex) {
            status = -2;
            initilizeServer.logger.error("Exception", ex);
        } catch (Exception ex) {
            status = -3;
            initilizeServer.logger.error("Exception", ex);
        }

        return status;
    }

    /**
     * *
     *
     * @param username
     * @return -1 No useraccount -2 SQL exception -3 Exception 1 success
     */
    public static int deleteAccount(String username, String password) {

        int status = -1;

        try {

            PreparedStatement p1 = conn.prepareStatement("select * from users where username = ? and password=?;");
            p1.setString(1, username);
            p1.setString(2, password);
            initilizeServer.logger.info("Query : " + p1);
            ResultSet rs = p1.executeQuery();
            if (!rs.next()) {
                status = -1;
            } else {

                p1 = conn.prepareStatement("delete from users where username =?;");
                p1.setString(1, username);
                initilizeServer.logger.info("Query : " + p1);
                p1.executeUpdate();
                status = 1;
            }
        } catch (SQLException ex) {
            status = -2;
            initilizeServer.logger.error("Exception", ex);
        } catch (Exception ex) {
            status = -3;
            initilizeServer.logger.error("Exception", ex);
        }

        return status;
    }
}
