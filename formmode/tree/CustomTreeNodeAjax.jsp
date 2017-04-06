<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
int sourceid = Util.getIntValue(request.getParameter("sourceid"),0);
int sourcefrom = Util.getIntValue(request.getParameter("sourcefrom"),0);
String tablename = "";
String sql = "";
if(sourcefrom==1){//Ä£¿é
	sql = "select * from modeinfo where id = " +sourceid;
	rs.executeSql(sql);
	while(rs.next()){
		int formid = rs.getInt("formid");
		tablename = "formtable_main_"+Math.abs(formid);
	}
}
%>
<%=tablename%>