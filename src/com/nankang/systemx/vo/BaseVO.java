/**
 * BaseVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.nankang.systemx.vo;

public class BaseVO  extends com.nankang.frameworkx.vo.ExAbstractRdbVO  implements java.io.Serializable {
    public BaseVO() {
    }

    public BaseVO(
           int attributeCount,
           java.util.HashMap attributeMap,
           java.lang.String[] attributeNames,
           java.lang.String IDFieldName,
           java.util.HashMap extendedFields,
           java.lang.String[] primaryKeyFieldNames,
           java.lang.Object[] primaryKeyValues,
           java.lang.Object[] referenceTables,
           java.lang.Object[] references,
           java.lang.String sequenceName,
           java.lang.String tableName) {
        super(
            attributeCount,
            attributeMap,
            attributeNames,
            IDFieldName,
            extendedFields,
            primaryKeyFieldNames,
            primaryKeyValues,
            referenceTables,
            references,
            sequenceName,
            tableName);
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof BaseVO)) return false;
        BaseVO other = (BaseVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj);
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(BaseVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vo.systemx.nankang.com", "BaseVO"));
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
