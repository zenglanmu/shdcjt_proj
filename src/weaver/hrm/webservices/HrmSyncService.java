package weaver.hrm.webservices;

public interface HrmSyncService {
	
	/**
	 * 该接口返回json字符串数据。格式为：{“code”,” description”}
	 * 例如：{“0”,”用户、组织、岗位同步成功”}
	 * {“1”,”**用户同步出错，组织、岗位同步成功”}
	 * @param 参数：appID   appID为应用系统代码，由南康公司确定后，告知应用系统开发商。
	 * @return
	 * 
	 */
	public String userSync(String appID);
}
