<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
	<HEAD>
		<TITLE></TITLE>
<%
	if(!HrmUserVarify.checkUserRight("WorkPlanMonitorSet:Set", user))
	{
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}

	String hrmID = Util.null2String(request.getParameter("hrmID"));

	String workPlanTypeIDs[] = request.getParameterValues("workPlanTypeIDs");
	
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = (TimeUtil.getCurrentTimeString()).substring(11,19);

	if(!"".equals(hrmID) && null != hrmID)
	{
	    RecordSet.executeSql("DELETE FROM WorkPlanMonitor WHERE hrmID = " + hrmID);
	    
	    if(null != workPlanTypeIDs && workPlanTypeIDs.length > 0)
	    {
	        for(int i = 0; i < workPlanTypeIDs.length; i++)
	        {
	            RecordSet.executeSql("INSERT INTO WorkPlanMonitor(hrmID, workPlanTypeID, operatorDate, operatorTime) VALUES (" + hrmID + ", " + workPlanTypeIDs[i] + ", '" + currentDate + "', '" + currentTime + "'" + ")");	            
	        }
	    }
	}
	
	response.sendRedirect("WorkPlanMonitorStatic.jsp");
%>
	</HEAD>

<BODY>
</BODY>

</HTML>
