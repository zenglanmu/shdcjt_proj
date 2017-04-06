<%@page import="weaver.conn.RecordSet"%>
<%@page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />


<%
	
	int editfolderid = Util.getIntValue(request.getParameter("editfolderid"));
	int folderid = Util.getIntValue(request.getParameter("folderid"));
	String folderName = Util.null2String(request.getParameter("foldername"));
	String method = Util.null2String(request.getParameter("method"));
	String mailsId = Util.null2String(request.getParameter("mailsId"));
	if(method.equals("add")){
		boolean flag = fms.checkRepeatName(user.getUID(),folderName);
	
		if(!flag){
			fms.createFolder(user.getUID(), folderName);
		}else{
			out.clearBuffer();
			out.print("repeat");
		}
		
		
	}else if(method.equals("edit")){
		
		boolean flag = fms.checkRepeatName(user.getUID(),folderName,editfolderid+"");
		if(!flag){
			fms.updateFolder(user.getUID(), editfolderid, folderName);
		}else{
			out.clearBuffer();
			out.print("repeat");
		}
	}else if(method.equals("del")){
		fms.delFolder(user.getUID(), folderid);
	}else if(method.equals("clear")){
		fms.clearFolder(user.getUID(), folderid);
	}else if(method.equals("removeAll")){
		
	}else if(method.equals("addandmt")){
			boolean flag = fms.checkRepeatName(user.getUID(),folderName);
			String newfolderId="";
			if(!flag){
				fms.createFolder(user.getUID(), folderName);
				RecordSet rs = new RecordSet();
				if(rs.execute("select MAX(id) m from MailInboxFolder where userId="+user.getUID()+"")&&rs.next()){
						newfolderId=rs.getString("m");
				}
				//绑定邮件的id到最新的文件夹里面去
				if(!"".equals(mailsId)&&!"".equals(newfolderId)){
					String szmailsid[]=mailsId.split(",");
					for(int i=0;i<szmailsid.length;i++){
						if(!"".equals(szmailsid[i])){
									rs.execute("update mailresource set folderid='"+newfolderId+"' where id='"+szmailsid[i]+"'");
						}
					}
				}
			}else{
					out.clearBuffer();
					out.print("repeat");
			}
			
	}
%>