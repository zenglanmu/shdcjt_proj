<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.general.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
	String target = Util.null2String(request.getParameter("target"));

	String imagefilename = "/images/hdHRM.gif";
	String titlename = SystemEnv.getHtmlLabelName(18220,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
%>

<%
	String groupId=Util.null2String(request.getParameter("id"));
	String requestid="";
	boolean flag=false;
	String urgentLevel="";
	String type="";
	String planDate="";
	String objId=""+user.getUID();

	String SQL = "SELECT hrmPerformancePlanModul.*, hrmPerformancePlanKindDetail.planName"
		+ " FROM HrmPerformancePlanModul hrmPerformancePlanModul"
		+ " LEFT JOIN HrmPerformancePlanKindDetail hrmPerformancePlanKindDetail"
		+ " ON hrmPerformancePlanKindDetail.ID = hrmPerformancePlanModul.planProperty"
		+ " WHERE objID = " + objId+" order by hrmPerformancePlanModul.id desc";

	RecordSet.execute(SQL);
%>

<HTML>
<HEAD>
	<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",PlanModelAdd.jsp?target="+target+",_self}";
	RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
		<COL width="5">
		<COL width="">
		<COL width="5">
	<TR>
		<TD ></TD>
		<TD valign="top" style="padding-left:5px;padding-right:5px;">
						<FORM name="planform" method="post" action="PlanModulOperation.jsp">					
						<INPUT type="hidden" name="operationType" value="process">
						<INPUT type="hidden" name="src">
						<INPUT type="hidden" name="from" value="list">
						<INPUT type="hidden" name="requestId" value=<%=requestid%> >
						<INPUT type="hidden" name="objId" value=<%=objId%>>
												
						<TABLE class=ListStyle cellspacing=1 >
							<COLGROUP>							
								<COL width="50%">
								<COL width="20%">
								<COL width="20%">
								<COL width="10%">						 
						  	<TBODY>
							<TR class=Header>						  
								<TH><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TH>						   
					  		</TR>
					 		<TR class=Line>
					 			<TD colspan="5" style="padding:0;"></TD>
					 		</TR> 
							<%
								boolean isLight = false;
							   
								while(RecordSet.next()) 
								{   
								    urgentLevel = Util.null2String(RecordSet.getString("urgentLevel"));
									if(isLight = !isLight)
									{
							%>	
							<TR CLASS=DataLight>
							<%
									}
									else
									{
							%>
							<TR CLASS=DataDark>
							<%		
									}
							%>
								<TD>
									<A href="PlanModelAdd.jsp?target=<%=target%>&id=<%=RecordSet.getString("id")%>&type_d=3&type=<%=RecordSet.getString("cycle")%>&planDate=<%=RecordSet.getString("planDate")%>">
										<%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%>
									</A>
								</TD>
								<TD>
							<%
									if (Util.null2String(RecordSet.getString("type_n")).equals("0")) 
									{
										if(urgentLevel.equals("1")) 
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
									} 
									else 
									{
							%>
								<%=Util.toScreen(RecordSet.getString("planName"),user.getLanguage())%>
							<%
									}
							%>
								</TD>
								<TD>
							<%
									if ("0".equals(Util.null2String(RecordSet.getString("type_n"))))
									//ÈÕ³Ì
									{
									    RecordSetu.executeSql("SELECT * from WorkPlanType WHERE workPlanTypeId = " + RecordSet.getString("workPlanTypeId"));
										if(RecordSetu.next())
										{
							%>
										<%= RecordSetu.getString("workPlanTypeName") %>
							<%
										}
									}
									else 
									{
							%>
								<%=SystemEnv.getHtmlLabelName(18181,user.getLanguage())%>
							<%
									}
							%>
								</TD>
								<TD>
									<A href="#" onclick="deldetail(<%=RecordSet.getString("id")%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>
								</TD>								
							</TR>
							<%
								}
							%>
						 </TABLE>
			 			</FORM>
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</BODY>
</HTML>

<SCRIPT language="javascript">
function doSubmit()
{
	document.planform.src.value="submit";
	document.planform.submit();
	enablemenu();	
}

function deldetail(id)
{
	if (isdel())
	{
		location.href="PlanModulOperation.jsp?operationType=del&id="+id;
	}
}

function confirms(id,cycle,planDate)
{
	document.planform.planId.value=id;
	document.planform.type.value=cycle;
	document.planform.planDate.value=planDate;
	document.planform.operationType.value="confirm";
	document.planform.submit();
	enablemenu();
}
</SCRIPT>

    
