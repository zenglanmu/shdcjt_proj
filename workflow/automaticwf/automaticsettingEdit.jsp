<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
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
String operate = Util.null2String(request.getParameter("operate"));
String formID = "";
String isbill = "";
if(operate.equals("reedit")){//编辑时重新选择流程
    setname = Util.null2String(request.getParameter("setname"));
    workflowid = Util.null2String(request.getParameter("workFlowId"));
    datasourceid = Util.null2String(request.getParameter("datasourceid"));
    workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
    isbill = Util.null2String(WorkflowComInfo.getIsBill(workflowid));
    formID = Util.null2String(WorkflowComInfo.getFormId(workflowid));
}else{
    RecordSet.executeSql("select * from outerdatawfset where id="+viewid);
    if(RecordSet.next()){
        setname = Util.null2String(RecordSet.getString("setname"));
        workflowid = Util.null2String(RecordSet.getString("workflowid"));
        datasourceid = Util.null2String(RecordSet.getString("datasourceid"));
        workflowname = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
        isbill = Util.null2String(WorkflowComInfo.getIsBill(workflowid));
        formID = Util.null2String(WorkflowComInfo.getFormId(workflowid));
        outermaintable = Util.null2String(RecordSet.getString("outermaintable"));
        outermainwhere = Util.null2String(RecordSet.getString("outermainwhere"));
        successback = Util.null2String(RecordSet.getString("successback"));
        failback = Util.null2String(RecordSet.getString("failback"));
        outerdetailtables = Util.null2String(RecordSet.getString("outerdetailtables"));
        outerdetailwheres = Util.null2String(RecordSet.getString("outerdetailwheres"));
        outerdetailtablesArr = Util.TokenizerString(outerdetailtables,",");
        outerdetailwheresArr = Util.TokenizerString(outerdetailwheres,",");
    }
}

int detailcount = GetFormDetailInfo.getDetailNum(formID,isbill);
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsettingView.jsp?viewid="+viewid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<input type="hidden" id="operate" name="operate" value="edit">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
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
				<button type=button  class=browser onClick="onShowWorkFlowSerach('workFlowId','workflowspan')"></button>
				<span id="workflowspan">
				<%if(workflowname.equals("")){%>
					<img src="/images/BacoError.gif" align=absmiddle>
				<%}else{%>
					<%=workflowname%>
				<%}%>
				</span>
				<input type="hidden" id="workFlowId" name="workFlowId" value="<%=workflowid%>">
			</td>
		</tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></td>
			<td class=field>
				<select id="datasourceid" name="datasourceid" onchange="ChangeDatasource(this,datasourceidspan)">
					<option></option>
					<%
					boolean isexist = false;
					ArrayList pointArrayList = DataSourceXML.getPointArrayList();
					for(int i=0;i<pointArrayList.size();i++){
					    String pointid = (String)pointArrayList.get(i);
					    String isselected = "";
					    if(datasourceid.equals(pointid)){
					        isexist = true;
					        isselected = "selected";
					    }
					%>
					<option value="<%=pointid%>" <%=isselected%>><%=pointid%></option>
					<%    
					}
					%>
				</select>
				<span id="datasourceidspan"><%if(datasourceid.equals("")||!isexist){%><img src="/images/BacoError.gif" align=absmiddle><%}%></span>
			</td>
	  </tr>
		<tr style="height:1px;"><td class=line1 colspan=2><td></tr>
		<%if(!workflowid.equals("")){%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></td>
			<td class=field><input type=text size=35 class=inputstyle id="outermaintable" name="outermaintable" value="<%=outermaintable%>"></td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			<td class=field>
				<textarea id="outermainwhere" name="outermainwhere" cols=100 rows=4 ><%=outermainwhere%></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(23107,user.getLanguage())%></td>
			<td class=field>
				<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:<br>
				<textarea id="successback" name="successback" cols=100 rows=4 ><%=successback%></textarea><br>
				<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:<br>
				<textarea id="failback" name="failback" cols=100 rows=4 ><%=failback%></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<%
		for(int i=0;i<detailcount;i++){
		    String outerdetailtable = "";
		    String outerdetailwhere = "";
		    if(!operate.equals("reedit")){
		        if(outerdetailtablesArr.size()>i){
		            outerdetailtable = (String)outerdetailtablesArr.get(i);
		            outerdetailwhere = (String)outerdetailwheresArr.get(i);
		            if(outerdetailtable.equals("-")) outerdetailtable = "";
		            if(outerdetailwhere.equals("-")) outerdetailwhere = "";
		        }
		    }
		%>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></td>
			<td class=field><input type=text size=35 class=inputstyle id="outerdetailname<%=i%>" name="outerdetailname<%=i%>" value="<%=outerdetailtable%>" ></td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<tr>
			<td valign="top"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
			<td class=field>
				<textarea id="outerdetailwhere<%=i%>" name="outerdetailwhere<%=i%>" cols=100 rows=4 ><%=outerdetailwhere%></textarea>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2><td></tr>
		<%}%>
		<%}%>
		<tr>
			<td class=field colspan=2 style="word-break:break-all;">
			<font color=red>
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
