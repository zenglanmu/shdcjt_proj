<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="PicUploadComInfo" class="weaver.docs.tools.PicUploadComInfo" scope="page" />
<%
  	PicUploadManager.setClientAddress(request.getRemoteAddr());
	PicUploadManager.setUserid(user.getUID());
  	String imagetype = PicUploadManager.foruploadfile(request);
    String errorcode = PicUploadManager.getErrorcode();
    if(!errorcode.equals("")){
        response.sendRedirect("DocPicUploadEdit.jsp?id="+PicUploadManager.getReturnId()+"&errorcode="+errorcode);
        return;
    }

  	PicUploadComInfo.removePicUploadCache();
 	response.sendRedirect("DocPicUpload.jsp?imagetype="+imagetype);
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">