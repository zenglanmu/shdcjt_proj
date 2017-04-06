<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int objId = Util.getIntValue(request.getParameter("objId"));
int flowId = Util.getIntValue(request.getParameter("flowId"));
String syc = Util.null2String(request.getParameter("syc"));
 BudgetHandler.auditMapEdit(syc,objId,flowId);
 response.sendRedirect("AuditSetting.jsp");
%>
