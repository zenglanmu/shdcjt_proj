<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<% if(!HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(15244,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
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

	<FORM name="weaver" action="/CRM/sellchance/CRMTimespanOperation.jsp" method=post>
	 <input type="hidden" name="method" value="add">
	<TABLE class=ViewForm>
	
	<TBODY>
	<TR>

	<TD vAlign=top>
	
	<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="30%">
	<COL width="70%">
	<TBODY>
	<TR class=Title>
	<TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
	</TR>
	 <TR class=Spacing style='height:1px'>
	<TD class=Line1 colSpan=2></TD></TR>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(15237,user.getLanguage())%></TD>
	<TD class=Field><INPUT text class=InputStyle maxLength=50 size=20 name="time" onBlur='checkcount1(this);checkinput("time","timeimage")' onKeyPress="ItemCount_KeyPress()" ><SPAN id=timeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(15238,user.getLanguage())%></TD>
	<TD class=Field><INPUT text class=InputStyle maxLength=50 size=20 name="spannum" onBlur='checkcount1(this);checkinput("spannum","spannumimage")' onKeyPress="ItemCount_KeyPress()" ><SPAN id=spannumimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>      

</TBODY>
</TABLE>
</FORM>
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

<SCRIPT language="JavaScript">
function doSave() {
	if (check_form(document.weaver, "time,spannum"))
		document.weaver.submit();
}
</SCRIPT>
</BODY>
</HTML>