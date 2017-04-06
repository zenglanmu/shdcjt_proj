<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="session"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<%
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();

char flag = 2 ;
String ProcPara = "";
String method = request.getParameter("method");
String ProjID=Util.null2String(request.getParameter("ProjID"));

String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";

if (method.equals("submitplan"))
{
	ProcPara = ProjID ;
	RecordSet.executeProc("Prj_Plan_Submit",ProcPara);

		RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
		String manager="";
		String managers="";
		String name="";
		String prjtype = "";
		if (RecordSet.next()){
			manager = RecordSet.getString("manager");
			name = RecordSet.getString("name");
			prjtype = RecordSet.getString("prjtype");
		}
		int workflowid = 0;
		RecordSet.executeSql("Select wfid from Prj_ProjectType where id = "+prjtype); //get the workflow id
		if(RecordSet.next())
		    workflowid = RecordSet.getInt(1);

        if(workflowid == 0){
        	 ProjectInfoComInfo.removeProjectInfoCache();
            response.sendRedirect("/proj/data/ViewProject.jsp?message=1&ProjID="+ProjID);
            return;
        }

		String gopage ="/proj/plan/ViewPlan.jsp?ProjID="+ProjID ;
		String subject = SystemEnv.getHtmlLabelName(16409,user.getLanguage())+":"+name;
		ApproveParameter.resetParameter();
		ApproveParameter.setWorkflowid(workflowid);
		ApproveParameter.setNodetype("0");
		ApproveParameter.setApproveid(Integer.valueOf(ProjID).intValue());
	    ApproveParameter.setRequestname(subject);
		ApproveParameter.setGopage(gopage);

		response.sendRedirect("/workflow/request/BillApproveProjOperation.jsp?isfromprojplan=1&src=submit&iscreate=1&ProjID="+ProjID+"&workflowid="+workflowid+"&gopage="+URLEncoder.encode(gopage)+"&requestname="+URLEncoder.encode(subject));

		/*
		managers=ResourceComInfo.getManagerID(manager);
		if(!managers.equals(manager)){

		SWFAccepter=managers;
		SWFTitle=SystemEnv.getHtmlLabelName(841,user.getLanguage());
		SWFTitle += ":"+name;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark="";
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

		}else{
        如果上级经理是本人
            ProcPara = ProjID ;
            RecordSet.executeProc("Prj_Plan_Approve",ProcPara);

            String tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID +"update Prj_ProjectInfo set status = 5 where id = "+ ProjID;
            RecordSet.executeSql(tmpsql);



            response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
        }
		*/

}

if (method.equals("approveplan"))
{
	ProcPara = ProjID ;
	RecordSet.executeProc("Prj_Plan_Approve",ProcPara);

	String tmpsql="update prj_taskprocess set isactived=2 where prjid="+ProjID ;
	RecordSet.executeSql(tmpsql);
	tmpsql = "update Prj_ProjectInfo set status = 5 where id = "+ ProjID;
	RecordSet.executeSql(tmpsql);

	//更新工作计划中该项目的经理的时间Begin
	String begindate01 = "";
	String enddate01 = "";

	RecordSet.executeProc("Prj_TaskProcess_Sum",""+ProjID);
	if(RecordSet.next() && !RecordSet.getString("workday").equals("")){

		if(!RecordSet.getString("begindate").equals("x")) begindate01 = RecordSet.getString("begindate");
		if(!RecordSet.getString("enddate").equals("-")) enddate01 = RecordSet.getString("enddate");

	}
	if (!begindate01.equals("")){
		RecordSet.executeSql("update workplan set status = '0',begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
	}
	//更新工作计划中该项目的经理的时间End

	//添加工作计划Begin
	String para = "";
	String workid = "";
	String manager="";
	String TaskID="";
	RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
	if (RecordSet.next()){
		manager=RecordSet.getString("manager");
	}

	tmpsql = "SELECT * FROM Prj_TaskProcess WHERE prjid = " + ProjID + " and isdelete<>'1' order by id";
	RecordSet.executeSql(tmpsql);

	while (RecordSet.next())
	{
		TaskID = RecordSet.getString("id");
		String beginDate = RecordSet.getString("begindate");
		String beginTime = "";
		String endDate = RecordSet.getString("enddate");
		String endTime = "";
		
		//添加工作计划
		WorkPlan workPlan = new WorkPlan();
		
		workPlan.setCreaterId(Integer.parseInt(manager));

	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
	    workPlan.setWorkPlanName(RecordSet.getString("subject"));    
	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
	    workPlan.setResourceId(RecordSet.getString("hrmid"));
	    
	    workPlan.setBeginDate(beginDate);
	    if(null != beginTime && !"".equals(beginTime.trim()))
	    {
	        workPlan.setBeginTime(beginTime);  //开始时间
	    }
	    else
	    {
	        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间
	    }	    
	    workPlan.setEndDate(endDate);
	    if(null != endDate && !"".equals(endDate.trim()) && (null == endTime || "".equals(endTime.trim())))
	    {
	        workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
	    }
	    else
	    {
	        workPlan.setEndTime(endTime);  //结束时间
	    }
	    
	    String workPlanDescription = Util.null2String(RecordSet.getString("content"));
	    workPlanDescription = Util.replace(workPlanDescription, "\n", "", 0);
	    workPlanDescription = Util.replace(workPlanDescription, "\r", "", 0);
	    workPlan.setDescription(workPlanDescription);
	    	    
	    workPlan.setProject(ProjID);
	    workPlan.setTask(TaskID);

	    workPlanService.insertWorkPlan(workPlan);  //插入日程
			    
		//插入日志
		logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, manager, request.getRemoteAddr()};
		logMan.writeViewLog(logParams);
	}

	response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
}


if (method.equals("saveasplan"))
{
	ProcPara = ProjID ;
	RecordSet.executeProc("Prj_TaskInfo_SelectMaxVersion",ProcPara);
	if(RecordSet.next()){
		int version=RecordSet.getInt("version")+1;
		ProcPara += "" + flag + version ;
		RecordSet.executeProc("Prj_Plan_SaveFromProcess",ProcPara);
	}
	response.sendRedirect("/proj/plan/ViewPlan.jsp?ProjID="+ProjID);
}

if (method.equals("tellmember"))
{


    String noticetitle=Util.null2String(request.getParameter("noticetitle"));
    String noticecontent=Util.null2String(request.getParameter("noticecontent"));
    String members=Util.null2String(request.getParameter("hrmids02"));
/*
	ProcPara = ProjID+flag+"" ;
	RecordSet.executeProc("Prj_Member_SumProcess",ProcPara);
	String members="";
	while(RecordSet.next()){
	members += ","+RecordSet.getString("hrmid");
	}
	RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
	String manager="";
	String name="";
	if (RecordSet.next()){
		manager=RecordSet.getString("manager");
		name=RecordSet.getString("name");
	}*/
	if(!members.equals("")){

		SWFAccepter=members;
		SWFTitle=SystemEnv.getHtmlLabelName(15276,user.getLanguage());
		SWFTitle += ":"+noticetitle;
		SWFTitle += "-"+CurrentUserName;
		SWFTitle += "-"+CurrentDate;
		SWFRemark=Util.fromScreen2(noticecontent,user.getLanguage());
		SWFSubmiter=CurrentUser;
		SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);

	}


	response.sendRedirect("/proj/process/ViewProcess.jsp?ProjID="+ProjID);
}
 if (method.equals("normal")){
     	String tmpsql="update Prj_ProjectInfo set status = 1 where id = "+ ProjID;
	    RecordSet.executeSql(tmpsql);
        response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+ProjID);
 }
  if (method.equals("delay")){
     	String tmpsql="update Prj_ProjectInfo set status = 2 where id = "+ ProjID;
	    RecordSet.executeSql(tmpsql);
        response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+ProjID);
 }
  if (method.equals("complete")){
     	String tmpsql="update Prj_ProjectInfo set status = 3 where id = "+ ProjID;
	    RecordSet.executeSql(tmpsql);
        response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+ProjID);
 }
  if (method.equals("freeze")){
     	String tmpsql="update Prj_ProjectInfo set status = 4 where id = "+ ProjID;
	    RecordSet.executeSql(tmpsql);
        response.sendRedirect("/proj/data/ViewProject.jsp?ProjID="+ProjID);
 }
 ProjectInfoComInfo.removeProjectInfoCache();
%>