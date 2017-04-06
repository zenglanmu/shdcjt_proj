/**
 * PayServiceServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package nk.webservice.pay;

public class PayServiceServiceLocator extends org.apache.axis.client.Service implements nk.webservice.pay.PayServiceService {

    public PayServiceServiceLocator() {
    }


    public PayServiceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public PayServiceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for pay
    private java.lang.String pay_address = "http://10.1.15.2:7001/dcfwpt/services/pay";

    public java.lang.String getpayAddress() {
        return pay_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String payWSDDServiceName = "pay";

    public java.lang.String getpayWSDDServiceName() {
        return payWSDDServiceName;
    }

    public void setpayWSDDServiceName(java.lang.String name) {
        payWSDDServiceName = name;
    }

    public nk.webservice.pay.PayService getpay() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(pay_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getpay(endpoint);
    }

    public nk.webservice.pay.PayService getpay(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            nk.webservice.pay.PaySoapBindingStub _stub = new nk.webservice.pay.PaySoapBindingStub(portAddress, this);
            _stub.setPortName(getpayWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setpayEndpointAddress(java.lang.String address) {
        pay_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (nk.webservice.pay.PayService.class.isAssignableFrom(serviceEndpointInterface)) {
                nk.webservice.pay.PaySoapBindingStub _stub = new nk.webservice.pay.PaySoapBindingStub(new java.net.URL(pay_address), this);
                _stub.setPortName(getpayWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("pay".equals(inputPortName)) {
            return getpay();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://10.1.15.2:7001/dcfwpt/services/pay", "PayServiceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://10.1.15.2:7001/dcfwpt/services/pay", "pay"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("pay".equals(portName)) {
            setpayEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
