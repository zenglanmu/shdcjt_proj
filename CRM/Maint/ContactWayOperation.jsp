<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_ContactWay_Insert",name+flag+desc);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("CrmContactWay_Add,"+para);
    SysMaintenanceLog.setOperateItem("145");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	ContactWayComInfo.removeContactWayCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_ContactWay_Update",id+flag+name+flag+desc);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("2");
    SysMaintenanceLog.setOperateDesc("CrmContactWay_Update,"+para);
    SysMaintenanceLog.setOperateItem("145");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	ContactWayComInfo.removeContactWayCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_ContactWay_Delete",id);
	int cid=0;
	while(RecordSet.next()){
		cid = RecordSet.getInt(1);
		out.print("id"+id);
	}
	char separator = Util.getSeparator() ;
	String para = name+separator+desc;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(cid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("3");
    SysMaintenanceLog.setOperateDesc("CrmContactWay_Delete,"+para);
    SysMaintenanceLog.setOperateItem("145");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();	
	// added by lupeng 2004-08-05 for TD750.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/Maint/EditContactWay.jsp?id=" + id + "&msgid=20");
		return;
	}
		
	// end.

	ContactWayComInfo.removeContactWayCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListContactWay.jsp");
%>