<%@ page language="java" contentType="text/html; charset=GBK" %>

 <%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="JavaScript" src="/js/weaver.js"></SCRIPT>
	</HEAD>
<%
	String currUserId = String.valueOf(user.getUID());  //用户ID
	String currUserType = user.getLogintype();  //用户类型
	String planName = Util.null2String(request.getParameter("planName"));  //日程名
	String urgentLevel = Util.null2String(request.getParameter("urgentLevel"));  //紧急程度
	String planType = Util.null2String(request.getParameter("planType"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planStatus"));  //状态  0：代办；1：完成；2、归档
	String createrID = Util.null2String(request.getParameter("createrID"));  //提交人
	//String receiveType = Util.null2String(request.getParameter("receiveType"));  //接受类型  1：人力资源 5：分部 2：部门
	//String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
	String beginDate = Util.null2String(request.getParameter("beginDate"));  //开始日期
	String endDate = Util.null2String(request.getParameter("endDate"));  //结束日期
	String beginDaten = Util.null2String(request.getParameter("beginDaten"));  //开始日期
	String endDaten = Util.null2String(request.getParameter("endDaten"));  //结束日期

	if (planStatus.equals("-1"))
	{
	    planStatus = "";
	}

	//1:workPlanSearch.doSearchExchanged
	//2:workPlanSearch.doSearchFinishRemind
	//其他：workPlanSearch.doSearch(currUserId, currUserType, planName, urgentLevel, planType, planStatus, 
	//							createrID, receiveID, crmIds, docIds, projectIds, requestIds, beginDate, endDate,
	//							String.valueOf(pageNum))
	
	String imagefilename = "/images/hdReport.gif";
	String titlename = SystemEnv.getHtmlLabelName(356,user.getLanguage()) + ":&nbsp;"
					 + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>


<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:doSearchAgain(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteWorkPlan(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
	
	if(rs.getDBType().equals("db2"))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=91,_self} " ;
	}
	else
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=91,_self} " ;
	}
	RCMenuHeight += RCMenuHeightStep ;
%>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
		<COL width="10">
		<COL width="">
		<COL width="10">
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
	<TR>
		<TD></TD>
		<TD valign="top">
			<TABLE class="Shadow">
				<TR>
					<TD valign="top">					
						<!--================== 搜索部分 ==================-->
						<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanMonitor.jsp">
						<input type="hidden" name="workPlanIDs" value="">
						<TABLE class=ViewForm>
							<COLGROUP>
								<COL width="10%">
								<COL width="17%">
								<COL width="5">
								<COL width="10%">
								<COL width="17%">
								<COL width="5%">
								<COL width="10%">
								<COL width="23%">
							<TBODY>
								<TR>
									<!--================== 标题 ==================-->	
							  		<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
							  		<TD class=field><INPUT class="InputStyle" maxlength="100" name="planName"></TD>							
									<TD>&nbsp;</TD>
									
									<!--================== 紧急程度 ==================-->
									<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
									<TD class=field>
										<SELECT name="urgentLevel">
											<OPTION value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
											<OPTION value="1"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
											<OPTION value="2"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
											<OPTION value="3"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
										</SELECT>
									</TD>
									<TD>&nbsp;</TD>
									
									<!--================== 日程类型 ==================-->
									<TD ><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TD>
									<TD class=field>
										<SELECT name="planType">
											<OPTION value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
										<%
								  			rs.executeSql("SELECT * FROM WorkPlanMonitor workPlanMonitor, WorkPlanType workPlanType WHERE workPlanMonitor.workPlanTypeId = workPlanType.workPlanTypeId AND workPlanMonitor.hrmID = " + currUserId + " ORDER BY workPlanType.displayOrder ASC");
								  			while(rs.next())
								  			{
								  		%>
								  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>"><%= Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
								  		<%
								  			}
								  		%>
										</SELECT>									
									</TD>
							 	</TR>
							   	<TR style="height:1px;">
							  		<TD class=Line colSpan=7></TD>
								</TR>
								
							 	<TR>
							 		<!--================== 状态 ==================-->
							  		<TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
							  		<TD class=field>
							  			<SELECT name="planStatus">
											<OPTION value="" selected><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
											<OPTION value="0"><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
											<OPTION value="1"><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
											<OPTION value="2"><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
										</SELECT>
							  		</TD>							
									<TD>&nbsp;</TD>
									
									<!--================== 提交人 ==================-->
									<TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
									<TD class=field>
									  	<INPUT  class="wuiBrowser" type=hidden name="createrID"
									  		_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									  		_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>">
									</TD>
									<TD>&nbsp;</TD>
									
									<!--================== 开始日期 结束日期 ==================-->
									<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%><br> <%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
								  	<TD class="Field">
										<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(beginDateSpan,beginDate)"></BUTTON> 
									  	<SPAN id="beginDateSpan" name="beginDateSpan"></SPAN> 
								  		<INPUT type="hidden" name="beginDate">  
								  		&nbsp;-&nbsp;&nbsp;
								  		<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(endDateSpan,endDate)"></BUTTON> 
								  		<SPAN id="endDateSpan" name="endDateSpan"></SPAN> 
									    <INPUT type="hidden" name="endDate">

										<br>

										<button type="button" class="Calendar" id="SelectBeginDaten" onclick="getDate(beginDateSpann,beginDaten)"></BUTTON> 
									  	<SPAN id="beginDateSpann" name="beginDateSpann"></SPAN> 
								  		<INPUT type="hidden" name="beginDaten">  
								  		&nbsp;-&nbsp;&nbsp;
								  		<button type="button" class="Calendar" id="SelectEndDaten" onclick="getDate(endDateSpann,endDaten)"></BUTTON> 
								  		<SPAN id="endDateSpann" name="endDateSpann"></SPAN> 
									    <INPUT type="hidden" name="endDaten">
									</TD>
							 	</TR>
							    <TR  style="height:1px;">
									<TD class=Line colSpan=7></TD>
							 	</TR>
							 	
							</TBODY>
						</TABLE>
						</FORM>		
							
						<!--================== 搜索结果列表 ==================-->
						<%
							String backFields = "workPlan.ID, workPlan.name, workPlan.urgentLevel, workPlan.type_n, workPlan.createrID, workPlan.status, workPlan.beginDate, workPlan.endDate, workPlan.createDate, workPlan.createTime";
							String sqlForm = "WorkPlan workPlan, WorkPlanMonitor workPlanMonitor";
							String sqlWhere = "WHERE workPlan.type_n = workPlanMonitor.workPlanTypeID AND workPlanMonitor.hrmID = " + currUserId;														
							String sqlSortWay = "workPlan.createDate DESC, workPlan.createTime DESC";
						    								
							if(!"".equals(planName) && null != planName)
							{
								planName=planName.replaceAll("\"","＂");
								planName=planName.replaceAll("'","＇");
							    sqlWhere += " AND workPlan.name LIKE '%" + planName + "%'";
							}
							if(!"".equals(urgentLevel) && null != urgentLevel)
							{
							    sqlWhere += " AND workPlan.urgentLevel = '" + urgentLevel + "'";
							}
							if(!"".equals(planType) && null != planType)
							{
							    sqlWhere += " AND workPlan.type_n = '" + planType + "'";
							}
							if(!"".equals(planStatus) && null != planStatus)
							{
							    sqlWhere += " AND workPlan.status = '" + planStatus + "'";
							}
							if(!"".equals(createrID) && null != createrID)
							{
							    sqlWhere += " AND workPlan.createrID = " + createrID;
							}
							
							/*if(!"".equals(receiveID) && null != receiveID)
							{									
							    sqlWhere += " AND (";
							    sqlWhere += " workPlan.resourceID = '" + receiveID + "'";
							    sqlWhere += " OR workPlan.resourceID LIKE '" + receiveID + ",%'";
							    sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + ",%'";
							    sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + "'";
							    sqlWhere += ")";														
							}*/
							
							if((!"".equals(beginDate) && null != beginDate) && ("".equals(endDate) || null == endDate))
							{
							    sqlWhere += " AND (workPlan.beginDate >= '" + beginDate;								    
							    sqlWhere += "' OR workPlan.beginDate IS NULL  or  workPlan.beginDate ='')";
							}
							else if(("".equals(beginDate) || null == beginDate) && (!"".equals(endDate) && null != endDate))
							{
							    sqlWhere += " AND (workPlan.beginDate <= '" + endDate + "' OR workPlan.beginDate IS NULL  or  workPlan.beginDate ='' ) ";
							}
							else if((!"".equals(beginDate) && null != beginDate) && (!"".equals(endDate) && null != endDate))
							{
						    	sqlWhere += " AND ((";							    	        
						    	sqlWhere += " workPlan.beginDate >= '" + beginDate;
						    	sqlWhere += "' AND workPlan.beginDate <= '" + endDate;
						    	sqlWhere += "') OR (";
						    	sqlWhere += "  (workPlan.beginDate IS NULL or  workPlan.beginDate ='')))";
							}

							if((!"".equals(beginDaten) && null != beginDaten) && ("".equals(endDaten) || null == endDaten))
							{
							    sqlWhere += " AND (workPlan.endDate >= '" + beginDaten;								    
							    sqlWhere += "' OR workPlan.endDate IS NULL  or  workPlan.endDate ='')";
							}
							else if(("".equals(beginDaten) || null == beginDaten) && (!"".equals(endDaten) && null != endDaten))
							{
							    sqlWhere += " AND (workPlan.endDate <= '" + endDaten + "' OR workPlan.endDate IS NULL  or  workPlan.endDate ='' ) ";
							}
							else if((!"".equals(beginDaten) && null != beginDaten) && (!"".equals(endDaten) && null != endDaten))
							{
						    	sqlWhere += " AND ((";							    	        
						    	sqlWhere += " workPlan.endDate >= '" + beginDaten;
						    	sqlWhere += "' AND workPlan.endDate <= '" + endDaten;
						    	sqlWhere += "') OR (";
						    	sqlWhere += "  (workPlan.endDate IS NULL or  workPlan.endDate ='')))";
							}												
                          // out.print(sqlWhere);
							String tableString=""+
								"<table pagesize=\"20\" tabletype=\"checkbox\">"+
							    "<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"workPlan.ID\" sqlsortway=\"" + sqlSortWay + "\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
							    "<head>"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(616,user.getLanguage())+"\" column=\"createrID\" orderkey=\"createrID\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getResourceName\" />"+							    
							    "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"ID\" otherpara=\"column:name+column:type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanName\"/>"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"urgentLevel\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getUrgentName\" />"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanType\"/>"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) + SystemEnv.getHtmlLabelName(602,user.getLanguage())+ "\" column=\"status\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getStatusName\"/>"+
							    "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"beginDate\" orderkey=\"beginDate\"/>"+
							    "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"endDate\" orderkey=\"endDate\"/>"+						    
							    "</head>"+
							    "</table>";
						%>
						
						<wea:SplitPageTag tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/> 

						</TBODY>
						</TABLE>
																																				
	 				</TD>
				</TR>		
			</TABLE>
			<%@ include file="/systeminfo/RightClickMenu.jsp" %>
			
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>

</BODY>
</HTML>

<SCRIPT language="JavaScript">
function doSearchAgain() 
{
	document.frmmain.submit();
}

function deleteWorkPlan()
{
	if(isdel()) 
	{
        document.frmmain.action='/system/systemmonitor/workplan/WorkPlanMonitorOperation.jsp';
        document.frmmain.workPlanIDs.value = _xtable_CheckedCheckboxId();
        document.frmmain.submit();
	}
}

function init()
{
	var planName = "<%= planName %>";
	var urgentLevel = "<%= urgentLevel %>";
	var planType = "<%= planType %>";
	var planStatus = "<%= planStatus %>";
	var createrID = "<%= createrID %>";
	var beginDate = "<%= beginDate %>";
	var endDate = "<%= endDate %>";
	var beginDaten = "<%= beginDaten %>";
	var endDaten = "<%= endDaten %>";
	/*================== 标题 ==================*/
	document.frmmain.planName.value = planName;

	/*================== 紧急程度 ==================*/
	for(var i = 0; i < document.frmmain.urgentLevel.length; i++)
	{	
		if(urgentLevel == document.frmmain.urgentLevel[i].value)
		{
			document.frmmain.urgentLevel.selectedIndex = i;
		}
	}
	
	/*================== 日程类型 ==================*/
	for(var i = 0; i < document.frmmain.planType.length; i++)
	{	
		if(planType == document.frmmain.planType[i].value)
		{
			document.frmmain.planType.selectedIndex = i;
		}
	}
	
	/*================== 状态 ==================*/
	for(var i = 0; i < document.frmmain.planStatus.length; i++)
	{	
		if(planStatus == document.frmmain.planStatus[i].value)
		{
			document.frmmain.planStatus.selectedIndex = i;
		}
	}
	
	/*================== 提交人 ==================*/	
	$GetEle("createrID").value = createrID;
	$($GetEle("createrIDSpan")).html("<A href=/hrm/resource/HrmResource.jsp?id=" + createrID + "><%= resourceComInfo.getResourcename(createrID) %>" + "</A>");
		
	/*================== 开始日期 ==================*/
	$GetEle("beginDate").value = beginDate;
	$($GetEle("beginDateSpan")).text(beginDate);
	
	/*================== 结束日期 ==================*/
	$GetEle("endDate").value = endDate;
	$($GetEle("endDateSpan")).text(endDate);
	/*================== 开始日期 ==================*/
	$GetEle("beginDaten").value = beginDaten;
	$($GetEle("beginDateSpann")).text( beginDaten);
	
	/*================== 结束日期 ==================*/
	$GetEle("endDaten").value = endDaten;
	$($GetEle("endDateSpann")).text(endDaten);
}
$(function(){
	init();
});
</SCRIPT>

<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>