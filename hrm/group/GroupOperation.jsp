<%@ page import="weaver.general.Util,
                 weaver.hrm.group.GroupAction,
                 weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int groupid = Util.getIntValue(request.getParameter("groupid"));
int ownerid = Util.getIntValue(request.getParameter("ownerid"));

String name = Util.null2String(request.getParameter("name"));
String type = Util.null2String(request.getParameter("type"));
String hrmids = Util.null2String(request.getParameter("hrmids"));
int uid=user.getUID();
/*权限判断--Begin*/  
boolean cansave=HrmUserVarify.checkUserRight("CustomGroup:Edit", user);
/*权限判断--End*/  
if(operation.equals("addgroup")){
	if(ownerid!=uid&&!cansave){
		response.sendRedirect("/notice/noright.jsp");
    	return;
}
        int flag=0;
        if(groupid==-1)
        flag=GroupAction.create(name,type,uid,hrmids);
        else
        flag=GroupAction.update(groupid,name,type,uid,hrmids);
	
        if(flag==-1){
        request.getRequestDispatcher("/hrm/group/HrmGroupAdd.jsp?msgid=17567").forward(request,response);        
        return;
        }
        session.removeAttribute("grouplist");
 	response.sendRedirect("HrmGroup.jsp");
 }else if(operation.equals("deletegroup")){
	if(ownerid!=uid&&!cansave){
		response.sendRedirect("/notice/noright.jsp");
    	return;
}
        GroupAction.delete(groupid);
        session.removeAttribute("grouplist");
        response.sendRedirect("/hrm/group/HrmGroup.jsp");
 }else if(operation.equals("editgroup")){
	if(ownerid!=uid&&!cansave){
		response.sendRedirect("/notice/noright.jsp");
    	return;
}
        //session.removeAttribute("grouplist");
        request.getRequestDispatcher("/hrm/group/HrmGroupAdd.jsp").forward(request,response);
 }

%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">