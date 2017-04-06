/**
 * PlatformImpl.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package _2._15._1._10.dcfwpt.services.platform;

public interface PlatformImpl extends java.rmi.Remote {
    public java.lang.String getUser(long userID) throws java.rmi.RemoteException;
    public java.lang.String loginCheck(java.lang.String token, java.lang.String sessionToken) throws java.rmi.RemoteException;
    public java.lang.String getApplicationList(java.lang.String token) throws java.rmi.RemoteException;
    public java.lang.String logout(java.lang.String token) throws java.rmi.RemoteException;
    public java.lang.String toApp(int _int, java.lang.String token) throws java.rmi.RemoteException;
    public java.lang.String getLoginUrl() throws java.rmi.RemoteException;
    public java.lang.String changePwd(java.lang.String token, java.lang.String oldPwd, java.lang.String newPwd) throws java.rmi.RemoteException;
    public java.lang.String validateLogin(java.lang.String loginName, java.lang.String passWord) throws java.rmi.RemoteException;
    public java.lang.String updateUser(BeanService.UserVO userInfo) throws java.rmi.RemoteException;
    public java.lang.String saveApplog(int appid, long userID, java.lang.String userName, java.lang.String logtype, java.lang.String content, java.lang.String result) throws java.rmi.RemoteException;
}
