<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15519,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>



<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/workflow/report/ReportTypeManage.jsp,_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/ReportTypeManage.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
// }
%><FORM id=weaver name=frmMain action="ReportTypeOperation.jsp" method=post>
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

<TABLE class="viewform">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class="Title">
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></TH>
    </TR>
  <TR class="Spacing" style="height:1px;">
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
        <INPUT type=text size=30 class=Inputstyle name="typename" onchange='checkinput("typename","typenameimage")'>
          <SPAN id=typenameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
        <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text size=60 name="typedesc" class=Inputstyle>
          <SPAN id=provincedescimage></SPAN></TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          
      <TD class=Field>
        <input type=text size=35 class=inputstyle id="typeorder" name="typeorder" maxlength=10 onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);">
      </TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line1" colSpan=2 ></TD></TR>
        <input type="hidden" name=operation value=reporttypeadd>
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

 </form>
 <script language="javascript">
function submitData()
{
	if (check_form(weaver,'typename'))
		weaver.submit();
}
</script>
</BODY></HTML>
