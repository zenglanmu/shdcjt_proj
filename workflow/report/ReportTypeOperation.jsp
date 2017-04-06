<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("reporttypeadd")){


  	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typeorder = "" + Util.getIntValue(request.getParameter("typeorder"),0);  
	
	

	String para = typename + separator + typedesc + separator + typeorder ; 
		

	RecordSet.executeProc("Workflow_ReportType_Insert",para);

    ReportTypeComInfo.removeReportTypeCache() ;

	response.sendRedirect("ReportTypeManage.jsp");
 }
else if(operation.equals("reporttypeedit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String typename = Util.fromScreen(request.getParameter("typename"),user.getLanguage());
	String typedesc = Util.fromScreen(request.getParameter("typedesc"),user.getLanguage());
	String typeorder = "" + Util.getIntValue(request.getParameter("typeorder"),0);  
	

	String para = ""+id + separator + typename + separator + typedesc + separator + typeorder ; 

	RecordSet.executeProc("Workflow_ReportType_Update",para);

    ReportTypeComInfo.removeReportTypeCache() ;
	
 	response.sendRedirect("ReportTypeManage.jsp");
 }
 else if(operation.equals("reporttypedelete")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
    RecordSet.executeProc("Workflow_ReportType_Delete",para);
	
    if(RecordSet.next() && RecordSet.getString(1).equals("0") ) {
		response.sendRedirect("ReportTypeEdit.jsp?id="+id+"&msgid=20"); //Modify by Ñî¹úÉú 2004-10-15 For TD1208
	}
	else {
        ReportTypeComInfo.removeReportTypeCache() ;
		response.sendRedirect("ReportTypeManage.jsp");
    }
 }
%>