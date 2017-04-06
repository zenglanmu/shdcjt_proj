<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.systeminfo.sysadmin.*"%>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</head>
<% 
if(!HrmUserVarify.checkUserRight("SysadminRight:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String result = Util.null2String(request.getParameter("result"));
%>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(17870,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String passwordComplexity = settings.getPasswordComplexity();
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name="frmmain" action="/systeminfo/sysadmin/sysadminOperation.jsp" method="post">
<INPUT type="hidden" name="method" value="add">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class="viewform">
		<colgroup>
		<col width="20%">
		<col width="80%">
		<tbody>
        <TR class="Title">
			<TH><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TH>
		</TR>
        <TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(17870,user.getLanguage())%></td>
			<td class=Field><INPUT class=Inputstyle maxLength=60 size=20 name="loginid" value="" onchange='checkinput("loginid","loginidimage")'><SPAN id="loginidimage"><IMG src="/images/BacoError.gif" align="absMiddle"><%if(result.equals("false")){%><div style="color:#FF0000 "><%=SystemEnv.getHtmlNoteName(64,user.getLanguage())%></div><%}%></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(17888,user.getLanguage())%></td>
			<td class=Field><INPUT class=Inputstyle maxLength=20 size=20 name="lastname" value="" onchange='checkinput("lastname","lastnameimage")'><SPAN id="lastnameimage"><IMG src="/images/BacoError.gif" align="absMiddle"></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
        <tr>
			<td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
			<td class=Field><INPUT type="password" class=Inputstyle maxLength=100 size=20 name="password" value="" onchange='checkinput("password","passwordimage")'><SPAN id="passwordimage"><IMG src="/images/BacoError.gif" align="absMiddle"></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
			<td class=Field><INPUT class=Inputstyle maxLength=255 size=60 name="description" value="" onchange='checkinput("description","descriptionimage")'><SPAN id="descriptionimage"><IMG src="/images/BacoError.gif" align="absMiddle"></SPAN></td>
		</tr>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
		</tbody>
	</table>
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
</FORM>
</body>
<SCRIPT language="JavaScript">
function doSave(obj) {	
	if (check_form(frmmain,"loginid,password,description")) {
		var checkpass = CheckPasswordComplexity();
		if(checkpass)
		{
			document.frmmain.submit();	
		}
	}
}
function CheckPasswordComplexity()
{
	var ins = document.getElementById("password");
	var cs = "";
	if(ins)
	{
		cs = ins.value;
	}
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!="")
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("新密码不符合要求，必须为字母大写、字母小写、数字组合！请重新输入！");
			ins.value = "";
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!="")
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("新密码不符合要求，必须为字母、数字、特殊字符组合！请重新输入！");
			ins.value = "";
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
</SCRIPT>
</html>