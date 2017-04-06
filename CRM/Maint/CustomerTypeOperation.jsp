<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String workflowid = Util.null2String(request.getParameter("workflowid"));

if (method.equals("add"))
{
	//added by xwj on 2005-03-22 for td1552
	RecordSet.executeSql("select * from CRM_CustomerType where fullname = '" + name + "'");
	if(!RecordSet.next()){
		char flag=2;
	  RecordSet.executeProc("CRM_CustomerType_Insert",name+flag+desc+flag+workflowid);

	   RecordSet.executeSql("Select Max(id) as maxid FROM CRM_CustomerType");
      RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(RecordSet.getInt("maxid"));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("CustomerType_Insert,"+name+flag+desc+flag+workflowid);
      SysMaintenanceLog.setOperateItem("107");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

    CustomerTypeComInfo.removeCustomerTypeCache();
	}
	else{
    response.sendRedirect("/CRM/Maint/AddCustomerType.jsp?msgid=17626");
	}

}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CustomerType_Update",id+flag+name+flag+desc+flag+workflowid);

     SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CustomerType_Update,"+id+flag+name+flag+desc+flag+workflowid);
      SysMaintenanceLog.setOperateItem("107");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();


	CustomerTypeComInfo.removeCustomerTypeCache();
}
else if (method.equals("delete"))
{
    RecordSet.executeSql("Select fullname FROM CRM_CustomerType where id ="+id);
	RecordSet.next();
    String typeName = RecordSet.getString("fullname"); 

	RecordSet.executeProc("CRM_CustomerType_Delete",id);
	// added by lupeng 2004-08-05 for TD771.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/EditCustomerType.jsp?id=" + id + "&msgid=20");
		return;
	}		
	// end.
    
   SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(typeName);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CustomerType_delete,"+id);
      SysMaintenanceLog.setOperateItem("107");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerTypeComInfo.removeCustomerTypeCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListCustomerType.jsp");
%>