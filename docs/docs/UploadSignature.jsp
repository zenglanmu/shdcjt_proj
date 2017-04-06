<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="SignatureManager" class="weaver.docs.docs.SignatureManager" scope="page" />
<%
	SignatureManager.resetParameter();
  	//MouldManager.setLanguageid(user.getLanguage());
	//MouldManager.setClientAddress(request.getRemoteAddr());
	//MouldManager.setUserid(user.getUID());

  	String opera = SignatureManager.UploadSignature(request);

 	response.sendRedirect("SignatureList.jsp");
%>
