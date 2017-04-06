<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
int dsporder = Util.getIntValue(request.getParameter("dsporder"),0);

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("workflow_wftype_Insert",type+flag+desc+flag+dsporder);
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("workflow_wftype_Update",""+id+flag+type+flag+desc+flag+dsporder);
	
}
else if (method.equals("delete"))
{
	String sql = "delete from workflow_type where id = "+id;
	RecordSet.executeSql(sql);
	
}else if(method.equals("valRepeat")){   //验证类型名称是否重复
	String sql = "select id  from workflow_type where typename='"+type+"'";
	RecordSet.executeSql(sql);
	boolean isExist=false;
	if(id!=null){
		while(RecordSet.next()){
			if(!id.equals(""+RecordSet.getInt("id"))){
				isExist=true;
			}
		}
	}else{	
		if(RecordSet.next())
			isExist=true;
	}
	
	if(isExist)
		out.print("<script>parent.typeExist();</script>");  //类型名称已存在
	else
		out.print("<script>parent.submitForm();</script>"); //类型名称不存在 提交form
}

if(!method.equals("valRepeat")){
	
	  WorkTypeComInfo.removeWorkTypeCache();
	  response.sendRedirect("ListWorkType.jsp");
	  
	}
%>