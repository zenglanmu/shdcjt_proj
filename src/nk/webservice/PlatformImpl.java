/**
 * PlatformImpl.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package nk.webservice;

public interface PlatformImpl extends java.rmi.Remote {
    public boolean backWorkflow(java.lang.String CID) throws java.rmi.RemoteException;
    public java.lang.String getHandlerList(java.lang.String CID) throws java.rmi.RemoteException;
    public boolean submitWorkflow(java.lang.String CID, java.lang.String userID, java.lang.String auditorID, java.lang.String auditDate) throws java.rmi.RemoteException;
    public java.lang.String getReportList(java.lang.String userID) throws java.rmi.RemoteException;
    public java.lang.String getConList(java.lang.String userID) throws java.rmi.RemoteException;
    public void main(java.lang.String[] args) throws java.rmi.RemoteException;
}
