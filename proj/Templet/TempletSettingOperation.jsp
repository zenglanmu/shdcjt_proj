<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String chkNeedAppr = Util.null2String(request.getParameter("chkNeedAppr"));
if(chkNeedAppr.equals("")){
	chkNeedAppr = "0";
}
int wfid = Util.getIntValue(request.getParameter("relatingFlow"));
rs.executeSql("UPDATE ProjTemplateMaint SET isNeedAppr='"+chkNeedAppr+"',wfid="+wfid+" WHERE id=1");
response.sendRedirect("/proj/Templet/TempletSetting.jsp");
%>