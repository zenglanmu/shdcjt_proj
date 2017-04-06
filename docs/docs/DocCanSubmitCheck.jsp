<%@ page language="java" contentType="text/plain; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.hrm.*"%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String docid = Util.null2String(request.getParameter("docid"));

String sql = "";

RecordSet.executeSql("select count(0) from docdetail where doceditionid > 0 and id<>"+docid+" and doceditionid = (select doceditionid from docdetail where id = " + docid + ") and (docstatus <= 0 or docstatus in (3,4,6)) ");

if(RecordSet.next()&&RecordSet.getInt(1)>0){
   	out.println("checkCanSubmitCallBack("+RecordSet.getInt(1)+");");
} else {
	out.println("checkCanSubmitCallBack(0);");
}
%>