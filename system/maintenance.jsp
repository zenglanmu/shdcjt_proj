<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />


<%
	String toPage="/hrm/HrmMaintenance.jsp?mainttype=H";
	if(software.equals("CRM")) toPage="/CRM/CRMMaintenance.jsp?mainttype=C";
	else if(software.equals("KM")) toPage="/docs/DocMaintenance.jsp?mainttype=D";
	response.sendRedirect(toPage);
%>