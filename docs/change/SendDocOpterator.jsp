<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%
String requestids = Util.null2String(request.getParameter("requestids"));
//if(!requestids.equals("")) requestids = requestids.substring(0, requestids.length()-1);
//System.out.println(requestids);
String issuccess = DocChangeManager.SendDocManual(user.getUID(), requestids);
if(issuccess.equals("0")) {
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(23120,user.getLanguage())%>');
location.href = '/docs/change/SendDoc.jsp';
</script>
<%
}
else if(issuccess.equals("1")){
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(23121,user.getLanguage())%>');
location.href = '/docs/change/SendDoc.jsp';
</script>
<%
}
else if(issuccess.equals("-1")){
%>
<script>
alert('<%=SystemEnv.getHtmlLabelName(23121,user.getLanguage())%>\n<%=SystemEnv.getHtmlLabelName(17024,user.getLanguage())%>');
location.href = '/docs/change/SendDoc.jsp';
</script>
<%
}
%>