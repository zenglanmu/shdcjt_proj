<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workspace.WorkSpaceInfo" %>
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="JavaScript" src="/js/weaver.js"></SCRIPT>
</HEAD>

<%

String userId = String.valueOf(user.getUID());
String userType = user.getLogintype();
WorkSpaceInfo infoCollection = new WorkSpaceInfo(request);
int newsUnreadCount = infoCollection.getNewsUnreadCount();
int newsAmount = infoCollection.getNewsAmount();
int docsUnreadCount = infoCollection.getDocsUnreadCount();
int docsApproveCount = infoCollection.getDocsApproveCount();
//int docsSubscibeCount = infoCollection.getDocsSubscibeCount();
int docsAmount = infoCollection.getDocsAmount();
int docsCreatedCount = infoCollection.getDocsCreatedCount();
int projParticipantCount = infoCollection.getProjParticipantCount();
int projUnachievedCount = infoCollection.getProjUnachievedCount();
int projNewCount = infoCollection.getProjNewCount();
int projApproveCount = infoCollection.getProjApproveCount();
int crmManageCount = infoCollection.getCrmManageCount();
int crmNewCount = infoCollection.getCrmNewCount();
int crmContactCount = infoCollection.getCrmContactCount();
int crmApproveCount = infoCollection.getCrmApproveCount();
int meetAttendAmount = infoCollection.getMeetAttendAmount();
int meetNewCount = infoCollection.getMeetNewCount();
int meetApproveCount = infoCollection.getMeetApproveCount();
int reqPendingCount = infoCollection.getReqPendingCount();
int reqDefaultCount = infoCollection.getReqDefaultCount();
int reqPendingUnreadCount = infoCollection.getReqPendingUnreadCount();
int reqDefaultUnreadCount = infoCollection.getReqDefaultUnreadCount();
int myRequestAmount = infoCollection.getMyRequestAmount();
int myRequestFeedBackCount = infoCollection.getMyRequestFeedBackCount();
int myDefaultAmount = infoCollection.getMyDefaultAmount();
int myDefaultFeedBackCount = infoCollection.getMyDefaultFeedBackCount();

int myCoworkCount = infoCollection.getMyCoworkCount();//new add by xys 2005-08-03

int mailAmount = infoCollection.getMailAmount();
int planFeedbackCount = infoCollection.getPlanFeedbackCount();
int planApproveCount = infoCollection.getPlanApproveCount();
%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#E3E3E3">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="15">
<TR>
	<TD height="6" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">	
		<TABLE class="ViewForm" width="100%">
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(18124,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您未阅读(<A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=userType%>&docpublishtype=5" target="_parent"><%=newsUnreadCount%></A>)篇,
		系统现有(<A href="/docs/search/DocSearchTemp.jsp?list=all&loginType=<%=userType%>&docpublishtype=5" target="_parent"><%=newsAmount%></A>)篇新闻公告.
		<%}else if(user.getLanguage()==8){%>
		(<A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=userType%>&docpublishtype=5" target="_parent"><%=newsUnreadCount%></A>) are unread,
		totally (<A href="/docs/search/DocSearchTemp.jsp?list=all&loginType=<%=userType%>&docpublishtype=5" target="_parent"><%=newsAmount%></A>) news.
		<%}else if(user.getLanguage()==9){%>
		您未閱讀(<A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=userType%>&docpublishtype=5" target="_parent"><%=newsUnreadCount%></A>)篇, 
		系統現有(<A href="/docs/search/DocSearchTemp.jsp?list=all&loginType=<%=userType%>&docpublishtype=5" target="_parent"><%=newsAmount%></A>)篇新聞公告.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(2115,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您未阅读(<A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=userType%>" target="_parent"><%=docsUnreadCount%></A>)篇,
		有(<A href="/docs/docs/ApproveDocList.jsp" target="_parent"><%=docsApproveCount%></A>)篇需要您审批,
		系统现有(<A href="/docs/search/DocSearchTemp.jsp?list=all&loginType=<%=userType%>" target="_parent"><%=docsAmount%></A>)篇文档,
		您创建(<A href="/docs/search/DocView.jsp?dspreply=0" target="_parent"><%=docsCreatedCount%></A>)篇文档.
		<%}else if(user.getLanguage()==8){%>
		(<A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=userType%>" target="_parent"><%=docsUnreadCount%></A>) are unread,
		and (<A href="/docs/docs/ApproveDocList.jsp" target="_parent"><%=docsApproveCount%></A>) should be approved,totally (<A href="/docs/search/DocSearchTemp.jsp?list=all&loginType=<%=userType%>" target="_parent"><%=docsAmount%></A>) documents,
		and (<A href="/docs/search/DocView.jsp?dspreply=0" target="_parent"><%=docsCreatedCount%></A>) you created.
		<%}else if(user.getLanguage()==9){%>
		您未閱讀(<A href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=userType%>" target="_parent"><%=docsUnreadCount%></A>)篇, 
		有(<A href="/docs/docs/ApproveDocList.jsp" target="_parent"><%=docsApproveCount%></A>)篇需要您審批, 
		系統現有(<A href="/docs/search/DocSearchTemp.jsp?list=all&loginType=<%=userType%>" target="_parent"><%=docsAmount%></A>)篇文檔, 
		您創建(<A href="/docs/search/DocView.jsp?dspreply=0" target="_parent"><%=docsCreatedCount%></A>)篇文檔.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(2114,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您共参与了(<A href="/proj/data/MyProject.jsp" target="_parent"><%=projParticipantCount%></A>)个项目,
		还有(<A href="/proj/data/MyProject.jsp?ProjectStatus=12" target="_parent"><%=projUnachievedCount%></A>)个项目未完成,
		有(<A href="/proj/data/MyProject.jsp?unread=1" target="_parent"><%=projNewCount%></A>)个新项目分配,
		有(<A href="/proj/data/ProjectApproval.jsp" target="_parent"><%=projApproveCount%></A>)个需要审批.
		<%}else if(user.getLanguage()==8){%>
		Joined (<A href="/proj/data/MyProject.jsp" target="_parent"><%=projParticipantCount%></A>) projects,
		and (<A href="/proj/data/MyProject.jsp?ProjectStatus=12" target="_parent"><%=projUnachievedCount%></A>) are not completed,
		(<A href="/proj/data/MyProject.jsp?unread=1" target="_parent"><%=projNewCount%></A>) will be distributed, (<A href="/proj/data/ProjectApproval.jsp" target="_parent"><%=projApproveCount%></A>) are to be approved.
		<%}else if(user.getLanguage()==9){%>
		您共參與了(<A href="/proj/data/MyProject.jsp" target="_parent"><%=projParticipantCount%></A>)個項目, 
		還有(<A href="/proj/data/MyProject.jsp?ProjectStatus=12" target="_parent"><%=projUnachievedCount%></A>)個項目未完成, 
		有(<A href="/proj/data/MyProject.jsp?unread=1" target="_parent"><%=projNewCount%></A>)個新項目分配, 
		有(<A href="/proj/data/ProjectApproval.jsp" target="_parent"><%=projApproveCount%></A>)個需要審批.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(2113,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您共管理了(<A href="/CRM/search/SearchOperation.jsp?msg=report&settype=manager&id=<%=userId%>" target="_parent"><%=crmManageCount%></A>)个客户,
		有(<A href="/CRM/data/NewCustomerList.jsp" target="_parent"><%=crmNewCount%></A>)个新客户分配,
		有(<A href="/CRM/data/CRMContactRemind.jsp" target="_parent"><%=crmContactCount%></A>)个需要联系,
		有(<A href="/CRM/data/ApproveCustomerList.jsp" target="_parent"><%=crmApproveCount%></A>)个需要审批.
		<%}else if(user.getLanguage()==8){%>
		Managing (<A href="/CRM/search/SearchOperation.jsp?msg=report&settype=manager&id=<%=userId%>" target="_parent"><%=crmManageCount%></A>),
		(<A href="/CRM/data/NewCustomerList.jsp" target="_parent"><%=crmNewCount%></A>) should be distributed,
		(<A href="/CRM/data/CRMContactRemind.jsp" target="_parent"><%=crmContactCount%></A>) should be connected,
		(<A href="/CRM/data/ApproveCustomerList.jsp" target="_parent"><%=crmApproveCount%></A>) should be approved.
		<%}else if(user.getLanguage()==9){%>
		您共管理了(<A href="/CRM/search/SearchOperation.jsp?msg=report&settype=manager&id=<%=userId%>" target="_parent"><%=crmManageCount%></A>)個客戶, 
		有(<A href="/CRM/data/NewCustomerList.jsp" target="_parent"><%=crmNewCount%></A>)個新客戶分配, 
		有(<A href="/CRM/data/CRMContactRemind.jsp" target="_parent"><%=crmContactCount%></A>)個需要聯繫, 
		有(<A href="/CRM/data/ApproveCustomerList.jsp" target="_parent"><%=crmApproveCount%></A>)個需要審批.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(18442,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您共参加了(<%if (userType.equals("1")) {%><A href="/meeting/search/SearchOperation.jsp?hrmids=<%=userId%>&meetingstatus=2" target="_parent"><%} else {%><A href="/meeting/search/SearchOperation.jsp?crmids=<%=userId%>" target="_parent"><%}%><%=meetAttendAmount%></A>)个会议,
		有(<A href="/meeting/data/NewMeetings.jsp" target="_parent"><%=meetNewCount%></A>)个新会议要参加,
		有(<A href="/meeting/data/MeetingApproval.jsp" target="_parent"><%=meetApproveCount%></A>)需要审批.
		<%}else if(user.getLanguage()==8){%>
		Attended (<%if (userType.equals("1")) {%><A href="/meeting/search/SearchOperation.jsp?hrmids=<%=userId%>&meetingstatus=2" target="_parent"><%} else {%><A href="/meeting/search/SearchOperation.jsp?crmids=<%=userId%>" target="_parent"><%}%><%=meetAttendAmount%></A>) meetings,
		(<A href="/meeting/data/NewMeetings.jsp" target="_parent"><%=meetNewCount%></A>) new meetings are for you to attend,
		(<A href="/meeting/data/MeetingApproval.jsp" target="_parent"><%=meetApproveCount%></A>) should be approved.
		<%}else if(user.getLanguage()==9){%>
		您共參加了(<%if (userType.equals("1")) {%><A href="/meeting/search/SearchOperation.jsp?hrmids=<%=userId%>&meetingstatus=2" target=" _parent"><%} else {%><A href="/meeting/search/SearchOperation.jsp?crmids=<%=userId%>" target="_parent"><%}%><%=meetAttendAmount%> </A>)個會議, 
		有(<A href="/meeting/data/NewMeetings.jsp" target="_parent"><%=meetNewCount%></A>)個新會議要參加, 
		有(<A href="/meeting/data/MeetingApproval.jsp" target="_parent"><%=meetApproveCount%></A>)需要審批.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您共有(<A href="WorkSpaceRequest.jsp?type=11" target="_parent"><%=reqPendingCount%></A>)个待办工作流程,
		有(<A href="WorkSpaceRequest.jsp?type=12" target="_parent"><%=reqDefaultCount%></A>)个待办默认流程,
		有(<A href="WorkSpaceRequest.jsp?type=13" target="_parent"><%=reqPendingUnreadCount%></A>)个新待办工作流程要处理,
		有(<A href="WorkSpaceRequest.jsp?type=14" target="_parent"><%=reqDefaultUnreadCount%></A>)个新待办默认流程.
		<%}else if(user.getLanguage()==8){%>
		You have (<A href="WorkSpaceRequest.jsp?type=11" target="_parent"><%=reqPendingCount%></A>) pending workflows,
		and (<A href="WorkSpaceRequest.jsp?type=12" target="_parent"><%=reqDefaultCount%></A>) default pending workflows,
		and (<A href="WorkSpaceRequest.jsp?type=13" target="_parent"><%=reqPendingUnreadCount%></A>) new pending workflows to do with,
		and (<A href="WorkSpaceRequest.jsp?type=14" target="_parent"><%=reqDefaultUnreadCount%></A>) new default pending workflows.
		<%}else if(user.getLanguage()==9){
		%>
		您共有(<A href="WorkSpaceRequest.jsp?type=11" target="_parent"><%=reqPendingCount%></A>)個待辦工作流程, 
		有(<A href="WorkSpaceRequest.jsp?type=12" target="_parent"><%=reqDefaultCount%></A>)個待辦默認流程, 
		有(<A href="WorkSpaceRequest.jsp?type=13" target="_parent"><%=reqPendingUnreadCount%></A>)個新待辦工作流程要處理, 
		有(<A href="WorkSpaceRequest.jsp?type=14" target="_parent"><%=reqDefaultUnreadCount%></A>)個新待辦默認流程.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(1210,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		您共发出(<A href="WorkSpaceRequest.jsp?type=51" target="_parent"><%=myRequestAmount%></A>)个请求,
		有(<A href="WorkSpaceRequest.jsp?type=52" target="_parent"><%=myDefaultAmount%></A>)个默认请求,
		有(<A href="WorkSpaceRequest.jsp?type=53" target="_parent"><%=myRequestFeedBackCount%></A>)个请求被反馈,
		有(<A href="WorkSpaceRequest.jsp?type=54" target="_parent"><%=myDefaultFeedBackCount%></A>)个默认请求被反馈.
		<%}else if(user.getLanguage()==8){%>
		You have sent (<A href="WorkSpaceRequest.jsp?type=51" target="_parent"><%=myRequestAmount%></A>) requests,
		and (<A href="WorkSpaceRequest.jsp?type=52" target="_parent"><%=myDefaultAmount%></A>) default requests,
		and (<A href="WorkSpaceRequest.jsp?type=53" target="_parent"><%=myRequestFeedBackCount%></A>) requests are feeded back,
		and (<A href="WorkSpaceRequest.jsp?type=54" target="_parent"><%=myDefaultFeedBackCount%></A>) default requests are feeded back.
		<%}else if(user.getLanguage()==9){%>
		您共發出(<A href="WorkSpaceRequest.jsp?type=51" target="_parent"><%=myRequestAmount%></A>)個請求, 
		有(<A href="WorkSpaceRequest.jsp?type=52" target="_parent"><%=myDefaultAmount%></A>)個默認請求, 
		有(<A href="WorkSpaceRequest.jsp?type=53" target="_parent"><%=myRequestFeedBackCount%></A>)個請求被反饋, 
		有(<A href="WorkSpaceRequest.jsp?type=54" target="_parent"><%=myDefaultFeedBackCount%></A>)個默認請求被反饋.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(17716,user.getLanguage())%></B>:
		<%if(user.getLanguage()==7){%>
		您共有(<A href="/cowork/coworkview.jsp?type=new" target="_parent"><%=myCoworkCount%></A>)个未查看协作.
		<%}else if(user.getLanguage()==8){%>
		You have (<A href="/cowork/coworkview.jsp?type=new" target="_parent"><%=myCoworkCount%></A>) unread coworks.
		<%}else if(user.getLanguage()==9){%>
		您共有(<A href="/cowork/coworkview.jsp?type=new" target="_parent"><%=myCoworkCount%></A>)個未查看協作.
		<%}%>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(1213,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
			<%if (mailAmount == -1) {%>
			邮件系统未<A href="/email/Weavermail.jsp" target="_parent">登陆</A>.
			<%} else {%>
			您的收件夹中共有(<A href="/email/Weavermail.jsp" target="_parent"><%=mailAmount%></A>)封邮件.
			<%}%>
		<%}else if(user.getLanguage()==8){%>
			<%if (mailAmount == -1) {%>
			You have not <A href="/email/Weavermail.jsp" target="_parent">Login</A> your mail system.
			<%} else {%>
			There are (<A href="/email/Weavermail.jsp" target="_parent"><%=mailAmount%></A>) mails in your folder.
			<%}%>			
		<%}else if(user.getLanguage()==9){
		%>
			<%if (mailAmount == -1) {%>
			郵件系統未<A href="/email/Weavermail.jsp" target="_parent">登陸</A>. 
			<%} else {%> 
			您的收件夾中共有(<A href="/email/Weavermail.jsp" target="_parent"><%=mailAmount%></A>)封郵件.
			<%}%>	
		<%} %>
		</TD></TR>
		<TR style="height:1px;" bgcolor="#000000"><TD colspan="2"></TD></TR>
		<TR><TD width="15" align="center"><TABLE width="5" height="5">
		<TR><TD></TD></TR></TABLE></TD><TD><B><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></B>: 
		<%if(user.getLanguage()==7){%>
		你的计划(<A href="/workplan/search/WorkPlanSearchResult.jsp?advanced=1" target="_parent"><%=planFeedbackCount%></A>)个被反馈,
		您有(<A href="/workplan/search/WorkPlanSearchResult.jsp?advanced=2" target="_parent"><%=planApproveCount%></A>)个计划需要审批完成,
		我的<A href="/workplan/report/WorkPlanReport.jsp?type=6" target="_parent">工作计划和总结</A>.
		<%}else if(user.getLanguage()==8){%>
		Your (<A href="/workplan/search/WorkPlanSearchResult.jsp?advanced=1" target="_parent"><%=planFeedbackCount%></A>) plans are feeded back,
		and (<A href="/workplan/search/WorkPlanSearchResult.jsp?advanced=2" target="_parent"><%=planApproveCount%></A>) are to be approved.
		My <A href="/workplan/report/WorkPlanReport.jsp?type=6" target="_parent">Work Plan</A>.
		<%}else if(user.getLanguage()==9){%>
		你的計劃(<A href="/workplan/search/WorkPlanSearchResult.jsp?advanced=1" target="_parent"><%=planFeedbackCount%></A>)個被反饋, 
		您有(<A href="/workplan/search/WorkPlanSearchResult.jsp?advanced=2" target="_parent"><%=planApproveCount%></A>)個計劃需要審批完成, 
		我的<A href="/workplan/report/WorkPlanReport.jsp?type=6" target="_parent">工作計劃和總結</A>.
		<%}%>
		</TD></TR>
		</TABLE>			 
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

</BODY>
<SCRIPT language="JavaScript">
function doAdd() {
	if (check_form(document.frmmain, "note"))
		document.frmmain.submit();
}
</SCRIPT>
</HTML>