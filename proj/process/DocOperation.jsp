<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
char flag = 2 ;
String ProcPara = "";
String method = Util.null2String(request.getParameter("method"));
String ProjID=Util.null2String(request.getParameter("ProjID"));
String taskid=Util.null2String(request.getParameter("taskid"));
String docid=Util.null2String(request.getParameter("docid"));
String type=Util.null2String(request.getParameter("type"));

if (method.equals("add"))
{
	String tempsql="";
	tempsql="select * from Prj_Doc where prjid='"+ProjID+"' and taskid='"+taskid+"' and docid='"+docid+"'";
	RecordSet.executeSql(tempsql);
	if(!RecordSet.next()){
		ProcPara = ProjID ;
		ProcPara += flag  + taskid ;
		ProcPara += flag  + docid ;
		ProcPara += flag  + DocComInfo.getDocSecId(docid) ;

		RecordSet.executeProc("Prj_Doc_Insert",ProcPara);
		
		tempsql="update docdetail set projectid="+ProjID+" where id="+docid;
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
	
	String tempsql="select prjid,docid from Prj_Doc where id="+id;
	RecordSet.executeSql(tempsql);
	RecordSet.next();
	String deldocid = RecordSet.getString("docid");
	String tempprjid = RecordSet.getString("prjid");
	
	tempsql="delete Prj_Doc  where id="+id;
	RecordSet.executeSql(tempsql);
	
	tempsql = "select count(*) from Prj_Doc where docid="+deldocid+" and prjid="+tempprjid;
	RecordSet.executeSql(tempsql);
	RecordSet.next();
	if(RecordSet.getInt(1)<=0){
	    tempsql = "update docdetail set projectid='' where id="+deldocid;
	    RecordSet.executeSql(tempsql);
	}
	
	if(type.equals("1"))
		response.sendRedirect("/proj/plan/ViewTask.jsp?log=n&taskrecordid="+taskid);
	else if(type.equals("2"))
		response.sendRedirect("/proj/process/ViewTask.jsp?log=n&taskrecordid="+taskid);

}

%>