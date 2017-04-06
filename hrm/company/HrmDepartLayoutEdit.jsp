
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.org.layout.*" %>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
    if(!HrmUserVarify.checkUserRight("HrmDepartLayoutEdit:Edit", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
	}
	DepLayout dl = DownloadDeptLayoutServlet.readDeptLayout(user.getLanguage(), false);
    dl.buildObjectRef();
    dl.checkAndAutoset(10, 10, 20, 20);
    String serverstr=request.getScheme()+"://"+request.getHeader("Host");
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(15771,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<table border="0" width="75%" height="343">
  <tr> 
  <td valign="top">
        <object classid="clsid:CAFEEFAC-0013-0001-0004-ABCDEFFEDCBA" width=<%=dl.getMaxPos().x+10>1024?dl.getMaxPos().x+10:1024%> height=<%=dl.getMaxPos().y+10>768?dl.getMaxPos().y+40:768%>  codebase="<%=serverstr%>/resource/j2re-1_3_1_04-windows-i586.exe">
            <param name = CODE value = weaver.org.layout.DepLayoutEditor.class >
            <param name = CODEBASE value = /classbean >
            <param name="type" value="application/x-java-applet;jpi-version=1.3.1">
            <param name="scriptable" value="false">
			<param name="MAYSCRIPT" value="true">
            <param name = "downloadUrl" value  ="<%=serverstr%>/weaver/weaver.org.layout.DownloadDeptLayoutServlet"/>
            <param name = "uploadUrl" value  ="<%=serverstr%>/weaver/weaver.org.layout.DownloadDeptLayoutServlet"/>
            <param name = actionRedirectToLogin value = "redirect"/>
        </object>
  </td>
  </tr>
</table>
<%
String loginfile = Util.getCookie(request , "loginfileweaver");
%>
<form name="redirect" method="post" action="/Refresh.jsp?loginfile=<%=loginfile%>&message=19">
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>