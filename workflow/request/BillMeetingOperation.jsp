<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.lang.* "%>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanService" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.workflow.request.RequestInfo" %>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="RequestTransactionManager" class="weaver.workflow.request.RequestTransactionManager" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="RequestCheckAddinRules" class="weaver.workflow.request.RequestCheckAddinRules" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="MeetingViewer" class="weaver.meeting.MeetingViewer" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%!
public int addPlan(WorkPlanService workPlanService,String MeetingID,String caller,String meetingname,String description,
		String resourceids,String begindate,String begintime,String enddate,String endtime,String remindType,
		String remindBeforeStart, String remindBeforeEnd,int remindTimesBeforeStart,int remindTimesBeforeEnd)
{
	int workPlanID = -1;
	//System.out.println("MeetingID : "+MeetingID);
    if(!MeetingID.equals(""))
    {        
    	//添加工作计划
		WorkPlan workPlan = new WorkPlan();
		
		workPlan.setCreaterId(Util.getIntValue(caller, 1));
	    //workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

	    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ConferenceCalendar));        
	    workPlan.setWorkPlanName(meetingname);    
	    workPlan.setDescription(description);
	    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
	    if(!"".equals(resourceids))
	    {
		    workPlan.setResourceId(resourceids.substring(1));	        
	    }
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
	    workPlan.setMeeting(MeetingID);
	    
	  	//增加提醒
	    workPlan.setRemindType(remindType);  //提醒方式
	    if(!"".equals(remindBeforeStart) && null != remindBeforeStart)
	    {
	        workPlan.setRemindBeforeStart(remindBeforeStart);  //是否开始前提醒
	    }
	    if(!"".equals(remindBeforeEnd) && null != remindBeforeEnd)
	    {
	        workPlan.setRemindBeforeEnd(remindBeforeEnd);  //是否结束前提醒
	    }
	    workPlan.setRemindTimesBeforeStart(remindTimesBeforeStart);  //开始前提醒时间
	    workPlan.setRemindTimesBeforeEnd(remindTimesBeforeEnd);  //结束前提醒时间
	    
	    if(!"".equals(workPlan.getBeginDate()) && null != workPlan.getBeginDate())
	    {	    	
	    	List beginDateTimeRemindList = Util.processTimeBySecond(workPlan.getBeginDate(), workPlan.getBeginTime(), workPlan.getRemindTimesBeforeStart() * -1 * 60);
	    	workPlan.setRemindDateBeforeStart((String)beginDateTimeRemindList.get(0));  //开始前提醒日期
	    	workPlan.setRemindTimeBeforeStart((String)beginDateTimeRemindList.get(1));  //开始前提醒时间
	    }
	    if(!"".equals(workPlan.getEndDate()) && null != workPlan.getEndDate())
	    {
	    	List endDateTimeRemindList = Util.processTimeBySecond(workPlan.getEndDate(), workPlan.getEndTime(), workPlan.getRemindTimesBeforeEnd() * -1 * 60);
	    	workPlan.setRemindDateBeforeEnd((String)endDateTimeRemindList.get(0));  //结束前提醒日期
	    	workPlan.setRemindTimeBeforeEnd((String)endDateTimeRemindList.get(1));  //结束前提醒时间
	    }
	    
	    //System.out.println("插入日程...");
	    workPlanService.insertWorkPlan(workPlan);  //插入日程
	    workPlanID = workPlan.getWorkPlanID();
    }
    return workPlanID;
}
%>
<%
FileUpload fu = new FileUpload(request);
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

String isfrommeeting = Util.null2String(fu.getParameter("isfrommeeting"));
String viewmeeting = Util.null2String(fu.getParameter("viewmeeting"));
String Procpara = "";
String ProjID = "";
//int isfromdoc = Util.getIntValue(fu.getParameter("isfromdoc"),-1);         //是否从文档显示页面提交审批过来的

char flag = Util.getSeparator() ;
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
int userid = user.getUID();
String logintype = user.getLogintype();


String MeetingID = Util.null2String(fu.getParameter("MeetingID"));
String approvewfid = Util.null2String(fu.getParameter("approvewfid"));
if(!approvewfid.equals(""))
        workflowid = Integer.valueOf(approvewfid).intValue();

String meetingtype = "";
String meetingname = "";
String description = "";
int caller = 0;
int contacter = 0;
String begindate = "";
String begintime = "";
String enddate = "";
String endtime = "";
String address = "";

String saveSql ="";
String sqlstr = "";
String totalmember="";
String resources="";
String crms="";
String others="";
String projectid="";	//加入了项目id
isbill=1;
String customizeAddress = "";
int remindBeforeStart = 0;  //是否开始前提醒
int remindBeforeEnd = 0;  //是否结束前提醒
int remindType = 1;  //提醒方式
int remindTimesBeforeStart = 0;  //开始前提醒时间
int remindTimesBeforeEnd = 0;  //结束前提醒时间
String approve=Util.null2String((String)fu.getParameter("approve"));
if(approve.equals("1")){
    response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid);
    //out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"');</script>");
   return;
}

/***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过开始***/
String approvemeeting = Util.null2String((String)fu.getParameter("approvemeeting"));
if("1".equals(approvemeeting) && requestid > -1) {
	RequestInfo rqInfo = new RequestInfo(requestid,user);
	src = "submit";
	iscreate = "0";
	formid = rqInfo.getFormid();
	billid = rqInfo.getBillid();
}
/***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过结束***/

//System.out.println("src  :"+src);
if(src.equals("submit")&&!MeetingID.equals("")) {//新建request时

	 if(workflowid!=-1){
		rs.executeProc("workflow_Workflowbase_SByID",workflowid+"");
		if(rs.next()){
			formid=rs.getInt("formid");
		}
		if (nodeid == -1){
				rs.executeProc("workflow_CreateNode_Select",workflowid+"");
				if(rs.next())
					nodeid=rs.getInt(1);
		
				nodetype="0";
		}		
	}
    RecordSet.executeSql("Select * From Meeting WHERE ID="+MeetingID);
	if(RecordSet.next()){
		meetingtype = Util.null2o(RecordSet.getString("meetingtype"));
		meetingname = Util.null2String(RecordSet.getString("name"));
		caller = Util.getIntValue(RecordSet.getString("caller"),0);
		contacter = Util.getIntValue(RecordSet.getString("contacter"),0);
		begindate = Util.null2String(RecordSet.getString("begindate"));
		begintime = Util.null2String(RecordSet.getString("begintime"));
		enddate = Util.null2String(RecordSet.getString("enddate"));
		endtime = Util.null2String(RecordSet.getString("endtime"));
		description=Util.null2String(RecordSet.getString("description"));
		address = Util.null2o(RecordSet.getString("address"));
        totalmember=Util.null2String(RecordSet.getString("totalmember"));
        totalmember = ""+Util.getIntValue(totalmember,0);
        others = Util.null2String(RecordSet.getString("othermembers"));
        projectid=Util.null2o(RecordSet.getString("projectid"));	//加入了项目id
        customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));
        
        remindBeforeStart = Util.getIntValue(RecordSet.getString("remindBeforeStart"),0);
        remindBeforeEnd = Util.getIntValue(RecordSet.getString("remindBeforeEnd"),0);
        remindType = Util.getIntValue(RecordSet.getString("remindType"),1);
        remindTimesBeforeStart = Util.getIntValue(RecordSet.getString("remindTimesBeforeStart"),0);
        remindTimesBeforeEnd = Util.getIntValue(RecordSet.getString("remindTimesBeforeEnd"),0);
    }
    RecordSet.executeSql("select membertype,memberid from Meeting_Member2 where meetingid="+MeetingID+" order by id ASC");
    while(RecordSet.next()){
        String membertype=Util.null2String(RecordSet.getString("membertype"));
        if(membertype.equals("1")){
        resources += Util.null2String(RecordSet.getString("memberid"))+",";
        }
        if(membertype.equals("2")){
        crms += Util.null2String(RecordSet.getString("memberid"))+",";
        }
    }
    if(resources.length()>0){
       resources=resources.substring(0,resources.length()-1);
    }
    if(crms.length()>0){
       crms=crms.substring(0,crms.length()-1);
    }
     requestname=SystemEnv.getHtmlLabelName(16419,user.getLanguage())+"-"+meetingname;
     
}
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	response.sendRedirect("/notice/RequestError.jsp");
    else 
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

if(remark.equals("")){
	remark = ResourceComInfo.getResourcename(""+user.getUID())+" "+CurrentDate+" "+CurrentTime ;
}
if(src.equals("delete")){
	/*删除工作流时，更新会议状态为审批退回，并清空会议的requestid*/
    RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid);
	if(RecordSet.next())
		MeetingID = RecordSet.getString("approveid");
    RecordSet.executeProc("Meeting_Delete",MeetingID);

	RecordSet.executeProc("Meeting_Member2_Delete",MeetingID);

	RecordSet.executeProc("Meeting_Topic_Delete",MeetingID);

	RecordSet.executeProc("Meeting_Service2_Delete",MeetingID);

    RecordSet.executeProc("MeetingShareDetail_DById",MeetingID);

}
RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = true ;
if(!isfrommeeting.equals("1"))
    savestatus = RequestManager.saveRequestInfo() ;    //不是从会议显示页面提交审批过来的才作saveRequestInfo否则会由于文档显示页面没有单据的字段信息而被清空
else RequestManager.setBilltablename("Bill_Meeting");

requestid = RequestManager.getRequestid() ;


if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
                response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message);
			else out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
            response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        else out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
            response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        else out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}
if(src.equals("submit")&&!MeetingID.equals("")){

    String updateSql ="Update Bill_Meeting Set meetingtype ="+meetingtype+",meetingname ='"+Util.convertInput2DB(meetingname)+"',caller="+caller+",contacter="
            +contacter+",address="+address+",begindate='"+begindate+"',begintime='"+begintime+"',enddate='"+enddate+"',endtime='"+endtime
            +"',description='"+Util.convertInput2DB(description)+"',approveid="+MeetingID+",resourcenum="+totalmember+",resources='"+resources+"',crms='"+crms+"',others='"+others+"',projectid="+projectid+",customizeAddress='"+customizeAddress
            +"',remindBeforeStart="+remindBeforeStart+",remindBeforeEnd="+remindBeforeEnd+",remindType="+remindType+",remindTimesBeforeStart="+remindTimesBeforeStart+",remindTimesBeforeEnd="+remindTimesBeforeEnd+" WHERE requestID ="+requestid;
	RecordSet.executeSql(updateSql);
 }
boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
        response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	else out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}
boolean logstatus = RequestManager.saveRequestLog() ;
if(!src.equals("save")){
	Calendar today = Calendar.getInstance();
			String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
					Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
					Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	
			String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
					Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
					Util.add0(today.get(Calendar.SECOND), 2);
	RecordSet.executeSql("select a.nodeid from workflow_flownode a,workflow_nodebase b where a.nodeid=b.id and a.workflowid="+workflowid+" and a.nodetype = 0");
	if(RecordSet.next()){
		int node_id = Util.getIntValue(RecordSet.getString("nodeid"),0);
		if(nodeid == node_id){
			RecordSet.executeSql("update workflow_currentoperator set isremark='2',operatedate='"+currentdate+"',operatetime='"+currenttime+"' where (isremark = '5' or isremark='0') and requestid=" + requestid+" and nodeid="+node_id+"");
		}
	}
}
if(src.equals("submit")&&MeetingID.equals("")){
    RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid+" order by id desc");
	if(RecordSet.next()){
		meetingtype = Util.null2o(RecordSet.getString("meetingtype"));
		meetingname = Util.null2String(RecordSet.getString("meetingname"));
		caller = Util.getIntValue(RecordSet.getString("caller"),0);
		contacter = Util.getIntValue(RecordSet.getString("contacter"),0);
		begindate = Util.null2String(RecordSet.getString("begindate"));
		begintime = Util.null2String(RecordSet.getString("begintime"));
		enddate = Util.null2String(RecordSet.getString("enddate"));
		endtime = Util.null2String(RecordSet.getString("endtime"));
		address = Util.null2o(RecordSet.getString("address"));
		description=Util.null2String(RecordSet.getString("description"));
        totalmember=Util.null2String(RecordSet.getString("resourcenum"));
        totalmember = ""+Util.getIntValue(totalmember,0);
        others = Util.null2String(RecordSet.getString("others"));
        resources=Util.null2String(RecordSet.getString("resources"));
        crms = Util.null2String(RecordSet.getString("crms"));
        projectid=Util.null2o(RecordSet.getString("projectid"));	//加入了项目id
        customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));
        remindBeforeStart = Util.getIntValue(RecordSet.getString("remindBeforeStart"),0);
        remindBeforeEnd = Util.getIntValue(RecordSet.getString("remindBeforeEnd"),0);
        remindType = Util.getIntValue(RecordSet.getString("remindType"),1);
        remindTimesBeforeStart = Util.getIntValue(RecordSet.getString("remindTimesBeforeStart"),0);
        remindTimesBeforeEnd = Util.getIntValue(RecordSet.getString("remindTimesBeforeEnd"),0);
    }
    RecordSet.executeSql("Select id From Meeting where requestid="+requestid);
    if(RecordSet.next()){
        MeetingID=RecordSet.getString("id");
    }
    if(!MeetingID.equals("")){
        sqlstr = "Update Meeting Set meetingtype="+meetingtype+",name='"+Util.convertInput2DB(meetingname)+"',caller="+caller+",contacter="
                +contacter+",address="+address+",begindate='"+begindate+"',begintime='"+begintime+"',enddate='"+enddate+"',endtime='"
                +endtime+"',description='"+Util.convertInput2DB(description)+"',totalmember="+totalmember+",othermembers='"+others+"',projectid="+projectid+",customizeAddress='"+customizeAddress
                +"',remindBeforeStart="+remindBeforeStart+",remindBeforeEnd="+remindBeforeEnd+",remindType="+remindType+",remindTimesBeforeStart="+remindTimesBeforeStart+",remindTimesBeforeEnd="+remindTimesBeforeEnd+" Where id="+MeetingID;
        RecordSet.executeSql(sqlstr);
    }else{
        Procpara =  meetingtype;
        Procpara += flag + meetingname;
        Procpara += flag + ""+caller;
        Procpara += flag + ""+contacter;
        Procpara += flag + projectid; //加入项目id
        Procpara += flag + address;
        Procpara += flag + begindate;
        Procpara += flag + begintime;
        Procpara += flag + enddate;
        Procpara += flag + endtime;
        Procpara += flag + remark;
        Procpara += flag + ""+user.getUID();
        Procpara += flag + CurrentDate;
        Procpara += flag + CurrentTime;
        Procpara += flag + totalmember;
        Procpara += flag + others;
        Procpara += flag + "";
        Procpara += flag + description;
        Procpara += flag + ""+remindType;
        Procpara += flag + ""+remindBeforeStart;
        Procpara += flag + ""+remindBeforeEnd;
        Procpara += flag + ""+remindTimesBeforeStart;
        Procpara += flag + ""+remindTimesBeforeEnd;
        Procpara += flag + customizeAddress;
        RecordSet.executeProc("Meeting_Insert",Procpara);
        RecordSet.executeProc("Meeting_SelectMaxID","");
        RecordSet.next();
        MeetingID = RecordSet.getString(1);
        RecordSet.executeSql("update Meeting set requestid="+requestid+" where id="+MeetingID);
        RecordSet.executeSql("update bill_Meeting set approveid="+MeetingID+" where requestid="+requestid);
    }
    
    RecordSet.executeSql("delete From Meeting_member2 where meetingid="+MeetingID);
    
	//删除会议中相关的标识是否查看的信息
	StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("DELETE FROM Meeting_View_Status WHERE meetingId = ");
	stringBuffer.append(MeetingID);
	RecordSet.executeSql(stringBuffer.toString());
    
    ArrayList arrayhrmids02 = Util.TokenizerString(resources,",");
	for(int i=0;i<arrayhrmids02.size();i++){
		Procpara =  MeetingID;
		Procpara += flag + "1";
		Procpara += flag + "" + arrayhrmids02.get(i);
		Procpara += flag + "" + arrayhrmids02.get(i);
		RecordSet.executeProc("Meeting_Member2_Insert",Procpara);
				
		//标识会议是否查看过
		stringBuffer = new StringBuffer();
		stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		stringBuffer.append(MeetingID);
		stringBuffer.append(", ");
		stringBuffer.append(arrayhrmids02.get(i));
		stringBuffer.append(", '");
		stringBuffer.append("1");
		stringBuffer.append("', '");
		if(String.valueOf(userid).equals(arrayhrmids02.get(i)))
		//当前操作用户表示已看
		{
		    stringBuffer.append("1");
		}
		else
		{
		    stringBuffer.append("0");
		}
		stringBuffer.append("')");
		RecordSet.executeSql(stringBuffer.toString());		
	}

	ArrayList arraycrmids02 = Util.TokenizerString(crms,",");
	for(int i=0;i<arraycrmids02.size();i++){
		String membermanager="";
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+arraycrmids02.get(i));
		if(RecordSet.next()) membermanager=RecordSet.getString("manager");
		Procpara =  MeetingID;
		Procpara += flag + "2";
		Procpara += flag + "" + arraycrmids02.get(i);
		Procpara += flag + membermanager;
		RecordSet.executeProc("Meeting_Member2_Insert",Procpara);
	}
    //添加共享
    RecordSet.executeProc("MeetingShareDetail_DById",MeetingID);
    MeetingViewer.setMeetingShareById(""+MeetingID);
}

ArrayList fieldids=new ArrayList();             //字段队列
ArrayList fieldnames = new ArrayList();
ArrayList fielddbtypes = new ArrayList();

RecordSet.executeProc("workflow_billfield_Select",formid+"");
while(RecordSet.next()){
	fieldids.add(RecordSet.getString("id"));
	fieldnames.add(RecordSet.getString("fieldname"));
	fielddbtypes.add(RecordSet.getString("fielddbtype"));
}

/**更新会议共享权限*/


char flag1=Util.getSeparator() ;

//System.out.println("RequestManager.getNodetype() ="+RequestManager.getNodetype());
//System.out.println("RequestManager.getNextNodetype() ="+RequestManager.getNextNodetype());

    /*下一个节点未审批节点时才给节点操作者赋予会议权限*/
    if(RequestManager.getNextNodetype().equals("1")){
        sqlstr = "select distinct userid,usertype from workflow_currentoperator where isremark = '0' and requestid ="+requestid;

        //System.out.println("sqlstr ="+sqlstr);
        int theusertype=0;
        rs.executeSql(sqlstr);
        while(rs.next()){
            int userid1 = rs.getInt("userid");
            int usertype1 = rs.getInt("usertype");
             if( usertype1 == 0 ) theusertype = 1 ;
                        else theusertype = 2 ;

            int sharelevel = 4 ;
            if(!MeetingID.equals("")){
                RecordSet.executeSql(" select sharelevel from meeting_sharedetail where meetingid = " + MeetingID + " and userid = " + userid1 + " and usertype = " + theusertype + " AND shareLevel <> 2" );               
                if(RecordSet.getCounts() == 0){
                    //Procpara = ""+MeetingID + flag1 + ""+userid1 + flag1 + ""+theusertype + flag1 + ""+sharelevel ;
                    RecordSet.executeSql("INSERT INTO Meeting_ShareDetail(meetingid, userid, usertype, sharelevel) VALUES ("+MeetingID+","+userid1+","+theusertype+","+sharelevel+")");  //插入审批人权限
                    //System.out.println("INSERT INTO Meeting_ShareDetail(meetingid, userid, usertype, sharelevel) VALUES ("+MeetingID+","+userid1+","+theusertype+","+sharelevel+")");
                    //RecordSet.executeProc("MeetingShareDetail_Insert",Procpara);
                }
            }
        }
    }

//Save data to Bill_ApproveProj 创建时
if(src.equals("submit")&&iscreate.equals("1")) {
	RecordSet.executeSql("Update Meeting Set requestid ="+requestid+",meetingstatus=1 WHERE ID="+MeetingID);//更新当前会议的requestid

	//如果仅仅两个节点直接触发流程
    if(RequestManager.getNextNodetype().equals("3")){
		sqlstr = "Update Meeting Set meetingstatus = 2 Where id="+MeetingID;
		RecordSet.executeSql(sqlstr);

        MeetingComInfo.removeMeetingInfoCache();

		//会议通知
		String SWFAccepter,
			   SWFTitle,
			   SWFRemark,
			   SWFSubmiter
				;

		SWFAccepter="";
		RecordSet.executeProc("Meeting_Member2_SelectByType",MeetingID+flag+"1");
		//sqlstr="select distinct membermanager from Meeting_Member2 where meetingid="+MeetingID;
        String resourceids =""  ;
		//RecordSet.executeSql(sqlstr);
		while(RecordSet.next()){
			//if(!RecordSet.getString(1).equals(caller) && !RecordSet.getString(1).equals(contacter)){
			SWFAccepter+=","+RecordSet.getString("memberid");
			//}
            resourceids += ","+ RecordSet.getString("memberid");
        }
		description = "您有会议: "+meetingname+"   会议时间:"+begindate+" "+begintime+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
		addPlan(workPlanService,MeetingID,""+caller,meetingname,description,resourceids,begindate,
				begintime,enddate,endtime,
				""+remindType,
                ""+remindBeforeStart,
                ""+remindBeforeEnd,
                remindTimesBeforeStart,
                remindTimesBeforeEnd);
		
					

		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += meetingname;
			SWFTitle += "-"+ResourceComInfo.getResourcename(""+contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=""+contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MeetingID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		SWFAccepter="";
		sqlstr="select distinct hrmid from Meeting_Service2 where meetingid="+MeetingID;
		RecordSet.executeSql(sqlstr);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += meetingname;
			SWFTitle += "-"+ResourceComInfo.getResourcename(""+contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=""+contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MeetingID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}



	 }
	if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MeetingID);
	else out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
    return;
}
/*审批通过时*/
//System.out.println("src = "+src);
//System.out.println("iscreate = "+iscreate);
if(src.equals("submit")&&iscreate.equals("0")){
    RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid);
	if(RecordSet.next()){
			MeetingID = RecordSet.getString("approveid");
			meetingtype = Util.null2o(RecordSet.getString("meetingtype"));
			meetingname = Util.null2String(RecordSet.getString("meetingname"));
			caller = Util.getIntValue(RecordSet.getString("caller"),0);
			contacter = Util.getIntValue(RecordSet.getString("contacter"),0);
			begindate = Util.null2String(RecordSet.getString("begindate"));
			begintime = Util.null2String(RecordSet.getString("begintime"));
			enddate = Util.null2String(RecordSet.getString("enddate"));
			endtime = Util.null2String(RecordSet.getString("endtime"));
			description=Util.null2String(RecordSet.getString("description"));
			address = Util.null2o(RecordSet.getString("address"));
            totalmember=Util.null2String(RecordSet.getString("resourcenum"));
            totalmember = ""+Util.getIntValue(totalmember,0);
            others = Util.null2String(RecordSet.getString("others"));
            resources=Util.null2String(RecordSet.getString("resources"));
            crms = Util.null2String(RecordSet.getString("crms"));
            projectid=Util.null2o(RecordSet.getString("projectid"));	//加入了项目id
            customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));
            
            remindBeforeStart = Util.getIntValue(RecordSet.getString("remindBeforeStart"),0);
            remindBeforeEnd = Util.getIntValue(RecordSet.getString("remindBeforeEnd"),0);
            remindType = Util.getIntValue(RecordSet.getString("remindType"),1);
            remindTimesBeforeStart = Util.getIntValue(RecordSet.getString("remindTimesBeforeStart"),0);
            remindTimesBeforeEnd = Util.getIntValue(RecordSet.getString("remindTimesBeforeEnd"),0);
    /*审批退回时，重新提交，先更新会议的状态为待审批*/
		RecordSet.executeSql("Update Meeting Set meetingstatus=1 where ID ="+MeetingID);
    /*审批退回时，重新提交*/
    /*
    if(nodetype.equals("0")){
		saveSql ="Update Bill_Meeting Set meetingtype ="+meetingtype+",meetingname ='"+Util.convertInput2DB(meetingname)+"',caller="+caller+",contacter="
                +contacter+",address="+address+",begindate='"+begindate+"',begintime='"+begintime+"',enddate='"+enddate+"',endtime='"
                +endtime+"',description='"+Util.convertInput2DB(description)+"',approveid="+MeetingID
                +",remindBeforeStart="+remindBeforeStart+",remindBeforeEnd="+remindBeforeEnd+",remindType="+remindType+",remindTimesBeforeStart="+remindTimesBeforeStart+",remindTimesBeforeEnd="+remindTimesBeforeEnd+" WHERE requestID ="+requestid;

		RecordSet.executeSql(saveSql);

	}*/

    /*为审批节点时，更新审批人，和审批时间*/
    if(nodetype.equals("1")){
        saveSql ="Update Bill_Meeting Set approveby="+userid+",approvedate='"+CurrentDate+"' WHERE requestID="+requestid;

        //System.out.println("saveSql =="+saveSql);

        RecordSet.executeSql(saveSql);
    }
     if(RequestManager.getNextNodetype().equals("3")){
     RecordSet.executeSql("Update Meeting Set meetingstatus=2 where ID ="+MeetingID);
		sqlstr = "Update Meeting Set meetingstatus = 2,meetingtype="+meetingtype+",name='"+Util.convertInput2DB(meetingname)+"',caller="+caller+",contacter="
                +contacter+",address="+address+",begindate='"+begindate+"',begintime='"+begintime+"',enddate='"+enddate+"',endtime='"
                +endtime+"',description='"+Util.convertInput2DB(description)+"',totalmember="+totalmember+",othermembers='"+others+"',projectid="+projectid+",customizeAddress='"+customizeAddress
                +"',remindBeforeStart="+remindBeforeStart+",remindBeforeEnd="+remindBeforeEnd+",remindType="+remindType+",remindTimesBeforeStart="+remindTimesBeforeStart+",remindTimesBeforeEnd="+remindTimesBeforeEnd+" Where id="+MeetingID;
        RecordSet.executeSql(sqlstr);
        
        //更新参予人员和参予客户
        sqlstr="delete from Meeting_Member2 where meetingid="+MeetingID;                        
        RecordSet.executeSql(sqlstr);
        
		//删除会议中相关的标识是否查看的信息
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append("DELETE FROM Meeting_View_Status WHERE meetingId = ");
        stringBuffer.append(MeetingID);
        RecordSet.executeSql(stringBuffer.toString());
        
        ArrayList resourcelist=Util.TokenizerString(resources,",");
        ArrayList crmlist=Util.TokenizerString(crms,",");
        for(int i=0;i<resourcelist.size();i++){
            Procpara =  MeetingID;
		    Procpara += flag + "1";
		    Procpara += flag + "" + resourcelist.get(i);
		    Procpara += flag + "" + resourcelist.get(i);
		    RecordSet.executeProc("Meeting_Member2_Insert",Procpara);
		    
			//标识会议是否查看过
		    stringBuffer = new StringBuffer();
		    stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		    stringBuffer.append(MeetingID);
		    stringBuffer.append(", ");
		    stringBuffer.append(resourcelist.get(i));
		    stringBuffer.append(", '");
		    stringBuffer.append("1");
		    stringBuffer.append("', '");
		    if(String.valueOf(userid).equals(resourcelist.get(i)))
			//当前操作用户标识已看
		    {
		        stringBuffer.append("1");
		    }
		    else
		    {
		        stringBuffer.append("0");
		    }
		    stringBuffer.append("')");
		    RecordSet.executeSql(stringBuffer.toString());	
		    
        }
        for(int i=0;i<crmlist.size();i++){
            String membermanager="";
		    RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+crmlist.get(i));
		    if(RecordSet.next()) membermanager=RecordSet.getString("manager");
            Procpara =  MeetingID;
		    Procpara += flag + "2";
		    Procpara += flag + "" + crmlist.get(i);
		    Procpara += flag + "" + membermanager;
		    RecordSet.executeProc("Meeting_Member2_Insert",Procpara);
        }

        MeetingComInfo.removeMeetingInfoCache();

		//会议通知
		String SWFAccepter,
			   SWFTitle,
			   SWFRemark,
			   SWFSubmiter
				;

		SWFAccepter="";
		RecordSet.executeProc("Meeting_Member2_SelectByType",MeetingID+flag+"1");
		//sqlstr="select distinct membermanager from Meeting_Member2 where meetingid="+MeetingID;
        String resourceids =""  ;
		//RecordSet.executeSql(sqlstr);
		while(RecordSet.next()){
			//if(!RecordSet.getString(1).equals(caller) && !RecordSet.getString(1).equals(contacter)){
			SWFAccepter+=","+RecordSet.getString("memberid");
			//}
            resourceids += ","+ RecordSet.getString("memberid");
        }
		
		description = "您有会议: "+meetingname+"   会议时间:"+begindate+" "+begintime+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
		int workPlanID = addPlan(workPlanService,MeetingID,""+caller,meetingname,description,resourceids,begindate,
				begintime,enddate,endtime,
				""+remindType,
                ""+remindBeforeStart,
                ""+remindBeforeEnd,
                remindTimesBeforeStart,
                remindTimesBeforeEnd);
	    
	

		//System.out.println("SWFAccepter = "+SWFAccepter);
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += meetingname;
			SWFTitle += "-"+ResourceComInfo.getResourcename(""+contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=""+contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MeetingID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		SWFAccepter="";
		sqlstr="select distinct hrmid from Meeting_Service2 where meetingid="+MeetingID;
		RecordSet.executeSql(sqlstr);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += meetingname;
			SWFTitle += "-"+ResourceComInfo.getResourcename(""+contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=""+contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MeetingID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}
		
		if("1".equals(approvemeeting)) { /***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过***/
	      response.sendRedirect("/meeting/data/MeetingApproval.jsp");
	      return;
	    }

	 if (-1 != workPlanID) 
		{
			if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	        response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MeetingID);
			else out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
			return;
		}

	 }
    }
	
	if("1".equals(approvemeeting)) { /***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过***/
	    response.sendRedirect("/meeting/data/MeetingApproval.jsp");
	    return;
	}
	
    //if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	//	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MeetingID);
}
/*审批拒绝时*/
if(src.equals("reject")&&iscreate.equals("0")){
	billid = RequestManager.getBillid() ;

	if(RequestManager.getNextNodetype().equals("0")){
		RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid);
		if(RecordSet.next()){
			MeetingID = RecordSet.getString("approveid");
			meetingtype = Util.null2o(RecordSet.getString("meetingtype"));
			meetingname = Util.null2String(RecordSet.getString("meetingname"));
			description = Util.null2String(RecordSet.getString("description"));
			caller = Util.getIntValue(RecordSet.getString("caller"),0);
			contacter = Util.getIntValue(RecordSet.getString("contacter"),0);
			begindate = Util.null2String(RecordSet.getString("begindate"));
			begintime = Util.null2String(RecordSet.getString("begintime"));
			enddate = Util.null2String(RecordSet.getString("enddate"));
			endtime = Util.null2String(RecordSet.getString("endtime"));
			address = Util.null2o(RecordSet.getString("address"));
			customizeAddress = Util.null2String(RecordSet.getString("customizeAddress"));
			
            remindBeforeStart = Util.getIntValue(RecordSet.getString("remindBeforeStart"),0);
            remindBeforeEnd = Util.getIntValue(RecordSet.getString("remindBeforeEnd"),0);
            remindType = Util.getIntValue(RecordSet.getString("remindType"),1);
            remindTimesBeforeStart = Util.getIntValue(RecordSet.getString("remindTimesBeforeStart"),0);
            remindTimesBeforeEnd = Util.getIntValue(RecordSet.getString("remindTimesBeforeEnd"),0);
		}
		sqlstr ="Update Meeting Set meetingstatus = 3,meetingtype="+meetingtype+",name='"+Util.convertInput2DB(meetingname)+"',caller="+caller+",contacter="+contacter+",address="+address+",begindate='"+begindate+"',begintime='"+begintime+"',enddate='"+enddate+"',endtime='"+endtime+"',description='"+Util.convertInput2DB(description)+"',customizeAddress='"+customizeAddress
		+"',remindBeforeStart="+remindBeforeStart+",remindBeforeEnd="+remindBeforeEnd+",remindType="+remindType+",remindTimesBeforeStart="+remindTimesBeforeStart+",remindTimesBeforeEnd="+remindTimesBeforeEnd+" Where id="+MeetingID ;

		//System.out.println("sqlstr = "+sqlstr);
		RecordSet.executeSql(sqlstr);

		MeetingComInfo.removeMeetingInfoCache();
	}

	if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
		response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MeetingID);
		else out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		return;
}
/*
if(src.equals("save")&&iscreate.equals("0")){
	billid = RequestManager.getBillid() ;
	saveSql ="Update Bill_Meeting Set ";
	for(int i=0;i<fieldids.size();i++){
		if(fielddbtypes.get(i).equals("INT"))
	        saveSql += fieldnames.get(i) +" = "+request.getParameter("field"+fieldids.get(i))+",";
		else saveSql += fieldnames.get(i) +" = '"+request.getParameter("field"+fieldids.get(i))+"',";
	}
	saveSql = saveSql.substring(0,saveSql.length()-1);
	saveSql +=" Where id="+billid;

	//System.out.println("saveSql = "+saveSql);

	RecordSet.executeSql(saveSql);
}
*/

//response.sendRedirect("/workflow/request/RequestView.jsp");

if(!"".equals(approvewfid)) {  //会议通过流程审批时TD17758
        if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	     response.sendRedirect("/workflow/request/RequestView.jsp");
        else out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		 return;
	 }
    if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MeetingID);
	else out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>