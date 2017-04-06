<%@ page language="java" contentType="text/html; charset=gbk" %> 
<jsp:useBean id="mailSend" class="weaver.email.MailSend" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<%
String isSent = "";

try{
	isSent = mailSend.sendMail(request, user) ;
}catch(Exception e){
	out.println(e);
	e.printStackTrace();
	return;
}

//out.println(isSent);
String savedraft =mailSend.getSavedraft();
if(savedraft.equals("1")){
	response.sendRedirect("/email/new/MailAdd.jsp?flag=4&id="+mailSend.getMailId());
	
}else{
	response.sendRedirect("/email/new/MailDone.jsp?isSent="+isSent+"");
}
%>
