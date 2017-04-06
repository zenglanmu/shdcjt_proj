<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<%
session.setAttribute("relaterequest", "new");
String CurrentUser = ""+user.getUID();
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentDay = TimeUtil.getCurrentDateString();
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(request.getParameter("type")); //周期
String type_d = Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(request.getParameter("operationType"));
String taskcontent = Util.null2String(request.getParameter("taskcontent"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 0);
int wakemode = Util.getIntValue(request.getParameter("wakemode"), -1);

int orderType = 0;
String orderFieldName = "";
int orderFieldid = 0;
String srcType = "";
String sqlWhere = "";

FileUpload fu = new FileUpload(request);
if(fu != null){
	orderType = Util.getIntValue(fu.getParameter("orderType"), 0);
	orderFieldName = Util.null2String(fu.getParameter("orderFieldName"));
	orderFieldid = Util.getIntValue(fu.getParameter("orderFieldid"), 0);
	srcType = Util.null2String(fu.getParameter("srcType"));
	operationType = Util.null2String(fu.getParameter("operationType"));
	if("search".equals(operationType) || "searchorder".equals(srcType) || "changePage".equals(srcType)){
		type = Util.null2String(fu.getParameter("type")); //周期
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
		taskcontent = Util.null2String(fu.getParameter("taskcontent"));
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		wakemode = Util.getIntValue(fu.getParameter("wakemode"), -1);
	}
}
String checkStr = "";
String worktaskName = "";
boolean hasSuchWT = false;
Hashtable worktaskName_hs = new Hashtable();
ArrayList wtidList = new ArrayList();
rs1.execute("select * from worktask_base order by orderid asc");
while(rs1.next()){
	int id_tmp = Util.getIntValue(rs1.getString("id"), 0);
	if(id_tmp == wtid){
		hasSuchWT = true;
	}
	String worktaskName_tmp = Util.null2String(rs1.getString("name"));
	wtidList.add(""+id_tmp);
	worktaskName_hs.put("worktaskname_"+id_tmp, worktaskName_tmp);
}
if(hasSuchWT == true){
	worktaskName = Util.null2String((String)worktaskName_hs.get("worktaskname_"+wtid));
}else{
	wtid = 0;
}

WTSerachManager wtSerachManager = new WTSerachManager(wtid);
wtSerachManager.setLanguageID(user.getLanguage());
wtSerachManager.setType_d(type_d);
wtSerachManager.setObjid(objId);
wtSerachManager.setUserID(user.getUID());
wtSerachManager.setWorktaskStatus(worktaskStatus);

if("searchorder".equals(srcType) || "changePage".equals(srcType)){
	sqlWhere = Util.null2String((String)session.getAttribute("sqlWhereWT_"+user.getUID()));
}
if("search".equals(operationType)){
	if(wtid != 0){
		sqlWhere += " and r.taskid="+wtid+" ";
	}
	if(!"".equals(taskcontent.trim())){
		sqlWhere += " and r.taskcontent like '%"+taskcontent+"%' ";
	}
	if(wakemode != -1){
		sqlWhere += " and r.wakemode="+wakemode+" ";
	}
}
session.setAttribute("sqlWhereWT_"+user.getUID(), sqlWhere);
ArrayList wtsdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkTaskStatus");//先留着
ArrayList wtsdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkTaskStatus");

String createPageSql = "";
Hashtable ret_hs_1 = wtSerachManager.getTemplatePageSql();
createPageSql = (String)ret_hs_1.get("createPageSql");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList widthList = (ArrayList)ret_hs_1.get("widthList");
ArrayList needorderList = (ArrayList)ret_hs_1.get("needorderList");
int listCount = Util.getIntValue(((String)ret_hs_1.get("listCount")), 0);
if(wtid == 0){//页面上沿计划任务类型选择框，如果选择所有类型，则必须多加一列“任务类型”
	listCount += 1;
}
listCount += 1;//创建人
listCount += 1;//一直显示定期类型

//使用自定义查询时，时间限定无作用
if("search".equals(operationType) || (("searchorder".equals(srcType) || "changePage".equals(srcType)) && !"".equals(sqlWhere))){
	createPageSql += sqlWhere;
}
//System.out.println("createPageSql = " + createPageSql);
int perpage = wtSerachManager.getUserDefaultPerpage(false);
int pagenum = Util.getIntValue(fu.getParameter("pagenum"), 1);

if(orderFieldid == 0){
	createPageSql += " order by status asc, createdate desc, createtime desc";
}else{
	createPageSql += " order by "+orderFieldName;
	if(orderType == 1){
		createPageSql += " desc";
	}else{
		createPageSql += " asc";
	}
}
rs2.execute(createPageSql);
int allCount = rs2.getCounts();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:left;padding:0 2px 0 2px;color:#333}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(16539, user.getLanguage()) + SystemEnv.getHtmlLabelName(64, user.getLanguage());
String imagefilename = "/images/hdHRM.gif";
%>

<BODY id="worktaskBody">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javaScript:OnNew(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javaScript:delRow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(pagenum > 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:doPrePage(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(allCount > (perpage*pagenum)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:doNextPage(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
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
<form name="taskform" method="post" action="WorktaskTemplate.jsp" enctype="multipart/form-data">
<input type="hidden" name="worktaskStatus" value="<%=worktaskStatus%>">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="ishidden" value="1" >
<input type="hidden" id="isCreate" name="isCreate" value="1">
<input type="hidden" id="nodesnum" name="nodesnum" value="1">
<input type="hidden" id="indexnum" name="indexnum" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="delids" name="delids" >
<input type="hidden" id="editids" name="editids" >
<input type="hidden" id="functionPage" name="functionPage" value="WorktaskTemplate.jsp" >
<input type="hidden" id="orderType" name="orderType" value="">
<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
<input type="hidden" id="srcType" name="srcType" value="">
<input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>">
<table class="viewform" cellspacing="1">
<COLGROUP>
	<COL width="10%">
	<COL width="20%">
	<COL width="10%">
	<COL width="20%">
	<COL width="10%">
	<COL width="15%">
	<COL width="15%">
	<TBODY>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(22134, user.getLanguage())%></td>
		<td class="field"><input type="text" class="InputStyle" width="90%" name="taskcontent" value="<%=taskcontent%>"></td>
		<td><%=SystemEnv.getHtmlLabelName(842, user.getLanguage())%></td>
		<td class="field">
			<select id="wtid" name="wtid">
				<option value="0"></option>
				<%
					for(int i=0; i<wtidList.size(); i++){
						int id_tmp = Util.getIntValue((String)wtidList.get(i), 0);
						String name_tmp = Util.null2String((String)worktaskName_hs.get("worktaskname_"+id_tmp));
						String selectStr = "";
						if(id_tmp == wtid){
							selectStr = "selected";
						}
						out.println("<option value=\""+id_tmp+"\" "+selectStr+">"+name_tmp+"</option>");
					}%>
		</td>
		<td><%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%></td>
		<td class="field">
			<select id="wakemode" name="wakemode">
				<option value="-1"></option>
				<option value="2" <%if(wakemode==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(445, user.getLanguage())%></option>
				<option value="4" <%if(wakemode==4){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(18280, user.getLanguage())%></option>
				<option value="1" <%if(wakemode==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(6076, user.getLanguage())%></option>
				<option value="0" <%if(wakemode==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(1926, user.getLanguage())%></option>
				<option value="3" <%if(wakemode==3){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222, user.getLanguage())+SystemEnv.getHtmlLabelName(1925, user.getLanguage())%></option>
		</td>
		<td align="left">&nbsp;&nbsp;<BUTTON Class="btn_RequestSubmitList" type="button" onclick="onSearch();"><%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>
		</td>
	</tr>
	<tr class="Line">
		<td colspan="7"></td>
	</tr>
</table>
<%
//获得有创建权限的taskid
Hashtable createTasks_hs = wtSerachManager.getCanCreateTasks();
String tasksSelectStr = (String)createTasks_hs.get("tasksSelectStr");//可创建计划任务下拉必选框，以默认第一个任务。
String hasCanCreateTasks = (String)createTasks_hs.get("hasCanCreateTasks");//是否具有至少一个可创建的计划任务
%>
</br>
<TABLE class="ListStyle" cellspacing="1" id="oTableBut" style="width:98%">
	<TBODY>
	<tr>
	<td align="right">
	<%
		int allPage = 0;
		if((allCount%perpage) == 0){
			allPage = allCount/perpage;
		}else{
			allPage = allCount/perpage + 1;
		}
		String splitPageHtml = sptmForWorktask.getSplitPageHtml(allPage, allCount, perpage, pagenum, user.getLanguage());
		out.println(splitPageHtml);
	%>
	</td>
	</tr>
	<tr style="height: 1px;"><td class="line1" style="padding: 0px"></td></tr> 
	</TBODY>
</TABLE>
<%
int totalWidth = 25;
String colStr = "<COL width=\"25\">\n";
if(wtid == 0){
	totalWidth += 80;
	colStr += "<COL width=\"80\">\n";
}
/*创建人*/
totalWidth += 80;
colStr += "<COL width=\"80\">\n";
for(int cx=0; cx<widthList.size(); cx++){
	int width = Util.getIntValue((String)widthList.get(cx), 80);
	totalWidth += width;
	colStr += "<COL width=\""+width+"\">\n";
}
%>
<div id="firstDiv" name="firstDiv" style="width:100%;overflow-x:auto;height=300px;overflow-y:auto;">
<TABLE class="ListStyle" cellspacing="1" id="oTable" name="oTable" style="width:<%=totalWidth%>px;margin:0px;">
	<COLGROUP>
	<%=colStr%>
	<TBODY>
	<TR class=Header>
	<th><input type="checkbox" name="chooseAll" onClick="onChooseAll(this)"></th>
	<%
	int orderType_1 = 0;
	String orderTypeStr_1 = "";
	if(orderFieldid == -1){
		if(orderType == 0){
			orderType_1 = 1;
			orderTypeStr_1 = "<font style=\"font-family:webdings\"></font>";
		}else{
			orderType_1 = 0;
			orderTypeStr_1 = "<font style=\"font-family:webdings\"></font>";
		}
	}
	if(wtid == 0){//计划任务类型。新增时为必选框
		out.println("<th style=\"cursor:hand\" onClick=\"changeOrder(this, '"+orderType_1+"', 'r.taskid', '-1')\" >"+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"&nbsp;"+orderTypeStr_1+"</th>");
	}
	out.println("<th>"+SystemEnv.getHtmlLabelName(882, user.getLanguage())+"</th>");
	for(int cx=0; cx<crmnameList.size(); cx++){
		String crmname_tmp = Util.null2String((String)crmnameList.get(cx));
		int id_tmp = Util.getIntValue((String)idList.get(cx), 0);
		String fieldname_tmp = Util.null2String((String)fieldnameList.get(cx));
		int needorder_tmp = Util.getIntValue((String)needorderList.get(cx), 0);
		int orderType_tmp = 0;
		String orderTypeStr_tmp = "";
		if(orderFieldid == id_tmp){
			if(orderType == 0){
				orderType_tmp = 1;
				orderTypeStr_tmp = "<font style=\"font-family:webdings\"></font>";
			}else{
				orderType_tmp = 0;
				orderTypeStr_tmp = "<font style=\"font-family:webdings\"></font>";
			}
		}
		String orderStr = "";
		if(needorder_tmp == 1){
			orderStr = " style=\"cursor:hand\" onClick=\"changeOrder(this, '"+orderType_tmp+"', 'r."+fieldname_tmp+"', '"+id_tmp+"')\" ";
		}
		out.println("<th"+orderStr+">"+crmname_tmp+"&nbsp;"+orderTypeStr_tmp+"</th>");
	}
	%>
	</TR>
	<TR class=Line><TD colspan="<%=(listCount+1)%>" ></TD></TR>
	<%
		//列表数据查询开始
		//System.out.println(createPageSql);
		if(pagenum > 1){
			for(int c=0; (c<(perpage*(pagenum-1)) && rs2.next()); c++){
				//
			}
		}
		int showCount = 0;
		String planStartDate = "";
		String planEndDate = "";
		String planDays = "";
		String classStr = "DataDark";
		boolean trClass = true;
		while(rs2.next()){
			int requestid_tmp = Util.getIntValue(rs2.getString("requestid"), 0);
			int taskid_tmp = Util.getIntValue(rs2.getString("taskid"), 0);
			if(requestid_tmp <= 0 ){
				continue;
			}
			showCount++;
			if(showCount > perpage){
				break;
			}
			out.println("<TR CLASS="+classStr+" onmouseover=\"browseTable_onmouseover(this)\" onmouseout=\"browseTable_onmouseout(this)\">");
			int status_tmp = Util.getIntValue(rs2.getString("status"), -1);
			//System.out.println("status_tmp = "+rs2.getString("status"));
			if(status_tmp==1 || status_tmp==3){//只有未提交和被退回才能编辑、提交审批
				out.println("<TD><INPUT type='checkbox'  name='checktask2' value='"+requestid_tmp+"'><input type='hidden' name='requestid_add' value='"+requestid_tmp+"'><input type='hidden' name='taskid_"+requestid_tmp+"' value='"+taskid_tmp+"'></TD>");
			}else{
				out.println("<TD></TD>");
			}
			if(wtid == 0){
				out.println("<td>"+Util.null2String((String)worktaskName_hs.get("worktaskname_"+taskid_tmp))+"</td>");
			}
			int creater = Util.getIntValue(rs2.getString("creater"), 0);
			out.println("<td><a href=\"javaScript:openFullWindowHaveBar('/hrm/resource/HrmResource.jsp?id="+creater+"')\">"+resourceComInfo.getLastname(""+creater)+"</a></td>");
			for(int i=0; i<fieldnameList.size(); i++){
				String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
				String value_tmp = rs2.getString(fieldname_tmp);
				String fieldid_tmp = Util.null2String((String)idList.get(i));
				String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
				String type_tmp = Util.null2String((String)typeList.get(i));
				int width = Util.getIntValue((String)widthList.get(i), 6);
				if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
					if(!"".equals(value_tmp)){
						String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
						for(int dx=0; dx<tlinkwts.length; dx++){
							String tlinkwt = Util.null2o(tlinkwts[dx]);
							int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
							tempnum++;
							session.setAttribute("retrequestid"+tempnum, tlinkwt);
							session.setAttribute("tlinkwfnum", ""+tempnum);
							session.setAttribute("haslinkworktask", "1");
							session.setAttribute("deswtrequestid"+tempnum, ""+requestid_tmp);
						}
					}
				}
				String valueStr = wtSerachManager.getFieldValue(fieldhtmltype_tmp, type_tmp, value_tmp, fieldid_tmp);
				if("taskcontent".equals(fieldname_tmp) && !"".equals(valueStr.trim())){//系统字段 taskcontent，用于添加进入单个计划任务页面
					valueStr = "<a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktaskTemplate.jsp?requestid="+requestid_tmp+"')\">"+valueStr+"</a>";
				}
				out.println("<td style=\"LEFT: 0px; WIDTH:"+width+"px;WORD-break:break-all;TEXT-VALIGN:center\">"+valueStr+"</td>");
			}
%>
	</TR>
<%
	if(trClass == true){
		classStr = "DataLight";
		trClass = false;
	}else{
		classStr = "DataDark";
		trClass = true;
	}
}
%>
	<TR class="Line"><TD colspan="<%=(listCount+1)%>" ></TD></TR>
</TABLE>
</div>
</td>
</tr>
</TABLE>
</form>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
<script>
function setFirstDivHeight(){
	firstDiv.style.width = "100%";
	var bodyheight = worktaskBody.clientHeight;
	if(bodyheight > 94){
		bodyheight = bodyheight - 94;
	}
	firstDiv.style.height = bodyheight - 20;
	firstDiv.style.width = worktaskBody.clientWidth - 15;
	var tableWidth = parseInt(oTable.style.width);
	var divWidth = parseInt(firstDiv.style.width);
	if(tableWidth < divWidth){
		oTable.style.width = worktaskBody.clientWidth - 40;
	}else if(tableWidth != <%=totalWidth%>){
		oTable.style.width = <%=totalWidth%>;
	}
}
setFirstDivHeight();
window.onresize = setFirstDivHeight;
function browseTable_onmouseover(obj){
	/*
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	*/
	obj.className = "Selected";
}
function browseTable_onmouseout(obj){
	/*
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	*/
	if(obj.rowIndex%2==0){
		obj.className = "DataDark";
	}else{
		obj.className = "DataLight";
	}
}
function onChooseAll(obj){
	var check = obj.checked;
	var chks = document.getElementsByName("taskcheck");
	try{
		for(var i=0; i<chks.length; i++){
			chks[i].checked = check;
		}
	}catch(e){}
	var chks2 = document.getElementsByName("checktask2");
	try{
		for(var i=0; i<chks2.length; i++){
			chks2[i].checked = check;
		}
	}catch(e){}
}

function onSearch(){
	document.taskform.operationType.value="search";
	document.taskform.submit();
	enableAllmenu();
}

function delRow(){
	if(checkChoose() == false){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		return;
	}else{
		if(isdel()){
			document.taskform.action = "RequestOperation.jsp";
			document.taskform.operationType.value="multideletetemplate";
			document.taskform.submit();
			enableAllmenu();
		}
	}
}

function checkChoose(){
	var flag = false;
	var ary = eval("document.taskform.checktask2");
	try{
		if(ary.length==null){
			if(ary.checked == true){
				flag = true;
				return flag;
			}
		}else{
			for(var i=0; i<ary.length; i++){
				if(ary[i].checked == true){
					flag = true;
					return flag;
				}
			}
		}
	}catch(e){
		return flag;
	}
	return flag;
}

function OnNew(){
	var wtid = document.taskform.wtid.value;
	openFullWindowForXtable("/worktask/request/AddWorktaskTemplateFrame.jsp?wtid="+wtid);
}
function changeOrder(obj, orderType, fieldname, fieldid){
	document.taskform.srcType.value="searchorder";
	document.getElementById("orderType").value = orderType;
	document.getElementById("orderFieldName").value = fieldname;
	document.getElementById("orderFieldid").value = fieldid;
	document.taskform.submit();
	enableAllmenu();
}

function doPrePage(){
	document.getElementById("pagenum").value = "<%=pagenum-1%>";
	document.getElementById("srcType").value = "changePage";
	document.taskform.submit();
	enableAllmenu();
}
function doNextPage(){
	document.getElementById("pagenum").value = "<%=pagenum+1%>";
	document.getElementById("srcType").value = "changePage";
	document.taskform.submit();
	enableAllmenu();
}
function doToFirstPage(){
	document.getElementById("pagenum").value = "1";
	document.getElementById("srcType").value = "changePage";
	document.taskform.submit();
	enableAllmenu();
}
function doToLastPage(){
	document.getElementById("pagenum").value = "<%=allPage%>";
	document.getElementById("srcType").value = "changePage";
	document.taskform.submit();
	enableAllmenu();
}
function doToCustomPage(customerpage){
	var customerpagestr = document.getElementById(customerpage).value;
	var customerpagenum = <%=pagenum%>;
	try{
		customerpagenum = parseInt(customerpagestr);
		if(isNaN(customerpagenum)){
			document.getElementById(customerpage).value = "<%=pagenum%>";
			return;
		}else{
			if(customerpagenum<=0 || customerpagenum><%=allPage%> || customerpagenum==<%=pagenum%>){
				document.getElementById(customerpage).value = "<%=pagenum%>";
				return;
			}
		}
		customerpagestr = ""+customerpagenum;
	}catch(e){
		document.getElementById(customerpage).value = "<%=pagenum%>";
		return;
	}
	document.getElementById("pagenum").value = customerpagestr;
	document.getElementById("srcType").value = "changePage";
	document.taskform.submit();
	enableAllmenu();
}

</script>
</HTML>

<script language="vbs">
sub changelevel(tmpindex)
 	document.taskform.check_con(tmpindex*1).checked = true
end sub

sub onShowBrowser2(id,url,type1)
    
          if type1=8 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=9 then
            tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=1 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=4 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=16 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			else type1=7 
			tmpids =document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
           end if
	//id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
			resourceids = id1(0)
			resourcename = id1(1)
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))	
			document.all("con"+id+"_valuespan").innerHtml =resourcename 
			document.all("con"+id+"_value").value=resourceids
			document.all("con"+id+"_name").value=resourcename
			else
			document.all("con"+id+"_valuespan").innerHtml = empty
			document.all("con"+id+"_value").value=""
			document.all("con"+id+"_name").value=""
		 end if
		
end sub

sub onShowBrowser(id,url)

		id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
		        if id1(0)<> "" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub

sub onShowBrowser3(id,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,2,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,2,len(names))
					descs = Mid(descs,2,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
end sub

</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
