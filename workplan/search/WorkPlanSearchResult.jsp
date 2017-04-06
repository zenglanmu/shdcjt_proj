<%@ page language="java" contentType="text/html; charset=GBK" %>

 <%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="workPlanSearch" class="weaver.WorkPlan.WorkPlanSearch" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="JavaScript" src="/js/weaver.js"></SCRIPT>
	</HEAD>
<%
	String advanced = Util.null2String(request.getParameter("advanced"));  //1：被反馈  2：需要审批完成
	String currUserId = String.valueOf(user.getUID());  //用户ID
	String currUserType = user.getLogintype();  //用户类型
	String planName = Util.null2String(request.getParameter("planname"));  //日程名
	String urgentLevel = Util.null2String(request.getParameter("urgentlevel"));  //紧急程度
	String planType = Util.null2String(request.getParameter("plantype"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planstatus"));  //状态  0：代办；1：完成；2、归档
	String createrId = Util.null2String(request.getParameter("createrid"));  //提交人
	String receiveType = Util.null2String(request.getParameter("receiveType"));  //接受类型  1：人力资源 5：分部 2：部门
	String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
	String beginDate = Util.null2String(request.getParameter("begindate"));  //开始日期
	String endDate = Util.null2String(request.getParameter("enddate"));  //结束日期
	String beginDate2 = Util.null2String(request.getParameter("begindate2"));  //开始日期
	String endDate2 = Util.null2String(request.getParameter("enddate2"));  //结束日期
	String crmIds = Util.null2String(request.getParameter("crmids"));  //相关客户
	String docIds = Util.null2String(request.getParameter("docids"));  //相关文档
	String projectIds = Util.null2String(request.getParameter("prjids"));  //相关项目
	String requestIds = Util.null2String(request.getParameter("requestids"));  //相关流程

String from = Util.null2String(request.getParameter("from"));  //返回页面标记

	if (planStatus.equals("-1"))
	{
	    planStatus = "";
	}


	//1:workPlanSearch.doSearchExchanged
	//2:workPlanSearch.doSearchFinishRemind
	//其他：workPlanSearch.doSearch(currUserId, currUserType, planName, urgentLevel, planType, planStatus, 
	//							createrId, receiveID, crmIds, docIds, projectIds, requestIds, beginDate, endDate,
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:doSearchAgain(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;	

if(from.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
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
						<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanSearchResult.jsp">
							<INPUT type="hidden" name="advanced" value="<%=advanced%>">
							<INPUT type="hidden" name="planname" value="<%=planName%>">
							<INPUT type="hidden" name="urgentlevel" value="<%=urgentLevel%>">
							<INPUT type="hidden" name="plantype" value="<%=planType%>">
							<INPUT type="hidden" name="planstatus" value="<%=planStatus%>">
							<INPUT type="hidden" name="createrid" value="<%=createrId%>">
							<INPUT type="hidden" name="receiveID" value="<%=receiveID%>">
							<INPUT type="hidden" name="begindate" value="<%=beginDate%>">
							<INPUT type="hidden" name="enddate" value="<%=endDate%>">
							<INPUT type="hidden" name="begindate2" value="<%=beginDate2%>">
							<INPUT type="hidden" name="enddate2" value="<%=endDate2%>">
							<INPUT type="hidden" name="crmids" value="<%=crmIds%>">
							<INPUT type="hidden" name="docids" value="<%=docIds%>">
							<INPUT type="hidden" name="prjids" value="<%=projectIds%>">
							<INPUT type="hidden" name="requestids" value="<%=requestIds%>">
						</FORM>
						<%
							String backFields = "workPlan.ID, workPlan.name, workPlan.urgentLevel, workPlan.type_n, workPlan.createrID, workPlan.status, workPlan.beginDate, workPlan.beginTime, workPlan.endDate, workPlan.createDate, workPlan.createTime";
							String sqlForm = "";
							String sqlWhere = "";
							String sqlOrderBy = "workPlan.beginDate, workPlan.beginTime";
							
							if ("1".equals(advanced))
							//被反馈（从主页转入）
							{
							    sqlForm = "WorkPlan workPlan, WorkPlanExchange workPlanExchange";
							    sqlWhere = "WHERE workPlan.id = workPlanExchange.workPlanId"
							    	+ " AND ("
							    	+ " workPlan.createrID = " + currUserId
							    	+ " OR workPlan.resourceID LIKE '" + currUserId + ",%'"
							    	+ " OR workPlan.resourceID LIKE '%," + currUserId + ",%'"
							    	+ " OR workPlan.resourceID LIKE '%," + currUserId + "'"
							    	+ ")"
									+ " AND workPlan.createrType = " + currUserType
							    	+ " AND workPlanExchange.memberID = " + currUserId
							    	+ " AND workPlanExchange.exchangeCount > 0"
									+ " AND workPlanExchange.memberType = " + currUserType;								
							}
							else if ("2".equals(advanced))
							//需要审批完成（从主页转入）
							{						    
							    sqlForm = "WorkPlan workPlan, WorkPlanShareDetail workPlanShareDetail";
							    sqlWhere = "WHERE workPlan.ID = workPlanShareDetail.workID"
							        + " AND workPlan.status = '0'"
									+ " AND workPlan.finishRemind > 0"
									+ " AND workPlan.createrID = " + currUserId
									+ " AND workPlan.createrType = '" + currUserType + "'"
									+ " AND workPlanShareDetail.userID = " + currUserId
									+ " AND workPlanShareDetail.userType = " + currUserType;							    
							}
							else
							//从搜索页面进入
							{
							    sqlForm = "WorkPlan workPlan, WorkPlanShareDetail workPlanShareDetail";
							    sqlWhere = "WHERE workPlan.ID = workPlanShareDetail.workID"
							    	+ " AND workPlanShareDetail.userID = " + currUserId
									+ " AND workPlanShareDetail.userType = " + currUserType;
									
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
								if(!"".equals(createrId) && null != createrId)
								{
								    sqlWhere += " AND workPlan.createrid = " + createrId;
								}
								
								//日程类型 1：人力资源 5：分部 2：部门
								if(!"".equals(receiveID) && null != receiveID)
								{
									if("1".equals(receiveType))
									//人力资源
									{										
									    sqlWhere += " AND (";
									    sqlWhere += " workPlan.resourceID = '" + receiveID + "'";
									    sqlWhere += " OR workPlan.resourceID LIKE '" + receiveID + ",%'";
									    sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + ",%'";
									    sqlWhere += " OR workPlan.resourceID LIKE '%," + receiveID + "'";
									    sqlWhere += ")";							
									}
									else if("5".equals(receiveType))
									//分部
									{
										
									}
									else if("2".equals(receiveType))
									//部门
									{
									    
									}
								}
								
								if((!"".equals(beginDate) && null != beginDate))
								{
								    sqlWhere += " AND workPlan.beginDate >= '" + beginDate+ "'";								    
								   // sqlWhere += "' OR workPlan.endDate IS NULL)";
								}
								if((!"".equals(endDate) && null != endDate))
								{
								    sqlWhere += " AND workPlan.beginDate <= '" + endDate + "'";
								}
								if((!"".equals(beginDate2) && null != beginDate2))
								{
								    sqlWhere += " AND workPlan.endDate >= '" + beginDate2+ "'";								    
								   // sqlWhere += "' OR workPlan.endDate IS NULL)";
								}
								if((!"".equals(endDate2) && null != endDate2))
								{
								    sqlWhere += " AND workPlan.endDate <= '" + endDate2+ "'";								    
								   // sqlWhere += "' OR workPlan.endDate IS NULL)";
								}
								//相关客户
								if(!"".equals(crmIds) && null != crmIds)
								{
								    sqlWhere += " AND (";
								    sqlWhere += " workPlan.crmID = '" + crmIds + "'";
								    sqlWhere += " OR workPlan.crmID LIKE '" + crmIds + ",%'";
								    sqlWhere += " OR workPlan.crmID LIKE '%," + crmIds + ",%'";
								    sqlWhere += " OR workPlan.crmID LIKE '%," + crmIds + "'";
								    sqlWhere += ")";
								}
								
								//相关文档
								if(!"".equals(docIds) && null != docIds)
								{
								    sqlWhere += " AND (";
								    sqlWhere += " workPlan.docID = '" + docIds + "'";
								    sqlWhere += " OR workPlan.docID LIKE '" + docIds + ",%'";
								    sqlWhere += " OR workPlan.docID LIKE '%," + docIds + ",%'";
								    sqlWhere += " OR workPlan.docID LIKE '%," + docIds + "'";
								    sqlWhere += ")";
								}
								
								//相关项目
								if(!"".equals(projectIds) && null != projectIds)
								{
								    sqlWhere += " AND (";
								    sqlWhere += " workPlan.projectID = '" + projectIds + "'";
								    sqlWhere += " OR workPlan.projectID LIKE '" + projectIds + ",%'";
								    sqlWhere += " OR workPlan.projectID LIKE '%," + projectIds + ",%'";
								    sqlWhere += " OR workPlan.projectID LIKE '%," + projectIds + "'";
								    sqlWhere += ")";
								}
								
								//相关流程
								if(!"".equals(requestIds) && null != requestIds)
								{
								    sqlWhere += " AND (";
								    sqlWhere += " workPlan.requestID = '" + requestIds + "'";
								    sqlWhere += " OR workPlan.requestID LIKE '" + requestIds + ",%'";
								    sqlWhere += " OR workPlan.requestID LIKE '%," + requestIds + ",%'";
								    sqlWhere += " OR workPlan.requestID LIKE '%," + requestIds + "'";
								    sqlWhere += ")";
								}
							}
							String tableString=""+
							    "<table pagesize=\"20\" tabletype=\"none\">"+
							    "<sql backfields=\"" + backFields + "\" sqlform=\"" + sqlForm + "\" sqlprimarykey=\"workPlan.ID\" sqlorderby=\"" + sqlOrderBy + "\" sqlsortway=\"DESC\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />"+
							    "<head>"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(616,user.getLanguage())+"\" column=\"createrID\" orderkey=\"createrID\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getResourceName\" />"+							    
							    "<col width=\"20%%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"ID\" otherpara=\"column:name+column:type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanName\"/>"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"urgentLevel\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getUrgentName\" />"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanType\"/>"+
							    "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) + SystemEnv.getHtmlLabelName(602,user.getLanguage())+ "\" column=\"status\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getStatusName\"/>"+
							    "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"beginDate\" orderkey=\"beginDate\"/>"+
							    "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"endDate\" orderkey=\"endDate\"/>"+						    
							    "</head>"+
							    "</table>";
						%>
						
						<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/> 

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
	document.location.href = "WorkPlanSearchTerm.jsp";
}

function goBack() 
{
    doSearchAgain();
}
</SCRIPT>