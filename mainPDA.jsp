<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>

<%
String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();
session.setAttribute("loginPAD","1");   //从PDA登录
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE class="ViewForm">
<tr><td>当前用户：<%=resourceComInfo.getResourcename(userId)%></td></tr>
<tr><td height="25"></td></tr>
<TR>
<TD valign="top">
		<TABLE class="ListStyle" cellspacing=1>
		<tr><td><a href="/workflow/request/RequestView.jsp"><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></a></td></tr>
		</table>
</TD>
</TR>

</TABLE>


</BODY>
</HTML>