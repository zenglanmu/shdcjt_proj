<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String worktypecode = Util.null2String(request.getParameter("txtWorktypecode"));

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("Prj_WorkType_Insert",type+flag+desc+flag+worktypecode);

	WorkTypeComInfo.removeWorkTypeCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("Prj_WorkType_Update",id+flag+type+flag+desc+flag+worktypecode);

	WorkTypeComInfo.removeWorkTypeCache();
}
else if (method.equals("delete"))
{
    //modify by dongping for TD698
    //在项目库里查一下此工作类型是否被引用,如果被引用就不能删除此工作类型	
	String referenced = "" ;
    RecordSet.executeSql("SELECT count(id) FROM Prj_ProjectInfo where worktype = "+id);
    if (RecordSet.next()) {
        if (!RecordSet.getString(1).equals("0"))
            referenced = "yes" ;
    }
    
    if (referenced.equals("yes")) {
       response.sendRedirect("/proj/Maint/EditWorkType.jsp?id="+id+"&referenced="+referenced); 
       return ;
	} else {
	    RecordSet.executeProc("Prj_WorkType_Delete",id);
	}
	
	WorkTypeComInfo.removeWorkTypeCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/proj/Maint/ListWorkType.jsp");
%>