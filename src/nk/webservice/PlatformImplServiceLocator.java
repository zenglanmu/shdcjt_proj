/**
 * PlatformImplServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package nk.webservice;

public class PlatformImplServiceLocator extends org.apache.axis.client.Service implements nk.webservice.PlatformImplService {

    public PlatformImplServiceLocator() {
    }


    public PlatformImplServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public PlatformImplServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for dcfwpt
    private java.lang.String dcfwpt_address = "http://10.1.100.33:8080/dcfwpt/services/dcfwpt";

    public java.lang.String getdcfwptAddress() {
        return dcfwpt_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String dcfwptWSDDServiceName = "dcfwpt";

    public java.lang.String getdcfwptWSDDServiceName() {
        return dcfwptWSDDServiceName;
    }

    public void setdcfwptWSDDServiceName(java.lang.String name) {
        dcfwptWSDDServiceName = name;
    }

    public nk.webservice.PlatformImpl getdcfwpt() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(dcfwpt_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getdcfwpt(endpoint);
    }

    public nk.webservice.PlatformImpl getdcfwpt(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	nk.webservice.DcfwptSoapBindingStub _stub = new nk.webservice.DcfwptSoapBindingStub(portAddress, this);
            _stub.setPortName(getdcfwptWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setdcfwptEndpointAddress(java.lang.String address) {
        dcfwpt_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (nk.webservice.PlatformImpl.class.isAssignableFrom(serviceEndpointInterface)) {
            	nk.webservice.DcfwptSoapBindingStub _stub = new nk.webservice.DcfwptSoapBindingStub(new java.net.URL(dcfwpt_address), this);
                _stub.setPortName(getdcfwptWSDDServiceName());
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
        if ("dcfwpt".equals(inputPortName)) {
            return getdcfwpt();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://10.1.100.33:8080/dcfwpt/services/dcfwpt", "PlatformImplService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://10.1.100.33:8080/dcfwpt/services/dcfwpt", "dcfwpt"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("dcfwpt".equals(portName)) {
            setdcfwptEndpointAddress(address);
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
