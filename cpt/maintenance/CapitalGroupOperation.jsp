<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CapitalGroupComInfo" class="weaver.cpt.maintenance.CapitalGroupComInfo" scope="page" />
<%
char separator = Util.getSeparator() ;

String operation = Util.null2String(request.getParameter("operation"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String parentid = Util.null2String(request.getParameter("parentid"));

if (parentid.equals("")){
	parentid = "0";
}

if (operation.equals("add"))
{
	RecordSet.executeProc("CptCapitalGroup_Insert",name+separator+description+separator+parentid);

	CapitalGroupComInfo.removeCapitalGroupCache();
}
else if (operation.equals("edit"))
{
	RecordSet.executeProc("CptCapitalGroup_Update",id+separator+name+separator+description+separator+parentid);

	CapitalGroupComInfo.removeCapitalGroupCache();
}
else if (operation.equals("delete"))
{
	RecordSet.executeProc("CptCapitalGroup_Delete",id);
	RecordSet.next();
int returnval = RecordSet.getInt(1);
	if(returnval==-1){
		response.sendRedirect("CptCapitalGroupEdit.jsp?id="+id+"&msgid=20");
		return ;
	}

	CapitalGroupComInfo.removeCapitalGroupCache();
}

response.sendRedirect("/cpt/maintenance/CptCapitalGroup.jsp?parentid="+parentid);
%>