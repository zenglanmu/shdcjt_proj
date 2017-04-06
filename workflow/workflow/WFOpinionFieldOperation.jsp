<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WFOpinionManager" class="weaver.workflow.workflow.WFOpinionManager" scope="page" />
<%
//added by pony on 2006-04-24 for TD4215
	WFOpinionManager.processFields(request);
	//System.out.println("OK.....");
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),0) ;
	String path = "WFOpinionField.jsp?ajax=1&wfid="+workflowid;
	response.sendRedirect(path);
	return;
//added end.
%>