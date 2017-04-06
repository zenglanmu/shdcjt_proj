package nk.webservice;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;

public class PlatformUtil extends BaseBean {
	
	/**
	 * 获得南康的webserveice url地址
	 * @return
	 */
	public String getWebserviceUrl(){
		String url = "";
		String fname = "nkwebservice";
		String key = "webservicesurl";
		url = this.getPropValue(fname, key);
		return url;
	}
	
	/**
	 * 根据oa的hrid获得对应的南康的userid
	 * @return
	 */
	public String getUseridByOaId(String hrmid){
		String userId = "0";
		RecordSet rs = new RecordSet();
		rs.executeSql("select userid from oa_hrm where oaid="+hrmid);
		if(rs.next()){
			userId = rs.getString("userid");
		}
		return userId;
	}
	
    /**
     * 根据oa的部门id获得对应的南康的部门id
     * @return
     */
    public String getOrgidByOaDeptId(String deptId){
		String orgId = "0";
		RecordSet rs = new RecordSet();
		rs.executeSql("select orgid from oa_dept where oaid="+deptId);
		if(rs.next()){
			orgId = rs.getString("orgid");
		}
		return orgId;
    }
    
	/**
	 * 获得合同编号
	 * @return
	 */
	public String getHtbh(String wfId){
		String returnVal = "";
		String fname = "docWfConfig";
		String key = wfId+"_htbh";
		returnVal = this.getPropValue(fname, key);
		return returnVal;
	}
	/**
	 * 获得节点处理人
	 * @return
	 */
	public String getJdclr(String wfId){
		String returnVal = "";
		String fname = "docWfConfig";
		String key = wfId+"_jdclr";
		returnVal = this.getPropValue(fname, key);
		return returnVal;
	}
	/**
	 * 获得集团领导审批的节点id
	 * @return
	 */
	public String getNodeid(String wfId){
		String returnVal = "";
		String fname = "docWfConfig";
		String key = wfId+"_nodeid";
		returnVal = this.getPropValue(fname, key);
		return returnVal;
	}
 
	/**
	 * 获得法务正文
	 * @return
	 */
	public String getFwzw(String wfId){
		String returnVal = "";
		String fname = "docWfConfig";
		String key = wfId+"_fwzw";
		returnVal = this.getPropValue(fname, key);
		return returnVal;
	}
}
