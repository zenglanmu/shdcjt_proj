<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="flowDoc" class="weaver.workflow.request.RequestDoc" scope="page"/>
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="RequestDetailImport" class="weaver.workflow.request.RequestDetailImport" scope="page" />
<%
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%> 
<%
int fromtest = Util.getIntValue(request.getParameter("fromtest"), 0);
//获得工作流的基本信息
String workflowid = Util.null2String(request.getParameter("workflowid"));
String workflowname = WorkflowComInfo.getWorkflowname(workflowid);
String workflowtype = WorkflowComInfo.getWorkflowtype(workflowid);   //工作流种类
String importwf= WorkflowComInfo.getIsImportwf(workflowid);//可导入流程
String nodeid= "" ;
String formid= "" ;
String isbill="0";
int helpdocid = 0;
int messageType=0;
int defaultName=0;
String docCategory="";
String isannexupload="";
String annexdocCategory="";
String needAffirmance="";   //是否需要提交确认
String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
String isworkflowdoc = "0";//是否是公文,1代表是
//把session存储在SESSION中，供浏览框调用，达到不同的流程可以使用同一浏览框，不同的条件
session.setAttribute("workflowidbybrowser",workflowid);

//获得当前用户的id，类型和名称。如果类型为1，表示为内部用户（人力资源），2为外部用户（CRM）
int userid = user.getUID();
String logintype = user.getLogintype();
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String custompage = "";
//查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
RecordSet.executeProc("workflow_Workflowbase_SByID",workflowid);
if(RecordSet.next()){
	formid = Util.null2String(RecordSet.getString("formid"));
	isbill = ""+Util.getIntValue(RecordSet.getString("isbill"),0);
	helpdocid = Util.getIntValue(RecordSet.getString("helpdocid"),0);
  //modify by xhheng @20050318 for TD1689, 顺便将messageType、docCategory的获取统一至此
  messageType=RecordSet.getInt("messageType");
  defaultName=RecordSet.getInt("defaultName");
  docCategory=RecordSet.getString("docCategory");
  isannexupload=Util.null2String(RecordSet.getString("isannexUpload"));
  annexdocCategory=Util.null2String(RecordSet.getString("annexdoccategory"));
    needAffirmance=Util.null2o(RecordSet.getString("needAffirmance"));
	custompage = Util.null2String(RecordSet.getString("custompage"));
}

//查询该工作流的当前节点id （即改工作流的创建节点 ）
RecordSet.executeProc("workflow_CreateNode_Select",workflowid);
if(RecordSet.next())  nodeid = Util.null2String(RecordSet.getString(1)) ;


//检查用户是否有创建权限
RequestCheckUser.setUserid(userid);
RequestCheckUser.setWorkflowid(Util.getIntValue(workflowid,0));
RequestCheckUser.setLogintype(logintype);
RequestCheckUser.checkUser();
int  hasright=RequestCheckUser.getHasright();
//modify by mackjoe at 2005-09-14 增加代理新建流程权限
int isagent=Util.getIntValue(request.getParameter("isagent"),0);
int beagenter=Util.getIntValue(request.getParameter("beagenter"),0);
if(isagent==1){
    hasright=1;
}
session.setAttribute(workflowid+"isagent"+user.getUID(),""+isagent);
session.setAttribute(workflowid+"beagenter"+user.getUID(),""+beagenter);
//end by mackjoe
if(hasright==0){
	response.sendRedirect("/notice/noright.jsp");
    return;
}
//判断是否有流程创建文档，并且在该节点是有正文字段
boolean docFlag=flowDoc.haveDocFiled(workflowid,nodeid);
String  docFlagss=docFlag?"1":"0";
session.setAttribute("requestAdd"+user.getUID(),docFlagss);

//判断正文字段是否显示选择按钮
ArrayList newTextList = flowDoc.getDocFiled(workflowid);
if(newTextList != null && newTextList.size() > 0){
  String newTextNodes = ""+newTextList.get(5);
  String flowDocField = ""+newTextList.get(1);
  session.setAttribute("requestFlowDocField"+user.getUID(),flowDocField);
  session.setAttribute("requestAddNewNodes"+user.getUID(),newTextNodes);
}

if (!fromFlowDoc.equals("1"))
{
if (docFlag)
{
isworkflowdoc = "1";
//response.sendRedirect("WorkflowAddRequestDocBody.jsp?workflowid="+workflowid+"&isagent="+isagent);
//return;
}
}
//对不同的模块来说,可以定义自己相关的内容，作为请求默认值，比如将 docid 赋值，作为该请求的默认文档
//默认的值可以赋多个，中间用逗号格开

String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
String reqid = Util.null2String(request.getParameter("reqid"));
if(hrmid.equals("") && logintype.equals("1")) hrmid = "" + userid ;
if(crmid.equals("") && logintype.equals("2")) crmid = "" + userid ;

//工作流建立完成后将返回的页面
String topage = Util.null2String(request.getParameter("topage"));
if(isbill.equals("1")){
	session.setAttribute("topage_ForAllBill",topage);
}



//获得当前的日期和时间
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

//请求提交的时候需要检查必输的字段名，多个必输项用逗号格开，requestname为新建请求中第一行的请求说明，是每一个请求都必须有的
String needcheck="requestname";



//TopTitle.jsp 页面参数
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	+SystemEnv.getHtmlLabelName(125,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(125,user.getLanguage());

//if(helpdocid !=0 ) {titlename=titlename + "";}
String needfav ="1";
String needhelp ="";

//add by xhheng @20050206 for TD 1544，requestid设为-1
String requestid="-1";
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int showdes=0;
String isSignMustInputOfThisJsp="0";
String isFormSignatureOfThisJsp=null;
String FreeWorkflowname="";
int formSignatureWidthOfThisJsp=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeightOfThisJsp=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select ismode,showdes,isFormSignature,formSignatureWidth,formSignatureHeight,freewfsetcurnameen,freewfsetcurnametw,freewfsetcurnamecn,issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
String hasModeSign="0";
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
	isFormSignatureOfThisJsp = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidthOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeightOfThisJsp= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
    if(user.getLanguage() == 8){
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnameen"));
    }
    else if(user.getLanguage() == 9)
    {
    	FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnametw"));
    }
    else {
        FreeWorkflowname=Util.null2String(RecordSet.getString("freewfsetcurnamecn"));
    }
    isSignMustInputOfThisJsp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
int isUseWebRevisionOfThisJsp = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevisionOfThisJsp != 1){
	isFormSignatureOfThisJsp = "";
}

//---------------------------------------------------------------------------------
//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
//---------------------------------------------------------------------------------
//模板模式-如果用户使用的是非IE则自动使用一般模式来显示流程 START 2011-11-23 CC
//if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {
if (!isIE.equalsIgnoreCase("true") && ismode.equals("1")) {
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
// 跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
//---------------------------------------------------------------------------------

if(ismode.equals("1") && showdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill="+isbill);
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
session.setAttribute(userid+"_"+logintype+"username",username);
session.setAttribute(userid+"_"+workflowid+"workflowname",workflowname);
session.setAttribute(userid+"_"+workflowid+"isannexupload",isannexupload);
session.setAttribute(userid+"_"+workflowid+"annexdocCategory",annexdocCategory);     
session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
boolean IsFreeWorkflow=WFForwardManager.getIsFreeWorkflow(Util.getIntValue(requestid),Util.getIntValue(nodeid),0);
boolean isImportDetail=RequestDetailImport.getAllowesImport(Util.getIntValue(requestid),Util.getIntValue(workflowid),Util.getIntValue(nodeid),0,user);

String createpage = "";//TD11055 DS 下面需要公用，定义移到上面
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver.js"></script>

<script language=javascript src="/js/xmlextras.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>         
<script type="text/javascript" language="javascript" src="/js/jquery/jquery.js"></script>
<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf.js"></script>
<script language="javascript">
<%if(!ismode.equals("1") || modeid<1){%>
function setwtableheight(){
    /*
    var totalheight=5;
    var bodyheight=document.body.clientHeight;
    if($GetEle("divTopTitle")!=null){
        totalheight+=$GetEle("divTopTitle").clientHeight;
    }
    <%if (fromFlowDoc.equals("1")){%>
        totalheight+=100;
        bodyheight=parent.document.body.clientHeight;
    <%}%>
    $GetEle("w_table").height=bodyheight-totalheight;
    */
}
window.onresize = function (){
    setwtableheight();
}
<%}else{%>
function windowonload(){
    init();
    funcremark_log();
}
<%}%>
</script>
<style>
.wordSpan{font-family:MS Shell Dlg,Arial;CURSOR: hand;font-weight:bold;FONT-SIZE: 10pt}
</style>

</head>
<BODY id="flowbody"  <%if(ismode.equals("1") && modeid>0){%> onload="windowonload()" <%}else{%> onload="setwtableheight()"<%}%>>
<%if (!fromFlowDoc.equals("1")) {%>
<%@ include file="RequestTopTitle.jsp" %>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%//TD9145
Prop prop = Prop.getInstance();
String ifchangstatus = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String sqlselectName = "select * from workflow_nodecustomrcmenu where wfid="+workflowid+" and nodeid="+nodeid;
RecordSet.executeSql(sqlselectName);
String submitName = "";
String subnobackName = "";//提交不需反馈
String subbackName = "";//提交需反馈
String hasnoback = "";//使用提交不需反馈按钮
String hasback = "";//使用提交需反馈按钮
String saveName = "";
String newWFName = "";//新建流程按钮
String newSMSName = "";//新建短信按钮
String haswfrm = "";//是否使用新建流程按钮
String hassmsrm = "";//是否使用新建短信按钮
int t_workflowid = 0;//新建流程的ID
String strBar = "[";//菜单
if(RecordSet.next()){
	if(user.getLanguage() == 7){
		submitName = Util.null2String(RecordSet.getString("submitName7"));
		saveName = Util.null2String(RecordSet.getString("saveName7"));
		newWFName = Util.null2String(RecordSet.getString("newWFName7"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName7"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName7"));
		subbackName = Util.null2String(RecordSet.getString("subbackName7"));
	}else if(user.getLanguage() == 9){
		submitName = Util.null2String(RecordSet.getString("submitName9"));
		saveName = Util.null2String(RecordSet.getString("saveName9"));
		newWFName = Util.null2String(RecordSet.getString("newWFName9"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName9"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName9"));
		subbackName = Util.null2String(RecordSet.getString("subbackName9"));
	}
	else{
		submitName = Util.null2String(RecordSet.getString("submitName8"));
		saveName = Util.null2String(RecordSet.getString("saveName8"));
		newWFName = Util.null2String(RecordSet.getString("newWFName8"));
		newSMSName = Util.null2String(RecordSet.getString("newSMSName8"));
		subnobackName = Util.null2String(RecordSet.getString("subnobackName8"));
		subbackName = Util.null2String(RecordSet.getString("subbackName8"));
	}
	haswfrm = Util.null2String(RecordSet.getString("haswfrm"));
	hassmsrm = Util.null2String(RecordSet.getString("hassmsrm"));
	hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
	hasback = Util.null2String(RecordSet.getString("hasback"));
	t_workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
}
if("".equals(submitName)){
	submitName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
}
if("".equals(saveName)){
	saveName = SystemEnv.getHtmlLabelName(86,user.getLanguage());
}
if("".equals(FreeWorkflowname.trim())){
	FreeWorkflowname = SystemEnv.getHtmlLabelName(21781,user.getLanguage());
}    
if("".equals(subbackName)){
	if("1".equals(hasnoback) || "1".equals(hasback)){
		subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21761,user.getLanguage())+"）";
	}else{
		subbackName = SystemEnv.getHtmlLabelName(615,user.getLanguage());
	}
}
if("".equals(subnobackName)){
	subnobackName = SystemEnv.getHtmlLabelName(615,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21762,user.getLanguage())+"）";
}
if("".equals(ifchangstatus)){
	if(!needAffirmance.equals("1")){
		RCMenu += "{"+submitName+",javascript:doSubmitBack(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){doSubmitBack(this);}},";
	}else{
		RCMenu += "{"+submitName+",javascript:doAffirmanceBack(this),_self}";
		RCMenuHeight += RCMenuHeightStep;
        strBar += "{text: '"+submitName+"',iconCls:'btn_submit',handler: function(){doAffirmanceBack(this);}},";
	}
}else{//必须至少有一个按钮
	if(!needAffirmance.equals("1")){
		if(!"1".equals(hasnoback)){
			RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:doSubmitBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doSubmitBack(this);}},";
			}
			RCMenu += "{"+subnobackName+",javascript:doSubmitNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){doSubmitNoBack(this);}},";
		}
	}else{
		if(!"1".equals(hasnoback)){
			RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
            strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doAffirmanceBack(this);}},"; 
		}else{
			if("1".equals(hasback)){
				RCMenu += "{"+subbackName+",javascript:doAffirmanceBack(this),_self}";
				RCMenuHeight += RCMenuHeightStep;
                strBar += "{text: '"+subbackName+"',iconCls:'btn_subbackName',handler: function(){doAffirmanceBack(this);}},"; 
			}
			RCMenu += "{"+subnobackName+",javascript:doAffirmanceNoBack(this),_self}";
			RCMenuHeight += RCMenuHeightStep;
			strBar += "{text: '"+subnobackName+"',iconCls:'btn_subnobackName',handler: function(){doAffirmanceNoBack(this);}},";
		}
	}
}
if(IsFreeWorkflow){
    RCMenu += "{"+FreeWorkflowname+",javascript:doFreeWorkflow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+FreeWorkflowname+"',iconCls:'btn_edit',handler: function(){doFreeWorkflow(this);}},";
}
if(isImportDetail){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(26255,user.getLanguage())+",javascript:doImportDetail(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
}
if("1".equals(importwf)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(24270,user.getLanguage())+",javascript:doImportWorkflow(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    strBar += "{text: '"+SystemEnv.getHtmlLabelName(24270,user.getLanguage())+"',iconCls:'btn_edit',handler: function(){doImportWorkflow(this);}},";
}
RCMenu += "{"+saveName+",javascript:doSave_nNew(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
strBar += "{text: '"+saveName+"',iconCls:'btn_wfSave',handler: function(){doSave_nNew();}},";
if("1".equals(haswfrm)){
	if("".equals(newWFName)){
		newWFName = SystemEnv.getHtmlLabelName(1239,user.getLanguage());
	}
	RequestCheckUser.resetParameter();
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setWorkflowid(t_workflowid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.checkUser();
	int  t_hasright=RequestCheckUser.getHasright();
	if(t_hasright == 1){
		RCMenu += "{"+newWFName+",javascript:onNewRequest("+t_workflowid+",0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
        strBar += "{text: '"+newWFName+"',iconCls:'btn_newWFName',handler: function(){onNewRequest("+t_workflowid+",0);}},";
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
	RCMenu += "{"+newSMSName+",javascript:onNewSms("+workflowid+", "+nodeid+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	strBar += "{text: '"+newSMSName+"',iconCls:'btn_newSMSName',handler: function(){onNewSms("+workflowid+", "+nodeid+");}},";
}

if(strBar.lastIndexOf(",")>-1) strBar = strBar.substring(0,strBar.lastIndexOf(","));
strBar+="]";
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

		<input type=hidden name=_isagent id=_isagent value="<%=isagent%>">
        <input type=hidden name=_beagenter id="_beagenter" value="<%=beagenter%>">
		<input type=hidden name=isworkflowdoc id="isworkflowdoc" value="<%=isworkflowdoc%>">		

			<%
            //add by mackjoe at 2005-12-20 增加模板应用
            if(modeid>0 && "1".equals(ismode)){
            %>
                <jsp:include page="modehead.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="topage" value="<%=topage%>" />
                <jsp:param name="needcheck" value="<%=needcheck%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="messageType" value="<%=messageType%>" />
                <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
				</jsp:include>
                <jsp:include page="/workflow/mode/loadmode.jsp" flush="true">
                <jsp:param name="modeid" value="<%=modeid%>" />
                <jsp:param name="isform" value="<%=isform%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />    
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="isFormSignature" value="<%=isFormSignatureOfThisJsp%>" />
				</jsp:include>
                <jsp:include page="hiddenfield.jsp" flush="true">
				<jsp:param name="workflowid" value="<%=workflowid%>" />
				<jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="billid" value="<%=formid%>" />    
                <jsp:param name="docCategory" value="<%=docCategory%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="prjid" value="<%=prjid%>" />
				<jsp:param name="reqid" value="<%=reqid%>" />
                <jsp:param name="docid" value="<%=docid%>" />
                <jsp:param name="crmid" value="<%=crmid%>" />
                <jsp:param name="hrmid" value="<%=hrmid%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="currenttime" value="<%=currenttime%>" />
                <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
                <jsp:param name="isFormSignature" value="<%=isFormSignatureOfThisJsp%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="isSignMustInput" value="<%=isSignMustInputOfThisJsp%>" />
				</jsp:include>
				<%
				//模板中是否设置签字字段，如果设置了按模板模式显示，如果没有设置按以前模式显示
				RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-4");
				if(!RecordSet.next()){%>
                <jsp:include page="modeend.jsp" flush="true" >
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="isFormSignature" value="<%=isFormSignatureOfThisJsp%>" />
                <jsp:param name="formSignatureWidth" value="<%=formSignatureWidthOfThisJsp%>" />
                <jsp:param name="formSignatureHeight" value="<%=formSignatureHeightOfThisJsp%>" />
                <jsp:param name="isSignMustInput" value="<%=isSignMustInputOfThisJsp%>" />
                </jsp:include>
         <%}else{
         		hasModeSign="1";%>
            <script>
                function funcremark_log() {
                }
            </script>
         <%}%>
		 <input type="hidden" name="needwfback" id="needwfback" value="1" />
            </form>
            <%
            }else{
            //end by mackjoe
			String operationpage = "" ;
            String hasfileup="";
			if(isbill.equals("1")) {
				RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
				if(RecordSet.next())  {
					createpage = Util.null2String(RecordSet.getString("createpage"));
					operationpage = Util.null2String(RecordSet.getString("operationpage"));
                    hasfileup=Util.null2String(RecordSet.getString("hasfileup"));
				}
			}

			//---------------------------------------------------------------------------------
			// 跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 START
			//---------------------------------------------------------------------------------
			if (!isIE.equalsIgnoreCase("true")) {
				if (isbill.equals("1") && formid.indexOf("-") == -1 && !createpage.equals("")) {
					if (!"180".equals(formid) && !"85".equals(formid) &&!"7".equals(formid) && !"79".equals(formid) && !"158".equals(formid) && !"157".equals(formid) && !"156".equals(formid) ) {
						//response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=15590");
			%>

			<script type="text/javascript">

			window.parent.location.href = "/wui/common/page/sysRemind.jsp?labelid=27826";

			</script>

			<%
						return;
					}
				}
			}
			//---------------------------------------------------------------------------------
			//跨浏览器添加-当前浏览器是非IE，表单为单据，并且是未修改的单据，则跳转至公共页面 END
			//---------------------------------------------------------------------------------
			
			
			if( ! createpage.equals("") ) {
			%>
				<jsp:include page="<%=createpage%>" flush="true">
				<jsp:param name="workflowid" value="<%=workflowid%>" />
				<jsp:param name="workflowtype" value="<%=workflowtype%>" />
				<jsp:param name="nodeid" value="<%=nodeid%>" />
				<jsp:param name="formid" value="<%=formid%>" />
				<jsp:param name="prjid" value="<%=prjid%>" />
				<jsp:param name="reqid" value="<%=reqid%>" />
				<jsp:param name="docid" value="<%=docid%>" />
				<jsp:param name="hrmid" value="<%=hrmid%>" />
				<jsp:param name="crmid" value="<%=crmid%>" />
				<jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
				<jsp:param name="topage" value="<%=topage%>" />
				<jsp:param name="docCategory" value="<%=docCategory%>" />
				<jsp:param name="currentdate" value="<%=currentdate%>" />
				<jsp:param name="currenttime" value="<%=currenttime%>" />
        <jsp:param name="helpdocid" value="<%=Integer.toString(helpdocid)%>" />
        <jsp:param name="messageType" value="<%=messageType%>" />
        <jsp:param name="defaultName" value="<%=defaultName%>" />
		<jsp:param name="isSignMustInput" value="<%=isSignMustInputOfThisJsp%>" />
				</jsp:include>
			<%
			} else{
        //modify by xhheng @20050315 for 附件上传
				if( operationpage.equals("") ){
          operationpage = "RequestOperation.jsp" ;
          %>
          <form name="frmmain" method="post"  action="<%=operationpage%>" enctype="multipart/form-data">
          <%
        }else{
          if(hasfileup.equals("1")){
          %>
            <form name="frmmain" method="post"  action="<%=operationpage%>" enctype="multipart/form-data">
          <%}else{%>
          <form name="frmmain" method="post" action="<%=operationpage%>" enctype="multipart/form-data">
          <%
            }
        }
        if("2".equals(ismode) && modeid>0){
		%>
			<jsp:include page="WorkflowAddRequestHtml.jsp" flush="true">
				<jsp:param name="modeid" value="<%=modeid%>" />
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
                <jsp:param name="docCategory" value="<%=docCategory%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
				<jsp:param name="nodetype" value="0" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="currenttime" value="<%=currenttime%>" />
                <jsp:param name="needcheck" value="<%=needcheck%>" />
                <jsp:param name="prjid" value="<%=prjid%>" />
                <jsp:param name="reqid" value="<%=reqid%>" />
                <jsp:param name="docid" value="<%=docid%>" />
                <jsp:param name="hrmid" value="<%=hrmid%>" />
                <jsp:param name="crmid" value="<%=crmid%>" />
                <jsp:param name="messageType" value="<%=messageType%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="topage" value="<%=topage%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
				<jsp:param name="iscreate" value="1" />
				<jsp:param name="isremark" value="0" />
            </jsp:include>
		<%}else{%>
			<jsp:include page="WorkflowAddRequestBodyAction.jsp" flush="true">
                <jsp:param name="workflowid" value="<%=workflowid%>" />
                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
                <jsp:param name="docCategory" value="<%=docCategory%>" />
                <jsp:param name="nodeid" value="<%=nodeid%>" />
                <jsp:param name="requestid" value="<%=requestid%>" />
                <jsp:param name="isbill" value="<%=isbill%>" />
                <jsp:param name="formid" value="<%=formid%>" />
                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
                <jsp:param name="currentdate" value="<%=currentdate%>" />
                <jsp:param name="currenttime" value="<%=currenttime%>" />
                <jsp:param name="needcheck" value="<%=needcheck%>" />
                <jsp:param name="prjid" value="<%=prjid%>" />
                <jsp:param name="reqid" value="<%=reqid%>" />
                <jsp:param name="docid" value="<%=docid%>" />
                <jsp:param name="hrmid" value="<%=hrmid%>" />
                <jsp:param name="crmid" value="<%=crmid%>" />
                <jsp:param name="messageType" value="<%=messageType%>" />
                <jsp:param name="defaultName" value="<%=defaultName%>" />
                <jsp:param name="topage" value="<%=topage%>" />
                <jsp:param name="logintype" value="<%=logintype%>" />
                <jsp:param name="userid" value="<%=userid%>" />
                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
            </jsp:include>
		<%}%>
			<input type="hidden" name="needwfback"  id="needwfback" value="1"/>
			</form>
			<%}
            }%>			

			<%
				if(!custompage.equals("")){
			%>
					<jsp:include page="<%=custompage%>" flush="true">
		                <jsp:param name="workflowid" value="<%=workflowid%>" />
		                <jsp:param name="workflowtype" value="<%=workflowtype%>" />
		                <jsp:param name="docCategory" value="<%=docCategory%>" />
		                <jsp:param name="nodeid" value="<%=nodeid%>" />
		                <jsp:param name="requestid" value="<%=requestid%>" />
		                <jsp:param name="isbill" value="<%=isbill%>" />
		                <jsp:param name="formid" value="<%=formid%>" />
		                <jsp:param name="fromFlowDoc" value="<%=fromFlowDoc%>" />
		                <jsp:param name="currentdate" value="<%=currentdate%>" />
		                <jsp:param name="currenttime" value="<%=currenttime%>" />
		                <jsp:param name="needcheck" value="<%=needcheck%>" />
		                <jsp:param name="prjid" value="<%=prjid%>" />
		                <jsp:param name="reqid" value="<%=reqid%>" />
		                <jsp:param name="docid" value="<%=docid%>" />
		                <jsp:param name="hrmid" value="<%=hrmid%>" />
		                <jsp:param name="crmid" value="<%=crmid%>" />
		                <jsp:param name="messageType" value="<%=messageType%>" />
		                <jsp:param name="defaultName" value="<%=defaultName%>" />
		                <jsp:param name="topage" value="<%=topage%>" />
		                <jsp:param name="logintype" value="<%=logintype%>" />
		                <jsp:param name="userid" value="<%=userid%>" />
		                <jsp:param name="languageid" value="<%=user.getLanguage()%>" />
		            </jsp:include>
			<%		
				}
			%>
        
		
<SCRIPT LANGUAGE="JavaScript">
<%--added by xwj for td3247 20051201--%>
window.onbeforeunload=function protectCreatorFlow(event){
		//modified by cyril on 20080605 for td8828
		var opt = true;
		try {
			opt = document.getElementById('src').value=='';
		}
		catch(e){
			opt = true;
		}
		if(opt && !checkDataChange())
    return "<%=SystemEnv.getHtmlLabelName(18674,user.getLanguage())%>";
}
function showWFHelp(docid){
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var operationPage = "/docs/docs/DocDsp.jsp?id="+docid;
    window.open(operationPage,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
function onNewRequest(wfid,agent){
	var redirectUrl =  "AddRequest.jsp?workflowid="+wfid+"&isagent="+agent;
	var width = screen.availWidth-10 ;
	var height = screen.availHeight-50 ;
	var szFeatures = "top=0," ;
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
function onNewSms(wfid, nodeid){
	var redirectUrl =  "/sms/SendRequestSms.jsp?workflowid="+wfid+"&nodeid="+nodeid;
	var width = screen.availWidth/2;
	var height = screen.availHeight/2;
	var top = height/2;
	var left = width/2;
	var szFeatures = "top="+top+"," ;
	szFeatures +="left="+left+"," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ;
	szFeatures +="directories=no," ;
	szFeatures +="status=yes,toolbar=no,location=no," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	window.open(redirectUrl,"",szFeatures) ;
}
function doSubmitBack(obj){
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doSubmit(obj);
}
function doSubmitNoBack(obj){
	document.getElementById("needwfback").value = "0";
	getRemarkText_log();
	doSubmit(obj);
}
function doRemark_nBack(obj){
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doRemark_n(obj);
}
function doRemark_nNoBack(obj){
	document.getElementById("needwfback").value = "0";
	getRemarkText_log();
	doRemark_n(obj);
}
function doAffirmanceBack(obj){
	document.getElementById("needwfback").value = "1";
	getRemarkText_log();
	doAffirmance(obj);
}
function doAffirmanceNoBack(obj){
	document.getElementById("needwfback").value = "0";
	getRemarkText_log();
	doAffirmance(obj);
}
function doSave_nNew(){
	getRemarkText_log();
	doSave();
}
function getRemarkText_log(){
	try{
		
		var reamrkNoStyle = CkeditorExt.getText("remark");
		
		if(reamrkNoStyle == ""){
			document.getElementById("remarkText10404").value = reamrkNoStyle;
		}else{
			var remarkText = CkeditorExt.getTextNew("remark");
			document.getElementById("remarkText10404").value = remarkText;
		}
		for(var i=0; i<CkeditorExt.editorName.length; i++){
			var tmpname = CkeditorExt.editorName[i];
			try{
				if(tmpname == "remark"){
					continue;
				}
				$(tmpname).value = CkeditorExt.getText(tmpname);
			}catch(e){}
		}
	}catch(e){
		
	}
}
function uescape(url){
    return escape(url);
}
</SCRIPT>
<%  
if(modeid<1 || ismode.equals("2")){
%>


<script type="text/javascript">

function onShowBrowser(id,url,linkurl,type1,ismand) {
	var funFlag = "";
	var id1 = null;
	
    if (type1 == 9  && <%=docFlag%>) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}

    spanname = "field" + id + "span";
    inputname = "field" + id;
	if (type1 == 2 || type1 == 19 ) {
		if (type1 == 2) {
			onWorkFlowShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
			id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);

					$GetEle("field"+id).value= resourceids
					
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];

						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						$GetEle("field"+id).value = ids;
						sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return ;
				   }

				   if (type1 == 16) {
					   curid = wuiUtil.getJsonValueByIndex(id1, 0);
                   	   linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                   if (linkno>0) {
	                       curid = curid + "&wflinkno=" + linkno;
	                   } else {
	                       linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
	                   }
	                   $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
					   if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
						   $GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1)+ "</a>&nbsp";
					   } else {
	                       $GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
					   }
	                   return;
				   }
				   
	               if (type1 == 9 && <%=docFlag%>) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && <%=docFlag%>) {
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("");
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && <%=docFlag%>){
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=CreateNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
	}
}

function getDate(i) {
	var returndate = window.showModalDialog("/systeminfo/Calendar.jsp","","dialogHeight:320px;dialogwidth:275px")
	$GetEle("datespan"  + i).innerHTML= returndate;
	$GetEle("dff0" + i).value=returndate;
}

function onShowSignBrowser(url,linkurl,inputname,spanname,type1) {
	var tmpids = document.getElementById(inputname).value
	var id1 = null;
	if (type1 == 37) {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids, "", "dialogWidth:550px;dialogHeight:550px;");
	} else {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids, "", "dialogWidth:550px;dialogHeight:550px;");
	}
    if (wuiUtil.isNotNull(id1)) {
	   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = ""
				resourceids = resourceids.substr(1);
				resourcename = resourcename.substr(1);
				$GetEle(inputname).value = resourceids;

				var resourceidArray = resourceids.split(",");
				var resourcenameArray = resourcename.split(",");

				for (var _i=0; _i<resourceidArray.length; _i++) {
					var curid = resourceidArray[_i];
					var curname = resourcenameArray[_i];
					
					sHtml = sHtml + "<a href=" + linkurl + curid + " target='_blank'>" + curname + "</a>&nbsp";
				}
				
				$GetEle(spanname).innerHTML = sHtml;

	   } else {
			    $GetEle(spanname).innerHTML = "";
				$GetEle(inputname).value="";
	   }
    }
}
</script>
<%}%>
<!-- add by xhheng @20050206 for TD 1544-->
<script language="javascript">
var isfirst = 0 ;
var objSubmit="";
function displaydiv()
{
    if(oDivAll.style.display == ""){
		oDivAll.style.display = "none";
		oDivInner.style.display = "none";
        oDiv.style.display = "none";

        spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
    }
    else{
        if(isfirst == 0) {
        	$GetEle("picInnerFrame").src="/workflow/request/WorkflowRequestPictureInner.jsp?fromFlowDoc=<%=fromFlowDoc%>&modeid=<%=modeid%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";				
        	$GetEle("picframe").src="/workflow/request/WorkflowRequestPicture.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&isbill=<%=isbill%>&formid=<%=formid%>";

            isfirst ++ ;
        }

        spanimage.innerHTML = "<img src='/images/ArrowUpGreen.gif' border=0>" ;
		oDivAll.style.display = "";
		oDivInner.style.display = "";
        oDiv.style.display = "";
        workflowStatusLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19678,user.getLanguage())%></font>";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}


function displaydivOuter()
{
    if(oDiv.style.display == ""){
        oDiv.style.display = "none";
        workflowStatusLabelSpan.innerHTML="<font color=red><%=SystemEnv.getHtmlLabelName(19677,user.getLanguage())%></font>";
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"){
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
		if(oDiv.style.display == "none"&&oDivInner.style.display == "none"){
		    oDivAll.style.display = "none";
            spanimage.innerHTML = "<img src='/images/ArrowDownRed.gif' border=0>" ;
		}
    }
    else{
        oDivInner.style.display = "";
        workflowChartLabelSpan.innerHTML="<font color=green><%=SystemEnv.getHtmlLabelName(19676,user.getLanguage())%></font>";
    }
}



function doAffirmance(obj){          //<!-- 提交确认 -->
	    
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
				if(check_form($GetEle("frmmain"),$GetEle("needcheck").value+$GetEle("inputcheck").value)){
				   if($GetEle("formid").value == 85 || $GetEle("formid").value==163){ 
					  if(!checkmeetingtimeok()){
						  ischeckok = "false";
					  } else {
						  ischeckok="true";
					  }	  
					}else{
						ischeckok="true";
					}
				}       
			}catch(e){
			  ischeckok="false";
			}
			try{
				frmmain.ChinaExcel.EndCellEdit(true);
			}catch(e1){}

<%
	if(isSignMustInputOfThisJsp.equals("1")){
	    if("1".equals(isFormSignatureOfThisJsp)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>

            if(ischeckok=="true"){
                if(checktimeok()) {
                    <%if(isbill.equals("1") && Util.getIntValue(formid,0)<0 && "AddBillDataCenter.jsp".equalsIgnoreCase(createpage)){%>
                        objSubmit=obj;
					    checkReportData("Affirmance");						
					<%}else{%>
                        $GetEle("frmmain").src.value='save';
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                       //TD4262 增加提示信息  开始
	                   <%
    if(modeid>0 && "1".equals(ismode)){
%>
	                    contentBox = document.getElementById("divFavContent18979");
                        showObjectPopup(contentBox)
<%
    }else{
%>
		       var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
		       showPrompt(content);
<%
    }
%>

                        <%
                        topage = URLEncoder.encode(topage);
                        %>
                        $GetEle("frmmain").topage.value="ViewRequest.jsp?isaffirmance=1&reEdit=0&fromFlowDoc=<%=fromFlowDoc%>&topage=<%=topage%>";

//保存签章数据
<%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)){%>
	                    if(SaveSignature()){
                       //TD4262 增加提示信息  结束
                        obj.disabled=true;
                            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                        }else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
<%}else{%>
                       //TD4262 增加提示信息  结束
                        obj.disabled=true;
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}}%>
                    }
             }
        }
	}

    function doFreeWorkflow() {
    if (confirm("<%=SystemEnv.getHtmlLabelName(21798,user.getLanguage())%>")) {
        try {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        } catch(e) {
            var ischeckok = "";
            try {
                if (check_form($GetEle("frmmain"), $GetEle("needcheck").value + $GetEle("inputcheck").value))
                    ischeckok = "true";
            } catch(e) {
                ischeckok = "false";
            }
            if (ischeckok == "true") {
                if (checktimeok()) {
                    $GetEle("frmmain").src.value = 'save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                    //TD4262 增加提示信息  开始
                <%
                    if(modeid>0 && "1".equals(ismode)){
                %>
                    contentBox = document.getElementById("divFavContent18979");
                    showObjectPopup(contentBox)
                <%
                    }else{
                %>
                    var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                    showPrompt(content);
                <%
                    }
                %>
                    //TD4262 增加提示信息  结束
                <%
                topage = URLEncoder.encode(topage);
                %>
                    $GetEle("frmmain").topage.value = "ViewRequest.jsp";

//保存签章数据
                <%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)){%>
                    if (SaveSignature()) {
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                    } else {
                        if(isDocEmpty==1){
                        	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
                        	isDocEmpty=0;
                        }else{
                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                        }
                        return;
                    }
                <%}else{%>
                    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
                <%}%>
                }
            }
        }
    }
}

function doImportDetail() {
    if (confirm("<%=SystemEnv.getHtmlLabelName(21798,user.getLanguage())%>")) {
        try {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        } catch(e) {
            var ischeckok = "";
            try {
                if (check_form($GetEle("frmmain"), $GetEle("needcheck").value + $GetEle("inputcheck").value))
                    ischeckok = "true";
            } catch(e) {
                ischeckok = "false";
            }
            
            
            <%
            //签字意见是否必填
			 String isSignMustInputTemp="0";
			 RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
			 if(RecordSet.next()){
				 isSignMustInputTemp = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
			 }
				if(isSignMustInputTemp.equals("1")){
				    if("1".equals(isFormSignatureOfThisJsp)){
					}else{
			%>
			            if(ischeckok=="true"){
			            	getRemarkText_log();
						    if(!check_form($GetEle("frmmain"),'remarkText10404')){
							    ischeckok="false";
						    }
					    }
			<%
					}
				}
			%>
            
            if (ischeckok == "true") {
                if (checktimeok()) {
                    $GetEle("frmmain").src.value = 'save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                <%
                topage = URLEncoder.encode(topage);
                %>
                    $GetEle("frmmain").topage.value = "ViewRequest.jsp";

//保存签章数据
								<%if("1".equals(isFormSignatureOfThisJsp) && "0".equals(hasModeSign)){%>
                    if (SaveSignature()) {
                        //TD4262 增加提示信息  开始
                <%
                    if(ismode.equals("1")){
                %>
                        contentBox = document.getElementById("divFavContent18979");
                        showObjectPopup(contentBox)
                <%
                    }else{
                %>
                        var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                        showPrompt(content);
                <%
                    }
                %>
                        //TD4262 增加提示信息  结束
                        $GetEle("frmmain").submit();
                        enableAllmenu();
                    } else {
							if(isDocEmpty==1){
								alert("<%=SystemEnv.getHtmlLabelName(24839,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
                        return;
                    }
                <%}else{%>
                    //TD4262 增加提示信息  开始
                <%
                    if(ismode.equals("1")){
                %>
                    contentBox = document.getElementById("divFavContent18979");
                    showObjectPopup(contentBox)
                <%
                    }else{
                %>
                    var content = "<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                    showPrompt(content);
                <%
                    }
                %>
                    //TD4262 增加提示信息  结束
                    $GetEle("frmmain").submit();
                    enableAllmenu();
                <%}%>
                }
            }
        }
    }
}

function doImportWorkflow(){
    if(check_form($GetEle("frmmain"),"requestname")){
        window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+escape("/workflow/request/RequestImport.jsp?formid=<%=formid%>&isbill=<%=isbill%>&workflowid=<%=workflowid%>&status=2&ismode=<%=ismode%>"),window,"dialogWidth=600px;dialogHeight=500px");
    }
}
function doImport(reqid){
    if(reqid>0){
        if (check_form($GetEle("frmmain"), "requestname")){
        $GetEle("frmmain").src.value='import';
        $GetEle("frmmain").action = "RequestImportOption.jsp?newmodeid=<%=modeid%>&ismode=<%=ismode%>&imprequestid="+reqid;
        $GetEle("frmmain").enctype="multipart/form-data"
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
    <%
        if(modeid>0 && "1".equals(ismode)){
    %>
        contentBox = document.getElementById("divFavContent24272");
        showObjectPopup(contentBox)
    <%
        }else{
    %>
        var content = "<%=SystemEnv.getHtmlLabelName(24272,user.getLanguage())%>";
        showPrompt(content);
    <%
        }
    %>
        $GetEle("frmmain").submit();
        enableAllmenu();
        }
    }
}
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
<%if(fromtest==1){%>
function setAdiabled(){
	jQuery("a").attr("disabled", true);
	jQuery("a").attr("onclick", "");
	jQuery("a").attr("href", "");
	jQuery("a").attr("target", "_blank");
}
function setAdiabledLoad(){
	setAdiabled();
	setInterval(setAdiabled, 500);
}
jQuery(document).ready(function(){
	setAdiabledLoad();
});
<%}%>
</SCRIPT>

<!-- added by cyril on 20080605 for td8828-->
<script language=javascript src="/js/checkData.js"></script>
<script type="text/javascript" src="/js/swfupload/workflowswfupload.js"></script>
<div id="divFavContent18979" style="display:none"><!--正在保存流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
</body>
</html>