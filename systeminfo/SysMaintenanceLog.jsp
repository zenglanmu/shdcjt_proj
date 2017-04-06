<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>


<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="companyInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    String wflog=Util.null2String(request.getParameter("wflog"));
%>
<%


int secid = Util.getIntValue(request.getParameter("secid"),0);
String subname="";
if(secid != 0) subname = ":" + SystemEnv.getHtmlLabelName(secid,user.getLanguage());
String sql="";
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
boolean isLogView = HrmUserVarify.checkUserRight("LogView:View", user);

boolean isResourcesInfoSys = HrmUserVarify.checkUserRight("ResourcesInformationSystem:All", user);

// 如果是登录日志查看，需要检查是否有登录日志查看的权限 （刘煜修改）
if( ((sqlwhere.equals("")||(sqlwhere.indexOf("operateitem=60")>=0)) && !isLogView)||((sqlwhere.equals("")||(sqlwhere.indexOf("operateitem=89")>=0))&&!isResourcesInfoSys))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String subcomid = Util.null2String(request.getParameter("subcomid"));
String checkDeptId = Util.null2String(request.getParameter("checkDeptId"));

String resourceid = Util.null2String(request.getParameter("resourceid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
int start = Util.getIntValue(request.getParameter("start") ,1) ;
String linkstr;
    if(!ajax.equals("1"))
linkstr="SysMaintenanceLog.jsp?sqlwhere="+sqlwhere+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate ;
    else
linkstr="/systeminfo/SysMaintenanceLog.jsp?ajax=1&sqlwhere="+sqlwhere+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate ;


String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage())+subname;
String needfav ="";
String needhelp ="";
String subcompanyid=request.getParameter("subcompanyid");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
//String isNew = Util.null2String(request.getParameter("isNew"));
%>
<BODY>
<%if(!isfromtab ) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if(!ajax.equals("1"))
    {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSubmit(),_self}";
		RCMenuHeight += RCMenuHeightStep;
    }
    else
    {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:logsearch(),_self}";
		RCMenuHeight += RCMenuHeightStep;
    }
 	if(!isfromtab){
	if(sqlwhere.indexOf("operateitem=90") >= 0)
	//协作区退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCoworkBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=85") >= 0&&!wflog.equals("1"))
	//流程监控退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goWorkFlowMonitorBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=91") >= 0)
	//我的日程监控退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goWorkPlanMonitorBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=23") >= 0)
	//办公地点退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goOfficePlaceBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=24") >= 0)
	//职务类别按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDutyCategoryBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	
    else if(sqlwhere.indexOf("operateitem=25") >= 0)
	//职务设置退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDutySetBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
   else if(sqlwhere.indexOf("operateitem=26") >= 0)
	//岗位设置退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPostSetBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=93") >= 0)
	//奖惩管理退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPunishManagerBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=95") >= 0)
	//项目监控退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goItemManagerBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=94") >= 0)
	//奖惩种类退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goPunishTypeBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=96") >= 0)
	//考核项目退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCheckItem() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=97") >= 0)
	//考核种类退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCheckKind() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem =17")>=0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmScheduleDiffBack() ,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}
   else if(sqlwhere.indexOf("operateitem =79")>=0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmScheduleMaintanceBack() ,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem =13")>=0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmDefaultScheduleListBack() ,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem =21")>=0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goHrmPubHolidayBack() ,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem =75")>=0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDocMouldBack() ,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem =7")>=0)
	{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goDocSysDefaultsBack() ,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	}else if(sqlwhere.indexOf("operateitem=16 and relatedid=")>=0){//返回单个角色页面Tab1
		int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=16 and relatedid=")+"operateitem=16 and relatedid=".length()), 0);
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack1("+roleid_tmp+") ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if(sqlwhere.indexOf("operateitem=102 and relatedid=")>=0){//返回单个角色页面Tab2
		int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=102 and relatedid=")+"operateitem=102 and relatedid=".length()), 0);
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack2("+roleid_tmp+") ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if(sqlwhere.indexOf("operateitem=32 and relatedid=")>=0){//返回单个角色页面Tab3
//		int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=32 and relatedid=")+"operateitem=32 and relatedid=".length()), 0);
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1) ,_self} " ;
//		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack3("+roleid_tmp+") ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if(sqlwhere.indexOf("operateitem=103 and relatedid=")>=0){//返回单个角色页面Tab4
		int roleid_tmp = Util.getIntValue(sqlwhere.trim().substring(sqlwhere.trim().indexOf("operateitem=103 and relatedid=")+"operateitem=103 and relatedid=".length()), 0);
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleBack4("+roleid_tmp+") ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if(sqlwhere.indexOf("operateitem=16")>=0){//返回角色页面
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goRoleListBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=100") >= 0)
	//新闻设置类型退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goNewsTypeBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=101") >= 0)
	//网段策略退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goIpStrategyBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=45") >= 0)
	//单位设置-日志查询页面退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goLgcAssetUnitBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if(sqlwhere.indexOf("operateitem=44") >= 0)
	//类型设置-日志查询页面退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCptCapitalTypeBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(sqlwhere.indexOf("operateitem=51") >= 0)
	//资产资料维护-日志查询页面退回按钮
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goCptCapitalMaintenanceBack() ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	else if(!wflog.equals("1")){	
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1) ,_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
 	}
	RCMenu += "{EXCEL,javascript:exportExcel(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe>

<FORM id=SysMaintenanceLog name=SysMaintenanceLog action="/systeminfo/SysMaintenanceLog.jsp" method=post>

<%
if(ajax.equals("1")){
%>
<input type="hidden" id=ajax name="ajax" value="1">
<%}%>
<input type="hidden" id=sqlwhere name="sqlwhere" value="<%=sqlwhere%>">
	<input type="hidden" name="start" value=''>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<%if(!isfromtab ){ %>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

			<table class=ViewForm>
			  <colgroup> <col width="20%"> <col width="30%"> <col width="20%"> <col width="30%">
			  <tbody>
			  <tr class=Title>
				<th colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></th>
			  </tr>
			  <tr class=Spacing style="height: 1px!important;">
				<td class=Line1 colspan=4 ></td>
			  </tr>
			  <tr>
				<td><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></td>
				<td class=Field><BUTTON class=Browser type="button" id=SelectManagerID onClick="onShowResourceID('resourceid','resourceidspan')"></BUTTON>
				  <span id=resourceidspan><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></span>
				<INPUT class=saveHistory id=resourceid type=hidden name=resourceid value="<%=resourceid%>"></td>
				<td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
				<td class=Field>
					<%
					String branchName="";
					if (!subcomid.equals("")) {
					  
					  ArrayList branchIda=Util.TokenizerString(subcomid,",");
					  for (int i=0;i<branchIda.size();i++)
					  {
					  	branchName=branchName+"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+branchIda.get(i)+">"+SubCompanyComInfo.getSubCompanyname(""+branchIda.get(i))+"</a> ";
						 
					  }
					  
					}%>
				<INPUT class="wuiBrowser" _displayText="<%=branchName %>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=<%=subcomid%>" 
				 _displayTemplate="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id=#b{id}'>#b{name}</a>"
				 _callBack="onShowBranch"
				 type=hidden name=subcomid id="subcomid" value="<%=subcomid%>">
				
				</td>
			  </tr>
			  <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
			  <tr>
				<td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
				<td class=Field>
				<%
				  String deptName="";
				if (!checkDeptId.equals("")) {
				
				  ArrayList deptIda=Util.TokenizerString(checkDeptId,",");
				  for (int i=0;i<deptIda.size();i++)
				  {
				  deptName=deptName+"<a href=/hrm/company/HrmDepartmentDsp.jsp?id="+deptIda.get(i)+">"+DepartmentComInfo.getDepartmentname(""+deptIda.get(i))+"</a> ";
				  }
				  
				}%>
				<INPUT class="wuiBrowser" _displayText="<%=deptName %>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=<%=checkDeptId%>" 
				 _displayTemplate="<a href='/hrm/company/HrmDepartmentDsp.jsp?id=#b{id}'>#b{name}</a>"
				 _callBack="onShowDepartment"
				 type=hidden name=checkDeptId id="checkDeptId" value="<%=checkDeptId%>">
				 
				 <!--
					<BUTTON class=Browser type="button" id=SelectDepID onClick="onShowDepartment('checkDeptId','deptName')"></BUTTON>
					<INPUT class=saveHistory id=checkDeptId type=hidden name=checkDeptId value="<%=checkDeptId%>"></td>
				-->
				<td><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></td>
				<td class=Field><button class=calendar type="button" id=SelectDate onClick="gettheDate(fromdate,fromdatespan)"></button>&nbsp;
				  <span id=fromdatespan ><%=fromdate%></span> -&nbsp;&nbsp;<button class=calendar type="button"
				  id=SelectDate2 onClick="gettheDate(todate,todatespan)"></button>&nbsp; <span id=todatespan  ><%=todate%></span>
				  <input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
				  <input type="hidden" id=todate name="todate" value="<%=todate%>">
				</td>
			  </tr>
			  <TR style="height: 1px!important;"><TD class=Line colSpan=4></TD></TR>
			  </tbody>
			</table>
			<BR>
			
			<%
				String backFields = "id, relatedName, operateType, lableId, operateUserId, operateDate, operateTime, clientAddress";
				
				String sqlForm = "SysMaintenanceLog, SystemLogItem";
				if(sqlwhere.indexOf("operateitem=85")>=0 && !isLogView)
				//流程监控需要根据监控列表判断查看范围
				{
				    sqlForm += ", WorkFlow_Monitor_Bound";
				}
				else if(sqlwhere.indexOf("operateitem=91") >= 0)
				{
				    sqlForm += ", WorkPlanMonitor";
				}
								
				String sqlWhere = sqlwhere;
				sqlWhere += " AND SysMaintenanceLog.operateItem = SystemLogItem.itemId";
				if(sqlwhere.indexOf("operateitem=85")>=0 && !isLogView)
				//流程监控需要根据监控列表判断查看范围
				{
				    sqlWhere += " AND WorkFlow_Monitor_Bound.monitorHrmId = " + user.getUID() + " AND WorkFlow_Monitor_Bound.workFlowId = SysMaintenanceLog.relatedId";
				}
				else if(sqlwhere.indexOf("operateitem=91") >= 0)
				{
				    sqlWhere += " AND WorkPlanMonitor.hrmId = " + user.getUID() + " AND WorkPlanMonitor.workPlanTypeId = SysMaintenanceLog.relatedId";
				}
				
				String sqlOrderBy = "";
								
				if(!"".equals(resourceid))
				{
				    sqlWhere += " AND operateUserId = " + resourceid;
				}
				if(!"".equals(fromdate))
				{
				    sqlWhere += " and operateDate >= '" + fromdate + "'";				    
				}
				if(!"".equals(todate))
				{
				    sqlWhere += " and operateDate <= '" + todate + "'";
				}

				if(!"".equals(subcomid))
				{
				sqlWhere += " AND operateUserId in  (select id from hrmresource where subcompanyid1 in ("+subcomid+") ) ";
				}
				if(!"".equals(checkDeptId))
				{
				sqlWhere += " AND operateUserId in  (select id from hrmresource where departmentid in ("+checkDeptId+") ) ";
				}
 


				String tableString = ""+
				    "<table pagesize=\"20\" tabletype=\"none\">"+
				    "<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"id\" sqlorderby=\"" + "" + "\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />"+
				    "<head>"+
				    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(97, user.getLanguage())+"\" column=\"operateDate\" otherpara=\"column:operateTime\" transmethod=\"weaver.splitepage.transform.SptmForCowork.combineDateTime\" />"+	
					 "<col width=\"10%%\" text=\""+SystemEnv.getHtmlLabelName(16017, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForLog.getLoginName\"/>"+
					"<col width=\"10%%\" text=\""+SystemEnv.getHtmlLabelName(141, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForLog.getSubName\"/>"+
					  "<col width=\"10%%\" text=\""+SystemEnv.getHtmlLabelName(124, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForLog.getDepName\"/>"+
				    "<col width=\"10%%\" text=\""+SystemEnv.getHtmlLabelName(99, user.getLanguage())+"\" column=\"operateUserId\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getResourceName\"/>"+
					
				    "<col width=\"5%\" text=\""+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"\" column=\"operateType\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getTypeName\" />"+
				    "<col width=\"5%\" text=\""+SystemEnv.getHtmlLabelName(101, user.getLanguage())+"\" column=\"lableId\" otherpara=\"" + user.getLanguage() + "\" transmethod=\"weaver.splitepage.transform.SptmForCowork.getItemLableName\"/>"+
				    "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(106, user.getLanguage())+"\" column=\"relatedName\"/>"+
				    "<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(108, user.getLanguage())+SystemEnv.getHtmlLabelName(110, user.getLanguage())+"\" column=\"clientAddress\"/>"+
				    "</head>"+
				    "</table>";
			
			%>
			
			<!--================== 显示列表 ==================-->					
			<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/> 
			

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr  style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>
</form>
<%
	if(!ajax.equals("1"))
	{
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%
	}
	else
	{
%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%
	}
%>


<%if(!ajax.equals("1")){%>
<script language="javascript">

function onShowBranch(datas,e){
  if(datas){
     if(datas.id!=""){
       jQuery("#subcomid").val(datas.id.substr(1));
     }else{
       jQuery("#subcomid").val(""); 
     }    
  }
}

function onShowResourceID(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
		
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
	    		"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (datas) {
		if (datas.id!= "") {
			
			$("#"+spanname).html("<A href='javascript:openhrm("+datas.id+");' onclick='pointerXY(event);'>"+datas.name+"</A>");

			$("input[name="+inputname+"]").val(datas.id);
		}else{
			$("#"+spanname).html("");
			$("input[name="+inputname+"]").val("");
		}
	}
}

function onShowSubcompany(inputname,spanname)  {
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			_displayTemplate:"#b{name}",
			_displaySelector:"",
			_required:"no",
			_displayText:"",
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
		
	linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
    		"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
   if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
	    }
	    else	{
    	     $("#"+spanname).html("");
		    $("input[name="+inputname+"]").val("");
	    }
	}
}
function onShowDepartment(datas,e){
    if(datas){
     if(datas.id!=""){
       jQuery("#checkDeptId").val(datas.id.substr(1));
     }else{
       jQuery("#checkDeptId").val(""); 
     }    
  }
}

function exportExcel()
{
	document.getElementById("excels").src = "LogExcel.jsp?sqlwhere=<%=sqlWhere%>";
}

function OnSubmit()
{   
<%if(wflog.equals("1")){%>
    SysMaintenanceLog.action="/systeminfo/SysMaintenanceLog.jsp?wflog=1";
<%}%>    
	SysMaintenanceLog.submit();
}

function goCoworkBack()
{
	window.location = "/system/systemmonitor/cowork/CoworkMonitor.jsp";
}

function goWorkFlowMonitorBack()
{
	window.location = "/system/systemmonitor/workflow/WorkflowMonitor.jsp";
}

function goWorkPlanMonitorBack()
{
	window.location = "/system/systemmonitor/workplan/WorkPlanMonitor.jsp";
}

function goOfficePlaceBack()
{
	window.location = "/hrm/location/HrmLocation.jsp";
}
function goDutyCategoryBack() 
{
     window.location="/hrm/jobgroups/HrmJobGroups.jsp";
 }
 function goDutySetBack()
{
    window.location='/hrm/jobactivities/HrmJobActivities.jsp';
 }
 function goPostSetBack()
{
    window.location='/hrm/jobtitles/HrmJobTitles.jsp';
 }
 function goPunishManagerBack()
{
 window.location='/hrm/award/HrmAward.jsp';
 }
 function goPunishTypeBack()
{
 window.location='/hrm/award/HrmAwardType.jsp';
 }
 function goHrmScheduleDiffBack()
{
 window.location="/hrm/schedule/HrmScheduleDiff.jsp?subcompanyid=<%=subcompanyid%>";
 }
 function goHrmScheduleMaintanceBack()
{
 window.location="/hrm/schedule/HrmScheduleMaintance.jsp";
 }
function goHrmDefaultScheduleListBack()
{
window.location="/hrm/schedule/HrmDefaultScheduleList.jsp";
}
function goHrmPubHolidayBack()
{
window.location="/hrm/schedule/HrmPubHoliday.jsp";
}
function goDocSysDefaultsBack()
{
window.location="/docs/tools/DocSysDefaults.jsp";
}
function goItemManagerBack()
{
window.location="/system/systemmonitor/proj/ProjMonitor.jsp";
}
function goCheckItem()
{
window.location="/hrm/check/HrmCheckItem.jsp";
}
function goCheckKind()
{
window.location="/hrm/check/HrmCheckKind.jsp";
}
function goDocMouldBack()
{
window.location="/docs/mouldfile/DocMould.jsp";
}
function goNewsTypeBack()
{
window.location="/docs/news/type/newstypeList.jsp";
}
function goIpStrategyBack()
{
window.location="/hrm/tools/NetworkSegmentStrategy.jsp";
}
function goRoleListBack(){
	window.location="/hrm/roles/HrmRoles.jsp";
}
function goRoleBack1(roleid){
	window.location="/hrm/roles/HrmRolesEdit.jsp?id="+roleid;
}
function goRoleBack2(roleid){
	window.location="/hrm/roles/HrmRolesFucRightSet.jsp?id="+roleid;
}
//function goRoleBack3(roleid){
//	window.location="/hrm/roles/HrmRolesMembers.jsp?id="+roleid+"&type=0";
	//window.location="/hrm/roles/HrmRolesMembersEdit.jsp?id="+roleid;
//}
function goRoleBack4(roleid){
	window.location="/hrm/roles/HrmRolesStrRightSet.jsp?id="+roleid;
}
function goLgcAssetUnitBack()
{
window.location="/lgc/maintenance/LgcAssetUnit.jsp";
}
function goCptCapitalTypeBack()
{
	location.href = "/cpt/maintenance/CptCapitalType.jsp";
}
function goCptCapitalMaintenanceBack()
{
	history.back();
	//location.href = "/cpt/capital/CptCapitalMaintenance.jsp";
	//location.href = "/cpt/capital/CptCapMain_frm.jsp";
}
</script>
<%}%>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
