<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
	String mServerName="PDFServer.jsp";

	String mClientName=BaseBean.getPropValue("weaver_obj","iWebPDFClientName");
	if(mClientName==null||mClientName.trim().equals("")){
		mClientName="iWebPDF.ocx#version=7,1,0,206";
	}
	
	String mClassId=BaseBean.getPropValue("weaver_obj","iWebPDFClassId");
	if(mClassId==null||mClassId.trim().equals("")){
		mClassId="clsid:39E08D82-C8AC-4934-BE07-F6E816FD47A1";
	}

%>