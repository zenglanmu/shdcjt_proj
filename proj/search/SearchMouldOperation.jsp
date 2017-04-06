<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
String opera=Util.null2String(request.getParameter("opera"));

int id=Util.getIntValue(request.getParameter("mouldid"),0);

String mouldname=Util.fromScreen(request.getParameter("mouldname"),user.getLanguage());
int userid=user.getUID();
String prjtypes[]=request.getParameterValues("prjtype");
String worktypes[]=request.getParameterValues("worktype");
String statuss[]=request.getParameterValues("status");

String prjtype="";
if(prjtypes != null)
{
	for(int i=0;i<prjtypes.length;i++)
	{
		prjtype +=","+prjtypes[i];
	}
	prjtype = prjtype.substring(1);
}

String worktype="";
if(worktypes != null)
{
	for(int i=0;i<worktypes.length;i++)
	{
		worktype +=","+worktypes[i];
	}
	worktype = worktype.substring(1);
}

String status="";
if(statuss != null)
{
	for(int i=0;i<statuss.length;i++)
	{
		status +=","+statuss[i];
	}
	status = status.substring(1);
}

	String prjid =Util.fromScreen(request.getParameter("prjid"),user.getLanguage());
	String nameopt =Util.fromScreen(request.getParameter("nameopt"),user.getLanguage());
	String name   =Util.fromScreen(request.getParameter("name"),user.getLanguage());
	String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
	String customer   =Util.fromScreen(request.getParameter("customer"),user.getLanguage());
	String parent=Util.fromScreen(request.getParameter("parent"),user.getLanguage());
	String securelevel =Util.fromScreen(request.getParameter("securelevel"),user.getLanguage());
	String department =Util.fromScreen(request.getParameter("department"),user.getLanguage());
	String manager =Util.fromScreen(request.getParameter("manager"),user.getLanguage());
	String member       =Util.fromScreen(request.getParameter("member"),user.getLanguage());
    String procode=Util.fromScreen(request.getParameter("procode"),user.getLanguage());
    
    String startdate=Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
    String startdateTo=Util.fromScreen(request.getParameter("startdateTo"),user.getLanguage());
    String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
    String enddateTo=Util.fromScreen(request.getParameter("enddateTo"),user.getLanguage());
    
  char separator = Util.getSeparator() ;
  
if(opera.equals("insert")){

String para = mouldname + separator+userid + separator + prjid + separator + status + separator+ prjtype + separator+ worktype + separator+ nameopt + separator + name   + separator + description + separator + customer   + separator + parent + separator + securelevel + separator + department + separator + manager + separator + member+separator +procode;
	RecordSet.executeProc("Prj_SearchMould_Insert",para);
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	RecordSet.executeSql("update Prj_SearchMould set startdatefrom='"+startdate+"',startdateto='"+startdateTo+"',enddatefrom='"+enddate+"',enddateto='"+enddateTo+"' where id="+id);
	response.sendRedirect("Search.jsp?mouldid="+id);
}
if(opera.equals("update")){
String para = ""+id+separator+userid + separator + prjid + separator + status + separator+ prjtype + separator+ worktype + separator+ nameopt + separator + name   + separator + description + separator + customer   + separator + parent + separator + securelevel + separator + department + separator + manager + separator + member+ separator + procode;
	RecordSet.executeProc("Prj_SearchMould_Update",para);
	
	RecordSet.executeSql("update Prj_SearchMould set startdatefrom='"+startdate+"',startdateto='"+startdateTo+"',enddatefrom='"+enddate+"',enddateto='"+enddateTo+"' where id="+id);
	
response.sendRedirect("Search.jsp?mouldid="+id);
	
}
if(opera.equals("delete")){
String para = ""+id;
	RecordSet.executeProc("Prj_SearchMould_Delete",para);
	response.sendRedirect("Search.jsp?mouldid=0");
}

%>