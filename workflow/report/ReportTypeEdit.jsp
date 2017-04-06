<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	} 
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(15519,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Workflow_ReportType_SelectByID",id);
RecordSet.next();

String typename = Util.toScreen(RecordSet.getString("typename"),user.getLanguage()) ;
String typedesc = Util.toScreen(RecordSet.getString("typedesc"),user.getLanguage()) ;
String typeorder = Util.null2String(RecordSet.getString("typeorder"));

//add by xhheng @20050206 for TD 1539
RecordSet.executeSql("SELECT count(*) FROM Workflow_Report where reporttype="+id);
int typecount=0;
if(RecordSet.next()){
    typecount= RecordSet.getInt(1);
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
//modify by xhheng @20050206 for TD 1539
if(typecount==0){
  RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
  RCMenuHeight += RCMenuHeightStep;
}
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/workflow/report/ReportTypeManage.jsp,_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/ReportTypeManage.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
// }
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="ReportTypeOperation.jsp" method=post >

<%
if(msgid!=-1){
%>
  <DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<%
 // if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
%>




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
        <INPUT type=text class=Inputstyle size=30  name="typename" onchange='checkinput("typename","typenameimage")' value="<%=typename%>">
          <SPAN id=typenameimage></SPAN></TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
        <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text class=Inputstyle  size=60 name="typedesc" value="<%=typedesc%>">
          <SPAN id=provincedescimage></SPAN></TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line" colSpan=2 ></TD></TR>
  <TR>
  <TR>
          
      <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD>
          
      <TD class=Field>
        <input type=text size=35 class=inputstyle id="typeorder" name="typeorder" value="<%=typeorder%>" maxlength=10 onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);">
      </TD>
        </TR>  <TR class="Spacing"  style="height:1px;">
    <TD class="Line1" colSpan=2 ></TD></TR>
  <TR>
        <input type="hidden" name=operation value=reporttypeedit>
		<input type="hidden" name=id value=<%=id%>>
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
 <script>
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="reporttypedelete";
			document.frmMain.submit();
		}
}
</script>

<script language="javascript">
function submitData()
{
	if (check_form(weaver,'typename'))
		weaver.submit();
}
</script>
</BODY></HTML>
