<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ include file="/systeminfo/init.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.Writer" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.Constants" %>
<%@ page import="weaver.domain.workplan.WorkPlan" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="java.math.BigDecimal" %>

<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.docs.docs.DocExtUtil" %>

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="ProjTempletUtil" class="weaver.proj.Templet.ProjTempletUtil" scope="page" />
<jsp:useBean id="workPlanService" class="weaver.WorkPlan.WorkPlanService" scope="page"/>
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ProjectAccesory" class="weaver.proj.ProjectAccesory" scope="page" />
<jsp:useBean id="ProjectInfo" class="weaver.proj.ProjectInfo" scope="page" />

<%
FileUpload fu = new FileUpload(request);
int accessorynum = Util.getIntValue(fu.getParameter("accessory_num"),0);
int deleteField_idnum = Util.getIntValue(fu.getParameter("field_idnum"),0);

char flag = 2;
String ProcPara = "";
String strTemp = "";
String CurrentUser = ""+user.getUID();
String SubmiterType = ""+user.getLogintype();
String ClientIP = fu.getRemoteAddr();

String[] logParams;
WorkPlanLogMan logMan = new WorkPlanLogMan();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(fu.getParameter("method"));

String Remark=Util.fromScreen(fu.getParameter("Remark"),user.getLanguage());
String RemarkDoc=Util.fromScreen(fu.getParameter("RemarkDoc"),user.getLanguage());

String ProjID = Util.null2String(fu.getParameter("ProjID"));
String Members=Util.null2String(fu.getParameter("hrmids02"));/*项目成员*/
if(ProjID.equals("")) ProjID = "0";
boolean canRemind = false;//是否需要出发提醒工作流
rs2.executeProc("Prj_TaskInfo_SelectMaxVersion",""+ProjID);
if(rs2.next()) canRemind = true;

/*项目状态为完成和冻结的时候不能编辑*/
if(!ProjID.equals("")){
	String sql_tatus="select isactived from Prj_TaskProcess where prjid="+ProjID;
	RecordSet.executeSql(sql_tatus);
	RecordSet.next();
	String isactived=RecordSet.getString("isactived");
	//isactived=0,为计划
	//isactived=1,为提交计划
	//isactived=2,为批准计划

	String sql_prjstatus="select status from Prj_ProjectInfo where id = "+ProjID;
	RecordSet.executeSql(sql_prjstatus);
	RecordSet.next();
	String status_prj=RecordSet.getString("status");
	if(isactived.equals("2")&&(status_prj.equals("3")||status_prj.equals("4"))){//项目冻结或者项目完成
		response.sendRedirect("ViewProject.jsp?ProjID="+ProjID);
		return;
	}
}
if(method.equals("Jianbao"))
{
	ProcPara = ProjID;
	ProcPara += flag+"1";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("Prj_Jianbao_Insert",ProcPara);

	if(!RemarkDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+RemarkDoc;
		RecordSet.executeSql(tempsql);	
	}

	response.sendRedirect("/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID);
	return;
}

/*2003-4-22*/
String muticontract=Util.null2String(fu.getParameter("muticontract"));



String PrjName=Util.fromScreen(fu.getParameter("PrjName"),user.getLanguage());
String PrjDesc=Util.fromScreen(fu.getParameter("PrjDesc"),user.getLanguage());
String PrjType=Util.fromScreen(fu.getParameter("PrjType"),user.getLanguage());
String WorkType=Util.fromScreen(fu.getParameter("WorkType"),user.getLanguage());
String SecuLevel=Util.fromScreen(fu.getParameter("SecuLevel"),user.getLanguage());
String PrjStatus=fu.getParameter("status");
String MemberOnly=Util.fromScreen(fu.getParameter("MemberOnly"),user.getLanguage());
if(MemberOnly.equals("")) MemberOnly = "0";
String ManagerView=Util.fromScreen(fu.getParameter("ManagerView"),user.getLanguage());
if(ManagerView.equals("")) ManagerView = "0";
String ParentView=Util.fromScreen(fu.getParameter("ParentView"),user.getLanguage());
if(ParentView.equals("")) ParentView = "0";
String MoneyP=Util.fromScreen(fu.getParameter("MoneyP"),user.getLanguage());
String MoneyT=Util.fromScreen(fu.getParameter("MoneyT"),user.getLanguage());
String IncomeP=Util.fromScreen(fu.getParameter("IncomeP"),user.getLanguage());
String IncomeT=Util.fromScreen(fu.getParameter("IncomeT"),user.getLanguage());
String BDateP=Util.null2String(fu.getParameter("BDateP"));
String BTimeP=Util.null2String(fu.getParameter("BTimeP"));
String EDateP=Util.null2String(fu.getParameter("EDateP"));
String ETimeP=Util.null2String(fu.getParameter("ETimeP"));
String BDateT=Util.null2String(fu.getParameter("BDateT"));
String BTimeT=Util.null2String(fu.getParameter("BTimeT"));
String EDateT=Util.null2String(fu.getParameter("EDateT"));
String ETimeT=Util.null2String(fu.getParameter("ETimeT"));
String LabourP=Util.fromScreen(fu.getParameter("LabourP"),user.getLanguage());
String LabourT=Util.fromScreen(fu.getParameter("LabourT"),user.getLanguage());
String Photo=Util.fromScreen(fu.getParameter("Photo"),user.getLanguage());
if(Photo.equals("")) Photo = "0";
String PrjInfo=Util.fromScreen(fu.getParameter("PrjInfo"),user.getLanguage());
String ParentID=Util.fromScreen(fu.getParameter("ParentID"),user.getLanguage());
String EnvDoc=Util.fromScreen(fu.getParameter("EnvDoc"),user.getLanguage());
String ConDoc=Util.fromScreen(fu.getParameter("ConDoc"),user.getLanguage());
String ProDoc=Util.fromScreen(fu.getParameter("ProDoc"),user.getLanguage());
String PrjManager=Util.fromScreen(fu.getParameter("PrjManager"),user.getLanguage());
//根据经理选部门
String PrjDept=ResourceComInfo.getDepartmentID(PrjManager);
String Subcompanyid1=DepartmentComInfo.getSubcompanyid1(PrjDept);

String dff01=Util.null2String(fu.getParameter("dff01"));
String dff02=Util.null2String(fu.getParameter("dff02"));
String dff03=Util.null2String(fu.getParameter("dff03"));
String dff04=Util.null2String(fu.getParameter("dff04"));
String dff05=Util.null2String(fu.getParameter("dff05"));

String nff01=Util.null2String(fu.getParameter("nff01"));
if(nff01.equals("")) nff01="0.0";
String nff02=Util.null2String(fu.getParameter("nff02"));
if(nff02.equals("")) nff02="0.0";
String nff03=Util.null2String(fu.getParameter("nff03"));
if(nff03.equals("")) nff03="0.0";
String nff04=Util.null2String(fu.getParameter("nff04"));
if(nff04.equals("")) nff04="0.0";
String nff05=Util.null2String(fu.getParameter("nff05"));
if(nff05.equals("")) nff05="0.0";

String tff01=Util.fromScreen(fu.getParameter("tff01"),user.getLanguage());
String tff02=Util.fromScreen(fu.getParameter("tff02"),user.getLanguage());
String tff03=Util.fromScreen(fu.getParameter("tff03"),user.getLanguage());
String tff04=Util.fromScreen(fu.getParameter("tff04"),user.getLanguage());
String tff05=Util.fromScreen(fu.getParameter("tff05"),user.getLanguage());

String bff01=Util.null2String(fu.getParameter("bff01"));
if(bff01.equals("")) bff01="0";
String bff02=Util.null2String(fu.getParameter("bff02"));
if(bff02.equals("")) bff02="0";
String bff03=Util.null2String(fu.getParameter("bff03"));
if(bff03.equals("")) bff03="0";
String bff04=Util.null2String(fu.getParameter("bff04"));
if(bff04.equals("")) bff04="0";
String bff05=Util.null2String(fu.getParameter("bff05"));
if(bff05.equals("")) bff05="0";


String proCode = Util.null2String(fu.getParameter("PrjCode"));    //项目编号
int proTemplateId = Util.getIntValue(fu.getParameter("prjTemplet"),0);    //项目模板ID

//---------任务自定义字段

//=======================================================================
//TD5130 获取RelationXML中所有的TaskID
//added by hubo, 2006-10-13
String taskRecordIds = Util.null2String(fu.getParameter("taskRecordIds"));
if(taskRecordIds.startsWith(",")){
	taskRecordIds = taskRecordIds.substring(1,taskRecordIds.length());	
}
if(taskRecordIds.endsWith(",")){
	taskRecordIds = taskRecordIds.substring(0,taskRecordIds.length()-1);	
}
//=======================================================================


String[] rowIndexs = fu.getParameterValues("txtRowIndex");   //任务名称
String[] taskNames = fu.getParameterValues("txtTaskName");   //任务名称
String[] workLongs = fu.getParameterValues("txtWorkLong");   //工期
String[] beginDates = fu.getParameterValues("txtBeginDate");  //开始时间
String[] endDates = fu.getParameterValues("txtEndDate");     //结束时间
String[] beforeTasks = fu.getParameterValues("seleBeforeTask"); //前置任务
String[] budgets = fu.getParameterValues("txtBudget");         //预算
String[] managers = fu.getParameterValues("txtManager");       //负责人

String[] taskTempletIDs = fu.getParameterValues("templetTaskId");	//任务模板ID
int currentTaskID = 0;																//当前任务ID
String sqlInsTaskRelatedInfo = "";

String linkXml=Util.null2String(fu.getParameter("areaLinkXml"));  //上下级关系的字符串

//TD6879 2007-7-11
if("".equals(PrjType)){
	PrjType = ProjectInfoComInfo.getProjectInfoprjtype(ProjID);
}
//====================================
//TD6720
//2007-5-31
String insertWorkPlan = "";
RecordSet.executeSql("SELECT insertWorkPlan FROM Prj_ProjectType WHERE id="+PrjType+"");
if(RecordSet.next()){
	insertWorkPlan = RecordSet.getString("insertWorkPlan");
}
//====================================
if(method.equals("add")){
	ProjectInfo.setBff01(bff01);
	ProjectInfo.setBff02(bff02);
	ProjectInfo.setBff03(bff03);
	ProjectInfo.setBff04(bff04);
	ProjectInfo.setBff05(bff05);
	ProjectInfo.setTff01(tff01);
	ProjectInfo.setTff02(tff02);
	ProjectInfo.setTff03(tff03);
	ProjectInfo.setTff04(tff04);
	ProjectInfo.setTff05(tff05);
	ProjectInfo.setNff01(nff01);
	ProjectInfo.setNff02(nff02);
	ProjectInfo.setNff03(nff03);
	ProjectInfo.setNff04(nff04);
	ProjectInfo.setNff05(nff05);
	ProjectInfo.setDff01(dff01);
	ProjectInfo.setDff02(dff02);
	ProjectInfo.setDff03(dff03);
	ProjectInfo.setDff04(dff04);
	ProjectInfo.setDff05(dff05);
	ProjectInfo.setLinkXml(linkXml);
	ProjectInfo.setProTemplateId(proTemplateId);
	ProjectInfo.setProCode(proCode);
	ProjectInfo.setPrjName(PrjName);
	ProjectInfo.setPrjDesc(PrjDesc);
	ProjectInfo.setPrjType(PrjType);
	ProjectInfo.setWorkType(WorkType);
	ProjectInfo.setSecuLevel(SecuLevel);
	ProjectInfo.setMemberOnly(MemberOnly);
	ProjectInfo.setManagerView(ManagerView);
	ProjectInfo.setParentView(ParentView);
	/*ProjectInfo.setMoneyP(MoneyP);
	ProjectInfo.setMoneyT(MoneyT);
	ProjectInfo.setIncomeP(IncomeP);
	ProjectInfo.setIncomeT(IncomeT);
	*/
	/*TD46699 由于以上四列数据库类型为money型，在插入时需要转化数据类型。不然SQL 2000 数据库会报错，改用存储过程更新*/
	
	ProjectInfo.setBDateP(BDateP);
	ProjectInfo.setBTimeP(BTimeP);
	ProjectInfo.setEDateP(EDateP);
	ProjectInfo.setETimeP(ETimeP);
	ProjectInfo.setBDateT(BDateT);
	ProjectInfo.setBTimeT(BTimeT);
	ProjectInfo.setEDateT(EDateT);
	ProjectInfo.setETimeT(ETimeT);
	ProjectInfo.setLabourP(LabourP);
	ProjectInfo.setLabourT(LabourT);
	ProjectInfo.setPhoto(Photo);
	ProjectInfo.setPrjInfo(PrjInfo);
	ProjectInfo.setParentID(ParentID);
	ProjectInfo.setEnvDoc(EnvDoc);
	ProjectInfo.setConDoc(ConDoc);
	ProjectInfo.setProDoc(ProDoc);
	ProjectInfo.setPrjManager(PrjManager);
	ProjectInfo.setPrjDept(PrjDept);
	ProjectInfo.setSubcompanyid1(Subcompanyid1);
	ProjectInfo.setCurrentUser(CurrentUser);
	ProjectInfo.setCurrentDate(CurrentDate);
	ProjectInfo.setCurrentTime(CurrentTime);
	ProjectInfo.addPrjInfo();

	RecordSet.executeProc("Prj_ProjectInfo_InsertID","");
	RecordSet.first();
	ProjID = RecordSet.getString(1);
	
	/*TD46699 在插入结束后，用存储过程更新 Money类型字段值*/
	ProcPara = ProjID;
	ProcPara += flag+MoneyP;
	ProcPara += flag+MoneyT;
	ProcPara += flag+IncomeP;
	ProcPara += flag+IncomeT;
	RecordSet.executeProc("Prj_ProjectInfo_UpdateForMoney",ProcPara);
	/*TD46699  End*/
	
  //修改项目编码 开始
  CodeBuild cbuild = new CodeBuild(1);
  String projectCode = cbuild.getProjCodeStr(ProjID,PrjDesc,PrjType,WorkType);
  RecordSet.execute("update Prj_ProjectInfo set procode='"+projectCode+"' where id="+ProjID);  
  //修改项目编码 结束

  RecordSet.executeProc("Prj_ProjectInfo_UConids",ProjID+flag+muticontract);

	ProcPara = ProjID;
	ProcPara += flag+"n";
	ProcPara += flag+RemarkDoc;
	ProcPara += flag+Remark;
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("Prj_Log_Insert",ProcPara);
	
    ProcPara = ProjID;
    ProcPara += flag+Members;
	RecordSet.executeProc("Proj_Members_update",ProcPara);

	ProjectInfoComInfo.removeProjectInfoCache();
    
    RecordSet.executeProc("Prj_ShareInfo_Update",PrjType+flag+ProjID);
    //权限添加
	
    PrjViewer.setPrjShareByPrj(""+ProjID);

	if(!EnvDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+EnvDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ConDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ConDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ProDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ProDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!RemarkDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+RemarkDoc;
		RecordSet.executeSql(tempsql);	
	}

if(insertWorkPlan.equals("1")){
	//添加工作计划
	WorkPlan workPlan = new WorkPlan();
	
	workPlan.setCreaterId(Integer.parseInt(CurrentUser));
    workPlan.setCreateType(Integer.parseInt(SubmiterType));
    workPlan.setWorkPlanType(Integer.parseInt(Constants.WorkPlan_Type_ProjectCalendar));        
    workPlan.setWorkPlanName(PrjName);    
    workPlan.setUrgentLevel(Constants.WorkPlan_Urgent_Normal);
    workPlan.setRemindType(Constants.WorkPlan_Remind_No);  
    workPlan.setResourceId(PrjManager);
    workPlan.setBeginDate(CurrentDate);
    workPlan.setBeginTime(Constants.WorkPlan_StartTime);  //开始时间    
   
    workPlan.setDescription(Util.convertInput2DB(Util.null2String(fu.getParameter("PrjInfo"))));
    workPlan.setProject(ProjID);

    workPlanService.insertWorkPlan(workPlan);  //插入日程
	

    //插入日程日志
    logParams = new String[] {String.valueOf(workPlan.getWorkPlanID()), WorkPlanLogMan.TP_CREATE, CurrentUser, fu.getRemoteAddr()};
    logMan.writeViewLog(logParams);
}

   
    //========项目类型自定义字段开始=====    
    ProjTempletUtil.addProjTypeCDataReal(fu,ProjID);
    //========项目类型自定义字段结束=====

     //------任务的内容的插入
    if (rowIndexs!=null){
        for (int i=0 ;i<rowIndexs.length;i++){
            int rowIndex = Util.getIntValue(rowIndexs[i],0);
            String taskName =  new String(Util.null2String(taskNames[i]).getBytes("ISO8859_1") , "GBK");
            int workLong = Util.getIntValue(workLongs[i],0);
            String beginDate =  Util.null2String(beginDates[i]);
            String endDate =  Util.null2String(endDates[i]);
            int beforeTask = Util.getIntValue(beforeTasks[i],0);
            //float budget = Util.getFloatValue(budgets[i],0);
            String budget =  Util.null2String(budgets[i]);
            int manager =Util.getIntValue(managers[i],0);
    
    		  int taskTempletID = Util.getIntValue(taskTempletIDs[i],0);
    
    
            String parentid  = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);
            int level = ProjTempletUtil.getLevel(linkXml,rowIndex); 
            
           
            String taskid = "0" ;
            String wbscoding = "0" ;
            String version = "0" ;
    
            //以下这段东西需要修改 dongpign 现在只为测试用      

				//====================================================================================================================
				//TD3853,modified by hubo,2006-03-13
				String tempParentIds = "";
				String tempParentHrmIds = "";
				rs2.executeSql("SELECT parentids,parenthrmids FROM Prj_TaskProcess WHERE prjid="+ProjID+" AND taskIndex="+parentid+"");
				if (rs2.next()){
					tempParentIds = rs2.getString(1);
					tempParentHrmIds = rs2.getString(2);
				}
            String parentids = tempParentIds;
            String parenthrmids = tempParentHrmIds;
            //====================================================================================================================
    
    
            if ("".equals(taskName))  taskName=" ";
            if ("".equals(beginDate))  beginDate=" ";
            if ("".equals(endDate))  endDate=" ";
            if ("".equals(budget))  budget="0";
            ProcPara = "";
            ProcPara = ProjID ;
            ProcPara += flag + "" + taskid ;
            ProcPara += flag + "" + wbscoding ;
            ProcPara += flag + "" + taskName ;
            ProcPara += flag + "" + version ;
            ProcPara += flag + "" + beginDate ;
            ProcPara += flag + "" + endDate ;
            ProcPara += flag + "" + workLong ;
            ProcPara += flag + "" + " " ;
            ProcPara += flag + "" + budget ;
            ProcPara += flag + "" + parentid ;
            ProcPara += flag + "" + parentids ;
            ProcPara += flag + "" + parenthrmids ;
            ProcPara += flag + "" + level ;
            ProcPara += flag + "" + manager ;
            ProcPara += flag + "" + beforeTask ;
            ProcPara += flag + "" + "0" ; // real work days
            ProcPara += flag + "" + rowIndex ;  //记录真正的行号
    
            RecordSet.executeProc("Prj_TaskProcess_Insert",ProcPara);      
            //System.out.println(ProcPara);   
    		  currentTaskID = RecordSet.getFlag();
    
    		  //保存模板任务的所需文档
    		  sqlInsTaskRelatedInfo = "INSERT INTO Prj_task_needdoc (taskId,templetTaskId,docMainCategory,docSubCategory,docSecCategory,isNecessary,isTempletTask) SELECT "+currentTaskID+","+taskTempletID+",docMainCategory,docSubCategory,docSecCategory,isNecessary,1 FROM Prj_TempletTask_needdoc WHERE templetTaskId='"+taskTempletID+"'";
    		  RecordSet.executeSql(sqlInsTaskRelatedInfo);
    
    		  ////保存模板任务的参考文档
    		  sqlInsTaskRelatedInfo = "INSERT INTO Prj_task_referdoc (taskId,templetTaskId,docid,isTempletTask) SELECT "+currentTaskID+","+taskTempletID+",docid,1 FROM Prj_TempletTask_referdoc WHERE templetTaskId='"+taskTempletID+"'";
    		  RecordSet.executeSql(sqlInsTaskRelatedInfo);
    
    		  ////保存模板任务的所需工作流
    		  sqlInsTaskRelatedInfo = "INSERT INTO Prj_task_needwf (taskId,templetTaskId,workflowId,isNecessary,isTempletTask) SELECT "+currentTaskID+","+taskTempletID+",workflowId,isNecessary,1 FROM Prj_TempletTask_needwf WHERE templetTaskId='"+taskTempletID+"'";
    		  RecordSet.executeSql(sqlInsTaskRelatedInfo);
            
            RecordSet.executeSql("update Prj_TaskProcess set dsporder ="+i+" where prjid="+ProjID+" and taskIndex="+rowIndex);
        }
   
    }
    //修改父结点的值
    RecordSet.executeSql("select id,parentid from Prj_TaskProcess where prjid="+ProjID);
    while(RecordSet.next()){
        String id = RecordSet.getString("id");
        String parentid =  RecordSet.getString("parentid");
        
        rs.executeSql("select id from Prj_TaskProcess where prjid="+ProjID+" and taskIndex ="+parentid);
        if (rs.next()){
            String newId = rs.getString(1);
            rs1.executeSql("update Prj_TaskProcess set parentid ="+newId+" where id="+id );
        }
    }
    
    //附件上传开始
    String tempAccessory = "";
    if(accessorynum>0){
    	String[] uploadField=new String[accessorynum];
    	for(int i=0;i<accessorynum;i++){
    		uploadField[i]="accessory"+(i+1);
    	}
    	DocExtUtil mDocExtUtil=new DocExtUtil();
    	int[] returnarry = mDocExtUtil.uploadDocsToImgs(fu,user,uploadField);
    	if(returnarry != null){
    		for(int j=0;j<returnarry.length;j++){
    			if(returnarry[j] != -1){  										
   					tempAccessory += String.valueOf(returnarry[j])+",";
    			}
    		}
    	}
    	if(!"".equals(tempAccessory)) {
    		rs.executeSql("update Prj_ProjectInfo set accessory='"+tempAccessory+"' where id ="+ProjID);
    	}
    }
    //附件上传结束
    
    //给项目里面的相关附件赋查看权限开始
	String memberstmp = "";
    RecordSet.executeSql("select userid from PrjShareDetail where prjid="+ProjID);
	while(RecordSet.next()) {
        memberstmp += RecordSet.getString("userid")+",";
	}
	if(!"".equals(tempAccessory)) {
	   ProjectAccesory.addAccesoryShare(tempAccessory,memberstmp);
	}
	//给项目里面的相关附件赋查看权限结束

	response.sendRedirect("/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID);
	return;
}




String projStatus ="";
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if (RecordSet.next()){
   projStatus = RecordSet.getString("status");
}

if(method.equals("edit")){
	boolean bNeedUpdate = false;
	boolean bShareUpdate = false;    
    //String Members_d = RecordSet.getString("members");
	String Members_d=Util.null2String(fu.getParameter("members"));
    ArrayList Members01 = Util.TokenizerString(Members_d,",");
    int Member_length_01 = Members01.size();
    ArrayList Members02 = Util.TokenizerString(Members,",");
    int Member_length_02 = Members02.size();
    out.print(Member_length_01);
    boolean membercheck=false;
    
      if(Member_length_01<Member_length_02){
        for(int i=0;i<Member_length_02;i++){
            if(Members01.indexOf(Members02.get(i)) == -1){
                 membercheck=true;
        }
        }
      }
      if(Member_length_01>Member_length_02){
        for(int i=0;i<Member_length_01;i++){
            if(Members02.indexOf(Members01.get(i)) == -1){
                 membercheck=true;
        }
        }
      }
     
        if(membercheck){
                ProcPara = ProjID+flag+"m";
                ProcPara += flag+"members"+flag+CurrentDate+flag+CurrentTime+flag+Members_d+flag+Members;
                ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
                RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);   

                ProcPara =ProjID;
                ProcPara += flag +Members;
                RecordSetM.executeProc("Proj_Members_update",ProcPara);

        		bShareUpdate = true;
        }


    String contractids_d = RecordSet.getString("contractids");
    ArrayList contractids01 = Util.TokenizerString(contractids_d,",");
    int Con_length_01 = contractids01.size();
    ArrayList contractids02 = Util.TokenizerString(muticontract,",");
    int Con_length_02 = contractids02.size();
    
    boolean concheck=false;
    
      if(Con_length_01<Con_length_02){
        for(int i=0;i<Con_length_02;i++){
            if(contractids01.indexOf(contractids02.get(i)) == -1){
                 concheck=true;
        }
        }
      }
      if(Con_length_01>Con_length_02){
        for(int i=0;i<Con_length_01;i++){
            if(contractids02.indexOf(contractids01.get(i)) == -1){
                 concheck=true;
        }
        }
      }

    if(concheck){
            ProcPara = ProjID+flag+"m";
            ProcPara += flag+"contract"+flag+CurrentDate+flag+CurrentTime+flag+contractids_d+flag+muticontract;
            ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
            RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);   

            RecordSet.executeProc("Prj_ProjectInfo_UConids",ProjID+flag+muticontract);

    
    }


	strTemp = RecordSet.getString("name");
	if(!PrjName.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"name"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjName;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("description");
	if(!PrjDesc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"description"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjDesc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}

	strTemp = RecordSet.getString("prjtype");
	if(!PrjType.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"prjtype"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjType;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

    strTemp = RecordSet.getString("proCode");
	if(!proCode.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"proCode"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+proCode;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

    strTemp = RecordSet.getString("protemplateid");
	if(!strTemp.equals(""+proTemplateId))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"proTemplateId"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+""+proTemplateId;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("worktype");
	if(!WorkType.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"worktype"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+WorkType;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("securelevel");
	if(!SecuLevel.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"securelevel"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+SecuLevel;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("status");
	if(!PrjStatus.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"status"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjStatus;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("isblock");
	if(!MemberOnly.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"isblock"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+MemberOnly;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}


	strTemp = RecordSet.getString("managerview");
	if(!ManagerView.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"managerview"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ManagerView;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
        bShareUpdate = true;
	}


	strTemp = RecordSet.getString("picid");
	if(!Photo.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"picid"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+Photo;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("intro");
	if(!PrjInfo.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"intro"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjInfo;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("parentid");
	if(!ParentID.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"parentid"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ParentID;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("envaluedoc");
	if(!EnvDoc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"envaluedoc"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+EnvDoc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("confirmdoc");
	if(!ConDoc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"confirmdoc"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ConDoc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("proposedoc");
	if(!ProDoc.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"proposedoc"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+ProDoc;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("manager");
	if(!PrjManager.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"manager"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjManager;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
		
	}

	strTemp = RecordSet.getString("department");
	if(!PrjDept.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"department"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+PrjDept;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
		bShareUpdate = true;
	}

	strTemp = RecordSet.getString("datefield1");
	if(!dff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield2");
	if(!dff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield3");
	if(!dff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield4");
	if(!dff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("datefield5");
	if(!dff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"datefield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+dff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield1");
	if(!nff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield2");
	if(!nff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield3");
	if(!nff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield4");
	if(!nff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("numberfield5");
	if(!nff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"numberfield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+nff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield1");
	if(!tff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield2");
	if(!tff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield3");
	if(!tff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield4");
	if(!tff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("textfield5");
	if(!tff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"textfield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+tff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield1");
	if(!bff01.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield1"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff01;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield2");
	if(!bff02.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield2"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff02;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield3");
	if(!bff03.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield3"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff03;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield4");
	if(!bff04.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield4"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff04;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}

	strTemp = RecordSet.getString("tinyintfield5");
	if(!bff05.equals(strTemp))
	{
		ProcPara = ProjID+flag+"m";
		ProcPara += flag+"tinyintfield5"+flag+CurrentDate+flag+CurrentTime+flag+strTemp+flag+bff05;
		ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
		RecordSetT.executeProc("Prj_Modify_Insert",ProcPara);
		bNeedUpdate = true;
	}
    bNeedUpdate = true ;
	if(bNeedUpdate)
	{
		ProjectInfo.setId(ProjID);
	ProjectInfo.setBff01(bff01);
	ProjectInfo.setBff02(bff02);
	ProjectInfo.setBff03(bff03);
	ProjectInfo.setBff04(bff04);
	ProjectInfo.setBff05(bff05);
	ProjectInfo.setTff01(tff01);
	ProjectInfo.setTff02(tff02);
	ProjectInfo.setTff03(tff03);
	ProjectInfo.setTff04(tff04);
	ProjectInfo.setTff05(tff05);
	ProjectInfo.setNff01(nff01);
	ProjectInfo.setNff02(nff02);
	ProjectInfo.setNff03(nff03);
	ProjectInfo.setNff04(nff04);
	ProjectInfo.setNff05(nff05);
	ProjectInfo.setDff01(dff01);
	ProjectInfo.setDff02(dff02);
	ProjectInfo.setDff03(dff03);
	ProjectInfo.setDff04(dff04);
	ProjectInfo.setDff05(dff05);
	ProjectInfo.setLinkXml(linkXml);
	ProjectInfo.setProTemplateId(proTemplateId);
	ProjectInfo.setProCode(proCode);
	ProjectInfo.setPrjName(PrjName);
	ProjectInfo.setPrjDesc(PrjDesc);
	ProjectInfo.setPrjType(PrjType);
	ProjectInfo.setWorkType(WorkType);
	ProjectInfo.setSecuLevel(SecuLevel);
	ProjectInfo.setMemberOnly(MemberOnly);
	ProjectInfo.setManagerView(ManagerView);
	ProjectInfo.setParentView(ParentView);
	/*ProjectInfo.setMoneyP(MoneyP);
	ProjectInfo.setMoneyT(MoneyT);
	ProjectInfo.setIncomeP(IncomeP);
	ProjectInfo.setIncomeT(IncomeT);*/
	/*TD46699 由于以上四列数据库类型为money型，需要转化数据类型。不然SQL 2000 数据库会报错，改用存储过程更新*/
	ProjectInfo.setBDateP(BDateP);
	ProjectInfo.setBTimeP(BTimeP);
	ProjectInfo.setEDateP(EDateP);
	ProjectInfo.setETimeP(ETimeP);
	ProjectInfo.setBDateT(BDateT);
	ProjectInfo.setBTimeT(BTimeT);
	ProjectInfo.setEDateT(EDateT);
	ProjectInfo.setETimeT(ETimeT);
	ProjectInfo.setLabourP(LabourP);
	ProjectInfo.setLabourT(LabourT);
	ProjectInfo.setPhoto(Photo);
	ProjectInfo.setPrjInfo(PrjInfo);
	ProjectInfo.setParentID(ParentID);
	ProjectInfo.setEnvDoc(EnvDoc);
	ProjectInfo.setConDoc(ConDoc);
	ProjectInfo.setProDoc(ProDoc);
	ProjectInfo.setPrjManager(PrjManager);
	ProjectInfo.setPrjDept(PrjDept);
	ProjectInfo.setSubcompanyid1(Subcompanyid1);
	ProjectInfo.setCurrentUser(CurrentUser);
	ProjectInfo.setCurrentDate(CurrentDate);
	ProjectInfo.setCurrentTime(CurrentTime);
	ProjectInfo.setPrjStatus(PrjStatus);
	//System.out.println("ProjID:"+ProjID);
	ProjectInfo.editPrjInfo();
	
	/************TD46699 在结束后，用存储过程更新 Money类型字段值****************/
	ProcPara = ProjID;
	ProcPara += flag+MoneyP;
	ProcPara += flag+MoneyT;
	ProcPara += flag+IncomeP;
	ProcPara += flag+IncomeT;
	RecordSet.executeProc("Prj_ProjectInfo_UpdateForMoney",ProcPara);
	/*****************TD46699  End****************/
		ProjectInfoComInfo.removeProjectInfoCache();

		

 
        ProcPara = ProjID;
        ProcPara += flag+"m";
        ProcPara += flag+RemarkDoc;
        ProcPara += flag+Remark;
        ProcPara += flag+CurrentDate;
        ProcPara += flag+CurrentTime;
        ProcPara += flag+CurrentUser;
        ProcPara += flag+SubmiterType;
        ProcPara += flag+ClientIP;
        RecordSet.executeProc("Prj_Log_Insert",ProcPara);

        //========编辑项目类型自定义字段开始=====    
        ProjTempletUtil.editProjTypeCDataReal(fu,ProjID);
        //========编辑项目类型自定义字段结束=====   
	}

	if(bShareUpdate)
	{
		PrjViewer.setPrjShareByPrj(""+ProjID);
	}

	if(!EnvDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+EnvDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ConDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ConDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!ProDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+ProDoc;
		RecordSet.executeSql(tempsql);	
	}
	if(!RemarkDoc.equals("")){
		String tempsql="update docdetail set projectid="+ProjID+" where id="+RemarkDoc;
		RecordSet.executeSql(tempsql);	
	}        
    
	//相关附件操作开始
    String newAccessory = "";
	RecordSet.executeSql("SELECT accessory FROM Prj_ProjectInfo WHERE id = " + ProjID);
    if(RecordSet.next()){
		String oldAccessory = Util.null2String(RecordSet.getString(1));
	    newAccessory = oldAccessory;
		//删除附件
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
		//附件上传
		if(accessorynum > 0){
			String[] uploadField=new String[accessorynum];
			for(int i=0; i<accessorynum; i++){
				uploadField[i]="accessory"+(i+1);
			}
			DocExtUtil mDocExtUtil=new DocExtUtil();
			int[] returnarry = mDocExtUtil.uploadDocsToImgs(fu,user,uploadField);
			if(returnarry != null){
				for(int j=0;j<returnarry.length;j++){
					if(returnarry[j] != -1){
						if(newAccessory.equals("")){
							newAccessory = String.valueOf(returnarry[j])+",";
						}else{
							newAccessory += String.valueOf(returnarry[j])+",";
						}
					}
				}
			}
		}
	}
    if(!"".equals(newAccessory)){
	    RecordSet.executeSql("update Prj_ProjectInfo set accessory ='"+newAccessory+"' where id = "+ProjID);    
	    
		//给项目里面的相关附件赋查看权限开始
		String memberstmp = "";
		RecordSet.executeSql("select userid from PrjShareDetail where prjid="+ProjID);
		while(RecordSet.next()) {
			memberstmp += RecordSet.getString("userid")+",";
		}
		ProjectAccesory.addAccesoryShare(newAccessory,memberstmp);
		//给项目里面的相关附件赋查看权限结束
		
	}
    //相关附件操作结束
    
	response.sendRedirect("/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID);
	return;
  
} 





if(method.equals("editTask")){
	//TD5130
	//added by hubo, 2006-10-13
	 if("".equals(taskRecordIds)){
	 
	     String deleteTrashyTask = "DELETE FROM Prj_TaskProcess WHERE prjid="+Util.getIntValue(ProjID)+" ";
	 	 RecordSet.executeSql(deleteTrashyTask);
	 }else{
	
		 String deleteTrashyTask = "DELETE FROM Prj_TaskProcess WHERE prjid="+Util.getIntValue(ProjID)+" AND id NOT IN ("+taskRecordIds+")";
	     RecordSet.executeSql(deleteTrashyTask);
	 }

    //TD5672 added by mackjoe  2007-01-04 增加项目xml的更新处理
    
    ProjectInfo.setLinkXml(linkXml);
    ProjectInfo.setId(ProjID);
    ProjectInfo.editLinkXml();
    
    RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
    if(RecordSet.next()){
        PrjManager = RecordSet.getString("manager");
    }

    boolean needAprove = false  ;
	boolean bNeedUpdate=false;
        if ("1".equals(projStatus)||"2".equals(projStatus)||"5".equals(projStatus)) needAprove = true ;
        int status = 0;
        //1:表示项目审批过后正常状态   2:表项目为延期状态   5:表项目为立项批准状态
        if (rowIndexs!=null)
                                for (int i=0 ;i<rowIndexs.length;i++){
                                    int rowIndex = Util.getIntValue(rowIndexs[i],0);
                                    String taskName =  new String(Util.null2String(taskNames[i]).getBytes("ISO8859_1") , "GBK");
                                    float workLong = Util.getFloatValue(workLongs[i],0);
                                    String beginDate =  Util.null2String(beginDates[i]);
                                    String endDate =  Util.null2String(endDates[i]);
                                    int beforeTask = Util.getIntValue(beforeTasks[i],0);
                                    //float budget = Util.getFloatValue(budgets[i],0);
                                    String budget =  Util.null2String(budgets[i]);
                                    if(budget.equals("")) budget = "0";
                                    int manager = 0;
									try{
										manager =Util.getIntValue(managers[i],0);
									}catch(Exception e){
									
									}
                                   
                                    String parentid  = ProjTempletUtil.getParentTaskId(linkXml,rowIndex);
                                    int level = ProjTempletUtil.getLevel(linkXml,rowIndex); 
                        
                                    String taskid = "0" ;
                                    String wbscoding = "0" ;
                                    String version = "0" ;
                            
												//====================================================================================================================
                                    //TD3853,modified by hubo,2006-03-13
												String tempParentIds = "";
												String tempParentHrmIds = "";
												rs2.executeSql("select id,parentids,parenthrmids from Prj_TaskProcess where prjid="+ProjID+" and taskIndex ="+parentid);
												if (rs2.next()){
													parentid=rs2.getString(1);
													tempParentIds = rs2.getString(2);
													tempParentHrmIds = rs2.getString(3);
												}
												String parentids = tempParentIds;
												String parenthrmids = tempParentHrmIds;   
												//====================================================================================================================

                        
                        
                                    if ("".equals(taskName))  taskName=" ";
                                    if ("".equals(beginDate))  beginDate=" ";
									if (ProjTempletUtil.isProjTaskExist(ProjID,""+rowIndex)){
                                         bNeedUpdate = false ;
                                    int taskrecordid = 0 ;
                                    rs.executeSql("select id from Prj_TaskProcess where prjid="+ProjID+" and taskIndex="+rowIndex);
                                    if (rs.next()) taskrecordid = Util.getIntValue(rs.getString(1),0);
                                        strTemp="";
                                        RecordSetM.executeProc("Prj_TaskProcess_SelectByID",""+taskrecordid);
                                        if( RecordSetM.next())  {
                                            /*修改主题*/
                                            strTemp = RecordSetM.getString("subject");
                                            if(!taskName.equals(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "subject" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ taskName+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType + flag +"0";
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                                            /*修改负责人*/
                                            strTemp = RecordSetM.getString("hrmid");
                                            if(!(manager==Util.getIntValue(strTemp))){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "hrmid" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ manager+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                                
                                                //触发工作流通知原任务负责人和现任务负责人，若其中有一个是现登陆者，那么就不用再通知本人。
                                                if(canRemind&&CurrentUser.equals(PrjManager)){//修改者是经理
                                                    String SWFAccepter="";
                                                    String Subject="";
                                                    String SWFTitle="";
                                                    String SWFRemark="";
                                                    String SWFSubmiter="";
                                                    String CurrentUserName = ""+user.getUsername();
                                                
                                                    if(CurrentUser.equals(strTemp)){//同时原负责人也是自己,只要通知当前负责人
                                                        SWFAccepter=""+manager;
                                                    }else{
                                                        if(CurrentUser.equals(""+manager)){//原负责人不是自己，现负责人是自己,通知原负责人
                                                            SWFAccepter = strTemp;
                                                        }else{//原负责人不是自己，现负责人也不是自己:通知原负责人和现负责人
                                                            SWFAccepter = manager+","+strTemp;
                                                        }
                                                    }

                                                     String name=ResourceComInfo.getResourcename(""+manager);
                                                     Subject=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                                     Subject+=":"+taskName+"-";
                                                     Subject+=SystemEnv.getHtmlLabelName(15285,user.getLanguage());
                                                     Subject+=":"+name;
                                                     
                                                     SWFTitle=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                                     SWFTitle += ":"+taskName;
                                                     SWFTitle += "-"+CurrentUserName;
                                                     SWFTitle += "-"+CurrentDate;
                                                     SWFRemark="<a href=/proj/process/ViewProcess.jsp?ProjID="+ProjID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
                                                     SWFSubmiter=CurrentUser;

                                                     SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
                                                }
                                                
                                            }
															
														//================================================
														//TD3900
														//modified by hubo,2006-04-05
                                            strTemp = RecordSetM.getString("begindate").trim();
                                            if(!(beginDate.trim()).equals(strTemp)){
														//================================================
                                                ProcPara =ProjID+flag + taskrecordid +flag + "begindate" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ beginDate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                                            strTemp = RecordSetM.getString("enddate");
                                            if(!endDate.equals(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "enddate" + flag + CurrentDate +  flag + CurrentTime + flag+ strTemp+flag+ endDate+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                        
                        
                                            strTemp = RecordSetM.getString("workday");
                                            if(workLong!=Util.getFloatValue(strTemp)){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "workday" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ workLong+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                        
                                            strTemp = Util.null2String(RecordSetM.getString("fixedcost"));
                                            if(strTemp.equals("")) strTemp = "0";
                                            //if(budget!=Util.getFloatValue(strTemp)){
                                            if((new BigDecimal(strTemp)).compareTo(new BigDecimal(budget))!=0){
                                                ProcPara =ProjID+flag + taskrecordid +flag + "fixedcost" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ budget+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+ flag +"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }
                                            strTemp = Util.null2String(RecordSetM.getString("prefinish"));                    if(!(beforeTask==Util.getIntValue(strTemp))){                   
                                                ProcPara =ProjID+flag + taskrecordid +flag + "pretask" + flag + CurrentDate + flag + CurrentTime + flag+ strTemp+flag+ beforeTask+ flag+CurrentUser +flag +ClientIP +flag +SubmiterType+flag+"0" ;
                                                RecordSetT.executeProc("Prj_TaskModify_Insert",ProcPara);
                                                bNeedUpdate = true;
                                            }   
                                        }
                                        
										if (ProjTempletUtil.isManager(user,ProjID)||!needAprove)
											status = 0;
										else if(!bNeedUpdate) //如果没有什么改动的话，还是原来的状态 
											status = RecordSetM.getInt("status");
										else  
											status = 2;
					
										//String strsqlForTask="update Prj_TaskProcess set subject='"+taskName+"',hrmid="+manager+",begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workLong+",fixedcost="+budget+",prefinish="+beforeTask+",parentid="+parentid+",level_n="+level+",dsporder="+i+",status="+status+" where prjid="+ProjID+" and taskIndex="+rowIndex;
										parentids+=""+taskrecordid+",";
										parenthrmids+="|"+taskrecordid+","+manager+"|";
										String strsqlForTask="update Prj_TaskProcess set subject='"+taskName+"',hrmid="+manager+",begindate='"+beginDate+"',enddate='"+endDate+"',workday="+workLong+",fixedcost="+budget+",prefinish="+beforeTask+",parentid="+parentid+",level_n="+level+",dsporder="+i+",status="+status+",parentids='"+parentids+"',parenthrmids='"+parenthrmids+"' where prjid="+ProjID+" and taskIndex="+rowIndex;
										rs.executeSql(strsqlForTask);
													
										//====================================================================
										//TD3853,added by hubo,2006-03-13
										String oldhrmid = RecordSetM.getString("hrmid");
										ProcPara = ""+manager + flag + ""+oldhrmid + flag + ""+taskrecordid;
										rs.executeProc("Prj_TaskProcess_UParentHrmIds",ProcPara);
										//====================================================================
                                       
                                    } else {
                        
                                        ProcPara = "";
                                        ProcPara = ProjID ;
                                        ProcPara += flag + "" + taskid ;
                                        ProcPara += flag + "" + wbscoding ;
                                        ProcPara += flag + "" + taskName ;
                                        ProcPara += flag + "" + version ;
                                        ProcPara += flag + "" + beginDate ;
                                        ProcPara += flag + "" + endDate ;
                                        ProcPara += flag + "" + workLong ;
                                        ProcPara += flag + "" + " " ;
                                        ProcPara += flag + "" + budget ;
                                        ProcPara += flag + "" + parentid ;
                                        ProcPara += flag + "" + parentids ;
                                        ProcPara += flag + "" + parenthrmids ;
                                        ProcPara += flag + "" + level ;
                                        ProcPara += flag + "" + manager ;
                                        ProcPara += flag + "" + beforeTask ;
                                        ProcPara += flag + "" + "0" ; // real work days
                                        ProcPara += flag + "" + rowIndex ;  //记录真正的行号
                        
                                        RecordSet.executeProc("Prj_TaskProcess_Insert",ProcPara);  
                                        
                                        String TaskID="0";
                                        RecordSet.executeProc("Prj_TaskProcess_SMAXID","");
                                        if (RecordSet.next())   TaskID = RecordSet.getString("maxid_1");
                        
                                        ProcPara = ProjID ;
                                        ProcPara += flag + "" + TaskID ;
                                        ProcPara += flag + "np"  ;
                                        ProcPara += flag + "" + CurrentDate ;
                                        ProcPara += flag + "" + CurrentTime ;
                                        ProcPara += flag + "" + CurrentUser ;
                                        ProcPara += flag + "" + ClientIP ;
                                        ProcPara += flag + "" + SubmiterType ;
                                        RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);
                                        
                                        if (ProjTempletUtil.isManager(user,ProjID)||!needAprove)   status = 0;
                                        else  status = 1;
                                        rs.executeSql("update Prj_TaskProcess set dsporder ="+i+" ,status="+status+" where prjid="+ProjID+" and taskIndex="+rowIndex);
                                        //strsqlForTask = "insert into Prj_TaskProcess (prjid,taskIndex,subject,hrmid,begindate,enddate,workday,fixedcost,prefinish) values("+ProjID+","+rowIndex+",'"+taskName+"',"+manager+",'"+beginDate+"','"+endDate+"',"+workLong+","+budget+","+beforeTask+")"; 
                                        
                                        //触发工作流通知原任务负责人和现任务负责人，若其中有一个是现登陆者，那么就不用再通知本人。
                                        if(canRemind&&CurrentUser.equals(PrjManager)&&!(""+manager).equals("")){//修改者是经理,并且任务负责人不为空
                                            String SWFAccepter="";
                                            String Subject="";
                                            String SWFTitle="";
                                            String SWFRemark="";
                                            String SWFSubmiter="";
                                            String CurrentUserName = ""+user.getUsername();
                                                
                                            if(!CurrentUser.equals(""+manager)){//任务负责人不是当前操作者
                                                SWFAccepter = ""+manager;
                                            }

                                            String name=ResourceComInfo.getResourcename(""+manager);
                                            Subject=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                            Subject+=":"+taskName+"-";
                                            Subject+=SystemEnv.getHtmlLabelName(15285,user.getLanguage());
                                            Subject+=":"+name;
                                                     
                                            SWFTitle=SystemEnv.getHtmlLabelName(15284,user.getLanguage());
                                            SWFTitle += ":"+taskName;
                                            SWFTitle += "-"+CurrentUserName;
                                            SWFTitle += "-"+CurrentDate;
                                            SWFRemark="<a href=/proj/process/ViewProcess.jsp?ProjID="+ProjID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
                                            SWFSubmiter=CurrentUser;

                                            SysRemindWorkflow.setPrjSysRemind(SWFTitle,Util.getIntValue(ProjID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);
                                        }
                                    }
                                     
                                    //System.out.println(strsqlForTask);
        }
        ArrayList rowIndexList = Util.arrayToArrayList(rowIndexs);
        rs.executeSql("select id,taskIndex from Prj_TaskProcess where prjid="+ProjID);
        while (rs.next()){
            String taskId = Util.null2String(rs.getString("id"));
            String taskIndexId = Util.null2String(rs.getString("taskIndex"));           

            //如果从客户端传过来的数据中不存在此任务的ID则需删掉此任务
            if (rowIndexList.indexOf(taskIndexId)==-1){                             
                ProcPara = ProjID ;
                ProcPara += flag + "" + taskId ;
                ProcPara += flag + "dp"  ;
                ProcPara += flag + "" + CurrentDate ;
                ProcPara += flag + "" + CurrentTime ;
                ProcPara += flag + "" + CurrentUser ;
                ProcPara += flag + "" + ClientIP ;
                ProcPara += flag + "" + SubmiterType ;
                RecordSet.executeProc("Prj_TaskLog_Insert",ProcPara);
                
                if (ProjTempletUtil.isManager(user,ProjID)||!needAprove) {
                    //真正的删除操作
                   rs1.executeSql("delete Prj_TaskProcess where id = "+taskId);
                } else {
                    rs1.executeSql("update Prj_TaskProcess set status=3 where id = "+taskId);
                }
                //System.out.println("delete Prj_TaskProcess where id = "+taskId);
            }
        }

        /*
        **说明：此处功能不太明确，当有任务1的taskIndex刚好与任务2的parentid相同时，
        即使这两个任务没有关系，会将任务2的上级任务更新为任务1，导致错误。
        Prj_TaskProcess的id是自增长的，taskindex对一个项目来说是从1开始的，该种错误发生可能性在项目模块刚启用时。
        立此为据，便于日后问题查找。
        **梅运强 2009-12-15
        
        //修改父结点的值
        RecordSet.executeSql("select id,parentid from Prj_TaskProcess where prjid="+ProjID);
        while(RecordSet.next()){
            String id = RecordSet.getString("id");
            String parentid =  RecordSet.getString("parentid");
            
            rs.executeSql("select id from Prj_TaskProcess where prjid="+ProjID+" and taskIndex ="+parentid);
            if (rs.next()){
                String newId = rs.getString(1);
                rs1.executeSql("update Prj_TaskProcess set parentid ="+newId+" where id="+id );
            }
        }
        */

        //System.out.println("====================");	
	

if(insertWorkPlan.equals("1")){
	//编辑工作计划Begin
	RecordSet.executeSql("select * from workplan where type_n = '2' and projectid = '" + ProjID + "' and taskid = -1");
	String para = "";
	String workid = "";
	if (RecordSet.next()) {
		
		workid = RecordSet.getString("id");
		para = workid;
		para +=flag+"2";//type_n
		para +=flag+PrjName;
		para +=flag+PrjManager;
		para +=flag+Util.null2String(RecordSet.getString("begindate"));//BeginDate;
		para +=flag+Util.null2String(RecordSet.getString("begintime"));//BeginTime;
		para +=flag+Util.null2String(RecordSet.getString("enddate"));//EndDate;
		para +=flag+Util.null2String(RecordSet.getString("endtime"));//EndTime;
		para +=flag+PrjInfo;//description
		para +=flag+Util.null2String(RecordSet.getString("requestid"));//requestid ;
		para +=flag+ProjID;
		para +=flag+Util.null2String(RecordSet.getString("crmid"));//crmid;
		para +=flag+Util.null2String(RecordSet.getString("docid"));//docid;
		para +=flag+Util.null2String(RecordSet.getString("meetingid"));//meetingid;
		para +=flag+Util.null2String(RecordSet.getString("isremind"));//isremind;
		para +=flag+Util.null2String(RecordSet.getString("waketime"));//waketime;
		para +=flag+Util.null2String(RecordSet.getString("taskid"));//taskid;
		para +=flag+Util.null2String(RecordSet.getString("urgentlevel"));//urgentlevel;
		//=======================================================================================================
            //TD.6769
			para += flag + "1";  //remindType
			para += flag + "";  //remindBeforeStart
			para += flag + "";  //remindBeforeEnd
			para += flag + "0";  //remindTimesBeforeStart
			para += flag + "0";  //remindTimesBeforeEnd
			para += flag + "";  //remindDateBeforeStart
			para += flag + "";  //remindTimeBeforeStart
			para += flag + "";  //remindDateBeforeEnd
			para += flag + "";  //remindTimeBeforeEnd
			para += flag + "-1";  //hrmPerformanceCheckDetailID
		RecordSet.executeProc("WorkPlan_Update",para);
		//out.print(para);
		WorkPlanViewer.setWorkPlanShareById(workid);
		
	}
	//编辑工作计划End
}
        
    	response.sendRedirect("/proj/data/ViewProject.jsp?log=n&ProjID="+ProjID);
	return;
  
}

%>
<p><%=SystemEnv.getHtmlLabelName(15127,user.getLanguage())%>！</p>