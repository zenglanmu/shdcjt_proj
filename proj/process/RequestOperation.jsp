<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char flag = 2 ;
String ProcPara = "";
String method = Util.null2String(request.getParameter("method"));
String ProjID=Util.null2String(request.getParameter("ProjID"));
String taskid=Util.null2String(request.getParameter("taskid"));
String requestid=Util.null2String(request.getParameter("requestid"));
String type=Util.null2String(request.getParameter("type"));
String workflowid = "";
String sql = "SELECT workflowid FROM workflow_requestbase WHERE requestid="+Util.getIntValue(requestid,-1);
RecordSet.executeSql(sql);
workflowid = RecordSet.next() ? RecordSet.getString("workflowid") : "0";

if (method.equals("add"))
{
	String tempsql="";
	tempsql="select * from Prj_Request where prjid='"+ProjID+"' and taskid='"+taskid+"' and requestid='"+requestid+"'";
	RecordSet.executeSql(tempsql);
	if(!RecordSet.next()){
		ProcPara = ProjID ;
		ProcPara += flag  + taskid ;
		ProcPara += flag  + requestid ;
		ProcPara += flag  + workflowid ;

		RecordSet.executeProc("Prj_Request_Insert",ProcPara);

		tempsql="update workflow_requestbase set prjids='"+ProjID+"' where requestid="+requestid;
		RecordSet.executeSql(tempsql);
	}
	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);

}

if (method.equals("del"))
{

	String id = Util.null2String(request.getParameter("id"));
	
	String tempsql="delete Prj_Request  where id="+id;
	RecordSet.executeSql(tempsql);
	
	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);

}

%>