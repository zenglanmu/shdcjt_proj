<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17630,user.getLanguage());
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarTypeOperation.jsp">
<input type="hidden" name=operation value=add>

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")'>
    <SPAN id=nameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=60 name="description"></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('usefee','usefeespan')">
    <SPAN id=usefeespan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
</form>
 </TBODY></TABLE>
			
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

<script language="javascript">
function onSubmit()
{
    if(check_form($GetEle("frmmain"),'name,usefee')){
	    $GetEle("frmmain").submit();
    }
}
</script>
</BODY></HTML>
