<%@ page import="weaver.systeminfo.*,weaver.general.Util,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
RecordSet.executeProc("Sys_Slogan_Select","");
RecordSet.next();
%>

<html>

<head>
<title></title>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=GBK">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<base target="MainWindow">
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css">
</head>

<body bgcolor="buttonface" CLASS="mybody" SCROLL="no" >
<table width="100%" border="0" cellpadding="0" height=10 cellspacing="0">
  <tr> 
    <td background="/images/hr.gif"></td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="0" align="center" cellspacing="0">
  <tr>
    <td><FONT style="COLOR: #<%=RecordSet.getString(3)%>; FONT-FAMILY: verdana;FONT-WEIGHT: bold">
<MARQUEE scrollAmount=<%=RecordSet.getString(2)%> scrollDelay=1><%=Util.toScreen(RecordSet.getString(1),user.getLanguage())%></MARQUEE></font>	
	</td>
  </tr>
</table>
<table width="100%" border="0" cellpadding="0" height=10 cellspacing="0">
  <tr>
    <td background="/images/hr.gif"></td>
  </tr>
</table>
</body>

</html>
