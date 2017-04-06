/**
 * PlatformImplServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package _2._15._1._10.dcfwpt.services.platform;

public class PlatformImplServiceLocator extends org.apache.axis.client.Service implements _2._15._1._10.dcfwpt.services.platform.PlatformImplService {

    public PlatformImplServiceLocator() {
    }


    public PlatformImplServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public PlatformImplServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for platform
    private java.lang.String platform_address = "http://10.1.15.2:7001/dcfwpt/services/platform";

    public java.lang.String getplatformAddress() {
        return platform_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String platformWSDDServiceName = "platform";

    public java.lang.String getplatformWSDDServiceName() {
        return platformWSDDServiceName;
    }

    public void setplatformWSDDServiceName(java.lang.String name) {
        platformWSDDServiceName = name;
    }

    public _2._15._1._10.dcfwpt.services.platform.PlatformImpl getplatform() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(platform_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getplatform(endpoint);
    }

    public _2._15._1._10.dcfwpt.services.platform.PlatformImpl getplatform(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            _2._15._1._10.dcfwpt.services.platform.PlatformSoapBindingStub _stub = new _2._15._1._10.dcfwpt.services.platform.PlatformSoapBindingStub(portAddress, this);
            _stub.setPortName(getplatformWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setplatformEndpointAddress(java.lang.String address) {
        platform_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (_2._15._1._10.dcfwpt.services.platform.PlatformImpl.class.isAssignableFrom(serviceEndpointInterface)) {
                _2._15._1._10.dcfwpt.services.platform.PlatformSoapBindingStub _stub = new _2._15._1._10.dcfwpt.services.platform.PlatformSoapBindingStub(new java.net.URL(platform_address), this);
                _stub.setPortName(getplatformWSDDServiceName());
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
        if ("platform".equals(inputPortName)) {
            return getplatform();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://10.1.15.2:7001/dcfwpt/services/platform", "PlatformImplService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://10.1.15.2:7001/dcfwpt/services/platform", "platform"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("platform".equals(portName)) {
            setplatformEndpointAddress(address);
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
