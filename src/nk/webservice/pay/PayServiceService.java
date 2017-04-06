/**
 * PayServiceService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package nk.webservice.pay;

public interface PayServiceService extends javax.xml.rpc.Service {
    public java.lang.String getpayAddress();

    public nk.webservice.pay.PayService getpay() throws javax.xml.rpc.ServiceException;

    public nk.webservice.pay.PayService getpay(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
