<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page"/>
<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int id = Util.getIntValue(request.getParameter("id"));
String typename = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String managerid = "";
String members = "";

char flag = 2;
String Proc="";
boolean isoracle = (RecordSet.getDBType()).equals("oracle");

if(operation.equals("add")){
	if(isoracle){
		ConnStatement statement=new ConnStatement();
		try{
		    String sql = "insert into cowork_types(typename,departmentid,managerid,members) values('"+typename+"',"+departmentid+",EMPTY_CLOB(),EMPTY_CLOB())";
		    statement.setStatementSql(sql);
	        statement.executeUpdate();
	        
			sql = "select max(id) as id from cowork_types";
			statement.setStatementSql(sql);
			statement.executeQuery();
			if(statement.next()){
				id = statement.getInt("id");
			}
	        
	        sql = "select managerid,members from cowork_types where id="+id+" for update";
	        statement.setStatementSql(sql,false);
	        statement.executeQuery();
	        if(statement.next()){
				CLOB theclob1 = statement.getClob("managerid");
				char[] manageridchar = managerid.toCharArray();
				Writer manageridwrite = theclob1.getCharacterOutputStream();
				manageridwrite.write(manageridchar);
				manageridwrite.flush();
				manageridwrite.close();
				CLOB theclob2 = statement.getClob("members");
				char[] memberschar = members.toCharArray();
				Writer memberswrite = theclob2.getCharacterOutputStream();
				memberswrite.write(memberschar);
				memberswrite.flush();
				memberswrite.close();
	        }
	        
	    }finally{
	    	statement.close();
	    }
	}else{
		Proc=typename+flag+departmentid+flag+managerid+flag+members;
		RecordSet.executeProc("cowork_types_insert",Proc);
	}
}else if(operation.equals("edit")){
	if(isoracle){
		ConnStatement statement = new ConnStatement();
		try{
		    String sql = "update cowork_types set typename='"+typename+"',departmentid="+departmentid+",managerid=EMPTY_CLOB(),members=EMPTY_CLOB() where id="+id;
		    statement.setStatementSql(sql);
	        statement.executeUpdate();
	        sql = "select managerid,members from cowork_types where id="+id+" for update";
	        statement.setStatementSql(sql,false);
	        statement.executeQuery();
	        if(statement.next()){
				CLOB theclob1 = statement.getClob("managerid");
				char[] manageridchar = managerid.toCharArray();
				Writer manageridwrite = theclob1.getCharacterOutputStream();
				manageridwrite.write(manageridchar);
				manageridwrite.flush();
				manageridwrite.close();
				CLOB theclob2 = statement.getClob("members");
				char[] memberschar = members.toCharArray();
				Writer memberswrite = theclob2.getCharacterOutputStream();
				memberswrite.write(memberschar);
				memberswrite.flush();
				memberswrite.close();
	        }
	        
	    }finally{
	    	statement.close();
	    }
	}else{
		Proc=id+""+flag+typename+flag+departmentid+flag+managerid+flag+members;
		RecordSet.executeProc("cowork_types_Update",Proc);
	}
}
else if(operation.equals("delete")){
	Proc=""+id;
	RecordSet.executeProc("cowork_types_Delete",Proc);
	RecordSet.executeSql("delete from cotype_sharemanager where cotypeid="+id);
	RecordSet.executeSql("delete from cotype_sharemembers where cotypeid="+id);
} 
CoTypeComInfo.removeCoTypeCache();

response.sendRedirect("/cowork/type/CoworkType.jsp");
%>