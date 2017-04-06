<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page" />
<jsp:useBean id="MeetingUtil" class="weaver.meeting.MeetingUtil" scope="page" />

<%
char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String meetingtype=Util.null2String(request.getParameter("meetingtype"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),user.getUserSubCompany1());
int subid = Util.getIntValue(request.getParameter("subid"),user.getUserSubCompany1());
if(method.equals("add"))
{
	String hrmid=Util.null2String(request.getParameter("hrmid"));
	String name=Util.null2String(request.getParameter("name"));
	String desc=Util.null2String(request.getParameter("desc"));
	
	ProcPara =  name + flag + desc + flag + hrmid+flag+""+subcompanyid;
	RecordSet.executeProc("MeetingRoom_Insert",ProcPara);
    MeetingRoomComInfo.removeMeetingRoomInfoCache();
	response.sendRedirect("/meeting/Maint/MeetingRoom_left.jsp?subCompanyId="+subid);
	return;
}

String MeetingRoomIDs[]=request.getParameterValues("MeetingRoomIDs");
if(method.equals("delete")){
    String noDelRooms ="";

	if(MeetingRoomIDs != null)
	{
		for(int i=0;i<MeetingRoomIDs.length;i++)
		{
			ProcPara = MeetingRoomIDs[i];
            //System.out.println(ProcPara);
            if (MeetingUtil.isAllowRoomDel(ProcPara)) {
                RecordSet.executeProc("MeetingRoom_DeleById",ProcPara);
            } else {
               noDelRooms += MeetingUtil.getRoomName(ProcPara)+"," ;
            }
		}
	}
    //For TD2704:删除一个没有被引用的会议室时，报错。
    if (noDelRooms.length()!=0){
        noDelRooms = noDelRooms.substring(0,noDelRooms.length()-1);
        session.setAttribute("noDelRooms",noDelRooms);
        MeetingRoomComInfo.removeMeetingRoomInfoCache();
    }
	response.sendRedirect("/meeting/Maint/MeetingRoom_left.jsp?subCompanyId="+subid);
	return;
}

if(method.equals("edit"))
{   
    String id=Util.null2String(request.getParameter("id"));
	String hrmid=Util.null2String(request.getParameter("hrmid"));
	String name=Util.null2String(request.getParameter("name"));
	String desc=Util.null2String(request.getParameter("desc"));
	
	ProcPara = id + flag + name + flag + desc + flag + hrmid+flag+""+subcompanyid;
	RecordSet.executeProc("MeetingRoom_Update",ProcPara);
    MeetingRoomComInfo.removeMeetingRoomInfoCache();
	response.sendRedirect("/meeting/Maint/MeetingRoom_left.jsp?subCompanyId="+subid);
	return;
}

%>
