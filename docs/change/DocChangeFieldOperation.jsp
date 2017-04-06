<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%
boolean isok = DocChangeManager.saveChangeFields(request, user.getUID());
if(isok) {
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>');
location.href = 'DocChangeField.jsp?wfid=<%=request.getParameter("wfid")%>&changeid=<%=request.getParameter("changeid")%>';
</script>
<%
}
else {
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage())%>');
location.href = 'DocChangeField.jsp?wfid=<%=request.getParameter("wfid")%>&changeid=<%=request.getParameter("changeid")%>';
</script>
<%
}
%>