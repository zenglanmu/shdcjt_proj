<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.text.*,weaver.file.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="weaver.worktask.bean.*" %>

<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
/*TD29457 设置td单元格边框线*/
.divTd {
	border:1px  solid  #d4e9e9; 
}
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<%
int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
session.setAttribute("relaterequest", "new");
String CurrentUser = ""+user.getUID();
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentDay = TimeUtil.getCurrentDateString();
String currentQuarter="";
String years = Util.null2String(request.getParameter("years"));
String months = Util.null2String(request.getParameter("months"));
String quarters = Util.null2String(request.getParameter("quarters"));
String weeks = Util.null2String(request.getParameter("weeks"));
String days = Util.null2String(request.getParameter("days"));
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(request.getParameter("type")); //周期
String type_d = Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(request.getParameter("operationType"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 0);

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
	sqlWhere = Util.null2String(fu.getParameter("sqlWhere"));
	operationType = Util.null2String(fu.getParameter("operationType"));
	if("search".equals(operationType) || "searchorder".equals(srcType) || "changePage".equals(srcType)){
		years = Util.null2String(fu.getParameter("years"));
		months = Util.null2String(fu.getParameter("months"));
		quarters = Util.null2String(fu.getParameter("quarters"));
		weeks = Util.null2String(fu.getParameter("weeks"));
		days = Util.null2String(fu.getParameter("days"));
		type = Util.null2String(fu.getParameter("type")); //周期
		wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
		worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
	}
}

String checkStr = "";

WTSerachManager wtSerachManager = new WTSerachManager(wtid);
wtSerachManager.setLanguageID(user.getLanguage());
wtSerachManager.setType_d(type_d);
wtSerachManager.setObjid(objId);
wtSerachManager.setUserID(user.getUID());
wtSerachManager.setWorktaskStatus(worktaskStatus);

if("search".equals(operationType)){
	Hashtable sql_hs = wtSerachManager.getSearchSqlStr(fu);
	sqlWhere = (String)sql_hs.get("sqlWhere");
}
//System.out.println("sqlWhere = " + sqlWhere);

String worktaskName = "";
String worktaskStatusName = "";
Hashtable worktaskName_hs = new Hashtable();
rs1.execute("select * from worktask_base");
while(rs1.next()){
	String id_tmp = Util.null2String(rs1.getString("id"));
	String worktaskName_tmp = Util.null2String(rs1.getString("name"));
	worktaskName_hs.put("worktaskname_"+id_tmp, worktaskName_tmp);
}
if(wtid > 0){
	worktaskName = Util.null2String((String)worktaskName_hs.get("worktaskname_"+wtid));
}
ArrayList wtsdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkTaskStatus");
ArrayList wtsdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkTaskStatus");
if(wtsdetailCodeList.contains(""+worktaskStatus)){
	worktaskStatusName = SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+worktaskStatus))), user.getLanguage());
}

String planDate="";

String strStatus = "";

if (objId.equals("")) {
	objId=CurrentUser;
	type = "0";
	type_d = "3";
}

if(weeks.equals("")){
	weeks = currentWeek;
}
if(months.equals("")){
	months = currentMonth;
}
if(days.equals("")){
	days = currentDay;
}
if (1<=Integer.parseInt(months)&& Integer.parseInt(months)<=3){
	currentQuarter="1";
}else if (4<=Integer.parseInt(months)&& Integer.parseInt(months)<=6){
	currentQuarter="2";
}else if (7<=Integer.parseInt(months)&& Integer.parseInt(months)<=9){
	currentQuarter="3";
}else if (10<=Integer.parseInt(months)&& Integer.parseInt(months)<=12){
	currentQuarter="4";
}
if (quarters.equals("")){
	quarters = currentQuarter;
}

if (type.equals("0")){
	planDate = years;
}else if (type.equals("2")){
	planDate=years+months;
}else if (type.equals("1")){
	planDate = years+quarters;
}else if (type.equals("3")){
	planDate = years+weeks;
}else if(type.equals("4")){
	planDate = days;
}

String createPageSql = "";
Hashtable ret_hs_1 = wtSerachManager.getExecutePageSql();
createPageSql = (String)ret_hs_1.get("createPageSql");
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList wttypeList = (ArrayList)ret_hs_1.get("wttypeList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList widthList = (ArrayList)ret_hs_1.get("widthList");
ArrayList needorderList = (ArrayList)ret_hs_1.get("needorderList");
int listCount = Util.getIntValue(((String)ret_hs_1.get("listCount")), 0);
if(wtid == 0){//页面上沿计划任务类型选择框，如果选择所有类型，则必须多加一列“任务类型”
	listCount += 1;
}
listCount += 1;//一直显示任务状态

//使用自定义查询时，时间限定无作用
if("search".equals(operationType)){
	createPageSql += sqlWhere;
}else{
	if(("searchorder".equals(srcType) || "changePage".equals(srcType)) && !"".equals(sqlWhere)){
		createPageSql += sqlWhere;
	}else{
		sqlWhere = wtSerachManager.getExecuteDateSql(type, years, quarters, months, weeks, days);
		createPageSql += sqlWhere;
	}
}
//System.out.println("createPageSql = " + createPageSql);

String pName1="";
pName1 = years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
if(type.equals("1")){
	 pName1 += quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());
}else if(type.equals("2")){
	pName1 += months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());
}else if(type.equals("3")){
	pName1+=weeks+SystemEnv.getHtmlLabelName(1926,user.getLanguage());
}else if(type.equals("4")){
	pName1 = days.substring(0, 4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+days.substring(5, 7)+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+days.substring(8, 10)+SystemEnv.getHtmlLabelName(390, user.getLanguage());
}
pName1 += (worktaskStatusName + worktaskName);
String pName = objName+pName1;

Hashtable hasShowRequest_hs = new Hashtable();
//导出到excel，初始化
ExcelSheet es = new ExcelSheet();
ExcelRow er = es.newExcelRow();


int perpage = wtSerachManager.getUserDefaultPerpage(false);
int pagenum = Util.getIntValue(fu.getParameter("pagenum"), 1);
if(orderFieldid == 0){
	createPageSql += " order by o.type asc, r.requestid desc";
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
String titlename = pName;
String imagefilename = "/images/hdHRM.gif";
%>

<BODY id="worktaskBody">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(22002, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{Excel , /weaver/weaver.file.ExcelOut, ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep;

if(pagenum > 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:doPrePage(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
}
if(allCount > (perpage*pagenum)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:doNextPage(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
}

%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border="0" frameborder="no" noresize="NORESIZE" height="0%" width="0%"></iframe>
<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="1">
<col width="">
<col width="1">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=ListStyle>
<tr>
<td valign="top">
<form name="taskform" method="post" action="RequestExecuteList.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" value="<%=wtid%>">
<input type="hidden" name="worktaskStatus" value="<%=worktaskStatus%>">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="planDate" value=<%=planDate%>>
<input type="hidden" name="pName1" value=<%=pName1%>>
<input type="hidden" name="ishidden" value="1" >
<input type="hidden" name="years" value="<%=years%>">
<input type="hidden" name="months" value="<%=months%>">
<input type="hidden" name="quarters" value="<%=quarters%>">
<input type="hidden" name="weeks" value="<%=weeks%>">
<input type="hidden" name="days" value="<%=days%>">
<input type="hidden" id="isCreate" name="isCreate" value="0">
<input type="hidden" id="nodesnum" name="nodesnum" value="1">
<input type="hidden" id="indexnum" name="indexnum" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="delids" name="delids" >
<input type="hidden" id="editids" name="editids" >
<input type="hidden" id="functionPage" name="functionPage" value="RequestExecuteList.jsp" >
<input type="hidden" id="orderType" name="orderType" value="">
<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
<input type="hidden" id="srcType" name="srcType" value="">
<input type="hidden" id="sqlWhere" name="sqlWhere" value="<%=sqlWhere%>">
<input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>">
<TABLE class="ListStyle" cellspacing="1" id="monthHtmlTbl">
	<COLGROUP>
	<COL width="100%">
	<TBODY>
	<TR >
	<td align="left">
		<div align="left">
			<BUTTON Class="btn_RequestSubmitList" type="button"  onclick="showorhiddenprop()"><span id="showhidden"><%=SystemEnv.getHtmlLabelName(21991, user.getLanguage())%></span></BUTTON>
	<%if (!type.equals("0")){
	if(type.equals("2")){//月
		for (int a=1;a<=12;a++){
	%>
		<a href="RequestExecuteList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=a%>&worktaskStatus=<%=worktaskStatus%>">
		<%=a%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
		</a>&nbsp;
	<%}
	}else if (type.equals("1")){//季
		for (int a=1;a<=4;a++){
	%>
		<a href="RequestExecuteList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&quarters=<%=a%>&worktaskStatus=<%=worktaskStatus%>">
		<%=a%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
		</a>&nbsp;
  <%}
  }else if (type.equals("3")){//周
  %>
	<select class=inputStyle id="weeks" name="weeks" onchange="javascript:location.href='RequestExecuteList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&worktaskStatus=<%=worktaskStatus%>&weeks='+this.value">
	<%for (int a=1;a<=56;a++){%>
		<option value="<%=a%>" <%if (weeks.equals(String.valueOf(a))) {%>selected<%}%>><%=a%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></option>
	<%}%>
	</select>
<%}else if("4".equals(type)){//日%>
		<BUTTON type="button" class=Calendar onclick="changeDays(daysspan, days)" ></BUTTON> 
		<SPAN id="daysspan">
		<%=days%></span> 
		<input type="hidden" name="days" id="days" value=<%=days%> >   
<%}%>
 <%}%>
 </div>
  </td>
  
  </tr>
 <TR class=Line><TD colspan="3" style="padding:0;"></TD></TR> 
</TBODY>
</TABLE>
<%
//生成自定义查询条件
Hashtable query_hs = wtSerachManager.getCrmSearchStr();
String queryStr = (String)query_hs.get("queryStr");
out.println(queryStr);
%>
</br>
<TABLE class="ListStyle" cellspacing="1" id="oTableBut">
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
	<tr style="height:1px;"><td class="line1" style="padding:0;"></td></tr> 
	</TBODY>
</TABLE>
<%
int totalWidth = 25;
String colStr = "<COL width=\"25\">\n";
if(wtid == 0){
	totalWidth += 80;
	colStr += "<COL width=\"80\">\n";
}
totalWidth += 80;
colStr += "<COL width=\"80\">\n";
for(int cx=0; cx<widthList.size(); cx++){
	int width = Util.getIntValue((String)widthList.get(cx), 80);
	totalWidth += width;
	colStr += "<COL width=\""+width+"\">\n";
}
%>
<div id="firstDiv" name="firstDiv" style="width:100%;overflow-x:auto;height=300px;overflow-y:auto;">
<TABLE class="ListStyle" cellspacing="0" id="oTable" name="oTable" style="width:<%=totalWidth%>px;margin:0px;margin:0px;">
	<COLGROUP>
	<%=colStr%>
	<TBODY>
	<TR class="Header" style="top:expression(this.offsetParent.scrollTop); z-index:9999; position:relative;">
	<th>
		<div>
			<input type="checkbox" name="chooseAll" onClick="onChooseAll(this)">
		</div>
		<div id="iframediv1" name="iframediv1" style="z-index:-1;position:absolute;padding:0px;top:0px;">
			<iframe frameborder="no" scrolling="no" marginHeight="0" marginWidth="0" border="0" style="z-index:-1;position:absolute;width:800;height:20%"></iframe>
		</div>
	</th>
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
		out.println("<th style=\"BORDER-LEFT:#ffffff 1px solid;cursor:hand\" onClick=\"changeOrder(this, '"+orderType_1+"', 'r.taskid', '-1')\" >"+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"&nbsp;"+orderTypeStr_1+"</th>");
		er.addStringValue(SystemEnv.getHtmlLabelName(63, user.getLanguage()));//导出到excel
	}
	int orderType_2 = 0;
	String orderTypeStr_2 = "";
	if(orderFieldid == -2){
		if(orderType == 0){
			orderType_2 = 1;
			orderTypeStr_2 = "<font style=\"font-family:webdings\"></font>";
		}else{
			orderType_2 = 0;
			orderTypeStr_2 = "<font style=\"font-family:webdings\"></font>";
		}
	}
	out.println("<th style=\"BORDER-LEFT:#ffffff 1px solid;cursor:hand\" onClick=\"changeOrder(this, '"+orderType_2+"', 'r.status', '-2')\" >"+SystemEnv.getHtmlLabelName(602, user.getLanguage())+"&nbsp;"+orderTypeStr_2+"</th>");
	er.addStringValue(SystemEnv.getHtmlLabelName(602, user.getLanguage()));//导出到excel
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
			orderStr = " style=\"BORDER-LEFT:#ffffff 1px solid;cursor:hand\" onClick=\"changeOrder(this, '"+orderType_tmp+"', 'r."+fieldname_tmp+"', '"+id_tmp+"')\" ";
		}else{
			orderStr = " style=\"BORDER-LEFT:#ffffff 1px solid\" ";
		}
		out.println("<th"+orderStr+">"+crmname_tmp+"&nbsp;"+orderTypeStr_tmp+"</th>");
		er.addStringValue(crmname_tmp);//导出到excel
	}
	es.addExcelRow(er);
	%>
	</TR>
	<TR class="Line" style="top:expression(this.offsetParent.scrollTop); z-index:9999; position:relative;"><TD colspan="<%=(listCount+1)%>" ></TD></TR>
	<%
		//列表数据查询开始
		//System.out.println(createPageSql);
		Hashtable operatorid_hs = new Hashtable();
		StringBuffer operatorStr = new StringBuffer();
		while(rs2.next()){
			int operatorid_tmp = Util.getIntValue(rs2.getString("operatorid"), 0);
			if(operatorid_tmp == 0){
				continue;
			}
			String operatorid_Str = Util.null2String((String)operatorid_hs.get("operatorid_"+operatorid_tmp));
			if("".equals(operatorid_Str.trim())){
				operatorStr.append(operatorid_tmp).append(",");
				operatorid_hs.put("operatorid_"+operatorid_tmp, "1");
			}
		}
		int planDaysTotal = 0;
		int realDaysTotal = 0;
		int planDaysTD = 0;
		int realDaysTD = 0;
		String realStartDate = "";
		String realEndDate = "";
		String realDays = "";
		Hashtable backLog_hs = wtSerachManager.getBackLogs(operatorStr.toString());
		Hashtable checkLog_hs = wtSerachManager.getCheckLogs(operatorStr.toString());
		Hashtable canExecuteOperator_hs = wtSerachManager.getCanExecuteOperator(operatorStr.toString());
		rs2.beforFirst();
		if(pagenum > 1){
			for(int c=0; (c<(perpage*(pagenum-1)) && rs2.next()); c++){
				//
			}
		}
		int showCount = 0;
		String classStr = "DataDark";
		boolean trClass = true;
		while(rs2.next()){
			int operatorid_tmp = Util.getIntValue(rs2.getString("operatorid"), 0);
			int requestid_tmp = Util.getIntValue(rs2.getString("requestid"), 0);
			int liableperson_tmp = Util.getIntValue(rs2.getString("liableperson"), 0);
			int viewtype_tmp = Util.getIntValue(rs2.getString("viewtype"), 0);
			int createrviewtype_tmp = Util.getIntValue(rs2.getString("createrviewtype"), 0);
			int checkorviewtype_tmp = Util.getIntValue(rs2.getString("checkorviewtype"), 0);
			int checkor_tmp = Util.getIntValue(rs2.getString("checkor_tmp"), 0);
			int needcheck_tmp = Util.getIntValue(rs2.getString("needcheck_tmp"), 0);
			int creater_tmp = Util.getIntValue(rs2.getString("creater_tmp"), 0);
			int taskid_tmp = Util.getIntValue(rs2.getString("taskid"), 0);
			int status_tmp = 0;//Util.getIntValue(rs2.getString("status"), -1);
			int sharelevel_tmp = (Util.null2String((String)canExecuteOperator_hs.get("operatorid_"+operatorid_tmp))).equals("1")?1:0;
			int optstatus_tmp = Util.getIntValue(rs2.getString("optstatus"), 0);
			if(liableperson_tmp != user.getUID()){
				viewtype_tmp = checkorviewtype_tmp;
				if(checkor_tmp==0 || needcheck_tmp==0 || checkor_tmp!=user.getUID()){
					viewtype_tmp = createrviewtype_tmp;
					if(creater_tmp != user.getUID()){
						viewtype_tmp = 0;
					}
				}
			}
			String planstartdate_tmp = Util.null2String(rs2.getString("planstartdate"));
			String realstartdate_tmp = Util.null2String(rs2.getString("realstartdate"));
			String remindnum = "";
			if("".equals(realstartdate_tmp)){
				remindnum = wtSerachManager.computerRemindNum(planstartdate_tmp);
			}else{
				remindnum = "0";
			}
			if(optstatus_tmp == 0){
				status_tmp = 6;
			}else if(optstatus_tmp == -1 || optstatus_tmp == 7){
				status_tmp = 7;
			}else if(optstatus_tmp == 8){
				status_tmp = 8;
			}else if(optstatus_tmp == 1){
				status_tmp = 9;
			}else if(optstatus_tmp == 2){
				status_tmp = 10;
			}
			if(requestid_tmp <= 0 || liableperson_tmp <= 0){
				continue;
			}
			String hs_has = Util.null2String((String)hasShowRequest_hs.get("hasShowRequest_"+requestid_tmp+"_"+liableperson_tmp));
			if("".equals(hs_has.trim())){
				hasShowRequest_hs.put("hasShowRequest_"+requestid_tmp+"_"+liableperson_tmp, "has");
			}else{
				continue;
			}
			showCount++;
			if(showCount > perpage){
				break;
			}
			out.println("<TR CLASS="+classStr+" onmouseover=\"browseTable_onmouseover()\" onmouseout=\"browseTable_onmouseout()\">");
			int opttype_tmp = 0;//非责任人本人提交
			if(user.getUID() == liableperson_tmp){
				opttype_tmp = 1;//责任人本人提交
			}
			if(sharelevel_tmp == 1 && (status_tmp==6 || status_tmp==7 || status_tmp==8)){//只有未完成且有反馈权限的才能反馈
				out.println("<TD class=\"divTd\"><INPUT type='checkbox'  name='checktask2' value='"+operatorid_tmp+"'><input type='hidden' name='operatorid_add' value='"+operatorid_tmp+"'><input type='hidden' name='requestid_"+operatorid_tmp+"' value='"+requestid_tmp+"'><input type='hidden' name='taskid_"+operatorid_tmp+"' value='"+taskid_tmp+"'><input type='hidden' name='liableperson_"+operatorid_tmp+"' value='"+liableperson_tmp+"'><input type='hidden' name='opttype_"+operatorid_tmp+"' value='"+opttype_tmp+"'></TD>");
			}else{
				out.println("<TD class=\"divTd\"><input type='hidden' name='operatorid_add' value='"+operatorid_tmp+"'></TD>");
			}
			er = es.newExcelRow();//导出到excel
			if(wtid == 0){
				out.println("<td class=\"divTd\">"+Util.null2String((String)worktaskName_hs.get("worktaskname_"+taskid_tmp))+"</td>");
				er.addStringValue(Util.null2String((String)worktaskName_hs.get("worktaskname_"+taskid_tmp)));//导出到excel
			}
			out.println("<td class=\"divTd\">"+SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+status_tmp))), user.getLanguage())+"</td>");
			er.addStringValue(SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+status_tmp))), user.getLanguage()));//导出到excel
			String checkStr1 = "";
			String checkStr2 = "";
			String checkStr3 = "";
			for(int i=0; i<fieldnameList.size(); i++){
				int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
				String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
				String value_tmp = rs2.getString(fieldname_tmp);
				int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
				String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
				String type_tmp = Util.null2String((String)typeList.get(i));
				String wttype = Util.null2String((String)wttypeList.get(i));
				String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
				String crmname_tmp = Util.null2String((String)crmnameList.get(i));
				int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
				int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
				int width = Util.getIntValue((String)widthList.get(i), 6);
				//判断字段是否可以编辑，属性、验证字段不可编辑；任务完成不可编辑；createstatus、realstartdate、realenddate、realendtime、realstarttime默认只能当前责任人可编辑
				boolean canEdit = true;
				if("1".equals(wttype) || "3".equals(wttype)){
					canEdit = false;
				}else if(sharelevel_tmp == 0 || status_tmp == 9 || status_tmp == 10){
					canEdit = false;
				}else if(user.getUID() != liableperson_tmp && ("createstatus".equalsIgnoreCase(fieldname_tmp) || "realstartdate".equalsIgnoreCase(fieldname_tmp) || "realenddate".equalsIgnoreCase(fieldname_tmp) || "realendtime".equalsIgnoreCase(fieldname_tmp) || "realstarttime".equalsIgnoreCase(fieldname_tmp) || "realdays".equalsIgnoreCase(fieldname_tmp))){
					canEdit = false;
				}
				if(ismand_tmp == 1 && !"4".equals(fieldhtmltype_tmp) && canEdit == true){
					//System.out.println("fieldname_tmp "+operatorid_tmp+" = " + fieldname_tmp);
					if("createstatus".equalsIgnoreCase(fieldname_tmp)){
						checkStr1 += ("field" + fieldid_tmp + "_"+operatorid_tmp);
					}else if("realenddate".equalsIgnoreCase(fieldname_tmp)){
						checkStr2 = ""+fieldid_tmp;
					}else{
						checkStr3 += (",field" + fieldid_tmp + "_"+operatorid_tmp);
					}
				}
				if("realstartdate".equalsIgnoreCase(fieldname_tmp)){
					realStartDate = "field" + fieldid_tmp + "_";
				}else if("realenddate".equalsIgnoreCase(fieldname_tmp)){
					realEndDate = "field" + fieldid_tmp + "_";
				}else if("realdays".equalsIgnoreCase(fieldname_tmp)){
					realDays = "field" + fieldid_tmp + "_";
					if("".equals(value_tmp.trim())){
						value_tmp = "0";
					}
				}
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
				if("2".equals(wttype) && (status_tmp!=9 && status_tmp!=10) && !"realstartdate".equalsIgnoreCase(fieldname_tmp) && !"realstarttime".equalsIgnoreCase(fieldname_tmp)){//修改执行反馈字段最后一次验证记录的值会同时显示出来
					value_tmp = "";
				}
				String valueStr = "";
				String cellStr = "";
				Hashtable ret_hs = null;
				if("remindnum".equalsIgnoreCase(fieldname_tmp)){
					value_tmp = remindnum;
					ret_hs = wtSerachManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, operatorid_tmp);
					cellStr = Util.null2String((String)ret_hs.get("cellStr"));
				}else if("taskcontent".equals(fieldname_tmp) && !"".equals(value_tmp.trim())){//系统字段 taskcontent，用于添加进入单个计划任务页面
					String iconStr = sptmForWorktask.getWorktaskIcon(viewtype_tmp, status_tmp);
					cellStr = "<a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktask.jsp?operatorid="+operatorid_tmp+"');\">"+value_tmp+"</a>"+iconStr;
					valueStr = value_tmp;
				}else if("backremark".equals(fieldname_tmp) && "2".equals(wttype) ){
					if(sharelevel_tmp == 1 && (optstatus_tmp <= 0 || optstatus_tmp == 7 || optstatus_tmp == 8)){
						valueStr = wtSerachManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, "2000", crmname_tmp, "1", type_tmp, isedit_tmp, ismand_tmp, "", operatorid_tmp);
					}
					ArrayList backLogList = (ArrayList)backLog_hs.get("operatorid_"+operatorid_tmp);
					cellStr = wtSerachManager.getBackRemark(valueStr, backLogList, operatorid_tmp);
					valueStr = wtSerachManager.getBackRemarkExcel(valueStr, backLogList, operatorid_tmp);
					//System.out.println("valueStr = " + valueStr);
				}else if("checkremark".equals(fieldname_tmp) && "3".equals(wttype)){
					ArrayList checkLogList = (ArrayList)checkLog_hs.get("operatorid_"+operatorid_tmp);
					cellStr = wtSerachManager.getCheckRemark(valueStr, checkLogList, operatorid_tmp);
					valueStr = wtSerachManager.getCheckRemarkExcel(valueStr, checkLogList, operatorid_tmp);
				}else{
					if("2".equals(wttype) && "realenddate".equalsIgnoreCase(fieldname_tmp) && (status_tmp==6 || status_tmp==7 || status_tmp==8)){
						value_tmp = "";
					}
					if(canEdit == false){
						ret_hs = wtSerachManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, operatorid_tmp);
						cellStr = Util.null2String((String)ret_hs.get("cellStr"));
						valueStr = Util.null2String((String)ret_hs.get("valueStr"));
					}else{
						ret_hs = wtSerachManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, operatorid_tmp);
						cellStr = Util.null2String((String)ret_hs.get("cellStr"));
						valueStr = Util.null2String((String)ret_hs.get("valueStr"));
					}
				}
				if(valueStr.indexOf("/images/BacoError.gif") > 0){
					valueStr = "";
				}
				valueStr = Util.toExcelData(valueStr);
				er.addStringValue(valueStr);
				if(i == (fieldnameList.size()-1)){
					if(!"".equals(checkStr3)){
						checkStr3 = checkStr3.substring(1);
					}
					out.println("<td class=\"divTd\" style=\"LEFT: 0px; WIDTH:"+width+"px;WORD-break:break-all;TEXT-VALIGN:center\"><input type='hidden' name='checkStr1_"+operatorid_tmp+"' value='"+checkStr1+"'><input type='hidden' name='checkStr2_"+operatorid_tmp+"' value='"+checkStr2+"'><input type='hidden' name='checkStr3_"+operatorid_tmp+"' value='"+checkStr3+"'>"+cellStr+"</td>");
				}else{
					out.println("<td class=\"divTd\" style=\"LEFT: 0px; WIDTH:"+width+"px;WORD-break:break-all;TEXT-VALIGN:center\">"+cellStr+"</td>");
				}
				//自动合计 计划工期、实际工期 Start
				//planDaysTD
				//realDaysTD
				if("plandays".equalsIgnoreCase(fieldname_tmp)){
					planDaysTD = listCount - fieldnameList.size() + i;
					planDaysTotal += (Util.getIntValue(value_tmp, 0));
				}else if("realdays".equalsIgnoreCase(fieldname_tmp)){
					realDaysTD = listCount - fieldnameList.size() + i;
					realDaysTotal += (Util.getIntValue(value_tmp, 0));
				}
				//自动合计 计划工期、实际工期 End
			}
			es.addExcelRow(er);//导出到excel
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
	<TR class="Line"><TD colspan="<%=(listCount+1)%>" padding:0;></TD></TR>
	<TR style="height=24px;BACKGROUND-COLOR: #EAEAEA">
		<TD class="divTd" colspan="2" align="center"><b><%=SystemEnv.getHtmlLabelName(358, user.getLanguage())%></b></TD>
		<%
			er = es.newExcelRow();//导出到excel
			er.addStringValue(SystemEnv.getHtmlLabelName(358, user.getLanguage()));
			er.addStringValue("");
			//System.out.println("planDaysTD = " + planDaysTD);
			//System.out.println("realDaysTD = " + realDaysTD);
			//System.out.println("listCount = " + listCount);
			for(int i=1; i<=(listCount-1); i++){
				if(i == planDaysTD){
					out.println("<TD class=\"divTd\" align=\"right\"><span id=\"planDaysTotal_span\" name=\"planDaysTotal_span\"><font color=\"#FF0000\">"+planDaysTotal+"</font></span></TD>");
				}else if(i == realDaysTD){
					out.println("<TD class=\"divTd\" align=\"right\"><span id=\"realDaysTotal_span\" name=\"realDaysTotal_span\"><font color=\"#FF0000\">"+realDaysTotal+"</font></span></TD>");
				}else{
					out.println("<TD class=\"divTd\"></TD>");
				}
				//导出到excel
				if(i == (planDaysTD-1)){
					er.addStringValue(""+planDaysTotal);
				}else if(i == (realDaysTD-1)){
					er.addStringValue(""+realDaysTotal);
				}else{
					er.addStringValue("");
				}
			}
			es.addExcelRow(er);//导出到excel
		%>
	</TR>
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
<%
ExcelFile.init();
ExcelFile.setFilename(pName);
ExcelFile.addSheet(pName, es) ;
%>
<script>
function setFirstDivHeight(){
	firstDiv.style.width = "100%";
	var bodyheight = worktaskBody.clientHeight;
	if(bodyheight > 94){
		bodyheight = bodyheight - 94;
	}
	firstDiv.style.height = bodyheight - 15;
	firstDiv.style.width = worktaskBody.clientWidth - 10;
	var tableWidth = parseInt(oTable.style.width);
	var divWidth = parseInt(firstDiv.style.width);
	if(tableWidth < divWidth){
		oTable.style.width = worktaskBody.clientWidth - 40;
	}else if(tableWidth != <%=totalWidth%>){
		oTable.style.width = <%=totalWidth%>;
	}
}
parent.parent.onHuidden();
setFirstDivHeight();
window.onresize = setFirstDivHeight;
function browseTable_onmouseover(){
	var e =$.event.fix(getEvent()).target;
	while(e.tagName != "TR"){
		e = $(e).parent()[0];
	}
	e.className = "Selected";
}
function browseTable_onmouseout(e){
	var e =$.event.fix(getEvent()).target;
	while(e.nodeName != "TR"){
		e = $(e).parent()[0];;
	}
	if(e.rowIndex%2==0){
		e.className = "DataDark";
	}else{
		e.className = "DataLight";
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
function changeDays(objspan, objinput){
	WdatePicker_changeDays(objspan, objinput);
}
function WdatePicker_changeDays(objspan, objinput){
	WdatePicker(
		{
			el:
				objspan,
				onpicked:function(dp){
					var returnvalue = dp.cal.getDateStr();
					$dp.$(objinput).value = returnvalue;
					location.href="/worktask/request/RequestExecuteList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&worktaskStatus=<%=worktaskStatus%>&days="+objinput.value;
				},
				oncleared:function(dp){
					$dp.$(objinput).value = "<%=currentDay%>";
					$dp.$(objspan).innerHTML = "<%=currentDay%>";
					location.href="/worktask/request/RequestExecuteList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&worktaskStatus=<%=worktaskStatus%>&days=<%=currentDay%>";
				}
			}
		);
}
function onShowadvanceQuery(obj){
	var check = obj.checked;
	if(check == false){
		document.all("showadvanceQuery").style.display = "none";
	}else{
		document.all("showadvanceQuery").style.display = "";
	}
}
function showorhiddenprop(obj){
	var ishidden = document.taskform.ishidden.value;
	if(ishidden == "1"){
		document.taskform.ishidden.value = "0";
		document.all("showhidden").innerHTML = "<%=SystemEnv.getHtmlLabelName(21992, user.getLanguage())%>";
		document.all("showquery").style.display = "";
	}else{
		document.taskform.ishidden.value = "1";
		document.all("showhidden").innerHTML = "<%=SystemEnv.getHtmlLabelName(21991, user.getLanguage())%>";
		document.all("showquery").style.display = "none";
		document.all("check_showadvanceQuery").checked = false;
		onShowadvanceQuery(document.all("check_showadvanceQuery"));
	}
	
}
function onSearch(){
	document.taskform.operationType.value="search";
	document.taskform.submit();
	enableAllmenu();
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
function OnSubmit(){
	//check_form_self();
	//alert(check_form_self());
	if(checkChoose() == false){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		return;
	}
	if(check_form_self()){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="multiExecute";
		document.taskform.submit();
		enableAllmenu();
	}
}
function check_form_self(){
	//check_form(document.taskform, document.all("needcheck").value);
	var flag = true;
	try{
		var chks = document.getElementsByName("checktask2");
		for (var i=0; i<chks.length; i++){
			var chk = chks[i];
			if (chk.checked){
				var operatorid = chk.value;
				var checkStr1 = document.getElementById("checkStr1_"+operatorid).value;
				var checkStr2 = document.getElementById("checkStr2_"+operatorid).value;
				var checkStr3 = document.getElementById("checkStr3_"+operatorid).value;
				if(checkStr3 == null || checkStr3 == ""){
					flag = true;
				}else{
					flag = check_form(document.taskform, checkStr3);
				}
				if(flag == false){
					return flag;
				}
				var createstatus = "1";
				try{
					createstatus = document.getElementById(checkStr1).value;
				}catch(e){}
				if(createstatus == '0'){
					flag = check_form(document.taskform, "field"+checkStr2+"_"+operatorid);
				}
				if(flag == false){
					return flag;
				}
			}
		}
	}catch(e){}
	return flag;
}
function changeEndDate(obj, operatorid){
	try{
		var checkStr2 = document.getElementById("checkStr2_"+operatorid).value;
		var realenddatespan = document.getElementById("field"+checkStr2+"_"+operatorid+"span");
		var realenddate = document.getElementById("field"+checkStr2+"_"+operatorid).value;
		if(obj.value == '0'){
			if(realenddate==null || realenddate==''){
				realenddatespan.innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
		}else{
			if(realenddate==null || realenddate==''){
				realenddatespan.innerHTML = "";
			}
		}
	}catch(e){}
}
function showHisLogs(id){

}
function onShowRealDateCompute(objinput, objspan, ismand, rowindex){
	WdatePicker_onShowRealDateCompute(objinput, objspan, ismand, rowindex);
}
function WdatePicker_onShowRealDateCompute(objinput, objspan, ismand, rowindex){
	WdatePicker(
	{       
	        el:objspan,
			onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();
				var oldValue = $dp.$(objinput).value;
				var oldinnerHTML = $dp.$(objspan).innerHTML;
				$dp.$(objinput).value = returnvalue;
				$dp.$(objspan).innerHTML = returnvalue;
				var oldRealDays = 0;
				try{
					var realStartDate = document.getElementById("<%=realStartDate%>"+rowindex).value;
					//alert(planStartDate);
					var realEndDate = document.getElementById("<%=realEndDate%>"+rowindex).value;
					try{
						if(realStartDate!=null && realStartDate!="" && realEndDate!=null && realEndDate!=""){
							if(realStartDate > realEndDate){
								alert(document.getElementById("<%=realEndDate%>"+rowindex).temptitle + "<%=SystemEnv.getHtmlLabelName(22269, user.getLanguage())%>" + document.getElementById("<%=realStartDate%>"+rowindex).temptitle + "<%=SystemEnv.getHtmlLabelName(22270, user.getLanguage())%>");
								$dp.$(objinput).value = oldValue;
								$dp.$(objspan).innerHTML = oldinnerHTML;
								return false;
							}
						}
					}catch(e){
					}
					if(realStartDate != null && realStartDate != "" && realEndDate != null && realEndDate != ""){
						var days = getnumber(realStartDate, realEndDate);
						document.getElementById("<%=realDays%>"+rowindex).value = days;
						try{
							document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = "";
						}catch(e){}
						try{
							if(document.getElementById("<%=realDays%>"+rowindex).type == "hidden"){
								document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = days;
							}
						}catch(e){}
					}else{
						document.getElementById("<%=realDays%>"+rowindex).value = 0;
						try{
							document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = "";
						}catch(e){}
						try{
							if(document.getElementById("<%=realDays%>"+rowindex).type == "hidden"){
								document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = 0;
							}
						}catch(e){}
					}
				}catch(e){
					try{
						document.getElementById("<%=realDays%>"+rowindex).value = 0;
						try{
							document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = "";
						}catch(e){}
						try{
							if(document.getElementById("<%=realDays%>"+rowindex).type == "hidden"){
								document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = 0;
							}
						}catch(e){}
					}catch(e){}
				}
				onChangeRealDaysTotal();
			},
			oncleared:function(dp){
				$dp.$(objinput).value = "";
				if(ismand == 1){
					try{
						if(objinput.name==("<%=realStartDate%>"+rowindex)){
							$dp.$(objspan).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
						}else{
							var createstatusName = document.getElementById("checkStr1_"+rowindex).value;
							var createstatus = document.getElementById(createstatusName).value;
							if(createstatus==0 || createstatus=='0'){
								$dp.$(objspan).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
							}else{
								$dp.$(objspan).innerHTML = "";
							}
						}
					}catch(e){
						$dp.$(objspan).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
					}
				}else{
					$dp.$(objspan).innerHTML = "";
				}
				try{
					document.getElementById("<%=realDays%>"+rowindex).value = 0;
					try{
						if(document.getElementById("<%=realDays%>"+rowindex).type == "hidden"){
							document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = 0;
						}
					}catch(e){}
				}catch(e){}
				onChangeRealDaysTotal();
			}
		}
	);

	//onShowFlowDate(spanname, inputname, ismand);
}
function onChangeRealDaysTotal(){
	var operatorid_adds = document.getElementsByName("operatorid_add");
	var realDaysTotal = 0;
	try{
		var i = 0;
		for(i=0; i<operatorid_adds.length; i++){
			try{
				var operatorid_add = operatorid_adds[i].value;
				var realDays = document.getElementById("<%=realDays%>"+operatorid_add).value;
				if(realDays == null || realDays == ""){
					realDays = "0";
				}
				realDaysTotal += parseInt(realDays);
			}catch(e){}
		}
		document.getElementById("realDaysTotal_span").innerHTML = ("<font color=\"#FF0000\">"+realDaysTotal+"</font>");
	}catch(e){}
}
function getnumber(date1,date2){
	//默认格式为"20030303",根据自己需要改格式和方法
	var year1 =  date1.substr(0,4);
	var year2 =  date2.substr(0,4);

	var month1 = date1.substr(5,2);
	var month2 = date2.substr(5,2);

	var day1 = date1.substr(8,2);
	var day2 = date2.substr(8,2);

	temp1 = year1+"/"+month1+"/"+day1;
	temp2 = year2+"/"+month2+"/"+day2;

	var dateaa= new Date(temp1); 
	var datebb = new Date(temp2); 
	var date = datebb.getTime() - dateaa.getTime(); 
	var time = Math.floor(date / (1000 * 60 * 60 * 24)+1);
	return time;
	//alert(time);
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


function changelevel(tmpindex){
	document.taskform.check_con[tmpindex*1].checked = true;
}


function onShowBrowser(id,url){
		datas = window.showModalDialog(url);
		if(datas){
		     if(datas.id!=""){
				$("#con"+id+"_valuespan").html(datas.name);
				$("input[name=con"+id+"_value]").val(datas.id);
				$("input[name=con"+id+"_name]").val(datas.name);
		     }else{
		    	$("#con"+id+"_valuespan").html("");
				$("input[name=con"+id+"_value]").val("");
				$("input[name=con"+id+"_name]").val("");
		     }
		}
}

function onShowBrowser2(id,url,type1){
	if(type1==8){
 		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?projectids="+tmpids)
	}else if(type1==9){
	  tmpids = document.all("con"+id+"_value").value
	  datas = window.showModalDialog(url+"?documentids="+tmpids)
	}else if(type1==1){
		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}else if(type1==4){
		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}else if(type1==16){
		tmpids = document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}else{
		 type1=7 
		tmpids =document.all("con"+id+"_value").value
		datas = window.showModalDialog(url+"?resourceids="+tmpids)
	}
	if(datas){
		if(datas.id){
			resourceids = datas.id
			resourcename = datas.name
			resourceids = resourceids.substr("1");
			resourcename = resourcename.substr("1");
			$("#con"+id+"_valuespan").html(resourcename); 
			$("input[name=con"+id+"_value]").val(resourceids);
			$("input[name=con"+id+"_name]").val(resourcename);
		}else{
			$("#con"+id+"_valuespan").html(""); 
			$("input[name=con"+id+"_value]").val("");
			$("input[name=con"+id+"_name]").val("");
		}
	}
	
}
</script>
</HTML>

<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js?rnd="+Math.random()></script>
