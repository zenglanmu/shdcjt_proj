package weaver.hrm.webservices;

import java.util.Calendar;

import weaver.conn.RecordSet;
import weaver.conn.RecordSetDataSource;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.hrm.company.DepartmentComInfo;
import weaver.hrm.company.SubCompanyComInfo;
import weaver.hrm.job.JobTitlesComInfo;
 

public class HrmSyncServiceImpl extends BaseBean implements HrmSyncService {
	private BaseBean log = new BaseBean();
 
	public String userSync(String appID){
		String returnStr = "";
		String type="";
		String subComInfo = SynSubCompany(); //同步分部
		String deptInfo = SynDept();       //同步部门
		String jobTitleInfo = SynJobTitles();  //同步岗位
		String hrmInfo = synHrmResource(appID);//同步人员
		if(subComInfo.indexOf("失败")>0||deptInfo.indexOf("失败")>0||jobTitleInfo.indexOf("失败")>0||hrmInfo.indexOf("失败")>0){
			type="1";
		}else{
			type="0";
		}
		returnStr = "{\""+type+"\",\""+subComInfo+","+deptInfo+","+jobTitleInfo+","+hrmInfo+"\"}";
		return returnStr;
	}
	
	public String SynSubCompany() {
		String returnStr = "";
			RecordSet rs = new RecordSet();
			RecordSet rs1 = new RecordSet();
			RecordSet synrs = new RecordSet();
			RecordSetDataSource hrrs = new RecordSetDataSource("hr");
			String synts = "";
			synrs.executeSql("select * from hrm_ncsynts where id=1");
	        if (synrs.next()) {
	            synts = Util.null2String(synrs.getString("synts"));
	            if (synts.length() <= 0) {
	                  synts = "2000-01-01 00:00:00";
	            }
	        }
			String sql = "select id,companyid,subcompanyname,subcompanydesc,status,modifydate from HrmSubCompany where modifydate >= to_date('" + synts + "','yyyy-mm-dd HH24:mi:ss') order by modifydate desc";
			hrrs.executeSql(sql); 
		    while(hrrs.next()){
		    	
		    	String code = Util.null2String(hrrs.getString("id"));
				String shortname = Util.null2String(hrrs.getString("subcompanyname"));
				String fullname = Util.null2String(hrrs.getString("subcompanydesc"));
				try {
				String parent_code = Util.null2String(hrrs.getString("companyid"));
				String supsubcomid = "0";				
				rs.executeSql("select id from HrmSubCompany where hrpkcode = '"+code+"'");
				if(!rs.next()) {  //不存在就新增
                     //获取上级分部ID
					rs1.executeSql("select id from HrmSubCompany where hrpkcode = '"+parent_code+"'");
					if(rs1.next()) {
						supsubcomid = Util.null2String(rs1.getString("id"));
					}
					
					//插入分部								
					sql = "insert into hrmsubcompany(subcompanyname,subcompanydesc,companyid,supsubcomid,hrpkcode) " +
	    			"values ('"+shortname+"','"+fullname+"',1,"+supsubcomid+",'"+code+"')";				
					rs1.executeSql(sql);
					
					//插入左侧菜单和主菜单
					int id=0;
					rs1.executeSql("select id from HrmSubCompany where hrpkcode = '"+code+"'");
					if(rs1.next()) {
						id = rs1.getInt(1);					
						rs1.executeSql("insert into leftmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex," + id + ",2,locked,lockedbyid,usecustomname,customname,customname_e from leftmenuconfig where resourcetype=1  and resourceid=1");
						rs1.executeSql("insert into mainmenuconfig (userid,infoid,visible,viewindex,resourceid,resourcetype,locked,lockedbyid,usecustomname,customname,customname_e)  select  distinct  userid,infoid,visible,viewindex," + id + ",2,locked,lockedbyid,usecustomname,customname,customname_e from mainmenuconfig where resourcetype=1  and resourceid=1");
				    }
					log.writeLog("新增分部成功,"+sql);
				}			
				} catch(Exception e) {
					log.writeLog("同步分部失败,"+e);
					returnStr += "新增分部"+code+shortname+"失败";
				}	
			}	
		    
		    //更新组织节点的上下级关系
            hrrs.beforFirst();
            while (hrrs.next()) {
            	String code = Util.null2String(hrrs.getString("id"));
				String shortname = Util.null2String(hrrs.getString("subcompanyname"));
				String fullname = Util.null2String(hrrs.getString("subcompanydesc"));
				String parent_code = Util.null2String(hrrs.getString("companyid"));
				synts = Util.null2String(hrrs.getString("modifydate"));
				int canceled = Util.getIntValue(hrrs.getString("status"), 0);
				int supsubcomid = 0;
				if(canceled==0) {   //封存
					delSubCompany(code,shortname);
				} else {
					//获取上级分部ID
					rs.executeSql("select id from HrmSubCompany where hrpkcode = '"+parent_code+"'");
					if(rs.next()) {
						supsubcomid = rs.getInt("id");
					}						
					//更新分部信息
					sql = "update HrmSubCompany set subcompanyname='"+shortname+"',subcompanydesc='"+fullname+"',supsubcomid='"+supsubcomid+"',canceled='0' where hrpkcode='" + code + "'";
					rs.executeSql(sql);					
					log.writeLog("编辑分部成功,"+sql);
				}
            }
            
            if (hrrs.getCounts() > 0) {
 				try {
 					SubCompanyComInfo scci = new SubCompanyComInfo();
 					scci.removeCompanyCache();
 				} catch (Exception e) {
 					e.printStackTrace();
 				}
 				synrs.executeSql("update hrm_ncsynts set synts='" + synts + "' where id=1");
 			}  
            if("".equals(returnStr)){
            	returnStr = "同步分部成功";
            }
		return returnStr;
	}
	
	/**
	 * 封存或解封分部
	 * @param orgXmlBean
	 * @return
	 */
	public void delSubCompany(String code,String shortname) {
		try {
			RecordSet rs = new RecordSet();
			String sql = "";		
			sql = "select count(id) from hrmdepartment where EXISTS (select 1 from hrmsubcompany b where hrmdepartment.subcompanyid1=b.id and b.hrpkcode='" + code + "') and (canceled='0' or canceled is null)";
            rs.executeSql(sql);
            int rows = 0;
            while (rs.next()) {
                rows += Util.getIntValue(rs.getString(1), 0);
            }
            if (rows > 0) {
            	log.writeLog("封存分部失败，该分部下有正常的部门，分部名称："+shortname);
            } else {
                sql = "update HrmSubCompany set canceled='1' where hrpkcode='"+code+"'";
                rs.executeSql(sql);          
                log.writeLog("封存分部成功,"+sql);
            }				
		} catch (Exception e) {
			log.writeLog("封存分部失败,"+e);
		}
	}
	
	public String SynDept() {
		String returnStr = "";
		
			RecordSet rs = new RecordSet();
			RecordSet rs1 = new RecordSet();
			RecordSet synrs = new RecordSet();
			RecordSetDataSource hrrs = new RecordSetDataSource("hr");
			String synts = "";
			synrs.executeSql("select * from hrm_ncsynts where id=2");
	        if (synrs.next()) {
	            synts = Util.null2String(synrs.getString("synts"));
	            if (synts.length() <= 0) {
	                  synts = "2000-01-01 00:00:00";
	            }
	        }
			String sql = "select id,supdepid,subcompanyid1,departmentname,status,modifydate from HrmDepartment where modifydate >= to_date('" + synts + "','yyyy-mm-dd HH24:mi:ss') order by modifydate desc";
			hrrs.executeSql(sql); 
		    while(hrrs.next()){
		    	String code = Util.null2String(hrrs.getString("id"));
				String shortname = Util.null2String(hrrs.getString("departmentname"));
				String fullname = Util.null2String(hrrs.getString("departmentname"));
				String parent_code = Util.null2String(hrrs.getString("supdepid"));
				String org_code = Util.null2String(hrrs.getString("subcompanyid1"));
				try {
				int subcomid = 0;
				int supdeptid = 0;				
				rs.executeSql("select id from hrmdepartment where hrpkcode = '"+code+"'");
				if(!rs.next()) {  //不存在就新增
					//获取分部ID
					rs1.executeSql("select id from HrmSubCompany where hrpkcode = '"+org_code+"'");
					if(rs1.next()) {
						subcomid = Util.getIntValue(rs1.getString("id"),0);
					}
					
					//获取上级部门ID
					rs1.executeSql("select id from hrmdepartment where hrpkcode = '"+parent_code+"'");
					if(rs1.next()) {
						supdeptid = Util.getIntValue(rs1.getString("id"),0);
					}
					
					//插入部门
					sql = "insert into hrmdepartment(departmentname,departmentmark,subcompanyid1,supdepid,hrpkcode) " +
	    			"values ('"+shortname+"','"+fullname+"',"+subcomid+","+supdeptid+",'"+code+"')";				
					rs1.executeSql(sql);
						
					log.writeLog("新增部门成功,"+sql);
				} 
				} catch (Exception e) {
					log.writeLog("同步部门失败,"+e);
					returnStr += "同步部门"+code+shortname+"失败";
				}
			}
		    
		  //更新组织节点的上下级关系
            hrrs.beforFirst();
            while (hrrs.next()) {
            	String code = Util.null2String(hrrs.getString("id"));
				String shortname = Util.null2String(hrrs.getString("departmentname"));
				String fullname = Util.null2String(hrrs.getString("departmentname"));
				String parent_code = Util.null2String(hrrs.getString("supdepid"));
				String org_code = Util.null2String(hrrs.getString("subcompanyid1"));
				String canceled = Util.null2String(hrrs.getString("status"));
				synts = Util.null2String(hrrs.getString("modifydate"));
				int subcomid = 0;
				int supdeptid = 0;	
				if("0".equals(canceled)) {   //封存
					delDepartment(code,shortname);
				} else {
					//获取分部ID
					rs1.executeSql("select id from HrmSubCompany where hrpkcode = '"+org_code+"'");
					if(rs1.next()) {
						subcomid = Util.getIntValue(rs1.getString("id"),0);
					}
					
					//获取上级部门ID
					rs1.executeSql("select id from hrmdepartment where hrpkcode = '"+parent_code+"'");
					if(rs1.next()) {
						supdeptid = Util.getIntValue(rs1.getString("id"),0);
					}
					
					log.writeLog("subcomid:"+subcomid+",pkcode:"+code+",supdepid:"+supdeptid);				 
					sql = "update hrmdepartment set subcompanyid1="+subcomid+", departmentname='"+shortname+"',departmentmark='"+fullname+"',supdepid=" + supdeptid + ",canceled='0' where hrpkcode='" + code + "'";
					rs1.executeSql(sql);
					log.writeLog("更新OA部门的sql:"+sql);
				}
            }
            
            if (hrrs.getCounts() > 0) {
                try {
                    DepartmentComInfo dci = new DepartmentComInfo();
                    dci.removeCompanyCache();
                } catch (Exception e) {
                    e.printStackTrace();
                }
                rs.executeSql("update hrm_ncsynts set synts='" + synts + "' where id=2");
            }
            if("".equals(returnStr)){
            	returnStr = "同步部门成功";
            }
		return returnStr;
	}
	
	/**
	 * 封存部门
	 * @param ipaddress
	 * @param orgXmlBean
	 * @return
	 */
	public void delDepartment(String code,String shortname) {
		try {
			RecordSet rs = new RecordSet();
			String sql = "";
			int id = 0;
			rs.executeSql("select id from hrmdepartment where hrpkcode='"+code+"'");
			if(rs.next()) id = Util.getIntValue(rs.getString(1), 0);			
			sql = "select id from hrmresource where status in (0,1,2,3) and EXISTS (select 1 from hrmdepartment b where hrmresource.departmentid=b.id and b.id = "+id+ ") union select id from hrmdepartment where (canceled = '0' or canceled is null) and id in (select id from hrmdepartment where supdepid ="+id+")";
            rs.executeSql(sql);
            int rows = 0;
            while (rs.next()) {
                rows += Util.getIntValue(rs.getString(1), 0);
            }
            if (rows > 0) {
            	log.writeLog("封存部门失败，该部门下有正常的人员，部门名称："+shortname);
            } else {
                sql = "update hrmdepartment set canceled='1' where hrpkcode='"+code+"'";
                rs.executeSql(sql);              
                log.writeLog("封存部门成功!"+sql);
            }					
		} catch (Exception e) {
			log.writeLog("封存部门失败,"+e);
		}
	}
	
	 /**
     * 同步岗位
     * 返回:同步信息,其中包括:NCPK,PK,Memo,Success(1:插入,2:更新,0:失败)
     * @param SynMsg
     * @return HashMap 同步信息
     */
     public String  SynJobTitles() {
    	 String returnStr = "";

	        RecordSet rs=new RecordSet();
	        String lastts="";
	        String sql="select Synts from hrm_ncsynts where id=3";
	        rs.executeSql(sql);
	        if(rs.next()){
	            lastts= Util.null2String(rs.getString("Synts"));
	        }
	        if (lastts.length() <= 0) return returnStr;
	        RecordSetDataSource hrrs = new RecordSetDataSource("hr");          
	        sql="select \"id\",\"NAME\",departmentid,modifydate,status from HRMJOBTITLES where modifydate >= to_date('" + lastts + "','yyyy-mm-dd HH24:mi:ss') order by modifydate desc";
	        hrrs.executeSql(sql);
	        while(hrrs.next()) {
	            String pk_om_job = Util.null2String(hrrs.getString("id"));
	            String jobname = Util.null2String(hrrs.getString("Name"));
	            String jobremarkname =Util.null2String(hrrs.getString("Name"));
	            String pk_deptdoc = Util.null2String(hrrs.getString("departmentid"));
	            String canceled = Util.null2String(hrrs.getString("status"));
	       	 try {
	            lastts = Util.null2String(hrrs.getString("modifydate"));
	            if(pk_om_job.length()>0) {            	
	                sql="select id from hrmdepartment where hrpkcode='"+pk_deptdoc+"'";
	                rs.executeSql(sql);
	                if(rs.next()) {                   
	                	int deptid = rs.getInt("id");
		                sql="select max(id) id from hrmJobActivities";
		                rs.executeSql(sql);
		                int Activityid=0;
		                if(rs.next()){
		                    Activityid=rs.getInt("id");
		                }
	                    
	                    sql="select id from hrmjobtitles where hrpkcode='"+pk_om_job+"'";
	                    rs.executeSql(sql);
	                    if(rs.next()) {
	                    	if("0".equals(canceled)) {   //封存
	                    		delJobTitle(pk_om_job,jobname);
	        				}
	                        sql="update hrmjobtitles set jobtitlename='"+jobname+"',jobtitlemark='"+jobremarkname+"',jobdepartmentid="+deptid+" where hrpkcode='"+pk_om_job+"'";
	                        log.writeLog("更新岗位sql："+sql);
	                    } else {
	                        sql="insert into hrmjobtitles(hrpkcode,jobtitlename,jobtitlemark,jobdepartmentid,jobactivityid) values ('"+pk_om_job+"','"+jobname+"','"+jobremarkname+"',"+deptid+","+Activityid+")";
	                        log.writeLog("新增岗位sql："+sql);
	                    }
	                    rs.executeSql(sql);
	                } 
	            }
	    	 } catch(Exception e) {
	   			log.writeLog("同步岗位失败,"+e);
				returnStr += "同步岗位"+pk_om_job+jobname+"失败";
	   		 }	
	        }
	        //更新同步TS
	        if(hrrs.getCounts()>0){
		        try {
		            JobTitlesComInfo jtci=new JobTitlesComInfo();
		            jtci.removeJobTitlesCache();
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		        sql="update hrm_ncsynts set Synts='"+lastts+"' where id=3";
		        rs.executeSql(sql);      
	        }
            if("".equals(returnStr)){
            	returnStr = "同步岗位成功";
            }
    	 return returnStr;
    }
     
     /**
 	 * 删除岗位
 	 * @param 
 	 * @return
 	 */
 	public void delJobTitle(String jobtitlecode,String jobtitlename) {
 		try {
 			RecordSet rs=new RecordSet();
 			int id = 0;
            rs.executeSql("select id from hrmjobtitles where hrpkcode='"+jobtitlecode+"'");
            if(rs.next()) id = Util.getIntValue(rs.getString("id"), 0);  
            if(id > 0) {
             	rs.executeSql("select count(id) from HrmResource where jobtitle="+id);
             	if(rs.getInt(1) > 0){
             		log.writeLog("此岗位已经被使用,不能删除!"); 
             	} else {
             		rs.executeSql("delete from hrmjobtitles where hrpkcode='"+jobtitlecode+"'");                  
                    log.writeLog("删除岗位成功!");
             	}
             } else {
               log.writeLog(jobtitlename + "岗位不存在!");
             }
 		} catch(Exception e) {
 			log.writeLog("删除岗位失败,"+e);
 		}		
 	}
 	
 	/**
     * 获得同步的部门id
     *
     * @param ncpkcode
     * @return
     */
    public String getSynDeptId(String hrpkcode) {
        RecordSet rs = new RecordSet();
        String Syndeptid = "";
        rs.executeSql("select id from hrmdepartment where hrpkcode='" + hrpkcode + "'");
        if (rs.next()) {
            Syndeptid = rs.getString("id");
        }
        return Syndeptid;
    }
 	
 	public String synHrmResource(String appID) {
 		String returnStr = "";
 		RecordSet rs = new RecordSet();
        RecordSet rs1 = new RecordSet();
        RecordSetDataSource hrrs = new RecordSetDataSource("hr");
        char separator = Util.getSeparator();
        Calendar todaycal = Calendar.getInstance();
        String today = Util.add0(todaycal.get(Calendar.YEAR), 4) + "-" +
                Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) + "-" +
                Util.add0(todaycal.get(Calendar.DAY_OF_MONTH), 2);
        String userpara = "" + 1 + separator + today;
        String lastts = "";
        DepartmentComInfo dci = null;
        try {
            dci = new DepartmentComInfo();
        } catch (Exception e) {
        }
        String sql = "select Synts from Hrm_NCSynTS where id=4";
        rs.executeSql(sql);
        if (rs.next()) {
            lastts = Util.null2String(rs.getString("Synts"));
            if (lastts.length() <= 0) lastts = "2000-01-01 00:00:00";
        }
        //同步人员
        sql = "select id,loginid,password,lastname,certificatenum,mobile,email,departmentid,jobtitle,modifydate,status,ismain,mhid,belongto,seclevel from HrmResource where appName='"+appID+"' and modifydate >= to_date('" + lastts + "','yyyy-mm-dd HH24:mi:ss') order by modifydate desc,ismain asc ";			 
        hrrs.executeSql(sql);
        while (hrrs.next()) {
        	String pk_psndoc = Util.null2String(hrrs.getString("id"));
            String psnname = Util.null2String(hrrs.getString("lastname"));
            try{
            String pk_deptdoc = Util.null2String(hrrs.getString("departmentid"));
            String pk_om_job = Util.null2String(hrrs.getString("jobtitle"));
			String mobile = Util.null2String(hrrs.getString("mobile"));
			String email = Util.null2String(hrrs.getString("email"));				 
			String certificatenum = Util.null2String(hrrs.getString("certificatenum"));
			String loginid = Util.null2String(hrrs.getString("loginid"));
            lastts = Util.null2String(hrrs.getString("modifydate")); 
			int status =  Util.getIntValue(hrrs.getString("status"),0);
			String password = Util.null2String(hrrs.getString("password"));
			int seclevel = Util.getIntValue(hrrs.getString("seclevel"),0);
			
			String ismain = Util.null2String(hrrs.getString("ismain"));
			String belongto = Util.null2String(hrrs.getString("belongto"));
			//oa 中 accounttype Null、0:主账号 1：次账号        belongto   关联的主账号Hrmreource表id
			//nk 中 Ismain 0代表主帐号  大于0代表子账号      belongto 对应id
			
			int accounttype = 0;
			int oabelongto = -1;
			if("0".equals(ismain)){
				accounttype = 0;
				oabelongto = -1;
			}else{
				accounttype = 1;
				RecordSet rsTemp = new RecordSet();
				rsTemp.executeSql("select id from hrmresource where hrpkcode='"+belongto+"'");
				if(rsTemp.next()){
					oabelongto = rsTemp.getInt("id");
				}
			}
			if(status == 0) status = 5;
			
			String subcompanyid = "";  
            String deptid = "";
            String jobtitlesid = "-1";
            String Errermsg = "";                 
			if (pk_psndoc.length() > 0  && pk_deptdoc.length() > 0) {
				 if(!"".equals(pk_om_job)){
					 sql = "select id from hrmjobtitles where hrpkcode='" + pk_om_job + "'";
					 rs1.executeSql(sql);
					 if (rs1.next()) {
						 jobtitlesid = rs1.getString("id");
					 } else {
						 //同步岗位
						 SynJobTitles();
						 sql = "select id from hrmjobtitles where hrpkcode='" + pk_om_job + "'";
						 rs1.executeSql(sql);
						 if (rs1.next()) {
							jobtitlesid = rs1.getString("id");
						 }
					}
				 } else {
					jobtitlesid = "0";
				 }
				 sql = "select id,subcompanyid1 from hrmdepartment where hrpkcode='" + pk_deptdoc + "'";
				 rs1.executeSql(sql);
				 if (rs1.next()) {
					 deptid = rs1.getString("id");
					 subcompanyid = rs1.getString("subcompanyid1");
				 } else {
					 //同步部门
					 SynDept();
					 deptid = getSynDeptId(pk_deptdoc);
					 if (!deptid.equals("")) subcompanyid = dci.getSubcompanyid1(deptid);
				 }
				 if (subcompanyid.equals("")) {
					 Errermsg = "人员所属分部不正确!";
				 } else if (deptid.equals("")) {
					 Errermsg = "人员所属部门不正确!";
				 }
				 log.writeLog("deptid:"+deptid+",subcompanyid:"+subcompanyid+",pk_psndoc:"+pk_psndoc+",Errermsg:"+Errermsg);
                 if ((!deptid.equals("") && !subcompanyid.equals(""))) {
                    sql = "select id from hrmresource where hrpkcode='" + pk_psndoc + "'";
                    rs1.executeSql(sql);
                    if (rs1.next()) { 
                        int maxid = rs1.getInt("id");
                        if (maxid > 0) {                                
                            sql = "update hrmresource set loginid='"+loginid+"',password='"+ password+"',lastname='"+psnname+"',email='"+email+"',departmentid="+deptid+",subcompanyid1="+subcompanyid+",jobtitle="+jobtitlesid+"," +
                            		"workcode='"+pk_psndoc+"',status="+status+",certificatenum='"+certificatenum+"',mobile='" +mobile +"',seclevel="+seclevel+" "+
                            	    " where id=" + maxid;
                            rs1.executeSql(sql);
                            log.writeLog("更新人员的sql:"+sql);
                            
                            String p_para = "" + maxid + separator + deptid + separator + subcompanyid + separator + -1 + separator + "10" + separator + "" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0";
                            rs1.executeProc("HrmResourceShare", p_para);
						 }
                    } else {                       	 
                        rs1.executeProc("HrmResourceMaxId_Get", "");
                        rs1.next();
                        int maxid = rs1.getInt(1); 
                        if (maxid > 0) {
                            sql = "insert into hrmresource(id,hrpkcode,loginid,password,lastname,email,departmentid,subcompanyid1,jobtitle," +
                                    "systemlanguage,mobile,status,certificatenum,accounttype,belongto,seclevel) values (" +
                                    maxid + ",'"+pk_psndoc+ "','"+loginid+"','"+ password+"','"+psnname+"','"+email+"',"+deptid+","+subcompanyid+","+jobtitlesid+",7,'"+mobile+"',"+status+",'"+certificatenum+"',"+
                                    accounttype+","+oabelongto+","+seclevel+")";
							 rs1.executeSql(sql);  
							 log.writeLog("新增人员的sql:"+sql);
							 
							 String p_para = "" + maxid + separator + deptid + separator + subcompanyid + separator + -1 + separator + "10" + separator + "" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0" + separator + "0";
	                         rs1.executeProc("HrmResourceShare", p_para);
	                         rs1.executeProc("HrmResource_CreateInfo", "" + maxid + separator + userpara + separator + userpara);
	                         String para = "" + maxid + separator + "-1" + separator + deptid + separator + subcompanyid + separator + "10" + separator + "";
	                         rs1.executeProc("HrmResource_Trigger_Insert", para);
	                         String sql_1 = "insert into HrmInfoStatus (itemid,hrmid,status) values(1," + maxid + ",1)";
	                         rs1.executeSql(sql_1);
	                         String sql_2 = "insert into HrmInfoStatus (itemid,hrmid) values (2," + maxid + ")";
	                         rs1.executeSql(sql_2);
	                         String sql_3 = "insert into HrmInfoStatus (itemid,hrmid) values (3," + maxid + ")";
	                         rs1.executeSql(sql_3);
	                         String sql_10 = "insert into HrmInfoStatus (itemid,hrmid) values(10," + maxid + ")";
	                         rs1.executeSql(sql_10);
                        }
                    }                      
                }
            }
			} catch(Exception e) {
				log.writeLog("同步人员失败,"+e);
				returnStr += "同步人员"+pk_psndoc+psnname+"失败";
			}	
        }
        if("".equals(returnStr)){
        	returnStr = "同步人员成功";
        }
        return returnStr;
 	}
}
