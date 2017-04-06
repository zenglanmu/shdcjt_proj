package nk.webservice.pay;

public class PayServiceProxy implements nk.webservice.pay.PayService {
  private String _endpoint = null;
  private nk.webservice.pay.PayService payService = null;
  
  public PayServiceProxy() {
    _initPayServiceProxy();
  }
  
  public PayServiceProxy(String endpoint) {
    _endpoint = endpoint;
    _initPayServiceProxy();
  }
  
  private void _initPayServiceProxy() {
    try {
      payService = (new nk.webservice.pay.PayServiceServiceLocator()).getpay();
      if (payService != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)payService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)payService)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (payService != null)
      ((javax.xml.rpc.Stub)payService)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public nk.webservice.pay.PayService getPayService() {
    if (payService == null)
      _initPayServiceProxy();
    return payService;
  }
  
  public boolean getResultFromOA(java.lang.String cid, boolean flag) throws java.rmi.RemoteException{
    if (payService == null)
      _initPayServiceProxy();
    return payService.getResultFromOA(cid, flag);
  }
  
  
}