<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<HEAD>
	<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(20215,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String workPlanString = "";
	RecordSet.execute("SELECT * FROM SysPoppupRemindInfoNew WHERE userID = " + user.getUID() + " AND type = 12");	
	if(RecordSet.next())
	{
	    workPlanString = RecordSet.getString("requestid");
	}
	
	if(!"".equals(workPlanString) && null != workPlanString)
	{
	    
		int templen=workPlanString.lastIndexOf(",");
		if (templen==workPlanString.length())
			workPlanString = workPlanString.substring(0, workPlanString.length() - 1);
	}
	if ("".equals(workPlanString))      workPlanString="-1";  
	RecordSet.execute("SELECT * FROM WorkPlan WHERE ID IN (" + workPlanString +  ")");
  
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
		<COL width="1">
		<COL width="">
		<COL width="1">
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
	<TR>
		<TD ></TD>
		<TD valign="top">
			<FORM name="planform" method="post" action="PlanOperation.jsp">
			<TABLE class=shadow>
				<TR>
					<TD valign=top>
						<TABLE class=ListStyle cellspacing=1 >
					  		<TR class=Header>						  
					  			<TH><%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%></TH>						  
					  		</TR>
					 		<TR class=Line>
					 			<TD colspan="2" ></TD>
					 		</TR> 
							<%
								boolean isLight = false;
					 			
							    while(RecordSet.next())
								{
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
									<A href='#' onclick=openFullWindow('/workplan/data/WorkPlanDetail.jsp?workid=<%= RecordSet.getString("ID") %>&from=1')><%= RecordSet.getString("name") %></A>
								</TD>		
							</TR>
							<%
								}																		
							%>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			</FORM>
		</TD>
		<TD></TD>
	</TR>
</TABLE>

</BODY>

</HTML>
    
