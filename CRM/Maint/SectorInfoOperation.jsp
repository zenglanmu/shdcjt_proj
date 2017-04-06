<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String parentid = Util.null2String(request.getParameter("parentid"));
String sectors = "";
if(parentid.equals("")||parentid.equals("0"))
	;
else
{
	RecordSet.executeProc("CRM_SectorInfo_SelectByID",parentid);
	RecordSet.first();
	if(RecordSet.getString("sectors").equals(""))
		sectors = ",";
	else
		sectors = RecordSet.getString("sectors");
	sectors += RecordSet.getString("id") +",";
}

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_SectorInfo_Insert",name+flag+desc+flag+parentid+flag+"0"+flag+sectors);

	SectorInfoComInfo.removeSectorInfoCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_SectorInfo_Update",id+flag+name+flag+desc+flag+parentid+flag+"0"+flag+sectors);

	SectorInfoComInfo.removeSectorInfoCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_SectorInfo_Delete",id);

	// added by lupeng 2004-08-07 for TD761. //Modified by xwj on 2005-03-19 for td1548
	if (RecordSet.next()) {
		if (RecordSet.getInt(1) == -1) {
			response.sendRedirect("/CRM/Maint/EditSectorInfo.jsp?id=" + id + "&msgid=50");
			return;
		}
		if (RecordSet.getInt(1) == -2) {
			response.sendRedirect("/CRM/Maint/EditSectorInfo.jsp?id=" + id + "&msgid=49");
			return;
		}
	}
	// end.

	SectorInfoComInfo.removeSectorInfoCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListSectorInfo.jsp?parentid="+parentid);
%>