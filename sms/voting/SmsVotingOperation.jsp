<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="smsVotingManager" class="weaver.smsvoting.SmsVotingManager" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
int retInt = 0;
String method = Util.null2String(request.getParameter("method"));
int smsvotingid = Util.getIntValue(request.getParameter("id"), 0);
smsVotingManager.setRequest(request);
smsVotingManager.setUser(user);
if("add".equalsIgnoreCase(method)){
	retInt = smsVotingManager.addSmsVoting();
}else if("edit".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where status=0 and creater="+user.getUID()+" and id="+smsvotingid);
	if(rs.next()){
		retInt = smsVotingManager.editSmsVoting();
	}
}else if("delete".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where creater="+user.getUID()+" and id="+smsvotingid);
	if(rs.next()){
		retInt = smsVotingManager.deleteSmsVoting();
	}
}else if("end".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where creater="+user.getUID()+" and status=1 and id="+smsvotingid);
	if(rs.next()){
		retInt = smsVotingManager.endSmsVoting();
	}
}else if("reopen".equalsIgnoreCase(method)){
	rs.execute("select * from smsvoting where creater="+user.getUID()+" and status=2 and id="+smsvotingid);
	if(rs.next()){
		retInt = smsVotingManager.reopenSmsVoting();
	}
}




response.sendRedirect("SmsVotingList.jsp");
%>