<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
char flag = Util.getSeparator() ;
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String feelevel = Util.fromScreen(request.getParameter("feelevel"),user.getLanguage());
String feeperiod = Util.null2String(request.getParameter("feeperiod"));
String feetype = Util.null2String(request.getParameter("feetype"));
String agreegap = Util.null2String(request.getParameter("agreegap"));
String alertvalue=Util.null2String(request.getParameter("alertvalue"));
String supsubject=Util.null2String(request.getParameter("supsubject"));
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
if(feelevel.equals("1")){
    feetype="";
    agreegap="";
    alertvalue="";
    supsubject="";
}else if(feelevel.equals("2")){
    feetype="";
    agreegap="";
    alertvalue="";
    feeperiod="";
}else if(feelevel.equals("3")){
    feeperiod="";
}
String para = "" ;

if(operation.equals("add")){
	para = name +flag +feeperiod +flag+feetype +flag+agreegap +flag+description+flag+feelevel+flag+alertvalue+flag+supsubject ;
	RecordSet.executeProc("FnaBudgetfeeType_Insert",para);
}
else if(operation.equals("edit")){
	para = id + flag + name +flag + feeperiod +flag+feetype +flag+agreegap + flag + description+flag+feelevel+flag+alertvalue+flag+supsubject ;
	RecordSet.executeProc("FnaBudgetfeeType_Update",para);
 }
 else if(operation.equals("delete")){
	RecordSet.executeProc("FnaBudgetfeeType_Delete",id);

	if (RecordSet.next() && (RecordSet.getString(1)).equals("-1")) {
		response.sendRedirect("FnaBudgetfeeTypeEdit.jsp?id=" + id + "&msgid=20"); 
		return; 
	}
 }
 BudgetfeeTypeComInfo.removeBudgetfeeTypeCache();
 response.sendRedirect("FnaBudgetfeeType.jsp");
%>
