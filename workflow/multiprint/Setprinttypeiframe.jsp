<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String multirequestid = Util.null2String(request.getParameter("multirequestid"));
String sql_tmp = "update workflow_requestbase set ismultiprint=1 where requestid in ("+multirequestid+"0)";
rs.executeSql(sql_tmp);

%>