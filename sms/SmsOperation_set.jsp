<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SMSSaveAndSend" class="weaver.sms.SMSSaveAndSend" scope="page" />


<%
int collectionnum=Util.getIntValue(request.getParameter("collectionnum"),0);


 SMSSaveAndSend.setCollectionnum(collectionnum);






response.sendRedirect("/sms/SmsManage.jsp");
%>