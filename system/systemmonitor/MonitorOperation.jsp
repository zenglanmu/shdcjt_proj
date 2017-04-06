<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ page import="java.util.*,java.net.*" %>

<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%--------------xwj for td2831 on 20050921 begin-----%>
<jsp:useBean id="DocExtUtil" class="weaver.docs.docs.DocExtUtil" scope="page" />
<jsp:useBean id="RecordSetDelRq" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDelDoc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetDelCheck" class="weaver.conn.RecordSet" scope="page" />
<%--------------xwj for td2831 on 20050921 end-----%>
<jsp:useBean id="wflm" class="weaver.system.SysWFLMonitor" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="prjComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String deletedocids[] = request.getParameterValues("deletedocid");

if(operation.equals("deletedoc")){
	if(!HrmUserVarify.checkUserRight("DocEdit:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String deletedocidstr = "" ;
    if( deletedocids != null ) {
        for(int i=0 ; i<deletedocids.length; i++ ) {
            if(deletedocidstr.equals("")) deletedocidstr = deletedocids[i] ;
            else deletedocidstr += "," + deletedocids[i] ;
        }

        if( !deletedocidstr.equals("") ) {

            RecordSet.executeSql(" delete DocDetail where id in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete DocImageFile where docid in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete DocShare where docid in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete ShareinnerDoc where sourceid in ( " + deletedocidstr + " ) " ) ;
            RecordSet.executeSql(" delete ShareouterDoc where sourceid in ( " + deletedocidstr + " ) " ) ;
        }

        for(int i=0 ; i<deletedocids.length; i++ ) {
            DocComInfo.deleteDocInfoCache(deletedocids[i]);
        }
    }
  	
 	response.sendRedirect("docs/DocMonitor.jsp");
}

if(operation.equals("deleteworkflow")){
	
    /*这里记录下所有需要回传回去的查询参数值 End*/
    String paraStr = "fromself=1";
    String workflowid_tmp = Util.null2String(request.getParameter("workflowid"));
    String nodetype_tmp = Util.null2String(request.getParameter("nodetype"));
    String fromdate_tmp = Util.null2String(request.getParameter("fromdate"));
    String todate_tmp = Util.null2String(request.getParameter("todate"));
    String creatertype_tmp = Util.null2String(request.getParameter("creatertype"));
    String createrid_tmp = Util.null2String(request.getParameter("createrid"));
    String requestlevel_tmp = Util.null2String(request.getParameter("requestlevel"));
    String requestname_tmp = Util.null2String(request.getParameter("requestname"));
    String requestid_tmp1 = Util.null2String(request.getParameter("requestid"));
    paraStr += "&workflowid="+URLEncoder.encode(workflowid_tmp)+"&nodetype="+URLEncoder.encode(nodetype_tmp);
    paraStr += "&fromdate="+URLEncoder.encode(fromdate_tmp)+"&todate="+URLEncoder.encode(todate_tmp);
    paraStr += "&creatertype="+URLEncoder.encode(creatertype_tmp)+"&createrid="+URLEncoder.encode(createrid_tmp);
    paraStr += "&requestlevel="+URLEncoder.encode(requestlevel_tmp)+"&requestname="+URLEncoder.encode(requestname_tmp);
    paraStr += "&requestid="+URLEncoder.encode(requestid_tmp1);
    /*这里记录下所有需要回传回去的查询参数值 End*/
    
    String deleteworkflowidstr=Util.null2String(request.getParameter("multiRequestIds"));
    
    String TEMPdeleteworkflowidstr = "";//实际可以删除的请求
    //参照workflowmonitor.jsp中的逻辑
    String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
    if(CurrentUser.equals("")) CurrentUser = ""+user.getUID();

      if( !deleteworkflowidstr.equals("") ) {
		String   deleteworkflowidstrsre=deleteworkflowidstr.substring(0,deleteworkflowidstr.length()-1);
		String[] deleteRequestIdsstr = Util.TokenizerString2(deleteworkflowidstrsre, ",");
        for(int k=0;k<deleteRequestIdsstr.length;k++){
        String  delpop = (String)deleteRequestIdsstr[k];
        
        String candeleteflag = "0";//是否可以删除该类流程
        RecordSet.executeSql("select isdelete from workflow_monitor_bound a, workflow_requestbase b where a.workflowid=b.workflowid and a.monitorhrmid="+CurrentUser+" and a.isdelete='1' and b.requestid="+delpop);
        if(RecordSet.next()) candeleteflag = RecordSet.getString("isdelete");
        if(candeleteflag.equals("0")) continue;
        TEMPdeleteworkflowidstr += delpop+",";
        
		//System.out.print(Util.getIntValue(delpop)+"******");
        //删除流程提醒信息
		PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(delpop),0);
		//System.out.print(Util.getIntValue(delpop)+"******");
		PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(delpop),1);
        PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(delpop),10);
      }
	  }
	  deleteworkflowidstr = TEMPdeleteworkflowidstr;//实际可以删除的请求
    if( !deleteworkflowidstr.equals("") ) {
        deleteworkflowidstr=deleteworkflowidstr.substring(0,deleteworkflowidstr.length()-1);
        /*-------------xwj for td2831 on 20050921 begin----- */
        ArrayList delDocIds = new ArrayList();
        String[] deleteDocIds = null;
        String delDocid = "";
        String delRqid = "";
        String uploadfieldname = "";
        String[] deleteRequestIds = Util.TokenizerString2(deleteworkflowidstr, ",");
        
		//记录删除日志
        for(int i=0;i<deleteRequestIds.length;i++){
        	String temprequestid = (String)deleteRequestIds[i];
        	RecordSet.executeSql("select requestname from workflow_requestbase where requestid="+temprequestid);
        	RecordSet.next();
        	String temprequestname = RecordSet.getString("requestname");
        	
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(temprequestid));
			SysMaintenanceLog.setRelatedName(temprequestname);
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("delete workflow_currentoperator where requestid="+temprequestid+
											";delete workflow_form where requestid="+temprequestid+
											";delete workflow_formdetail where requestid="+temprequestid+
											";delete workflow_requestLog where requestid="+temprequestid+
											";delete workflow_requestViewLog where id="+temprequestid+
											";delete workflow_requestbase where requestid="+temprequestid);
			SysMaintenanceLog.setOperateItem("85");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
	    
	    Calendar today = Calendar.getInstance();
	    String formatdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH)+1,2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	    String formattime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" + Util.add0(today.get(Calendar.MINUTE), 2) + ":" +Util.add0(today.get(Calendar.SECOND), 2);
			RecordSet.executeSql("insert into WorkFlow_Monitor_Bound(monitorhrmid,workflowid,operatordate,operatortime,isview) values('"+user.getUID()+"','"+Util.getIntValue(temprequestid)+"','"+formatdate+"','"+formattime+"',0)");
	        
        }
		
        monitor.delWfAcc(deleteworkflowidstr);
      
        /*删除流程，如果是资产申请流程，则在删除流程后解冻资产*/
        RecordSet.executeSql(" select r.requestid,r.workflowid,r.currentnodetype from workflow_requestbase r,workflow_base b where requestid in ( " + deleteworkflowidstr + " ) and r.workflowid=b.id and b.formid=19 and b.isbill=1" ) ;
        RecordSet RecordSet2=new RecordSet();
        while(RecordSet.next()){
        	String workflowid=RecordSet.getString("workflowid"); //流程id
        	String requestid=RecordSet.getString("requestid");   //流程请求id
        	String workflowtype = WorkflowComInfo.getWorkflowtype(workflowid);   //工作流种类
        	String currentnodetype=RecordSet.getString("currentnodetype"); //当前节点状态
        	//流程为资产申请流程且不为 3归档节点 0 创建节点
        	if(!"0".equals(currentnodetype)&&!"3".equals(currentnodetype)){
        		String sql=" select b.* from workflow_form w,bill_CptFetchDetail b where w.requestid ="+requestid+" and w.billid=b.cptfetchid";
        		RecordSet2.executeSql(sql) ;
        		RecordSet RecordSet3=new RecordSet();
        		while(RecordSet2.next()){
        		String capitalid=RecordSet2.getString("capitalid");
        		float old_number_n = 0.0f;
				float old_frozennum = 0.0f;
				float new_frozennum = 0.0f;
				RecordSet3.executeSql("select number_n as old_number_n from bill_CptFetchDetail where cptfetchid = (select id from bill_CptFetchMain where requestid="+requestid+") and capitalid="+capitalid);
				if(RecordSet3.next())	old_number_n = RecordSet3.getFloat("old_number_n");
				RecordSet3.executeSql("select frozennum as old_frozennum from CptCapital where id="+capitalid);
				if(RecordSet3.next()) old_frozennum = RecordSet3.getFloat("old_frozennum");
				 new_frozennum = old_frozennum - old_number_n;
				 RecordSet3.executeSql("update CptCapital set frozennum="+new_frozennum+" where id="+capitalid);
        		}
        	}
        }
        /*-------------xwj for td2831 on 20050921 end----- */

        if( !deleteworkflowidstr.equals("") ) {
            wflm.WorkflowDel(deleteworkflowidstr+"");
            RecordSet.executeSql(" delete workflow_currentoperator where requestid in ( " + deleteworkflowidstr + " ) " ) ;
            RecordSet.executeSql(" delete workflow_form where requestid in ( " + deleteworkflowidstr + " ) " ) ;
            RecordSet.executeSql(" delete workflow_formdetail where requestid in ( " + deleteworkflowidstr + " ) " ) ;
            RecordSet.executeSql(" delete workflow_requestLog where requestid in ( " + deleteworkflowidstr + " ) " ) ;
            RecordSet.executeSql(" delete workflow_requestViewLog where id in ( " + deleteworkflowidstr + " ) " ) ;
            RecordSet.executeSql(" delete workflow_requestbase where requestid in ( " + deleteworkflowidstr + " ) " ) ;
	        RecordSet.executeSql(" delete FnaExpenseInfo where requestid in ( " + deleteworkflowidstr + " ) " ) ;//删除财务相关的数据
        }
    }
	
    response.sendRedirect("workflow/WorkflowMonitor.jsp?"+paraStr);
}
 
//2004-7-12 modify by Evan:增加客户删除功能
if(operation.equals("deletecrm")){
	if(!HrmUserVarify.checkUserRight("EditCustomer:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String deletecrmid = Util.null2String(request.getParameter("deletecrmid"));
	
	ArrayList deletecrmids = Util.TokenizerString(deletecrmid,",");
	String deletecrmidstr = "" ;
    if( deletecrmids != null ) {
        for(int i=0 ; i<deletecrmids.size(); i++ ) {
            if(deletecrmidstr.equals("")) deletecrmidstr = (String)deletecrmids.get(i) ;
            else deletecrmidstr += "," + (String)deletecrmids.get(i) ;
        }
        if( !deletecrmidstr.equals("") ) {

           RecordSet.executeSql("update CRM_CustomerInfo set deleted='1' where id in( "+deletecrmidstr+")");
		   RecordSet.executeSql("delete from CRM_Contract where crmId in( "+deletecrmidstr+")");
        }
        for(int i=0 ; i<deletecrmids.size(); i++ ) {
            String Tcrmid=(String)deletecrmids.get(i);
            CustomerInfoComInfo.deleteCustomerInfoCache(Tcrmid);
            SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(Tcrmid));
			SysMaintenanceLog.setRelatedName(CustomerInfoComInfo.getCustomerInfoname(Tcrmid));
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("update CRM_CustomerInfo set deleted='1' where id ="+Tcrmid);
			SysMaintenanceLog.setOperateItem("99");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
        }
    }

 	response.sendRedirect("crm/CustomerMonitor.jsp");
}

//2006-11-29 modify by yshxu:增加协作监控删除功能
if(operation.equals("deletecowork")){
	if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String deletecoworkid = Util.null2String(request.getParameter("deletecoworkid"));
    
	ArrayList deletecoworkids = Util.TokenizerString(deletecoworkid,",");
	String deletecoworkidstr = "" ;
    if( deletecoworkids != null ) {
        for(int i=0 ; i<deletecoworkids.size(); i++ ) {
        	String tempcoworkid = (String)deletecoworkids.get(i);
            RecordSet.executeSql("select name from cowork_items where id="+tempcoworkid);
			PoppupRemindInfoUtil.deletePoppupRemindInfo(Util.getIntValue(tempcoworkid),9);
		
            RecordSet.next();
			String tempcoworkname = RecordSet.getString("name");
			
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(tempcoworkid));
			SysMaintenanceLog.setRelatedName(tempcoworkname);
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("delete from cowork_items where id="+tempcoworkid+";delete from cowork_discuss where coworkid="+tempcoworkid);
			SysMaintenanceLog.setOperateItem("90");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
            
            if(deletecoworkidstr.equals("")) {
            	deletecoworkidstr = tempcoworkid;
            } else {
            	deletecoworkidstr += "," + tempcoworkid ;
            }
        }
        //删除协作内容和协作讨论
        if( !deletecoworkidstr.equals("") ) {
		  //PoppupRemindInfoUtil.updatePoppupRemindInfo(RecordSetDelRq.getInt(1),9,RecordSetDelRq.getString(2),Util.getIntValue(delRqid,0));

           RecordSet.executeSql("delete from cowork_items where id in( "+deletecoworkidstr+")");
           RecordSet.executeSql("delete from cowork_discuss where coworkid in( "+deletecoworkidstr+")");
        }
    }
	//更新协作提醒信息的数量
	RecordSet.executeProc("reset_CoworkRemind","");

 	response.sendRedirect("cowork/CoworkMonitor.jsp");
}
//结束协作
if(operation.equals("endCowork")){
	if(!HrmUserVarify.checkUserRight("collaborationmanager:edit",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String coworkid = Util.null2String(request.getParameter("coworkids"));
	//协作提醒
	ArrayList coworkids = Util.TokenizerString(coworkid,",");
	
	String remark = SystemEnv.getHtmlLabelName(19076,user.getLanguage());
	char flag = 2;
	int userId=user.getUID();
	Date now=new Date();
	SimpleDateFormat date=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat time=new SimpleDateFormat("HH:mm:ss");
	String createdate=date.format(now);
	String createtime=time.format(now);
	for(int k=0;k<coworkids.size();k++){
		String tempCoworkid=(String)coworkids.get(k);
		//协作是打开的，才进行结束操作
		RecordSet.executeSql("select status from cowork_items where status=1 and id ="+tempCoworkid);
		if(RecordSet.next()){
			List parterList=CoworkShareManager.getShareList("parter",tempCoworkid);//协作参与人
			
			//协作结束讨论记录
		 	String Proc=tempCoworkid+flag+userId+flag+createdate+flag+createtime+flag+remark+flag+""+flag+""+flag+""+flag+""+flag+""+flag+""+flag+"0"+flag+"0";
			RecordSet.executeProc("cowork_discuss_insert",Proc);
			
			//协作结束提醒
			for(int i=0;i<parterList.size();i++){
		        PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue((String)parterList.get(i)),9,"0",Util.getIntValue(tempCoworkid));	
			}
			//结束协作
			RecordSet.executeSql("update cowork_items set status=2 where id ="+tempCoworkid);
		}
	}
	response.sendRedirect("cowork/CoworkMonitor.jsp");
}

/**
 * 增加项目监控删除功能
 * @author hubo
 * @date 2007-5-30
 */
if(operation.equals("deleteproj")){
	if(!HrmUserVarify.checkUserRight("EditProject:Delete",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
	String ids = Util.null2String(request.getParameter("deleteprojid"));
	if(ids.endsWith(",")){
		ids = ids.substring(0,ids.length()-1);
	}

	String[] _ids = Util.TokenizerString2(ids, ",");
	String tempprjid = "";
	String tempprjname = "";
	for(int i=0;i<_ids.length;i++){
		tempprjid = _ids[i];
		//RecordSet.executeSql("select name from prj_projectinfo where id="+tempprjid);
		//RecordSet.next();
		//tempprjname = RecordSet.getString("name");
		tempprjname = prjComInfo.getProjectInfoname(tempprjid);
		
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(tempprjid));
		SysMaintenanceLog.setRelatedName(tempprjname);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("delete from prj_projectinfo where id="+tempprjid+"");
		SysMaintenanceLog.setOperateItem("95");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
	}

	//删除项目
    RecordSet.executeSql("DELETE FROM Prj_ProjectInfo WHERE id IN ("+ids+")");
	//删除项目任务
	RecordSet.executeSql("DELETE FROM Prj_TaskProcess WHERE prjid IN ("+ids+")");
	//删除项目日程
	RecordSet.executeSql("DELETE FROM WorkPlan WHERE type_n=2 AND projectid IN ("+ids+")");
	return;
}
%>