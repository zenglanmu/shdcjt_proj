<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>
<%@ page import="weaver.WorkPlan.WorkPlanViewer" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.WorkPlan.WorkPlanService" %>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="MeetingViewer" class="weaver.meeting.MeetingViewer" scope="page"/>
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<%!
public void addPlan(String subject,
                    String meetingID,
                    String beginDate,
                    String beginTime,
                    String endDate,
                    String endTime,
                    String caller,
                    String currentDate,
                    String currentTime,
                    String remindType,
                    String remindBeforeStart,
                    String remindBeforeEnd,
                    int remindTimesBeforeStart,
                    int remindTimesBeforeEnd,
                    String description,
					String ip)
{
    if(!meetingID.equals(""))
    {        
        String sqlstr="SELECT DISTINCT memberManager FROM Meeting_Member2 WHERE meetingId = " + meetingID;
        String resourceids ="";
        String para ="";
	    String[] logParams;
	    WorkPlanLogMan logMan = new WorkPlanLogMan();
        char flag1 = Util.getSeparator() ;
        RecordSet rs = new RecordSet();
        rs.executeSql(sqlstr);	
        while(rs.next())
        {
            resourceids += ","+ rs.getString(1);
        }
                        
		if(!"".equals(resourceids))
		{
	        WorkPlan workPlan = new WorkPlan();
	        WorkPlanService workPlanService = new WorkPlanService();
		    
		    workPlan.setCreaterId(Integer.parseInt(caller));
		    //workPlan.setCreateType(Integer.parseInt(user.getLogintype()));

		    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ConferenceCalendar));        
		    workPlan.setWorkPlanName(subject);    
		    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
		    workPlan.setResourceId(resourceids.substring(1));
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
		    workPlan.setMeeting(meetingID);
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
		    workPlan.setDescription(description);
		    workPlanService.insertWorkPlan(workPlan);  //插入日程
		    
		    //插入日志
            logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, caller, ip};
            logMan.writeViewLog(logParams);
		}     
    }
}
public void saveAccessory(FileUpload fu,User user,RecordSet RecordSet,String meetingid)
{
	int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
	//附件上传
	String tempAccessory = "";
	if(accessorynum>0){
		String[] uploadField=new String[accessorynum];
		for(int i=0;i<accessorynum;i++){
			uploadField[i]="accessory"+(i+1);
		}
		DocExtUtil mDocExtUtil=new DocExtUtil();
		//int[] returnarry = mDocExtUtil.uploadDocsToImgs(fu,user,uploadField); 
		String returnarry1 =fu.getParameter("relatedacc");
		String[] returnarry = returnarry1.split(",");
		if(returnarry != null){
			for(int j=0;j<returnarry.length;j++){
				if(!returnarry[j].equals("-1")){
						//新建时赋予创建者对附件文档的权限，而不是对所有参与者赋权。
						RecordSet.executeSql("insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)values("+returnarry[j]+",1,"+user.getUID()+",0,1,1,"+user.getUID()+",1)");
						if(tempAccessory.equals(""))
						{
							tempAccessory = String.valueOf(returnarry[j]);
						}
						else
						{
							tempAccessory += "," + String.valueOf(returnarry[j]);
						}
				}
			}
		}
	}
	String sql = "update meeting set accessorys = '"+tempAccessory+"' where id="+meetingid;
	RecordSet.executeSql(sql);
}
public void editAccessory(FileUpload fu,User user,String meetingid,RecordSet RecordSet)
{
	int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
	int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);
	RecordSet.executeSql("SELECT accessorys FROM meeting WHERE id = " + meetingid);
	if(RecordSet.next()){
		String oldAccessory = Util.null2String(RecordSet.getString(1));
		String newAccessory = oldAccessory;
		
		if(deleteField_idnum>0){
			for(int i=0;i<deleteField_idnum;i++){
				String field_del_flag = Util.null2String(fu.getParameter("field_del_"+i));
				if(field_del_flag.equals("1")){
					String field_del_value = Util.null2String(fu.getParameter("field_id_"+i));
					RecordSet.executeSql("delete DocDetail where id = " + field_del_value);
					if(newAccessory.indexOf(field_del_value)==0){
						newAccessory = Util.StringReplace(newAccessory,field_del_value+",","");
					}else{
						newAccessory = Util.StringReplace(newAccessory,","+field_del_value,"");
					}
				}
			}
		}
		if(accessorynum>0){
			String[] uploadField=new String[accessorynum];
			for(int i=0;i<accessorynum;i++){
				uploadField[i]="accessory"+(i+1);
			}
			DocExtUtil mDocExtUtil=new DocExtUtil();
			String returnarry1 =fu.getParameter("relatedacc");
			String[] returnarry = returnarry1.split(",");
			if(returnarry != null){
				for(int j=0;j<returnarry.length;j++){
					if(!returnarry[j].equals("-1")){
						if(newAccessory.equals("")){
							newAccessory = String.valueOf(returnarry[j]);
						}else{
							newAccessory += ","+String.valueOf(returnarry[j]);
						}
					}
				}
			}
		}
		RecordSet.executeSql("update meeting set accessorys='"+newAccessory+"' where id="+meetingid);
		if(!newAccessory.equals("")){
			ArrayList accessoryList = Util.TokenizerString(newAccessory,",");
			for(int i=0;i<accessoryList.size();i++){
				String accessory = (String)accessoryList.get(i);
				//编辑时赋予创建者对附件文档的权限，而不是对所有参与者赋权。
				//RecordSet.executeSql("insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,isSecDefaultShare) values("+accessory+",1,0,0,1,"+creater+",0,0,0,0,0,1)");
				RecordSet.executeSql("insert into shareinnerdoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)values("+accessory+",1,"+user.getUID()+",0,1,1,"+user.getUID()+",1)");
			}
		}
	}
}
%>
<%
FileUpload fu = new FileUpload(request);
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();
String SubmiterType = ""+user.getLogintype();
String ClientIP = fu.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag = 2;
String ProcPara = "";
String Sql="";

String method = Util.null2String(fu.getParameter("method"));
String meetingtype=Util.null2String(fu.getParameter("meetingtype"));
String meetingid=Util.null2String(fu.getParameter("meetingid"));

String approvewfid ="";


if(method.equals("add") || method.equals("addSubmit"))
{
	String name=Util.null2String(fu.getParameter("name"));
	String caller=Util.null2String(fu.getParameter("caller"));
	String contacter=Util.null2String(fu.getParameter("contacter"));
	String projectid=Util.null2String(fu.getParameter("projectid"));	//加入了项目id
	String address=Util.null2String(fu.getParameter("address"));
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	String desc=Util.spacetoHtml(Util.null2String(fu.getParameter("desc")));
	String totalmember=Util.null2String(fu.getParameter("totalmember"));
	String othermembers=Util.fromScreen(fu.getParameter("othermembers"),user.getLanguage());
	String addressdesc=Util.fromScreen(fu.getParameter("addressdesc"),user.getLanguage());
	String customizeAddress = Util.null2String(fu.getParameter("customizeAddress"));
	String description=Util.null2String(fu.getParameter("description"));
	int remindBeforeStart = Util.getIntValue(fu.getParameter("remindBeforeStart"),0);  //是否开始前提醒
	int remindBeforeEnd = Util.getIntValue(fu.getParameter("remindBeforeEnd"),0);  //是否结束前提醒
	int remindType = Util.getIntValue(fu.getParameter("remindType"),1);  //提醒方式
    int remindTimesBeforeStart = Util.getIntValue(fu.getParameter("remindDateBeforeStart"),0)*60+Util.getIntValue(Util.null2String(fu.getParameter("remindTimeBeforeStart")),0);  //开始前提醒时间
    int remindTimesBeforeEnd = Util.getIntValue(fu.getParameter("remindDateBeforeEnd"),0)*60+Util.getIntValue(Util.null2String(fu.getParameter("remindTimeBeforeEnd")),0);  //结束前提醒时间
	
    description = "您有会议: "+name+"   会议时间:"+begindate+" "+begintime+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
    ProcPara =  meetingtype;
	ProcPara += flag + name;
	ProcPara += flag + caller;
	ProcPara += flag + contacter;
	ProcPara += flag + projectid; //加入项目id
	ProcPara += flag + address;
	ProcPara += flag + begindate;
	ProcPara += flag + begintime;
	ProcPara += flag + enddate;
	ProcPara += flag + endtime;
	ProcPara += flag + desc;
	ProcPara += flag + CurrentUser;
	ProcPara += flag + CurrentDate;
	ProcPara += flag + CurrentTime;
    ProcPara += flag + totalmember;
    ProcPara += flag + othermembers;
    ProcPara += flag + addressdesc;
    ProcPara += flag + description;
    ProcPara += flag + ""+remindType;
    ProcPara += flag + ""+remindBeforeStart;
    ProcPara += flag + ""+remindBeforeEnd;
    ProcPara += flag + ""+remindTimesBeforeStart;
    ProcPara += flag + ""+remindTimesBeforeEnd;
    ProcPara += flag + customizeAddress;
    if (RecordSet.getDBType().equals("oracle"))
	{
	RecordSet.executeProc("Meeting_Insert",ProcPara);
    
	RecordSet.executeProc("Meeting_SelectMaxID","");
	}
	else
	{
	RecordSet.executeProc("Meeting_Insert",ProcPara);
	}
	RecordSet.next();
	String MaxID = RecordSet.getString(1);
    //System.out.print(MaxID);
	String[] hrmids01=fu.getParameterValues("hrmids01");
	String hrmids02=Util.null2String(fu.getParameter("hrmids02"));
	ArrayList arrayhrmids02 = Util.TokenizerString(hrmids02,",");
	if(hrmids01!=null){
		for(int i=0;i<hrmids01.length;i++){
			if(arrayhrmids02.indexOf(hrmids01[i]) == -1) arrayhrmids02.add(hrmids01[i]);
		}
	}
	for(int i=0;i<arrayhrmids02.size();i++){
		ProcPara =  MaxID;
		ProcPara += flag + "1";
		ProcPara += flag + "" + arrayhrmids02.get(i);
		ProcPara += flag + "" + arrayhrmids02.get(i);
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
		
		//标识会议是否查看过
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		stringBuffer.append(MaxID);
		stringBuffer.append(", ");
		stringBuffer.append(arrayhrmids02.get(i));
		stringBuffer.append(", '");
		stringBuffer.append("1");
		stringBuffer.append("', '");
		if(CurrentUser.equals(arrayhrmids02.get(i)))
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

	String[] crmids01=fu.getParameterValues("crmids01");
	String crmids02=Util.null2String(fu.getParameter("crmids02"));
	ArrayList arraycrmids02 = Util.TokenizerString(crmids02,",");
	if(crmids01!=null){
		for(int i=0;i<crmids01.length;i++){
			if(arraycrmids02.indexOf(crmids01[i]) == -1) arraycrmids02.add(crmids01[i]);
		}
	}
	for(int i=0;i<arraycrmids02.size();i++){
		String membermanager="";
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+arraycrmids02.get(i));
		if(RecordSet.next()) membermanager=RecordSet.getString("manager");
		ProcPara =  MaxID;
		ProcPara += flag + "2";
		ProcPara += flag + "" + arraycrmids02.get(i);
		ProcPara += flag + membermanager;
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
	}

	int topicrows=Util.getIntValue(Util.null2String(fu.getParameter("topicrows")),0);
	for(int i=0;i<topicrows;i++){
		String topicsubject=Util.null2String(fu.getParameter("topicsubject_"+i));
		String topichrmids=Util.null2String(fu.getParameter("topichrmids_"+i));
		String topicprojid=Util.null2String(fu.getParameter("topicprojid_"+i));
		String topiccrmid=Util.null2String(fu.getParameter("topiccrmid_"+i));
		String topicopen=Util.null2String(fu.getParameter("topicopen_"+i));
		if(!topicsubject.equals("")){
			ProcPara =  MaxID;
			ProcPara += flag + "0";
			ProcPara += flag + topicsubject;
			ProcPara += flag + topichrmids;
			ProcPara += flag + topicprojid;
			ProcPara += flag + topiccrmid;
			ProcPara += flag + topicopen;
			RecordSet.executeProc("Meeting_Topic_Insert",ProcPara);
		}
	}

	int servicerows=Util.getIntValue(Util.null2String(fu.getParameter("servicerows")),0);
	for(int i=0;i<servicerows;i++){
		String servicename=Util.null2String(fu.getParameter("servicename_"+i));
		String servicehrm=Util.null2String(fu.getParameter("servicehrm_"+i));
		String[] serviceitem=fu.getParameterValues("serviceitem_"+i);
		String serviceother=Util.null2String(fu.getParameter("serviceother_"+i));
		String servicedesc="";
		if(serviceitem != null){
			for(int j=0;j<serviceitem.length;j++){
				//String newId = new String(serviceitem[j].getBytes("iso-8859-1"),"GBK"); 
				//String sql = "select desc_n from Meeting_Service where id = '"+newId+"' ";
				//RecordSet2.executeSql(sql);
				//RecordSet2.next();
				//String desc_n = RecordSet2.getString("desc_n");
				//servicedesc +=  "," + desc_n;
				String serviceitemValue = new String(serviceitem[j].getBytes("iso-8859-1"),"GBK"); 
				servicedesc += "," + serviceitemValue;
			}
		}
		if(!servicedesc.equals("")){
			servicedesc = servicedesc.substring(1);
			if(!serviceother.equals("")){
				servicedesc += "," + serviceother;
			}
		}else{
				servicedesc +=  serviceother;
		}
		if(!servicename.equals("")&&!servicedesc.equals("")){
			ProcPara =  MaxID;
			ProcPara += flag + servicehrm;
			ProcPara += flag + servicename;
			ProcPara += flag + servicedesc;
			RecordSet.executeProc("Meeting_Service2_Insert",ProcPara);
		}
	}

    MeetingViewer.setMeetingShareById(""+MaxID);
	MeetingComInfo.removeMeetingInfoCache();
	//保存附件信息
	saveAccessory(fu,user,RecordSet,MaxID);

	//2004年4月17日，根据会议类型所对应的工作流判断是否需要触发审批工作流
    if(method.equals("addSubmit")){
        if(!meetingtype.equals("")){

            RecordSet.executeSql("Select approver From Meeting_Type WHERE ID ="+meetingtype);
            RecordSet.next();
            approvewfid = RecordSet.getString(1);
        }
        if(!approvewfid.equals("0")&&!approvewfid.equals("")){
            response.sendRedirect("/workflow/request/BillMeetingOperation.jsp?src=submit&iscreate=1&MeetingID="+MaxID+"&approvewfid="+approvewfid+"&viewmeeting=1");
            return;
        }else{
            RecordSet.executeSql("Update Meeting Set meetingstatus = 2 WHERE id="+MaxID);//更新会议状态为正常
            description = "您有会议: "+name+"   会议时间:"+begindate+" "+begintime+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
            addPlan(name,
                    MaxID,
                    begindate,
                    begintime,
                    enddate,
                    endtime,
                    caller,
                    CurrentDate,
                    CurrentTime,
                    ""+remindType,
                    ""+remindBeforeStart,
                    ""+remindBeforeEnd,
                    remindTimesBeforeStart,
                    remindTimesBeforeEnd,
                    description,
                    fu.getRemoteAddr() // added by lupeng 2004-07-23
			        )   ;
			//触发提醒工作流  Added by Charoes Huang，July 23,2004
			
			String SWFTitle="";
			String SWFRemark="";
			String SWFSubmiter="";
			String SWFAccepter="";
			String sql="";

		//会议通知
		RecordSet.executeProc("Meeting_Member2_SelectByType",MaxID+flag+"1");
	    //sql="select distinct membermanager from Meeting_Member2 where meetingid="+MaxID;
		//RecordSet.executeSql(sql);
		while(RecordSet.next()){
			//Modified By Charoes Huang On July 26,2004
			//if(!RecordSet.getString(1).equals(caller) && !RecordSet.getString(1).equals(contacter)){
			SWFAccepter+=","+RecordSet.getString("memberid");
			//}
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MaxID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}
		//会议服务
		SWFAccepter="";
		sql="select distinct hrmid from Meeting_Service2 where meetingid="+MaxID;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(MaxID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

            response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MaxID);

            return;
        }
    }
    response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MaxID);
    return;
}

if(method.equals("editSubmit")) {

    if(!meetingid.equals("")) {

        RecordSet rs = new RecordSet();
        rs.executeSql("Update Meeting Set meetingstatus = 2 WHERE id="+meetingid);//更新会议状态为正常
        rs.executeProc("Meeting_SelectByID",meetingid);
    rs.next();
    String name=rs.getString("name");
    String caller=rs.getString("caller");
    String contacter=rs.getString("contacter");
    String begindate=rs.getString("begindate");
    String begintime=rs.getString("begintime");
    String enddate=rs.getString("enddate");
    String endtime=rs.getString("endtime");
    String desc=rs.getString("desc_n");
    String creater=rs.getString("creater");
    String createdate=rs.getString("createdate");
    String createtime=rs.getString("createtime");
    String description = rs.getString("description");
    int remindBeforeStart = Util.getIntValue(rs.getString("remindBeforeStart"),0);  //是否开始前提醒
	int remindBeforeEnd = Util.getIntValue(rs.getString("remindBeforeEnd"),0);  //是否结束前提醒
	int remindType = Util.getIntValue(rs.getString("remindType"),1);  //提醒方式
    int remindTimesBeforeStart = Util.getIntValue(rs.getString("remindTimesBeforeStart"),0);  //开始前提醒时间
    int remindTimesBeforeEnd = Util.getIntValue(rs.getString("remindTimesBeforeEnd"),0);  //结束前提醒时间
    String address = rs.getString("address");
    String customizeAddress = rs.getString("customizeAddress");
    description = "您有会议: "+name+"   会议时间:"+begindate+" "+begintime+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
    addPlan(name,
                    meetingid,
                    begindate,
                    begintime,
                    enddate,
                    endtime,
                    caller,
                    CurrentDate,
                    CurrentTime,
                    ""+remindType,
                    ""+remindBeforeStart,
                    ""+remindBeforeEnd,
                    remindTimesBeforeStart,
                    remindTimesBeforeEnd,
                    description,
                    fu.getRemoteAddr() // added by lupeng 2004-07-23
                    );

		//触发提醒工作流  Added by Charoes Huang，July 23,2004
		
		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";
		String sql="";

		//会议通知
		RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
	    //sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
		//RecordSet.executeSql(sql);
		while(RecordSet.next()){
			//Modified By Charoes Huang ,On July 26,2004
			//if(!RecordSet.getString(1).equals(caller) && !RecordSet.getString(1).equals(contacter)){
			SWFAccepter+=","+RecordSet.getString("memberid");
			//}
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}
		//会议服务
		SWFAccepter="";
		sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

    }
    response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid);
    return;
}

//修改
if(method.equals("edit"))
{
	String name=Util.null2String(fu.getParameter("name"));
	String caller=Util.null2String(fu.getParameter("caller"));
	String contacter=Util.null2String(fu.getParameter("contacter"));
	String address=Util.null2String(fu.getParameter("address"));
	String begindate=Util.null2String(fu.getParameter("begindate"));
	String begintime=Util.null2String(fu.getParameter("begintime"));
	String enddate=Util.null2String(fu.getParameter("enddate"));
	String endtime=Util.null2String(fu.getParameter("endtime"));
	String desc=Util.spacetoHtml(Util.null2String(fu.getParameter("desc")));
	String projectid=Util.null2String(fu.getParameter("projectid"));//获得项目id
	String totalmember=Util.null2String(fu.getParameter("totalmember"));
	String othermembers=Util.fromScreen(fu.getParameter("othermembers"),user.getLanguage());
	String addressdesc=Util.fromScreen(fu.getParameter("addressdesc"),user.getLanguage());
	String customizeAddress = Util.null2String(fu.getParameter("customizeAddress"));
	String description=Util.null2String(fu.getParameter("description"));
	int remindBeforeStart = Util.getIntValue(fu.getParameter("remindBeforeStart"),0);  //是否开始前提醒
	int remindBeforeEnd = Util.getIntValue(fu.getParameter("remindBeforeEnd"),0);  //是否结束前提醒
	int remindType = Util.getIntValue(fu.getParameter("remindType"),0);  //提醒方式
    int remindTimesBeforeStart = Util.getIntValue(fu.getParameter("remindDateBeforeStart"),0)*60+Util.getIntValue(Util.null2String(fu.getParameter("remindTimeBeforeStart")),0);  //开始前提醒时间
    int remindTimesBeforeEnd = Util.getIntValue(fu.getParameter("remindDateBeforeEnd"),0)*60+Util.getIntValue(Util.null2String(fu.getParameter("remindTimeBeforeEnd")),0);  //结束前提醒时间
    description = "您有会议: "+name+"   会议时间:"+begindate+" "+begintime+" 会议地点:"+MeetingRoomComInfo.getMeetingRoomInfoname(""+address)+customizeAddress;
	ProcPara +=  meetingid;
	ProcPara += flag + name;
	ProcPara += flag + caller;
	ProcPara += flag + contacter;
	ProcPara += flag + projectid;	//加入修改字段
	ProcPara += flag + address;
	ProcPara += flag + begindate;
	ProcPara += flag + begintime;
	ProcPara += flag + enddate;
	ProcPara += flag + endtime;
	ProcPara += flag + desc;
    ProcPara += flag + totalmember;
    ProcPara += flag + othermembers;
    ProcPara += flag + addressdesc;
    ProcPara += flag + description;
    ProcPara += flag + ""+remindType;
    ProcPara += flag + ""+remindBeforeStart;
    ProcPara += flag + ""+remindBeforeEnd;
    ProcPara += flag + ""+remindTimesBeforeStart;
    ProcPara += flag + ""+remindTimesBeforeEnd;
    ProcPara += flag + customizeAddress;
    
	RecordSet.executeProc("Meeting_Update",ProcPara);


 
	//删除会议人员
	RecordSet.executeProc("Meeting_Member2_Delete",meetingid);
		
	//删除会议中相关的标识是否查看的信息
	StringBuffer stringBuffer = new StringBuffer();
	stringBuffer.append("DELETE FROM Meeting_View_Status WHERE meetingId = ");
	stringBuffer.append(meetingid);
	RecordSet.executeSql(stringBuffer.toString());
	

	String[] hrmids01=fu.getParameterValues("hrmids01");
	String hrmids02=Util.null2String(fu.getParameter("hrmids02"));
	ArrayList arrayhrmids02 = Util.TokenizerString(hrmids02,",");
	if(hrmids01!=null){
		for(int i=0;i<hrmids01.length;i++){
			if(arrayhrmids02.indexOf(hrmids01[i]) == -1) arrayhrmids02.add(hrmids01[i]);
		}
	}
	for(int i=0;i<arrayhrmids02.size();i++){
		ProcPara =  meetingid;
		ProcPara += flag + "1";
		ProcPara += flag + "" + arrayhrmids02.get(i);
		ProcPara += flag + "" + arrayhrmids02.get(i);
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
		
		//标识会议是否查看过
		stringBuffer = new StringBuffer();
		stringBuffer.append("INSERT INTO Meeting_View_Status(meetingId, userId, userType, status) VALUES(");
		stringBuffer.append(meetingid);
		stringBuffer.append(", ");
		stringBuffer.append(arrayhrmids02.get(i));
		stringBuffer.append(", '");
		stringBuffer.append("1");
		stringBuffer.append("', '");
		if(CurrentUser.equals(arrayhrmids02.get(i)))
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

	String[] crmids01=fu.getParameterValues("crmids01");
	String crmids02=Util.null2String(fu.getParameter("crmids02"));
	ArrayList arraycrmids02 = Util.TokenizerString(crmids02,",");
	if(crmids01!=null){
		for(int i=0;i<crmids01.length;i++){
			if(arraycrmids02.indexOf(crmids01[i]) == -1) arraycrmids02.add(crmids01[i]);
		}
	}
	for(int i=0;i<arraycrmids02.size();i++){
		String membermanager="";
		RecordSet.executeProc("CRM_CustomerInfo_SelectByID",""+arraycrmids02.get(i));
		if(RecordSet.next()) membermanager=RecordSet.getString("manager");
		ProcPara =  meetingid;
		ProcPara += flag + "2";
		ProcPara += flag + "" + arraycrmids02.get(i);
		ProcPara += flag + membermanager;
		RecordSet.executeProc("Meeting_Member2_Insert",ProcPara);
	}

	int topicrows=Util.getIntValue(Util.null2String(fu.getParameter("topicrows")),0);
	String recordsetids="";
	for(int i=0;i<topicrows;i++){
		String recordsetid=Util.null2String(fu.getParameter("recordsetid_"+i));
		if(!recordsetid.equals("")) recordsetids+=","+recordsetid;
	}
	if(!recordsetids.equals("")){
		recordsetids=recordsetids.substring(1);
		Sql = "delete from Meeting_Topic WHERE ( meetingid = "+meetingid+" and id not in ("+recordsetids+"))";
		RecordSet.executeSql(Sql);
	}else{
		Sql = "delete from Meeting_Topic WHERE ( meetingid = "+meetingid+")";
		RecordSet.executeSql(Sql);
	}
	for(int i=0;i<topicrows;i++){
		String recordsetid=Util.null2String(fu.getParameter("recordsetid_"+i));
		String topicsubject=Util.null2String(fu.getParameter("topicsubject_"+i));
		String topichrmids=Util.null2String(fu.getParameter("topichrmids_"+i));
		String topicopen=Util.null2String(fu.getParameter("topicopen_"+i));
		String topicprojid=Util.null2String(fu.getParameter("topicprojid_"+i));
		String topiccrmid=Util.null2String(fu.getParameter("topiccrmid_"+i));

		if(!recordsetid.equals("")){
			if(!topicsubject.equals("")){
				ProcPara =  recordsetid;
				ProcPara += flag + "0";
				ProcPara += flag + topicsubject;
				ProcPara += flag + topichrmids;
				ProcPara += flag + topicprojid;
				ProcPara += flag + topiccrmid;
				ProcPara += flag + topicopen;
				RecordSet.executeProc("Meeting_Topic_Update",ProcPara);
			}
		}else if(!topicsubject.equals("")){
				ProcPara =  meetingid;
				ProcPara += flag + "0";
				ProcPara += flag + topicsubject;
				ProcPara += flag + topichrmids;
				ProcPara += flag + topicprojid;
				ProcPara += flag + topiccrmid;
				ProcPara += flag + topicopen;
				RecordSet.executeProc("Meeting_Topic_Insert",ProcPara);
		}
	}

	RecordSet.executeProc("Meeting_Service2_Delete",meetingid);

	int servicerows=Util.getIntValue(Util.null2String(fu.getParameter("servicerows")),0);
	for(int i=0;i<servicerows;i++){
		String servicename=Util.null2String(fu.getParameter("servicename_"+i));
		String servicehrm=Util.null2String(fu.getParameter("servicehrm_"+i));
		String[] serviceitem=fu.getParameterValues("serviceitem_"+i);
		String serviceother=Util.null2String(fu.getParameter("serviceother_"+i));
		String servicedesc="";
		if(serviceitem != null){
			for(int j=0;j<serviceitem.length;j++){
				//String newId = new String(serviceitem[j].getBytes("iso-8859-1"),"GBK"); 
				//String sql = "select desc_n from Meeting_Service where id = '"+newId+"' ";
				//RecordSet3.executeSql(sql);
				//RecordSet3.next();
				//String desc_n = RecordSet3.getString("desc_n");
				//servicedesc +=  "," + desc_n;
				String serviceitemValue = new String(serviceitem[j].getBytes("iso-8859-1"),"GBK"); 
				servicedesc += "," + serviceitemValue;
			}
		}
		if(!servicedesc.equals("")){
			servicedesc = servicedesc.substring(1);
			if(!serviceother.equals("")){
				servicedesc += "," + serviceother;
			}
		}else{
				servicedesc +=  serviceother;
		}
		if(!servicename.equals("")&&!servicedesc.equals("")){
			ProcPara =  meetingid;
			ProcPara += flag + servicehrm;
			ProcPara += flag + servicename;
			ProcPara += flag + servicedesc;
			RecordSet.executeProc("Meeting_Service2_Insert",ProcPara);
		}
	}

    MeetingViewer.setMeetingShareById(meetingid);
	MeetingComInfo.removeMeetingInfoCache();
	editAccessory(fu,user,meetingid,RecordSet);


	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+meetingid);
	return;
}

if(method.equals("delete"))
{
    RecordSet.executeSql("select requestid From meeting where id="+meetingid);
    int requestid=0;
    if(RecordSet.next()){
       requestid=Integer.valueOf(Util.null2String(RecordSet.getString("requestid"))).intValue();
    }
    RecordSet.executeProc("Meeting_Delete",meetingid);

	RecordSet.executeProc("Meeting_Member2_Delete",meetingid);

	RecordSet.executeProc("Meeting_Topic_Delete",meetingid);

	RecordSet.executeProc("Meeting_Service2_Delete",meetingid);

    RecordSet.executeProc("MeetingShareDetail_DById",meetingid);
    RecordSet.executeSql("delete From Bill_Meeting where approveid="+meetingid);
    if(requestid>0){
        RecordSet.executeSql("delete From workflow_currentoperator where requestid="+requestid);
    }
    MeetingComInfo.removeMeetingInfoCache();
	response.sendRedirect("/meeting/data/AddMeeting.jsp");
	return;
}

//提交会议，此部分对于现在通过流程来审批会议已经无用处！ by charoes Huang ,July 23,2004
if(method.equals("submitapprove"))
{
	String approver="";
	RecordSet.executeProc("Meeting_Type_SelectByID",meetingtype);
	if(RecordSet.next()){
		approver=RecordSet.getString("approver");
	}

	if(!approver.equals("0") && !approver.equals("") && !approver.equals(CurrentUser)){
		RecordSet.executeProc("Meeting_Submit",meetingid);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String contacter=RecordSet.getString("contacter");
		String SWFTitle=Util.toScreen("会议申请:",user.getLanguage(),"0"); //文字
		SWFTitle += RecordSet.getString("name");
		SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
		SWFTitle += "-"+CurrentDate;
		String SWFRemark="";
		SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(CurrentUser),approver,SWFRemark);
	}else{
	    RecordSet.executeProc("Meeting_Submit",meetingid);
        ProcPara =  meetingid;
		ProcPara += flag + CurrentUser;
		ProcPara += flag + CurrentDate;
		ProcPara += flag + CurrentTime;
		RecordSet.executeProc("Meeting_Approve",ProcPara);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String name=RecordSet.getString("name");
		String caller=RecordSet.getString("caller");
		String contacter=RecordSet.getString("contacter");
		approver=RecordSet.getString("approver");
		String address=RecordSet.getString("address");
		String begindate=RecordSet.getString("begindate");
		String begintime=RecordSet.getString("begintime");
		String enddate=RecordSet.getString("enddate");
		String endtime=RecordSet.getString("endtime");
		String desc=RecordSet.getString("desc_n");

		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

		/*查询会议室管理员,并发出通知*/
		String roommanager="" ;
		RecordSet.executeSql("select resourceid from hrmrolemembers where roleid=11") ;
		while(RecordSet.next()){
		    roommanager+=","+ RecordSet.getString(1);
		}
		if(!roommanager.equals(""))
        {
            roommanager=roommanager.substring(1);
            SWFTitle=Util.toScreen("会议室调配:",user.getLanguage(),"0");
            SWFTitle += name;
            SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
            SWFTitle += "-"+CurrentDate;
            SWFRemark="";
            SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(CurrentUser),roommanager,SWFRemark);
        }
	    /* end */

		//会议通知
		SWFAccepter="";
		SWFSubmiter="";
		RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
		//Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
		//RecordSet.executeSql(Sql);
		while(RecordSet.next()){
			if(!RecordSet.getString("memberid").equals(caller) && !RecordSet.getString("memberid").equals(contacter) && !RecordSet.getString("memberid").equals(approver) ){
			SWFAccepter+=","+RecordSet.getString("memberid");
			}
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		SWFAccepter="";
		Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
		RecordSet.executeSql(Sql);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

	}
	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?meetingid="+meetingid);
	return;
}

//点批准后的操作，是做什么用的？
if(method.equals("approve"))
{
		ProcPara =  meetingid;
		ProcPara += flag + CurrentUser;
		ProcPara += flag + CurrentDate;
		ProcPara += flag + CurrentTime;
		RecordSet.executeProc("Meeting_Approve",ProcPara);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String name=RecordSet.getString("name");
		String caller=RecordSet.getString("caller");
		String contacter=RecordSet.getString("contacter");
		String approver=RecordSet.getString("approver");
		String address=RecordSet.getString("address");
		String begindate=RecordSet.getString("begindate");
		String begintime=RecordSet.getString("begintime");
		String enddate=RecordSet.getString("enddate");
		String endtime=RecordSet.getString("endtime");
		String desc=RecordSet.getString("desc_n");

		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

		if(!approver.equals(caller) && !approver.equals(contacter)){
    		SWFTitle=Util.toScreen("会议批准:",user.getLanguage(),"0");  //文字
    		SWFTitle += name;
    		SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
    		SWFTitle += "-"+CurrentDate;
    		SWFRemark="";
    		SWFSubmiter=approver;
    		SWFAccepter=caller+","+contacter;
    		SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		/*查询会议室管理员,并发出通知*/
		String roommanager="" ;
		RecordSet.executeSql("select resourceid from hrmrolemembers where roleid=11") ;
		while(RecordSet.next()){
		    roommanager+=","+ RecordSet.getString(1);
		}
		if(!roommanager.equals(""))
        {
            roommanager=roommanager.substring(1);
            RecordSet.executeProc("Meeting_SelectByID",meetingid);
            RecordSet.next();
            SWFTitle=Util.toScreen("会议室调配:",user.getLanguage(),"0"); //文字
            SWFTitle += RecordSet.getString("name");
            SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
            SWFTitle += "-"+CurrentDate;
            SWFRemark="";
            SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(CurrentUser),roommanager,SWFRemark);
        }
	    /* end */

		//会议通知
		SWFAccepter="";
		//Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
		//RecordSet.executeSql(Sql);
		RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
		while(RecordSet.next()){
			if(!RecordSet.getString("memberid").equals(caller) && !RecordSet.getString("memberid").equals(contacter) && !RecordSet.getString("memberid").equals(approver) ){
			SWFAccepter+=","+RecordSet.getString("memberid");
			}
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		SWFAccepter="";
		Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
		RecordSet.executeSql(Sql);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		//会议查看权限？
        MeetingViewer.setMeetingShareById(meetingid);

	response.sendRedirect("/meeting/data/ProcessMeeting.jsp?meetingid="+meetingid);
	return;
}

if(method.equals("schedule"))
{
		String address1=Util.fromScreen(fu.getParameter("address"),user.getLanguage()) ;
		String begindate1=Util.fromScreen(fu.getParameter("begindate"),user.getLanguage()) ;
		String begintime1=Util.fromScreen(fu.getParameter("begintime"),user.getLanguage()) ;
		String enddate1=Util.fromScreen(fu.getParameter("enddate"),user.getLanguage()) ;
		String endtime1=Util.fromScreen(fu.getParameter("endtime"),user.getLanguage()) ;
		enddate1=begindate1 ;
		String updatesql="update meeting set address="+address1+",begindate='"+begindate1+"',begintime='"+begintime1+
		                "',enddate='"+enddate1+"',endtime='"+endtime1+"' where id="+meetingid ;
		RecordSet.executeSql(updatesql) ;

		RecordSet.executeProc("Meeting_Schedule",meetingid);

		RecordSet.executeProc("Meeting_SelectByID",meetingid);
		RecordSet.next();
		String name=RecordSet.getString("name");
		String caller=RecordSet.getString("caller");
		String contacter=RecordSet.getString("contacter");
		String approver=RecordSet.getString("approver");
		String address=RecordSet.getString("address");
		String begindate=RecordSet.getString("begindate");
		String begintime=RecordSet.getString("begintime");
		String enddate=RecordSet.getString("enddate");
		String endtime=RecordSet.getString("endtime");
		String desc=RecordSet.getString("desc_n");

		String SWFTitle="";
		String SWFRemark="";
		String SWFSubmiter="";
		String SWFAccepter="";

		SWFAccepter="";
		//Sql="select distinct membermanager from Meeting_Member2 where meetingid="+meetingid;
		//RecordSet.executeSql(Sql);
		RecordSet.executeProc("Meeting_Member2_SelectByType",meetingid+flag+"1");
		while(RecordSet.next()){
			if(!RecordSet.getString("memberid").equals(caller) && !RecordSet.getString("memberid").equals(contacter) && !RecordSet.getString("memberid").equals(approver) ){
			SWFAccepter+=","+RecordSet.getString("memberid");
			}
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议通知:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

		SWFAccepter="";
		Sql="select distinct hrmid from Meeting_Service2 where meetingid="+meetingid;
		RecordSet.executeSql(Sql);
		while(RecordSet.next()){
			SWFAccepter+=","+RecordSet.getString(1);
		}
		if(!SWFAccepter.equals("")){
			SWFAccepter=SWFAccepter.substring(1);
			SWFTitle=Util.toScreen("会议服务:",user.getLanguage(),"0"); //文字
			SWFTitle += name;
			SWFTitle += "-"+ResourceComInfo.getResourcename(contacter);
			SWFTitle += "-"+CurrentDate;
			SWFRemark="";
			SWFSubmiter=contacter;
			SysRemindWorkflow.setMeetingSysRemind(SWFTitle,Util.getIntValue(meetingid),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
		}

	response.sendRedirect("/meeting/report/MeetingRoomPlan.jsp");
	return;
}

//取消会议
if(method.equals("cancelMeeting"))
{
	String meetingId = fu.getParameter("meetingId");
	String userId = "" + user.getUID();
	int meetingStatus = -1;
    
	String forwardFlag = Util.null2String(fu.getParameter("forward"));
	//会议详细中右键的取消会议后跳转界面
	String forward = "/meeting/data/NewMeetings.jsp";
	//会议室报表中的会议取消，跳转界面
	if(!"".equals(forwardFlag) && !"null".equals(forwardFlag)){
	     forward = "/meeting/report/MeetingRoomPlan.jsp";
	}
	
	//会议取消，触发系统提醒工作流
	String MeetingName="";
	String MeetingDate="";
	String MeetingContacter="";
	RecordSet.executeSql("select * from meeting where id = '"+meetingId+"'");
	while(RecordSet.next()){
	   MeetingName=RecordSet.getString("name");
	   MeetingDate=RecordSet.getString("begindate");
	   MeetingContacter=RecordSet.getString("contacter");
	   meetingStatus = RecordSet.getInt("meetingStatus");	   
	}
	
	String wfname="";
	String wfaccepter="";
	String wfremark="";
	
	wfname=SystemEnv.getHtmlLabelName(23269,user.getLanguage())+"："+MeetingName+"-"+ResourceComInfo.getLastname(user.getUID()+"")+"-"+CurrentDate;
	
	RecordSet.executeProc("Meeting_Member2_SelectByType",meetingId+flag+"1");
	//RecordSet.executeSql("select membermanager from Meeting_Member2 where meetingid = '"+meetingId+"'");
	while(RecordSet.next()){
	   wfaccepter+=","+RecordSet.getString("memberid");
	}
	if(!"".equals(wfaccepter)){
		wfaccepter=wfaccepter.substring(1);
	}
	
	if(1!=meetingStatus){
	    SysRemindWorkflow.setMeetingSysRemind(wfname,Util.getIntValue(meetingId),Util.getIntValue(MeetingContacter),wfaccepter,wfremark);
	}
	
	//更新状态
	RecordSet.executeSql("SELECT * FROM Meeting WHERE id = " + meetingId + " AND caller = " + userId + " AND (meetingStatus = 1 OR meetingStatus = 2)");	
	boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
	if(RecordSet.next()  || cancelRight)
	{
		meetingStatus = RecordSet.getInt("meetingStatus");
		//RecordSetDB.executeSql("UPDATE Meeting SET meetingStatus = 4 WHERE id = " + meetingId);
		Calendar today = Calendar.getInstance();
		String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
        String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2); 
        RecordSetDB.executeSql("update meeting set cancel='1',meetingStatus=4,canceldate='"+nowdate+"',canceltime='"+nowtime+"' where id="+meetingId);
		//标识会议已经被取消
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("UPDATE Meeting_View_Status SET status = '2'");		
		stringBuffer.append(" WHERE meetingId = ");
		stringBuffer.append(meetingId);
		stringBuffer.append(" AND userId <> ");
		stringBuffer.append(CurrentUser);
		
		RecordSetDB.executeSql(stringBuffer.toString());
		
		/** Add By Hqf for TD9970 Start**/
		//表示当日计划已经被删除
		stringBuffer.setLength(0);	
		stringBuffer.append("DELETE FROM  WorkPlan ");
		stringBuffer.append(" WHERE meetingId = ");
		stringBuffer.append("'");
		stringBuffer.append(meetingId);
		stringBuffer.append("'");
		RecordSetDB.executeSql(stringBuffer.toString());
		/** Add By Hqf for TD9970 End**/
	}

	//待审批则删除相关流程
	if(1 == meetingStatus)
	{	
		int requestId = 0;	
 		RecordSet.executeSql("SELECT requestId FROM Meeting WHERE id = " + meetingId);
    	if(RecordSet.next())
    	{
       		requestId = Integer.valueOf(Util.null2String(RecordSet.getString("requestId"))).intValue();
       	}
       	       	
		RecordSet.executeSql("DELETE FROM Bill_Meeting WHERE approveId = " + meetingId);
    	if(requestId > 0)
    	{
        	RecordSet.executeSql("DELETE FROM WorkFlow_CurrentOperator WHERE requestId = " + requestId);
    	}
	
	}


	response.sendRedirect(forward);
	return;
}
%>