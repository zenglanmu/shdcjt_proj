package ln;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;

import weaver.conn.RecordSet;
import weaver.file.Prop;
import weaver.general.BaseBean;
import weaver.general.Encoder;
import weaver.general.GCONST;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.system.GetPhysicalAddress;

public class LN  extends BaseBean{


	Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String currenttime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

	private String companyname = "";
	private String license="";
	private String licensecode="";
	private String software="";
	private String hrmnum="";
	private String expiredate="";
	private String message="";	//message=0 表示License信息错误;message=1 表示成功;message=2 表示数据库连接或者执行出错;message=3 表示License文件上传出错;
															//message=4 表示License信息错误，License过期;message=5 表示License信息错误，注册用户数大于License申请人数
	private String licensepass="";
	
	private String concurrentFlag="";//控制并发标识
	
    private StaticObj staticobj = null;
    private ArrayList infos = null;
    public LN(){
        staticobj = StaticObj.getInstance();
        OutLicensecode();
    }

    public void setCompanyname(String newValue){
		companyname = newValue.trim();
		}
	public String getCompanyname(){
		return companyname;
	}
	public void setLicense(String newValue){
		license = newValue.trim();
		}
	public String getLicense(){
		return license;
	}
	public void setLicensecode(String newValue){
		licensecode = newValue.trim();
		}
	public String getLicensecode(){
		return licensecode;
	}
	public void setSoftware(String newValue){
		software = newValue.trim();
		}
	public String getSoftware(){
		return software;
	}
	public void setHrmnum(String newValue){
		hrmnum = newValue.trim();
		}
	public String getHrmnum(){
		return hrmnum;
	}
	public void setExpiredate(String newValue){
		expiredate = newValue.trim();
		}
	public String getExpiredate(){
		return expiredate;
	}
	public void setLicensepass(String newValue){
		licensepass = newValue.trim();
		}
	public void setConcurrentFlag(String newValue) {
		concurrentFlag = newValue.trim();
	    }
	public String getConcurrentFlag() {
		return concurrentFlag;
	}

  public String InLicense() {
        RecordSet rs = new RecordSet() ;
		String sql = "update license set companyname='"+companyname+"',software='"+software+"',license='"+license+"',hrmnum="+hrmnum+",expiredate='"+expiredate+"'" ;
		boolean r1 = rs.execute(sql);
		sql = "update HrmCompany set companyname='"+companyname+"'" ;
		boolean r2 = rs.execute(sql);
		if(!r1 || !r2) return "6";//选择的License文件不正确
		message=CkLicense(currentdate);
		return message;
  }

  public void removeLicenseComInfo() {
        staticobj.removeObject("LicenseComInfo");
  }

  public  void ReadFromFile(String licensefilepath) {
        try{
              if (staticobj.getObject("LicenseComInfo") == null){
                  infos=new ArrayList();
                  File fin = new File(licensefilepath);
                  FileInputStream fis = new FileInputStream(fin);
                  int finLength=(int)fin.length();
                  if(finLength>0){
                      byte[] bytIn = new byte[finLength];
                      for(int i = 0;i<fin.length();i++){
                        bytIn[i] = (byte)fis.read();
                      }
                      String temp = Encoder.decrypt(bytIn,licensecode.substring(0,16));
                      temp=temp.substring(0,temp.lastIndexOf("|"));
                      infos=Util.TokenizerString(temp,"|");
                      fis.close();
                      staticobj.putRecordToObj("LicenseComInfo", "infos", infos);
                  }
              }
              else {
                  infos = (ArrayList) (staticobj.getRecordFromObj("LicenseComInfo", "infos"));
              }
              //老的方式处理
              if(infos.size() == 5){
            	  companyname=(String)infos.get(0);
                  license=(String)infos.get(1);
                  software=(String)infos.get(2);
                  hrmnum=(String)infos.get(3);
                  //无限制License的处理
                  // if(Util.getIntValue(hrmnum)==9999) {
                  //	  hrmnum = "999999";
                  //  }
                  expiredate=(String)infos.get(4);
              }
              //新的方式(控制并发)处理
              if(infos.size() == 6){
                  companyname=(String)infos.get(0);                 
                  license=(String)infos.get(1);
                  software=(String)infos.get(2);
                  hrmnum=(String)infos.get(3);
                  expiredate=(String)infos.get(4);
                  concurrentFlag = (String)infos.get(5);        
              }
        }catch(Exception e) {
			  writeLog(e) ;
		}
  }


  public String OutLicensecode() {
	  String codeStr = Util.null2String((String)staticobj.getObject("StaticLicenseCode"));
	  //System.out.println("staticobj licensecode = "+codeStr);
	  if(codeStr.equals("")) {
		  codeStr = MakeLicensecode();
	  }
	  licensecode = codeStr;
	  return licensecode;
  }
  
  public String MakeLicensecode() {
	  GetPhysicalAddress PhysicalAddress = new GetPhysicalAddress() ;
	  licensecode = Util.getEncrypt(PhysicalAddress.getPhysicalAddress());
	  staticobj.putObject("StaticLicenseCode", licensecode);
	  //System.out.println("make licensecode = "+ licensecode);
	  return licensecode;
  }

  public String CkLicense(String currentdate) {
//		String sql = "";
//		String tempcompanyname="";
//		RecordSet rs = new RecordSet() ;
//		sql = "select companyname from license" ;
//		boolean r1 = rs.execute(sql);
//		if(!r1) return "2";//数据库连接出错
//		if(rs.next()){
//				tempcompanyname=rs.getString("companyname").trim();
//		}
//
//		String filename = GCONST.getRootPath()+"license"+File.separatorChar+licensecode+".license";
//        ReadFromFile(filename);
//		if(expiredate.compareTo(currentdate)<0) return "4";//License过期
//		String temphrmnum = hrmnum;
//		//if(Util.getIntValue(hrmnum)>9999) temphrmnum = "9999";
//		String src="";
//		if("1".equals(concurrentFlag)) {
//			src = tempcompanyname+licensecode+software+temphrmnum+expiredate+concurrentFlag;
//		} else {
//			src = tempcompanyname+licensecode+software+temphrmnum+expiredate;
//		}
//		if(!license.equals("") && license.equals(Util.getEncrypt(src))){
//			message="1";//License提交成功
//		}else{
//			message="0";//License信息错误
//		}
//		if(CkHrmnum()>=1) message="5";//注册用户数大于License申请人数
//		return message;
	  return "1";
  }

  public int CkHrmnum() {
//	    int revalue = 0;
//	    int hrmnum01 = 0;
//		int hrmnum02 = 0;
//		String sql = "";
//		RecordSet rs = new RecordSet() ;
//		String filename = GCONST.getRootPath()+"license"+File.separatorChar+licensecode+".license";
//		ReadFromFile(filename);
//		hrmnum01=Util.getIntValue(hrmnum,0);
//        String mode= Prop.getPropValue(GCONST.getConfigFile() , "authentic");
//        if(mode!=null&&mode.equals("ldap")){ //add by xiaofeng, modify for ldap
//           if(rs.getDBType().equals("oracle")){
//			sql = "select count(*) from HrmResource where status in (0,1,2,3) and account is not null" ;
//		   }else{
//			sql = "select count(*) from HrmResource where status in (0,1,2,3) and account is not null and account<>'' " ;
//		   }
//        }else{
//		   if(rs.getDBType().equals("oracle")){
//			sql = "select count(*) from HrmResource where status in (0,1,2,3) and loginid is not null" ;
//		   }else{
//			sql = "select count(*) from HrmResource where status in (0,1,2,3) and loginid is not null and loginid<>'' " ;
//		   }
//        }
//        if ("1".equals(concurrentFlag)) {
//        	revalue = -1;
//        } else {
//            rs.execute(sql);
//    		if(rs.next()) hrmnum02 = rs.getInt(1);
//    		revalue = hrmnum02-hrmnum01;
//        }
//
//		return revalue;
	  return -1;
  }
  //未使用的License
  public int CkUnusedHrmnum() {
	    int hrmnum01 = 0;
		int hrmnum02 = 0;
		String sql = "";
		RecordSet rs = new RecordSet() ;
		String filename = GCONST.getRootPath()+"license"+File.separatorChar+licensecode+".license";
		ReadFromFile(filename);
		hrmnum01=Util.getIntValue(hrmnum,0);
      String mode= Prop.getPropValue(GCONST.getConfigFile() , "authentic");
      if(mode!=null&&mode.equals("ldap")){ //add by xiaofeng, modify for ldap
         if(rs.getDBType().equals("oracle")){
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and account is not null" ;
		   }else{
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and account is not null and account<>'' " ;
		   }
      }else{
		   if(rs.getDBType().equals("oracle")){
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and loginid is not null" ;
		   }else{
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and loginid is not null and loginid<>'' " ;
		   }
      }
      rs.execute(sql);
		if(rs.next()) hrmnum02 = rs.getInt(1);
		return hrmnum01-hrmnum02;
}
  //已使用的License数量
  public int CkUsedHrmnum() {
	    int hrmnum01 = 0;
		int hrmnum02 = 0;
		String sql = "";
		RecordSet rs = new RecordSet() ;
		String filename = GCONST.getRootPath()+"license"+File.separatorChar+licensecode+".license";
		ReadFromFile(filename);
		hrmnum01=Util.getIntValue(hrmnum,0);
    String mode= Prop.getPropValue(GCONST.getConfigFile() , "authentic");
    if(mode!=null&&mode.equals("ldap")){ //add by xiaofeng, modify for ldap
       if(rs.getDBType().equals("oracle")){
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and account is not null" ;
		   }else{
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and account is not null and account<>'' " ;
		   }
    }else{
		   if(rs.getDBType().equals("oracle")){
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and loginid is not null" ;
		   }else{
			sql = "select count(*) from HrmResource where status in (0,1,2,3) and loginid is not null and loginid<>'' " ;
		   }
    }
    rs.execute(sql);
		if(rs.next()) hrmnum02 = rs.getInt(1);
		return hrmnum02;
}


}
