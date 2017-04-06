<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.Util" %>

<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>

<jsp:useBean id="DocMonitorManager" class="weaver.system.systemmonitor.docs.DocMonitorManager" scope="page" />

<%

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String docIdSelected = Util.null2String(request.getParameter("docIdSelected")) ;

DocMonitorManager.setClientAddress(request.getRemoteAddr());
DocMonitorManager.executeDocMonitor(docIdSelected,operation,user);

response.sendRedirect("DocMonitor.jsp?operation="+operation+"&needSubmit=1");



%>