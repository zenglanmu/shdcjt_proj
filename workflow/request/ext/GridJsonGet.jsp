<%@ page language="java" contentType="application/x-json;charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<%
	String paras = Util.null2String(request.getParameter("paras"));
	//System.out.println(paras);
	

	JSONObject oJson= new JSONObject();	
	JSONArray table=new JSONArray();
	

	
	for(int i=0;i<30;i++){
		JSONObject row=new JSONObject();
		row.put("id",""+i);
		row.put("createdate","2008-07-03 16:11:25");
		row.put("creator","<A href='#'>曾东平</a>");
		row.put("workflow","留言");
		row.put("level","重要");
		row.put("title","<A href='javascript:openWfToTab("+i+")' title='测试流程"+i+"'>测试流程"+i+"</a>");
		row.put("receivedate","2008-07-03 16:11:25");
		
		table.put(row);	
	}	
	oJson.put("totalCount",200);
	oJson.put("data",table);
    out.print(oJson.toString());
%>