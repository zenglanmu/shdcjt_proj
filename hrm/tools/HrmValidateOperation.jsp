<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("ShowColumn:Operate",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String method=Util.fromScreen(request.getParameter("method"),user.getLanguage());
String ProcPara = "";
char flag=2;
if(method.equals("add")){
    String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
    String name=Util.fromScreen2(request.getParameter("name"),user.getLanguage());
    String validate=Util.fromScreen(request.getParameter("validate"),user.getLanguage());
    String tmpsql="insert into hrmlistvalidate values("+id+",'"+name+"',"+validate+")" ;
    rs.executeSql(tmpsql);
}
if(method.equals("save")){
    String[] isValidate=request.getParameterValues("isValidate");
    rs.executeSql("update HrmListValidate set validate_n=0");
    if(isValidate!=null){
        for(int i=0;i<isValidate.length;i++){
            ProcPara =  isValidate[i];
            rs.executeProc("Hrmlist_Update",ProcPara);
    	}
    }
}
response.sendRedirect("HrmValidate.jsp");
%>
