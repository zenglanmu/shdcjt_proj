<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<%
String loginfile = Util.getCookie(request , "loginfileweaver") ;
request.getSession(true).removeValue("moniter") ;
request.getSession(true).invalidate() ;
response.sendRedirect("/portal/Refresh.jsp?loginfile="+ loginfile) ;
%>