<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<body>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%
RTXConfig rtxconfig = new RTXConfig();
String temV = rtxconfig.getPorp(rtxconfig.CUR_SMS_SERVER_IS_VALID);
boolean valid = false;
if (temV != null && temV.equalsIgnoreCase("true")) {
	valid = true;
} else {
	valid = false;
}
Prop prop = Prop.getInstance();
String ifchangstatus=Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String overtimeset = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.overtime"));

int design = Util.getIntValue(request.getParameter("design"),0);
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String isbill = "";
int formid=0;
WFManager.setWfid(wfid);
WFManager.getWfInfo();
formid = WFManager.getFormid();
isbill = WFManager.getIsBill();
String submitName7 = Util.null2String(request.getParameter("submitName7"));
String submitName8 = Util.null2String(request.getParameter("submitName8"));
String submitName9 = Util.null2String(request.getParameter("submitName9"));
String subnobackName7 = Util.null2String(request.getParameter("subnobackName7"));
String subnobackName8 = Util.null2String(request.getParameter("subnobackName8"));
String subnobackName9 = Util.null2String(request.getParameter("subnobackName9"));
String subbackName7 = Util.null2String(request.getParameter("subbackName7"));
String subbackName8 = Util.null2String(request.getParameter("subbackName8"));
String subbackName9 = Util.null2String(request.getParameter("subbackName9"));
String forwardName7 = Util.null2String(request.getParameter("forwardName7"));
String forwardName8 = Util.null2String(request.getParameter("forwardName8"));
String forwardName9 = Util.null2String(request.getParameter("forwardName9"));
String saveName7 = Util.null2String(request.getParameter("saveName7"));
String saveName8 = Util.null2String(request.getParameter("saveName8"));
String saveName9 = Util.null2String(request.getParameter("saveName9"));
String rejectName7 = Util.null2String(request.getParameter("rejectName7"));
String rejectName8 = Util.null2String(request.getParameter("rejectName8"));
String rejectName9 = Util.null2String(request.getParameter("rejectName9"));
String forsubName7 = Util.null2String(request.getParameter("forsubName7"));
String forsubName8 = Util.null2String(request.getParameter("forsubName8"));
String forsubName9 = Util.null2String(request.getParameter("forsubName9"));
String forsubnobackName7 = Util.null2String(request.getParameter("forsubnobackName7"));
String forsubnobackName8 = Util.null2String(request.getParameter("forsubnobackName8"));
String forsubnobackName9 = Util.null2String(request.getParameter("forsubnobackName9"));
String forsubbackName7 = Util.null2String(request.getParameter("forsubbackName7"));
String forsubbackName8 = Util.null2String(request.getParameter("forsubbackName8"));
String forsubbackName9 = Util.null2String(request.getParameter("forsubbackName9"));
String ccsubName7 = Util.null2String(request.getParameter("ccsubName7"));
String ccsubName8 = Util.null2String(request.getParameter("ccsubName8"));
String ccsubName9 = Util.null2String(request.getParameter("ccsubName9"));
String ccsubnobackName7 = Util.null2String(request.getParameter("ccsubnobackName7"));
String ccsubnobackName8 = Util.null2String(request.getParameter("ccsubnobackName8"));
String ccsubnobackName9 = Util.null2String(request.getParameter("ccsubnobackName9"));
String ccsubbackName7 = Util.null2String(request.getParameter("ccsubbackName7"));
String ccsubbackName8 = Util.null2String(request.getParameter("ccsubbackName8"));
String ccsubbackName9 = Util.null2String(request.getParameter("ccsubbackName9"));
String newWFName7 = Util.null2String(request.getParameter("newWFName7"));
String newWFName8 = Util.null2String(request.getParameter("newWFName8"));
String newWFName9 = Util.null2String(request.getParameter("newWFName9"));
String newSMSName7 = Util.null2String(request.getParameter("newSMSName7"));
String newSMSName8 = Util.null2String(request.getParameter("newSMSName8"));
String newSMSName9 = Util.null2String(request.getParameter("newSMSName9"));
String newOverTimeName7 = Util.null2String(request.getParameter("newOverTimeName7"));
String newOverTimeName8 = Util.null2String(request.getParameter("newOverTimeName8"));
String newOverTimeName9 = Util.null2String(request.getParameter("newOverTimeName9"));
String hasovertime = Util.null2String(request.getParameter("hasovertime"));
String toAllNodeOverTime = Util.null2String(request.getParameter("toAllNodeOverTime"));    
String customMessage = Util.null2String(request.getParameter("customMessage"));
String haswfrm = Util.null2String(request.getParameter("haswfrm"));
String hassmsrm = Util.null2String(request.getParameter("hassmsrm"));
String hasnoback = Util.null2String(request.getParameter("hasnoback"));
String hasback = Util.null2String(request.getParameter("hasback"));
String hasfornoback = Util.null2String(request.getParameter("hasfornoback"));
String hasforback = Util.null2String(request.getParameter("hasforback"));
String hasccnoback = Util.null2String(request.getParameter("hasccnoback"));
String hasccback = Util.null2String(request.getParameter("hasccback"));
String toAllNodeWF = Util.null2String(request.getParameter("toAllNodeWF"));
String toAllNodeSMS = Util.null2String(request.getParameter("toAllNodeSMS"));
String usecustomsender = Util.null2String(request.getParameter("usecustomsender"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"), 0);
int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
int isshowinwflog = Util.getIntValue(request.getParameter("isshowinwflog"), 0);

int flag = 0;

String src = Util.null2String(request.getParameter("src"));

if(src.equals("")){
	RecordSet.executeSql("select * from workflow_nodecustomrcmenu where wfid="+wfid+" and nodeid="+nodeid);
	if(RecordSet.next()){
		submitName7 = Util.null2String(RecordSet.getString("submitName7"));
		submitName8 = Util.null2String(RecordSet.getString("submitName8"));
		submitName9 = Util.null2String(RecordSet.getString("submitName9"));
		subnobackName7 = Util.null2String(RecordSet.getString("subnobackName7"));
		subnobackName8 = Util.null2String(RecordSet.getString("subnobackName8"));
		subnobackName9 = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName7 = Util.null2String(RecordSet.getString("subbackName7"));
		subbackName8 = Util.null2String(RecordSet.getString("subbackName8"));
		subbackName9 = Util.null2String(RecordSet.getString("subbackName9"));
		forwardName7 = Util.null2String(RecordSet.getString("forwardName7"));
		forwardName8 = Util.null2String(RecordSet.getString("forwardName8"));
		forwardName9 = Util.null2String(RecordSet.getString("forwardName9"));
		saveName7 = Util.null2String(RecordSet.getString("saveName7"));
		saveName8 = Util.null2String(RecordSet.getString("saveName8"));
		saveName9 = Util.null2String(RecordSet.getString("saveName9"));
		rejectName7 = Util.null2String(RecordSet.getString("rejectName7"));
		rejectName8 = Util.null2String(RecordSet.getString("rejectName8"));
		rejectName9 = Util.null2String(RecordSet.getString("rejectName9"));
		forsubName7 = Util.null2String(RecordSet.getString("forsubName7"));
		forsubName8 = Util.null2String(RecordSet.getString("forsubName8"));
		forsubName9 = Util.null2String(RecordSet.getString("forsubName9"));
		forsubnobackName7 = Util.null2String(RecordSet.getString("forsubnobackName7"));
		forsubnobackName8 = Util.null2String(RecordSet.getString("forsubnobackName8"));
		forsubnobackName9 = Util.null2String(RecordSet.getString("forsubnobackName9"));
		forsubbackName7 = Util.null2String(RecordSet.getString("forsubbackName7"));
		forsubbackName8 = Util.null2String(RecordSet.getString("forsubbackName8"));
		forsubbackName9 = Util.null2String(RecordSet.getString("forsubbackName9"));
		ccsubName7 = Util.null2String(RecordSet.getString("ccsubName7"));
		ccsubName8 = Util.null2String(RecordSet.getString("ccsubName8"));
		ccsubName9 = Util.null2String(RecordSet.getString("ccsubName9"));
		ccsubnobackName7 = Util.null2String(RecordSet.getString("ccsubnobackName7"));
		ccsubnobackName8 = Util.null2String(RecordSet.getString("ccsubnobackName8"));
		ccsubnobackName9 = Util.null2String(RecordSet.getString("ccsubnobackName9"));
		ccsubbackName7 = Util.null2String(RecordSet.getString("ccsubbackName7"));
		ccsubbackName8 = Util.null2String(RecordSet.getString("ccsubbackName8"));
		ccsubbackName9 = Util.null2String(RecordSet.getString("ccsubbackName9"));
		newWFName7 = Util.null2String(RecordSet.getString("newWFName7"));
		newWFName8 = Util.null2String(RecordSet.getString("newWFName8"));
		newWFName9 = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName7 = Util.null2String(RecordSet.getString("newSMSName7"));
		newSMSName8 = Util.null2String(RecordSet.getString("newSMSName8"));
		newSMSName9 = Util.null2String(RecordSet.getString("newSMSName9"));
		customMessage = Util.null2String(RecordSet.getString("customMessage"));
		haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
		hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
		hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
		hasback = Util.null2String(RecordSet.getString("hasback"));
		hasfornoback = Util.null2String(RecordSet.getString("hasfornoback"));
		hasforback = Util.null2String(RecordSet.getString("hasforback"));
		hasccnoback = Util.null2String(RecordSet.getString("hasccnoback"));
		hasccback = Util.null2String(RecordSet.getString("hasccback"));
		usecustomsender = Util.null2String(RecordSet.getString("usecustomsender"));
		workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
		fieldid = Util.getIntValue(RecordSet.getString("fieldid"), 0);
        newOverTimeName7 = Util.null2String(RecordSet.getString("newOverTimeName7"));
		newOverTimeName8 = Util.null2String(RecordSet.getString("newOverTimeName8"));
		newOverTimeName9 = Util.null2String(RecordSet.getString("newOverTimeName9"));
        hasovertime = Util.null2String(RecordSet.getString("hasovertime"));
        isshowinwflog = Util.getIntValue(RecordSet.getString("isshowinwflog"),0);
	}
}

if(workflowid == 0){
	haswfrm = "";
}
if(!"1".equals(haswfrm)){
	workflowid = 0;
	newWFName7 = "";
	newWFName8 = "";
	newWFName9 = "";
}
if(!"1".equals(hassmsrm)){
	fieldid = 0;
	newSMSName7 = "";
	newSMSName8 = "";
	newSMSName9 = "";
	customMessage = "";
	usecustomsender = "";
}
if(!"1".equals(hasnoback)){
	subnobackName7 = "";
	subnobackName8 = "";
	subnobackName9 = "";
}
if(!"1".equals(hasback)){
	subbackName7 = "";
	subbackName8 = "";
	subbackName9 = "";
}
if(!"1".equals(hasfornoback)){
	forsubnobackName7 = "";
	forsubnobackName8 = "";
	forsubnobackName9 = "";
}
if(!"1".equals(hasforback)){
	forsubbackName7 = "";
	forsubbackName8 = "";
	forsubbackName9 = "";
}
if(!"1".equals(hasccnoback)){
	ccsubnobackName7 = "";
	ccsubnobackName8 = "";
	ccsubnobackName9 = "";
}
if(!"1".equals(hasccback)){
	ccsubbackName7 = "";
	ccsubbackName8 = "";
	ccsubbackName9 = "";
}
if(!"1".equals(hasovertime)){
	newOverTimeName7 = "";
	newOverTimeName8 = "";
	newOverTimeName9 = "";
}
String isTriDiffWorkflow=null;
RecordSet.executeSql("select isTriDiffWorkflow from workflow_base where id="+wfid);
if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
}
if(!"1".equals(isTriDiffWorkflow)){
	isTriDiffWorkflow="0";
}
String uovertime_sql = "update workflow_nodecustomrcmenu set newOverTimeName7='"+newOverTimeName7+"', newOverTimeName8='"+newOverTimeName8+"', newOverTimeName9='"+newOverTimeName9+"', hasovertime='"+hasovertime+"' where wfid="+wfid;
String uwf_sql = "update workflow_nodecustomrcmenu set newWFName7='"+newWFName7+"', newWFName8='"+newWFName8+"', newWFName9='"+newWFName9+"', workflowid="+workflowid+", haswfrm='"+haswfrm+"' where wfid="+wfid;
String usms_sql = "update workflow_nodecustomrcmenu set newSMSName7='"+newSMSName7+"', newSMSName8='"+newSMSName8+"', newSMSName9='"+newSMSName9+"', customMessage='"+customMessage+"', fieldid="+fieldid+", usecustomsender='"+usecustomsender+"', hassmsrm='"+hassmsrm+"' where wfid="+wfid;
String sub_sql1 = "submitName7,submitName8,submitName9,forsubName7,forsubName8,forsubName9,ccsubName7,ccsubName8,ccsubName9,";
String sub_sql2 = "'"+submitName7+"','"+submitName8+"','"+submitName9+"','"+forsubName7+"','"+forsubName8+"','"+forsubName9+"','"+ccsubName7+"','"+ccsubName8+"','"+ccsubName9+"',";
if(!"".equals(ifchangstatus)){
	sub_sql1 = "subnobackName7,subnobackName8,subnobackName9,subbackName7,subbackName8,subbackName9,forsubnobackName7,forsubnobackName8,forsubnobackName9,forsubbackName7,forsubbackName8,forsubbackName9,ccsubnobackName7,ccsubnobackName8,ccsubnobackName9,ccsubbackName7,ccsubbackName8,ccsubbackName9,hasnoback,hasback,hasfornoback,hasforback,hasccnoback,hasccback,";
	sub_sql2 = "'"+subnobackName7+"','"+subnobackName8+"','"+subnobackName9+"','"+subbackName7+"','"+subbackName8+"','"+subbackName9+"','"+forsubnobackName7+"','"+forsubnobackName8+"','"+forsubnobackName9+"','"+forsubbackName7+"','"+forsubbackName8+"','"+forsubbackName9+"','"+ccsubnobackName7+"','"+ccsubnobackName8+"','"+ccsubnobackName9+"','"+ccsubbackName7+"','"+ccsubbackName8+"','"+ccsubbackName9+"','"+hasnoback+"','"+hasback+"','"+hasfornoback+"','"+hasforback+"','"+hasccnoback+"','"+hasccback+"',";
}
String i_sql = "insert into workflow_nodecustomrcmenu (wfid,nodeid,"+sub_sql1+"forwardName7,forwardName8,forwardName9,saveName7,saveName8,saveName9,rejectName7,rejectName8,rejectName9,newWFName7,newWFName8,newWFName9,newSMSName7,newSMSName8,newSMSName9,customMessage,usecustomsender,workflowid,fieldid,haswfrm,hassmsrm,newOverTimeName7,newOverTimeName8,newOverTimeName9,hasovertime) values"+
"("+wfid+","+nodeid+","+sub_sql2+"'"+forwardName7+"','"+forwardName8+"','"+forwardName9+"','"+saveName7+"','"+saveName8+"','"+saveName9+"','"+rejectName7+"', '"+rejectName8+"', '"+rejectName9+"','"+ newWFName7+"', '"+newWFName8+"', '"+newWFName9+"', '"+newSMSName7+"', '"+newSMSName8+"', '"+newSMSName9+"', '"+customMessage+"', '"+usecustomsender+"', "+workflowid+", "+fieldid+", '"+haswfrm+"', '"+hassmsrm+"', '"+newOverTimeName7+"', '"+newOverTimeName8+"', '"+newOverTimeName9+"', '"+hasovertime+"')";
String d_sql = "delete from workflow_nodecustomrcmenu where nodeid="+nodeid +" and wfid=" +wfid;
if((!"".equals(forwardName7) || !"".equals(forwardName8)|| !"".equals(forwardName9) || !"".equals(saveName7) || !"".equals(saveName8) || !"".equals(saveName9) || !"".equals(rejectName7) || !"".equals(rejectName8)|| !"".equals(rejectName9) || "1".equals(haswfrm) || "1".equals(hassmsrm) || "1".equals(hasnoback) || "1".equals(hasback) || "1".equals(hasfornoback) || "1".equals(hasforback) || "1".equals(hasccnoback) || "1".equals(hasccback) || "1".equals(hasovertime)) && !"".equals(ifchangstatus)){
	flag = 1;
}else if((!"".equals(forwardName7) || !"".equals(forwardName8)|| !"".equals(forwardName9) || !"".equals(saveName7) || !"".equals(saveName8)|| !"".equals(saveName9) || !"".equals(rejectName7) || !"".equals(rejectName8)|| !"".equals(rejectName9) || !"".equals(submitName7) || !"".equals(submitName8)|| !"".equals(submitName9) || !"".equals(forsubName7) || !"".equals(forsubName8)|| !"".equals(forsubName9) || !"".equals(ccsubName7) || !"".equals(ccsubName8)|| !"".equals(ccsubName9) || "1".equals(haswfrm) || "1".equals(hassmsrm) || "1".equals(hasovertime)) && "".equals(ifchangstatus)){
	flag = 1;
}
if(src.equals("save")){
	RecordSet.executeSql(d_sql);
	if((!"".equals(forwardName7) || !"".equals(forwardName8)|| !"".equals(forwardName9) || !"".equals(saveName7) || !"".equals(saveName8)|| !"".equals(saveName9) || !"".equals(rejectName7) || !"".equals(rejectName8)|| !"".equals(rejectName9) || "1".equals(haswfrm) || "1".equals(hassmsrm) || "1".equals(hasnoback) || "1".equals(hasback) || "1".equals(hasfornoback) || "1".equals(hasforback) || "1".equals(hasccnoback) || "1".equals(hasccback) || "1".equals(hasovertime)) && !"".equals(ifchangstatus)){
		//System.out.println(i_sql);
		RecordSet.executeSql(i_sql);
	}else if((!"".equals(forwardName7) || !"".equals(forwardName8) || !"".equals(forwardName9) || !"".equals(saveName7) || !"".equals(saveName8)|| !"".equals(saveName9) || !"".equals(rejectName7) || !"".equals(rejectName8)|| !"".equals(rejectName9) || !"".equals(submitName7) || !"".equals(submitName8)|| !"".equals(submitName9) || !"".equals(forsubName7) || !"".equals(forsubName8)|| !"".equals(forsubName9) || !"".equals(ccsubName7) || !"".equals(ccsubName8)|| !"".equals(ccsubName9) || "1".equals(haswfrm) || "1".equals(hassmsrm) || "1".equals(hasovertime)) && "".equals(ifchangstatus)){
		//System.out.println(i_sql);
		RecordSet.executeSql(i_sql);
	}
	if("1".equals(toAllNodeWF)){
		RecordSet.execute(uwf_sql);
		if("1".equals(haswfrm)){
			rs1.execute("select nodeid from workflow_flownode fn where nodeid not in (select nodeid from workflow_nodecustomrcmenu rm where rm.wfid="+wfid+") and workflowid="+wfid);
			while(rs1.next()){
				int t_nodeid = Util.getIntValue(rs1.getString("nodeid"), 0);
				if(t_nodeid != 0){
					RecordSet.execute("insert into workflow_nodecustomrcmenu(wfid,nodeid,newWFName7,newWFName8,newWFName9,workflowid,haswfrm) values("+wfid+","+t_nodeid+", '"+newWFName7+"', '"+newWFName8+"', '"+newWFName9+"', "+workflowid+", '"+haswfrm+"')");
				}
			}
		}
	}
	if("1".equals(toAllNodeSMS)){
		RecordSet.execute(usms_sql);
		if("1".equals(hassmsrm)){
			rs1.execute("select nodeid from workflow_flownode fn where nodeid not in (select nodeid from workflow_nodecustomrcmenu rm where rm.wfid="+wfid+") and workflowid="+wfid);
			while(rs1.next()){
				int t_nodeid = Util.getIntValue(rs1.getString("nodeid"), 0);
				if(t_nodeid != 0){
					RecordSet.execute("insert into workflow_nodecustomrcmenu(wfid,nodeid,newSMSName7,newSMSName8,newSMSName9,customMessage,usecustomsender,fieldid,hassmsrm) values("+wfid+","+t_nodeid+", '"+newSMSName7+"', '"+newSMSName8+"', '"+newSMSName9+"', '"+customMessage+"', '"+usecustomsender+"', "+fieldid+", '"+hassmsrm+"')");
				}
			}
		}
	}
    if("1".equals(toAllNodeOverTime)){
		RecordSet.execute(uovertime_sql);
		if("1".equals(hasovertime)){
			rs1.execute("select nodeid from workflow_flownode fn where nodeid not in (select nodeid from workflow_nodecustomrcmenu rm where rm.wfid="+wfid+") and workflowid="+wfid);
			while(rs1.next()){
				int t_nodeid = Util.getIntValue(rs1.getString("nodeid"), 0);
				if(t_nodeid != 0){
					RecordSet.execute("insert into workflow_nodecustomrcmenu(wfid,nodeid,newOverTimeName7,newOverTimeName8,newOverTimeName9,hasovertime) values("+wfid+","+t_nodeid+", '"+newOverTimeName7+"', '"+newOverTimeName8+"', '"+newOverTimeName9+"', '"+hasovertime+"')");
				}
			}
		}
	}
	//System.out.println("t_sql = "  + t_sql);
    String subwfSetTableName="Workflow_SubwfSet";
	if("1".equals(isTriDiffWorkflow)){
		subwfSetTableName="Workflow_TriDiffWfDiffField";
	}

	List subwfSetIdList=new ArrayList();
	RecordSet.executeSql("select id from "+subwfSetTableName+" where mainWorkflowId="+wfid+" and triggerNodeId="+nodeid+" and triggerType='2'");
	while(RecordSet.next()){
		subwfSetIdList.add(Util.null2String(RecordSet.getString("id")));
	}

	int subwfSetId=0;
	int buttonNameId=0;
	String triSubwfName7=null;
	String triSubwfName8=null;
	String triSubwfName9=null;
	for(int i=0;i<subwfSetIdList.size();i++){
		subwfSetId=Util.getIntValue((String)subwfSetIdList.get(i),0);
		if(subwfSetId<=0){
			continue;
		}

		buttonNameId = Util.getIntValue(request.getParameter("buttonNameId_"+subwfSetId),0);
		triSubwfName7 = Util.null2String(request.getParameter("triSubwfName7_"+subwfSetId));
		triSubwfName8 = Util.null2String(request.getParameter("triSubwfName8_"+subwfSetId));
		triSubwfName9 = Util.null2String(request.getParameter("triSubwfName9_"+subwfSetId));

		if(!triSubwfName7.equals("")||!triSubwfName8.equals("")||!triSubwfName9.equals("")){
			flag=1;
		}
		
		if(buttonNameId>0){
			RecordSet.executeSql("update Workflow_TriSubwfButtonName set triSubwfName7='"+triSubwfName7+"',triSubwfName8='"+triSubwfName8+"',triSubwfName9='"+triSubwfName9+"'  where id="+buttonNameId);
		}else if(!triSubwfName7.equals("")||!triSubwfName8.equals("")||!triSubwfName9.equals("")){
			RecordSet.executeSql("insert into Workflow_TriSubwfButtonName(workflowId,nodeId,subwfSetTableName,subwfSetId,triSubwfName7,triSubwfName8,triSubwfName9) values("+wfid+","+nodeid+",'"+subwfSetTableName+"',"+subwfSetId+",'"+triSubwfName7+"','"+triSubwfName8+"','"+triSubwfName9+"')");
		}
	}
	
	RecordSet.executeSql("update workflow_nodecustomrcmenu set isshowinwflog="+isshowinwflog+" where wfid="+wfid+" and nodeid="+nodeid);
}

	String sql="";
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
    if(detachable==1){
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkFlowTitleSet:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkFlowTitleSet:All", user))
            operatelevel=2;
    }
   
   if (isbill.equals("0"))
  	{
   	sql="select workflow_formfield.fieldid, workflow_fieldlable.fieldlable from workflow_formfield,workflow_fieldlable where workflow_formfield.fieldid=workflow_fieldlable.fieldid and workflow_fieldlable.formid=workflow_formfield.formid  and workflow_fieldlable.formid="+formid+" and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and langurageid="+user.getLanguage();
  	}
 	else
 	{
 	sql="select id,fieldlabel from workflow_billfield where viewtype=0 and billid="+formid;
 	}
%>

<%
    String imagefilename = "/images/hdMaintenance.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21737,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:designOnSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM NAME=SearchForm id=SearchForm STYLE="margin-bottom:0" action="showButtonNameOperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=design%>" name="design">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

		    <TABLE class=liststyle cellspacing=1>
		    <COLGROUP>
			<COL width="6%">
		    <COL width="25%">
		    <COL width="23%">
			<COL width="23%">
			<COL width="23%">
			<TR class="Title">
				<TH colspan="2"><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%></TH>
				<TH <%if(1==GCONST.getZHTWLANGUAGE()&&1!=GCONST.getENLANGUAGE()){%>colSpan=2<%}else if(1!=GCONST.getZHTWLANGUAGE()&&1==GCONST.getENLANGUAGE()){%>colSpan=2<%}else if(1==GCONST.getZHTWLANGUAGE()&&1==GCONST.getENLANGUAGE()){%>colSpan=3<%}%> align="right"><input type="checkbox" id="isshowinwflog" name="isshowinwflog" value="1" <%if(isshowinwflog==1){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(23509,user.getLanguage())%></TH>
			</TR>
			<TR class="Spacing"><TD class="Line1"  style="padding:0;" colspan=5></TD></TR>
		    <TR class="header">
				<TD><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
		        <TD><%=SystemEnv.getHtmlLabelName(21560,user.getLanguage())%></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)</TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)</TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
				<TD><%=SystemEnv.getHtmlLabelName(21557,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>)</TD>
				<%} %>
		    </TR>                                
		    <TR class="Spacing">
		        <TD class="Line1"  style="padding:0;" colSpan=5></TD>
		    </TR>
			<%if("".equals(ifchangstatus)){%>
		    <TR class="datalight">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="submitName7" value = "<%=submitName7%>"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="submitName8" value = "<%=submitName8%>"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="submitName9" value = "<%=submitName9%>"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD  class="Line"  style="padding:0;"  colSpan=5></TD>
		    </TR>
			<%}else{%>
			<TR class="datadark">
				<TD><input type=checkbox name="hasback" <%if("1".equals(hasback)){%>checked<%}%> value="1"></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21761,user.getLanguage())%>)</TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="subbackName7" value = "<%=subbackName7%>" onchange="onChangeBackName(this)"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="subbackName8" value = "<%=subbackName8%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="subbackName9" value = "<%=subbackName9%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<TR class="datalight">
				<TD><input type=checkbox name="hasnoback" <%if("1".equals(hasnoback)){%>checked<%}%> value="1"></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21762,user.getLanguage())%>)</TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="subnobackName7" value = "<%=subnobackName7%>" onchange="onChangeBackName(this)"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="subnobackName8" value = "<%=subnobackName8%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="subnobackName9" value = "<%=subnobackName9%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<%}%>
		    <TR class="datadark">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forwardName7" value = "<%=forwardName7%>"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forwardName8" value = "<%=forwardName8%>"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forwardName9" value = "<%=forwardName9%>"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
		    <TR class="datalight">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="saveName7" value = "<%=saveName7%>"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="saveName8" value = "<%=saveName8%>"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="saveName9" value = "<%=saveName9%>"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
		    <TR class="datadark">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="rejectName7" value = "<%=rejectName7%>"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="rejectName8" value = "<%=rejectName8%>"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="rejectName9" value = "<%=rejectName9%>"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<%if("".equals(ifchangstatus)){%>
			<TR class="datalight">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21097,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forsubName7" value = "<%=forsubName7%>"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forsubName8" value = "<%=forsubName8%>"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forsubName9" value = "<%=forsubName9%>"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<TR class="datadark">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21630,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="ccsubName7" value = "<%=ccsubName7%>"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="ccsubName8" value = "<%=ccsubName8%>"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="ccsubName9" value = "<%=ccsubName9%>"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<%}else{%>
			<TR class="datalight">
				<TD><input type=checkbox name="hasforback" <%if("1".equals(hasforback)){%>checked<%}%> value="1"></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21097,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21761,user.getLanguage())%>)</TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forsubbackName7" value = "<%=forsubbackName7%>" onchange="onChangeBackName(this)"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forsubbackName8" value = "<%=forsubbackName8%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forsubbackName9" value = "<%=forsubbackName9%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<TR class="datadark">
				<TD><input type=checkbox name="hasfornoback" <%if("1".equals(hasfornoback)){%>checked<%}%> value="1"></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21097,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21762,user.getLanguage())%>)</TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forsubnobackName7" value = "<%=forsubnobackName7%>" onchange="onChangeBackName(this)"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forsubnobackName8" value = "<%=forsubnobackName8%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="forsubnobackName9" value = "<%=forsubnobackName9%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<TR class="datalight">
				<TD><input type=checkbox name="hasccback" <%if("1".equals(hasccback)){%>checked<%}%> value="1"></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21630,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21761,user.getLanguage())%>)</TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="ccsubbackName7" value = "<%=ccsubbackName7%>" onchange="onChangeBackName(this)"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="ccsubbackName8" value = "<%=ccsubbackName8%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="ccsubbackName9" value = "<%=ccsubbackName9%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<TR class="datadark">
				<TD><input type=checkbox name="hasccnoback" <%if("1".equals(hasccnoback)){%>checked<%}%> value="1"></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(21630,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(21762,user.getLanguage())%>)</TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="ccsubnobackName7" value = "<%=ccsubnobackName7%>" onchange="onChangeBackName(this)"></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="ccsubnobackName8" value = "<%=ccsubnobackName8%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=14 name="ccsubnobackName9" value = "<%=ccsubnobackName9%>" onchange="onChangeBackName(this)"></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing" style="height:1px;">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
			<%}%>
<%
                StringBuffer sb=new StringBuffer();
				if("1".equals(isTriDiffWorkflow)){
					sb.append("  select  ab.id as subwfSetId,c.id as buttonNameId,c.triSubwfName7,c.triSubwfName8,c.triSubwfName9 from ")
					  .append(" ( ")
					  .append("  select a.triggerType,b.nodeType,b.nodeId,a.triggerTime,a.fieldId ,a.id ")
					  .append("    from Workflow_TriDiffWfDiffField a,workflow_flownode b ")
					  .append("   where a.triggerNodeId=b.nodeId ")
					  .append("     and a.mainWorkflowId=b.workflowId ")
					  .append("     and a.mainWorkflowId=").append(wfid)
					  .append("     and a.triggerNodeId=").append(nodeid)
					  .append("     and a.triggerType='2' ")
					  .append(" )ab left join  ")
					  .append(" ( ")
					  .append("   select *  ")
					  .append("     from Workflow_TriSubwfButtonName ")
					  .append("    where workflowId=").append(wfid)
					  .append("      and nodeId=").append(nodeid)
					  .append("      and subwfSetTableName='Workflow_TriDiffWfDiffField' ")
					  .append(" )c on ab.id=c.subwfSetId ")
					  .append(" order by ab.triggerType asc,ab.nodeType asc,ab.nodeId asc,ab.triggerTime asc,ab.fieldId asc ,ab.id asc ")
					  ;
				}else{
					sb.append("  select  ab.id as subwfSetId,c.id as buttonNameId,c.triSubwfName7,c.triSubwfName8,c.triSubwfName9 from ")
					  .append(" ( ")
					  .append("  select a.triggerType,b.nodeType,b.nodeId,a.triggerTime,a.subWorkflowId ,a.id ")
					  .append("    from Workflow_SubwfSet a,workflow_flownode b ")
					  .append("   where a.triggerNodeId=b.nodeId ")
					  .append("     and a.mainWorkflowId=b.workflowId ")
					  .append("     and a.mainWorkflowId=").append(wfid)
					  .append("     and a.triggerNodeId=").append(nodeid)
					  .append("     and a.triggerType='2' ")
					  .append(" )ab left join  ")
					  .append(" ( ")
					  .append("   select *  ")
					  .append("     from Workflow_TriSubwfButtonName ")
					  .append("    where workflowId=").append(wfid)
					  .append("      and nodeId=").append(nodeid)
					  .append("      and subwfSetTableName='Workflow_SubwfSet' ")
					  .append(" )c on ab.id=c.subwfSetId ")
					  .append(" order by ab.triggerType asc,ab.nodeType asc,ab.nodeId asc,ab.triggerTime asc,ab.subWorkflowId asc,ab.id asc ")
					  ;
				}
				int subwfSetId=0;
				int buttonNameId=0;
				String triSubwfName7=null;
				String triSubwfName8=null;
				String triSubwfName9=null;
				String trClass="datalight";
				int indexId=0;
				RecordSet.executeSql(sb.toString());
				while(RecordSet.next()){
					subwfSetId=Util.getIntValue(RecordSet.getString("subwfSetId"),0);
					buttonNameId=Util.getIntValue(RecordSet.getString("buttonNameId"),0);
					triSubwfName7=Util.null2String(RecordSet.getString("triSubwfName7"));
					triSubwfName8=Util.null2String(RecordSet.getString("triSubwfName8"));
					triSubwfName9=Util.null2String(RecordSet.getString("triSubwfName9"));

					indexId++;
%>
			<TR class="<%=trClass%>">
				<TD><input type="checkbox" checked disabled ></TD>
			    <TD><%=SystemEnv.getHtmlLabelName(22064,user.getLanguage())+indexId%></TD>
	            <input name="buttonNameId_<%=subwfSetId%>" type=hidden value="<%=buttonNameId%>">
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="triSubwfName7_<%=subwfSetId%>" value = "<%=triSubwfName7%>" ></TD>
				<%if(1==GCONST.getENLANGUAGE()){ %>
				<TD class=Field><INPUT class=InputStyle maxLength=20 size=16 name="triSubwfName8_<%=subwfSetId%>" value = "<%=triSubwfName8%>" ></TD>
				<%} %>
				<%if(1==GCONST.getZHTWLANGUAGE()){ %>
					<TD class=Field><INPUT class=InputStyle maxLength=20 size=16 name="triSubwfName9_<%=subwfSetId%>" value = "<%=triSubwfName9%>" ></TD>
				<%} %>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=5></TD>
		    </TR>
<%
					if(trClass.equals("datalight")){
					    trClass="datadark";
				    }else{
					    trClass="datalight";
					}
				}
%>
		</TABLE>
		</BR>
		<TABLE class=liststyle cellspacing=1>
		    <COLGROUP>
		    <COL width="24%">
		    <COL width="38%">
			<COL width="38%">
			<TR class="Title">
				<TH colSpan=3><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(333,user.getLanguage())%></TH></TR>
			<TR class="Spacing"><TD class="Line1"  style="padding:0;" colspan=3></TD></TR>
			<TR class="datalight">
			<TD colspan=2 align="left">
				<input type=checkbox name="haswfrm" value="1" onclick="changeHasWF(this);" <%if("1".equals(haswfrm)){%>checked<%}%>>
				<%=SystemEnv.getHtmlLabelName(1239,user.getLanguage())%>
			</TD>
			<TD>
				<input type=checkbox name="toAllNodeWF" value="1"><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%>
			</TD>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=3></TD>
		    </TR>
			<TR>
				<TD colSpan=3>
				<div id="wfdiv"style="display:<%if(!"1".equals(haswfrm)){%>none<%}%>">
				<TABLE class=liststyle cellspacing=1>
				<COLGROUP>
				<COL width="16%">
				<COL width="28%">
				<COL width="28%">
				<COL width="28%">
					<TR class="datadark" id="wftr" name="wftr">
						<TD><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></TD>
						<TD class=Field>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)<INPUT class=InputStyle maxLength=10 size=11 name="newWFName7" value = "<%=newWFName7%>"></TD>
						<%if(1==GCONST.getENLANGUAGE()){ %>
						<TD class=Field>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="newWFName8" value = "<%=newWFName8%>"></TD>
						<%} %>
						<%if(1==GCONST.getZHTWLANGUAGE()){ %>
							<TD class=Field>(<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="newWFName9" value = "<%=newWFName9%>"></TD>
						<%} %>
					</TR>
					<TR class="Spacing" id="wftr" name="wftr">
						<TD class="Line" colSpan=4></TD>
					</TR>
					<TR class="datalight" id="wftr" name="wftr"> 
						<TD class=Field align="left"><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></TD>
						<TD class=Field align="left" colspan="3">
							<button class=browser type="button" onClick="onShowWorkFlow('workflowid','workflowspan')"></button>
							<span id=workflowspan>
							<%=WorkflowComInfo.getWorkflowname(""+workflowid)%><%if(workflowid==0){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
							</span>
							<input name=workflowid type=hidden value="<%=workflowid%>">
						</TD>
					</TR>
					<TR class="datadark" id="wftr" name="wftr">
						<TD colSpan=4><B><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(21742,user.getLanguage())%></TD>
					</TR>
				</TABLE>
				</div>
				</TD>
			</TR>
			<%if(valid == true){%>
			<TR class="datalight">
			<TD colspan=2 align="left">
				<input type=checkbox name="hassmsrm" value="1" onclick="changeHasSMS(this);" <%if("1".equals(hassmsrm)){%>checked<%}%>>
				<%=SystemEnv.getHtmlLabelName(16444,user.getLanguage())%>
			</TD>
			<TD>
				<input type=checkbox name="toAllNodeSMS" value="1"><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%>
			</TD>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=3></TD>
		    </TR>
			<TR>
				<TD colSpan=3>
				<div id="smsdiv" style="display:<%if(!"1".equals(hassmsrm)){%>none<%}%>">
				<TABLE class=liststyle cellspacing=1>
				<COLGROUP>
				<COL width="16%">
				<COL width="28%">
				<COL width="28%">
				<COL width="28%">
					<TR class="datadark" id="smstr" name="smstr">
						<TD><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></TD>
						<TD class=Field>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)<INPUT class=InputStyle maxLength=10 size=11 name="newSMSName7" value = "<%=newSMSName7%>"></TD>
						<%if(1==GCONST.getENLANGUAGE()){ %>
						<TD class=Field>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="newSMSName8" value = "<%=newSMSName8%>"></TD>
						<%} %>
						<%if(1==GCONST.getZHTWLANGUAGE()){ %>
							<TD class=Field>(<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="newSMSName9" value = "<%=newSMSName9%>"></TD>
						<%} %>
					</TR>
					<TR class="Spacing" id="smstr" name="smstr">
						<TD class="Line" colSpan=4></TD>
					</TR>
					<TR class="datalight" id="smstr" name="smstr">
						<TD class=Field align="left"><%=SystemEnv.getHtmlLabelName(18908,user.getLanguage())%></TD>
						<TD class=Field align="left" colSpan=3>
							<INPUT class=InputStyle maxLength=40 size=40 name="customMessage" value = "<%=customMessage%>">
						</TD>
					</TR>
					<TR class="datadark" id="smstr" name="smstr">
						<TD class=Field align="left"><%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())%></TD>
						<TD class=Field align="left" colspan="3">
						<select name="fieldid">
							<option></option>
						<%
							String fieldid_tmp = ""+fieldid;
							RecordSet.execute(sql);
							while(RecordSet.next()){
						%>
							<option  <%if (fieldid_tmp.equals(RecordSet.getString(1))) {%>selected<%}%>  value="<%=RecordSet.getString(1)%>"><%if (isbill.equals("0")) {%><%=RecordSet.getString(2)%>
								<%}else{%>
								<%=SystemEnv.getHtmlLabelName(RecordSet.getInt(2),user.getLanguage())%>
								<%}%></option>
						<%}%>
						</select>
						</TD>
					</TR>
					<TR class="datalight" id="smstr" name="smstr">
						<TD class=Field align="left"><%=SystemEnv.getHtmlLabelName(21897,user.getLanguage())%></TD>
						<TD class=Field align="left" colSpan=3><input type=checkbox name="usecustomsender" value="1" <%if("1".equals(usecustomsender)){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(21915,user.getLanguage())%></TD>
					</TR>
					<TR class="datalight" id="smstr" name="smstr">
						<TD colSpan=4><B><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(21743,user.getLanguage())%></TD>
					</TR>
				</TABLE>
				</div>
				</TD>
			</TR>
			<%}
			if(!overtimeset.equals("")){
			%>
            <TR class="datalight">
			<TD colspan=2 align="left">
				<input type=checkbox name="hasovertime" value="1" onclick="changeHasOverTime(this);" <%if("1".equals(hasovertime)){%>checked<%}%>>
				<%=SystemEnv.getHtmlLabelName(18818,user.getLanguage())%>
			</TD>
			<TD>
				<input type=checkbox name="toAllNodeOverTime" value="1"><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%>
			</TD>
		    </TR>
		    <TR class="Spacing">
		        <TD class="Line" colSpan=3></TD>
		    </TR>
            <TR>
				<TD colSpan=3>
				<div id="overtimediv" style="display:<%if(!"1".equals(hasovertime)){%>none<%}%>">
				<TABLE class=liststyle cellspacing=1>
				<COLGROUP>
				<COL width="16%">
				<COL width="28%">
				<COL width="28%">
				<COL width="28%">
					<TR class="datadark" id="overtimetr" name="overtimetr">
						<TD><%=SystemEnv.getHtmlLabelName(17607,user.getLanguage())%></TD>
						<TD class=Field>(<%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%>)<INPUT class=InputStyle maxLength=10 size=11 name="newOverTimeName7" value = "<%=newOverTimeName7%>"></TD>
						<%if(1==GCONST.getENLANGUAGE()){ %>
						<TD class=Field>(<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="newOverTimeName8" value = "<%=newOverTimeName8%>"></TD>
						<%} %>
						<%if(1==GCONST.getZHTWLANGUAGE()){ %>
							<TD class=Field>(<%=SystemEnv.getHtmlLabelName(21866,user.getLanguage())%>)<INPUT class=InputStyle maxLength=20 size=11 name="newOverTimeName9" value = "<%=newOverTimeName9%>"></TD>
						<%} %>
					</TR>
					<TR class="datadark" id="overtimetr" name="overtimetr">
						<TD colSpan=4><B><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(22254,user.getLanguage())%></TD>
					</TR>
				</TABLE>
				</div>
				</TD>
			</TR>
            <%}%>
			</TABLE>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


</form>

</body>
</html>

<script language=javascript>
function designOnSave() {
	onSave();
}
function onSave(){
	if(checkWFid()){
		document.all("src").value="save";
		document.SearchForm.submit();
	}
}
function onChangeBackName(obj){
	var td_checkbox = obj.parentElement.parentElement.children(0).children(0);
	td_checkbox.checked = true;
}
function checkWFid(){
	var checked = document.SearchForm.haswfrm.checked;
	var flag = true;
	var workflowid = document.SearchForm.workflowid.value;
	if(checked == true){
		if(workflowid == null || workflowid == "" || workflowid == "0"){
			alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
			flag = false;
		}
	}
	return flag;
}

function changeHasOverTime(obj){
	var playType = "";
	if(obj.checked == false){
		playType = "none";
	}
	//var wfdiv = document.getElementByID("wfdiv");
	overtimediv.style.display = playType;
}

function onClose(){
	window.parent.returnValue = "<%=flag%>";
	window.parent.close();
}

function changeHasWF(obj){
	var playType = "";
	if(obj.checked == false){
		playType = "none";
	}
	//var wfdiv = document.getElementByID("wfdiv");
	wfdiv.style.display = playType;
}

function changeHasSMS(obj){
	var playType = "";
	if(obj.checked == false){
		playType = "none";
	}
	//var smsdiv = document.getElementByID("smsdiv");
	smsdiv.style.display = playType;
}
<%
if(src.equals("save")){
	if(design==0) {
%>
onClose();
<%
	}
	else {
//td 19600
		boolean bolFlag = false;
		if(flag == 1) bolFlag = true;
%>
window.parent.design_callback('showButtonNameOperate','<%=bolFlag%>');
<%
	}
	//td 19600
}	
%>
//工作流图形化确定
function designOnClose() {
//td19600
    <%
	    boolean bolFlag2 = false;
		if(flag == 1) bolFlag2 = true;
    %>
	window.parent.design_callback('showButtonNameOperate','<%=bolFlag2%>');
}
//td19600


function onShowWorkFlow(inputname, spanname){
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	if (retValue!=null){
		if (retValue.id!= ""){
			$G(spanname).innerHTML = retValue.name;
			$G(inputname).value = retValue.id;
		}else{ 
			$G(inputname).value = "";
			$G(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		}
	}
	if($G(inputname).value == null || $G(inputname).value == "" || $G(inputname).value == "0"){
		$G(spanname).innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	}
}
</script>
<!--
<script language=vbs>
Sub onShowWorkFlow(inputname, spanname)
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
	if (Not IsEmpty(retValue)) Then
		If retValue(0) <> "" Then
			document.all(spanname).innerHtml = retValue(1)
			document.all(inputname).value = retValue(0)
		Else 
			document.all(inputname).value = ""
			document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		End If
	End If
	if(IsEmpty(document.all(inputname).value) or document.all(inputname).value = "" or document.all(inputname).value = "0") then
		document.all(spanname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	end if
End Sub
</script>
-->

