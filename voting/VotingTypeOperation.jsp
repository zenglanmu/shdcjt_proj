<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String name=Util.null2String(request.getParameter("name"));
int approver=Util.getIntValue(request.getParameter("approver"),0);
if(method.equals("add")) {
	if(!"".equals(name)) {
		RecordSet.executeSql("insert into voting_type (typename,approver) values ('"+name+"',"+approver+")");
	}
	response.sendRedirect("/voting/VotingType.jsp");
	return;
}

if(method.equals("edit")) {
	String id=Util.null2String(request.getParameter("id"));
	if(!"".equals(id) && !"".equals(name)) {
		RecordSet.executeSql("update voting_type set typename = '"+name+"',approver="+approver+" where id ="+id);
	}
	response.sendRedirect("/voting/VotingType.jsp");
	return;
}

String votingTypeIDs[]=request.getParameterValues("votingTypeIDs");
if(method.equals("delete")) {
    String noDelVotingTypes ="";
	if(votingTypeIDs != null) {
		for(int i=0;i<votingTypeIDs.length;i++) {
			RecordSet.executeSql("select subject from Voting where votingtype="+votingTypeIDs[i]);
			while(RecordSet.next()) {
				noDelVotingTypes += RecordSet.getString(1)+"," ;
			}
			if(RecordSet.getCounts() <= 0) {
				rs.executeSql("delete from voting_type where id ="+votingTypeIDs[i]);
			}
		}
	}
    if(noDelVotingTypes.length()>0) 
    noDelVotingTypes = noDelVotingTypes.substring(0,noDelVotingTypes.length()-1);
    session.setAttribute("noDelVotingTypes",noDelVotingTypes);
    response.sendRedirect("/voting/VotingType.jsp");
	return;
}
%>
