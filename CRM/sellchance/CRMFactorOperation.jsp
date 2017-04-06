<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellsuccessComInfo" class="weaver.crm.sellchance.SellsuccessComInfo" scope="page" />
<jsp:useBean id="SellfailureComInfo" class="weaver.crm.sellchance.SellfailureComInfo" scope="page" />
<%
String method = request.getParameter("method");
String sign = request.getParameter("sign");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add")&&sign.equals("s"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Successfactor_Insert",type+flag+desc);
    SellsuccessComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/ListCRMSuccessfactor.jsp");
    
}
if (method.equals("edit")&&sign.equals("s"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Successfactor_Update",id+flag+type+flag+desc); SellsuccessComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/ListCRMSuccessfactor.jsp");
   
}

if (method.equals("delete")&&sign.equals("s"))
{
	RecordSet.executeProc("CRM_Successfactor_Delete",id);
	// added by lupeng 2004-08-08 for TD791.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/sellchance/EditSuccessfactor.jsp?id=" + id + "&msgid=20");
		return;
	}		
	// end.

    SellsuccessComInfo.removeSuccessCache();
    response.sendRedirect("/CRM/sellchance/ListCRMSuccessfactor.jsp");

}


if (method.equals("add")&&sign.equals("f"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Failfactor_Insert",type+flag+desc);
    SellfailureComInfo.removeFailureCache();
    response.sendRedirect("/CRM/sellchance/ListCRMFailfactor.jsp");
    
}

if (method.equals("edit")&&sign.equals("f"))
{
	char flag=2;
	RecordSet.executeProc("CRM_Failfactor_Update",id+flag+type+flag+desc);
    SellfailureComInfo.removeFailureCache();
    response.sendRedirect("/CRM/sellchance/ListCRMFailfactor.jsp");
    
}

if (method.equals("delete")&&sign.equals("f"))
{
	RecordSet.executeProc("CRM_Failfactor_Delete",id);
	// added by lupeng 2004-08-08 for TD794.
	if (RecordSet.next() && RecordSet.getInt(1) == -1) {
		response.sendRedirect("/CRM/sellchance/EditFailfactor.jsp?id=" + id + "&msgid=20");
		return;
	}		
	// end.

    SellfailureComInfo.removeFailureCache();
    response.sendRedirect("/CRM/sellchance/ListCRMFailfactor.jsp");
    
}

%>