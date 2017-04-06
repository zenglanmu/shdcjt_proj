/**
 * AbstractRdbVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.nankang.framework.vo;

public abstract class AbstractRdbVO  extends com.nankang.framework.vo.AbstractVO  implements java.io.Serializable {
    private java.lang.String IDFieldName;

    private java.util.HashMap extendedFields;

    private java.lang.String[] primaryKeyFieldNames;

    private java.lang.Object[] primaryKeyValues;

    private java.lang.Object[] referenceTables;

    private java.lang.Object[] references;

    private java.lang.String sequenceName;

    private java.lang.String tableName;

    public AbstractRdbVO() {
    }

    public AbstractRdbVO(
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
            attributeNames);
        this.IDFieldName = IDFieldName;
        this.extendedFields = extendedFields;
        this.primaryKeyFieldNames = primaryKeyFieldNames;
        this.primaryKeyValues = primaryKeyValues;
        this.referenceTables = referenceTables;
        this.references = references;
        this.sequenceName = sequenceName;
        this.tableName = tableName;
    }


    /**
     * Gets the IDFieldName value for this AbstractRdbVO.
     * 
     * @return IDFieldName
     */
    public java.lang.String getIDFieldName() {
        return IDFieldName;
    }


    /**
     * Sets the IDFieldName value for this AbstractRdbVO.
     * 
     * @param IDFieldName
     */
    public void setIDFieldName(java.lang.String IDFieldName) {
        this.IDFieldName = IDFieldName;
    }


    /**
     * Gets the extendedFields value for this AbstractRdbVO.
     * 
     * @return extendedFields
     */
    public java.util.HashMap getExtendedFields() {
        return extendedFields;
    }


    /**
     * Sets the extendedFields value for this AbstractRdbVO.
     * 
     * @param extendedFields
     */
    public void setExtendedFields(java.util.HashMap extendedFields) {
        this.extendedFields = extendedFields;
    }


    /**
     * Gets the primaryKeyFieldNames value for this AbstractRdbVO.
     * 
     * @return primaryKeyFieldNames
     */
    public java.lang.String[] getPrimaryKeyFieldNames() {
        return primaryKeyFieldNames;
    }


    /**
     * Sets the primaryKeyFieldNames value for this AbstractRdbVO.
     * 
     * @param primaryKeyFieldNames
     */
    public void setPrimaryKeyFieldNames(java.lang.String[] primaryKeyFieldNames) {
        this.primaryKeyFieldNames = primaryKeyFieldNames;
    }


    /**
     * Gets the primaryKeyValues value for this AbstractRdbVO.
     * 
     * @return primaryKeyValues
     */
    public java.lang.Object[] getPrimaryKeyValues() {
        return primaryKeyValues;
    }


    /**
     * Sets the primaryKeyValues value for this AbstractRdbVO.
     * 
     * @param primaryKeyValues
     */
    public void setPrimaryKeyValues(java.lang.Object[] primaryKeyValues) {
        this.primaryKeyValues = primaryKeyValues;
    }


    /**
     * Gets the referenceTables value for this AbstractRdbVO.
     * 
     * @return referenceTables
     */
    public java.lang.Object[] getReferenceTables() {
        return referenceTables;
    }


    /**
     * Sets the referenceTables value for this AbstractRdbVO.
     * 
     * @param referenceTables
     */
    public void setReferenceTables(java.lang.Object[] referenceTables) {
        this.referenceTables = referenceTables;
    }


    /**
     * Gets the references value for this AbstractRdbVO.
     * 
     * @return references
     */
    public java.lang.Object[] getReferences() {
        return references;
    }


    /**
     * Sets the references value for this AbstractRdbVO.
     * 
     * @param references
     */
    public void setReferences(java.lang.Object[] references) {
        this.references = references;
    }


    /**
     * Gets the sequenceName value for this AbstractRdbVO.
     * 
     * @return sequenceName
     */
    public java.lang.String getSequenceName() {
        return sequenceName;
    }


    /**
     * Sets the sequenceName value for this AbstractRdbVO.
     * 
     * @param sequenceName
     */
    public void setSequenceName(java.lang.String sequenceName) {
        this.sequenceName = sequenceName;
    }


    /**
     * Gets the tableName value for this AbstractRdbVO.
     * 
     * @return tableName
     */
    public java.lang.String getTableName() {
        return tableName;
    }


    /**
     * Sets the tableName value for this AbstractRdbVO.
     * 
     * @param tableName
     */
    public void setTableName(java.lang.String tableName) {
        this.tableName = tableName;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof AbstractRdbVO)) return false;
        AbstractRdbVO other = (AbstractRdbVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.IDFieldName==null && other.getIDFieldName()==null) || 
             (this.IDFieldName!=null &&
              this.IDFieldName.equals(other.getIDFieldName()))) &&
            ((this.extendedFields==null && other.getExtendedFields()==null) || 
             (this.extendedFields!=null &&
              this.extendedFields.equals(other.getExtendedFields()))) &&
            ((this.primaryKeyFieldNames==null && other.getPrimaryKeyFieldNames()==null) || 
             (this.primaryKeyFieldNames!=null &&
              java.util.Arrays.equals(this.primaryKeyFieldNames, other.getPrimaryKeyFieldNames()))) &&
            ((this.primaryKeyValues==null && other.getPrimaryKeyValues()==null) || 
             (this.primaryKeyValues!=null &&
              java.util.Arrays.equals(this.primaryKeyValues, other.getPrimaryKeyValues()))) &&
            ((this.referenceTables==null && other.getReferenceTables()==null) || 
             (this.referenceTables!=null &&
              java.util.Arrays.equals(this.referenceTables, other.getReferenceTables()))) &&
            ((this.references==null && other.getReferences()==null) || 
             (this.references!=null &&
              java.util.Arrays.equals(this.references, other.getReferences()))) &&
            ((this.sequenceName==null && other.getSequenceName()==null) || 
             (this.sequenceName!=null &&
              this.sequenceName.equals(other.getSequenceName()))) &&
            ((this.tableName==null && other.getTableName()==null) || 
             (this.tableName!=null &&
              this.tableName.equals(other.getTableName())));
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
        if (getIDFieldName() != null) {
            _hashCode += getIDFieldName().hashCode();
        }
        if (getExtendedFields() != null) {
            _hashCode += getExtendedFields().hashCode();
        }
        if (getPrimaryKeyFieldNames() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getPrimaryKeyFieldNames());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getPrimaryKeyFieldNames(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getPrimaryKeyValues() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getPrimaryKeyValues());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getPrimaryKeyValues(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getReferenceTables() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getReferenceTables());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getReferenceTables(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getReferences() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getReferences());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getReferences(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getSequenceName() != null) {
            _hashCode += getSequenceName().hashCode();
        }
        if (getTableName() != null) {
            _hashCode += getTableName().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(AbstractRdbVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://vo.framework.nankang.com", "AbstractRdbVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("IDFieldName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "IDFieldName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("extendedFields");
        elemField.setXmlName(new javax.xml.namespace.QName("", "extendedFields"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://xml.apache.org/xml-soap", "Map"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("primaryKeyFieldNames");
        elemField.setXmlName(new javax.xml.namespace.QName("", "primaryKeyFieldNames"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("primaryKeyValues");
        elemField.setXmlName(new javax.xml.namespace.QName("", "primaryKeyValues"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyType"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("referenceTables");
        elemField.setXmlName(new javax.xml.namespace.QName("", "referenceTables"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyType"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("references");
        elemField.setXmlName(new javax.xml.namespace.QName("", "references"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "anyType"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("sequenceName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "sequenceName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tableName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "tableName"));
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
