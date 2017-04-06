<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script>
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='delete';
	document.weaver.submit();
	}
}
</script>
</head>
<jsp:useBean id="MailMouldManager" class="weaver.docs.mail.MailMouldManager" scope="page" />
<%

int messageid = Util.getIntValue(request.getParameter("messageid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
	MailMouldManager.setId(id);
	MailMouldManager.getMailMouldInfoById();
	String mouldname=MailMouldManager.getMailMouldName();
	String mouldtext=MailMouldManager.getMailMouldText();
	MailMouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+":"+mouldname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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
<%
if(HrmUserVarify.checkUserRight("DocMailMouldEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/docs/mail/DocMouldEdit.jsp?id="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMailMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/docs/mail/DocMouldAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMailMouldEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMailMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere=where operateitem=57 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

</DIV>
<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<br>
<TABLE class=ViewForm>
<TBODY>
<TR class=Spacing><TD aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</TD></TR>
<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
<td width=85% class=field>
<%=mouldname%>
</td>
</tr>
<TR style="height: 1px"><TD class=Line colSpan=2></TD></TR>
</tbody>
</table>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=mouldname value="<%=mouldname%>">
</FORM>


<TABLE class=ListStyle cellspacing=1>
<TBODY>
<TR class=header>
<TD>
<%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%>
</TD>
</TR>
<TR class=dataLight>
<TD>
<%=mouldtext%></TD>
</TR>
</TBODY>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>
</html>