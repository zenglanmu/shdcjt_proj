<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="cssFileManager" class="weaver.workflow.html.CssFileManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int id = Util.getIntValue(request.getParameter("cssid"));//id是保留字符，所以没办法用
String opttype = Util.null2String(request.getParameter("opttype"));
if("save".equals(opttype)){
	id = cssFileManager.updateCssDetail(request);
	response.sendRedirect("/workflow/html/WorkFlowCssList.jsp");
	return;
}else if("delete".equals(opttype)){
	cssFileManager.deleteCssFiles(""+id);
	response.sendRedirect("/workflow/html/WorkFlowCssList.jsp");
	return;
}

%>