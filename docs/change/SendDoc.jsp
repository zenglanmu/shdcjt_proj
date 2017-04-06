<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Send", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23024,user.getLanguage());
String needfav ="1";
String needhelp ="";

String status = Util.null2String(request.getParameter("status"));
if(status.equals("")) status = "0";
String title = Util.null2String(request.getParameter("title"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
int timeText = 18961;
if(status.equals("0")) {
	timeText = 18002;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(status.equals("0")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+",javascript:doSend(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<LINK href="../css/Weaver.css" type=text/css rel=STYLESHEET>

<FORM name="frmmain" action="/docs/change/SendDocOpterator.jsp" method="post">
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



<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class="Title"> 
      <TH colSpan="2"><%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%></TH>
    </TR>
<TR class=Spacing  style="height:1px;">
  <TD colspan=8 class=line1></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></td>
    <td class=field>
	<select name="status" onChange="statusChange(this)">
	<option value="0" <%if(status.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22347,user.getLanguage())%></option>
	<option value="1" <%if(status.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19558,user.getLanguage())%></option>
	<option value="2" <%if(status.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22946,user.getLanguage())%></option>
	<option value="3" <%if(status.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21983,user.getLanguage())%></option>
	</select>
	</td>
     <td width=10%><div id="StatusDIV0" <%if(!status.equals("0")){%>style="display:none"<%}%>><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></div><div id="StatusDIV1" <%if(status.equals("0")){%>style="display:none"<%}%>><%=SystemEnv.getHtmlLabelName(18961,user.getLanguage())%></div></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=fromdate%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
    －<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=enddate%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
    </td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(23038,user.getLanguage())%></td>
    <td class=field colspan="3"><INPUT name=title value="<%=title%>"></td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>

<input name=start type=hidden value="<%=start%>">
<input name=requestids type=hidden value="">
<%
String statusText = "22347";
if(status.equals("0")) {
	statusText = "22347";
}
if(status.equals("1")) statusText = "19558";
if(status.equals("2")) statusText = "22946";
if(status.equals("3")) statusText = "21983";

String sqlwhere = " t1.requestid=t2.requestid and t1.currentnodeid = t2.nodeid and t2.userid="+user.getUID();
sqlwhere += " and t1.requestid > 0 and t1.currentnodetype='3' and t1.workflowid in(select workflowid from DocChangeWorkflow)";
if(status.equals("0")) {
	//取未发送的
	sqlwhere += " and t1.requestid not in (select requestid from DocChangeSend)";
	if(!fromdate.equals("")) sqlwhere += " and t2.receivedate>='"+fromdate+"' ";
	if(!enddate.equals("")) sqlwhere += " and t2.receivedate<='"+enddate+"' ";
}
else {
	String strStatus = "0,1";
	if(status.equals("2") || status.equals("3")) strStatus = status;
	//sqlwhere += " and t1.requestid in (select requestid from DocChangeSend)";
	sqlwhere += " and t1.requestid in (select distinct requestid from DocChangeSendDetail where status in(" + strStatus + ") )";
	//被退回
	//被拒收
}
if(!title.equals("")) sqlwhere += " and t1.requestname like '%"+title+"%'";

int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
String tableString = "";
if(perpage <2) perpage=10;                                 
String backfields = " t1.requestid,t1.workflowid,t1.requestname,t2.receivedate,t2.receivetime ";
String fromSql  = " workflow_requestbase t1, workFlow_CurrentOperator t2 ";
//out.print("select "+backfields + "from "+fromSql+" where "+sqlwhere);
tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                //" <checkboxpopedom    popedompara=\"column:requestid\" showmethod=\"\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"t2.receivedate,t2.receivetime\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(timeText,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"150\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
                "           <col width=\"\"  text=\""+SystemEnv.getHtmlLabelName(23038,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"\"  otherpara=\"column:requestid\" href=\"/workflow/request/ViewRequest.jsp\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" />";
if(!status.equals("0"))
tableString +=  "           <col width=\"80\"   text=\""+SystemEnv.getHtmlLabelName(20217,user.getLanguage())+"\" column=\"requestid\"  orderkey=\"\" otherpara=\"2121,"+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getDocChangeCompanyDetail\" />";
tableString +=  "           <col width=\"80\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"requestid\" orderkey=\"\" otherpara=\""+statusText+","+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getFieldname\" />"+
                "       </head>"+
                " </table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
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
</FORM>

<script>
//刷新动作
function doRefresh(obj) {
	document.frmmain.action = '#';
	document.frmmain.submit();
	obj.disabled = true;
}

//发送动作
function doSend(obj) {
	if(_xtable_CheckedCheckboxId()=="") { 
		alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
	}
	else {
		document.frmmain.requestids.value = _xtable_CheckedCheckboxId(); 
		document.frmmain.submit();
		obj.disabled = true;
	}
}
function statusChange(obj) {
	if(obj.value=='0') {
		document.all('StatusDIV0').style.display = '';
		document.all('StatusDIV1').style.display = 'none';
	}
	else {
		document.all('StatusDIV0').style.display = 'none';
		document.all('StatusDIV1').style.display = '';
	}
	doRefresh(obj);
}
</script>
<script language="vbs">
Sub showDetail(requestid)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/change/ChangeDetailBrowser.jsp?requestid="+requestid)
End Sub
</script>