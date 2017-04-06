<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />

<html>
<head>
<title>高效源于协同</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<body background="/images_frame/top_bg.gif">
<br>
<table class=form width=100%>
	<tr>
		<td align=center>
			<font size=4 color=#ffffff><b><%=CompanyComInfo.getCompanyname("1")%></b></font>
		</td>
	</tr>
</table>

</body>
</html>
