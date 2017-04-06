<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingtype=Util.null2String(request.getParameter("meetingtype"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),user.getUserSubCompany1());
if(method.equals("add"))
{
	String hrmid=Util.null2String(request.getParameter("hrmid"));
	String name=Util.null2String(request.getParameter("name"));
	String desc=Util.null2String(request.getParameter("desc"));
	
	ProcPara =  meetingtype + flag + hrmid + flag + name + flag + desc;
	RecordSet.executeProc("Meeting_Service_Insert",ProcPara);

	response.sendRedirect("/meeting/Maint/MeetingService.jsp?meetingtype="+meetingtype+"&subCompanyId="+subcompanyid);
	return;
}

String MeetingServiceIDs[]=request.getParameterValues("MeetingServiceIDs");
if(method.equals("delete"))
{
	if(MeetingServiceIDs != null)
	{
		for(int i=0;i<MeetingServiceIDs.length;i++)
		{
			ProcPara = MeetingServiceIDs[i];
			RecordSet.executeProc("Meeting_Service_Delete",ProcPara);

		}
	}

	response.sendRedirect("/meeting/Maint/MeetingService.jsp?meetingtype="+meetingtype+"&subCompanyId="+subcompanyid);
	return;
}
%>
