<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%

	int userid = user.getUID();
	String wfid = Util.null2String(request.getParameter("wfid"));
	if(wfid.equals("")){
		return;
	}
	rs.execute("select COUNT(*) as count from WorkflowUseCount where wfid="+wfid+" and userid="+userid);
	if(rs.next()){
		if(rs.getInt("count")>0){
			rs.execute("update WorkflowUseCount set count=count+1 where wfid="+wfid+" and userid="+userid);
		}else{
			rs.execute("insert into WorkflowUseCount (wfid,userid,count) values("+wfid+","+userid+",1)");
		}
	}
	
%>
