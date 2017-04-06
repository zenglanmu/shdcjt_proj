<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
int applyid = Util.getIntValue(request.getParameter("applyid"),0);
String firstname=Util.null2String(request.getParameter("firstname"));
String lastname=Util.null2String(request.getParameter("lastname"));
String resourceid=Util.null2String(request.getParameter("resourceid"));

String method=Util.null2String(request.getParameter("method"));



char flag=Util.getSeparator();

if(method.equals("delete"))
{   

	RecordSet.executeProc("HrmShare_Delete",""+resourceid+flag+applyid);
response.sendRedirect("HrmShare.jsp?applyid="+applyid+"&firstname="+firstname+"&lastname="+lastname);
	return;
}


if(method.equals("add"))
{

	RecordSet.executeProc("HrmShare_Insert",""+resourceid+flag+applyid);
	response.sendRedirect("HrmShare.jsp?hrmid="+resourceid+"&applyid="+applyid+"&firstname="+firstname+"&lastname="+lastname);
	return;
}
%>