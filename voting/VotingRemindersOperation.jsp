<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="vr" class="weaver.voting.VotingReminiders" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String method = Util.null2String(request.getParameter("method"));
String votingid = Util.null2String(request.getParameter("votingid"));
String sendtype = Util.null2String(request.getParameter("sendtype"));
String decision = Util.null2String(request.getParameter("decision"));
if(method.equals("reminders")){
	if(!"".equals(votingid) && !"".equals(sendtype)) {
		String votingname = "";
		String hostid = Util.getRequestHost(request);
		RecordSet.executeSql("select subject from Voting where id = "+votingid);
		if(RecordSet.next()) votingname = RecordSet.getString(1);
		vr.sendRemindersMethod(votingid,votingname,sendtype,decision,hostid);
	}
}
%>
<script type="text/javascript">
	window.parent.returnValue = {id:"", name:""};
	window.parent.close();
</script>