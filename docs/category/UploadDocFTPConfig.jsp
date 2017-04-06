<%@ page language="java" contentType="text/html; charset=GBK" %> 


<jsp:useBean id="DocFTPConfigManager" class="weaver.docs.category.DocFTPConfigManager" scope="page" />
<jsp:useBean id="DocFTPConfigComInfo" class="weaver.docs.category.DocFTPConfigComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%

  	String message = DocFTPConfigManager.UploadDocFTPConfig(request);
  	DocFTPConfigComInfo.removeCache();

	response.sendRedirect("DocFTPConfig.jsp");

	
%>
