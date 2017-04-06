<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="net.sf.json.*" %>
<%
			//org.json.simple
			int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
			String receivemailid = Util.null2String(request.getParameter("receivemailid"));
			String star = Util.null2String(request.getParameter("star"));
			String labelid = Util.null2String(request.getParameter("labelid"));
			String folderid = Util.null2String(request.getParameter("folderid"));	
			String receivemail = Util.null2String(request.getParameter("receivemail"));	
			String subject = Util.null2String(request.getParameter("subject"));		
			String from = Util.null2String(request.getParameter("from"));
			String to = Util.null2String(request.getParameter("to"));		
			String status = Util.null2String(request.getParameter("status"));	
			String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
			String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));	
			String startdate = Util.null2String(request.getParameter("startdate"));
			String enddate = Util.null2String(request.getParameter("enddate"));
			JSONObject json = new JSONObject();
			mrs.resetParameter();
			//总邮件数
			mrs.setResourceid(user.getUID()+"");
			mrs.setFolderid(folderid);
			mrs.setSubject(subject.trim());
			mrs.setLabelid(labelid);
			mrs.setStarred(star);
			mrs.setSendfrom(from);
			mrs.setSendto(to);
			mrs.setAttachmentnumber(attachmentnumber);
			mrs.setMailaccountid(mailaccountid);
			mrs.setIsInternal(isInternal);
			mrs.setStartdate(startdate);
			mrs.setEnddate(enddate);
			mrs.selectMailResource();
			json.accumulate("totalMailCount", mrs.getRecordCount());
			int unreadMailCount =0;
			//System.out.print(folderid+"33");
			if(!folderid.equals("-1")&&!folderid.equals("-2")){
				//获取未读邮件总数
				mrs.setStatus("");
				mrs.setStatus("0");
				mrs.selectMailResource();
				unreadMailCount = mrs.getRecordCount();
			}else if((folderid.equals("")&&!"".equals(labelid))||isInternal==1){
				//获取未读邮件总数
				mrs.setStatus("");
				mrs.setStatus("0");
				mrs.selectMailResource();
				unreadMailCount = mrs.getRecordCount();
			}
			json.accumulate("unreadMailCount", unreadMailCount);
			out.clear();
			out.println(json);
%>