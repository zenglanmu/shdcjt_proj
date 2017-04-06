<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WFOpinionNodeManager" class="weaver.workflow.workflow.WFOpinionNodeManager" scope="page" />
<%
//added by pony on 2006-04-24 for TD4215
	WFOpinionNodeManager.updateNodeFields(request);
	System.out.println("OK.....");
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),0) ;
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0) ;
	String path = "AddOpinionField.jsp?ajax=1&wfid="+workflowid+"&nodeid="+nodeid;
	response.sendRedirect(path);
	return;
//added end.
%>