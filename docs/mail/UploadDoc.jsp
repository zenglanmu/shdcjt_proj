<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="MailMouldManager" class="weaver.docs.mail.MailMouldManager" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<%
	MailMouldManager.resetParameter();
  	MailMouldManager.setLanguageid(user.getLanguage());
	MailMouldManager.setClientAddress(request.getRemoteAddr());
	MailMouldManager.setUserid(user.getUID());

  	String message = MailMouldManager.UploadMailMould(request);
  	MailMouldComInfo.removeMailMouldCache();
  	if(message.startsWith("delete_")){  		
  		int id=MailMouldManager.getId();
  		String imgid=message.substring(7,8);
  		
  		response.sendRedirect("DocMouldDsp.jsp?messageid="+imgid+"&id="+id);
  	}
  	else{
	  	response.sendRedirect("DocMould.jsp");
	 }
	
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">