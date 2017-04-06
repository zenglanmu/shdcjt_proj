/**
 * UserVO.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package BeanService;

public class UserVO  extends com.nankang.systemx.vo.BaseVO  implements java.io.Serializable {
    private java.lang.String CACertCategory;

    private short CACertState;

    private java.lang.String CACertType;

    private java.lang.String address;

    private boolean asSysManager;

    private java.lang.String certCode;

    private java.lang.String certType;

    private java.lang.String city;

    private java.lang.String country;

    private java.util.Calendar createdTime;

    private java.lang.String creator;

    private int defaultAppID;

    private java.lang.String description;

    private java.lang.String displayName;

    private java.lang.String email;

    private java.lang.String fax;

    private java.lang.String loginName;

    private short loginType;

    private java.lang.String mobile;

    private java.util.Calendar modifiedTime;

    private java.lang.String modifier;

    private java.lang.String orgName;

    private java.lang.String password;

    private int portalTemplateID;

    private BeanService.ByteArray portraitPhoto;

    private java.lang.String province;

    private java.lang.String pwdSeq;

    private java.lang.String realName;

    private int regionID;

    private java.lang.String telephone;

    private int userID;

    private boolean valid;

    private java.lang.String zip;

    public UserVO() {
    }

    public UserVO(
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
           java.lang.String tableName,
           java.lang.String CACertCategory,
           short CACertState,
           java.lang.String CACertType,
           java.lang.String address,
           boolean asSysManager,
           java.lang.String certCode,
           java.lang.String certType,
           java.lang.String city,
           java.lang.String country,
           java.util.Calendar createdTime,
           java.lang.String creator,
           int defaultAppID,
           java.lang.String description,
           java.lang.String displayName,
           java.lang.String email,
           java.lang.String fax,
           java.lang.String loginName,
           short loginType,
           java.lang.String mobile,
           java.util.Calendar modifiedTime,
           java.lang.String modifier,
           java.lang.String orgName,
           java.lang.String password,
           int portalTemplateID,
           BeanService.ByteArray portraitPhoto,
           java.lang.String province,
           java.lang.String pwdSeq,
           java.lang.String realName,
           int regionID,
           java.lang.String telephone,
           int userID,
           boolean valid,
           java.lang.String zip) {
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
        this.CACertCategory = CACertCategory;
        this.CACertState = CACertState;
        this.CACertType = CACertType;
        this.address = address;
        this.asSysManager = asSysManager;
        this.certCode = certCode;
        this.certType = certType;
        this.city = city;
        this.country = country;
        this.createdTime = createdTime;
        this.creator = creator;
        this.defaultAppID = defaultAppID;
        this.description = description;
        this.displayName = displayName;
        this.email = email;
        this.fax = fax;
        this.loginName = loginName;
        this.loginType = loginType;
        this.mobile = mobile;
        this.modifiedTime = modifiedTime;
        this.modifier = modifier;
        this.orgName = orgName;
        this.password = password;
        this.portalTemplateID = portalTemplateID;
        this.portraitPhoto = portraitPhoto;
        this.province = province;
        this.pwdSeq = pwdSeq;
        this.realName = realName;
        this.regionID = regionID;
        this.telephone = telephone;
        this.userID = userID;
        this.valid = valid;
        this.zip = zip;
    }


    /**
     * Gets the CACertCategory value for this UserVO.
     * 
     * @return CACertCategory
     */
    public java.lang.String getCACertCategory() {
        return CACertCategory;
    }


    /**
     * Sets the CACertCategory value for this UserVO.
     * 
     * @param CACertCategory
     */
    public void setCACertCategory(java.lang.String CACertCategory) {
        this.CACertCategory = CACertCategory;
    }


    /**
     * Gets the CACertState value for this UserVO.
     * 
     * @return CACertState
     */
    public short getCACertState() {
        return CACertState;
    }


    /**
     * Sets the CACertState value for this UserVO.
     * 
     * @param CACertState
     */
    public void setCACertState(short CACertState) {
        this.CACertState = CACertState;
    }


    /**
     * Gets the CACertType value for this UserVO.
     * 
     * @return CACertType
     */
    public java.lang.String getCACertType() {
        return CACertType;
    }


    /**
     * Sets the CACertType value for this UserVO.
     * 
     * @param CACertType
     */
    public void setCACertType(java.lang.String CACertType) {
        this.CACertType = CACertType;
    }


    /**
     * Gets the address value for this UserVO.
     * 
     * @return address
     */
    public java.lang.String getAddress() {
        return address;
    }


    /**
     * Sets the address value for this UserVO.
     * 
     * @param address
     */
    public void setAddress(java.lang.String address) {
        this.address = address;
    }


    /**
     * Gets the asSysManager value for this UserVO.
     * 
     * @return asSysManager
     */
    public boolean isAsSysManager() {
        return asSysManager;
    }


    /**
     * Sets the asSysManager value for this UserVO.
     * 
     * @param asSysManager
     */
    public void setAsSysManager(boolean asSysManager) {
        this.asSysManager = asSysManager;
    }


    /**
     * Gets the certCode value for this UserVO.
     * 
     * @return certCode
     */
    public java.lang.String getCertCode() {
        return certCode;
    }


    /**
     * Sets the certCode value for this UserVO.
     * 
     * @param certCode
     */
    public void setCertCode(java.lang.String certCode) {
        this.certCode = certCode;
    }


    /**
     * Gets the certType value for this UserVO.
     * 
     * @return certType
     */
    public java.lang.String getCertType() {
        return certType;
    }


    /**
     * Sets the certType value for this UserVO.
     * 
     * @param certType
     */
    public void setCertType(java.lang.String certType) {
        this.certType = certType;
    }


    /**
     * Gets the city value for this UserVO.
     * 
     * @return city
     */
    public java.lang.String getCity() {
        return city;
    }


    /**
     * Sets the city value for this UserVO.
     * 
     * @param city
     */
    public void setCity(java.lang.String city) {
        this.city = city;
    }


    /**
     * Gets the country value for this UserVO.
     * 
     * @return country
     */
    public java.lang.String getCountry() {
        return country;
    }


    /**
     * Sets the country value for this UserVO.
     * 
     * @param country
     */
    public void setCountry(java.lang.String country) {
        this.country = country;
    }


    /**
     * Gets the createdTime value for this UserVO.
     * 
     * @return createdTime
     */
    public java.util.Calendar getCreatedTime() {
        return createdTime;
    }


    /**
     * Sets the createdTime value for this UserVO.
     * 
     * @param createdTime
     */
    public void setCreatedTime(java.util.Calendar createdTime) {
        this.createdTime = createdTime;
    }


    /**
     * Gets the creator value for this UserVO.
     * 
     * @return creator
     */
    public java.lang.String getCreator() {
        return creator;
    }


    /**
     * Sets the creator value for this UserVO.
     * 
     * @param creator
     */
    public void setCreator(java.lang.String creator) {
        this.creator = creator;
    }


    /**
     * Gets the defaultAppID value for this UserVO.
     * 
     * @return defaultAppID
     */
    public int getDefaultAppID() {
        return defaultAppID;
    }


    /**
     * Sets the defaultAppID value for this UserVO.
     * 
     * @param defaultAppID
     */
    public void setDefaultAppID(int defaultAppID) {
        this.defaultAppID = defaultAppID;
    }


    /**
     * Gets the description value for this UserVO.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this UserVO.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the displayName value for this UserVO.
     * 
     * @return displayName
     */
    public java.lang.String getDisplayName() {
        return displayName;
    }


    /**
     * Sets the displayName value for this UserVO.
     * 
     * @param displayName
     */
    public void setDisplayName(java.lang.String displayName) {
        this.displayName = displayName;
    }


    /**
     * Gets the email value for this UserVO.
     * 
     * @return email
     */
    public java.lang.String getEmail() {
        return email;
    }


    /**
     * Sets the email value for this UserVO.
     * 
     * @param email
     */
    public void setEmail(java.lang.String email) {
        this.email = email;
    }


    /**
     * Gets the fax value for this UserVO.
     * 
     * @return fax
     */
    public java.lang.String getFax() {
        return fax;
    }


    /**
     * Sets the fax value for this UserVO.
     * 
     * @param fax
     */
    public void setFax(java.lang.String fax) {
        this.fax = fax;
    }


    /**
     * Gets the loginName value for this UserVO.
     * 
     * @return loginName
     */
    public java.lang.String getLoginName() {
        return loginName;
    }


    /**
     * Sets the loginName value for this UserVO.
     * 
     * @param loginName
     */
    public void setLoginName(java.lang.String loginName) {
        this.loginName = loginName;
    }


    /**
     * Gets the loginType value for this UserVO.
     * 
     * @return loginType
     */
    public short getLoginType() {
        return loginType;
    }


    /**
     * Sets the loginType value for this UserVO.
     * 
     * @param loginType
     */
    public void setLoginType(short loginType) {
        this.loginType = loginType;
    }


    /**
     * Gets the mobile value for this UserVO.
     * 
     * @return mobile
     */
    public java.lang.String getMobile() {
        return mobile;
    }


    /**
     * Sets the mobile value for this UserVO.
     * 
     * @param mobile
     */
    public void setMobile(java.lang.String mobile) {
        this.mobile = mobile;
    }


    /**
     * Gets the modifiedTime value for this UserVO.
     * 
     * @return modifiedTime
     */
    public java.util.Calendar getModifiedTime() {
        return modifiedTime;
    }


    /**
     * Sets the modifiedTime value for this UserVO.
     * 
     * @param modifiedTime
     */
    public void setModifiedTime(java.util.Calendar modifiedTime) {
        this.modifiedTime = modifiedTime;
    }


    /**
     * Gets the modifier value for this UserVO.
     * 
     * @return modifier
     */
    public java.lang.String getModifier() {
        return modifier;
    }


    /**
     * Sets the modifier value for this UserVO.
     * 
     * @param modifier
     */
    public void setModifier(java.lang.String modifier) {
        this.modifier = modifier;
    }


    /**
     * Gets the orgName value for this UserVO.
     * 
     * @return orgName
     */
    public java.lang.String getOrgName() {
        return orgName;
    }


    /**
     * Sets the orgName value for this UserVO.
     * 
     * @param orgName
     */
    public void setOrgName(java.lang.String orgName) {
        this.orgName = orgName;
    }


    /**
     * Gets the password value for this UserVO.
     * 
     * @return password
     */
    public java.lang.String getPassword() {
        return password;
    }


    /**
     * Sets the password value for this UserVO.
     * 
     * @param password
     */
    public void setPassword(java.lang.String password) {
        this.password = password;
    }


    /**
     * Gets the portalTemplateID value for this UserVO.
     * 
     * @return portalTemplateID
     */
    public int getPortalTemplateID() {
        return portalTemplateID;
    }


    /**
     * Sets the portalTemplateID value for this UserVO.
     * 
     * @param portalTemplateID
     */
    public void setPortalTemplateID(int portalTemplateID) {
        this.portalTemplateID = portalTemplateID;
    }


    /**
     * Gets the portraitPhoto value for this UserVO.
     * 
     * @return portraitPhoto
     */
    public BeanService.ByteArray getPortraitPhoto() {
        return portraitPhoto;
    }


    /**
     * Sets the portraitPhoto value for this UserVO.
     * 
     * @param portraitPhoto
     */
    public void setPortraitPhoto(BeanService.ByteArray portraitPhoto) {
        this.portraitPhoto = portraitPhoto;
    }


    /**
     * Gets the province value for this UserVO.
     * 
     * @return province
     */
    public java.lang.String getProvince() {
        return province;
    }


    /**
     * Sets the province value for this UserVO.
     * 
     * @param province
     */
    public void setProvince(java.lang.String province) {
        this.province = province;
    }


    /**
     * Gets the pwdSeq value for this UserVO.
     * 
     * @return pwdSeq
     */
    public java.lang.String getPwdSeq() {
        return pwdSeq;
    }


    /**
     * Sets the pwdSeq value for this UserVO.
     * 
     * @param pwdSeq
     */
    public void setPwdSeq(java.lang.String pwdSeq) {
        this.pwdSeq = pwdSeq;
    }


    /**
     * Gets the realName value for this UserVO.
     * 
     * @return realName
     */
    public java.lang.String getRealName() {
        return realName;
    }


    /**
     * Sets the realName value for this UserVO.
     * 
     * @param realName
     */
    public void setRealName(java.lang.String realName) {
        this.realName = realName;
    }


    /**
     * Gets the regionID value for this UserVO.
     * 
     * @return regionID
     */
    public int getRegionID() {
        return regionID;
    }


    /**
     * Sets the regionID value for this UserVO.
     * 
     * @param regionID
     */
    public void setRegionID(int regionID) {
        this.regionID = regionID;
    }


    /**
     * Gets the telephone value for this UserVO.
     * 
     * @return telephone
     */
    public java.lang.String getTelephone() {
        return telephone;
    }


    /**
     * Sets the telephone value for this UserVO.
     * 
     * @param telephone
     */
    public void setTelephone(java.lang.String telephone) {
        this.telephone = telephone;
    }


    /**
     * Gets the userID value for this UserVO.
     * 
     * @return userID
     */
    public int getUserID() {
        return userID;
    }


    /**
     * Sets the userID value for this UserVO.
     * 
     * @param userID
     */
    public void setUserID(int userID) {
        this.userID = userID;
    }


    /**
     * Gets the valid value for this UserVO.
     * 
     * @return valid
     */
    public boolean isValid() {
        return valid;
    }


    /**
     * Sets the valid value for this UserVO.
     * 
     * @param valid
     */
    public void setValid(boolean valid) {
        this.valid = valid;
    }


    /**
     * Gets the zip value for this UserVO.
     * 
     * @return zip
     */
    public java.lang.String getZip() {
        return zip;
    }


    /**
     * Sets the zip value for this UserVO.
     * 
     * @param zip
     */
    public void setZip(java.lang.String zip) {
        this.zip = zip;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof UserVO)) return false;
        UserVO other = (UserVO) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.CACertCategory==null && other.getCACertCategory()==null) || 
             (this.CACertCategory!=null &&
              this.CACertCategory.equals(other.getCACertCategory()))) &&
            this.CACertState == other.getCACertState() &&
            ((this.CACertType==null && other.getCACertType()==null) || 
             (this.CACertType!=null &&
              this.CACertType.equals(other.getCACertType()))) &&
            ((this.address==null && other.getAddress()==null) || 
             (this.address!=null &&
              this.address.equals(other.getAddress()))) &&
            this.asSysManager == other.isAsSysManager() &&
            ((this.certCode==null && other.getCertCode()==null) || 
             (this.certCode!=null &&
              this.certCode.equals(other.getCertCode()))) &&
            ((this.certType==null && other.getCertType()==null) || 
             (this.certType!=null &&
              this.certType.equals(other.getCertType()))) &&
            ((this.city==null && other.getCity()==null) || 
             (this.city!=null &&
              this.city.equals(other.getCity()))) &&
            ((this.country==null && other.getCountry()==null) || 
             (this.country!=null &&
              this.country.equals(other.getCountry()))) &&
            ((this.createdTime==null && other.getCreatedTime()==null) || 
             (this.createdTime!=null &&
              this.createdTime.equals(other.getCreatedTime()))) &&
            ((this.creator==null && other.getCreator()==null) || 
             (this.creator!=null &&
              this.creator.equals(other.getCreator()))) &&
            this.defaultAppID == other.getDefaultAppID() &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.displayName==null && other.getDisplayName()==null) || 
             (this.displayName!=null &&
              this.displayName.equals(other.getDisplayName()))) &&
            ((this.email==null && other.getEmail()==null) || 
             (this.email!=null &&
              this.email.equals(other.getEmail()))) &&
            ((this.fax==null && other.getFax()==null) || 
             (this.fax!=null &&
              this.fax.equals(other.getFax()))) &&
            ((this.loginName==null && other.getLoginName()==null) || 
             (this.loginName!=null &&
              this.loginName.equals(other.getLoginName()))) &&
            this.loginType == other.getLoginType() &&
            ((this.mobile==null && other.getMobile()==null) || 
             (this.mobile!=null &&
              this.mobile.equals(other.getMobile()))) &&
            ((this.modifiedTime==null && other.getModifiedTime()==null) || 
             (this.modifiedTime!=null &&
              this.modifiedTime.equals(other.getModifiedTime()))) &&
            ((this.modifier==null && other.getModifier()==null) || 
             (this.modifier!=null &&
              this.modifier.equals(other.getModifier()))) &&
            ((this.orgName==null && other.getOrgName()==null) || 
             (this.orgName!=null &&
              this.orgName.equals(other.getOrgName()))) &&
            ((this.password==null && other.getPassword()==null) || 
             (this.password!=null &&
              this.password.equals(other.getPassword()))) &&
            this.portalTemplateID == other.getPortalTemplateID() &&
            ((this.portraitPhoto==null && other.getPortraitPhoto()==null) || 
             (this.portraitPhoto!=null &&
              this.portraitPhoto.equals(other.getPortraitPhoto()))) &&
            ((this.province==null && other.getProvince()==null) || 
             (this.province!=null &&
              this.province.equals(other.getProvince()))) &&
            ((this.pwdSeq==null && other.getPwdSeq()==null) || 
             (this.pwdSeq!=null &&
              this.pwdSeq.equals(other.getPwdSeq()))) &&
            ((this.realName==null && other.getRealName()==null) || 
             (this.realName!=null &&
              this.realName.equals(other.getRealName()))) &&
            this.regionID == other.getRegionID() &&
            ((this.telephone==null && other.getTelephone()==null) || 
             (this.telephone!=null &&
              this.telephone.equals(other.getTelephone()))) &&
            this.userID == other.getUserID() &&
            this.valid == other.isValid() &&
            ((this.zip==null && other.getZip()==null) || 
             (this.zip!=null &&
              this.zip.equals(other.getZip())));
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
        if (getCACertCategory() != null) {
            _hashCode += getCACertCategory().hashCode();
        }
        _hashCode += getCACertState();
        if (getCACertType() != null) {
            _hashCode += getCACertType().hashCode();
        }
        if (getAddress() != null) {
            _hashCode += getAddress().hashCode();
        }
        _hashCode += (isAsSysManager() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getCertCode() != null) {
            _hashCode += getCertCode().hashCode();
        }
        if (getCertType() != null) {
            _hashCode += getCertType().hashCode();
        }
        if (getCity() != null) {
            _hashCode += getCity().hashCode();
        }
        if (getCountry() != null) {
            _hashCode += getCountry().hashCode();
        }
        if (getCreatedTime() != null) {
            _hashCode += getCreatedTime().hashCode();
        }
        if (getCreator() != null) {
            _hashCode += getCreator().hashCode();
        }
        _hashCode += getDefaultAppID();
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getDisplayName() != null) {
            _hashCode += getDisplayName().hashCode();
        }
        if (getEmail() != null) {
            _hashCode += getEmail().hashCode();
        }
        if (getFax() != null) {
            _hashCode += getFax().hashCode();
        }
        if (getLoginName() != null) {
            _hashCode += getLoginName().hashCode();
        }
        _hashCode += getLoginType();
        if (getMobile() != null) {
            _hashCode += getMobile().hashCode();
        }
        if (getModifiedTime() != null) {
            _hashCode += getModifiedTime().hashCode();
        }
        if (getModifier() != null) {
            _hashCode += getModifier().hashCode();
        }
        if (getOrgName() != null) {
            _hashCode += getOrgName().hashCode();
        }
        if (getPassword() != null) {
            _hashCode += getPassword().hashCode();
        }
        _hashCode += getPortalTemplateID();
        if (getPortraitPhoto() != null) {
            _hashCode += getPortraitPhoto().hashCode();
        }
        if (getProvince() != null) {
            _hashCode += getProvince().hashCode();
        }
        if (getPwdSeq() != null) {
            _hashCode += getPwdSeq().hashCode();
        }
        if (getRealName() != null) {
            _hashCode += getRealName().hashCode();
        }
        _hashCode += getRegionID();
        if (getTelephone() != null) {
            _hashCode += getTelephone().hashCode();
        }
        _hashCode += getUserID();
        _hashCode += (isValid() ? Boolean.TRUE : Boolean.FALSE).hashCode();
        if (getZip() != null) {
            _hashCode += getZip().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(UserVO.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("urn:BeanService", "UserVO"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CACertCategory");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CACertCategory"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CACertState");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CACertState"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "short"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("CACertType");
        elemField.setXmlName(new javax.xml.namespace.QName("", "CACertType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("address");
        elemField.setXmlName(new javax.xml.namespace.QName("", "address"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("asSysManager");
        elemField.setXmlName(new javax.xml.namespace.QName("", "asSysManager"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("certCode");
        elemField.setXmlName(new javax.xml.namespace.QName("", "certCode"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("certType");
        elemField.setXmlName(new javax.xml.namespace.QName("", "certType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("city");
        elemField.setXmlName(new javax.xml.namespace.QName("", "city"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("country");
        elemField.setXmlName(new javax.xml.namespace.QName("", "country"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("createdTime");
        elemField.setXmlName(new javax.xml.namespace.QName("", "createdTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("creator");
        elemField.setXmlName(new javax.xml.namespace.QName("", "creator"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("defaultAppID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "defaultAppID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("displayName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "displayName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("email");
        elemField.setXmlName(new javax.xml.namespace.QName("", "email"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fax");
        elemField.setXmlName(new javax.xml.namespace.QName("", "fax"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("loginName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "loginName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("loginType");
        elemField.setXmlName(new javax.xml.namespace.QName("", "loginType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "short"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mobile");
        elemField.setXmlName(new javax.xml.namespace.QName("", "mobile"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modifiedTime");
        elemField.setXmlName(new javax.xml.namespace.QName("", "modifiedTime"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "dateTime"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("modifier");
        elemField.setXmlName(new javax.xml.namespace.QName("", "modifier"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("orgName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "orgName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("password");
        elemField.setXmlName(new javax.xml.namespace.QName("", "password"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("portalTemplateID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "portalTemplateID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("portraitPhoto");
        elemField.setXmlName(new javax.xml.namespace.QName("", "portraitPhoto"));
        elemField.setXmlType(new javax.xml.namespace.QName("urn:BeanService", "ByteArray"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("province");
        elemField.setXmlName(new javax.xml.namespace.QName("", "province"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("pwdSeq");
        elemField.setXmlName(new javax.xml.namespace.QName("", "pwdSeq"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("realName");
        elemField.setXmlName(new javax.xml.namespace.QName("", "realName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("regionID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "regionID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("telephone");
        elemField.setXmlName(new javax.xml.namespace.QName("", "telephone"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://schemas.xmlsoap.org/soap/encoding/", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("userID");
        elemField.setXmlName(new javax.xml.namespace.QName("", "userID"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("valid");
        elemField.setXmlName(new javax.xml.namespace.QName("", "valid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("zip");
        elemField.setXmlName(new javax.xml.namespace.QName("", "zip"));
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
