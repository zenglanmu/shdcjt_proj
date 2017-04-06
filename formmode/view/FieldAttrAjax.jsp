<%@ page import="weaver.general.*,weaver.conn.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="fieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="detailFieldComInfo" class="weaver.workflow.field.DetailFieldComInfo" scope="page" />
<%
response.setContentType("text/xml;charset=UTF-8");
String fieldidAll = Util.null2String(request.getParameter("fieldid"));
int fieldid = -9;
int thisfieldid = -9;

int pos = fieldidAll.indexOf("_");
if(pos > -1){
	fieldid = Util.getIntValue(fieldidAll.substring(0, pos), 0);
}else{
	fieldid = Util.getIntValue(fieldidAll, 0);
}

String sqlcontent = Util.null2String(request.getParameter("sql"));
sqlcontent = URLDecoder.decode(sqlcontent);
sqlcontent = sqlcontent.replaceAll("%2B", "+");
sqlcontent = sqlcontent.replaceAll("%26", "&");
System.out.println("mode="+sqlcontent);
String name = "";
String key = "";
int htmltype = -1;
int type = -1;
int isdetail = 0;
try{
	int fieldcount = 1;
	int index = -1;
	try{
		String sqltmp = sqlcontent.substring(0, sqlcontent.indexOf("from"));
		index = sqltmp.indexOf(",");
		if(index > -1){
			fieldcount = 2;
		}
	}catch(Exception e){}
	ConnStatement statement = null;
	try{
		statement = new ConnStatement();
		statement.setStatementSql(sqlcontent);
		statement.executeQuery();
		while(statement.next()){
			String name_tmp = Util.null2String(statement.getString(1));
			name_tmp = name_tmp.replaceAll("&", "&amp;");
			name_tmp = name_tmp.replaceAll("<", "&lt;");
			name_tmp = name_tmp.replaceAll(">", "&gt;");
			if("".equals(name)){
				name = name_tmp;
			}else{
				name += ("&amp;nbsp;"+name_tmp);
			}
			if(fieldcount == 2){
				String key_tmp = Util.null2String(statement.getString(2));
				key_tmp = key_tmp.replaceAll("&", "&amp;");
				key_tmp = key_tmp.replaceAll("<", "&lt;");
				key_tmp = key_tmp.replaceAll(">", "&gt;");
				if("".equals(key)){
					key = key_tmp;
				}else{
					key += (key_tmp+",");
				}
			}
		}
	}catch(Exception e){
		//极有可能出错，出错时不做任何处理
	}finally{
		try{
			statement.close();
			statement = null;
		}catch(Exception e){
			//极有可能出错，出错时不做任何处理
		}
	}
	//rs.execute(sqlcontent);

	rs.execute("select viewtype, fieldhtmltype, type from workflow_billfield where id="+fieldid);
	if(rs.next()){
		htmltype = Util.getIntValue(rs.getString("fieldhtmltype"), -1);
		isdetail = Util.getIntValue(rs.getString("viewtype"), 0);
		type = Util.getIntValue(rs.getString("type"), -1);
	}
	if(htmltype==1 && (type==2||type==3||type==4||type==5)){
		if("".equals(key.trim())){
			key = "0";
		}
		if("".equals(name.trim())){
			name = "0";
		}
	}
}catch(Exception e){
	e.printStackTrace();
}
%>

<% if(name != "0" && !name.equals("")){ %>
<information>
<name><%=name%></name>
<key><%=key%></key>
<htmltype><%=htmltype%></htmltype>
<isdetail><%=isdetail%></isdetail>
<type><%=type%></type>
</information>
<% } %>