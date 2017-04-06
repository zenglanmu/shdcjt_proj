<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmJobActivitiesAdd:Add", user)){
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

<FORM id=weaver name=frmMain action="JobActivitiesOperation.jsp" method=post >

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="30%">
  <COL width=24>
  <COL width="65%">
  <TBODY>
  <TR class=HEADER>
      <TH align=left><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
      </TH>
  </TR>
  <TR class=Spacing style="height:2px">
    <TD class=line1></TD>    
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
        <TBODY>
       <TR>
      <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
   <TD class=Field><INPUT class=inputstyle type=text  name="jobactivitymark" onchange='checkinput("jobactivitymark","jobactivitymarkimage")'>
          <SPAN id=jobactivitymarkimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
     </tr>   
     <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD class=Field>
    <input class=inputstyle name="jobactivityname" onchange='checkinput("jobactivityname","jobactivitynameimage")'>
    <SPAN id=jobactivitynameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
  </tr>   
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>    
  <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15854,user.getLanguage())%></TD>
        <TD class=FIELD colSpan=3>

        <INPUT class="wuiBrowser" id=jobgroupid type=hidden name=jobgroupid
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp"
		_required="yes">
        </TD>
  </TR>         
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
<!--  
  <TR>
    <TD>工作级别、从</TD>
    <TD class=Field>
    <input type=text  name="joblevelfrom" >    
  </tr>   
  <TR>
    <TD>工作级别、到</TD>
    <TD class=Field>
    <input type=text  name="joblevelto" >    
  </tr>   
-->           
</TBODY>
</TABLE>    
 <input class=inputstyle type="hidden" name=operation value=add>
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
if(check_form(frmMain,'jobactivitymark,jobactivityname,jobgroupid')){
 frmMain.submit();
}
}
</script>

 <script language=vbs>
 sub onShowJobGroup()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobgroups/JobGroupsBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	jobgroupspan.innerHtml = id(1)
	frmMain.jobgroupid.value=id(0)
	else
	jobgroupspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.jobgroupid.value=""
	end if
	end if
end sub
</script>
</BODY></HTML>
