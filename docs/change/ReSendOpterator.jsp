<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%
String requestid = request.getParameter("requestid");
String cids = request.getParameter("cids");
DocChangeManager.doSendDoc(user.getUID(), user.getUID(), requestid, cids);
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(23119,user.getLanguage())%>');
location.href='ChangeDetailBrowser.jsp?requestid=<%=requestid%>';
</script>