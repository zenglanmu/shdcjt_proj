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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(2250,user.getLanguage());
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
<FORM id=weaver name="weaver" action="/CRM/sellchance/CRMStatusOperation.jsp" method=post onsubmit='return check_form(this,"type,desc")'>
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnSave accessKey=S id=mysave  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
    
</DIV>
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
	<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
	<TD class=Field><INPUT text class=InputStyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")'><SPAN id=typeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
	<TD class=Field><INPUT text class=InputStyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")'><SPAN id=descimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY>
</HTML>
