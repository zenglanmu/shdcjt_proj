<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.formmode.data.ModeDataManager" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int pageexpandid = Util.getIntValue(request.getParameter("pageexpandid"),0);
int modeid = Util.getIntValue(request.getParameter("modeid"),-1);
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(request.getParameter("billid"),-1);
ModeDataManager ModeDataManager = new ModeDataManager(billid,modeid);
ModeDataManager.setPageexpandid(pageexpandid);
ModeDataManager.doInterface(pageexpandid);
%>
<%=true%>
