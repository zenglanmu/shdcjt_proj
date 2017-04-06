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
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<jsp:useBean id="sptmForWorktask" class="weaver.splitepage.transform.SptmForWorktask" scope="page" />
<%
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
int isfromleft = Util.getIntValue(request.getParameter("isfromleft"), 0);

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
		isfromleft = Util.getIntValue(fu.getParameter("isfromleft"), 0);
	}
}

String checkStr = "";

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
Hashtable ret_hs_1 = wtSerachManager.getApprovePageSql();
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
listCount += 1;//一直显示任务状态

//使用自定义查询时，时间限定无作用
if("search".equals(operationType)){
	createPageSql += sqlWhere;
}else{
	if(("searchorder".equals(srcType) || "changePage".equals(srcType)) && !"".equals(sqlWhere)){
		createPageSql += sqlWhere;
	}else{
		sqlWhere = wtSerachManager.getDateSql(type, years, quarters, months, weeks, days);
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

int perpage = wtSerachManager.getUserDefaultPerpage(false);
if(orderFieldid == 0){
	createPageSql += " order by requestid desc";
}else{
	createPageSql += " order by "+orderFieldName;
	if(orderType == 1){
		createPageSql += " desc";
	}else{
		createPageSql += " asc";
	}
}
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(142, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnReject(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javaScript:OnCancel(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+",javaScript:doEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

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
<form name="taskform" method="post" action="RequestApproveList.jsp" enctype="multipart/form-data">
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
<input type="hidden" id="editids" name="editids" >
<input type="hidden" id="isfromleft" name="isfromleft" value="<%=isfromleft%>">
<input type="hidden" id="functionPage" name="functionPage" value="RequestApproveList.jsp" >
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
			<BUTTON Class="btn_RequestSubmitList" type="button"  onclick="showorhiddenprop()"><span id="showhidden"><%=SystemEnv.getHtmlLabelName(21991, user.getLanguage())%></span></BUTTON>
	<%if (!type.equals("0")){
	if(type.equals("2")){//月
		for (int a=1;a<=12;a++){
	%>
		<a href="RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&months=<%=a%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>">
		<%=a%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
		</a>&nbsp;
	<%}
	}else if (type.equals("1")){//季
		for (int a=1;a<=4;a++){
	%>
		<a href="RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&quarters=<%=a%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>">
		<%=a%><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%>
		</a>&nbsp;
  <%}
  }else if (type.equals("3")){//周
  %>
	<select class=inputStyle id="weeks" name="weeks" onchange="javascript:location.href='RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&worktaskStatus=<%=worktaskStatus%>&weeks='+this.value+'&isfromleft=<%=isfromleft%>'">
	<%for (int a=1;a<=56;a++){%>
		<option value="<%=a%>" <%if (weeks.equals(String.valueOf(a))) {%>selected<%}%>><%=a%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></option>
	<%}%>
	</select>
<%}else if("4".equals(type)){//日%>
		<BUTTON class=Calendar type="button" onclick="changeDays(daysspan, days)" ></BUTTON> 
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
	<tr style="height:1px;"> <td class="line1" style="padding:0;"></td></tr> 
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
		if(pagenum > 1){
			for(int c=0; (c<(perpage*(pagenum-1)) && rs2.next()); c++){
				//
			}
		}
		int showCount = 0;
		String classStr = "DataDark";
		boolean trClass = true;
		while(rs2.next()){
			int requestid_tmp = Util.getIntValue(rs2.getString("requestid"), 0);
			int taskid_tmp = Util.getIntValue(rs2.getString("taskid"), 0);
			int approverequest = Util.getIntValue(rs2.getString("approverequest"), 0);
			if(requestid_tmp <= 0 ){
				continue;
			}
			showCount++;
			if(showCount > perpage){
				break;
			}
			out.println("<TR CLASS="+classStr+" onmouseover=\"browseTable_onmouseover(event)\" onmouseout=\"browseTable_onmouseout(event)\">");
			int status_tmp = Util.getIntValue(rs2.getString("status"), -1);
			//System.out.println("status_tmp = "+rs2.getString("status"));
			out.println("<TD><INPUT type='checkbox'  name='checktask2' value='"+requestid_tmp+"'><input type='hidden' name='requestid_add' value='"+requestid_tmp+"'><input type='hidden' name='taskid_"+requestid_tmp+"' value='"+taskid_tmp+"'><input type='hidden' name='approverequest_"+requestid_tmp+"' value='"+approverequest+"'></TD>");
			if(wtid == 0){
				out.println("<td>"+Util.null2String((String)worktaskName_hs.get("worktaskname_"+taskid_tmp))+"</td>");
			}
			out.println("<td>"+SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+status_tmp))), user.getLanguage())+"</td>");
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
					valueStr = "<a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktask.jsp?requestid="+requestid_tmp+"')\">"+valueStr+"</a>";
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
	<TR class="Line"><TD colspan="<%=(listCount+1)%>" style="padding:0;"></TD></TR>
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
	firstDiv.style.width = worktaskBody.clientWidth - 25;
	var tableWidth = parseInt(oTable.style.width);
	var divWidth = parseInt(firstDiv.style.width);
	if(tableWidth < divWidth){
		oTable.style.width = worktaskBody.clientWidth - 40;
	}else if(tableWidth != <%=totalWidth%>){
		oTable.style.width = <%=totalWidth%>;
	}
}
window.parent.parent.onHuidden();
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
					location.href="/worktask/request/RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&days="+objinput.value;
				},
				oncleared:function(dp){
					$dp.$(objinput).value = "<%=currentDay%>";
					$dp.$(objspan).innerHTML = "<%=currentDay%>";
					location.href="/worktask/request/RequestApproveList.jsp?wtid=<%=wtid%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&isfromleft=<%=isfromleft%>&worktaskStatus=<%=worktaskStatus%>&days=<%=currentDay%>";
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
function OnApprove(){
	if(checkChoose() == false){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		return;
	}
	document.taskform.action = "RequestOperation.jsp";
	document.taskform.operationType.value="multiApprove";
	document.taskform.submit();
	enableAllmenu();
}

function OnReject(){
	if(checkChoose() == false){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		return;
	}
	document.taskform.action = "RequestOperation.jsp";
	document.taskform.operationType.value="multiBack";
	document.taskform.submit();
	enableAllmenu();
}

function OnCancel(){
	if(checkChoose() == false){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		return;
	}else{
		if(iscancel()){
			document.taskform.action = "RequestOperation.jsp";
			document.taskform.operationType.value="multiCancel";
			document.taskform.submit();
			enableAllmenu();
		}
	}
}
function iscancel(){
	if(!confirm("<%=SystemEnv.getHtmlLabelName(22059, user.getLanguage())%>")){
		return false;
	}
	return true;
}

function doEdit(){
	try{
		var flag = false;
		var ary = eval("document.taskform.checktask2");
		if(ary.length==null){
			if(ary.checked == true){
				flag = true;
				document.taskform.editids.value = ary.value+",";
			}
		}else{
			for(var i=0; i<ary.length; i++){
				if(ary[i].checked == true){
					flag = true;
					document.taskform.editids.value += (ary[i].value+",");
				}
			}
		}
		//alert(flag);
		var editids = document.taskform.editids.value;
		if(flag == true){
			location.href = "RequestEditList.jsp?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&weeks=<%=weeks%>&months=<%=months%>&quarters=<%=quarters%>&days=<%=days%>&functionPage=RequestApproveList.jsp&isfromleft=<%=isfromleft%>&editids="+editids;
			enableAllmenu();
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
		}
	}catch(e){
		alert("<%=SystemEnv.getHtmlLabelName(22000, user.getLanguage())%>");
	}
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

<script language="vbs">



</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js?rnd="+Math.random()></script>
