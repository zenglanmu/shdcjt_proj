<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.worktask.worktask.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="RecordSet5" class="weaver.conn.RecordSet" scope="page" /> <%-- xwj for td3665 on 20060227--%>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/><!--xwj for td3450 20060112-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" /><!--xwj for td3665 20060224-->
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="SysWFLMonitor" class="weaver.system.SysWFLMonitor" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="WFCoadjutantManager" class="weaver.workflow.request.WFCoadjutantManager" scope="page" />
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
boolean isUseOldWfMode = sysInfo.isUseOldWfMode();
String isworkflowhtmldoc=Util.null2String(request.getParameter("isworkflowhtmldoc"));
%>
<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
int isonlyview = Util.getIntValue(request.getParameter("isonlyview"), 0);
%>
<script language="JavaScript">
<%if(isovertime==1){%>
        window.opener.location.href=window.opener.location.href;
<%}%>
<%if(info!=null && !"".equals(info)){

  if("ovfail".equals(info)){%>
 alert("<%=SystemEnv.getHtmlLabelName(18566,user.getLanguage())%>")
 <%}
 else if("rbfail".equals(info)){%>
 alert("<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>")
 <%}
 else{
 
 }
 }%>
</script>
<%----xwj for td3665 20060301 end---%>

<%
String isworkflowdoc = "0";//是否为公文
int seeflowdoc = Util.getIntValue(request.getParameter("seeflowdoc"),0);
boolean isnotprintmode =Util.null2String(request.getParameter("isnotprintmode")).equals("1")?true:false;
String reEdit=""+Util.getIntValue(request.getParameter("reEdit"),1);//是否为编辑
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String wfdoc = Util.null2String((String)session.getAttribute(requestid+"_wfdoc"));
String isrequest = Util.null2String(request.getParameter("isrequest")); //
String nodetypedoc=Util.null2String(request.getParameter("nodetypedoc"));
int desrequestid=0;
int wflinkno=Util.getIntValue(request.getParameter("wflinkno"));
boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;
String fromoperation=Util.null2String(request.getParameter("fromoperation"));

String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));   //从PDA登录
//TD4262 增加提示信息  开始
String src=Util.null2String(request.getParameter("src"));//进入该界面前的操作，"submit"：提交，"reject"：退回。
String isShowPrompt=Util.null2String(request.getParameter("isShowPrompt"));//是否显示提示  取值"true"或者"false"
//TD4262 增加提示信息  结束

String requestname="";      //请求名称
String requestlevel="";     //请求重要级别 0:正常 1:重要 2:紧急
String requestmark = "" ;   //请求编号
String isbill="0";          //是否单据 0:否 1:是
int creater=0;              //请求的创建人
int creatertype = 0;        //创建人类型 0: 内部用户 1: 外部用户
int deleted=0;              //请求是否删除  1:是 0或者其它 否
int billid=0 ;              //如果是单据,对应的单据表的id
String isModifyLog = "";		//是否记录表单日志 by cyril on 2008-07-09 for TD:8835
int workflowid=0;           //工作流id
String workflowtype = "" ;  //工作流种类
int formid=0;               //表单或者单据的id
int helpdocid = 0;          //帮助文档 id
String workflowname = "" ;         //工作流名称
String status = ""; //当前的操作类型
String docCategory="";//工作流目录

int lastOperator=0; //最后操作者id
String lastOperateDate="";//最后操作日期
String lastOperateTime="";//最后操作时间

int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
int nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
String nodetype=WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档

//当前流程所处节点id和类型，用于判断是否有强制归档权限TD9023
String currentnodetype = "";
int currentnodeid = 0;

boolean canview = false ;               // 是否可以查看
boolean canactive = false ;             // 是否可以对删除的工作流激活
boolean isurger=false;                  //督办人可查看
boolean wfmonitor=false;                //流程监控人
boolean haveBackright=false;            //强制收回权限
boolean haveStopright = false;			//暂停权限
boolean haveCancelright = false;		//撤销权限
boolean haveRestartright = false;		//启用权限
boolean islog=true;            			//是否记录查看日志
//boolean haveOverright=false;            //强制归档权限
int wfcurrrid=0;

String sql = "" ;
char flag = Util.getSeparator() ;
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String isSignMustInputOfThisJsp="0";
String isFormSignatureOfThisJsp="0";
rs.executeSql("select requestid from workflow_currentoperator where userid="+userid+" and usertype="+usertype+" and requestid="+requestid);
if(rs.next()){
	canview=true;
	isrequest = "0";
}
if(isrequest.equals("1")){      // 从相关工作流过来,有查看权限
    requestid=Util.getIntValue(String.valueOf(session.getAttribute("resrequestid"+wflinkno)),0);
    String realateRequest=Util.null2String(String.valueOf(session.getAttribute("relaterequest")));
	if (requestid==0)  requestid=Util.getIntValue(request.getParameter("requestid"),0);
    int tempnum_ = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
	for(int cx_=0; cx_<=tempnum_; cx_++){
		int resrequestid_ = Util.getIntValue(String.valueOf(session.getAttribute("resrequestid"+cx_)));
		if(resrequestid_ == requestid){
			desrequestid = Util.getIntValue(String.valueOf(session.getAttribute("desrequestid")),0);//父级流程ID
			rs.executeSql("select count(*) from workflow_currentoperator where userid="+userid+" and usertype="+usertype+" and requestid="+desrequestid);
		    if(rs.next()){
		        int counts=rs.getInt(1);
		        if(counts>0){
		           canview=true;
		           break;
		        }
		    }
		}
	}
    session.setAttribute(requestid+"wflinkno",wflinkno+"");//解决相关流程，不是流程操作人无权限打印的问题    
}
int currentstatus = -1;//当前流程状态(对应流程暂停、撤销而言)
// 查询请求的相关工作流基本信息
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
if(RecordSet.next()){
    status  = Util.null2String(RecordSet.getString("status")) ;
    requestname= Util.null2String(RecordSet.getString("requestname")) ;
	requestlevel = Util.null2String(RecordSet.getString("requestlevel"));
    requestmark = Util.null2String(RecordSet.getString("requestmark")) ;
    creater = Util.getIntValue(RecordSet.getString("creater"),0);
	creatertype = Util.getIntValue(RecordSet.getString("creatertype"),0);
    deleted = Util.getIntValue(RecordSet.getString("deleted"),0);
	workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
	currentnodeid = Util.getIntValue(RecordSet.getString("currentnodeid"),0);
    if(nodeid<1) nodeid = currentnodeid;
	currentnodetype = Util.null2String(RecordSet.getString("currentnodetype"));
    if(nodetype.equals("")) nodetype = currentnodetype;
    docCategory=Util.null2String(RecordSet.getString("docCategory"));
    workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");
    workflowtype = WorkflowComInfo.getWorkflowtype(workflowid+"");

    lastOperator = Util.getIntValue(RecordSet.getString("lastOperator"),0);
    lastOperateDate=Util.null2String(RecordSet.getString("lastOperateDate"));
    lastOperateTime=Util.null2String(RecordSet.getString("lastOperateTime"));
    currentstatus = Util.getIntValue(RecordSet.getString("currentstatus"),-1);
}else{
    response.sendRedirect("/notice/Deleted.jsp?showtype=wf");
    return ;
}
//从计划任务页面过来，有查看权限 Start
int isworktask = Util.getIntValue(request.getParameter("isworktask"), 0);
if(isworktask == 1){
	int haslinkworktask = Util.getIntValue((String)session.getAttribute("haslinkworktask"), 0);
	if(haslinkworktask == 1){
		int tlinkwfnum = Util.getIntValue((String)session.getAttribute("tlinkwfnum"), 0);
		int i_tmp = 0;
		for(i_tmp=0; i_tmp<tlinkwfnum; i_tmp++){
			int retrequestid = Util.getIntValue((String)session.getAttribute("retrequestid"+i_tmp), 0);
			if(retrequestid != requestid){
				session.removeAttribute("retrequestid"+i_tmp);
				session.removeAttribute("deswtrequestid"+i_tmp);
				continue;
			}
			int deswtrequestid = Util.getIntValue((String)session.getAttribute("deswtrequestid"+i_tmp), 0);
			rs.execute("select * from worktask_requestbase where requestid="+deswtrequestid);
			if(rs.next()){
				int wt_id = Util.getIntValue(rs.getString("taskid"), 0);
				int wt_status = Util.getIntValue(rs.getString("status"), 1);
				int wt_creater = Util.getIntValue(rs.getString("creater"), 0);
				int wt_needcheck = Util.getIntValue(rs.getString("needcheck"), 0);
				int wt_checkor = Util.getIntValue(rs.getString("checkor"), 0);
				int wt_approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
				if(wt_needcheck == 0){
					wt_checkor = 0;
				}
				WTRequestManager wtRequestManager = new WTRequestManager(wt_id);
				wtRequestManager.setLanguageID(user.getLanguage());
				wtRequestManager.setUserID(user.getUID());
				Hashtable checkRight_hs = wtRequestManager.checkRight(deswtrequestid, wt_status, 0, wt_creater, wt_checkor, wt_approverequest);
				boolean canView_tmp = false;
				canView_tmp = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
				if(canView_tmp==false){
					checkRight_hs = wtRequestManager.checkTemplateRight(deswtrequestid, wt_status, 0, wt_creater, wt_checkor, wt_approverequest);
					canView_tmp = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
				}
				if(canView_tmp == true){
					canview = canView_tmp;
				}
			}
			session.removeAttribute("retrequestid"+i_tmp);
			session.removeAttribute("deswtrequestid"+i_tmp);
			session.setAttribute("haslinkworktask", "0");
			session.setAttribute("tlinkwfnum", "0");
			continue;
		}
	}

}
//从计划任务页面过来，有查看权限 End
session.removeAttribute(userid+"_"+requestid+"isremark");
ArrayList canviewwff = (ArrayList)session.getAttribute("canviewwf");
if(canviewwff!=null)
   if(canviewwff.indexOf(requestid+"")>-1)
         canview = true;

if(creater == userid && creatertype == usertype){   // 创建者本人有查看权限
	canview=true;
	canactive=true;
}

// 检查用户查看权限
// 检查用户是否可以查看和激活该工作流 (激活即是对删除的工作流,将删除状态改为删除前的状态)
// canview = HrmUserVarify.checkUserRight("ViewRequest:View", user);   //有ViewRequest:View权限的人可以查看全部工作流
// canactive = HrmUserVarify.checkUserRight("ViewRequest:Active", user);   //有ViewRequest:Active权限的人可以查看全部工作流
   

// 当前用户表中该请求对应的信息 isremark为0为当前操作者, isremark为1为当前被转发者,isremark为2为可跟踪查看者,isremark=5为干预人
//RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+usertype+flag+requestid+"");
int preisremark=-1;//如果是流程参与人，该值会被赋予正确的值，在初始化时先设为错误值，以解决主流程参与人查看子流程时权限判断问题。TD10126
String isremarkForRM = "";
int groupdetailid=0;
RecordSet.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,id");
boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
while(RecordSet.next())	{
    String isremark = Util.null2String(RecordSet.getString("isremark")) ;
	isremarkForRM = isremark;
    preisremark=Util.getIntValue(RecordSet.getString("preisremark"),0) ;
    wfcurrrid=Util.getIntValue(RecordSet.getString("id"));
    groupdetailid=Util.getIntValue(RecordSet.getString("groupdetailid"),0);
    int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
    //modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
    if( isremark.equals("1")||isremark.equals("5") || isremark.equals("7")|| isremark.equals("9") ||(isremark.equals("0")  && !nodetype.equals("3")) ) {
      //modify by xhheng @20041217 for TD 1438
      istoManagePage=true;
      canview=true;
      nodeid=tmpnodeid;
      nodetype=WFLinkInfo.getNodeType(nodeid);  
      break;
    }
    if(isremark.equals("8")){
        canview=true;
        break;
    }
    canview=true;
}
//add by mackjoe at 2008-10-15 td9423
String isintervenor=Util.null2String(request.getParameter("isintervenor"));
int intervenorright=0;
if(isintervenor.equals("1")){
    intervenorright=SysWFLMonitor.getWFInterventorRightBymonitor(userid,requestid);
}  
if(intervenorright>0){
    istoManagePage=false;
    canview=true;
    nodeid=currentnodeid;
    nodetype=currentnodetype;
}
//add by mackjoe at 2006-04-24 td3994
int urger=Util.getIntValue(request.getParameter("urger"),0);
session.setAttribute(userid+"_"+requestid+"urger",""+urger);
if(urger==1){
    canview=false;
    intervenorright=0;
}
if(!canview) isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);
session.setAttribute(userid+"_"+requestid+"ismonitor",""+ismonitor);    
if(ismonitor==1){
    canview=false;
    intervenorright=0;
    isurger=false;
}
if(!canview&&!isurger) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
session.setAttribute(userid+"_"+requestid+"isintervenor",""+isintervenor);
session.setAttribute(userid+"_"+requestid+"intervenorright",""+intervenorright);
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,10,(logintype).equals("1") ? "0" : "1",requestid);
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,14,(logintype).equals("1") ? "0" : "1",requestid);
session.removeAttribute(userid+"_"+requestid+"currentusercanview");
if(!canview && !isurger && !wfmonitor && !CoworkDAO.haveRightToViewWorkflow(Integer.toString(userid),Integer.toString(requestid))) {
    if(!WFUrgerManager.UrgerHaveWorkflowViewRight(desrequestid,userid,Util.getIntValue(logintype,1)) && !WFUrgerManager.getMonitorViewRight(desrequestid,userid)){//督办流程和监控流程的相关流程有查看权限
    	session.setAttribute(userid+"_"+requestid+"currentusercanview","true");    	
        response.sendRedirect("/notice/noright.jsp?isovertime="+isovertime);
        return ;
    }
}
if(urger==1 && isurger==true){//流程督办的入口，并且具有督办查看流程表单的权限
	nodeid = currentnodeid;
	nodetype = currentnodetype;
}
String isaffirmance=WorkflowComInfo.getNeedaffirmance(""+workflowid);//是否需要提交确认
//TD8715 获取工作流信息，是否显示流程图
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
//System.out.println("isShowChart = " + isShowChart);
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid+"");

//把session存储在SESSION中，供浏览框调用，达到不同的流程可以使用同一浏览框，不同的条件
session.setAttribute("workflowidbybrowser",workflowid+"");

if(RecordSet.next()){
	isModifyLog = Util.null2String(RecordSet.getString("isModifyLog"));//by cyril on 2008-07-09 for TD:8835
	formid = Util.getIntValue(RecordSet.getString("formid"),0);
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
}
RecordSet.executeSql("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
boolean isOrgBeforeCoadSubmit = false;
if(isremarkForRM.equals("0")){//协办人已经提交后，由于勾选"未查看一直停留在待办"，所以主办人打开代办流程，直接就变成已办
	RecordSet.execute("select c1.id from workflow_currentoperator c1 where c1.isremark='2' and c1.preisremark='7' and c1.requestid="+requestid+" and exists(select 1 from workflow_currentoperator c2 where c2.id="+wfcurrrid+" and c1.receivedate=c2.receivedate and c1.receivetime=c2.receivetime and c1.nodeid=c2.nodeid and c1.groupdetailid=c2.groupdetailid ) and exists(select id from workflow_groupdetail g where g.id=c1.groupdetailid and g.signtype='0')");
	if(RecordSet.next()){
		int c1id_t = Util.getIntValue(RecordSet.getString("id"));
		if(c1id_t > 0){
			isOrgBeforeCoadSubmit = true;
			isremarkForRM="2";
		    istoManagePage=false;
		}
	}
}
session.setAttribute(userid+"_"+requestid+"canview",canview+"");
session.setAttribute(userid+"_"+requestid+"isurger",isurger+"");
session.setAttribute(userid+"_"+requestid+"wfmonitor",wfmonitor+"");
session.setAttribute(userid+"_"+requestid+"isrequest",isrequest);
session.setAttribute(userid+"_"+requestid+"isremarkForRM",isremarkForRM+"");
session.setAttribute(userid+"_"+requestid+"preisremark",preisremark+"");
session.setAttribute(userid+"_"+requestid+"wfcurrrid",wfcurrrid+"");
session.setAttribute(userid+"_"+requestid+"groupdetailid",groupdetailid+"");
session.setAttribute(userid+"_"+requestid+"isSignMustInputOfThisJsp",""+isSignMustInputOfThisJsp);
session.setAttribute(userid+"_"+requestid+"helpdocid",""+helpdocid);
session.setAttribute(userid+"_"+requestid+"isModifyLog",""+isModifyLog);
session.setAttribute(userid+"_"+requestid+"currentnodeid",""+currentnodeid);
session.setAttribute(userid+"_"+requestid+"currentnodetype",currentnodetype);
session.setAttribute(userid+"_"+requestid+"isaffirmance",isaffirmance);
session.setAttribute(userid+"_"+requestid+"reEdit",reEdit);
session.setAttribute(userid+"_"+requestid+"workflowname",workflowname);
request.setAttribute(userid+"_"+workflowid+"workflowname",workflowname);
session.setAttribute(""+userid+"_"+requestid+"currentstatus",""+currentstatus);
//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(""+workflowid,""+nodeid);
String  docFlagss=docFlag?"1":"0";
//如果是流程存文档过来，则没有TAB页
if("1".equals(isworkflowhtmldoc)) docFlagss="0";
session.setAttribute("requestAdd"+requestid,docFlagss);
if (!fromFlowDoc.equals("1"))
{
if (docFlag)
{ if (fromoperation.equals("1"))
	{

	if (!nodetypedoc.equals("0")) {
	%>
	<script>
		<%if("1".equals(isShowChart)){%>
	 //setTimeout("window.close()",1);
     //window.opener._table.reLoad();
try{	
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}
     window.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
	 <%}else{
		 islog=false;
	 %>
	 setTimeout("window.close()",1);
     //window.opener._table.reLoad();
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}

		 <%}%>
    </script>
    <%return;}
	else
	{%>
			<script>
		try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}

try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}
</script>
<%
		if("1".equals(isShowChart)){
			response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid+"&isfromtab="+isfromtab);
		}else{
		 response.sendRedirect("RequestView.jsp");
		}
     return;
	}
    }
session.setAttribute(userid+"_"+requestid+"requestname",requestname);
session.setAttribute(userid+"_"+requestid+"requestmark",requestmark);
session.setAttribute(userid+"_"+requestid+"status",status);
//response.sendRedirect("ViewRequestDoc.jsp?requestid="+requestid+"&isrequest="+isrequest+"&isovertime="+isovertime+"&isaffirmance="+isaffirmance+"&reEdit="+reEdit+"&wflinkno="+wflinkno);
//return;
isworkflowdoc = "1";
//fromFlowDoc = "1";
}
}
if(fromoperation.equals("1")&&(src.equals("submit")||src.equals("reject"))){//fromoperation=1表示对流程做过操作,当做提交，退回操作时返回到流程图页面。
%>
<script>
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>
}catch(e){}
<%if("1".equals(isShowChart)){%>
window.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
</script>
<%  return;
	}else{%>
</script>
    <%}

}
WFForwardManager.init();
WFForwardManager.setWorkflowid(workflowid);
WFForwardManager.setNodeid(nodeid);
WFForwardManager.setIsremark(isremarkForRM);
WFForwardManager.setRequestid(requestid);
WFForwardManager.setBeForwardid(wfcurrrid);
WFForwardManager.getWFNodeInfo();
String IsPendingForward=WFForwardManager.getIsPendingForward();
String IsBeForward=WFForwardManager.getIsBeForward();
String IsSubmitedOpinion=WFForwardManager.getIsSubmitedOpinion();
String IsSubmitForward=WFForwardManager.getIsSubmitForward();
String IsWaitForwardOpinion=WFForwardManager.getIsWaitForwardOpinion();
String IsBeForwardSubmit=WFForwardManager.getIsBeForwardSubmit();
String IsBeForwardModify=WFForwardManager.getIsBeForwardModify();
String IsBeForwardPending=WFForwardManager.getIsBeForwardPending();
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(requestid,nodeid,Util.getIntValue(isremarkForRM));
String IsFreeNode=WFForwardManager.getIsFreeNode(nodeid);
session.setAttribute(userid+"_"+requestid+"wfcurrrid",""+wfcurrrid);
boolean IsCanSubmit=WFForwardManager.getCanSubmit();
boolean IsBeForwardCanSubmitOpinion=WFForwardManager.getBeForwardCanSubmitOpinion();
boolean IsCanModify=WFForwardManager.getCanModify();
WFCoadjutantManager.getCoadjutantRights(groupdetailid);
String coadsigntype=WFCoadjutantManager.getSigntype();
String coadissubmitdesc=WFCoadjutantManager.getIssubmitdesc();
String coadisforward=WFCoadjutantManager.getIsforward();
String coadismodify=WFCoadjutantManager.getIsmodify();
String coadispending=WFCoadjutantManager.getIspending();
if(!IsCanModify&&coadismodify.equals("1")) IsCanModify=true;
boolean coadCanSubmit=WFCoadjutantManager.getCoadjutantCanSubmit(requestid,wfcurrrid,isremarkForRM,coadsigntype);
session.setAttribute(userid+"_"+requestid+"coadsigntype",coadsigntype);
session.setAttribute(userid+"_"+requestid+"coadissubmitdesc",coadissubmitdesc);
session.setAttribute(userid+"_"+requestid+"coadisforward",coadisforward);
session.setAttribute(userid+"_"+requestid+"coadismodify",coadismodify);
session.setAttribute(userid+"_"+requestid+"coadispending",coadispending);
session.setAttribute(userid+"_"+requestid+"coadCanSubmit",""+coadCanSubmit);
session.setAttribute(userid+"_"+requestid+"IsPendingForward",IsPendingForward);
session.setAttribute(userid+"_"+requestid+"IsBeForward",IsBeForward);
session.setAttribute(userid+"_"+requestid+"IsSubmitedOpinion",IsSubmitedOpinion);
session.setAttribute(userid+"_"+requestid+"IsSubmitForward",IsSubmitForward);
session.setAttribute(userid+"_"+requestid+"IsWaitForwardOpinion",IsWaitForwardOpinion);
session.setAttribute(userid+"_"+requestid+"IsBeForwardSubmit",IsBeForwardSubmit);
session.setAttribute(userid+"_"+requestid+"IsBeForwardModify",IsBeForwardModify);
session.setAttribute(userid+"_"+requestid+"IsBeForwardPending",IsBeForwardPending);
session.setAttribute(userid+"_"+requestid+"IsCanSubmit",""+IsCanSubmit);
session.setAttribute(userid+"_"+requestid+"IsBeForwardCanSubmitOpinion",""+IsBeForwardCanSubmitOpinion);
session.setAttribute(userid+"_"+requestid+"IsCanModify",""+IsCanModify);
session.setAttribute(userid+"_"+requestid+"IsFreeWorkflow",""+IsFreeWorkflow);
session.setAttribute(userid+"_"+requestid+"IsFreeNode",""+IsFreeNode);

if(isremarkForRM.equals("8")||(isremarkForRM.equals("1")&&!IsCanSubmit&&IsBeForwardPending.equals("1")&&!IsBeForwardSubmit.equals("1")&&!IsBeForwardModify.equals("1"))||("7".equals(isremarkForRM)&&!coadCanSubmit) || isOrgBeforeCoadSubmit){
	if(isOrgBeforeCoadSubmit){
		RecordSet.executeSql("update workflow_currentoperator set isremark='2' where requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype);
	}
    RecordSet.executeProc("workflow_CurrentOperator_Copy", requestid + "" + flag + userid + flag + usertype + "");
    if (currentnodetype.equals("3")) {
        RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype);
    }
    isremarkForRM="2";
    istoManagePage=false;
%>
<script>
     //window.opener._table.reLoad();
try{	
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
	<%if(isUseOldWfMode){%>
	window.opener._table.reLoad();
	<%}else{%>
	window.opener.reLoad();
	<%}%>

}catch(e){}
</script>
<%
}

if( isbill.equals("1") ) {
    RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
    if(RecordSet.next()){
    formid = Util.getIntValue(RecordSet.getString("billformid"),0);
    billid= Util.getIntValue(RecordSet.getString("billid"));
    }
    if(formid == 207){//计划任务审批单单独处理
    	//特殊处理，直接跳转到计划任务界面，进行审批操作
    	int approverequest = Util.getIntValue(request.getParameter("requestid"), 0);
    	int wt_requestid = 0;
    	rs.execute("select * from worktask_requestbase where approverequest="+approverequest);
    	if(rs.next()){
    		wt_requestid = Util.getIntValue(rs.getString("requestid"), 0);
    	}
    	response.sendRedirect("/worktask/request/ViewWorktask.jsp?requestid="+wt_requestid);
		return;
    }

}

//xwj for td3450 20060112
if(istoManagePage && !isprint){
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,0,(logintype).equals("1") ? "0" : "1",requestid);
}
else{
String updatePoppupFlag = Util.null2String(request.getParameter("updatePoppupFlag"));
if( !"1".equals(updatePoppupFlag)){
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,1,(logintype).equals("1") ? "0" : "1",requestid);
}
}
String message = Util.null2String(request.getParameter("message"));       // 返回的错误信息

session.setAttribute(userid+"_"+requestid+"requestname",requestname);
session.setAttribute(userid+"_"+requestid+"workflowid",""+workflowid);
session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
session.setAttribute(userid+"_"+requestid+"preisremark",""+preisremark);
if(((isremarkForRM.equals("0")||isremarkForRM.equals("1"))&&!IsCanSubmit)||(isremarkForRM.equals("7")&&!coadCanSubmit)) istoManagePage=false;
session.setAttribute(userid+"_"+requestid+"formid",""+formid);
    session.setAttribute(userid+"_"+requestid+"billid",""+billid);
    session.setAttribute(userid+"_"+requestid+"isbill",isbill);
    session.setAttribute(userid+"_"+requestid+"nodetype",nodetype);
    session.setAttribute(userid+"_"+requestid+"creater",""+creater);
    session.setAttribute(userid+"_"+requestid+"creatertype",""+creatertype);
//add by xhheng @20041217 for TD 1438 start
if(istoManagePage && !isprint && !wfmonitor && isonlyview!=1 && !"1".equals(isworkflowhtmldoc)){
    String topage = URLEncoder.encode(Util.null2String(request.getParameter("topage"))) ;        //返回的页面
    String docfileid = Util.null2String(request.getParameter("docfileid"));   // 新建文档的工作流字段
    String newdocid = Util.null2String(request.getParameter("docid"));        // 新建的文档
    String actionPage = "ManageRequestNoForm.jsp?fromFlowDoc="+fromFlowDoc ;

    session.setAttribute(userid+"_"+requestid+"status",status);
    session.setAttribute(userid+"_"+requestid+"requestlevel",requestlevel);
    session.setAttribute(userid+"_"+requestid+"requestmark",requestmark);
    session.setAttribute(userid+"_"+requestid+"deleted",""+deleted);
    session.setAttribute(userid+"_"+requestid+"currentnodeid",""+currentnodeid);
    session.setAttribute(userid+"_"+requestid+"currentnodetype",currentnodetype);
    session.setAttribute(userid+"_"+requestid+"workflowtype",workflowtype);
    session.setAttribute(userid+"_"+requestid+"helpdocid",""+helpdocid);
    session.setAttribute(userid+"_"+requestid+"docCategory",docCategory);
    session.setAttribute(userid+"_"+requestid+"newdocid",newdocid);
    session.setAttribute(userid+"_"+requestid+"wfmonitor",""+wfmonitor);

    session.setAttribute(userid+"_"+requestid+"lastOperator",""+lastOperator);
    session.setAttribute(userid+"_"+requestid+"lastOperateDate",lastOperateDate);
    session.setAttribute(userid+"_"+requestid+"lastOperateTime",lastOperateTime);

    //RecordSet对象在一个客户程序多个执行之间，查询结果可以保留到下一次查询(见RecordSet类 Description 4)
    //但当第二次sql执行失败时，没有清空RecordSet对象，仍保留第一次sql执行结果
    //由此，为防止图形化表单相关脚本没有执行而以下sql执行失败所导致的逻辑错误，申明了新的RecordSet对象mrs
    //屏蔽老的图形化方式，默认为普通方式 mackjoe at 2006-06-12
    /*RecordSet mrs=new RecordSet();
    mrs.executeSql("select count(a.formid) from workflow_formprop a, workflow_base b, workflow_Requestbase c where a.formid = b.formid and b.id = c.workflowid and b.isbill='0' and c.requestid = "+requestid);

    if(mrs.next() && mrs.getInt(1) > 0 ){
      actionPage = "ManageRequestForm.jsp" ;
    }else{
      actionPage = "ManageRequestNoForm.jsp" ;
    }
    */
    //System.out.println("actionPage="+actionPage);

    //将本人的流程查看状态置为已查看2,已提交过的不要在更新操作时间
    if (RecordSet.getDBType().equals("oracle"))
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
	{
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate= to_char(sysdate,'yyyy-mm-dd'),operatetime=to_char(sysdate,'hh24:mi:ss'),orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
        RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=( case isremark when '2' then operatedate else to_char(sysdate,'yyyy-mm-dd') end  ) ,operatetime=( case isremark when '2' then operatetime else to_char(sysdate,'hh24:mi:ss') end  ) where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2 ");
	}
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
    else if (RecordSet.getDBType().equals("db2"))
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
	{
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=to_char(current date,'yyyy-mm-dd'),operatetime=to_char(current time,'hh24:mi:ss'),orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
        RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=( case isremark when '2' then operatedate else to_char(current date,'yyyy-mm-dd') end ),operatetime=( case isremark when '2' then operatetime else to_char(current time,'hh24:mi:ss') end ) where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
	}
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
    else
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
	{
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=convert(char(10),getdate(),20),operatetime=convert(char(8),getdate(),108),orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
        //RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=to_char(current date,'yyyy-mm-dd'),operatetime=to_char(current time,'hh24:mi:ss')  where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");//update by fanggsh 20060510
        RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,operatedate=( case isremark when '2' then operatedate else convert(char(10),getdate(),20) end ),operatetime=( case isremark when '2' then operatetime else convert(char(8),getdate(),108) end ) where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");//update by fanggsh 20060510

	}
		//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
    //记录第一次查看时间
    //RecordSet.executeProc("workflow_CurOpe_UpdatebyView",""+requestid+ flag + userid + flag + usertype);

    actionPage+="&requestid="+requestid+"&isrequest="+isrequest+"&isovertime="+isovertime+"&isaffirmance="+isaffirmance+"&reEdit="+reEdit+"&seeflowdoc="+seeflowdoc+"&isworkflowdoc="+isworkflowdoc+"&isfromtab="+isfromtab;
    if(!message.equals("")) actionPage+="&message="+message;
    if(!topage.equals("")) actionPage+="&topage="+topage;
    if(!docfileid.equals("")) actionPage+="&docfileid="+docfileid;
    if(!newdocid.equals("")) actionPage+="&newdocid="+newdocid;
    response.sendRedirect(actionPage);

    //当前操作者或者被转发者,并且当前节点不为备案节点,直接进入管理页面
    return ;
}
//add by xhheng @20041217 for TD 1438 end

// 记录查看日志
String clientip = request.getRemoteAddr();
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

// modify by xhheng @20050304 for TD 1691

/*--  xwj for td2104 on 20050802 begin  --*/
boolean isOldWf = false;
if(isprint==false){
RecordSet4.executeSql("select nodeid from workflow_currentoperator where requestid = " + requestid);
while(RecordSet4.next()){
	if(RecordSet4.getString("nodeid") == null || "".equals(RecordSet4.getString("nodeid")) || "-1".equals(RecordSet4.getString("nodeid"))){
			isOldWf = true;
	}
}

/*--  xwj for td2104 on 20050802 end  --*/


//将本人的流程查看状态置为已查看2
	//TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh begin
//RecordSet.executeSql("update workflow_currentoperator set viewtype=-2,orderdate=receivedate,ordertime=receivetime where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
RecordSet.executeSql("update workflow_currentoperator set viewtype=-2 where requestid = " + requestid + "  and userid ="+userid+" and usertype = "+usertype+" and viewtype<>-2");
    //TD4294  删除workflow_currentoperator表中orderdate、ordertime列 fanggsh end
//记录第一次查看时间
RecordSet.executeProc("workflow_CurOpe_UpdatebyView",""+requestid+ flag + userid + flag + usertype);

if(! currentnodetype.equals("3") )
    RecordSet.executeProc("SysRemindInfo_DeleteHasnewwf",""+userid+flag+usertype+flag+requestid);
else
    RecordSet.executeProc("SysRemindInfo_DeleteHasendwf",""+userid+flag+usertype+flag+requestid);
}

String imagefilename = "/images/hdReport.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage()) + " - " +  status + " "+requestmark ;//Modify by 杨国生 2004-10-26 For TD1231
//if(helpdocid !=0 ) {titlename=titlename + "<img src=/images/help.gif style=\"CURSOR:hand\" width=12 onclick=\"location.href='/docs/docs/DocDsp.jsp?id="+helpdocid+"'\">";}
String needfav ="1";
String needhelp ="";
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int showdes=0;
int printdes=0;
int toexcel=0;
RecordSet.executeSql("select ismode,showdes,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
    toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
}

if(ismode.equals("1") && showdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
            isform=1;
        }
    }
}else if("2".equals(ismode)){
	RecordSet.executeSql("select id from workflow_nodehtmllayout where type=0 and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }
}

//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
//---------------------------------------------------------------------------------
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 START 2011-11-23 CC
//if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {
if (!isIE.equalsIgnoreCase("true") && ismode.equals("1") && modeid != 0) {
	String messageLableId = "";
	if (ismode.equals("1")) {
		messageLableId = "18017";
	} else {
		messageLableId = "23682";
	}
	ismode = "0";	
	//response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=" + messageLableId);
	%>

	<script type="text/javascript">
	
	window.parent.location.href = "/wui/common/page/sysRemind.jsp?labelid=<%=messageLableId %>";
	
	</script>

<%
	return;
}
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 END
//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
//---------------------------------------------------------------------------------


if(fromPDA.equals("1") && ismode.equals("1")){
	modeid=0;
}
if(ismode.equals("1") && !isnotprintmode && isprint && printdes!=1&&!fromPDA.equals("1")){
    response.sendRedirect("PrintMode.jsp?requestid="+requestid+"&isbill="+isbill+"&workflowid="+workflowid+"&formid="+formid+"&nodeid="+nodeid+"&billid="+billid+"&isfromtab="+isfromtab);
    return;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">

<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
</style>
<title><%=requestname%></title>
</head>
<script language=javascript>
var showTableDiv;
var oIframe = document.createElement('iframe');
function showPrompt(content){
	showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.top=pTop;
     message_table_Div.style.left=pLeft;

     message_table_Div.style.zIndex=1002;
     //oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';

}
function hiddenPop(){
 try{
    <%
	if(modeid>0 && "1".equals(ismode)){
%>
    oPopup.hide();
<%
    }else{
%>
    showTableDiv.style.display='none';
    oIframe.style.display='none';
<%
    }
%>
}catch(e){}
}
var fromoperation="<%=fromoperation%>";
var overtime="<%=isovertime%>";
function windowOnload()
{
    <%if(modeid>0 && "1".equals(ismode)){%>
        //init();
    <%}else{%>
    setwtableheight();
    <%}
        if( message.equals("4") ) {//已经流转到下一节点，不可以再提交。
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);
<%
	} else if( message.equals("5") ) {//流程流转超时，请重试。
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("6") ) {//转发失败，请重试！
%>

		  var content="<%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("7") ) {//已经处理，不可重复处理！
%>

		  var content="<%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	} else if( message.equals("8") ) {//流程数据已更改，请核对后再处理！
%>

		  var content="<%=SystemEnv.getHtmlLabelName(24676,user.getLanguage())%>";
		  showPrompt(content);
          window.setTimeout("message_table_Div.style.display='none';document.all.HelpFrame.style.display='none'", 2000);

<%
	}
%>
    if (fromoperation=="1") {
<%
         //TD4262 增加提示信息  开始
		 if(isShowPrompt.equals("true"))
		{
			 if(src.equals("submit")){
				 if(modeid>0 && "1".equals(ismode)){
%>
	                 contentBox = document.getElementById("divFavContent18982");
                     showObjectPopup(contentBox);
<%
				 }else{
%>
		             var content="<%=SystemEnv.getHtmlLabelName(18982,user.getLanguage())%>";
		             showPrompt(content);
<%
				 }
			 }else if(src.equals("reject")){
				 if(modeid>0 && "1".equals(ismode)){
%>
	                 contentBox = document.getElementById("divFavContent18983");
                     showObjectPopup(contentBox);
<%
				 }else {
%>
		             var content="<%=SystemEnv.getHtmlLabelName(18983,user.getLanguage())%>";
		             showPrompt(content);
<%
				 }
			}
		}
%>
		if( overtime!="1"){
			try{
				window.opener.btnWfCenterReload.onclick();
			}catch(e){}
		}
		<%if("1".equals(isShowChart)){%>
       		try{
   				<%if(isUseOldWfMode){%>
   				window.opener._table.reLoad();
   				<%}else{%>
   				window.opener.reLoad();
   				<%}%>
			}catch(e){}
			window.location.href="/workflow/request/WorkflowDirection.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
		<%}else{%>
			try{
			<%if(isUseOldWfMode){%>
			window.opener._table.reLoad();
			<%}else{%>
			window.opener.reLoad();
			<%}%>
			}catch(e){}
			<%
				if("1".equals(fromoperation)){
					islog = false;
				}
			%>
			setTimeout("window.close()",1);
			<%}%>
    }
}
<%if(modeid<1 || "2".equals(ismode)){%>
function setwtableheight(){
    /*
    var totalheight=5;
    var bodyheight=document.body.clientHeight;
    if(document.getElementById("divTopTitle")!=null){
        totalheight+=document.getElementById("divTopTitle").clientHeight;
    }
    <%if (fromFlowDoc.equals("1")){%>
        totalheight+=100;
        bodyheight=parent.document.body.clientHeight;
    <%}%>
    document.getElementById("w_table").height=bodyheight-totalheight;
    */
}
window.onresize = function (){
    setwtableheight();
}
<%}%>
</script>
<%
if(islog){
if(isOldWf){//老数据 , 相对 td2104 以前
	RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + "9" + flag + -1);
	//程序中没有任何地方使用了ordertype='-1'的条件，所以此处直接把-1改成9 by ben 2006-05-24 for TD439
	}
	else{
	int showorder = 10000;
	String orderType = "";
	RecordSet.executeSql("select agentorbyagentid, agenttype, showorder from workflow_currentoperator where userid = " + userid +
	" and nodeid = " + nodeid + " and requestid = " + requestid + " and isremark in ('0','1','4','5','8','9','7') and usertype = " + usertype);

	if(RecordSet.next()){
	  orderType = "1"; // 当前节点操作人
	  showorder  = RecordSet.getInt("showorder");
	}
	else{

	orderType = "2";// 非当前节点操作人
	RecordSet2.executeSql("select max(showorder) from workflow_requestviewlog where id = " + requestid + "  and ordertype = '2' and currentnodeid = " + nodeid);
	RecordSet2.next();
	if(RecordSet2.getInt(1) != -1){
	showorder = RecordSet2.getInt(1) + 1;
	}
	}
	if(wfmonitor){
	    orderType ="3";//流程监控人查看
	}
	if(isurger){
	    orderType ="4";//流程督办人查看
	}
	RecordSet.executeProc("workflow_RequestViewLog_Insert",requestid+"" + flag + userid+"" + flag + currentdate +flag + currenttime + flag + clientip + flag + usertype +flag + nodeid + flag + orderType + flag + showorder);

	}
}
%>


<script language="javascript">
var isfirst = 0 ;

function displaydiv()
{
    if(oDivAll.style.display == ""){
		oDivAll.style.display = "none";
		oDivInner.style.display = "none";
        oDiv.style.display = "none";
        <%if(modeid>0 && "1".equals(ismode)){%> oDivSign.style.display = "none";<%}%>
        spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
    }
    else{
        if(isfirst == 0) {
			document.getElementById("picInnerFrame").src="/workflow/request/WorkflowRequestPictureInner.jsp?isview=1&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&randpara=<%=System.currentTimeMillis()%>";				
			document.getElementById("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&isurger=<%=isurger%>&randpara=<%=System.currentTimeMillis()%>";
            <%if(modeid>0 && "1".equals(ismode)){%> document.getElementById("picSignFrame").src="/workflow/request/WorkflowViewSignMode.jsp?isprint=true&languageid=<%=user.getLanguage()%>&userid=<%=userid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isOldWf=<%=isOldWf%>&desrequestid=<%=desrequestid%>&ismonitor=<%=ismonitor%>&logintype=<%=logintype%>&randpara=<%=System.currentTimeMillis()%>";<%}%>
            isfirst ++ ;
        }

        spanimage.innerHTML = "<img src='/images/ArrowUpGreen.gif' border=0>" ;
		oDivAll.style.display = "";
		oDivInner.style.display = "";
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
        <%if(modeid>0 && "1".equals(ismode)){%>
        oDivSign.style.display = "";
        workflowSignLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
        <%}%>
    }
}


function displaydivOuter()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        workflowStatusLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19677,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"<%if(modeid>0 && "1".equals(ismode)){%> &&oDivSign.style.display == "none"<%}%>){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
    }
    else{
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
    }
}

function displaydivInner()
{
    if(oDivInner.style.display == ""){
        oDivInner.style.display = "none";
        workflowChartLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19675,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"<%if(modeid>0 && "1".equals(ismode)){%> &&oDivSign.style.display == "none"<%}%>){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
    }
    else{
        oDivInner.style.display = "";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}


</SCRIPT>
<body onload="windowOnload()">

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
if(!"0".equals(isremarkForRM)){
	RecordSet.executeSql("select nodeid from workflow_currentoperator c where c.requestid="+requestid+" and c.userid="+userid+" and c.usertype="+usertype+" and c.isremark='"+isremarkForRM+"' ");
	int tmpnodeid = 0;
	if(RecordSet.next()){
		tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"), 0);
	}
	sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+tmpnodeid;
}

RecordSet.executeSql(sqlselectName);
String forwardName = "";
String newWFName = "";//新建流程按钮
String newSMSName = "";//新建短信按钮
String ccsubnobackName = "";//抄送批注不需反馈
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
String hasccnoback = "";//使用抄送批注不需反馈按钮
int t_workflowid = 0;//新建流程的ID
if(RecordSet.next()){
	if(user.getLanguage() == 7){
		forwardName = Util.null2String(RecordSet.getString("forwardName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName7"));
	}
	else if(user.getLanguage() == 9){
		forwardName = Util.null2String(RecordSet.getString("forwardName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName9"));
	}
	else{
		forwardName = Util.null2String(RecordSet.getString("forwardName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		ccsubnobackName = Util.null2String(RecordSet.getString("ccsubnobackName8"));
	}
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasccnoback = Util.null2String(RecordSet.getString("hasccnoback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
}
if("".equals(forwardName)){
	forwardName = SystemEnv.getHtmlLabelName(6011,user.getLanguage());
}
if("".equals(ccsubnobackName)){
	ccsubnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";
}

%>
<%--xwj for td3665 20060224 begin--%>
<%
String strBar = "[";
//HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,nodeid);
//String ov = (String)map.get("ov");//能否强制归档依据查看人所在节点是否有权限
HashMap map = WfFunctionManageUtil.wfFunctionManageByNodeid(workflowid,currentnodeid);
String rb = (String)map.get("rb");
//if(!"0".equals(rb)){//强制收回:如果流程当前节点设置"查看前收回"或"查看后收回"，则上一节点的操作者有权限收回。 myq修改 TD9348
//	RecordSet.executeSql("select * from workflow_NodeLink where nodeid="+nodeid+" and destnodeid="+currentnodeid+" and workflowid="+workflowid);
//	if(!RecordSet.next()) rb = "0";//如果操作人所在节点不是强制收回节点的上一个节点，则没有强制收回的权限。
//}
//String ifremark=Util.null2String(WorkflowComInfo.getIsremark(workflowid+""));
//haveOverright=preisremark!=1 && preisremark!=5 && preisremark!=8 && preisremark!=9 && "1".equals(ov) && !"3".equals(currentnodetype) && WfForceOver.isNodeOperator(requestid,currentnodeid,userid);		//增加对流程当前所处节点类型的判断TD9023
haveStopright = WfFunctionManageUtil.haveStopright(currentstatus,creater,user,currentnodetype,requestid,false);//流程不为暂停或者撤销状态，当前用户为流程发起人或者系统管理员，并且流程状态不为创建和归档
haveCancelright = WfFunctionManageUtil.haveCancelright(currentstatus,creater,user,currentnodetype,requestid,false);//流程不为撤销状态，当前用户为流程发起人，并且流程状态不为创建和归档
haveRestartright = WfFunctionManageUtil.haveRestartright(currentstatus,creater,user,currentnodetype,requestid,false);//流程为暂停或者撤销状态，当前用户为系统管理员，并且流程状态不为创建和归档
if(currentstatus>-1&&!haveCancelright&&!haveRestartright)
{
	String tips = "";
	if(currentstatus==0)
	{
		tips = SystemEnv.getHtmlLabelName(26154,user.getLanguage());//流程已暂停,请与流程发起人或系统管理员联系!
	}
	else
	{
		tips = SystemEnv.getHtmlLabelName(26155,user.getLanguage());//流程已撤销,请与系统管理员联系!
	}
%>
	<script language="JavaScript">
		var tips = '<%=tips%>';
		if(tips!="")
		{
			alert(tips);
		}
		//window.location.href="/notice/noright.jsp?isovertime=<%=isovertime%>";
		try
		{
			setTimeout('top.window.close()',1);
		}
		catch(e)
		{
			window.location.href="/notice/noright.jsp?isovertime=<%=isovertime%>";
		}
	</script>
<%
    return ;
}
haveBackright=preisremark!=1 && preisremark!=5 && preisremark!=8&& preisremark!=7 && preisremark!=9 && !"0".equals(rb) && WfForceDrawBack.isHavePurview(requestid,userid,Integer.parseInt(logintype),-1,-1);
if(intervenorright>0){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doIntervenor(this),_self}" ;//Modified by xwj for td3247 20051201
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+"',iconCls:'btn_doIntervenor',handler: function(){bodyiframe.doIntervenor(this);}},";
}else{
if(preisremark!=8 && !wfmonitor){
if (isurger)
{
//RCMenu += "{"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+",javascript:doSupervise(this),_self}" ;//Modified by xwj for td3247 20051201
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(21223,user.getLanguage())+"',iconCls:'btn_Supervise',handler: function(){bodyiframe.doSupervise(this);}},";
}else{
	//代理人的preisremark=2的情况
	String agenttypetmp = "0";
	RecordSet.executeSql("SELECT * FROM workflow_currentoperator where id=" + wfcurrrid);
	if(RecordSet.next()) agenttypetmp = RecordSet.getString("AGENTTYPE");
if (!haveRestartright&&((IsSubmitForward.equals("1")&&(preisremark==0||preisremark==9||(preisremark==1&&"1".equals(isremarkForRM)) || (preisremark==1 && "2".equals(isremarkForRM) && "1".equals(IsSubmitForward) && "1".equals(IsBeForward)) ||("1".equals(agenttypetmp) && preisremark==2)))||(IsBeForward.equals("1")&&preisremark==1&&(IsCanSubmit || isremarkForRM.equals("2") || isremarkForRM.equals("4")))||(coadisforward.equals("1")&&isremarkForRM.equals("7")))&&canview&&!isrequest.equals("1"))
{

//RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
//RCMenuHeight += RCMenuHeightStep ;	
strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview();}},";
}
//if(haveOverright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doDrawBack(this),_self}" ;//xwj for td3665 20060224
//RCMenuHeight += RCMenuHeightStep ;
//strBar += "{text: '"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+"',iconCls:'btn_doDrawBack',handler: function(){bodyiframe.doDrawBack(this);}},";
//}
%>
<%if(haveBackright){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+",javascript:doRetract(this),_self}" ;//xwj for td3665 20060224
//RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+SystemEnv.getHtmlLabelName(18359,user.getLanguage())+"',iconCls:'btn_doRetract',handler: function(){bodyiframe.doRetract(this);}},";
}
}
}else if(preisremark==8 && !wfmonitor){//抄送不需要提交也有转发按钮TD9144
	//if(!"".equals(ifchangstatus) && "1".equals(hasccnoback)){
		//RCMenu += "{"+ccsubnobackName+",javascript:doRemark_nNoBack(this),_self}";
		//RCMenuHeight += RCMenuHeightStep;
    //    strBar += "{text: '"+ccsubnobackName+"',iconCls:'btn_ccsubnobackName',handler: function(){bodyiframe.doRemark_nNoBack(this);}},";
	//}
	
	if (!haveRestartright&&((IsSubmitForward.equals("1")&&(preisremark==0||preisremark==8))||(IsBeForward.equals("1")&&preisremark==1))&&canview&&!isrequest.equals("1")&&isurger==false){
		//RCMenu += "{"+forwardName+",javascript:doReview(),_self}" ;//Modified by xwj for td3247 20051201
		//RCMenuHeight += RCMenuHeightStep ;	
		strBar += "{text: '"+forwardName+"',iconCls:'btn_forward',handler: function(){bodyiframe.doReview();}},";
	}
}
/* added by cyril on 2008-07-09 for TD:8835 **/
if(isModifyLog.equals("1") && preisremark>-1&&!isurger) {//TD10126
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+",javascript:doViewModifyLog(),_self}" ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(21625,user.getLanguage())+"',iconCls:'btn_doViewModifyLog',handler: function(){bodyiframe.doViewModifyLog();}},";
}
/* end by cyril on 2008-07-09 for TD:8835 **/
if(!isurger&&!wfmonitor){
/*TD9145 START*/
if("1".equals(haswfrm)){
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage());
	}
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		//RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+", "+requestid+",0),_top} " ;
		//RCMenuHeight += RCMenuHeightStep ;
		strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){bodyiframe.onNewRequest("+t_workflowid+", "+requestid+",0);}},";
	}
}
RTXConfig rtxconfig = new RTXConfig();
String temV = rtxconfig.getPorp(rtxconfig.CUR_SMS_SERVER_IS_VALID);
boolean valid = false;
if (temV != null && temV.equalsIgnoreCase("true")) {
	valid = true;
} else {
	valid = false;
}
if(valid == true && "1".equals(hassmsrm) && HrmUserVarify.checkUserRight("CreateSMS:View", user)){
	if("".equals(newSMSName)){
		newSMSName = SystemEnv.getHtmlLabelName(16444,user.getLanguage());
	}
	//RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+", "+requestid+"),_top} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){bodyiframe.onNewSms("+workflowid+", "+nodeid+", "+requestid+");}},";
}
/*TD9145 END*/
}
}
if(haveStopright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+"',iconCls:'btn_end',handler: function(){bodyiframe.doStop(this);}},";
}
if(haveCancelright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+"',iconCls:'btn_backSubscrible',handler: function(){bodyiframe.doCancel(this);}},";
}
if(haveRestartright)
{
	strBar += "{text: '"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"',iconCls:'btn_next',handler: function(){bodyiframe.doRestart(this);}},";
}
if("1".equals(ismode) && modeid>0 && toexcel==1){
strBar += "{text: '"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel',iconCls:'btn_excel',handler: function(){bodyiframe.ToExcel();}},";
}
strBar += "{text: '"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+"',iconCls:'btn_print',handler: function(){bodyiframe.openSignPrint();}},";
strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
if(isonlyview == 1){
	strBar = "[]";
}
%>
<%--xwj for td3665 20060224 end--%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%@ include file="/workflow/request/RequestShowHelpDoc.jsp" %>
        <input type=hidden name=seeflowdoc value="<%=seeflowdoc%>">
		<input type=hidden name=isworkflowdoc value="<%=isworkflowdoc%>">
        <input type=hidden name=wfdoc value="<%=wfdoc%>">
        <input type=hidden name=picInnerFrameurl value="/workflow/request/WorkflowRequestPictureInner.jsp?isview=1&fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&randpara=<%=System.currentTimeMillis()%>">
		<input type=hidden name=statInnerFrameurl value="WorkflowRequestPicture.jsp?hasExt=true&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>&desrequestid=<%=desrequestid %>&isurger=<%=isurger%>&randpara=<%=System.currentTimeMillis()%>">

		<%@ include file="/workflow/request/NewRequestFrame.jsp" %>
		<TABLE width=100%>
			<tr>
				<td valign="top">
		        <%if( message.equals("4") ) {%>
		        <font color=red><%=SystemEnv.getHtmlLabelName(21266,user.getLanguage())%></font>
				<%} else if( message.equals("5") ) {%>
		        <font color=red><%=SystemEnv.getHtmlLabelName(21270,user.getLanguage())%></font>
				<%} else if( message.equals("6") ) {%>
                <font color=red><%=SystemEnv.getHtmlLabelName(21766,user.getLanguage())%></font>
                <%} else if( message.equals("7") ) {%>
                <font color=red><%=SystemEnv.getHtmlLabelName(22751,user.getLanguage())%></font>
                <%} else if( message.equals("8") ) {%>
                <font color=red><%=SystemEnv.getHtmlLabelName(24676,user.getLanguage())%></font>
                <%}%>
		
				<!--TD4262 增加提示信息  开始-->
				<%
				    if(modeid>0 && "1".equals(ismode)){
				%>
				<div id="divFavContent18982" style="display:none">  <!--流程提交成功。-->
					<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
						<tr height="22">
							<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18982,user.getLanguage())%>
							</td>
						</tr>
					</table>
				</div>
				
				<div id="divFavContent18983" style="display:none"> <!--流程退回成功。-->
					<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
						<tr height="22">
							<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18983,user.getLanguage())%>
							</td>
						</tr>
					</table>
				</div>
				<div id="divFavContent19205" style="display:none"> <!--正在获取数据。-->
					<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
						<tr height="22">
							<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
							</td>
						</tr>
					</table>
				</div>
				<%
				    }else{
				%>
				<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
				</div>
				<%
					}
				%>
				<!--TD4262 增加提示信息  结束-->
				
				</td>
			</tr>
		</table>
</body>
</html>

<script language="JavaScript">

//TD4262 增加提示信息  开始
//提示窗口
<%
  if(modeid>0 && "1".equals(ismode)){
%>
var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
function showObjectPopup(contentBox){
  try{ 
  var iX=document.body.offsetWidth/2-50;
	var iY=document.body.offsetHeight/2+document.body.scrollTop-50;

	var oPopBody = oPopup.document.body;
  oPopBody.style.border = "1px solid #8888AA";
  oPopBody.style.backgroundColor = "white";
  oPopBody.style.position = "absolute";
  oPopBody.style.padding = "0px";
  oPopBody.style.zindex = 150;

  oPopBody.innerHTML = contentBox.innerHTML;

  oPopup.show(iX, iY, 180, 22, document.body);
 }catch(e){} 

}
function displaydivSign()
{
  if(oDivSign.style.display == ""){
      oDivSign.style.display = "none";
      workflowSignLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(21199,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"&&oDivSign.style.display == "none"){
		    oDivAll.style.display = "none";
          spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
  }
  else{
      oDivSign.style.display = "";
      workflowSignLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(21200,user.getLanguage())%></font>";
  }
}
function ajaxinit(){
  var ajax=false;
  try {
      ajax = new ActiveXObject("Msxml2.XMLHTTP");
  } catch (e) {
      try {
          ajax = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
          ajax = false;
      }
  }
  if (!ajax && typeof XMLHttpRequest!='undefined') {
  ajax = new XMLHttpRequest();
  }
  return ajax;
}
function showallreceived(operator,operatedate,operatetime,returntdid,viewLogIds,logtype,destnodeid){
  <%
  if(modeid>0 && "1".equals(ismode)){
  %>
  showObjectPopup(document.getElementById("divFavContent19205"));
  <%}else{%>
  showPrompt("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
  <%}%>
  var ajax=ajaxinit();
  ajax.open("POST", "WorkflowReceiviedPersons.jsp", true);
  ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  ajax.send("requestid=<%=requestid%>&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
  //获取执行状态
  ajax.onreadystatechange = function() {
      //如果执行状态成功，那么就把返回信息写到指定的层里
      if (ajax.readyState == 4 && ajax.status == 200) {
          try{
          document.getElementById(returntdid).innerHTML = ajax.responseText;
          }catch(e){}
          hiddenPop();
      }
  }
}
function displaydiv_1()
{
  if(WorkFlowDiv.style.display == ""){
      WorkFlowDiv.style.display = "none";
      //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
  }
  else{
      WorkFlowDiv.style.display = "";
      //WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
  }
}
function openSignPrint() {
var redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
<%//解决相关流程打印权限问题  
if(wflinkno>=0){
%>
redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>";
<%}%>  
var width = screen.width ;
var height = screen.height ;
if (height == 768 ) height -= 75 ;
if (height == 600 ) height -= 60 ;
var szFeatures = "top=0," ;
szFeatures +="left=0," ;
szFeatures +="width="+width+"," ;
szFeatures +="height="+height+"," ;
szFeatures +="directories=no," ;
szFeatures +="status=yes," ;
szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
szFeatures +="scrollbars=yes," ;

szFeatures +="resizable=yes" ; //channelmode
window.open(redirectUrl,"",szFeatures) ;
}        
<%
  }
%>
//TD4262 增加提示信息  结束

	var bodyiframeurl = location.href.substring(location.href.indexOf("ViewRequest.jsp?")+16);
	function setbodyiframe(){
		document.getElementById("bodyiframe").src="ViewRequestIframe.jsp?"+bodyiframeurl;
		initNewRequestFrame();
		eventPush(document.getElementById('bodyiframe'),'load',loadcomplete);		
	}
	//window.attachEvent("onload", setbodyiframe);
	if (window.addEventListener){
	    window.addEventListener("load", setbodyiframe, false);
	}else if (window.attachEvent){
	    window.attachEvent("onload", setbodyiframe);
	}else{
	    window.onload=setbodyiframe;
	}

    var wftitle="<%=titlename%>";
	var isfromtab=<%=isfromtab%>;	
	var bar=eval("<%=strBar%>");
	if("<%=seeflowdoc%>"=="1"){
		bar = eval("[]");
		if(document.getElementById("rightMenu")!=null){
			document.getElementById("rightMenu").style.display="none";
		}
	}
</script>