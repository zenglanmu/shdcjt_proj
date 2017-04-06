<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />
<%
char flag = Util.getSeparator();
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),user.getUserSubCompany1());
int subid = Util.getIntValue(request.getParameter("subid"),user.getUserSubCompany1());
if(method.equals("add"))
{
	String name=Util.null2String(request.getParameter("name"));
	String approver=Util.null2String(request.getParameter("approver"));
	String desc=Util.null2String(request.getParameter("desc"));
	String catalogpath = Util.null2String(request.getParameter("catalogpath"));
	
	ProcPara =  name + flag + approver + flag + desc+flag+""+subcompanyid+flag+""+catalogpath;
	RecordSet.executeProc("Meeting_Type_Insert",ProcPara);

	response.sendRedirect("/meeting/Maint/MeetingType_left.jsp?subCompanyId="+subid);
	return;
}

if(method.equals("edit"))
{
	String id=Util.null2String(request.getParameter("id"));
	String name=Util.null2String(request.getParameter("name"));
	String approver=Util.null2String(request.getParameter("approver"));
	String desc=Util.null2String(request.getParameter("desc"));
	String catalogpath = Util.null2String(request.getParameter("catalogpath"));
	
	ProcPara = id + flag + name + flag + approver + flag + desc+flag+""+subcompanyid+flag+""+catalogpath;
	RecordSet.executeProc("Meeting_Type_Update",ProcPara);

	response.sendRedirect("/meeting/Maint/MeetingType_left.jsp?subCompanyId="+subid);
	return;
}

String MeetingTypeIDs[]=request.getParameterValues("MeetingTypeIDs");
if(method.equals("delete"))
{
     String noDelMeetTypes ="";
	if(MeetingTypeIDs != null)
	{
		for(int i=0;i<MeetingTypeIDs.length;i++)
		{
            ProcPara = MeetingTypeIDs[i];
            if (MeetingUtil.isAllowMeetingTypeDel(ProcPara)) {
                RecordSet.executeProc("Meeting_Type_Delete",ProcPara);
            } else {
               noDelMeetTypes += MeetingUtil.getMeetingTypeName(ProcPara)+"," ;
            }			
		}
	}
    if(noDelMeetTypes.length()>0) 
    noDelMeetTypes = noDelMeetTypes.substring(0,noDelMeetTypes.length()-1);
    session.setAttribute("noDelMeetTypes",noDelMeetTypes);
	response.sendRedirect("/meeting/Maint/MeetingType_left.jsp?subCompanyId="+subid);
	return;
}
%>
