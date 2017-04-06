<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.List" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanExchange" %>
<%@ page import="weaver.WorkPlan.WorkPlanHandler" %>

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<HTML>
	<HEAD>
		<TITLE></TITLE>
<%
	RecordSet recordSet = new RecordSet();
	String workPlanIDs = request.getParameter("workPlanIDs");

	if(!"".equals(workPlanIDs) && null != workPlanIDs)
	{
	    WorkPlanExchange exchange = new WorkPlanExchange();
	    WorkPlanHandler workPlanHandler = new WorkPlanHandler();
	    WorkPlanLogMan logMan = new WorkPlanLogMan();
	    
	    String userID = String.valueOf(user.getUID());
		List workPlanList = Util.TokenizerString(workPlanIDs, ",");						
		
		for(int i = 0; i < workPlanList.size(); i++)
		{
			String workPlanID = (String)workPlanList.get(i);
		
			recordSet.executeSql("SELECT * FROM WorkPlan WHERE id = " + workPlanID);
			if(recordSet.next())
			{
				workPlanHandler.delete(workPlanID);
				
				String logParams[] = new String[]
				{ workPlanID, WorkPlanLogMan.TP_DELETE, userID, request.getRemoteAddr() };
				logMan.writeViewLog(logParams);
		
				exchange.workPlanDelete(Integer.parseInt(workPlanID));
				
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setOperateUserid(user.getUID());
				SysMaintenanceLog.setOperateType("3");
				SysMaintenanceLog.setRelatedName(Util.null2String(recordSet.getString("name")));
			    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			    	    		    		    
			    SysMaintenanceLog.setRelatedId(recordSet.getInt("type_n"));
			    SysMaintenanceLog.setOperateDesc("");
			    SysMaintenanceLog.setOperateItem("91");
			    
			    SysMaintenanceLog.setSysLogInfo();   
			}			
		}
	}
	
	response.sendRedirect("WorkPlanMonitor.jsp");		
%>
	</HEAD>

<BODY>
</BODY>

</HTML>
