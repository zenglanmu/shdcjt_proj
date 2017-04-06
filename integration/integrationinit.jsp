<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%
	if(!HrmUserVarify.checkUserRight("IntegratedManagement:Maint",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
%>