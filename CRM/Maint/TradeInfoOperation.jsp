<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String lowamount = Util.fromScreen(request.getParameter("lowamount"),user.getLanguage());
String highamount = Util.fromScreen(request.getParameter("highamount"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_TradeInfo_Insert",name+flag+lowamount+flag+highamount);

	TradeInfoComInfo.removeTradeInfoCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_TradeInfo_Update",id+flag+name+flag+lowamount+flag+highamount);

	TradeInfoComInfo.removeTradeInfoCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_TradeInfo_Delete",id);

	TradeInfoComInfo.removeTradeInfoCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListTradeInfo.jsp");
%>