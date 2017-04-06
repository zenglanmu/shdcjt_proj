<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("HrmCareerPlanFinish:Finish", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String id = request.getParameter("id");

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6135,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCareerPlanFinish:Finish", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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

<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD>
  </TR> 
<!--             
        <TR>
          <TD>费用</TD>
          <TD class=Field>
            <input class=inputstyle type=text size=30 name="fare" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fare")'> 
          </TD>
        </TR>
        <TR>
          <TD>费用类型</TD>
          <TD class=Field>
           <BUTTON class=Browser onClick="onShowBudgetType()">
	  </BUTTON> 
	  <span class=inputstyle id=faretypespan>
	  </span> 
	  <input class=inputstyle  id=faretype type=hidden name=faretype>            
          </TD>
        </TR> 
-->                  
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></td>
          <td class=Field>
            <textarea class=inputstyle cols=50 rows=4 name=advice></textarea>
          </td>
        </tr>     
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
</TABLE>
<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=rownum>
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

<script language=vbs>

sub onShowEmailMould()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/mail/DocMouldBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	emailmouldspan.innerHtml = id(1)
	frmMain.emailmould.value=id(0)
	else 
	emailmouldspan.innerHtml = ""
	frmMain.emailmould.value=""
	end if
	end if
end sub
sub onShowResource(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	inputspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
sub onShowBudgetType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype='1'")
	if Not isempty(id) then
	if id(0)<> 0 then
	faretypespan.innerHtml = id(1)
	frmMain.faretype.value=id(0)
	else
	faretypespan.innerHtml = ""
	frmMain.faretype.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
 function doedit(){      
   
   document.frmMain.operation.value="finish";   
   document.frmMain.submit();
 }
</script> 
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
