<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.conn.RecordSet"%>
<style>
  table{border-collapse:collapse}
</style>
<%
   String tempid=request.getParameter("tempid");
   String sql="select * from blog_template where id="+tempid;
   RecordSet recordSet=new RecordSet();
   recordSet.execute(sql);
   String tempContent="";
   if(recordSet.next())
      tempContent=recordSet.getString("tempContent");
   out.print(tempContent);
%>