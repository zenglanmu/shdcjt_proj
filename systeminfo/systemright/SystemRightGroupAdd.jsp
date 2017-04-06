<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("SystemRightGroupAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(492,user.getLanguage());
String needfav ="1";
String needhelp ="1";

//add by zhouquan 
int hasRecord=Util.getIntValue(request.getParameter("hasRecord"));


%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM ID=Baco name=Baco ACTION=SystemRightGroupOperation.jsp METHOD=POST >
<input type=hidden name=operationType value="addgroup">
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
			  <TABLE class="ViewForm">
				<COL width="15%">
				<COL width="85%">
				<%if(hasRecord == 1){
					%>
					<span class=fontred>&nbsp&nbsp<%=SystemEnv.getHtmlLabelName(17567,user.getLanguage())%></span>
				<%
				}
				%>
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%> </TD>
				<TD class="Field">
					<INPUT TYPE=TEXT class=InputStyle NAME=mark SIZE=10 MAXLENGTH=10 onchange='checkinput("mark","markimage")'>
					<SPAN ID=markimage><IMG ALIGN=absmiddle SRC="/images/BacoError.gif"></SPAN></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%> </TD>
					<TD class="Field"><INPUT TYPE=TEXT class=InputStyle NAME=description SIZE=60 MAXLENGTH=255 onchange='checkinput("description","descriptionimage")'><SPAN ID=descriptionimage><IMG ALIGN=absmiddle SRC="/images/BacoError.gif"></SPAN></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<TR>
					<TD VALIGN=TOP><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%> </TD>
					<TD class="Field"><TEXTAREA class=InputStyle NAME=notes ROWS=8 COLS=60></TEXTAREA></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
<script language="javascript">
function doSubmit()
{
	if (check_form(Baco,"mark,description")){
		
	Baco.submit();
		
	}
}
</script>
</BODY>
</HTML>