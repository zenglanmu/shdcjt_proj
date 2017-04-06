<%@ page import="weaver.general.Util,java.net.*,weaver.workflow.field.FieldComInfo"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.workflow.request.RequestManager" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
// 操作的用户信息
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String dateSql = "";
if(rs.getDBType().equalsIgnoreCase("oracle")){
	dateSql = "select to_char(sysdate,'yyyy-mm-dd') as currentdate, to_char(sysdate,'hh24:mi:ss') as currenttime from dual";
}else{
	dateSql = "select convert(char(10),getdate(),20) as currentdate, convert(char(8),getdate(),108) as currenttime";
}
String currentdate = "";
String currenttime = "";
rs.execute(dateSql);
if(rs.next()){
	currentdate = Util.null2String(rs.getString(1));
	currenttime = Util.null2String(rs.getString(2));
}else{
	Calendar today = Calendar.getInstance();
	currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			Util.add0(today.get(Calendar.SECOND), 2) ;
}

String src = "submit";
String iscreate = "0";
int isremark = 0;
String remark = "\n"+username+" "+currentdate+" "+currenttime;
String workflowtype = "";
int formid = -1;
int isbill = -1;
int billid = -1;
String messageType = "";
int nodeid = -1;
String nodetype = "";
String requestname = "";
String requestlevel = "";

//modify by xhheng @20050524 for TD 2023
String requestidlist=Util.null2String(request.getParameter("multiSubIds"));
String [] requestids=Util.TokenizerString2(requestidlist,",");

for (int i=0; i<requestids.length; i++){
    RequestManager = new RequestManager();
    int requestid = Util.getIntValue(requestids[i],-1) ;
     /*----------xwj for td3098 20051202 begin -----*/
    src = "submit";
    isremark = 0;
    RecordSet.executeSql("select min(isremark) from workflow_currentoperator where requestid = " + requestid + " and userid = "+user.getUID());
    if(RecordSet.next()){
    int isremarkCheck = RecordSet.getInt(1);
    if(isremarkCheck==1){
    src = "save";
    isremark = 1;
    }
    }
    
    //判断当前流程是否还为当前操作者的待办事宜
    if(RecordSet.getDBType().equals("sqlserver")){
	    RecordSet.executeSql("select t1.requestid from workflow_requestbase t1, workflow_currentoperator t2 " +
		"where t1.requestid = t2.requestid and t2.userid = "+user.getUID()+" and t2.usertype = 0 and (isnull(t1.currentstatus, -1) = -1 or (isnull(t1.currentstatus, -1) = 0 and t1.creater = "+user.getUID()+")) "+
		"and t2.isremark in ('0', '1', '5', '8', '9', '7') and t2.islasttimes = 1 and t1.requestid = " + requestid);
	    if(!RecordSet.next()){
	    	continue;
	    }
    }else{
	    RecordSet.executeSql("select t1.requestid from workflow_requestbase t1, workflow_currentoperator t2 " +
   		"where t1.requestid = t2.requestid and t2.userid = "+user.getUID()+" and t2.usertype = 0 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater = "+user.getUID()+")) "+
   		"and t2.isremark in ('0', '1', '5', '8', '9', '7') and t2.islasttimes = 1 and t1.requestid = " + requestid);
   	    if(!RecordSet.next()){
   	    	continue;
   	    }
    }
    
    /*----------xwj for td3098 20051202 end -----*/
    
    int workflowid=-1;

    if(requestid!=-1 ){
    boolean isStart = false;
    RecordSet.executeSql("select currentnodeid,currentnodetype,requestname,requestlevel,workflowid,status from workflow_requestbase where requestid="+requestid);
    if(RecordSet.next()){
      requestname = RecordSet.getString("requestname");
      requestlevel = RecordSet.getString("requestlevel");
      workflowid = RecordSet.getInt("workflowid");
      isStart = (RecordSet.getString("status")!=null && !"".equals(RecordSet.getString("status")));
    }
    nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
    nodetype=WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档    
    boolean isTrack = true;
    RecordSet.executeSql("select workflowtype,formid,isbill,messageType,isModifyLog from workflow_base where id="+workflowid);
    if(RecordSet.next()){
      workflowtype = RecordSet.getString("workflowtype");
      formid = RecordSet.getInt("formid");
      isbill = RecordSet.getInt("isbill");
      //billid = RecordSet.getInt("formid");
      messageType = RecordSet.getString("messageType");
      isTrack = (RecordSet.getString("ismodifylog")!=null && "1".equals(RecordSet.getString("ismodifylog")));
    }
	if(isbill == 1){
		RecordSet.execute("select tablename from workflow_bill where id="+formid);
		if(RecordSet.next()){
			String tablename = Util.null2String(RecordSet.getString(1));
			if(!"".equals(tablename)){
				RecordSet.execute("select id from "+tablename+" where requestid="+requestid);
				if(RecordSet.next()){
					billid = RecordSet.getInt("id");
				}
			}else{
				continue;
			}
		}
	}
    if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
        response.sendRedirect("/notice/RequestError.jsp");
        return ;
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
    RequestManager.setRequest(request) ;
    RequestManager.setMessageType(messageType) ;
    RequestManager.setUser(user) ;
    
    /**Start 批量提交时也必须做节点附加操作 by alan on 2009-04-23**/
    if(!src.equals("save")){
		try {
			 //由于objtype为"1: 节点自动赋值",不为"0 :出口自动赋值"，不用改变除状态外的文档相关信息，故可不用给user、clienIp、src赋值  fanggsh TD5121			
			weaver.workflow.request.RequestCheckAddinRules requestCheckAddinRules = new weaver.workflow.request.RequestCheckAddinRules();
			requestCheckAddinRules.resetParameter();
			//add by cyril on 2008-07-28 for td:8835 事务无法开启查询,只能传入
            requestCheckAddinRules.setTrack(isTrack);
            requestCheckAddinRules.setStart(isStart);
            requestCheckAddinRules.setNodeid(nodeid);
            //end by cyril on 2008-07-28 for td:8835
			requestCheckAddinRules.setRequestid(requestid);
			requestCheckAddinRules.setWorkflowid(workflowid);
			requestCheckAddinRules.setObjid(nodeid);
			requestCheckAddinRules.setObjtype(1);               // 1: 节点自动赋值 0 :出口自动赋值
			requestCheckAddinRules.setIsbill(isbill);
			requestCheckAddinRules.setFormid(formid);
			requestCheckAddinRules.setIspreadd("0");//xwj for td3130 20051123
			requestCheckAddinRules.setRequestManager(RequestManager);
			requestCheckAddinRules.setUser(user);
			requestCheckAddinRules.checkAddinRules();
		} catch (Exception e) {
			response.sendRedirect("/notice/RequestError.jsp");
	        return ;
		}
	}
    /**End 批量提交时也必须做节点附加操作 by alan on 2009-04-23**/
	//TD10974 处理流程批量提交的时候，文档、客户、资产、项目无法附权下一节点操作者的问题 Start
	int docRightByOperator=0;
	rs.execute("select docRightByOperator from workflow_base where id="+workflowid);
	if(rs.next()){
		docRightByOperator=Util.getIntValue(rs.getString("docRightByOperator"),0);
	}
	String maintable = "workflow_form";
	if (isbill == 1) {
		rs.execute("select tablename from workflow_bill where id = " + formid);
		if(rs.next()){
			maintable = Util.null2String(rs.getString("tablename"));
		}
		rs.executeProc("workflow_billfield_Select", formid + "");
	} else {
		rs.executeSql("select t2.fieldid,t2.fieldorder,t2.isdetail,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");
	}		
    ArrayList fieldidList = new ArrayList();
    ArrayList fieldnameList = new ArrayList();
    ArrayList fielddbtypeList = new ArrayList();
    ArrayList fieldhtmltypeList = new ArrayList();
    ArrayList fieldtypeList = new ArrayList();
    String fieldnames = "";
    String fieldid = "";
    String fieldname = "";
    String fielddbtype = "";
    String fieldhtmltype = "";
    String fieldtype = "";
    FieldComInfo fieldComInfo = new FieldComInfo();
    String hrmids = "";
    String crmids = "";
    String prjids = "";
    String docids = "";
    String cptids = "";
    boolean hasmanager=false;
    char separarorFlag = Util.getSeparator();
	while (rs.next()) {
		if (isbill == 1) {
			String viewtype = Util.null2String(rs.getString("viewtype"));   // 如果是单据的从表字段,不进行操作
			if (viewtype.equals("1")) continue;
			fieldid = Util.null2String(rs.getString("id"));
			fieldname = Util.null2String(rs.getString("fieldname"));
			fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			fieldtype = Util.null2String(rs.getString("type"));
		} else {
			fieldid = Util.null2String(rs.getString(1));
			fieldname = Util.null2String(fieldComInfo.getFieldname(fieldid));
			fielddbtype = Util.null2String(fieldComInfo.getFielddbtype(fieldid));
			fieldhtmltype = Util.null2String(fieldComInfo.getFieldhtmltype(fieldid));
			fieldtype = Util.null2String(fieldComInfo.getFieldType(fieldid));
		}
        if(fieldname.toLowerCase().equals("manager")){
            hasmanager=true;
        }
		fieldidList.add(fieldid);
		fieldnameList.add(fieldname);
		fielddbtypeList.add(fielddbtype);
		fieldhtmltypeList.add(fieldhtmltype);
		fieldtypeList.add(fieldtype);
		fieldnames = fieldnames + fieldname + ",";
	}
    if(hasmanager){
        String beagenter=""+userid;
        //获得被代理人
        RecordSet.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="+requestid+" and userid="+userid+" and nodeid="+nodeid+" order by id desc");
        if(RecordSet.next()){
          int tembeagenter=RecordSet.getInt(1);
          if(tembeagenter>0) beagenter=""+tembeagenter;
        }
        String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
        rs2.executeSql("update " + maintable + " set manager="+tmpmanagerid+" where requestid=" + requestid);
    }
	if(fieldnames.length() > 0){
		fieldnames = fieldnames.substring(0, fieldnames.length()-1);
		rs2.execute("select " + fieldnames + " from " + maintable + " where requestid=" + requestid);
		if(rs2.next()){
			for(int j=0; j<fieldidList.size(); j++){
				fieldid = Util.null2String((String)fieldidList.get(j));
				fieldname = Util.null2String((String)fieldnameList.get(j));
				fielddbtype = Util.null2String((String)fielddbtypeList.get(j));
				fieldhtmltype = Util.null2String((String)fieldhtmltypeList.get(j));
				fieldtype = Util.null2String((String)fieldtypeList.get(j));
				if (fieldhtmltype.equals("3") && (fieldtype.equals("1") || fieldtype.equals("17"))) { // 人力资源字段
					String tempvalueid="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) hrmids += "," + tempvalueid;
				} else if (fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18"))) {   // 客户字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) crmids += "," + tempvalueid;
				} else if (fieldhtmltype.equals("3") && (fieldtype.equals("8")|| fieldtype.equals("135"))) {                             // 项目字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) prjids += "," + tempvalueid;
				} else if (fieldhtmltype.equals("3") && (fieldtype.equals("9") || fieldtype.equals("37"))) {  // 文档字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) docids += "," + tempvalueid;
					//跟随文档关联人赋权
					if(docRightByOperator==1){
						//在Workflow_DocSource表中删除当前字段被删除的文档
						if (!tempvalueid.equals("")){
							rs1.execute("delete from Workflow_DocSource where requestid =" + requestid + " and fieldid =" + fieldid + " and docid not in (" + tempvalueid + ")");
						}else{
							rs1.execute("delete from Workflow_DocSource where requestid =" + requestid + " and fieldid =" + fieldid);
						}
						//在Workflow_DocSource表中添加当前字段新增加的文档
						String[] mdocid=Util.TokenizerString2(tempvalueid,",");
						for(int cx=0;cx<mdocid.length; cx++){
							if(mdocid[cx]!=null && !mdocid[cx].equals("")){
								rs1.executeProc("Workflow_DocSource_Insert",""+requestid + separarorFlag + nodeid + separarorFlag + fieldid + separarorFlag + mdocid[cx] + separarorFlag + userid + separarorFlag + "1");//由于usertype不一致，这里的usertype直接指定为1，只处理内部用户
							}
						}
					}
				} else if (fieldhtmltype.equals("3") && fieldtype.equals("23")) {                           // 资产字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) cptids += "," + tempvalueid;
				}
			}
			if (!hrmids.equals("")) hrmids = hrmids.substring(1);
			if (!crmids.equals("")) crmids = crmids.substring(1);
			if (!prjids.equals("")) prjids = prjids.substring(1);
			if (!docids.equals("")) docids = docids.substring(1);
			if (!cptids.equals("")) cptids = cptids.substring(1);
			RequestManager.setHrmids(hrmids);
			RequestManager.setCrmids(crmids);
			RequestManager.setPrjids(prjids);
			RequestManager.setDocids(docids);
			RequestManager.setCptids(cptids);
		}
	}
	//TD10974 End

    boolean flowstatus = RequestManager.flowNextNode() ;
    if (flowstatus) {
                //added by mackjoe at 2007-01-10 TD5567
                //增加文档,项目,客户批量审批处理
                if (RequestManager.getNextNodetype().equals("3") && isbill == 1) {
                    //文档
                    if (formid == 28) {
                        RecordSet.executeSql("update bill_Approve set status='1' where requestid=" + requestid);
                        RecordSet.executeSql("select approveid from bill_Approve where requestid=" + requestid);
                        if(RecordSet.next()){
                            DocManager.approveDocFromWF("approve", RecordSet.getString("approveid"), currentdate, currenttime, userid + "");
                        }
                    }
                    //项目
                    if (formid == 74) {
                        RecordSet.executeSql("select approveid from Bill_ApproveProj where requestid=" + requestid);
                        if(RecordSet.next()){
                            char flag = 2 ;
                            String approveid=RecordSet.getString("approveid");
                            RecordSet.executeProc("Prj_Plan_Approve",approveid);
                            String tmpsql="update prj_taskprocess set isactived=2 where prjid="+approveid ;
                            RecordSet.executeSql(tmpsql);
                            tmpsql = "update Prj_ProjectInfo set status = 5 where id = "+ approveid;
                            RecordSet.executeSql(tmpsql);

                            //更新工作计划中该项目的经理的时间Begin
                            String begindate01 = "";
                            String enddate01 = "";

                            RecordSet.executeProc("Prj_TaskProcess_Sum",""+approveid);
                            if(RecordSet.next() && !RecordSet.getString("workday").equals("")){

                                if(!RecordSet.getString("begindate").equals("x")) begindate01 = RecordSet.getString("begindate");
                                if(!RecordSet.getString("enddate").equals("-")) enddate01 = RecordSet.getString("enddate");

                            }
                            if (!begindate01.equals("")){
                                RecordSet.executeSql("update workplan set status = '0',begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + approveid + "' and taskid = -1");
                            }
                            //更新工作计划中该项目的经理的时间End

                            //添加工作计划Begin
                            String para = "";
                            String workid = "";
                            String manager="";
                            String TaskID="";
                            RecordSet.executeProc("Prj_ProjectInfo_SelectByID",approveid);
                            if (RecordSet.next()){
                                manager=RecordSet.getString("manager");
                            }

                            tmpsql = "SELECT * FROM Prj_TaskProcess WHERE prjid = " + approveid + " and isdelete<>'1' order by id";
                            RecordSet.executeSql(tmpsql);

                            while (RecordSet.next()) {
                                TaskID = RecordSet.getString("id");
                                para = "2"; //type_n
                                para +=flag+Util.toScreen(RecordSet.getString("subject"),user.getLanguage());
                                para +=flag+Util.toScreen(RecordSet.getString("hrmid"),user.getLanguage());
                                para +=flag+Util.toScreen(RecordSet.getString("begindate"),user.getLanguage());
                                para +=flag+""; //BeginTime
                                para +=flag+Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
                                para +=flag+""; //EndTime
                                para +=flag+Util.toScreen(RecordSet.getString("content"),user.getLanguage());
                                para +=flag+"0";//requestid
                                para +=flag+approveid;//projectid
                                para +=flag+"0";//crmid
                                para +=flag+"0";//docid
                                para +=flag+"0";//meetingid
                                para +=flag+"0";//status;
                                para +=flag+"1";//isremind;
                                para +=flag+"0";//waketime;
                                para +=flag+manager;//createid;
                                para +=flag+currentdate;
                                para +=flag+currenttime;
                                para +=flag+"0";
                                para += flag + "0";			//taskid
                                para += flag + "1";	//urgent level
                                para += flag + "0";	//agentId level

                                RecordSet1.executeProc("WorkPlan_Insert",para);
                                if (RecordSet1.next()) workid = RecordSet1.getString("id");

                                //write "add" of view log
                                String[] logParams = new String[] {workid,
                                                            WorkPlanLogMan.TP_CREATE,
                                                            String.valueOf(userid),
                                                            request.getRemoteAddr()};
                                WorkPlanLogMan logMan = new WorkPlanLogMan();
                                logMan.writeViewLog(logParams);
                                //end

                                RecordSet1.executeSql("update workplan set taskid = " + TaskID + " where id =" + workid);
                                WorkPlanViewer.setWorkPlanShareById(workid);
                            }
                            //添加工作计划End
                        }
                    }
                    //客户
                    if (formid == 79) {
                        String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where requestid="+requestid;
                        RecordSet.executeSql(sql);
                        String approveid="";
                        String approvetype="";
                        String approvevalue="";
                        if(RecordSet.next()){
                            approveid=RecordSet.getString("approveid");
                            approvetype=RecordSet.getString("approvetype");
                            approvevalue = RecordSet.getString("approvevalue");
                        }
                        //更改单据的状态，1：已经归档
                        RecordSet.executeSql("update bill_ApproveCustomer set status=1 where requestid="+requestid);
                        RecordSet.executeProc("CRM_CustomerInfo_SelectByID",approveid);
                        RecordSet.first();
                        String statusTemp = RecordSet.getString("status");
                        String Manager2 = RecordSet.getString("manager");
                        String name = RecordSet.getString("name");
                        String ProcPara="";
                        char flag = 2 ;
                        String fieldName="";
                        if(approvetype.equals("1")){
                            ProcPara = approveid;
                            ProcPara += flag+approvevalue;
                            ProcPara += flag+"1";

                            RecordSet.executeProc("CRM_CustomerInfo_Approve",ProcPara);

                            ProcPara = approveid;
                            ProcPara += flag+"a";
                            ProcPara += flag+"0";
                            ProcPara += flag+"a";
                            ProcPara += flag+currentdate;
                            ProcPara += flag+currenttime;
                            ProcPara += flag+""+user.getUID();
                            ProcPara += flag+""+user.getLogintype();
                            ProcPara += flag+request.getRemoteAddr();
                            RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                            fieldName = SystemEnv.getHtmlLabelName(23247,user.getLanguage());

                            ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                            ProcPara += flag+fieldName+flag+currentdate+flag+currenttime+flag+statusTemp+flag+approvevalue;
                            ProcPara += flag+""+user.getUID()+flag+""+user.getLogintype()+flag+request.getRemoteAddr();
                            RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
                        }else if(approvetype.equals("2")){
                            ProcPara = approveid;
                            ProcPara += flag+approvevalue;

                            RecordSet.executeProc("CRM_CustomerInfo_Portal",ProcPara);
                            String PortalLoginid = "";
                            String PortalPassword = "";

                            if(approvevalue.equals("2")){
                                if (approveid.length()<5){
                                    PortalLoginid = "U" + Util.add0(Util.getIntValue(approveid),5);
                                }else{
                                    PortalLoginid = "U" + approveid;
                                }

                                PortalPassword = Util.getPortalPassword();

                                ProcPara = approveid;
                                ProcPara += flag+PortalLoginid;
                                ProcPara += flag+PortalPassword;

                                RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
                            }
                            ProcPara = approveid;
                            ProcPara += flag+"p";
                            ProcPara += flag+"0";
                            ProcPara += flag+"p";
                            ProcPara += flag+currentdate;
                            ProcPara += flag+currenttime;
                            ProcPara += flag+""+user.getUID();
                            ProcPara += flag+""+user.getLogintype();
                            ProcPara += flag+request.getRemoteAddr();
                            RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                            fieldName = SystemEnv.getHtmlLabelName(23249,user.getLanguage());

                            ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                            ProcPara += flag+fieldName+flag+currentdate+flag+currenttime+flag+statusTemp+flag+approvevalue;
                            ProcPara += flag+""+user.getUID()+flag+""+user.getLogintype()+flag+request.getRemoteAddr();
                            RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
                        }else if(approvetype.equals("3")){
                            String PortalLoginid = "";
                            String PortalPassword = "";

                            if(approvevalue.equals("2")){
                                if (approveid.length()<5){
                                    PortalLoginid = "U" + Util.add0(Util.getIntValue(approveid),5);
                                }else{
                                    PortalLoginid = "U" + approveid;
                                }

                                PortalPassword = Util.getPortalPassword();

                                ProcPara = approveid;
                                ProcPara += flag+PortalLoginid;
                                ProcPara += flag+PortalPassword;

                                RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
                            }
                        }
                    }
                }
                PoppupRemindInfoUtil.updatePoppupRemindInfo(userid, 0, (logintype).equals("1") ? "0" : "1", requestid); //add by sean for td3999
                boolean logstatus = RequestManager.saveRequestLog();
            }
  }
}

response.sendRedirect("/workflow/request/RequestView.jsp");

%>