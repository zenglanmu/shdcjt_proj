<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage()) 
					+ ":&nbsp;" + SystemEnv.getHtmlLabelName(703,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="CapitalTypeOperation.jsp" method=post >
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
			<TABLE class=ViewForm>
			  <COLGROUP>
			  <COL width="20%">
			  <COL width="80%">
			  <TBODY>
			  <TR class=Title>
				<TH colSpan=2><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></TH></TR>
			  <TR class=Spacing style="height:1px;">
				<TD class=Line1 colSpan=2 ></TD></TR>
			  <TR>
					  <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
					  <TD class=Field><INPUT type=text size=30 name="name" onchange='checkinput("name","nameimage")' class="InputStyle">
					  <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
					</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 	
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
					  <TD class=Field><INPUT type=text size=60 name="description" onchange='checkinput("description","descriptionimage")' class="InputStyle">
					  <SPAN id=descriptionimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
					</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					<TR>
					  <TD><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></TD>
					  <TD class=Field><INPUT type=text size=60 maxlength=100 name="typecode" class="InputStyle">
					  </TD>
					</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
					<input type="hidden" name=operation value=add>
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
 </form> 
<script language="javascript">
function submitData()
{
	if (check_form(document.getElementsByName("frmMain")[0],'name,description'))
		document.getElementsByName("frmMain")[0].submit();
}
function goBack(){
	location.href = "/cpt/maintenance/CptCapitalType.jsp";
}
</script>
</BODY>
</HTML>
