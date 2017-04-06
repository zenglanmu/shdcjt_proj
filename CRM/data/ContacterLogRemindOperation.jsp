<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String CustomerID = Util.fromScreen(request.getParameter("CustomerID"),user.getLanguage());
String daytype = ""+Util.getIntValue(request.getParameter("daytype"),1);
String before = ""+Util.getIntValue(request.getParameter("before"),0);
String isremind = Util.fromScreen(request.getParameter("isremind"),user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String para = "";
char flag = 2;
	
	if (isremind.equals("")) isremind = "1";
	para = CustomerID;
	para += flag + daytype;
	para += flag + before;	
	para += flag + isremind;	
	RecordSetR.executeProc("CRM_ContacterLog_R_Update",para);
	//out.print(isremind);
	if(!isfromtab){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
	}else{
		response.sendRedirect("/CRM/data/AddContacterLogRemind.jsp?CustomerID="+CustomerID+"&isfromtab="+isfromtab);
	}
%>