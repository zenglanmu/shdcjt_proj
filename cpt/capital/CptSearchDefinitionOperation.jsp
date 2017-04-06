<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
if(!HrmUserVarify.checkUserRight("cptdefinition:all", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int rownum = Util.getIntValue(request.getParameter("rownum"),0);
String sql = "";

sql = "delete from CptSearchDefinition where mouldid = -1";
rs.executeSql(sql);

for(int i=0;i<rownum;i++){
	String fieldname = Util.null2String(request.getParameter("fieldname_"+i));
	int isconditionstitle = Util.getIntValue(request.getParameter("isconditionstitle_"+i),0);
	int istitle = Util.getIntValue(request.getParameter("istitle_"+i),0);
	int isconditions = Util.getIntValue(request.getParameter("isconditions_"+i),0);
	int isseniorconditions = Util.getIntValue(request.getParameter("isseniorconditions_"+i),0);
	String displayorder = Util.getFloatValue(request.getParameter("displayorder_"+i),0) + "";					

	if(istitle==0&&!fieldname.equals("isdata")) displayorder="";
	
	if(fieldname.equals("isdata")){
		sql = "insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder,mouldid) values ('isdata',1,1,1,0,'"+displayorder+"',-1)";	
		rs.executeSql(sql);
	}else{
		sql = "insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder,mouldid) values ('"+fieldname+"','"+isconditionstitle+"','"+istitle+"','"+isconditions+"','"+isseniorconditions+"','"+displayorder+"','-1')";	
		rs.executeSql(sql);
	}	
}

response.sendRedirect("/cpt/capital/CptSearchDefinition.jsp");

%>