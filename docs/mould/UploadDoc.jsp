<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<%
	MouldManager.resetParameter();
  	MouldManager.setLanguageid(user.getLanguage());
	MouldManager.setClientAddress(request.getRemoteAddr());
	MouldManager.setUserid(user.getUID());

  	String message = MouldManager.UploadMould(request);
  	DocMouldComInfo.removeDocMouldCache();
  	if(message.startsWith("delete_")){  		
  		int id=MouldManager.getId();
  		MouldManager.getMouldInfoById();
  		int mouldType = MouldManager.getMouldType();
  		String imgid=message.substring(7,8);
  		if(mouldType>1)
  			response.sendRedirect("DocMouldDspExt.jsp?messageid="+imgid+"&id="+id);
  		else
  			response.sendRedirect("DocMouldDsp.jsp?messageid="+imgid+"&id="+id);
  	}
  	else{
	  	response.sendRedirect("DocMould.jsp");
	 }
	
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">