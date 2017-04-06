<%@page import="weaver.email.service.MailResourceFileService"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.email.domain.*" %>
<%@page import="weaver.email.WeavermailComInfo"%>
<%@ page import="weaver.general.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="mrfs" class="weaver.email.service.MailResourceFileService" />


<%
	int mailid = Util.getIntValue(request.getParameter("mailid"),-1);
	
	//读取邮件，并加载到缓存中
	mrs.setId(mailid+"");
	mrs.setResourceid(user.getUID()+"");
	mrs.selectMailResource();
	mrs.next();
	//EML
	String _emlPath = Util.null2String(mrs.getEmlpath());
	String emlName = Util.null2String(mrs.getEmlname());
	String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;
	File eml = new File(emlPath + emlName + ".eml");
	if(!_emlPath.equals("")) eml = new File(_emlPath);
	
	String mailContent= mrs.getContent();
	if(mrs.getHashtmlimage().equals("1")){
		mrfs.selectMailResourceFileInfos(mailid+"","0");
		while(mrfs.next()){
			
			int imgId = mrfs.getId();
			String thecontentid = mrfs.getFilecontentid();
			String oldsrc = "cid:" + thecontentid ;
			String newsrc = "http://"+Util.getRequestHost(request)+"/weaver/weaver.email.FileDownloadLocation?fileid="+imgId;
			mailContent = Util.StringReplaceOnce(mailContent , oldsrc , newsrc ) ;
		}
	}
	mailContent = Util.replace(mailContent, "==br==", "\n", 0);
%>
<%=mailContent %>
