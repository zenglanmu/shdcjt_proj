<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CustomerDesc_Insert",name+flag+desc);
    
    RecordSet.executeSql("Select Max(id) as maxid FROM CRM_CustomerDesc");
      RecordSet.next();

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(RecordSet.getInt("maxid"));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("CustomerDesc_Insert,"+name+flag+desc);
      SysMaintenanceLog.setOperateItem("108");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();


	CustomerDescComInfo.removeCustomerDescCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CustomerDesc_Update",id+flag+name+flag+desc);

    SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("CustomerDesc_Update,"+id+flag+name+flag+desc);
      SysMaintenanceLog.setOperateItem("108");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerDescComInfo.removeCustomerDescCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeSql("Select fullname FROM CRM_CustomerDesc where id ="+id);
	RecordSet.next();
    String descName = RecordSet.getString("fullname"); 

	RecordSet.executeProc("CRM_CustomerDesc_Delete",id);
	// added by lupeng 2004-08-05 for TD776.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/EditCustomerDesc.jsp?id=" + id + "&msgid=37");
		return;
	}		
	// end.

    SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(descName);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CustomerDesc_delete,"+id);
      SysMaintenanceLog.setOperateItem("108");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CustomerDescComInfo.removeCustomerDescCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListCustomerDesc.jsp");
%>