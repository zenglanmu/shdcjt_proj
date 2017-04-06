<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workPlanShare" class="weaver.WorkPlan.WorkPlanShare" scope="page" />
<jsp:useBean id="workPlanExchange" class="weaver.WorkPlan.WorkPlanExchange" scope="page"/>

<%
	String method = Util.null2String(request.getParameter("method"));
	String para = "";
	char sep = Util.getSeparator();
	
	String planID = Util.null2String(request.getParameter("planID"));
	
	if (method.equals("add")) 
	{
		String shareType = Util.null2String(request.getParameter("sharetype"));
		String shareId = Util.null2String(request.getParameter("relatedshareid"));
		String roleLevel = Util.null2String(request.getParameter("rolelevel"));
		String secLevel = Util.null2String(request.getParameter("seclevel"));
		String shareLevel = Util.null2String(request.getParameter("sharelevel"));
	
		String userId = "0";
		String deptId = "0";
		String roleId = "0";
		String forAll = "0";
		String subCompanyID = "0";

		if (shareType.equals("1"))
		{
			userId = shareId;
		}
		else if (shareType.equals("2"))
		{
		    deptId = shareId;
		}
		else if (shareType.equals("3"))
		{
		    roleId = shareId;
		}
		else if (shareType.equals("5"))
		{
		    subCompanyID = shareId;
		}
		else
		{
		    forAll = "1";
		}

		para = planID;
		para += sep + shareType;
		para += sep + userId;
		para += sep + subCompanyID;
		para += sep + deptId;
		para += sep + roleId;
		para += sep + forAll;
		para += sep + roleLevel;
		para += sep + secLevel;
		para += sep + shareLevel;

		rs.executeProc("WorkPlanShare_Ins", para);
    		
        workPlanShare.setShareDetail(planID);
        
        workPlanExchange.exchangeAdd(Integer.parseInt(planID), String.valueOf(user.getUID()), user.getLogintype());  //标识日程已被编辑
        
	    response.sendRedirect("WorkPlanShare.jsp?planID=" + planID);    	
	}

	if (method.equals("delete")) 
	{
		String delId = Util.null2String(request.getParameter("delid"));
		rs.executeSql("DELETE WorkPlanShare WHERE id = " + delId);
		workPlanShare.setShareDetail(planID);
		
		workPlanExchange.exchangeAdd(Integer.parseInt(planID), String.valueOf(user.getUID()), user.getLogintype());  //标识日程已被编辑
		
		response.sendRedirect("WorkPlanShare.jsp?planID=" + planID);
	}
%>