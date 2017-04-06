<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>
<%

if(! HrmUserVarify.checkUserRight("collaborationtype:edit", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String id = Util.null2String(request.getParameter("id"));
String typename = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String mypath = Util.null2String(request.getParameter("mypath"));
String sql="";
char flag = 2;
String Proc="";

if(operation.equals("add")){
	sql="insert into cowork_maintypes(typename,category) values ('"+Util.fromScreen2(typename,user.getLanguage())+"','"+mypath+"')";
	RecordSet.executeSql(sql);
}
else if(operation.equals("edit")){
	sql="update cowork_maintypes set typename='"+Util.fromScreen2(typename,user.getLanguage())+"',category='"+mypath+"' where id="+id;
	RecordSet.executeSql(sql);
}
else if(operation.equals("delete")){
	RecordSet.executeSql("delete from cowork_maintypes where id="+id);
} 
CoMainTypeComInfo.removeCoMainTypeCache();

response.sendRedirect("/cowork/type/CoworkMainType.jsp");
%>