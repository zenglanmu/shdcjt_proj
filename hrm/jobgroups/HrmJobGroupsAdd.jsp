<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(805,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobGroupsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="JobGroupsOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(805,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=inputstyle type=text name="jobgroupname" onchange='checkinput("jobgroupname","jobgroupmarkimage")'>
          <SPAN id=jobgroupmarkimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
   </TR>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>         
   <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
      <TD class=FIELD>
        <input class=inputstyle type=text name=jobgroupremark >
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <input class=inputstyle type="hidden" name=operation value=add>
 </TBODY></TABLE>
 </form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>
function submitData() {
 if(check_form(frmMain,'jobgroupmark,jobgroupname')){
 frmMain.submit();
    }
}
</script>

</BODY>
</HTML>
