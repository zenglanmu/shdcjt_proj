package nk.webservice;

public class PlatformImplProxy implements nk.webservice.PlatformImpl {
  private String _endpoint = null;
  private nk.webservice.PlatformImpl platformImpl = null;
  
  public PlatformImplProxy() {
    _initPlatformImplProxy();
  }
  
  public PlatformImplProxy(String endpoint) {
    _endpoint = endpoint;
    _initPlatformImplProxy();
  }
  
  private void _initPlatformImplProxy() {
    try {
      platformImpl = (new nk.webservice.PlatformImplServiceLocator()).getdcfwpt();
      if (platformImpl != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)platformImpl)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)platformImpl)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (platformImpl != null)
      ((javax.xml.rpc.Stub)platformImpl)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public nk.webservice.PlatformImpl getPlatformImpl() {
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl;
  }
  
  public boolean backWorkflow(java.lang.String CID) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.backWorkflow(CID);
  }
  
  public java.lang.String getHandlerList(java.lang.String CID) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.getHandlerList(CID);
  }
  
  public boolean submitWorkflow(java.lang.String CID, java.lang.String userID, java.lang.String auditorID, java.lang.String auditDate) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.submitWorkflow(CID, userID, auditorID, auditDate);
  }
  
  public java.lang.String getReportList(java.lang.String userID) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.getReportList(userID);
  }
  
  public java.lang.String getConList(java.lang.String userID) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.getConList(userID);
  }
  
  public void main(java.lang.String[] args) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    platformImpl.main(args);
  }
  
  
}