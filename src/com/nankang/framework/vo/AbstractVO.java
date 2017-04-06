/**
 * AbstractVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.nankang.framework.vo;

public abstract class AbstractVO  extends com.nankang.framework.NKObject  implements java.io.Serializable {
    private int attributeCount;

    private java.util.HashMap attributeMap;

    private java.lang.String[] attributeNames;

    public AbstractVO() {
    }

    public AbstractVO(
           int attributeCount,
           java.util.HashMap attributeMap,
           java.lang.String[] attributeNames) {
        this.attributeCount = attributeCount;
        this.attributeMap = attributeMap;
        this.attributeNames = attributeNames;
    }


    /**
     * Gets the attributeCount value for this AbstractVO.
     * 
     * @return attributeCount
     */
    public int getAttributeCount() {
        return attributeCount;
    }


    /**
     * Sets the attributeCount value for this AbstractVO.
     * 
     * @param attributeCount
     */
    public void setAttributeCount(int attributeCount) {
        this.attributeCount = attributeCount;
    }


    /**
     * Gets the attributeMap value for this AbstractVO.
     * 
     * @return attributeMap
     */
    public java.util.HashMap getAttributeMap() {
        return attributeMap;
    }


    /**
     * Sets the attributeMap value for this AbstractVO.
     * 
     * @param attributeMap
     */
    public void setAttributeMap(java.util.HashMap attributeMap) {
        this.attributeMap = attributeMap;
    }


    /**
     * Gets the attributeNames value for this AbstractVO.
     * 
     * @return attributeNames
     */
    public java.lang.String[] getAttributeNames() {
        return attributeNames;
    }


    /**
     * Sets the attributeNames value for this AbstractVO.
     * 
     * @param attributeNames
     */
    public void setAttributeNames(java.lang.String[] attributeNames) {
        this.attributeNames = attributeNames;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AbstractVO)) return false;
        AbstractVO other = (AbstractVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            this.attributeCount == other.getAttributeCount() &&
            ((this.attributeMap==null && other.getAttributeMap()==null) || 
             (this.attributeMap!=null &&
              this.attributeMap.equals(other.getAttributeMap()))) &&
            ((this.attributeNames==null && other.getAttributeNames()==null) || 
             (this.attributeNames!=null &&
              java.util.Arrays.equals(this.attributeNames, other.getAttributeNames())));
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
        _hashCode += getAttributeCount();
        if (getAttributeMap() != null) {
            _hashCode += getAttributeMap().hashCode();
        }
        if (getAttributeNames() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getAttributeNames());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getAttributeNames(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AbstractVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vo.framework.nankang.com", "AbstractVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("attributeCount");
        elemField.setXmlName(new javax.xml.namespace.QName("", "attributeCount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("attributeMap");
        elemField.setXmlName(new javax.xml.namespace.QName("", "attributeMap"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://xml.apache.org/xml-soap", "Map"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("attributeNames");
        elemField.setXmlName(new javax.xml.namespace.QName("", "attributeNames"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
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
