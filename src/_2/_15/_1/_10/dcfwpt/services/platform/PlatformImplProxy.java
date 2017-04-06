package _2._15._1._10.dcfwpt.services.platform;

public class PlatformImplProxy implements _2._15._1._10.dcfwpt.services.platform.PlatformImpl {
  private String _endpoint = null;
  private _2._15._1._10.dcfwpt.services.platform.PlatformImpl platformImpl = null;
  
  public PlatformImplProxy() {
    _initPlatformImplProxy();
  }
  
  public PlatformImplProxy(String endpoint) {
    _endpoint = endpoint;
    _initPlatformImplProxy();
  }
  
  private void _initPlatformImplProxy() {
    try {
      platformImpl = (new _2._15._1._10.dcfwpt.services.platform.PlatformImplServiceLocator()).getplatform();
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
  
  public _2._15._1._10.dcfwpt.services.platform.PlatformImpl getPlatformImpl() {
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl;
  }
  
  public java.lang.String getUser(long userID) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.getUser(userID);
  }
  
  public java.lang.String loginCheck(java.lang.String token, java.lang.String sessionToken) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.loginCheck(token, sessionToken);
  }
  
  public java.lang.String getApplicationList(java.lang.String token) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.getApplicationList(token);
  }
  
  public java.lang.String logout(java.lang.String token) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.logout(token);
  }
  
  public java.lang.String toApp(int _int, java.lang.String token) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.toApp(_int, token);
  }
  
  public java.lang.String getLoginUrl() throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.getLoginUrl();
  }
  
  public java.lang.String changePwd(java.lang.String token, java.lang.String oldPwd, java.lang.String newPwd) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.changePwd(token, oldPwd, newPwd);
  }
  
  public java.lang.String validateLogin(java.lang.String loginName, java.lang.String passWord) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.validateLogin(loginName, passWord);
  }
  
  public java.lang.String updateUser(BeanService.UserVO userInfo) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.updateUser(userInfo);
  }
  
  public java.lang.String saveApplog(int appid, long userID, java.lang.String userName, java.lang.String logtype, java.lang.String content, java.lang.String result) throws java.rmi.RemoteException{
    if (platformImpl == null)
      _initPlatformImplProxy();
    return platformImpl.saveApplog(appid, userID, userName, logtype, content, result);
  }
  
  
}