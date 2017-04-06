<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="testWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%
if (!HrmUserVarify.checkUserRight("Delete:TestRequest", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(28056,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

String workflowid = "" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;

String fromself = Util.null2String(request.getParameter("fromself"));
String isfirst = Util.null2String(request.getParameter("isfirst"));
String opttype = Util.null2String(request.getParameter("opttype"));
if("delete".equals(opttype)){
	String multisubids = Util.null2String(request.getParameter("multisubids"));
	//out.println("multisubids = " + multisubids);
	testWorkflowCheck.deleteTestRequest(multisubids, user, request);
}
if(fromself.equals("1")) {
	workflowid = Util.null2String(request.getParameter("workflowid"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
}
String newsql = "";
if(fromself.equals("1")) {
	if(!workflowid.equals("") && !workflowid.equals("0")){
		newsql+=" and t1.workflowid in("+workflowid+")" ;
	}

	if(!fromdate.equals("")){
		newsql += " and t1.createdate>='"+fromdate+"'";
	}
	if(!todate.equals("")){
		newsql += " and t1.createdate<='"+todate+"'";
	}
	if(!createrid.equals("")){
		newsql += " and t1.creater='"+createrid+"'";
		newsql += " and t1.creatertype= '"+creatertype+"' ";
	}
}

String userID = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2")) usertype= 1;

String sqlwhere=" where t1.workflowid=t2.id and (t1.deleted=1 and t2.isvalid='2' )";

String orderby = "t1.requestid";

sqlwhere +=" "+newsql ;


int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

int perpage = 10;
RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
	perpage = RecordSet.getInt("numperpage");
}else{
	RecordSet.executeProc("workflow_RUserDefault_Select","1");
	if(RecordSet.next()){
		perpage = RecordSet.getInt("numperpage");
	}
}
if(perpage <=2){
	perpage = 10;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>

<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<table width="100%" height="94%" border="0" cellspacing="0" cellpadding="0">
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
		<form id="frmmain" name="frmmain" method="post" action="/workflow/search/RequestTestList.jsp">
		<input type="hidden" id="fromself" name="fromself" value="1">
		<input type="hidden" id="isfirst" name="isfirst" value="<%=isfirst%>">
		<input type="hidden" id="opttype" name="opttype" value="">
		<input type="hidden" id="multisubids" name="multisubids" value="">
		<table class="viewform">
			<colgroup>
			<col width="10%">
			<col width="20%">
			<col width="5">
			<col width="10%">
			<col width="20%">
			<col width="5%">
			<col width="10%">
			<col width="20">
		<tbody>
			<tr>
				<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
				<td class=field>
					<button type="button" class=browser onClick="onShowWorkFlow('workflowid','workflowspan')"></button>
					<span id=workflowspan><%=WorkflowComInfo.getWorkflowname(workflowid)%></span>
					<input name=workflowid type="hidden" value="<%=workflowid%>">
				</td>
				<td>&nbsp;</td>
				<td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
				<td class=field>
					<BUTTON type="button" class=calendar id=SelectDate  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
					<SPAN id=fromdatespan ><%=fromdate%></SPAN>
					-&nbsp;&nbsp;
					<BUTTON type="button" class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
					<SPAN id=todatespan ><%=todate%></SPAN>
					<input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
				</td>
				<td>&nbsp;</td>
				<td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
				<td class=field>
					<select class="Inputstyle" name="creatertype" id="creatertype">
				<%if(!user.getLogintype().equals("2")){%>
					<%if(isgoveproj==0){%>
						<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
					<%}else{%>
						<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
					<%}%>
				<%}%>
				<%if(isgoveproj==0){%>
						<option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
				<%}%>
					</select>
				&nbsp;
					<button type="button" class=browser onClick="onShowResource()"></button>
					<span id="resourcespan"><% if(creatertype.equals("0")){%><%=ResourceComInfo.getResourcename(createrid)%><%}%>
					<% if(creatertype.equals("1")){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%><%}%></span>
					<input name=createrid type="hidden" value="<%=createrid%>">
				</td>
			</tr>
			<TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
		</tbody>
		</table>
		<input name="start" id="start" type="hidden" value="<%=start%>">
		</form>
		<TABLE width="100%">
			<tr>
				<td valign="top">																					
				<%
					String tableString = "";						 
					String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid ";
					String fromSql  = " from workflow_requestbase t1,workflow_base t2 ";
					String sqlWhere = sqlwhere;
					//out.println("select "+backfields+"&nbsp;"+fromSql+"&nbsp;"+sqlWhere);
					tableString = "<table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+ 
									"	<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
									"			<head>";
					tableString += "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
					tableString += "				<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
					tableString += "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
					tableString += "				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
					tableString += "				<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\" />";
					tableString += "				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
					tableString += "			</head>"+   			
									"</table>";
				%>
					<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
				</td>
			</tr>
		</TABLE>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
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

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</body>

<script type="text/javascript">
function onShowResource() {
	var tmpval = $GetEle("creatertype").value;
	var id = null;
	if (tmpval == "0") {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}else {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			resourcespan.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle("createrid").value=wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			resourcespan.innerHTML = "";
			$GetEle("createrid").value="";
		}
	}

}
function onShowDepartment(tdname,inputename) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value, "", "dialogWidth:550px;dialogHeight:550px;")
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle(tdname).innerHTML = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			$GetEle(inputename).value= wuiUtil.getJsonValueByIndex(id, 0).substr(1);
		} else {
			$GetEle(tdname).innerHTML = "";
			$GetEle(inputename).value="";
		}
	}
}
</script>

<SCRIPT language="javascript">

function OnChangePage(start){
		$GetEle("start").value = start;
		$GetEle("frmmain").submit();
}

function OnSearch(){
	$GetEle("fromself").value="1";
	$GetEle("isfirst").value="1";
	$GetEle("frmmain").submit();
}
function doDelete(){
	$GetEle("multisubids").value = _xtable_CheckedCheckboxId();
	if($GetEle("multisubids").value == ""){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}
	if(isdel()){
		$GetEle("fromself").value="1";
		$GetEle("isfirst").value="1";
		$GetEle("opttype").value="delete";
		$GetEle("frmmain").submit();
	}
}

function CheckAll(haschecked) {

	len = document.weaver1.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.weaver1.elements[i].name.substring(0,13)=='multi_submit_') {
			document.weaver1.elements[i].checked=(haschecked==true?true:false);
		}
	}

}


var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
	showTableDiv.style.display='';
	var message_Div = document.createElement("div");
	 message_Div.id="message_Div";
	 message_Div.className="xTable_message";
	 showTableDiv.appendChild(message_Div);
	 var message_Div1  = $GetEle("message_Div");
	 message_Div1.style.display="inline";
	 message_Div1.innerHTML=content;
	 var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	 var pLeft= document.body.offsetWidth/2-50;
	 message_Div1.style.position="absolute"
	 message_Div1.style.top=pTop;
	 message_Div1.style.left=pLeft;

	 message_Div1.style.zIndex=1002;

	 oIframe.id = 'HelpFrame';
	 showTableDiv.appendChild(oIframe);
	 oIframe.frameborder = 0;
	 oIframe.style.position = 'absolute';
	 oIframe.style.top = pTop;
	 oIframe.style.left = pLeft;
	 oIframe.style.zIndex = message_Div1.style.zIndex - 1;
	 oIframe.style.width = parseInt(message_Div1.offsetWidth);
	 oIframe.style.height = parseInt(message_Div1.offsetHeight);
	 oIframe.style.display = 'block';
}
function displaydiv_1(){
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
	var ajax=false;
	try {
		ajax = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
		try {
			ajax = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (E) {
			ajax = false;
		}
	}
	if (!ajax && typeof XMLHttpRequest!='undefined') {
	ajax = new XMLHttpRequest();
	}
	return ajax;
}
function showallreceived(requestid,returntdid){
	showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
	var ajax=ajaxinit();
	ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
	ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	ajax.send("requestid="+requestid+"&returntdid="+returntdid);
	//获取执行状态
	//alert(ajax.readyState);
	//alert(ajax.status);
	ajax.onreadystatechange = function() {
		//如果执行状态成功，那么就把返回信息写到指定的层里
		if (ajax.readyState==4&&ajax.status == 200) {
			try{
				 $GetEle(returntdid).innerHTML = ajax.responseText;
				 $GetEle(returntdid).parentElement.title = ajax.responseText.replace(/[\r\n]/gm, "");
			}catch(e){}
				showTableDiv.style.display='none';
				oIframe.style.display='none';
		} 
	} 
}

function onShowWorkFlow(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, false);
}

function onShowWorkFlowNeeded(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, true);
}

function onShowWorkFlowBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else { 
			$GetEle(inputname).value = "";
			if (needed) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
		}
	}
}
</script>

<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>