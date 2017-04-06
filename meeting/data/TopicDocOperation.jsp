<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<%

char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingid=Util.null2String(request.getParameter("meetingid"));
String topicid=Util.null2String(request.getParameter("topicid"));
String docid=Util.null2String(request.getParameter("docid"));
String id=Util.null2String(request.getParameter("id"));

if(method.equals("add"))
{
	ProcPara =  meetingid;
	ProcPara += flag + topicid;
	ProcPara += flag + docid;
	ProcPara += flag + "" + user.getUID();

	RecordSet.executeProc("Meeting_TopicDoc_Insert",ProcPara);

	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid);
	return;
}


if(method.equals("delete"))
{

	RecordSet.executeProc("Meeting_TopicDoc_Delete",id);

	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid);
	return;
}

%>
