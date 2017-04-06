<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<!--<jsp:useBean id="WorkPlanShareBase" class="weaver.WorkPlan.WorkPlanShareBase" scope="page"/>-->
<HTML>
<HEAD>
	<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
	<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
	<STYLE>
		.vis1	{ visibility:"visible" }
		.vis2	{ visibility:"hidden" }
	</STYLE>
</HEAD>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String workID = Util.null2String(request.getParameter("workid"));
	String from = Util.null2String(request.getParameter("from"));
	String userID = String.valueOf(user.getUID());
	String userType = user.getLogintype();
	
	String logintype = user.getLogintype();
	int userid=user.getUID();
	String hrmid = Util.null2String(request.getParameter("hrmid"));
	boolean canView = false;
	boolean canEdit = false;

	//String temptable = WorkPlanShareBase.getTempTable(userID);
	String sql = "SELECT * FROM WorkPlanShareDetail WHERE workid = " + workID + " AND usertype = " + userType + " AND userid = " + String.valueOf(user.getUID())+" order by sharelevel desc ";

	rs.executeSql(sql);

	if (rs.next()) 
	{
		canView = true;
		if (rs.getString("sharelevel").equals("2"))
		{
			canEdit = true;	 
		}
	}

	if (!canEdit)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String selectUser = Util.null2String(request.getParameter("selectUser"));
	String selectDate = Util.null2String(request.getParameter("selectDate"));
	String viewType = Util.null2String(request.getParameter("viewType"));
	String workPlanType = Util.null2String(request.getParameter("workPlanType"));
	String workPlanStatus = Util.null2String(request.getParameter("workPlanStatus"));
	
	String type_n = "" ;
	String planName = "" ;
	String memberIDs = "";
	String beginDate = "";
	String beginTime = "";
	String endDate = "";
	String endTime = "";
	String description = "";
	String requestIDs = "";
	String projectIDs = "";
	String crmIDs = "";
	String docIDs = "";
	String taskIDs = "";
	String meetingIDs = "";
	String status = "";
	String isRemind = "";
	String deleted = "";
	String createrID = "";
	String createrType = "";
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
	
	String hrmPerformanceCheckDetailID = "";  //自定义考核叶子节点ID

	sql = "SELECT * FROM WorkPlan WHERE id = " + workID;
	
	rs.executeSql(sql);
	if (rs.next()) 
	{
		type_n = Util.null2String(rs.getString("type_n"));
		planName = Util.forHtml(Util.null2String(rs.getString("name")));
		memberIDs = Util.null2String(rs.getString("resourceID"));
		beginDate = Util.null2String(rs.getString("beginDate"));
		beginTime = Util.null2String(rs.getString("beginTime"));
		endDate = Util.null2String(rs.getString("endDate"));
		endTime = Util.null2String(rs.getString("endTime"));
		description = Util.null2String(rs.getString("description"));
    	if(description.indexOf("<br>")==-1)
			description = Util.forHtml(description);
		requestIDs = Util.null2String(rs.getString("requestID"));
		projectIDs = Util.null2String(rs.getString("projectID"));
		crmIDs = Util.null2String(rs.getString("crmID"));
		docIDs = Util.null2String(rs.getString("docID"));
		meetingIDs = Util.null2String(rs.getString("meetingID"));
		status = Util.null2String(rs.getString("status"));
		isRemind = Util.null2String(rs.getString("isRemind"));
		wakeTime = Util.getIntValue(rs.getString("wakeTime"), 0);
		deleted = Util.null2String(rs.getString("deleted"));
		createrID = Util.null2String(rs.getString("createrID"));
		urgentLevel = Util.null2String(rs.getString("urgentLevel"));
		createrType = Util.null2String(rs.getString("createrType"));
	    taskIDs = Util.null2String(rs.getString("taskID"));
	    
	    remindType = Util.null2String(rs.getString("remindType"));
		remindBeforeStart = Util.null2String(rs.getString("remindBeforeStart"));
		remindBeforeEnd = Util.null2String(rs.getString("remindBeforeEnd"));
		remindTimesBeforeStart = Util.null2String(rs.getString("remindTimesBeforeStart"));
		remindTimesBeforeEnd = Util.null2String(rs.getString("remindTimesBeforeEnd"));
		remindDateBeforeStart = Util.null2String(rs.getString("remindDateBeforeStart"));
		remindTimeBeforeStart = Util.null2String(rs.getString("remindTimeBeforeStart"));
		remindDateBeforeEnd = Util.null2String(rs.getString("remindDateBeforeEnd"));
		remindTimeBeforeEnd = Util.null2String(rs.getString("remindTimeBeforeEnd"));
		
		hrmPerformanceCheckDetailID = Util.null2String(String.valueOf(rs.getInt("hrmPerformanceCheckDetailID")));
	    
		if (isRemind.equals("2") && wakeTime > 0) 
		{
			BigDecimal b1 = new BigDecimal(wakeTime);
	
			if (wakeTime >= 1440) 
			{
				BigDecimal b2 = new BigDecimal("1440");
				remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
				unitType = "2";
			}
			else 
			{
				BigDecimal b2 = new BigDecimal("60");
				remindValue = b1.divide(b2, 1, BigDecimal.ROUND_HALF_UP).floatValue();
			}
		}
	}
	
	String imagefilename = "/images/hdReport.gif";
	String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) + ":&nbsp;"
					+ SystemEnv.getHtmlLabelName(2211,user.getLanguage());
	String needfav = "";
	String needhelp = "";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:goBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM name="frmmain" action="/workplan/data/WorkPlanOperation.jsp" method="post">
	<INPUT type="hidden" name="method" value="edit">
	<INPUT type="hidden" name="status" value="<%=status%>" >
	<INPUT type="hidden" name="workid" value="<%=workID%>">
	<INPUT type="hidden" name="from" value="<%=from%>">
	<INPUT type="hidden" name="selectDate" value="<%=selectDate%>">
	<INPUT type="hidden" name="selectUser" value="<%=selectUser%>">
	<INPUT type="hidden" name="viewType" value="<%=viewType%>">
	<INPUT type="hidden" name="meetingIDs" value="<%=meetingIDs%>">
	
	<TABLE class=ViewForm>
        <COLGROUP>
			<COL width="20%">
	  		<COL width="80%">
	    <TBODY>
        <TR class=Section>
            <TH colSpan=2></TH>
        </TR>
        
        <TR class=Spacing style="height:1px;">
        	<TD class=Line1 colSpan=2></TD>
        </TR>
        
        <!--================ 日程类型 ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></TD>
		  	<TD class="Field">
  			<%
  				if(1 <= Integer.parseInt(type_n) && Integer.parseInt(type_n) <= 6)
  				{
  			%>
  				<SELECT name="" disabled>
  			<%
		  			rs.executeSql("SELECT * FROM WorkPlanType WHERE workPlanTypeId = " + type_n);
		  			while(rs.next())
		  			{
	  		%>
	  				<OPTION value="<%= rs.getInt("workPlanTypeID") %>" selected><%= Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
	  		<%
	  				}
	  		%>
	  			</SELECT>
	  			<INPUT type=hidden name="workPlanType" value="<%= rs.getInt("workPlanTypeID") %>">
  			<%		  				    
  				}
  				else
  				{
  			%>
  				<SELECT name="workPlanType">
  			<%
	  				rs.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
  					  					  			
	  				while(rs.next())
	  				{
	  			    	String workPlanTypeID = String.valueOf(rs.getInt("workPlanTypeID"));
	  		%>
	  				<OPTION value="<%= workPlanTypeID %>" <% if(type_n.equals(workPlanTypeID)) { %> selected <% } %> ><%= Util.forHtml(rs.getString("workPlanTypeName")) %></OPTION>
	  		<%
	  				}
  				}
	  		%>
	  		</SELECT>
		  	</TD>
		</TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
        
        <!--================ 标题  ================-->
		<TR>
          	<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
          	<TD class=Field>
          		<INPUT class=INPUTStyle maxLength=100 size=30 name="planName" onchange="checkinput('planName','nameImage')" value="<%=planName%>">
          		<SPAN id=nameImage></SPAN>
          	</TD>
        </TR>   
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR>

		<!--================ 考核项  ================-->
		<!-- TR>
			<TD><%//=SystemEnv.getHtmlLabelName(18064,user.getLanguage())%></TD>
		  	<TD class="Field">
		  		<SELECT name="hrmPerformanceCheckDetailID">
		  			<OPTION value="-1" <%// if("-1".equals(hrmPerformanceCheckDetailID)) { %> selected <%// } %>></OPTION>
		  		<%
		  			//rs.executeSql("SELECT * FROM HrmPerformanceCheckDetail a WHERE NOT EXISTS(SELECT * FROM HrmPerformanceCheckDetail b WHERE a.ID = b.parentID) ORDER BY dePath");
		  			//while(rs.next())
		  			//{
		  			   // String ID = String.valueOf(rs.getInt("ID"));
		  		%>
		  			<OPTION value="<%//= ID %>" <%// if(ID.equals(hrmPerformanceCheckDetailID)) { %> selected <%// } %>><%//= rs.getString("targetName") %></OPTION>
		  		<%
		  			//}
		  		%>
		  		</SELECT>
		  	</TD>
		</TR>
		<TR>
			<TD class="Line" colSpan="2"></TD>
		</TR -->
		
		<!--================ 紧急程度  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="urgentLevel" <%if ("1".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="2" name="urgentLevel" <%if ("2".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
				&nbsp;&nbsp;
				<INPUT type="radio" value="3" name="urgentLevel" <%if ("3".equals(urgentLevel)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
			</TD>
		</TR>
			<TR style="height:1px;"><TD class="Line" colSpan="2"></TD>
		</TR>

		<!--================ 日程提醒方式  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if ("1".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
				<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if ("2".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
				<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if ("3".equals(remindType)) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>

		<!--================ 日程提醒时间  ================-->

		<%
		
		int temmhour=Util.getIntValue(remindTimesBeforeStart,0)/60;
		int temptinme=Util.getIntValue(remindTimesBeforeStart,0)%60;
		int temmhourend=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		int temptinmeend=Util.getIntValue(remindTimesBeforeEnd,0)%60;
		%>
		<TR id="remindTime" <% if("1".equals(remindType)) {%> style="display:none" <% } %>>
			<TD><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></TD>
			<TD class="Field">
				<INPUT type="checkbox" name="remindBeforeStart" value="1" <% if("1".equals(remindBeforeStart)) { %>checked<% } %>>
					<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindDateBeforeStart" onchange="checkint('remindDateBeforeStart')" size=5 value="<%= temmhour %> ">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="<%= temptinme %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
					&nbsp&nbsp&nbsp
				<INPUT type="checkbox" name="remindBeforeEnd" value="1" <% if("1".equals(remindBeforeEnd)) { %>checked<% } %>>

					<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%= temmhourend%>">
					<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="remindTimeBeforeEnd"  onchange="checkint('remindTimeBeforeEnd')" size=5 value="<%= temptinmeend %>">
					<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
			</TD>
		</TR>
		<TR id="remindTimeLine" <% if("1".equals(remindType)) {%> style="display:none" <% }else{%> style="height:1px;" <%} %>>
			<TD class="Line" colSpan="2"></TD>
		</TR>
		<TR id="reminddesc" <% if("1".equals(remindType)) {%> style="display:none" <% } %>>
			<TD></TD>
			<TD class="Field"><%=SystemEnv.getHtmlLabelName(24155,user.getLanguage())%></TD>
		</TR>
		<TR id="remindTimeLine1" <% if("1".equals(remindType)) {%> style="display:none" <% }else{%> style="height:1px;"<%} %>>
			<TD class="Line" colSpan="2"></TD>
		</TR>

		<!--================ 接收人  ================-->	
        <TR>
        <td><%=SystemEnv.getHtmlLabelName(17689,user.getLanguage())%></td>
		<td class=field colspan=5> 
			<%
			String tmpaccepterids="";
			String tmpaccepterNames="";
		ArrayList accepterids1=Util.TokenizerString(memberIDs,",");
		if(accepterids1.size()!=0){
			for(int m=0; m < accepterids1.size(); m++){
				String tmpaccepterid=(String) accepterids1.get(m);
				tmpaccepterids+=","+tmpaccepterid;
				tmpaccepterNames+="<a href='/hrm/resource/HrmResource.jsp?id="+tmpaccepterid+"' target='_blank'>"+Util.toScreen(ResourceComInfo.getResourcename(tmpaccepterid),user.getLanguage())+"</a> &nbsp;";
			}
		}
		
		%>
			<input type=hidden name="memberIDs" class="wuiBrowser" value=<%=memberIDs%> value="<%=tmpaccepterids %>" 
				_param="workID" _required="yes" _displayText="<%=tmpaccepterNames %>"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp">
			<span id="viewFlag1" style="display:''">
				<button type="button" class=AddDoc onclick="changeView('viewFlag1','hiddenspan1','memberIDsSpan','1')" title="<%=SystemEnv.getHtmlLabelName(89, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(89, user.getLanguage())%></button>
			</span>
			<span id="hiddenspan1" style="display:none">
				<button type="button" class=AddDoc onclick="changeView('viewFlag1','hiddenspan1','memberIDsSpan','0')" title="<%=SystemEnv.getHtmlLabelName(16636, user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16636, user.getLanguage())%></button>
			</span>
    	</td>
    </tr>
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR> 
		
		<!--================ 开始时间  ================-->	
        <TR>          
			<TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          	<TD class=Field>
          		<button type="button" class=Calendar id="selectBeginDate" onclick="onshowPlanDate('beginDate','selectBeginDateSpan')"></BUTTON> 
              	<SPAN id=selectBeginDateSpan ><%=beginDate%></SPAN> 
              	<INPUT type="hidden" name="beginDate" value="<%=beginDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectBeginTime" onclick="onShowTime(selectBeginTimeSpan,beginTime)"></BUTTON>
              	<SPAN id="selectBeginTimeSpan"><%=beginTime%></SPAN>
              	<INPUT type=hidden name="beginTime" value="<%=beginTime%>">
            </TD>
        </TR>
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR> 
		
		<!--================ 结束时间  ================-->
        <TR>
          	<TD><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
          	<TD class=Field>
          		<button type="button" class=Calendar id="selectEndDate" onclick="onshowPlanDate('endDate','endDateSpan')"></BUTTON> 
            	<SPAN id=endDateSpan><%=endDate%></SPAN> 
            	<INPUT type="hidden" name="endDate" value="<%=endDate%>">  
              	&nbsp;&nbsp;&nbsp;
              	<button type="button" class=Clock id="selectEndTime" onclick="onShowTime(endTimeSpan,endTime)"></BUTTON>
              	<SPAN id="endTimeSpan"><%=endTime%></SPAN>
              	<INPUT type=hidden name="endTime" value="<%=endTime%>"></TD>
        </TR>
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR> 
		
		<!--================ 内容  ================-->
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></TD>
          	<TD class=Field>
          		<TEXTAREA class=InputStyle NAME="description" ROWS="5" STYLE="width:900px" onchange="checkinput('description','descriptionImage')"><%= Util.convertDB2Input(description) %></TEXTAREA><SPAN  id="descriptionImage"><% if("".equals(description) || null == description) { %><IMG src='/images/BacoError.gif' align=absMiddle><% } %></SPAN>
          	</TD>
        </TR>
		<%if(isgoveproj==0){%>
		<!--================ 相关客户  ================-->
		<TR>
        	<TD><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></TD>
        	<TD class=Field>
				<%
					String crmNames="";
					if (!crmIDs.equals("")) 
					{
						ArrayList crms = Util.TokenizerString(crmIDs,",");
						for (int i = 0; i < crms.size(); i++)
						{
							crmNames+="<A  href='/CRM/data/ViewCustomer.jsp?CustomerID="+crms.get(i)+"' target='_blank'>"
									+CustomerInfoComInfo.getCustomerInfoname(""+crms.get(i))+"</a>&nbsp;";
						}
					}
				%>			
				<INPUT type="hidden" class="wuiBrowser" name="crmIDs" value="<%=crmIDs%>" _displayText="<%=crmNames %>" _param="resourceids"
					_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
		  	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR> 
		<%}%>
		<!--================ 相关文档  ================-->
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          	<TD class=Field>
          		<%
          			String docNames="";
        			if (!docIDs.equals("")) 
					{
						ArrayList docs = Util.TokenizerString(docIDs,",");
					for (int i = 0; i < docs.size(); i++) 
					{
						docNames+="<A  href='/docs/docs/DocDsp.jsp?id="+docs.get(i)+"' target='_blank'>"
								+DocComInfo.getDocname(""+docs.get(i))+"</a>&nbsp;";
					}
					}
          		%>
          		<INPUT type="hidden" class="wuiBrowser" name="docIDs" value="<%=docIDs%>" _displayText="<%=docNames %>" _param="documentids"
					_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>&nbsp"
					_url="/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp">
          	</TD>
        </TR>
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR> 
		<%if(isgoveproj==0){%>
		<!--================ 相关项目  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
			<TD class=Field>
				<%
					String prjNames="";
					if (!projectIDs.equals("")) 
					{
						ArrayList projects = Util.TokenizerString(projectIDs,",");
						for (int i = 0; i < projects.size(); i++) 
						{
							prjNames+="<A  href='/proj/data/ViewProject.jsp?ProjID="+projects.get(i)+"' target='_blank'>"
									+ProjectInfoComInfo.getProjectInfoname(""+projects.get(i))+"</a>&nbsp;";
						}
					}
				%>
				<INPUT type="hidden" name="projectIDs" class="wuiBrowser" value="<%=projectIDs%>"
					_param="projectids" _displayText="<%=prjNames %>"
					_displayTemplate="<A href=/proj/data/ViewProject.jsp?ProjID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp">
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD class="Line" colSpan="2"></TD>
		</TR>
		
		<!--================ 相关项目任务  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></TD>
			<TD class="Field">
				<%
					String taskNames="";
					if (!taskIDs.equals("") && !taskIDs.equals("0")) 
					{
						ArrayList tasks = Util.TokenizerString(taskIDs,",");
						for (int i = 0; i < tasks.size(); i++) 
						{
							taskNames+="<A  href='/proj/process/ViewTask.jsp?taskrecordid="+tasks.get(i)+"' target='_blank'>"+ProjectTaskApprovalDetail.getTaskSuject(tasks.get(i).toString())+"("+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":"+ProjectTaskApprovalDetail.getProjectNameByTaskId(tasks.get(i).toString())+")</A>&nbsp;";
						}
					}
				%>
				<INPUT type=hidden name="taskIDs" class="wuiBrowser"  value="<%=taskIDs%>" 
					_param="resourceids"
					_displayText="<%=taskNames %>"
					_url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp">
			</TD>
		</TR>
		<TR style="height:1px;">
			<TD class=Line colSpan=2></TD>
		</TR> 
		<%}%>
		<!--================ 相关流程  ================-->
		<TR>
			<TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
			<TD class=Field>
				<%
					String requestNames="";
					if (!requestIDs.equals("")) 
					{
						ArrayList requests = Util.TokenizerString(requestIDs,",");
						for (int i = 0; i < requests.size(); i++) 
						{
							requestNames+="<A  href='/workflow/request/ViewRequest.jsp?requestid="+requests.get(i)+"' target='_blank'>"
									+requestComInfo.getRequestname(""+requests.get(i))+"</a>&nbsp;";
						}
					}
				%>
				<INPUT type="hidden" name="requestIDs" class="wuiBrowser" value="<%=requestIDs%>" 
					_param="resourceids" _displayText="requestNames"
					_displayTemplate="<A href=/workflow/request/ViewRequest.jsp?requestid=#b{id} target='_blank'>#b{name}</A>&nbsp;"
					_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp">
			</TD>
		</TR>		
    </TBODY>
	</TABLE>
</FORM>


<SCRIPT language="JavaScript" src="/js/OrderValidator.js"></SCRIPT>

<SCRIPT LANGUAGE="JavaScript">

$(function(){
	if($("input[name=memberIDs]").val()==""){
	document.getElementById("viewFlag1").style.display='none';
	document.getElementById("hiddenspan1").style.display='none';
	document.getElementById("memberIDsSpan").style.display='none';
	}else{
		document.getElementById("viewFlag1").style.display='none';
		document.getElementById("hiddenspan1").style.display='';
		document.getElementById("memberIDsSpan").style.display='';
	}
});
function goBack() {	
	document.frmmain.action = "/workplan/data/WorkPlanDetail.jsp";
	document.frmmain.submit();
}

function doSave(obj) {	
	if (check_form(frmmain,"planName,memberIDs,begindate,description") && checkWorkPlanRemind()) {
		if (!checkOrderValid("beginDate", "endDate")) {
			alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
			return;
		}
        //td1976 判断是否只为空格和回车
        var dd=$GetEle("description").value;
	    dd=dd.replace(/^[ \t\n\r]+/g, "");
	    dd=dd.replace(/[ \t\n\r]+$/g, "");

	    if (dd=="") {
            alert("内容不能为空！");
            return;
        }

		var dateStart = $GetEle("beginDate").value;
		var dateEnd = $GetEle("endDate").value;

		if (dateStart == dateEnd && !checkOrderValid("beginTime", "endTime")) {
			alert("<%=SystemEnv.getHtmlNoteName(55,user.getLanguage())%>");
			return;
		}
		obj.disabled = true ;
		document.frmmain.submit();
	}
}

function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		$GetEle("remindTime").style.display = "none";
		$GetEle("remindTimeLine").style.display = "none";
		$GetEle("reminddesc").style.display = "none";
		$GetEle("remindTimeLine1").style.display = "none";
	}
	else
	{
		$GetEle("remindTime").style.display = "";
		$GetEle("remindTimeLine").style.display = "";
		$GetEle("reminddesc").style.display = "";
		$GetEle("remindTimeLine1").style.display = "";
	}
}

function checkWorkPlanRemind()
{
	if(false == document.frmmain.remindType[0].checked)
	{
		if(document.frmmain.remindBeforeStart.checked || document.frmmain.remindBeforeEnd.checked)
		{
			return true;			
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(20238,user.getLanguage())%>");
			return false;
		}
	}
	else
	{
		document.frmmain.remindBeforeStart.checked = false;
		document.frmmain.remindBeforeEnd.checked = false;
		document.frmmain.remindTimeBeforeStart.value = 10;
		document.frmmain.remindTimeBeforeEnd.value = 10;
		
		return true;		
	}
}

function onWPShowDate(spanname,inputname){
  var returnvalue;	  
  var oncleaingFun = function(){
		 $(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"; 
		 $(inputname).value = '';
	}
   WdatePicker({onpicked:function(dp){
	returnvalue = dp.cal.getDateStr();	
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

function onWPNOShowDate(spanname,inputname){
  var returnvalue;	  
  var oncleaingFun = function(){
		 $(spanname).innerHTML = ""; 
		 $(inputname).value = '';
	}
   WdatePicker({onpicked:function(dp){
	returnvalue = dp.cal.getDateStr();	
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}

function changeView(viewFlag,hiddenspan,accepterspan,flag){
	try {
		if(flag==1){
			document.getElementById(viewFlag).style.display='none';
			document.getElementById(hiddenspan).style.display='';
			document.getElementById(accepterspan).style.display='';
		}
		if(flag==0){
			document.getElementById(viewFlag).style.display='';
			document.getElementById(hiddenspan).style.display='none';
			document.getElementById(accepterspan).style.display='none';
		}
	}
	catch(e) {}
}

function back()
{
	window.history.back(-1);
}
</SCRIPT>
</SCRIPT>


</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>