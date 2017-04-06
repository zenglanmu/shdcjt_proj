<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
if (!HrmUserVarify.checkUserRight("WorkflowMonitor:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
char separator = Util.getSeparator() ;
if(operation.equals("add"))
{
  	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typeorder = "" + Util.getIntValue(request.getParameter("typeorder"),0);  
	
	String para = typename + separator + typedesc + separator + typeorder ; 
	System.out.println("para : "+para);
	
	RecordSet.executeProc("Workflow_MonitorType_INSERT",para);
	
	response.sendRedirect("CustomMonitorType.jsp");
}
else if(operation.equals("edit"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typeorder = "" + Util.getIntValue(request.getParameter("typeorder"),0);  
	
	String para = ""+id + separator + typename + separator + typedesc + separator + typeorder ; 

	RecordSet.executeProc("Workflow_MonitorType_Update",para);

 	response.sendRedirect("CustomMonitorType.jsp");
}
else if(operation.equals("delete"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
    RecordSet.executeProc("Workflow_MonitorType_Delete",para);
	
    if(RecordSet.next() && RecordSet.getString(1).equals("0") ) 
    {
		response.sendRedirect("MonitorTypeEdit.jsp?id="+id+"&msgid=20"); //Modify by Ñî¹úÉú 2004-10-15 For TD1208
	}
	else 
	{
		response.sendRedirect("CustomMonitorType.jsp");
    }
 }
%>