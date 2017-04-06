<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />

<%
	String keyword = Util.null2String(request.getParameter("keyword"));
	int groupId = Util.getIntValue(request.getParameter("groupid"));
	if(groupId>0){
	
		ArrayList<MailContact> groupedContacts = cms.getGroupedContacts(groupId, user.getUID(),keyword);
		if(groupedContacts.size()>0){
%>

<%
		for(int j=0; j<groupedContacts.size(); j++) {
			MailContact mailContact = groupedContacts.get(j);
%>
		<div data-id="0" onclick="addAddress('<%=mailContact.getMailUserName() %><<%=mailContact.getMailAddress() %>>')" title="&quot;<%=mailContact.getMailUserName() %>&quot;&lt;<%=mailContact.getMailAddress() %>&gt;" class="hand contactsItem w-200 " ><span class='overText w-100 p-l-15'><%=mailContact.getMailUserName() %></span></div>
<%
		}
		}
%>

<%}else if(groupId==0){
	

	ArrayList<MailContact> ungroupedContacts = cms.getUngroupedContacts(user.getUID(),keyword);
	if(ungroupedContacts.size() > 0) {
%>

<%	
	for(int i=0; i<ungroupedContacts.size(); i++) {
		MailContact mailContact = ungroupedContacts.get(i);
%>
		<div data-id="0" onclick="addAddress('<%=mailContact.getMailUserName() %><<%=mailContact.getMailAddress() %>>')" title="&quot;<%=mailContact.getMailUserName() %>&quot;&lt;<%=mailContact.getMailAddress() %>&gt;" class="hand contactsItem w-200 " ><span class='overText w-100 p-l-15'><%=mailContact.getMailUserName() %></span></div>
<%
	}
%>

<%		
	}
}else{
%>


<%
	ArrayList<MailContact> allContact = cms.getAllContacts(user.getUID());
%>

<%	
	for(int i=0; i<allContact.size(); i++) {
		MailContact mailContact = allContact.get(i);
%>
		<div data-id="0" onclick="addAddress('<%=mailContact.getMailUserName() %><<%=mailContact.getMailAddress() %>>')" title="&quot;<%=mailContact.getMailUserName() %>&quot;&lt;<%=mailContact.getMailAddress() %>&gt;" class="hand contactsItem w-200 " ><span class='overText w-100 p-l-15'><%=mailContact.getMailUserName() %></span></div>
<%
	}
}
%>
