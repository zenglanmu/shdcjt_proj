<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />

<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_SellStatus_Insert",type+flag+desc);
    SellstatusComInfo.removeSuccessCache();

}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_SellStatus_Update",id+flag+type+flag+desc);
    SellstatusComInfo.removeSuccessCache();

}

else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_SellStatus_Delete",id);
	// added by lupeng 2004-08-05 for TD764.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/sellchance/EditCRMStatus.jsp?id=" + id + "&msgid=20");
		return;
	}		
	// end.
    SellstatusComInfo.removeSuccessCache();

}

response.sendRedirect("/CRM/sellchance/ListCRMStatus.jsp");
%>