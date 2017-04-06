<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String money = Util.fromScreen(request.getParameter("money"),user.getLanguage());
String highamount = Util.fromScreen(request.getParameter("highamount"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CreditInfo_Insert",name+flag+money+flag+highamount);

	CreditInfoComInfo.removeCreditInfoCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CreditInfo_Update",id+flag+name+flag+money+flag+highamount);

	CreditInfoComInfo.removeCreditInfoCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_CreditInfo_Delete",id);

	CreditInfoComInfo.removeCreditInfoCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListCreditInfo.jsp");
%>