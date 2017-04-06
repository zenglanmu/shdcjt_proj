<%@ page import="weaver.general.*,weaver.conn.*" %>
<%
response.setContentType("text/xml;charset=UTF-8");
String sqlcontent = Util.null2String(request.getParameter("sql"));
boolean isCanUse = false;

try{
	ConnStatement statement = null;
	int index = sqlcontent.indexOf("doFieldSQL(\"");
	if(index > -1){
		sqlcontent = sqlcontent.substring(index+12);
		index = sqlcontent.lastIndexOf("\")");
		if(index > -1){
			sqlcontent = sqlcontent.substring(0, index);
		}
	}
	sqlcontent = sqlcontent.trim();
	sqlcontent = sqlcontent.replaceAll("\\$([0-9]*)\\$", "19700101");
	sqlcontent = sqlcontent.replaceAll("\\$([currentuser|currentdept|wfcreater|wfcredept|id|requestid]*)\\$", "0");
	if(!"".equals(sqlcontent)){
		try{
			statement = new ConnStatement();
			statement.setStatementSql(sqlcontent);
			statement.executeQuery();
			isCanUse = true;
		}catch(Exception e){
			isCanUse = false;
		}finally{
			try{
				statement.close();
				statement = null;
			}catch(Exception e){
				//极有可能出错，出错时不做任何处理
			}
		}
	}else{
		isCanUse = true;
	}
}catch(Exception e){
	isCanUse = false;
}
%>
<information>
<iscanuse><%=isCanUse%></iscanuse>
</information>