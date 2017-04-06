<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanValuate" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.discuss.ExchangeHandler" %>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="meetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<HTML>
	<HEAD>
	<script type="text/javascript">
function toBreakWord(intLen, id){

 var obj=document.getElementsByName(id);
 for(var a =0;a<obj.length;a++){
 var strContent=obj[a].innerHTML;
 var strTemp="";
 while(strContent.length>intLen){
  strTemp+=strContent.substr(0,intLen)+"<br/>";
  strContent=strContent.substr(intLen,strContent.length);
 }
 strTemp+= strContent;
 obj[a].innerHTML=strTemp;
 }
 
}
  window.onload=function()
            {
                  toBreakWord(100,"hh");
                  
            }

</script>
	
		<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
	    <SCRIPT language="javascript" src="/js/weaver.js"></script>		
	</HEAD>

<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String workID = Util.null2String(request.getParameter("workid"));
	String userID = String.valueOf(user.getUID());
	String from = Util.null2String(request.getParameter("from"));
	boolean canView = false;
	boolean canEdit = false;

	//String temptable = WorkPlanShareBase.getTempTable(userID);
	String sql = "SELECT * FROM WorkPlanShareDetail WHERE workID = " + workID + " AND usertype = 1 AND userID = " + userID+" order by sharelevel desc";

	rs.executeSql(sql);
	//System.out.println(sql);

	if (rs.next()) 
	{
		canView = true;
	 	
		if (rs.getString("sharelevel").equals("2"))
		{
		    canEdit = true;
		}
	}

	if (!canView)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    PoppupRemindInfoUtil.updatePoppupRemindInfo(Util.getIntValue(userID),12,"0",Util.getIntValue(workID));
	PoppupRemindInfoUtil.updatePoppupRemindInfo(Util.getIntValue(userID),13,"0",Util.getIntValue(workID));
	boolean canFinish = false;
	boolean canValuate = false;
	boolean canConvert = false;

	String selectUser = Util.null2String(request.getParameter("selectuser"));
	String selectDate = Util.null2String(request.getParameter("selectdate"));
	String viewType = Util.null2String(request.getParameter("viewtype"));
	String workPlanType = Util.null2String(request.getParameter("workplantype"));
	String workPlanStatus = Util.null2String(request.getParameter("workplanstatus"));
	int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);

	String type_n = "";
	String workPlanTypeName = "" ;
	String planName = "" ;
	String memberIDs = "";
	String beginDate = "";
	String beginTime = "";
	String endDate = "";
	String endTime = "";
	String description = "";
	String requestIDs = "";
	String projectIDs = "";
	String taskIDs = "";
	String crmIDs = "";
	String docIDs = "";
	String meetingIDs = "";
	String status = "";
	String isRemind = "";
	String deleted = "";
	String createrID = "";
	String urgentLevel = "";
	int wakeTime = 0;
	String unitType = "1";
	float remindValue = 0;
	
	String remindType = "";  //日程提醒方式
	String remindBeforeStart = "";  //是否开始前提醒
	String remindBeforeEnd = "";  //是否结束前提醒
	String remindTimesBeforeStart = "";  //开始前提醒时间数
	String remindTimesBeforeEnd = "";  //结束前提醒时间数
	String remindDateBeforeStart = "";  //开始前提醒日期
	String remindTimeBeforeStart = "";  //开始前提醒时间
	String remindDateBeforeEnd = "";  //结束前提醒日期
	String remindTimeBeforeEnd = "";  //结束前提醒时间
	
	String hrmPerformanceCheckDetailTargetName = "";  //自定义考核叶子节点名称
	String createrType = ""; 
			
	sql = "SELECT a.*, hrmPerformanceCheckDetail.targetName FROM "
		+ " (SELECT workPlan.*, workPlanType.workPlanTypeName "
	    + " FROM WorkPlan workPlan, WorkPlanType workPlanType "
	    + " WHERE workPlan.type_n = workPlanType.workPlanTypeID "
	    + " AND workPlan.ID = " + workID
	    + " ) a "
	    + " LEFT JOIN HrmPerformanceCheckDetail hrmPerformanceCheckDetail "
	    + " ON a.hrmPerformanceCheckDetailID = hrmPerformanceCheckDetail.ID";

	rs.executeSql(sql);
	
	if (rs.next()) 
	{
	    type_n = Util.null2String(rs.getString("type_n"));
	    workPlanTypeName = Util.forHtml(Util.null2String(rs.getString("workPlanTypeName")));
		planName = Util.forHtml(Util.null2String(rs.getString("name")).replaceAll("'","\\'"));
		memberIDs = Util.null2String(rs.getString("resourceID"));
		beginDate = Util.null2String(rs.getString("begindate"));
		beginTime = Util.null2String(rs.getString("begintime"));
		endDate = Util.null2String(rs.getString("enddate"));
		endTime = Util.null2String(rs.getString("endtime"));
		description = Util.null2String(rs.getString("description")).replaceAll("'","\\'");
		if(description.indexOf("<br>")==-1)
			description = Util.forHtml(description);
		requestIDs = Util.null2String(rs.getString("requestID"));
		projectIDs = Util.null2String(rs.getString("projectID"));
		taskIDs = Util.null2String(rs.getString("taskID"));
		crmIDs = Util.null2String(rs.getString("crmID"));
		docIDs = Util.null2String(rs.getString("docID"));
		meetingIDs = Util.null2String(rs.getString("meetingID"));
		status = Util.null2String(rs.getString("status"));
		isRemind = Util.null2String(rs.getString("isremind"));
		wakeTime = Util.getIntValue(rs.getString("waketime"), 0);
		deleted = Util.null2String(rs.getString("deleted"));
		createrID = Util.null2String(rs.getString("createrID"));
		urgentLevel = Util.null2String(rs.getString("urgentLevel"));

		remindType = Util.null2String(rs.getString("remindType"));
		remindBeforeStart = Util.null2String(rs.getString("remindBeforeStart"));
		remindBeforeEnd = Util.null2String(rs.getString("remindBeforeEnd"));
		remindTimesBeforeStart = Util.null2String(rs.getString("remindTimesBeforeStart"));
		remindTimesBeforeEnd = Util.null2String(rs.getString("remindTimesBeforeEnd"));
		remindDateBeforeStart = Util.null2String(rs.getString("remindDateBeforeStart"));
		remindTimeBeforeStart = Util.null2String(rs.getString("remindTimeBeforeStart"));
		remindDateBeforeEnd = Util.null2String(rs.getString("remindDateBeforeEnd"));
		remindTimeBeforeEnd = Util.null2String(rs.getString("remindTimeBeforeEnd"));
		
		hrmPerformanceCheckDetailTargetName = Util.null2String(rs.getString("targetName"));
		createrType = Util.null2String(rs.getString("createrType"));
	}

	String valMembers = "";
	boolean existUnderling = false;
	if (status.equals("0"))
	{
		valMembers = memberIDs;
	}

	//判断是否存在下属
	if (status.equals("1")) 
	{
		WorkPlanValuate workPlanValuate = new WorkPlanValuate();
		workPlanValuate.setManager(Integer.parseInt(userID));
		valMembers = workPlanValuate.checkUnderling(memberIDs);
		if (valMembers != null)
		{
			existUnderling = true;
		}
	}

	if (status.equals("0") && (canEdit || memberIDs.indexOf(userID) != -1))
	{
		canFinish = true;
	}

	if (!status.equals("0"))
	{
		canEdit = false;
	}

	if (status.equals("1") && existUnderling && !type_n.equals("4"))
	{
	    canValuate = true;
	}

	if (type_n.equals("4") && status.equals("0") && userID.equals(createrID))
	{
	    canConvert = true;
	}

	String imagefilename = "/images/hdReport.gif";
	String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage()) + ":&nbsp;" + SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav ="";
	String needhelp ="";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	if (canFinish)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(22177,user.getLanguage())+",javascript:doFinish(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	if (canEdit) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;		
	}

	if (canConvert) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(17508,user.getLanguage())+",javascript:doConvert(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	if (status.equals("1") && existUnderling && type_n.equals("4")) 
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+",javascript:doValuate(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	if(createrID.equals(""+userID))
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doShare(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17480,user.getLanguage())+",javascript:onViewLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(17481,user.getLanguage())+",javascript:onEditLog(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javascript:window.close(),_self} " ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javascript:parent.window.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post">
	<INPUT type="hidden" name="method" value="view">
	<INPUT type="hidden" name="from" value="<%=from%>">
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="status" value="<%=status%>" >
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="workPlanType" value="<%=workPlanType%>">
	<INPUT type="hidden" name="workPlanStatus" value="<%=workPlanStatus%>">
	<INPUT type="hidden" name="pageNum" value="<%=pagenum%>">

	<INPUT type="hidden" name="valMembers">
	<INPUT type="hidden" name="valScores">
	
	<TABLE class="ViewForm">
        <COLGROUP>
			<COL wIDth="20%">
	  		<COL wIDth="80%">
	  		</COLGROUP>
        <TBODY>
        <TR class="Spacing" style="height:1px;">
        	<TD class="Line1" colSpan="2"></TD>
       	</TR>
       	
       	<!--================ 日程类型  ================-->
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TD>
          	<TD class="Field"><%= workPlanTypeName %></TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>

		<!--================ 日程标题  ================-->
		<TR>
        	<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
          	<TD class="Field"><%=planName%></TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>

		<!--================ 考核项  ================-->
		<!-- TR>
			<TD><%//=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></TD>
		  	<TD class="Field"><%//= hrmPerformanceCheckDetailTargetName %></TD>
		</TR>
		<TR>
			<TD class="Line" colSpan="2"></TD>
		</TR -->

		<!--================ 紧急程度  ================-->
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
          	<TD class="Field">
          	<%
          		if (urgentLevel.equals("1")) 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
		  	<%
		  		}
          		else if (urgentLevel.equals("2")) 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
		  	<%
		  		}
          		else 
          		{
          	%>
		  		<%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
		  	<%
		  		}
		  	%>
		  	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<!--================ 日程提醒方式  ================-->
		<TR>			
			<TD><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></TD>
			<TD class="Field">
			<%
				if("1".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
			<%
				}
				else if("2".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
			<%
				}
				else if("3".equals(remindType))
				{
			%>
				<%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			<%
				}
			%>
			</TD>			
		</TR>			
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<%
			if(!"1".equals(remindType))
			{
		%>
		<!--================= 日程提醒时间 =================-->
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></TD>
          	<TD class="Field">
     		<%
     			if("1".equals(remindBeforeStart))
     			{	int temmhour=Util.getIntValue(remindTimesBeforeStart,0)/60;
		            int temptinme=Util.getIntValue(remindTimesBeforeStart,0)%60;
     		%>
          		<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
                   <%= temmhour %>
				<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<%= temptinme %>
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				&nbsp&nbsp&nbsp
			<%
     			}
	     		if("1".equals(remindBeforeEnd))
	 			{   int temmhour=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		            int temptinme=Util.getIntValue(remindTimesBeforeEnd,0)%60;
			%>
				<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
				 <%= temmhour %>
				<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<%= temptinme %>
				<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			<%
	 			}
			%>
          	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>		
		<%
			}
		%>
		<%if (!user.getLogintype().equals("2")){ %>
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(787,user.getLanguage())%></TD>
          	<TD class="Field">
          		<%if(!createrType.equals("") && createrType.equals("1")){%>
          			<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=createrID%>" target='_blank'><%=resourceComInfo.getResourcename(createrID)%></A>
          		<%}else{%>
          			<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=createrID%>" target='_blank'><%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
          		<%}%>
          	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></TD>
          	<TD class="Field">
			<%
				if (!memberIDs.equals("")) 
				{
					ArrayList members = Util.TokenizerString(memberIDs,",");
					for (int i = 0; i < members.size(); i++) 
					{
			%>
					<%if(!createrType.equals("") && createrType.equals("1")){%>
          				<A style="CURSOR: hand;" href='/hrm/resource/HrmResource.jsp?id=<%=""+members.get(i)%>' target='_blank'><%=resourceComInfo.getResourcename(""+members.get(i))%></A>&nbsp;
	          		<%}else{%>
	          			<A style="CURSOR: hand;" href='/hrm/resource/HrmResource.jsp?id=<%=""+members.get(i)%>' target='_blank'><%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(""+members.get(i)),user.getLanguage())%></A>&nbsp;
	          		<%}%>
					
			<%		}
				}
			%>
		 	</TD>
        </TR>
        <%}else{ %>
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(787,user.getLanguage())%></TD>
          	<TD class="Field">
          	    <A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=createrID%>" target='_blank'>
					<%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
          	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></TD>
          	<TD class="Field">
			<A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=createrID%>" target='_blank'>
					<%=Util.toScreen(customerInfoComInfo.getCustomerInfoname(createrID),user.getLanguage())%></A>
		 	</TD>
        </TR>
        <%} %>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
        <TR>
			<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          		<TD class="Field"><%=beginDate%>&nbsp;&nbsp;&nbsp;<%=beginTime%>
		  	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          	<TD class="Field">
          		<%=endDate%>&nbsp;&nbsp;&nbsp;<%=endTime%>
		  	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
          	<TD class="Field" name="hh" style="word-wrap:break-word;word-break:break-all;" ><%=description%></TD>
        </TR>        
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<%if(isgoveproj==0){%>
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
          	<TD class="Field">
			<%
				if (!crmIDs.equals("")) 
				{
					ArrayList crms = Util.TokenizerString(crmIDs,",");
					for (int i = 0; i < crms.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=""+crms.get(i)%>' target='_blank'><%=customerInfoComInfo.getCustomerInfoname(""+crms.get(i))%></A>&nbsp;
			<%	
					}
				}
			%>
		  	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<%}%>
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          	<TD class="Field">
			<%
				if (!docIDs.equals(""))
				{
					ArrayList docs = Util.TokenizerString(docIDs,",");
					for (int i = 0; i < docs.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/docs/docs/DocDsp.jsp?id=<%=""+docs.get(i)%>' target='_blank'><%=docComInfo.getDocname(""+docs.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
		  	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<%if(isgoveproj==0){%>
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
			<TD class="Field">
			<%
				if (!projectIDs.equals("")) 
				{
					ArrayList projects = Util.TokenizerString(projectIDs,",");
					for (int i = 0; i < projects.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/proj/data/ViewProject.jsp?ProjID=<%=""+projects.get(i)%>' target='_blank'><%=projectInfoComInfo.getProjectInfoname(""+projects.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<TR>
			<td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></td>
			<TD class="Field">
			<%
				if (!taskIDs.equals("")&&!taskIDs.equals("0")) 
				{
					ArrayList tasks = Util.TokenizerString(taskIDs,",");
					for (int i = 0; i < tasks.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/proj/process/ViewTask.jsp?taskrecordid=<%=""+tasks.get(i)%>' target='_blank'><%=ProjectTaskApprovalDetail.getTaskSuject(tasks.get(i).toString())%>(<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(tasks.get(i).toString())%>)</A>&nbsp;
			<%
					}
				}
			%>
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<%}%>
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
			<TD class="Field">
			<%
				if (!requestIDs.equals("")) 
				{
					ArrayList requests = Util.TokenizerString(requestIDs,",");
					for (int i = 0; i < requests.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href="/workflow/request/ViewRequest.jsp?requestid=<%=requests.get(i)%>" target='_blank'><%=requestComInfo.getRequestname(""+requests.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(926,user.getLanguage())%></TD>
			<TD class="Field">
			<%
				if (!meetingIDs.equals("")) 
				{
					ArrayList meetings = Util.TokenizerString(meetingIDs,",");
					for (int i = 0; i < meetings.size(); i++) 
					{
			%>
					<A style="CURSOR: hand;" href='/meeting/data/ProcessMeeting.jsp?meetingid=<%=""+meetings.get(i)%>' target='_blank'><%=meetingComInfo.getMeetingInfoname(""+meetings.get(i))%></A>&nbsp;
			<%
					}
				}
			%>
		</TR>
		<TR style="height:1px;">
			<TD class="Line1" colSpan="2"></TD>
		</TR>
        </TBODY>
	</TABLE>
</FORM>


<!--================== 相关交流输入 ==================-->
<FORM ID="Exchange" name="Exchange" action="/discuss/ExchangeOperation.jsp" method="post">
	<INPUT type="hidden" name="method1" value="add">
    <INPUT type="hidden" name="types" value="WP">
	<INPUT type="hidden" name="sortid" value="<%=workID%>">
	
	<TABLE class="ViewForm" cellpadding="1">
	<COLGROUP>
        <COL wIDth="10%">
        <COL wIDth="90%">
	</COLGROUP>
		<!--================== 相关交流 ==================-->
      	<TR class="Title">
       		<TH><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>
       		<TD align="right">
				<button type="button"  type="button"  class="Btn" accessKey="S" onclick="doSave1()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
     		</TD>
      	</TR>

	    <TR>
    		<TD class="Field" colspan="2">
		  		<TEXTAREA class="InputStyle" onchange='checkinput("ExchangeInfo","ExchangeInfospan")' name="ExchangeInfo" rows="3" style="width:1100px"></TEXTAREA><span  id=ExchangeInfospan><img src="/images/BacoError.gif" align=absmiddle></span>
		 	</TD>
		 	
	   	</TR>

		<!--================== 相关文档 ==================-->
       	<TR>
         	<TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          	<TD class="Field">
				<INPUT type="hidden" class="wuiBrowser" name="docids" value="" _param="documentids"
					_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>&nbsp"
					_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp">
		  	</TD>
        </TR>
        <TR style="height:1px;">
        	<TD class="Line" colSpan="2"></TD>
        </TR>
<%if(isgoveproj==0){%>
		<!--================== 相关客户 ==================-->
		<TR>
        	<TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
        	<TD class="Field">
				<INPUT type="hidden" class="wuiBrowser" name="excrmIDs" value="" _param="resourceids"
					_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
		  	</TD>
        </TR>
        <TR style="height:1px;">
        	<TD class="Line" colSpan="2"></TD>
        </TR>

		<!--================== 相关项目 ==================-->
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
          	<TD class="Field">
				<INPUT type="hidden" name="exPrjIDs" class="wuiBrowser" value=""
					_param="projectids"
					_displayTemplate="<A href=/proj/data/ViewProject.jsp?ProjID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp">
		  	</TD>
        </TR>
        <TR style="height:1px;">
        	<TD class="Line" colSpan="2"></TD>
        </TR>
<%}%>
		<!--================== 相关流程 ==================-->
		<TR>
         	<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
          	<TD class="Field">
				<INPUT type="hidden" name="exReqeustIDs" class="wuiBrowser" value="" 
					_param="resourceids"
					_displayTemplate="<A href=/workflow/request/ViewRequest.jsp?requestid=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp">
		  	</TD>
        </TR>
        <TR style="height:1px;">
        	<TD class="Line1" colSpan="2"></TD>
        </TR>
	</TABLE>
</FORM>

<BR>

<!--================== 相关交流列表 ==================-->
<TABLE class="ListStyle" cellspacing="1">
    <COLGROUP>
		<COL wIDth="12%">
		<COL wIDth="12%">
		<COL wIDth="12%">
      	<COL wIDth="16%">
		<COL wIDth="16%">
		<COL wIDth="16%">
		<COL wIDth="16%">
    <TBODY>
	    <TR class="Header">
			<TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
			<TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
			<TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
			<TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
			<%if(isgoveproj==0){%>
			<TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
			<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
			<%}%>
			<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
	    </TR>
<%
    boolean isLight = true;
    int nLogCount = 0;
    String[] data;
    String m_remark = "";
    String m_creater = "";
    String m_createrType = "";
    String m_createDate = "";
    String m_createTime = "";
    String m_docIDs = "";
    String m_crmIDs = "";
    String m_projectIDs = "";
    String m_requestIDs = "";

    ExchangeHandler exchangeHandler = new ExchangeHandler();
    ArrayList exchanges = exchangeHandler.getExchanges(workID, ExchangeHandler.EX_WORKPLAN);
    for (int i = 0; i < exchanges.size(); i++) 
    {
        data = (String[]) exchanges.get(i);

        m_remark = data[1];
        m_creater = data[2];
        m_createrType = data[3];
        m_createDate = data[4];
        m_createTime = data[5];
        m_docIDs = data[6];
        m_crmIDs = data[7];
        m_projectIDs = data[8];
        m_requestIDs = data[9];

		isLight = !isLight;

		nLogCount++;

		if (nLogCount == 4) 
		{
%>
	</TBODY>
</TABLE>

<DIV ID="WorkFlowDiv" style="display:none">
    <TABLE class="ListStyle" cellspacing="1">
      	<COLGROUP>
			<COL wIDth="12%">
	  		<COL wIDth="12%">
	  		<COL wIDth="12%">
	        <COL wIDth="16%">
			<COL wIDth="16%">
			<COL wIDth="16%">
			<COL wIDth="16%">
		</COLGROUP>
    	<TBODY>
<%
		}
%>
		<!--================== 相关交流：日期 时间 提交人 相关文档 相关客户 相关项目 相关流程  ==================-->
		<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
          	<TD><%=m_createDate%></TD>
          	<TD><%=m_createTime%></TD>
          	<TD>
		  	<%
		  		if (m_createrType.equals("1")) 
		  		{
		  	%>
		  		<A style="CURSOR: hand;" href="/hrm/resource/HrmResource.jsp?id=<%=m_creater%>" target='_blank'>
		  			<%=resourceComInfo.getResourcename(m_creater)%>
		  		</A>
		  	<%
		  		} 
		  		else 
		  		{
		  	%>
		  		<A style="CURSOR: hand;" href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=m_creater%>" target='_blank'>
		  			<%=customerInfoComInfo.getCustomerInfoname(m_creater)%></A>
		  	<%
		  		}
		  	%>
		  	</TD>
<%
		String docsName = "";
		if (!m_docIDs.equals("")) 
		{
		    ArrayList docs = Util.TokenizerString(m_docIDs, ",");
		
		    for (int j = 0; j < docs.size(); j++) 
		    {
		        docsName += "<A style='CURSOR: hand;' href='/docs/docs/DocDsp.jsp?id="+docs.get(j)+"' target='_blank'>"+docComInfo.getDocname(""+docs.get(j))+"</A>&nbsp;";
		    }
		}

 %>
            <TD><%=docsName%></TD>
<%if(isgoveproj==0){%>
<%
        String crmsName = "";
        if (!m_crmIDs.equals("")) 
        {
            ArrayList crms = Util.TokenizerString(m_crmIDs, ",");

            for (int j = 0; j < crms.size(); j++) 
            {
                crmsName += "<A style='CURSOR: hand;' href='/CRM/data/ViewCustomer.jsp?CustomerID="+crms.get(j)+"' target='_blank'>"+customerInfoComInfo.getCustomerInfoname(""+crms.get(j))+"</A>&nbsp;";
            }
        }

 %>
            <TD><%=crmsName%></TD>

<%
        String projectsName = "";
        if (!m_projectIDs.equals("")) 
        {
            ArrayList projects = Util.TokenizerString(m_projectIDs, ",");

            for (int j = 0; j < projects.size(); j++) 
            {
                projectsName += "<A style='CURSOR: hand;' href='/proj/data/ViewProject.jsp?ProjID="+projects.get(j)+"' target='_blank'>"+projectInfoComInfo.getProjectInfoname(""+projects.get(j))+"</A>&nbsp;";
            }
        }

 %>
            <TD><%=projectsName%></TD>
<%}%>
<%
        String requestsName = "";
        if (!m_requestIDs.equals("")) 
        {
            ArrayList requests = Util.TokenizerString(m_requestIDs,",");

            for (int j = 0; j < requests.size(); j++) 
            {
                requestsName += "<A style='CURSOR: hand;' href='/workflow/request/ViewRequest.jsp?requestid="+requests.get(j)+"' target='_blank'>"+requestComInfo.getRequestname(""+requests.get(j))+"</A>&nbsp;";
            }
        }

 %>
            <TD><%=requestsName%></TD>
        </TR>

		<!--================== 相关交流内容 ==================-->
		<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
        	<TD  name="hh" style="word-wrap:break-word;word-break:break-all;" colSpan="7"><%=m_remark%>
        	</TD>
        </TR>
<%
	}
%>
    </TBODY>
</TABLE>

<%
    if (nLogCount >= 4) 
    {
%>
</DIV>
<%
    }
%>
<TABLE class="ViewForm">
    <TR>
    <%
    	if (nLogCount >= 4) 
    	{
    %>
        <TD align="right">
        	<SPAN ID="WorkFlowspan">
				<A href="#" onClick="displaydiv_1()"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></A>
			</SPAN>
		</TD>
	<%
		}
	%>
  	</TR>
</TABLE>

<%
	//write "view" of view log.
	String[] logParams;
	WorkPlanLogMan logMan = new WorkPlanLogMan();
	logParams = new String[] 
	{
	        workID,
			WorkPlanLogMan.TP_VIEW,
			userID,
			request.getRemoteAddr()
	};
	
	logMan.writeViewLog(logParams);
	//end
	
	//reset the exchange flag.
	int[] viewParams = new int[] {Integer.parseInt(workID), Integer.parseInt(userID)};
	
	exchange.exchangeView(viewParams);
%>
<SCRIPT LANGUAGE="JavaScript">
function doEdit() {
	document.frmmain.action = "/workplan/data/WorkPlanEdit.jsp";
	document.frmmain.submit();
}

function goBack() {
	document.frmmain.action = "/workplan/data/WorkPlanView.jsp";
	document.frmmain.submit();
}

function doFinish() {
		<%if (userID.equals(createrID)) {%>
		document.all("method").value = "notefinish";
	    <%} else {%>
		document.all("method").value = "finish";
		<%}%>
		document.frmmain.submit();


}

function doValuate() {
    <%if (!type_n.equals("4")) {%>
	    onShowValuate();
    <%} else {%>
        document.all("method").value = "notefinish";
		document.frmmain.submit();
    <%}%>
}

function doConvert() {
	document.all("method").value = "convert";
	document.frmmain.submit();
}

function doDelete() {
	if (isdel()) {
		document.all("method").value = "delete";
		document.frmmain.submit();
	}
}

function doShare() {
	document.frmmain.action = "/workplan/share/WorkPlanShare.jsp?planID=<%=workID%>";
	document.frmmain.submit();
}

function doSave1() {
	if (check_form(document.Exchange,"ExchangeInfo"))
		document.Exchange.submit();
}

function displaydiv_1() {
	if (WorkFlowDiv.style.display == "") {
		WorkFlowDiv.style.display = "none";
		WorkFlowspan.innerHTML = "<a href='#' onClick='displaydiv_1()'><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
	} else {
		WorkFlowspan.innerHTML = "<a href='#' onClick='displaydiv_1()'><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowDiv.style.display = "";
	}
}

function onViewLog() {
	document.frmmain.action = "/workplan/log/WorkPlanViewLog.jsp";
	document.frmmain.submit();
}

function onEditLog() {
	document.frmmain.action = "/workplan/log/WorkPlanEditLog.jsp";
	document.frmmain.submit();
}
</SCRIPT>

</BODY>
</HTML>
