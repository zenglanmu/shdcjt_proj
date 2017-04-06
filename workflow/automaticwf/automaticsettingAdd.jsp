<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("OutDataInterface:Setting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String setname = Util.null2String(request.getParameter("setname"));
String workFlowId = Util.null2String(request.getParameter("workFlowId"));
String workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname(""+workFlowId));
String isbill = Util.null2String(WorkflowComInfo.getIsBill(workFlowId));
String formID = Util.null2String(WorkflowComInfo.getFormId(workFlowId));
int detailcount = 0;
if(!formID.equals("")){
    if(isbill.equals("0")){
        RecordSet.executeSql("select count(distinct groupid) from workflow_formfield where formid="+formID);
        if(RecordSet.next()){
            detailcount = RecordSet.getInt(1);
        }
    }else if(isbill.equals("1")){
        RecordSet.executeSql("select count(tablename) from Workflow_billdetailtable where billid="+formID);
        if(RecordSet.next()){
            detailcount = RecordSet.getInt(1);
        }
        if(detailcount==0){
            //没有记录不代表没有明细,单据对应的明细表可能没有写进Workflow_billdetailtable中
            //但此时可以确定该单据即使有明细，也只有一个明细。
            RecordSet.executeSql("select count(distinct viewtype) from workflow_billfield where viewtype=1 and billid="+formID);   
            if(RecordSet.next()){
                detailcount = RecordSet.getInt(1);
            }
        }
    }
}
//out.println("detailcount=="+detailcount);
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="add">
<input type="hidden" id="detailcount" name="detailcount" value="<%=detailcount%>">
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
			<td class=field>
				<input type=text size=35 class=inputstyle id="setname" name="setname" value="<%=setname%>" onChange="checkinput('setname','setnamespan')">
				<span id="setnamespan"><%if(setname.equals("")){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
			</td>
	  </tr>
	  <tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></td>
			<td class=field>
				<button type=Button  class=browser onClick="onShowWorkFlowSerach('workFlowId','workflowspan')"></button>
				<span id="workflowspan">
				<%if(workFlowName.equals("")){%>
					<img src="/images/BacoError.gif" align=absmiddle>
				<%}else{%>
					<%=workFlowName%>
				<%}%>
				</span>
				<input type="hidden" id="workFlowId" name="workFlowId" value="<%=workFlowId%>">
				</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></td>
			<td class=field>
				<select id="datasourceid" name="datasourceid" onchange="ChangeDatasource(this,datasourceidspan)">
					<option></option>
					<%
					ArrayList pointArrayList = DataSourceXML.getPointArrayList();
					for(int i=0;i<pointArrayList.size();i++){
					    String pointid = (String)pointArrayList.get(i);
					%>
					<option value="<%=pointid%>"><%=pointid%></option>
					<%    
					}
					%>
				</select>
				<span id="datasourceidspan"><img src="/images/BacoError.gif" align=absmiddle></span>
			</td>
	  </tr>
		<tr style="height:1px;"><td class=line1 colspan=2><td></tr>
		<%if(!workFlowId.equals("")){%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></td>
			<td class=field><input type=text size=35 class=inputstyle id="outermaintable" name="outermaintable"></td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			<td class=field>
				<textarea id="outermainwhere" name="outermainwhere" cols=100 rows=4></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(23107,user.getLanguage())%></td>
			<td class=field>
				<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:<br>
				<textarea id="successback" name="successback" cols=100 rows=4></textarea><br>
				<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:<br>
				<textarea id="failback" name="failback" cols=100 rows=4></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<%for(int i=0;i<detailcount;i++){%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></td>
			<td class=field><input type=text size=35 class=inputstyle id="outerdetailname<%=i%>" name="outerdetailname<%=i%>"></td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			<td class=field>
				<textarea id="outerdetailwhere<%=i%>" name="outerdetailwhere<%=i%>" cols=100 rows=4></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<%}%>
		<%}%>
		<tr><td class=field colspan=2>
			<font color=red style="word-break:break-all;">
				<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>:<BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<%=SystemEnv.getHtmlLabelName(23111,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23154,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<%=SystemEnv.getHtmlLabelName(23110,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3:<%=SystemEnv.getHtmlLabelName(23152,user.getLanguage())%>
			</font></td></tr>
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
<script language="javascript">
function submitData(){
    if(check_form($GetEle("frmmain"),"setname,workFlowId,datasourceid")){
    	$GetEle("frmmain").submit();
    }
}

function ChangeDatasource(obj,datasourceidspan){
    if(obj.value!=""&&obj.value!=null) datasourceidspan.innerHTML = "";
    else datasourceidspan.innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
}
</script>

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