<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />

<% if(!HrmUserVarify.checkUserRight("AddProjMember:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String projname = Util.toScreen(ProjectInfoComInfo.getProjectInfoname(ProjID),user.getLanguage());

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(431,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+Util.toScreen(projname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver action="ProjMemberOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="projid" value="<%=ProjID%>">
<input type="hidden" name="ismanager" value="0">


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

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser id=SelectManagerID onClick="onShowPrjManagerID()"></BUTTON> <span 
            id=PrjManagerspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
              <INPUT class=inputstyle type=hidden name="resourceid"></TD>
        </TR>  <TR class=spacing>
          <TD class=line colSpan=2></TD></TR>
           <TR>
<TR>
          <TD><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Calendar onclick="getBDateP()"></BUTTON> 
              <SPAN id=BDatePspan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
              <input type="hidden" name="begindate" id="BDateP">-<BUTTON class=Calendar onclick="getEDateP()"></BUTTON> 
              <SPAN id=EDatePspan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
              <input type="hidden" name="enddate" id="EDateP"></TD>
        </TR>  <TR class=spacing>
          <TD class=line1 colSpan=2></TD></TR>
           <TR>
        
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
<script language=vbs>
sub onShowPrjManagerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	PrjManagerspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.resourceid.value=id(0)
	else 
	PrjManagerspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.resourceid.value=""
	end if
	end if
end sub
</script>
<script language="javascript">
function submitData()
{
	if (check_form(weaver,'resourceid,begindate,enddate'))
		weaver.submit();
}
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>