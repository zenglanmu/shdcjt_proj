<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%int message=Util.getIntValue(request.getParameter("message"));
String idname=Util.null2String(request.getParameter("idname"));
String  description=Util.null2String(request.getParameter("description"));
%>

<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(71,user.getLanguage())+ SystemEnv.getHtmlLabelName(2026,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<% 

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form id=weaver name=weaver method=post name=MailUserGroup action="MailUserGroupOperation.jsp" >
 <input type=hidden name=operationType value="Add"> 
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

			<TABLE CLASS=ViewForm>
			<col width='15%'>
			<col width='35%'>
			<col width='15%'>
			<col width='35%'>
			<%if(message==1){%>
			 <tr><font color=red><%=SystemEnv.getHtmlLabelName(2027,user.getLanguage())%></font></tr><%}%>
			<TR class=Title><TD COLSPAN=4><B><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>
			<%=SystemEnv.getHtmlLabelName(2026,user.getLanguage())%></B></TD></TR>
			<TR class=Title><TD COLSPAN=4 class=Line1></TD></TR>
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><TD CLASS=FIELD colspan="3">
					<INPUT TYPE=TEXT class=InputStyle NAME=idname SIZE=15 MAXLENGTH=30 VALUE="<%=idname%>" onChange="checkinput('idname','idnamespan')">
					<span id=idnamespan><IMG src='/images/BacoError.gif' align=absMiddle></span></td>
			</TR>
			<TR><TD class=Line colSpan=4></TD></TR> 
			<TR><TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><TD CLASS=FIELD colspan=3>
			<INPUT TYPE=TEXT class=InputStyle NAME=description SIZE=60 MAXLENGTH=60 VALUE="<%=description%>"  onChange="checkinput('description','descspan')">
			<span id=descspan><IMG src='/images/BacoError.gif' align=absMiddle></span>
			</TD></TR>
			<TR><TD class=Line colSpan=4></TD></TR> 
			</TABLE>

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
<BR>
</BODY>
<script language="javascript">
 function onSubmit()
{
	if (check_form(weaver,"idname,description"))
	weaver.submit();
}
</script>
</HTML>