<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<html>
<HTML><HEAD>
</head>
<%
String msgstr=Util.null2String(request.getParameter("msg"));
if(msgstr.equals("")) msgstr=SystemEnv.getHtmlLabelName(18975,user.getLanguage());
%>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<br>
<font color="red"><b><%=msgstr%></b></font>
</body>
</html>