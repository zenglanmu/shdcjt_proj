<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.interfaces.datasource.DataSource"%>
<%@ page import="weaver.general.StaticObj"%>

<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("OutDataInterface:Setting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String setname = "";
String workflowid = "";
String datasourceid = "";
String workflowname = "";
String outermaintable = "";
String outermainwhere = "";
String successback = "";
String failback = "";
String outerdetailtables = "";
String outerdetailwheres = "";
ArrayList outerdetailtablesArr = new ArrayList();
ArrayList outerdetailwheresArr = new ArrayList();

String viewid = Util.null2String(request.getParameter("viewid"));
String formid = "";
String isbill = "";
RecordSet.executeSql("select * from outerdatawfset where id="+viewid);
if(RecordSet.next()){
    setname = Util.null2String(RecordSet.getString("setname"));
    workflowid = Util.null2String(RecordSet.getString("workflowid"));
    datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
    formid = WorkflowComInfo.getFormId(workflowid);
    isbill = WorkflowComInfo.getIsBill(workflowid);
    workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
    outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
    outermainwhere = Util.null2String(RecordSet.getString("outermainwhere"));
    successback = Util.null2String(RecordSet.getString("successback"));
    failback = Util.null2String(RecordSet.getString("failback"));
    outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
    outerdetailwheres = Util.null2String(RecordSet.getString("outerdetailwheres"));
    outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
    outerdetailwheresArr = Util.TokenizerString(outerdetailwheres,",");
}
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",automaticsettingEdit.jsp?viewid="+viewid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+",automaticsettingAddDetail.jsp?viewid="+viewid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class=viewform cellspacing=1>
		<colgroup>
		<col width="15%">
		<col width="85%">
		<tbody>
		<tr class=spacing>
			<td class=Sep1 colSpan=2></td>
		</tr>
	  <tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
			<td class=field><span><%=setname%></span></td>
	  </tr>
	  <tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></td>
			<td class=field>
				<span><%=workflowname%></span>
			</td>
		</tr>
	  <tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></td>
			<td class=field>
				<span><%=datasourceid%></span>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line1 colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></td>
			<td class=field><input type=text size=35 class=inputstyle value="<%=outermaintable%>" disabled></td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			<td class=field>
				<textarea cols=100 rows=4 disabled><%=outermainwhere%></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(23107,user.getLanguage())%></td>
			<td class=field>
				<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:<br>
				<textarea cols=100 rows=4 disabled><%=successback%></textarea><br>
				<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:<br>
				<textarea cols=100 rows=4 disabled><%=failback%></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<%
		int detailcount = GetFormDetailInfo.getDetailNum(formid,isbill);
		for(int i=0;i<detailcount;i++){
		    String outerdetailtable = "";
		    String outerdetailwhere = "";
		    if(outerdetailtablesArr.size()>i){//数组越界
		        outerdetailtable = (String)outerdetailtablesArr.get(i);
		        outerdetailwhere = (String)outerdetailwheresArr.get(i);
		    }
		    if(outerdetailtable.equals("-")) outerdetailtable = "";
		    if(outerdetailwhere.equals("-")) outerdetailwhere = "";
		%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></td>
			<td class=field><input type=text size=35 class=inputstyle value="<%=outerdetailtable%>" disabled></td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			<td class=field>
				<textarea cols=100 rows=4 disabled><%=outerdetailwhere%></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<%}%>
		<tr>
			<td class=field colspan=2 style="word-break:break-all;">
			<font color=red style="word-break:break-all;">
				<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>:<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<%=SystemEnv.getHtmlLabelName(23111,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23154,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<%=SystemEnv.getHtmlLabelName(23110,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3:<%=SystemEnv.getHtmlLabelName(23152,user.getLanguage())%>
			</font>
			</td>
		</tr>
		</tbody>
	</table>
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
</body>
</html>
<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowWorkFlowSerach(inputename, tdname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}
</script>