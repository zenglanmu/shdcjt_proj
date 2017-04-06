<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.hrm.performance.targetplan.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="weaver.Constants" %>

<jsp:useBean id="ar" class="weaver.general.AutoResult" scope="page" />
<jsp:useBean id="wp" class="weaver.hrm.performance.targetplan.PlanModul" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsk" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="customerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="projectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="docComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="meetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="exchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>
<jsp:useBean id="ProjectTaskApprovalDetail" class="weaver.proj.Maint.ProjectTaskApprovalDetail" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML>
<HEAD>
	<STYLE>
		.SectionHeader 
		{
			FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
		}
	</STYLE>
	<STYLE>
		.vis1	{ visibility:visible }
		.vis2	{ visibility:hidden }
		.vis3   { display:inline}
		.vis4   { display:none }
	</STYLE>
	<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver.js"></script>
	<script language="javascript" src="/js/addRowBg.js"></script>
</HEAD>

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);  
	String target = Util.null2String(request.getParameter("target"));

	String imagefilename = "/images/hdMaintenance.gif";
	
	String id=Util.null2String(request.getParameter("id"));
	if("".equals(id))
	{
	    id = "-1";
	}
	
	String type_n = "";  //类型 目标计划：6  工作安排：0
	
	String needfav ="1";
	String needhelp ="";
	String urgentLevel="";
	String resourceId = String.valueOf(user.getUID());	//默认为当前登录用户
	String objId=""+user.getUID();
	String type_d="3";
	String type="";
	int wakeTime = 0;
	String unitType = "1";
	String isRemind="";
	float remindValue = 0;
	String planName=user.getLastname()+"计划模版";
	String sqls="SELECT * from HrmPerformancePlanModul where id="+id;
	String titlename="";
	String flag="0";
	
	String workPlanTypeID = "";
	String remindType = "";
	String remindBeforeStart = "";//是否开始前提醒
	String remindBeforeEnd = "";//是否结束前提醒
	
	String createType = "";
	String workPlanCreateTime = "";
	String frequency = "";
	String frequencyy = "";
	String availableBeginDate = "";
	String availableEndDate = "";
	String persistentType = "";
	String persistentTimes = "";
	String timeModul = "";
	int remindDateBeforeStart = 0;//开始前提醒小时
	int remindTimeBeforeStart = 0;//开始前提醒分钟
	
    int remindDateBeforeEnd = 0;//结束前提醒小时
	int remindTimeBeforeEnd = 10;//结束前提醒分钟
	
	String remindTimesBeforeStart = ""; // 开始前提醒分钟数
	String remindTimesBeforeEnd = ""; // 结束前提醒分钟数
	int immediatetouch = 0;
	
	rs1.executeSql(sqls);
	if(rs1.next())
	{
		type_n = Util.null2String(rs1.getString("type_n"));
	    workPlanTypeID = Util.null2String(String.valueOf(rs1.getInt("workPlanTypeID")));
	    remindType = Util.null2String(rs1.getString("remindType"));
	    remindBeforeStart = Util.null2String(rs1.getString("remindBeforeStart"));
	    remindTimesBeforeStart = Util.null2String(rs1.getString("remindTimesBeforeStart"));
	    remindBeforeEnd = Util.null2String(rs1.getString("remindBeforeEnd"));
	    remindTimesBeforeEnd = Util.null2String(rs1.getString("remindTimesBeforeEnd"));
	    createType = Util.null2String(rs1.getString("createType"));
	    workPlanCreateTime = Util.null2String(rs1.getString("workPlanCreateTime"));
	    frequency = Util.null2String(String.valueOf(rs1.getInt("frequency")));
	    frequencyy = Util.null2String(String.valueOf(rs1.getInt("frequencyy")));
	    availableBeginDate = Util.null2String(rs1.getString("availableBeginDate"));
		availableEndDate = Util.null2String(rs1.getString("availableEndDate"));
		persistentType = Util.null2String(rs1.getString("persistentType"));
		persistentTimes = Util.null2String(rs1.getString("persistentTimes"));
		timeModul = Util.null2String(rs1.getString("timeModul"));
		immediatetouch = rs1.getInt("immediatetouch");
		
	}
	
	if("1".equals(remindBeforeStart))
	{	
		remindDateBeforeStart=Util.getIntValue(remindTimesBeforeStart,0)/60;
		remindTimeBeforeStart=Util.getIntValue(remindTimesBeforeStart,0)%60;
	}
	if("1".equals(remindBeforeEnd))
	{	
		remindDateBeforeEnd=Util.getIntValue(remindTimesBeforeEnd,0)/60;
		remindTimeBeforeEnd=Util.getIntValue(remindTimesBeforeEnd,0)%60;
	}
	if (ar.getResult(sqls))
	{
	    flag="1";
		titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18220,user.getLanguage());
		wp=(PlanModul)ar.getBean(sqls,wp);
		type=wp.getCycle();
		urgentLevel=wp.getUrgentLevel();
		isRemind = Util.null2String(wp.getIsremind());
		wakeTime = Util.getIntValue(wp.getWaketime(), 0);
		
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
	else
	{
		titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18220,user.getLanguage());
		wp.setId("0");
		wp.setPrincipal(objId);
	}
	
	if (!Util.null2String(wp.getName()).equals(""))
	{
	   planName=Util.null2String(wp.getName());
	}
%>


<BODY>
<DIV id="divSave" style="display:none;position:absolute; visibility:show;right:0px;top:0px;padding:1px;background:#ffffff;border:1px solid #EEEEEE;width:160px;color:#666666;z-index:9999 ;filter:alpha(opacity=80);">
	<TABLE>
		<TR>
			<TD>
				<IMG src="/images/loading2.gif">
			</TD>
			<TD>
				<%= SystemEnv.getHtmlLabelName(19611,user.getLanguage()) %>
			</TD>
		</TR>
	</TABLE>
</DIV>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",PlanModulList.jsp?target=" + target + ",_self}";
	RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
		<COL width="10">
		<COL width="">
		<COL width="10">
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
	<TR>
		<TD ></TD>
		<TD valign="top">
			<TABLE class=Shadow>
				<TR>
					<TD valign="top">
						<FORM name=resource id=resource action="PlanModulOperation.jsp" method=post>
						<INPUT type=hidden name=operationType value="planAdd" >
						<INPUT type=hidden name=pName value=<%=planName%> >
						<INPUT type=hidden name=id value=<%=Util.null2String(wp.getId())%> >
						<INPUT type=hidden name=type_n value=<% if("workplan".equals(target) || Util.null2String(wp.getType_n()).equals("0")) {%>0<% } else { %>6<% } %> >
						<INPUT type="hidden" id="rownum" name="rownum">
						<INPUT type="hidden" id="rownum" name="rownum1">
						<TABLE class=ViewForm>
							<COLGROUP> 
								<COL width="50%"> 
							<TBODY>   
    						<TR> 
      							<TD vAlign=top> 
      								<!--================== 基本信息标题 ==================-->
									<TABLE width="100%">
										<COLGROUP> 
											<COL width=15%> 
											<COL width=85%> 
										<TBODY> 
									  	<TR class=title> 
									    	<TH ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
											<TH style="text-align:right;cursor:hand">
												<SPAN class="spanSwitch1" onclick="doSwitchx('showobj','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')">
													<IMG src='/images/up.jpg' style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>' >
									  			</SPAN>
									  		</TH>
										</TR>
										<TR class=spacing style="height:1px;"> 
									  		<TD class=line1 colSpan=2></TD>
										</TR>
										</TBODY>
									</TABLE>
									
         							<DIV id="showobj">
								        <TABLE width="100%">
								        	<COLGROUP> 
								        		<COL width=15%>
								        		<COL width=85%>
								        	<TBODY>
								        	<!--================== 标题 ==================-->
								          	<TR> 
								            	<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
								            	<TD class=Field>								           
								              		<INPUT class=inputstyle  maxLength=50 size=50 name=name value="<%=planName%>" onchange='checkinput("name","nameimage")'>
													<SPAN id=nameimage></SPAN>
								            	</TD>
								          	</TR>             
        									<TR style="height:1px;">
        										<TD class=Line colSpan=2></TD>
        									</TR>
        									
        									<!--================== 类型 ==================-->
											<TR> 
												<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
												<TD class=Field>
												<%
													if("workplan".equals(target) || Util.null2String(wp.getType_n()).equals("0"))
													//从日程进入(工作安排)
													{
													    rs2.executeSql("SELECT * FROM WorkPlanType" + Constants.WorkPlan_Type_Query_By_Menu);
												%>
												    <SELECT name="workPlanType">
									  				<%
									  					while(rs2.next())
									  					{
									  					    String workPlanTypeIDOption = String.valueOf(rs2.getInt("workPlanTypeID"));
									  				%>
														<OPTION value=<%= workPlanTypeIDOption %> <% if(workPlanTypeID.equals(workPlanTypeIDOption)) { %> selected <% } %>><%= Util.forHtml(rs2.getString("workPlanTypeName")) %></OPTION>
													<%										  					
									  					}
													%>
											  		</SELECT>
												<%
													}
													else
													//目标绩效
													{
												%>
														<%= SystemEnv.getHtmlLabelName(18181,user.getLanguage()) %>												
												<%
													}
												%>													
											  	</TD>
											</TR>
        									<TR style="height:1px;">
        										<TD class=Line colSpan=2></TD>
        									</TR> 

											<!--================== 性质 ==================-->
									        <TR> 
									            <TD><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TD>
									            <TD class=Field> 									            									            
									            <%
									            	if("workplan".equals(target) || Util.null2String(wp.getType_n()).equals("0"))
													//从日程进入(工作安排)
													{
									            %>										            	
									            	<!--================== 工作安排性质 ==================-->									            	
										            <SPAN id="property_0">
											           	<INPUT type="radio" value="1" name="urgentlevel" <%if (urgentLevel.equals("1")||urgentLevel.equals("")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
														&nbsp;&nbsp;
														<INPUT type="radio" value="2" name="urgentlevel" <%if (urgentLevel.equals("2")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
														&nbsp;&nbsp;
														<INPUT type="radio" value="3" name="urgentlevel" <%if (urgentLevel.equals("3")) {%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
											        </SPAN>
									            <%
													}
									            	else
									            	{
									            %>
									            	<!--================== 目标计划性质 ==================-->
									            	<SPAN id="property_6">
									            <%
									             		rs1.execute("SELECT * from HrmPerformancePlanKindDetail order by sort");
									            %>
									            		<SELECT class=inputStyle id=planProperty name=planProperty>
									            <%
									            		while (rs1.next()) 
									            		{
									            %>
									                		<OPTION value="<%=rs1.getString("id")%>"  <%if (Util.null2String(wp.getName()).equals(rs1.getString("id"))) {%>selected<%}%>><%=rs1.getString("planName")%></OPTION>
									            <%
									            		}
									            %>
									            		</SELECT>								               
									            	</SPAN>
									            <%
									            	}
									            %>
									        	</TD>
									      	</TR>
									      	<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
											<!--================ 日程提醒方式  ================-->
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(19781,user.getLanguage())%></TD>
												<TD class="Field">
													<INPUT type="radio" value="1" name="remindType" onclick=showRemindTime(this) <%if(null!=remindType&&"1".equals(remindType)){ %>checked<%}else if(null==remindType||"".equals(remindType)){%>checked<%} %>><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
													<INPUT type="radio" value="2" name="remindType" onclick=showRemindTime(this) <%if(null!=remindType&&"2".equals(remindType)){ %>checked<%} %>><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
													<INPUT type="radio" value="3" name="remindType" onclick=showRemindTime(this) <%if(null!=remindType&&"3".equals(remindType)){ %>checked<%} %>><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
												</TD>
											</TR>
											<TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
											<!--================ 日程提醒时间  ================-->
											<TR id="remindTime" style="<%if(null!=remindType&&("2".equals(remindType)||"3".equals(remindType))){ %>display:block;<%}else{ %>display:none<%} %>">
												<TD><%=SystemEnv.getHtmlLabelName(19783,user.getLanguage())%></TD>
												<TD class="Field">
													<INPUT type="checkbox" id="remindBeforeStart" name="remindBeforeStart" value="1" <%if(null!=remindBeforeStart&&"1".equals(remindBeforeStart)){ %>checked<%} %>>
														<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
														<INPUT class="InputStyle" type="input" id="remindDateBeforeStart" name="remindDateBeforeStart"  onchange="checkint('remindDateBeforeStart')" size=5 value="<%=remindDateBeforeStart %>">
														<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
														<INPUT class="InputStyle" type="input" id="remindTimeBeforeStart" name="remindTimeBeforeStart" onchange="checkint('remindTimeBeforeStart')" size=5 value="<%=remindTimeBeforeStart %>">
														<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
													&nbsp&nbsp&nbsp
													<INPUT type="checkbox" id="remindBeforeEnd" name="remindBeforeEnd" value="1" <%if(null!=remindBeforeEnd&&"1".equals(remindBeforeEnd)){ %>checked<%} %>>
														<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
														<INPUT class="InputStyle" type="input" id="remindDateBeforeEnd" name="remindDateBeforeEnd" onchange="checkint('remindDateBeforeEnd')" size=5 value="<%=remindDateBeforeEnd %>">
														<%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>
														<INPUT class="InputStyle" type="input" id="remindTimeBeforeEnd" name="remindTimeBeforeEnd" onchange="checkint('remindTimeBeforeEnd')"  size=5 value="<%=remindTimeBeforeEnd %>">
														<%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
												</TD>
											</TR>
									      	<TR id="remindTimeLine" style="display:none;height:1px;">
												<TD class="Line" colSpan="2"></TD>
											</TR>
									      																		        
											<!--================== 提交人 ==================-->
											<TR> 
												<TD><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></TD>
											    <TD class=Field> 
										        	<%=user.getLastname()%>
									            </TD>
									        </TR>
									        <TR style="height:1px;">
									        	<TD class=Line colSpan=2></TD>
									        </TR> 
									        
									        <!--================== 负责人 ==================-->
									        <TR> 
									            <TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
									            <TD class=Field> 
									               	<%
									               		String principalNames="";
												  		if (!Util.null2String(wp.getPrincipal()).equals("")) 
												  		{
															ArrayList hrms = Util.TokenizerString(Util.null2String(wp.getPrincipal()),",");
															for (int i = 0; i < hrms.size(); i++) 
															{
																principalNames+="<A href='/hrm/resource/HrmResource.jsp?id="+hrms.get(i)+"' target='_blank'>"+resourceComInfo.getResourcename(""+hrms.get(i))+"</A>&nbsp;";
															}
														}
													%>
									             	<input type=hidden name="principal" class="wuiBrowser" value="<%=Util.null2String(wp.getPrincipal())%>" 
														_param="resourceids" _required="yes" _displayText="<%=principalNames %>"
														_displayTemplate="<a href=/hrm/resource/HrmResource.jsp?id=#b{id}>#b{name}</a>&nbsp"
														_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp">
									            </TD>
									        </TR>
									        <TR style="height:1px;">
									        	<TD class=Line colSpan=2></TD>
									        </TR> 
    										<%if(isgoveproj==0){%>								
								  			<!--================== 相关客户 ==================-->
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></TD>
												<TD class="Field">
														<%
													String crmNames="";
														if (!Util.null2String(wp.getCrmid()).equals("")) 
														{
															ArrayList crms = Util.TokenizerString(Util.null2String(wp.getCrmid()), ",");
															for (int i = 0; i < crms.size(); i++) 
															{
															crmNames+="<A  href='/CRM/data/ViewCustomer.jsp?CustomerID="+crms.get(i)+"' target='_blank'>"
																	+customerInfoComInfo.getCustomerInfoname(""+crms.get(i))+"</a>&nbsp;";
														}
													}
												%>			
												<INPUT type="hidden" class="wuiBrowser" name="crmid" value="<%=Util.null2String(wp.getCrmid())%>" _displayText="<%=crmNames %>" _param="resourceids"
													_displayTemplate="<A href=/CRM/data/ViewCustomer.jsp?CustomerID=#b{id} target='_blank'>#b{name}</A>&nbsp;"
													_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp">
											  	</TD>
											</TR>
											<TR style="height:1px;">
												<TD class="Line" colSpan="2"></TD>
											</TR> 
											<%}%>
											<!--================== 相关文档 ==================-->
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></TD>
												<TD class="Field">
													
											  		<%
											  		String docNames="";
											  		if (!Util.null2String(wp.getDocid()).equals("")) 
													{
														ArrayList docs = Util.TokenizerString(Util.null2String(wp.getDocid()), ",");
														for (int i = 0; i < docs.size(); i++) 
														{
														docNames+="<A  href='/docs/docs/DocDsp.jsp?id="+docs.get(i)+"' target='_blank'>"
																+docComInfo.getDocname(""+docs.get(i))+"</a>&nbsp;";
													}
													}
								          		%>
								          		<INPUT type="hidden" class="wuiBrowser" name="docid" value="<%=Util.null2String(wp.getDocid()) %>" _displayText="<%=docNames %>" _param="documentids"
													_displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}' target='_blank'>#b{name}</a>&nbsp"
													_url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp">
											  	</TD>
											</TR>
											<TR style="height:1px;">
												<TD class="Line" colSpan="2"></TD>
											</TR>
											<%if(isgoveproj==0){%>
											<!--================== 相关项目 ==================-->
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></TD>
												<TD class="Field">
													<%
															String prjNames="";
														if (!Util.null2String(wp.getProjectid()).equals("")) 
														{
															ArrayList projects = Util.TokenizerString(Util.null2String(wp.getProjectid()), ",");
															for (int i = 0; i < projects.size(); i++) 
															{
																	prjNames+="<A  href='/proj/data/ViewProject.jsp?ProjID="+projects.get(i)+"' target='_blank'>"
																			+projectInfoComInfo.getProjectInfoname(""+projects.get(i))+"</a>&nbsp;";
																}
															}
														%>
														<INPUT type="hidden" name="projectid" class="wuiBrowser" value="<%=Util.null2String(wp.getProjectid())%>"
															_param="projectids" _displayText="<%=prjNames %>"
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
												<TD><%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%></TD>
												<TD class="Field">
													<%
														String requestNames="";
													if (!Util.null2String(wp.getRequestid()).equals("")) 
													{
														ArrayList requests = Util.TokenizerString(Util.null2String(wp.getRequestid()), ",");
														for (int i = 0; i < requests.size(); i++) 
														{
																requestNames+="<A  href='/workflow/request/ViewRequest.jsp?requestid="+requests.get(i)+"' target='_blank'>"
																		+requestComInfo.getRequestname(""+requests.get(i))+"</a>&nbsp;";
															}
														}
													%>
													<INPUT type="hidden" name="requestid" class="wuiBrowser" value="<%=Util.null2String(wp.getRequestid())%>" 
														_param="resourceids" _displayText="<%=requestNames %>"
														_displayTemplate="<A href=/workflow/request/ViewRequest.jsp?requestid=#b{id} target='_blank'>#b{name}</A>&nbsp;"
														_url="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp">
												</TD>
											</TR>
											<TR style="height:1px;">
												<TD class="Line" colSpan="2"></TD>
											</TR>
											
											<!--================== 内容 ==================-->
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></TD>
											  	<TD class="Field">
											  		<TEXTAREA class="InputStyle" name="description" rows="5" style="width:98%" ><%=Util.convertDB2Input(Util.null2String(wp.getDescription()))%></TEXTAREA>
										      	</TD>
											</TR>
											<TR style="height:1px;">
												<TD class="Line" colSpan="2"></TD>
											</TR> 
											
          									</TBODY> 
        								</TABLE> 
        								
        								
        								<!--================== 定期模式 ==================-->      								
										<TABLE width="100%">
											<COLGROUP> 
												<COL width=15%>
												<COL width=85%> 
											<TBODY> 																						
											<TR class=title> 
									        	<TH colspan=2><%=SystemEnv.getHtmlLabelName(18221,user.getLanguage())%></TH>
											</TR>
											<TR class=spacing style="height:1px;"> 
									  			<TD class=line1 colSpan=2></TD>
											</TR>
											
											<!--================== 定期模式 ==================-->  
											<TR> 
												<TD><%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%></TD>
												<TD class=Field> 										   
											    	<SELECT id="timeModul" name="timeModul" onchange="showFre(this.value)">
											       		<OPTION value="9" <%if (Util.null2String(wp.getTimeModul()).equals("9")||Util.null2String(wp.getTimeModul()).equals("")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18223,user.getLanguage())%></OPTION><!--不定期建立计划-->
														<OPTION value="3" <%if (Util.null2String(wp.getTimeModul()).equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
														<OPTION value="0" <%if (Util.null2String(wp.getTimeModul()).equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
														<OPTION value="1" <%if (Util.null2String(wp.getTimeModul()).equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
														<OPTION value="2" <%if (Util.null2String(wp.getTimeModul()).equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
													</SELECT>
													<%
														String a="vis4";
												  		String b="vis4";
												  		String c="vis4";
												  		String d="vis4";
														if (Util.null2String(wp.getTimeModul()).equals("0"))
														{
														    a="vis3";
														}
														else if (Util.null2String(wp.getTimeModul()).equals("1"))
														{
														    b="vis3";
														}
														else if (Util.null2String(wp.getTimeModul()).equals("2"))
														{
														    c="vis3";
														}
														else if (Util.null2String(wp.getTimeModul()).equals("3"))
														{
														    d="vis3";
														}
													%>
													&nbsp&nbsp&nbsp
													<!--================== 天 ==================-->
													<SPAN id="show_3" class="<%=d%>" >
														<%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%>
														&nbsp
														<SELECT name="dayTime">
														<%
														for(int i = 0; i < 24; i++)
														{
														%>
															<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(workPlanCreateTime) && "3".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
														<%
														}
														%>
													  	</SELECT>
													  	<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
														
													<!--================== 周 ==================-->
													<SPAN id="show_0" class="<%=a%>" ><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%>																												
														<SELECT name="fer_0">
											 				<OPTION value="1" <%if (Util.null2String(wp.getFrequency()).equals("1") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
											 				<OPTION value="2" <%if (Util.null2String(wp.getFrequency()).equals("2") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
											 				<OPTION value="3" <%if (Util.null2String(wp.getFrequency()).equals("3") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
											 				<OPTION value="4" <%if (Util.null2String(wp.getFrequency()).equals("4") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
											 				<OPTION value="5" <%if (Util.null2String(wp.getFrequency()).equals("5") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
											 				<OPTION value="6" <%if (Util.null2String(wp.getFrequency()).equals("6") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
											 				<OPTION value="7" <%if (Util.null2String(wp.getFrequency()).equals("7") && "0".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>											 				
														</SELECT>														
														&nbsp
														<SELECT name="weekTime">
														<%
														for(int i = 0; i < 24; i++)
														{
														%>
															<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(workPlanCreateTime) && "0".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
														<%
														}
														%>
													  	</SELECT>
													  	<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
													
													<!--================== 月 ==================-->
													<SPAN id="show_1" class="<%=b%>">
														<%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%>
														<SELECT name="monthType">
															<OPTION value="0" <%if (createType.equals("0") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
															<OPTION value="1" <%if (createType.equals("1") && "1".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
														</SELECT>														
														<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
														<SELECT name="fer_1">
														<%
															for (int i = 1; i <= 31; i++) 
															{
														%>
															<OPTION value="<%=i%>" <%if (Util.null2String(wp.getFrequency()).equals(""+i) && "1".equals(timeModul)) {%>selected<%}%>><%=i%></OPTION>
														<%
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
														&nbsp
														<SELECT name="monthTime">
														<%
														for(int i = 0; i < 24; i++)
														{
														%>
															<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(workPlanCreateTime) && "1".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
														<%
														}
														%>
													  	</SELECT>
														<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
													
													<!--================== 年 ==================-->
													<SPAN id="show_2" class="<%=c%>"><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%>
														<SELECT name="fer_2">
													 	<%
													 		for (int i = 1; i <= 12; i++) 
													 		{
													 	%>
															<OPTION value="<%= Util.add0(i, 2) %>" <%if (Util.null2String(wp.getFrequency()).equals(""+i) && "2".equals(timeModul)) {%>selected<%}%>><%= Util.add0(i, 2) %></OPTION>
														<%
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
														
														<SELECT name="yearType">														
															<OPTION value="0" <%if (createType.equals("0") && "2".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
															<OPTION value="1" <%if (createType.equals("1") && "2".equals(timeModul)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
														</SELECT>														
														<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
														<SELECT name="frey">
														<%
															for (int i = 1; i <= 31; i++) 
															{
														%>
															<OPTION value="<%=i%>" <%if(frequencyy.equals(""+i) && "2".equals(timeModul)) {%>selected<%}%>><%=i%></OPTION>
														<%
															}
														%>
														</SELECT>
														<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
														<%//=Util.null2String(wp.getFrequencyy())%>
														&nbsp
														<SELECT name="yearTime">
														<%
														for(int i = 0; i < 24; i++)
														{
														%>
															<OPTION value="<%= Util.add0(i, 2) %>:00" <%if((Util.add0(i, 2) + ":00").equals(workPlanCreateTime) && "2".equals(timeModul)){%>selected<%}%>><%= Util.add0(i, 2) %>:00</OPTION>
														<%
														}
														%>
													  	</SELECT>
													  	<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
													</SPAN>
												</TD>
											</TR>
											<TR style="height:1px;">
												<TD class=Line colSpan=2></TD>
											</TR>
											
											<TR>
												<TD colspan=2>
													<DIV id="generateSet" name="generateSet" <% if (!"9".equals(timeModul) && !"".equals(timeModul)) { %> class="vis3" <% } else { %> class="vis4" <% } %>>
													<TABLE width="100%">
														<COLGROUP> 
															<COL width=15%>
															<COL width=85%> 
														<TBODY>
														<!--================ 持续时间  ================-->	
														<TR>          
															<TD>
																<%=SystemEnv.getHtmlLabelName(19798,user.getLanguage())%>
															</TD>
															<TD class="Field">
																<INPUT type=text id="times" name="times" size=5 class=inputStyle value="<%= persistentTimes %>" onKeyPress="Count_KeyPress()" onchange="checkinput('times', 'timesSpan')">
																<SPAN id="timesSpan" name="timesSpan">
																<%
																	if(null == persistentTimes || "".equals(persistentTimes))
																	{
																%>
																	<IMG src='/images/BacoError.gif' align=absMiddle>
																<%
																	}
																%>
																</SPAN>
																<SELECT class=inputStyle name=timeType>									            
												            		<OPTION value="1" <%if("1".equals(persistentType)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
												            		<OPTION value="2" <%if("2".equals(persistentType)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
												            		<OPTION value="3" <%if("3".equals(persistentType)) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></OPTION>
												            	</SELECT>	
															</TD>
														</TR>
														<TR style="height:1px;">
															<TD class="Line" colSpan="2"></TD>
														</TR>
														
														<!--================ 有效期  ================-->	
														<TR>          
															<TD>
																<%=SystemEnv.getHtmlLabelName(15030,user.getLanguage())%>
															</TD>
															<TD class="Field">
																<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>
																<button type="button" class="Calendar" id="selectBeginDate" onclick="getTheDate('beginDate','beginDateSpan')"></BUTTON> 
																<SPAN id="beginDateSpan"><%= availableBeginDate %></SPAN> 
															  	<INPUT type="hidden" name="beginDate" value="<%= availableBeginDate %>">  
																&nbsp&nbsp&nbsp
																<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>
																<button type="button" class="Calendar" id="selectEndDate" onclick="getTheDate('endDate','endDateSpan')"></BUTTON> 
																<SPAN id="endDateSpan"><%= availableEndDate %></SPAN> 
															  	<INPUT type="hidden" name="endDate" value="<%= availableEndDate %>">  
																
															</TD>
														</TR>
														<TR style="height:1px;">
															<TD class="Line" colSpan="2"></TD>
														</TR>
														<!--================ 有效期  ================-->	
														<TR>          
															<TD>
																<%= SystemEnv.getHtmlLabelName(23231,user.getLanguage()) %>
															</TD>
															<TD class="Field">
																<INPUT type=checkbox value="<%=immediatetouch %>" name=immediatetouch <%if(immediatetouch==1)out.print("checked"); %> onclick="validateImmediateTouch(this);">&nbsp;															
															</TD>
														</TR>
														<TR style="height:1px;">
															<TD class="Line" colSpan="2"></TD>
														</TR>
														</TBODY>
													</TABLE>
													</DIV>	
												</TD>
											</TR>
																																																								
										</TBODY>
										</TABLE>
									</DIV>
									
									
									<!--================== 以下内容只有在基本信息设置成功后才出现 ==================-->
									
									<!--================== 工作关键点 ==================-->
									<% 
								        int rowIndex = 0;
						        		int rowIndex1 = 0;
					        			if (ar.getResult(sqls) && !"0".equals(type_n))
					        			{
					        		%>
			        				<TABLE width="100%" class=ListStyle>
			          					<COLGROUP> 
			          						<COL width=90%> 
			          						<COL width=10%> 
			          					<TBODY> 
											<TR class=title> 
												<TH align="left"><%=SystemEnv.getHtmlLabelName(18200,user.getLanguage())%></TH>
												<TH style="text-align:right;cursor:hand">
													<SPAN class="spanSwitch1" onclick="doSwitchx('showobjk','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')">
														<IMG src='/images/up.jpg' style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>'>
											  		</SPAN>
											  	</TH>
											</TR>
											<TR class=spacing style="height:1px;"> 
												<TD class=line1 colSpan=4></TD>
											</TR>
										</TBODY>
									</TABLE>
									

									<DIV id=showobjk>										     										     
									    <TABLE width="100%" id="oTable" class=ListStyle cellspacing=1>
											<THEAD>
											<TR>
												<TD colspan="3">
													<TABLE style="width:100%;border-collapse:collapse;" cellpadding="0">
														<TR>						
															<TD align=right>
																<button type="button" class=btnNew accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
																<button type="button" class=btnDelete accessKey=D onClick="javascript:deleteRow1();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
															</TD>
														</TR>
													</TABLE>
												</TD>
											</TR>
											</THEAD>
											<TR>
												<TD style="height:2px;background-color:#A1A1A1" colSpan=3></TD>
											</TR>
											<TBODY>
												<TR class=Header>
													 <TH width="5%"></TD>													 
										             <TH width="80%"><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TH>
										             <TH width="10%"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH>
												</TR>
												<TR class=Line  style="height:1px;">
													<TD colspan="3" ></TD>
												</TR>
											<%
												String bgColor = "";
												
												rsk.executeSql("SELECT * from HrmPerformancePlanKeyModul where planId="+wp.getId()+" order by viewSort" );
												 
												while (rsk.next())
												{
													bgColor = (rowIndex%2)==0 ? "#E7E7E7" : "#F5F5F5";
											%>
												<TR style="background-color:<%=bgColor%>">
													<TD><DIV><INPUT class=inputstyle type='checkbox' name='check_node' value='0'></DIV></TD>
													<TD><DIV><INPUT class=inputstyle style='width:100%' type=text maxlength=50 name='keyName_<%=rowIndex%>' value="<%=rsk.getString("keyName")%>"></DIV></TD>
													<TD><DIV><INPUT class=inputstyle style='width:100%' type=text  maxlength=3 name='viewSort_<%=rowIndex%>' value='<%=rsk.getString("viewSort")%>'></DIV></TD>
												</TR>
											<%
													rowIndex++;
												}
											%>
											</TBODY>
										</TABLE>				        
				         			 </DIV>
			          		          
	        						<!--================== 成果要求 ==================-->
									<TABLE width="100%" class=ListStyle>
										<COLGROUP> 
											<COL width=90%> 
											<COL width=10%> 
										<TBODY> 
									  	<TR class=title> 
									    	<TH align="left"><%=SystemEnv.getHtmlLabelName(18202,user.getLanguage())%></TH>
											<TH style="text-align:right;cursor:hand">
												<SPAN class="spanSwitch1" onclick="doSwitchx('showobja','<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>')">
													<IMG src='/images/up.jpg' style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>' >
										  		</SPAN>
									  		</TH>
										</TR>
										<TR class=spacing style="height:1px;"> 
									   		<TD class=line1 colSpan=2></TD>
									    </TR>
									    </TBODY>
									</TABLE>
								          
								    <DIV id=showobja>
						           		<TABLE width="100%" id="oTable1" class=ListStyle cellspacing=1>
											<THEAD>
											<TR>
												<TD colspan="3">
													<TABLE style="width:100%;border-collapse:collapse;" cellpadding="0">
														<TR>								
															<TD align=right>
																<button type="button" class=btnNew accessKey=Q onClick="addRow2();"><U>Q</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
																<button type="button" class=btnDelete accessKey=W onClick="javascript:deleteRow2();"><U>W</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
															</TD>
														</TR>
													</TABLE>
												</TD>
											</TR>
											</THEAD>
											<TR>
												<TD style="height:2px;background-color:#A1A1A1" colSpan=3></TD>
											</TR>
											<TBODY>
											<TR class=Header>
					 							<TH width="5%"></TH>					 
		             							<TH width="80%"><%=SystemEnv.getHtmlLabelName(18201,user.getLanguage())%></TH>
	             								<TH width="10%"><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH>
											</TR>
											<TR class=Line style="height:1px;">
												<TD colspan="3" ></TD>
											</TR>
						  					<%
												bgColor = "";
											 
											  	rsc.executeSql("SELECT * from HrmPerformancePlanEffortModul where planId="+wp.getId()+" order by viewSort");
									          	
											  	while (rsc.next())
									          	{
											  	    bgColor = (rowIndex1%2)==0 ? "#E7E7E7" : "#F5F5F5";
									        %>
											<TR style="background-color:<%=bgColor%>">
												<TD><DIV><INPUT class=inputstyle type='checkbox' name='check_node_1' value='0'></DIV></TD>
												<TD><DIV><INPUT class=inputstyle style='width:100%' type=text maxlength=50 name='effortName_<%=rowIndex1%>' value="<%=rsc.getString("effortName")%>"></DIV></TD>
												<TD><DIV><INPUT class=inputstyle style='width:100%' type=text  maxlength=3 name='viewSort1_<%=rowIndex1%>' value='<%=rsc.getString("viewSort")%>'></DIV></TD>
											</TR>
											<%
													rowIndex1++;
												}
											%>
											</TBODY>
										</TABLE>        
				          			</DIV>  
			          				<%
			          					}
			          				%>  
		      					</TD>
		      				</TR>
		      			</TABLE>	
		      			</FORM>
					</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>
<SCRIPT language="JavaScript" src="/js/OrderValidator.js"></SCRIPT>
<SCRIPT language="javascript">
function validateImmediateTouch(o)
{
	if(o.checked)
	{
		o.value='1';
	}
	else
	{
		o.value='0';
	}
	if(o.checked)
	{
		var beginDate = document.resource.beginDate.value;
		var endDate = document.resource.endDate.value;
		if(endDate=="")
		{
			alert("<%= SystemEnv.getHtmlLabelName(23232,user.getLanguage()) %>!")
		}
	}
}
function OnSubmit()
{            
    if(check_form(document.resource,"name,principal") && checkNumberValid("times")&& checkWorkPlanRemind())
	{	
		if (<%=flag=="1"%> && "0" != "<%= type_n %>") 
		{
		    document.getElementById("rownum").value = oTable.tBodies[1].rows.length - 2;
		    document.getElementById("rownum1").value = oTable1.tBodies[1].rows.length - 2;
		}
		var immediatetouch = document.resource.immediatetouch;
		if(immediatetouch)
		{
			immediatetouch = immediatetouch.value;
			if(immediatetouch==1)
			{
				var endDate = document.resource.endDate.value;
				if(endDate=="")
				{
					alert("<%= SystemEnv.getHtmlLabelName(23232,user.getLanguage()) %>!");
					return;
				}
			}
		}
		var divSave = document.getElementById("divSave");
		divSave.style.top = document.body.scrollTop+(document.body.clientHeight-divSave.style.posHeight)/2+"px";
		divSave.style.left = document.body.scrollLeft+(document.body.clientWidth-divSave.style.posWidth)/2+"px";
		divSave.style.display="block";
		document.resource.submit();
		enablemenu();
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
}


function onNeedRemind() {
	if (document.all("isremind").checked) 
        document.all("remindspan").className = "vis1";
    else 
        document.all("remindspan").className = "vis2";
}
 
function showFre(mode)
{
	for(i = 0; i < 4; i++)
	{
		document.all("show_" + i).className = "vis4";
		document.all("generateSet").className = "vis4";
	}
	if("9" != mode)
	{
		document.all("show_" + mode).className = "vis3";
		document.all("generateSet").className = "vis3";
	}
}

function showPro(type)
{
	document.all("property_0").className = "vis4";	
	document.all("property_6").className = "vis4";
	document.all("workPlanTypeDIV").className = "vis4";

	if("6" == type)
	//目标计划性质
	{
		document.all("property_6").className = "vis3";	
	}
	else
	//工作安排性质
	{
		document.all("workPlanTypeDIV").className = "vis3";	
		document.all("property_0").className = "vis3";
	}	
}

var rowColor;
var rowindex = <%=rowIndex%>;
var rowindex1 = <%=rowIndex1%>;
function addRow(){
	
	rowColor = getRowBg();
	var oTbody = oTable.tBodies[1];
	var ncol = oTbody.firstChild.childNodes.length;
	var oRow = oTbody.insertRow();
	var rowindex = oRow.rowIndex - 4;
   
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("DIV");
				var sHtml =  "<INPUT class=inputstyle style='width:100%' type=text  maxlength=50 name='keyName_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle style='width:100%' type=text maxlength=3 name='viewSort_"+rowindex+"' onkeypress='ItemCount_KeyPress()' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

function deleteRow1(){
	len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable.deleteRow(delRowIndex);
			}
		}
	}
}
function addRow2(){
	
	rowColor = getRowBg();
	var oTbody = oTable1.tBodies[1];
	var ncol = oTbody.firstChild.childNodes.length;
	var oRow = oTbody.insertRow();
	var rowindex1 = oRow.rowIndex - 4;
   
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle type='checkbox' name='check_node_1' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("DIV");
				var sHtml =  "<INPUT class=inputstyle style='width:100%' type=text maxlength=50 name='effortName_"+rowindex1+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("DIV");
				var sHtml = "<INPUT class=inputstyle style='width:100%' type=text  maxlength=3 name='viewSort1_"+rowindex1+"' onkeypress='ItemCount_KeyPress()' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

function deleteRow2(){
	len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_node_1'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable1.deleteRow(delRowIndex);
			}
		}
	}
}

function checkNumberValid(inputId)
{
	//var patt = /^[1-9]\d*|[1-9]\d*\.\d+|0\.\d+$/g;
	var patt = /^([1-9]\d*)$/g;
	var inputString = $G(inputId).value;

	if("9" != document.all("timeModul").value && !(check_form(document.resource, "times")))
	{
		return false;
	}
	if("9" != document.all("timeModul").value &&!(patt.test(inputString)))
	{
		alert("<%= SystemEnv.getHtmlLabelName(19798, user.getLanguage())+SystemEnv.getHtmlLabelName(24475, user.getLanguage())%>");

		return false;
	}
	else
	{
		return true;
	}
}

function Count_KeyPress()
{
	if(!(window.event.keyCode >= 48 && window.event.keyCode <= 57)) 
	{
		window.event.keyCode=0;
	}
}

function onWPNOShowDate(spanname,inputname){
  var returnvalue;	  
  var oncleaingFun = function(){		 
		document.getElementById(spanname).innerHTML = "";
        document.getElementById(inputname).value = "";
	};
   WdatePicker({onpicked:function(dp){
	returnvalue = dp.cal.getDateStr();	
	$dp.$(spanname).innerHTML = returnvalue;
	$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun});
}
function showRemindTime(obj)
{
	if("1" == obj.value)
	{
		document.all("remindTime").style.display = "none";
		document.all("remindTimeLine").style.display = "none";
	}
	else
	{
		document.all("remindTime").style.display = "";
		document.all("remindTimeLine").style.display = "";
	}
}
function checkWorkPlanRemind()
{
	if(false == document.resource.remindType[0].checked)
	{
		if(document.resource.remindBeforeStart.checked || document.resource.remindBeforeEnd.checked)
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
		document.resource.remindBeforeStart.checked = false;
		document.resource.remindBeforeEnd.checked = false;
		document.resource.remindTimeBeforeStart.value = 10;
		document.resource.remindTimeBeforeEnd.value = 10;
		
		return true;		
	}
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>