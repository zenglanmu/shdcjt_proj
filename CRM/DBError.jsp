<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
String type = request.getParameter("type");
%>
<HTML>
<HEAD>
<TITLE><%=SystemEnv.getHtmlLabelName(15119,user.getLanguage())%></TITLE>
</HEAD>
<BODY>
<p>Database <%=type%> Error!</p>
</BODY>
</HTML> 
