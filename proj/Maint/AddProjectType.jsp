<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<% if(!HrmUserVarify.checkUserRight("AddProjectType:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(586,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver action="/proj/Maint/ProjectTypeOperation.jsp" method=post>

  <input type="hidden" name="method" value="add">
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
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
        <TR class=title>
            <TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=spacing style="height:1px;">
          <TD class=line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")'><SPAN id=typeimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>

        <TR class=Line style="height:1px;"><TD colspan="2"  class=line ></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(18632,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle name="txtTypeCode"></TD>
         </TR> 


		<TR class=Line style="height:1px;"><TD colspan="2"  class=line ></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")'><SPAN id=descimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
         </TR> 
		   
		  <TR class=Line style="height:1px;"><TD colspan="2"  class=line ></TD></TR> 
		  <TR>
			<TD><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></TD>
		    <TD class="Field">
              <input type=hidden name="approvewfid" class="wuiBrowser" value="" _required="yes" 
              	_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=74">
			</TD>
		  </TR> 

		<TR class=Line style="height:1px;"><TD colspan="2"  class=line ></TD></TR> 
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(20420,user.getLanguage())%></TD>
			<TD class=Field><input type="checkbox" name="insertWorkPlan" value="1" /></TD>
		</TR> 

		  <TR class=spacing style="height:1px;">
			<TD class=line1 colSpan=2></TD>
		  </TR> 
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
function submitData()
{
	if (check_form(weaver,'type,desc,approvewfid'))
		weaver.submit();
}
</script>
<script language="vbs">
	sub onShowWorkflow()
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1 and formid=74")
		if NOT isempty(id) then
				if id(0)<> 0 then
			approvewfspan.innerHtml = id(1)
			weaver.approvewfid.value=id(0)
			else
			approvewfspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle/>"
			weaver.approvewfid.value=""
			end if
		end if
	end sub
</script>
</BODY>
</HTML>
