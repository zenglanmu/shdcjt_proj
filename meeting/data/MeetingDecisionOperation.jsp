<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SysWorkPlanflow" class="weaver.system.SysWorkPlanflow" scope="page" />
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>

<%

char flag = 2;
String ProcPara = "";

String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();

String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(request.getParameter("method"));
String meetingid=Util.null2String(request.getParameter("meetingid"));
String decision=Util.fromScreen(request.getParameter("decision"),user.getLanguage());
String decisiondocid=Util.null2String(request.getParameter("decisiondocid"));

if(method.equals("edit"))
{
	ProcPara =  meetingid;
	ProcPara += flag + "1";
	ProcPara += flag + decision;
	ProcPara += flag + decisiondocid;
	ProcPara += flag + CurrentDate;
	ProcPara += flag + CurrentTime;
	ProcPara += flag + CurrentUser;

	RecordSet.executeProc("Meeting_UpdateDecision",ProcPara);

	RecordSet.executeProc("Meeting_Decision_Delete",meetingid);

	int decisionrows=Util.getIntValue(Util.null2String(request.getParameter("decisionrows")),0);
	for(int i=0;i<decisionrows;i++){
		String coding=Util.null2String(request.getParameter("coding_"+i));
		String subject=Util.null2String(request.getParameter("subject_"+i));
		String hrmid01=Util.null2String(request.getParameter("hrmid01_"+i));
		String hrmid02=Util.null2String(request.getParameter("hrmid02_"+i));
		String begindate=Util.null2String(request.getParameter("begindate_"+i));
		String begintime=Util.null2String(request.getParameter("begintime_"+i));
		String enddate=Util.null2String(request.getParameter("enddate_"+i));
		String endtime=Util.null2String(request.getParameter("endtime_"+i));

		if(!subject.equals("")){
			ProcPara =  meetingid;
			ProcPara += flag + "0";
			ProcPara += flag + coding;
			ProcPara += flag + subject;
			//更改把执行人变为多人
			ProcPara += flag + hrmid01;
			ProcPara += flag + hrmid02;
			ProcPara += flag + begindate;
			ProcPara += flag + begintime;
			ProcPara += flag + enddate;
			ProcPara += flag + endtime;
			RecordSet.executeProc("Meeting_Decision_Insert",ProcPara);	
		}
	}

}

if(method.equals("submit"))
{
	ProcPara =  meetingid;
	ProcPara += flag + "2";
	ProcPara += flag + decision;
	ProcPara += flag + decisiondocid;
	ProcPara += flag + CurrentDate;
	ProcPara += flag + CurrentTime;
	ProcPara += flag + CurrentUser;

	RecordSet.executeProc("Meeting_UpdateDecision",ProcPara);

	RecordSet.executeProc("Meeting_Decision_Delete",meetingid);

	int decisionrows=Util.getIntValue(Util.null2String(request.getParameter("decisionrows")),0);
	for(int i=0;i<decisionrows;i++){
		String coding=Util.fromScreen(Util.null2String(request.getParameter("coding_"+i)),user.getLanguage());
		String subject=Util.fromScreen(Util.null2String(request.getParameter("subject_"+i)),user.getLanguage());
		String hrmid01=Util.fromScreen(Util.null2String(request.getParameter("hrmid01_"+i)),user.getLanguage());
		String hrmid02=Util.fromScreen(Util.null2String(request.getParameter("hrmid02_"+i)),user.getLanguage());
		String begindate=Util.fromScreen(Util.null2String(request.getParameter("begindate_"+i)),user.getLanguage());
		String begintime=Util.fromScreen(Util.null2String(request.getParameter("begintime_"+i)),user.getLanguage());
		String enddate=Util.fromScreen(Util.null2String(request.getParameter("enddate_"+i)),user.getLanguage());
		String endtime=Util.fromScreen(Util.null2String(request.getParameter("endtime_"+i)),user.getLanguage());
		
/*
这里需要发工作流到个人计划，条件：if(!subject.equals(""))
hrm01为决议执行人，hrm02为检查人，“决议执行：”＋subject为工作流名称，还有时间
需要返回工作流ID，并赋值给下面的"0"

*/
	if(!subject.equals("")){ 
		String resourceid1 = hrmid01;
		String resourceid2 = hrmid02;
		int userid = user.getUID();
		int requestid = 0;
	//改动	
		ArrayList infos ;
		if(resourceid1.equals("")) 	resourceid1 = "" + userid;
		if(resourceid2.equals(""))	resourceid2 = "" + userid;

		//for(int hrmnumber=0;hrmnumber<hrm01s.size();hrmnumber++){
		infos= new ArrayList();
		infos.add(""+resourceid2);		
		infos.add(""+resourceid1);
		infos.add(""+begindate);
		infos.add(""+begintime);
		infos.add(""+enddate);
		infos.add(""+endtime);
		infos.add(""+Util.fromScreen2(subject,user.getLanguage()));
		infos.add(""+Util.fromScreen2(decision,user.getLanguage()));
		infos.add("0");
		infos.add("0");
		infos.add("0");
		infos.add("0");
		infos.add(""+decisiondocid);

        //modfied by lupeng 2004.1.30
        //to fix the work flow search function.
		//String requestname = Util.toScreen("会议决议执行:",user.getLanguage(),"0")+"<a href=/meeting/data/ProcessMeeting.jsp?meetingid="+meetingid+">"+subject+"</a>";
        String requestname = Util.toScreen("会议决议执行:",user.getLanguage(),"0")+subject;
        //end
		String sql = "select * from workflow_base where id=2";
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			String isValid = RecordSet.getString("isvalid");
			//System.out.println("isValid = " + isValid);
			if(isValid.equals("1")){
				requestid = SysWorkPlanflow.setWorkPlanflowInfo(2,requestname,infos);
			}
		}
        
		//添加工作计划
		WorkPlan workPlan = new WorkPlan();
		
		workPlan.setCreaterId(user.getUID());
	    workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_Plan));        
	    workPlan.setWorkPlanName(subject);    
	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
	    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
	    workPlan.setResourceId(resourceid1);
	    workPlan.setBeginDate(begindate);
	    if(null != begintime && !"".equals(begintime.trim()))
	    {
	        workPlan.setBeginTime(begintime);  //开始时间
	    }
	    else
	    {
	        workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间
	    }	    
	    workPlan.setEndDate(enddate);
	    if(null != enddate && !"".equals(enddate.trim()) && (null == endtime || "".equals(endtime.trim())))
	    {
	        workPlan.setEndTime(Constants.WorkPlan_EndTime);  //结束时间
	    }
	    else
	    {
	        workPlan.setEndTime(endtime);  //结束时间
	    }
	    workPlan.setDescription(Util.convertInput2DB(Util.null2String(request.getParameter("decision"))));
	    workPlan.setMeeting(meetingid);
	    
	    workPlanService.insertWorkPlan(workPlan);  //插入日程

		//添加日志
		logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, resourceid2, request.getRemoteAddr()};
		logMan.writeViewLog(logParams);
		

			//添加会议决议
			ProcPara =  meetingid;
			ProcPara += flag + "" + requestid;
			ProcPara += flag + coding;
			ProcPara += flag + subject;
			ProcPara += flag + hrmid01;
			ProcPara += flag + hrmid02;
			ProcPara += flag + begindate;
			ProcPara += flag + begintime;
			ProcPara += flag + enddate;
			ProcPara += flag + endtime;

			RecordSet.executeProc("Meeting_Decision_Insert",ProcPara);	
		}
    }
}
%>

<script>
  window.parent.returnValue = Array("","");
  window.parent.close();
</script>


