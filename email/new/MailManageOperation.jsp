<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />


<%
	
	String operation = Util.null2String(request.getParameter("operation"));
	String[] mailsId = Util.null2String(request.getParameter("mailsId")).split(",");
	String mailId = Util.null2String(request.getParameter("mailId"));
	String lableId = Util.null2String(request.getParameter("lableId"));
	String star = Util.null2String(request.getParameter("star"));
	String movetoFolder = Util.null2String(request.getParameter("movetoFolder"));
	String status = Util.null2String(request.getParameter("status"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	//System.out.println("operation=-----------------------------------"+operation);
	if(operation.equals("addLable")) {
		mrs.addLable(mailsId, lableId);
	} else if(operation.equals("removeLable")) {
		mrs.removeLable(mailId, lableId);
	} else if(operation.equals("updateStar")) {
		mrs.updateStar(mailId, star);
	}else if(operation.equals("move")){
		mrs.moveMailToFolder(mailId, movetoFolder);
	}else if(operation.equals("delete")){
		 String emlPath=application.getRealPath("")+"email\\eml\\";
		 //System.out.println(emlPath);
		 mrs.deleteMail(mailId,user.getUID(),emlPath);
	}else if(operation.equals("updateStatus")){
		
		mrs.updateMailResourceStatus(status,mailId,user.getUID());
	}else if(operation.equals("editLayout")){
		String layout  = Util.null2String(request.getParameter("layout"));
		mss.updateLayout(user.getUID(),layout);
	}else if (operation.equals("deleteAll")){
		 String emlPath=application.getRealPath("")+"email\\eml\\";
		 //System.out.println(emlPath);
		 mrs.deleteFolderMail(folderid,user.getUID(),emlPath);
	}else if (operation.equals("cancelLabel")){
		for(int i=0;i<mailsId.length;i++){
				mrs.removeALLLable(mailsId[i], lableId);
		}
	}
%>