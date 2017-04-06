<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
	</HEAD>

<%
	if(!HrmUserVarify.checkUserRight("WorkPlanMonitorSet:Set", user))
	{
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}

	String imagefilename = "/images/hdMaintenance.gif";
	String titlename = SystemEnv.getHtmlLabelName(19792,user.getLanguage()) + SystemEnv.getHtmlLabelName(352,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/system/systemmonitor/workplan/WorkPlanMonitorSet.jsp, _self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


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
						
						<TABLE class=ListStyle cellspacing=1 >
					  		<COLGROUP>						   
							   <COL align=left width="10%">
							   <COL align=left width="10%">
							   <COL align=left width="21%">
							   <COL align=left width="21%">
							   <COL align=left width="21%">
							   <COL align=left width="7%">						   
						    <TR class=Header>
								<TH><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(19794,user.getLanguage())%></TH>
						  <TH><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19736,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(19795,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(18562,user.getLanguage())%></TH>
								<TH><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TH>
							</TR>						
						<%

							String sql = "SELECT count(*) count, hrmID, operatorDate, operatorTime FROM WorkPlanMonitor GROUP BY hrmID, operatorDate, operatorTime";
							RecordSet.executeSql(sql);
							
							int colorCount = 0;
							int no = 0;
							
							while(RecordSet.next())
							{
								no++;
								
								if(0 == colorCount)
								{
							        colorCount = 1;
						%>
							<TR class=DataLight>
						<%
							    }
								else
								{
							        colorCount = 0;
						%>
							<TR class=DataDark>
						<%
							  	}
						%>
							    <TD><%= no %></TD>
							    <TD><%= Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("hrmID")), user.getLanguage()) %></TD>
							    <TD><%= RecordSet.getString("operatorDate") + " " + RecordSet.getString("operatorTime") %></TD>
							    <TD><%= RecordSet.getInt("count") %></TD>
							    <TD>
							    	<A href="WorkPlanMonitorSet.jsp?hrmID=<%=RecordSet.getString("hrmID")%>">
							    		<%=SystemEnv.getHtmlLabelName(18562,user.getLanguage())%>
							     	</A>
							    </TD>
							    <TD>
							    	<A href="javascript:del('<%=RecordSet.getString("hrmID")%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></A>
							    </TD>
							</TR>
						<%
							}
						%>
						
						</TABLE>

					</TD>
				</TR>
			</TABLE>
		</TD>
		<TD></TD>
	</TR>
	<TR>
		<TD height="10" colspan="3"></TD>
	</TR>
</TABLE>

</BODY>

</HTML>



<script language="JavaScript">
function del(id)
{
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>"))
	{
		var url = "/system/systemmonitor/workplan/WorkPlanMonitorSetOperation.jsp?hrmID=" + id;
		window.location.href=url;
	}
}
 </script>

