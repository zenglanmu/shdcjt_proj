<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("Prj_ProjectStatus_Insert",type+flag+desc);

	ProjectStatusComInfo.removeProjectStatusCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("Prj_ProjectStatus_Update",id+flag+type+flag+desc);

	ProjectStatusComInfo.removeProjectStatusCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("Prj_ProjectStatus_Delete",id);

	ProjectStatusComInfo.removeProjectStatusCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/proj/Maint/ListProjectStatus.jsp");
%>