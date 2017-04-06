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
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 9);
int isfirst = Util.getIntValue(request.getParameter("isfirst"), 0);

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
		isfirst = Util.getIntValue(fu.getParameter("isfirst"), 0);
	}
}

String checkStr = "";
int isfromleft = Util.getIntValue(request.getParameter("isfromleft"), 0);
WTSerachManager wtSerachManager = new WTSerachManager(wtid);
wtSerachManager.setLanguageID(user.getLanguage());
wtSerachManager.setType_d(type_d);
wtSerachManager.setObjid(objId);
wtSerachManager.setUserID(user.getUID());
wtSerachManager.setWorktaskStatus(worktaskStatus);
wtSerachManager.setIsfromleft(isfromleft);

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
Hashtable ret_hs_1 = wtSerachManager.getCheckPageSql();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
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
ArrayList wttypeList = (ArrayList)ret_hs_1.get("wttypeList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList widthList = (ArrayList)ret_hs_1.get("widthList");
ArrayList needorderList = (ArrayList)ret_hs_1.get("needorderList");
int listCount = Util.getIntValue(((String)ret_hs_1.get("listCount")), 0);
if(wtid == 0){//页面上沿计划任务类型选择框，如果选择所有类型，则必须多加一列“任务类型”
	listCount += 1;
}
listCount += 1;//一直显示任务状态

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

int perpage = wtSerachManager.getUserDefaultPerpage(false);
int pagenum = Util.getIntValue(fu.getParameter("pagenum"), 1);

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
RCMenu += "{"+SystemEnv.getHtmlLabelName(22046, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
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
<form name="taskform" method="post" action="RequestCheckList.jsp" enctype="multipart/form-data">
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
<input type="hidden" id="isfromleft" name="isfromleft" value="<%=isfromleft%>">
<input type="hidden" id="functionPage" name="functionPage" value="RequestCheckList.jsp" >
<input type="hidden" id="orderType" name="orderType" value="">
<input type="hidden" id="orderFieldName" name="orderFieldName" value="">
<input type="hidden" id="orderFieldid" name="orderFieldid" value="">
<input type="hidden" id="srcType" name="srcType" value="">
<input type="hidden" id="sqlWhere" name="sqlWhere" value="<%=sqlWhere%>">
<input type="hidden" id="pagenum" name="pagenum" value="<%=pagenum%>">
<TABLE  class=ListStyle cellspacing=1 id='monthHtmlTbl'>
	<COLGROUP>
	<COL width="100%">
	<TBODY>
	<TR >
	<td align="left">
		<div align="left">
			<BUTTON type=button  Class="btn_RequestSubmitList" type="button"  onclick="showorhiddenprop()"><span id="showhidden"><%=SystemEnv.getHtmlLabelName(21991, user.getLanguage())%></span></BUTTON>
	<%if (!type.equals("0")){
	if(type.equals("2")){//月
		for (int a=1;a<=12;a++){
	%>
		<a href="RequestCheckList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=a%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>">
		<%=a%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
		</a>&nbsp;
	<%}
	}else if (type.equals("1")){//季
		for (int a=1;a<=4;a++){
	%>
		<a href="RequestCheckList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&quarters=<%=a%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>">
		<%=a%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
		</a>&nbsp;
  <%}
  }else if (type.equals("3")){//周
  %>
	<select class=inputStyle id="weeks" name="weeks" onchange="javascript:location.href='RequestCheckList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&weeks='+this.value">
	<%for (int a=1;a<=56;a++){%>
		<option value="<%=a%>" <%if (weeks.equals(String.valueOf(a))) {%>selected<%}%>><%=a%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></option>
	<%}%>
	</select>
<%}else if("4".equals(type)){//日%>
		<BUTTON type=button  class=Calendar onclick="changeDays(daysspan, days)" ></BUTTON> 
		<SPAN id="daysspan">
		<%=days%></span> 
		<input type="hidden" name="days" id="days" value=<%=days%> >   
<%}%>
 <%}%>
 </div>
  </td>
  
  </tr>
 <TR class=Line><TD colspan="3" ></TD></TR> 
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
	<tr style="height:1px;"><td class="line1" style="margin:0;padding:0;"></td></tr> 
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
<TABLE class="ListStyle" cellspacing="1" id="oTable" name="oTable" style="width:<%=totalWidth%>px;margin:0px;">
	<COLGROUP>
	<%=colStr%>
	<TBODY>
	<TR class="Header" style="top:expression(this.offsetParent.scrollTop); z-index:9999; position:relative;">
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
		out.println("<th style=\"BORDER-LEFT:#ffffff 1px solid;cursor:hand\" onClick=\"changeOrder(this, '"+orderType_1+"', 'r.taskid', '-1')\" >"+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"&nbsp;"+orderTypeStr_1+"</th>");
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
	}
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
		String realStartDate = "";
		String realEndDate = "";
		String realDays = "";
		Hashtable backLog_hs = wtSerachManager.getBackLogs(operatorStr.toString());
		Hashtable checkLog_hs = wtSerachManager.getCheckLogs(operatorStr.toString());
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
			//int type_tmp = Util.getIntValue(rs2.getString("type"), 0);
			int taskid_tmp = Util.getIntValue(rs2.getString("taskid"), 0);
			int status_tmp = Util.getIntValue(rs2.getString("status"), -1);
			int checkorviewtype_tmp = Util.getIntValue(rs2.getString("checkorviewtype"), 0);
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
			out.println("<TD><INPUT type='checkbox'  name='checktask2' value='"+operatorid_tmp+"'><input type='hidden' name='operatorid_add' value='"+operatorid_tmp+"'><input type='hidden' name='requestid_"+operatorid_tmp+"' value='"+requestid_tmp+"'><input type='hidden' name='taskid_"+operatorid_tmp+"' value='"+taskid_tmp+"'><input type='hidden' name='liableperson_"+operatorid_tmp+"' value='"+liableperson_tmp+"'><input type='hidden' name='opttype_"+operatorid_tmp+"' value='"+opttype_tmp+"'></TD>");
			if(wtid == 0){
				out.println("<td>"+Util.null2String((String)worktaskName_hs.get("worktaskname_"+taskid_tmp))+"</td>");
			}
			out.println("<td>"+SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+status_tmp))), user.getLanguage())+"</td>");
			String checkStr1 = "";
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
				int width = Util.getIntValue((String)widthList.get(i), 6);
				int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
				int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
				//判断字段是否可以编辑，属性、验证字段不可编辑；任务完成不可编辑；createstatus、realstartdate、realenddate、realendtime、realstarttime默认只能当前责任人可编辑
				boolean canEdit = true;
				if("1".equals(wttype) || ("2".equals(wttype) && "createstatus".equalsIgnoreCase(fieldname_tmp))){
					canEdit = false;
				}
				if(ismand_tmp == 1 && !"4".equals(fieldhtmltype_tmp) && canEdit == true){
					checkStr1 += (",field" + fieldid_tmp + "_"+operatorid_tmp);
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
				if("3".equals(wttype)){//修改验证字段最后一次验证记录的值会同时显示出来
					value_tmp = "";
				}
				String valueStr = "";
				if("taskcontent".equals(fieldname_tmp) && !"".equals(value_tmp.trim())){//系统字段 taskcontent，用于添加进入单个计划任务页面
					String iconStr = sptmForWorktask.getWorktaskIcon(checkorviewtype_tmp, status_tmp);
					valueStr = "<a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktask.jsp?operatorid="+operatorid_tmp+"')\">"+value_tmp+"</a>"+iconStr;
				}else if("checkremark".equals(fieldname_tmp) && "3".equals(wttype)){
					valueStr = wtSerachManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, "2000", crmname_tmp, "1", type_tmp, isedit_tmp, ismand_tmp, "", operatorid_tmp);
					ArrayList checkLogList = (ArrayList)checkLog_hs.get("operatorid_"+operatorid_tmp);
					valueStr = wtSerachManager.getCheckRemark(valueStr, checkLogList, operatorid_tmp);
				}else if("backremark".equals(fieldname_tmp) && "2".equals(wttype)){
					valueStr = wtSerachManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, "2000", crmname_tmp, "1", type_tmp, 0, 0, value_tmp, operatorid_tmp);
					ArrayList backLogList = (ArrayList)backLog_hs.get("operatorid_"+operatorid_tmp);
					valueStr = wtSerachManager.getBackRemarkCheckPage(valueStr, backLogList, operatorid_tmp, fieldid_tmp, liableperson_tmp);
				}else{
					if(canEdit == false){
						valueStr = wtSerachManager.getFieldCellWithValueCheck(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, operatorid_tmp);
					}else{
						valueStr = wtSerachManager.getFieldCellWithValueCheck(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, operatorid_tmp);
					}
				}
				if(i == (fieldnameList.size()-1)){
					if(!"".equals(checkStr1)){
						checkStr1 = checkStr1.substring(1);
					}
					out.println("<td style=\"LEFT: 0px; WIDTH:"+width+"px;WORD-break:break-all;TEXT-VALIGN:center\"><input type='hidden' name='checkStr1_"+operatorid_tmp+"' value='"+checkStr1+"'>"+valueStr+"</td>");
				}else{
					out.println("<td style=\"LEFT: 0px; WIDTH:"+width+"px;WORD-break:break-all;TEXT-VALIGN:center\">"+valueStr+"</td>");
				}
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
	firstDiv.style.height = bodyheight - 15;
	firstDiv.style.width = worktaskBody.clientWidth - 15;
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
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	e.className = "Selected";
}
function browseTable_onmouseout(){
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
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
					location.href="/worktask/request/RequestCheckList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&days="+objinput.value;
				},
				oncleared:function(dp){
					$dp.$(objinput).value = "<%=currentDay%>";
					$dp.$(objspan).innerHTML = "<%=currentDay%>";
					location.href="/worktask/request/RequestCheckList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&days=<%=currentDay%>";
				}
			}
		);
}
function onShowadvanceQuery(obj){
	var check = obj.checked;
	if(check == false){
		$G("showadvanceQuery").style.display = "none";
	}else{
		$G("showadvanceQuery").style.display = "";
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
	var ary = eval("document.getElementsByName('checktask2')");
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
		document.taskform.operationType.value="multiCheck";
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
				if(checkStr1 == null || checkStr1 == ""){
					flag = true;
				}else{
					flag = check_form(document.taskform, checkStr1);
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
									if(document.getElementById("<%=realDays%>"+rowindex).type == "hidden"){
										document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = days;
									}
								}catch(e){}
							}else{
								document.getElementById("<%=realDays%>"+rowindex).value = 0;
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
									if(document.getElementById("<%=realDays%>"+rowindex).type == "hidden"){
										document.getElementById("<%=realDays%>"+rowindex+"span").innerHTML = 0;
									}
								}catch(e){}
							}catch(e){}
						}
					},
					oncleared:function(dp){
						$dp.$(objinput).value = "";
						if(ismand == 1){
							try{
								var createstatusName = document.getElementById("checkStr1_"+rowindex).value;
								var createstatus = document.getElementById(createstatusName).value;
								if(createstatus==0 || createstatus=='0'){
									$dp.$(objspan).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
								}else{
									$dp.$(objspan).innerHTML = "";
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
					}
				}
			);
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
</script>
</HTML>
<script type="text/javascript">
//<!--
function changelevel(tmpindex) {
 	document.getElementsByName("check_con")[tmpindex*1].checked = true;
}

function onShowBrowser2(id,url,type1) {
	var tmpids = null;
	var id1 = null;
    if (type1 == 8) {
	    tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
    } else if ( type1 == 9) {
	  	tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if ( type1 == 1 ) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if ( type1 == 4 ) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if ( type1 == 16 ) {
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if( type1 == 7) { 
		tmpids = $G("con"+id+"_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	
	if (id1 != null && id1 != undefined) {

		var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		var rname = wuiUtil.getJsonValueByIndex(id1, 1);

		if (rid != "") {
			resourceids = rid.substr(1);
			resourcename = rname.substr(1);
			
			$G("con"+id+"_valuespan").innerHTML =resourcename; 
			$G("con"+id+"_value").value = resourceids;
			$G("con"+id+"_name").value = resourcename;
		} else {
			$G("con"+id+"_valuespan").innerHTML = "";
			$G("con"+id+"_value").value = "";
			$G("con"+id+"_name").value = "";
		}
	} 
}

function onShowBrowser(id,url) {
	var id1 = window.showModalDialog(url)
	if (id1 != null) {
	    var rid = wuiUtil.getJsonValueByIndex(id1, 0);
	    var rname = wuiUtil.getJsonValueByIndex(id1, 1);
	    if (rid != "") {
	    	$G("con"+id+"_valuespan").innerHTML = rname;
			$G("con"+id+"_value").value = rid;
			$G("con"+id+"_name").value = rname;
	    } else {
	    	$G("con"+id+"_valuespan").innerHTML = "";
	    	$G("con"+id+"_value").value = "";
	    	$G("con"+id+"_name").value = "";
	    }
	}
}

function onShowBrowser3(id,url,linkurl,type1,ismand){
	if(type1==2||type1 ==19){
	    spanname = "field"+id+"span";
	    inputname = "field"+id;
		if(type1 ==2)
		  onFlownoShowDate(spanname,inputname,ismand);
        else
	      onWorkFlowShowTime(spanname,inputname,ismand);
	}else{
		if(type1!=152 && type1 !=142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170)
		{
			id1 = window.showModalDialog(url);
		}else{
            if(type1==135){
			    tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?projectids="+tmpids)
			}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
                tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?selectedids="+tmpids);
			}else if(type1==37) {
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?documentids="+tmpids);
            }else if (type1==142){
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
            }else if( type1==165 || type1==166 || type1==167 || type1==168){
                //index=InStr(id,"_");
                index=id.indexOf("_");
	            if (index!=-1){
		            //Mid(id,1,index-1)
		            tmpids=uescape("?isdetail=1&fieldid="+substr(id,0,index-1)+"&resourceids="+document.all("field"+id).value)
		            id1 = window.showModalDialog(url+tmpids);
	            }else{
		            tmpids=uescape("?fieldid="+id+"&resourceids="+document.all("field"+id).value);
		            id1 = window.showModalDialog(url+tmpids);
	            }
            }else{
               tmpids = document.all("field"+id).value;
			   id1 = window.showModalDialog(url+"?resourceids="+tmpids);
			}
           }
		
		if(id1){
			if  (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) 
			{
				if (id1.id!==""  && id1.id!=="0"){
					resourceids = id1.id;
					resourcename = id1.name;
					sHtml = "";
					resourceidss =resourceids.substr(1);
					resourceids = resourceids.substr(1);

					resourcename =resourcename.substr(1);
					
					ids=resourceids.split(",");
					names=resourcename.split(",");
					for(var i=0;i<ids.length;i++){
					   if(ids[i]!="")
					      sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp";
					}
					//$GetEle("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id).value= resourceidss;
				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>";
					document.all("field"+id).value="";
				}
			}else{
			   if  (id1.id!=""  && id1.id!="0"){
                   if (type1==162){
				     ids = id1.id;
					names = id1.name;
					descs = wuiUtil.getJsonValueByIndex(id1,2);
					sHtml = "";
					ids =ids.substr(1);
					document.all("field"+id).value= ids;
					names =names.substr(1).split(",");
					descs =descs.substr(1).split(",");
					for(var i=0;i<names.length;i++){
					   sHtml = sHtml+"<a title='"+descs[i]+"' >"+names[i]+"</a>&nbsp";
					}
					document.all("field"+id+"span").innerHTML = sHtml;
					return;
				   }
				   if (type1==161){
				     name =wuiUtil.getJsonValueByIndex(id1,1);
					 desc = wuiUtil.getJsonValueByIndex(id1,2);
				     document.all("field"+id).value=wuiUtil.getJsonValueByIndex(id1,0);
					 sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp";
					 document.all("field"+id+"span").innerHTML = sHtml;
					 return;
				   }
			        if (linkurl == "") 
						document.all("field"+id+"span").innerHTML =wuiUtil.getJsonValueByIndex(id1,1);
					else
						document.all("field"+id+"span").innerHTML = "<a href="+linkurl+id1.id+" target='_blank'>"+id1.name+"</a>";
					document.all("field"+id).value=id1.id;

				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>"
					
					document.all("field"+id).value=""
				}
              }  			
		}
	 }	
}
//-->
</script>
<script language="vbs">

</script>
<!-- 


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
 -->
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js?rnd="+Math.random()></script>
