
<%@ page import="weaver.general.Util,weaver.conn.*,weaver.hrm.company.DepartmentComInfo" %>
<%@ page import="java.util.*,java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%!

/**
 * 判断同一个部门下是否有 相同简称的岗位
 *@param departmentid 部门编号
 *@param jobtitlemark 岗位简称
 *@param id 记录的编号， 新建是应传入 0
 *@author Charoes Huang
 *@Date June 3,2004
 */
private boolean isDuplicatedJobtitle(int departmentid,String jobtitlemark,int id){
	boolean isDuplicated = false;
	RecordSet rs = new RecordSet();
	String sqlStr ="Select Count(*) From HrmJobTitles WHERE id<>"+id +" and jobdepartmentid="+departmentid+" and LTRIM(RTRIM(jobtitlemark))='"+jobtitlemark.trim()+"'";

	rs.executeSql(sqlStr);
	if(rs.next()){
		if(rs.getInt(1) > 0){
			isDuplicated = true;
		}
	}
	return isDuplicated;

}
%>
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String jobtitlemark = Util.fromScreen(request.getParameter("jobtitlemark"),user.getLanguage());
String jobtitlename = Util.fromScreen(request.getParameter("jobtitlename"),user.getLanguage());
String depid = Util.fromScreen(request.getParameter("jobdepartmentid"),user.getLanguage());
String jobactivityid = Util.fromScreen(request.getParameter("jobactivityid"),user.getLanguage());
String jobresponsibility = Util.fromScreen(request.getParameter("jobresponsibility"),user.getLanguage());
String jobcompetency = Util.fromScreen(request.getParameter("jobcompetency"),user.getLanguage());
String jobtitleremark = Util.fromScreen(request.getParameter("jobtitleremark"),user.getLanguage());
String jobdoc = Util.fromScreen(request.getParameter("jobdoc"),user.getLanguage());
String[] strObj = {jobtitlemark,jobtitlename,depid,jobactivityid,
					Util.null2String(request.getParameter("jobresponsibility")),
					Util.null2String(request.getParameter("jobcompetency")),
					Util.null2String(request.getParameter("jobtitleremark"))} ;

if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmJobTitlesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
	 int departmentid = Util.getIntValue(depid);

	/*
	 检查是否存在同一个部门下相同简称的岗位
	 */
    if(isDuplicatedJobtitle(departmentid,jobtitlemark,0)){
	    request.getSession().setAttribute("JobTitle.error",strObj);
		String url ="HrmJobTitlesAdd.jsp?message=1";
		response.sendRedirect(url);
    	return;
	}

	String para = jobtitlemark + separator + jobtitlename + separator + 
		depid + separator + jobactivityid + separator + 
		jobresponsibility+ separator + jobcompetency + separator + 
		jobtitleremark;
	
	RecordSet.executeProc("HrmJobTitles_Insert",para);
	int id=0;

    if(RecordSet.next()){
                id = RecordSet.getInt(1);
                if(!jobdoc.equals(""))
         RecordSet.executeSql("update HrmJobTitles set jobdoc="+jobdoc+" where id="+id);
    }
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobtitlename);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmJobTitles_Insert,"+para);
      SysMaintenanceLog.setOperateItem("26");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobTitlesComInfo.removeJobTitlesCache();
	response.sendRedirect("HrmJobTitles.jsp?departmentid="+departmentid);
 }
 
else if(operation.equals("edit")){    
	if(!HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));	
	
	/*
	 检查是否存在同一个部门下相同简称的岗位
	 */
	int departmentid = Util.getIntValue(depid);
    if(isDuplicatedJobtitle(departmentid,jobtitlemark,id)){
	    String url ="HrmJobTitlesEdit.jsp?id="+id+"&message=1";
		response.sendRedirect(url);
    	return;
	}

	String para = ""+id + separator +jobtitlemark + separator + jobtitlename + separator + 
		depid + separator + jobactivityid + separator + 
		jobresponsibility+ separator + jobcompetency + separator + 
		jobtitleremark;	
	
	RecordSet.executeProc("HrmJobTitles_Update",para);
    if(!jobdoc.equals(""))
    RecordSet.executeSql("update HrmJobTitles set jobdoc="+jobdoc+" where id="+id);
    String sql = "update HrmResource set departmentid = "+depid+" where jobtitle="+id;
	RecordSet.executeSql(sql);
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobtitlename);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmJobTitles_Update,"+para);
      SysMaintenanceLog.setOperateItem("26");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		JobTitlesComInfo.removeJobTitlesCache(); 
    out.write("<script>opener.parent.location.reload();window.close();</script>");
    // response.sendRedirect("HrmJobTitles.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmJobTitlesEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	
	String sql = "select count(id) from HrmResource where jobtitle = "+id;
	RecordSet.executeSql(sql);
	RecordSet.next();	
	if(RecordSet.getInt(1)>0){
		response.sendRedirect("HrmJobTitlesEdit.jsp?id="+id+"&msgid=20");
	}else{		
	RecordSet.executeProc("HrmJobTitles_Delete",para);
	}	
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(jobtitlename);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmJobTitles_Delete,"+para);
      SysMaintenanceLog.setOperateItem("26");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	JobTitlesComInfo.removeJobTitlesCache();
    out.write("<script>window.close();opener.parent.location.reload();</script>");
     //response.sendRedirect("HrmJobTitles.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">