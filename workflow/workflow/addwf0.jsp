<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldManager" class="weaver.workflow.field.FieldManager" scope="session"/>
<jsp:useBean id="testWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page" />

<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
    	
		return;
	}
%>

<%
    String ajax=Util.null2String(request.getParameter("ajax"));
    //是否为流程模板
String isTemplate=Util.null2String(request.getParameter("isTemplate"));
int isSaveas=Util.getIntValue(request.getParameter("isSaveas"),0);
    if(!ajax.equals("1")){
%>
<!-- add by xhheng @20050204 for TD 1538-->
<script language=javascript src="/js/weaver.js"></script>
<%
    }
%>
<html>
<%
    int subCompanyId2 = -1;
	String type="";
	String title="";
	String wfname="";
	String wfdes="";
	String isbill = "3";
	String iscust = "0";
	String isremak="";
	String isShowChart = "";
	String isModifyLog = "0";
	String orderbytype = "";
    String isforwardrights="";
  String needmark = "" ;
  String messageType= "" ;
  String mailMessageType= "" ;//added by xwj for td2965 20051101
  String forbidAttDownload="";//禁止附件批量下载
  String docRightByOperator="";
  String multiSubmit= "" ;
  String defaultName= "1" ;
  String maincategory = "";
  String subcategory= "";
  String seccategory= "";
  String docPath = "";
  String isannexUpload="";
  String annexmaincategory = "";
  String annexsubcategory= "";
  String annexseccategory= "";
  String annexdocPath = "";
  String isaffirmance="";
  String wfdocpath="";
  String wfdocpathspan="";
  String wfdocownertype = "";
  String wfdocownerfieldid = "";
  String wfdocowner="";
  String wfdocownerspan="";
   String isImportDetail="";
  int selectedCateLog = 0;
  int catelogType = 0;
  int docRightByHrmResource = 0;//added by pony for Td4611 on 2006/06/26
  String showUploadTab = "";
  String isSignDoc="";
  String showDocTab="";
  String isSignWorkflow="";
  String showWorkflowTab="";
  boolean isdocRightByHrmResource = false;
  int templateid=Util.getIntValue(request.getParameter("templateid"),0);
  String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
  String templatename="";
  String candelacc="";//是否允许创建人删除附件
  String ShowDelButtonByReject="1";
  
  String specialApproval = "0";	//是否特批件
  String Frequency = "0";	
  String Cycle = "1";
  
  String isrejectremind="0";
  String isneeddelacc="0";
  String ischangrejectnode="0";
      String isselectrejectnode="0";
  String isimportwf="0";
  String issignview="0";
  String newdocpath="";
  String newdocpathspan="";
	int helpdocid=0;
  String isvalid="1";
  String nosynfields = "";
  String nosynfieldsStr = "";
  String SAPSource = "";
	int wfid=0;
	int formid=0;
	int typeid=Util.getIntValue(request.getParameter("typeid"),0);
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	type = Util.null2String(request.getParameter("src"));

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;

    if(detachable==1){  
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }


    subCompanyId2 = subCompanyId;

    boolean isnewform = false;
	String isvalidStr = "";
	if(type=="")
		type = "addwf";
	if(type.equals("addwf"))
		title="add";
	else {
		title="edit";
		WFManager.setWfid(wfid);
		WFManager.getWfInfo();
		wfname=WFManager.getWfname();
		wfdes=WFManager.getWfdes();
		typeid=WFManager.getTypeid();
		formid=WFManager.getFormid();
		isbill = WFManager.getIsBill();
		iscust = WFManager.getIsCust();
		helpdocid = WFManager.getHelpdocid();
        templateid=WFManager.getTemplateid();
    isvalid=WFManager.getIsValid();
    needmark = WFManager.getNeedMark();
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    messageType=WFManager.getMessageType();
     //add by xwj 20051101 for 邮件提醒 td2965
    mailMessageType=WFManager.getMailMessageType();
    
    //是否禁止附件批量下载
    forbidAttDownload=WFManager.getForbidAttDownload();
    
    //是否跟随文档关联人赋权
    docRightByOperator=WFManager.getDocRightByOperator();
    //add by xhheng @ 20050302 for TD 1545
    multiSubmit=WFManager.getMultiSubmit();
    //add by xhheng @ 20050303 for TD 1689
    defaultName=WFManager.getDefaultName();
    //add by xhheng @ 20050314 for 附件上传
    docPath = WFManager.getDocPath();
    selectedCateLog = WFManager.getSelectedCateLog();
    catelogType = WFManager.getCatelogType();
    docRightByHrmResource = WFManager.getDocRightByHrmResource();
	 isImportDetail = WFManager.getIsImportDetail();
    isaffirmance=WFManager.getIsaffirmance();
	isremak=WFManager.getIsremak();
    isforwardrights=WFManager.getIsforwardRights();    
	isShowChart = WFManager.getIsShowChart();
	orderbytype = WFManager.getOrderbytype();
	isModifyLog = WFManager.getIsModifyLog();//add by cyril on 2008-07-14 for td:8835
    subCompanyId2 = WFManager.getSubCompanyId2() ;//add by wjy
    String tempcategory=WFManager.getDocCategory();
    String tempannexcategory=WFManager.getAnnexDocCategory();
    isannexUpload=WFManager.getIsAnnexUpload();
    showUploadTab=WFManager.getShowUploadTab();
    isSignDoc=WFManager.getSignDoc();
    showDocTab=WFManager.getShowDocTab();
    isSignWorkflow=WFManager.getSignWorkflow();
    showWorkflowTab=WFManager.getShowWorkflowTab();
    candelacc = WFManager.getCanDelAcc();//是否允许创建人删除附件

    ShowDelButtonByReject = WFManager.getShowDelButtonByReject();

	specialApproval = WFManager.getSpecialApproval();
    
    Frequency = WFManager.getFrequency();
    Cycle = WFManager.getCycle();
    
    isrejectremind = WFManager.getIsrejectremind();
    ischangrejectnode = WFManager.getIschangrejectnode();
	 isselectrejectnode = WFManager.getIsSelectrejectNode();
    isimportwf = WFManager.getIsImportwf();
	wfdocpath = WFManager.getWfdocpath();
	wfdocowner = WFManager.getWfdocowner();
	wfdocownerspan = ResourceComInfo.getLastname(wfdocowner);
	wfdocownertype = WFManager.getWfdocownertype();
	wfdocownerfieldid = WFManager.getWfdocownerfieldid();
	issignview = WFManager.getIssignview();
     newdocpath=WFManager.getNewdocpath();
	 nosynfields = WFManager.getNosynfields();
	  isneeddelacc=WFManager.getIsneeddelacc();
	  SAPSource = WFManager.getSAPSource();
    if(tempcategory!=null && !tempcategory.equals("")){
      maincategory=tempcategory.substring(0,tempcategory.indexOf(','));
      subcategory=tempcategory.substring(tempcategory.indexOf(',')+1,tempcategory.lastIndexOf(','));
      seccategory=tempcategory.substring(tempcategory.lastIndexOf(',')+1,tempcategory.length());
      String tempName = SubCCI.getSubCategoryname(subcategory);
      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
      if(!maincategory.equals(""))
      docPath="/"+MainCCI.getMainCategoryname(maincategory)+"/"+tempName+"/"+SecCCI.getSecCategoryname(seccategory);
    }
    if(tempannexcategory!=null && !tempannexcategory.equals("")){
      annexmaincategory=tempannexcategory.substring(0,tempannexcategory.indexOf(','));
      annexsubcategory=tempannexcategory.substring(tempannexcategory.indexOf(',')+1,tempannexcategory.lastIndexOf(','));
      annexseccategory=tempannexcategory.substring(tempannexcategory.lastIndexOf(',')+1,tempannexcategory.length());
      String tempName = SubCCI.getSubCategoryname(annexsubcategory);
      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
      if(!annexmaincategory.equals(""))
      annexdocPath="/"+MainCCI.getMainCategoryname(annexmaincategory)+"/"+tempName+"/"+SecCCI.getSecCategoryname(annexseccategory);
    }
    if(wfdocpath!=null && !wfdocpath.equals("")){
      String _temp1 = wfdocpath.substring(0,wfdocpath.indexOf(','));
      String _temp2 = wfdocpath.substring(wfdocpath.indexOf(',')+1,wfdocpath.lastIndexOf(','));
      String _temp3 = wfdocpath.substring(wfdocpath.lastIndexOf(',')+1,wfdocpath.length());
      String tempName = SubCCI.getSubCategoryname(_temp2);
      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
      if(!_temp1.equals(""))
      wfdocpathspan="/"+MainCCI.getMainCategoryname(_temp1)+"/"+tempName+"/"+SecCCI.getSecCategoryname(_temp3);
    }

	 if(newdocpath!=null && !newdocpath.equals("")){
      String _temp1 = newdocpath.substring(0,newdocpath.indexOf(','));
      String _temp2 = newdocpath.substring(newdocpath.indexOf(',')+1,newdocpath.lastIndexOf(','));
      String _temp3 = newdocpath.substring(newdocpath.lastIndexOf(',')+1,newdocpath.length());
      String tempName = SubCCI.getSubCategoryname(_temp2);
      tempName = tempName.replaceAll("&lt;", "＜").replaceAll("&gt;", "＞").replaceAll("<", "＜").replaceAll(">", "＞");
      if(!_temp1.equals(""))
      newdocpathspan="/"+MainCCI.getMainCategoryname(_temp1)+"/"+tempName+"/"+SecCCI.getSecCategoryname(_temp3);
    }

    if(isbill.equals("1")){//判断是不是新创建的表单
        String tablename = "";
        RecordSet.executeSql("select tablename from workflow_bill where id="+formid);	
        if(RecordSet.next()) tablename = RecordSet.getString("tablename");
        if(tablename.equals("formtable_main_"+formid*(-1))) isnewform = true;
    }
    if(isnewform){
        RecordSet.executeSql("select count(id) from workflow_billfield where fieldhtmltype=3 and type=141 and billid="+formid);
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0)
                isdocRightByHrmResource=true;
        }
    }else{
        RecordSet.executeSql("select count(d.id) from workflow_base b, workflow_formfield c, workflow_formdict d where b.id="+wfid+" and b.isbill=0 and b.formid=c.formid and c.fieldid=d.id and d.fieldhtmltype=3 and d.type=141");
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0)
                isdocRightByHrmResource=true;
        }
    }
    	boolean isHasTestRequest = testWorkflowCheck.isHasTestRequest(wfid);
    	if(isHasTestRequest == true){
    		isvalidStr = " onchange=\"docheckisvalid(this)\" ";
    	}
	}
	
if(templateid>0){
    WFManager.reset();
    WFManager.setWfid(templateid);
	WFManager.getWfInfo();
	templatename=WFManager.getWfname();
}
    String endaffirmances = "";
    String endShowCharts = "";
    RecordSet.executeSql("select * from workflow_billfunctionlist");
    while (RecordSet.next()) {
        String _billid=RecordSet.getString("billid");
        String _indaffirmance = Util.null2String(RecordSet.getString("indaffirmance"));
        String _indShowChart = Util.null2String(RecordSet.getString("indShowChart"));
        if (!_indaffirmance.equals("1")) {
            if(endaffirmances.equals("")) endaffirmances=_billid;
            else endaffirmances += "," + _billid;
        }
        if (!_indShowChart.equals("1")) {
            if(endShowCharts.equals("")) endShowCharts=_billid;
            else endShowCharts += "," + _billid;
        }
    }
    if(!endaffirmances.equals("")) endaffirmances=","+endaffirmances+",";
    if(!endShowCharts.equals("")) endShowCharts=","+endShowCharts+",";
    boolean indaffirmance = true;
    boolean indShowChart = true;
    if(isbill.equals("1")){
        indaffirmance=endaffirmances.indexOf(","+formid+",")>-1?false:true;
        indShowChart=endShowCharts.indexOf(","+formid+",")>-1?false:true;
    }

	//Start 手机推送接口功能  by alan on 2009-12-03
    boolean isMgms = false;
    RecordSet.executeSql("SELECT workflowid FROM workflow_mgmsworkflows WHERE workflowid="+wfid);
    if(RecordSet.next()){
    	isMgms = !Util.null2String(RecordSet.getString("workflowid")).equals("");
    }
    boolean EnableMobile = Util.null2String(Prop.getPropValue("mgms" , "mgms.on")).toUpperCase().equals("Y");
    //End 手机推送接口功能

    String isOpenWorkflowImportDetail=GCONST.getWorkflowImportDetail();//是否启用流程明细表通过EXCEL导入配置
    String isOpenWorkflowSpecialApproval=GCONST.getWorkflowSpecialApproval();//是否启用启用流程特批件设置配置 
    String isOpenWorkflowReturnNode=GCONST.getWorkflowReturnNode();//是否启用流程退回时可选退回节点功能

if(!"".equals(nosynfields)){
	if(isbill.equals("1")){
		RecordSet.executeSql("select id as fieldid, fieldlabel, viewtype as isdetail from workflow_billfield where billid="+formid+" and id in ("+nosynfields+") order by dsporder asc");
	}else{
		RecordSet.executeSql("select a.fieldid, b.fieldlable, a.isdetail from workflow_formfield a, workflow_fieldlable b  where a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage()+" order by a.fieldorder asc ");
	}
	while(RecordSet.next()){
		String fieldlablename = "";
		if(isbill.equals("1")){//单据无法将字段名称作为查询条件，在这里进行处理
			fieldlablename = SystemEnv.getHtmlLabelName(RecordSet.getInt("fieldlabel"),user.getLanguage());
		}else{
			fieldlablename = Util.null2String(RecordSet.getString("fieldlable"));
		}
		int isdetail_ = Util.getIntValue(RecordSet.getString("isdetail"), 0);
		String isdetailStr = "";
		if(isdetail_ == 1){
			isdetailStr = "(" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + ")";
		}
		nosynfieldsStr = nosynfieldsStr + fieldlablename + isdetailStr + ",";
	}
	if(!"".equals(nosynfieldsStr)){
		nosynfieldsStr = nosynfieldsStr.substring(0, nosynfieldsStr.length()-1);
	}
}
%>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+":";
if(isTemplate.equals("1")){
    titlename = SystemEnv.getHtmlLabelName(17857,user.getLanguage())+":";
}
if(type.equals("addwf")){
    titlename +=SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else{
    titlename +=SystemEnv.getHtmlLabelName(93,user.getLanguage());
}
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(operatelevel>0){
    if(isSaveas==1)
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:copytemplate(this),_self} " ; 
    else
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    if(!type.equals("addwf")){
	    if(!ajax.equals("1"))
	    	RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",/workflow/workflow/addwf0.jsp?isTemplate=1&isSaveas=1&ajax="+ajax+"&templateid="+wfid+",_self} " ;
	    else
	    {
		    RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",javascript:Savetemplate("+wfid+"),_self} " ;
		    RCMenuHeight += RCMenuHeightStep;
		    //是否开启流程导入导出
		    if(GCONST.isWorkflowIsOpenIOrE())
		    {
		    	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"xml,javascript:exportWorkflow("+wfid+"),_self} " ;
		    	RCMenuHeight += RCMenuHeightStep;
		    }
	    }
    }
    
    if(!ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:weaver.reset(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
    }
    
}
%>


<form name="weaver" id="weaver" method="post" action="wf_operation.jsp">
<input type="hidden" name="endaffirmances" id="endaffirmances" value="<%=endaffirmances%>">
<input type="hidden" name="endShowCharts" id="endShowCharts" value="<%=endShowCharts%>">
<%
if(ajax.equals("1")){
%>
<input type=hidden name="ajax" value="1">
<%}%>
<%
if(type.equals("editwf")&&operatelevel>0){
%>
<%
    if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+",Editwfnode.jsp?wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(261,user.getLanguage())+",addwfnodefield.jsp?wfid="+wfid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(15587,user.getLanguage())+",addwfnodeportal.jsp?wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }
%>

<%
}
%>

<%
    if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",managewf.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
    }
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
    if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=85 and relatedid="+wfid+",_self} " ;   
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=85 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;
    }
if(HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) && wfid>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2118,user.getLanguage())+SystemEnv.getHtmlLabelName(17688,user.getLanguage())+",javascript:doShowBaseData("+wfid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
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


  <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
   <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  <%if(!isTemplate.equals("1")){%>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <%}else{%>
    <td><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
    <%}%>
    <!-- modify by xhheng @20050204 for TD 1538 -->
    <td class=field><input class=Inputstyle type="text" name="wfname" size="40" onChange="checkinput('wfname','wfnamespan')" maxlength="50" value="<%=wfname%>">
    <span id=wfnamespan><%if(wfname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
    </td>
  </tr>
     <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <%if(EnableMobile){%>  	  
	  <tr>
	  	<td><%=SystemEnv.getHtmlLabelName(23996,user.getLanguage())%></td>
	  	<td class=field><INPUT type=checkbox name="isMgms" value="1" <% if(isMgms) {%> checked <%}%>></td>
	  </tr>
	  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <%}else{%>
  	<INPUT type=hidden name="isMgms" value="<%if(isMgms){%>1<%}%>">
  <%}%>    	  
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(18167,user.getLanguage())%></td>
  <td class=field>
  <%if(!type.equals("editwf")){%>
  <button type="button" class=Browser onClick="onShowWorkflow('templateid', 'templatespan')" name=SelectTemplate></BUTTON>
  <%}%>
    <span id=templatespan name=templatespan><%=templatename%></span>
  <input type="hidden" name="templateid" value="<%=templateid%>">
  </td>
  </tr>
  <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  </table>
  <div id="addwf0div" name="addwf0div" <%if(isSaveas==1){%>style="display:none" <%}else{%>style="display:''"<%}%>>
  <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field>
    <select class=inputstyle  name=typeid style="width:50%">
    <%
    while(WorkTypeComInfo.next()){
     	String checktmp = "";
     	if(typeid == Util.getIntValue(WorkTypeComInfo.getWorkTypeid()))
     		checktmp=" selected";
%>
<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=checktmp%>><%=WorkTypeComInfo.getWorkTypename()%></option>
<%
}
%>
    </select>
    
    </td>
  </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <tr><td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td>
  <td class=field>
    <select class=inputstyle  name = iscust onchange="onchangeiscust(this.value)">
    <option value=0 <%if(iscust.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%></option>
    <option value=1 <%if(iscust.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%></option>
    </select>
    </td>
    </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td>
    <select class=inputstyle  name=isbill style="width:84%" onchange="onchangeisbill(this.value)">
    <option value=3 <%if(isbill.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(557, user.getLanguage())%></option>
    <option value=0 <%if(isbill.equals("0")||isnewform){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
    <option value=1 <%if(isbill.equals("1")&&!isnewform){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19532,user.getLanguage())%></option>
    </select>

    </td>
    <td class=field>
    <%
    String bname = "";
    if(isbill.equals("1")) {
    	RecordSet.executeSql("select * from workflow_bill where id="+formid);
		if(RecordSet.next()){
			int tmplable = RecordSet.getInt("namelabel");
			bname = SystemEnv.getHtmlLabelName(tmplable,user.getLanguage());
		}
    }
	%>
    <button type="button" <%if((isbill.equals("1") && (formid>0 || formid==-1)) || isbill.equals("3")){%>style="display:none"<%}%> class=Browser id=formidSelect onClick="onShowFormSelect(isbill.value, formid, formidSelectSpan)" name=formidSelect></BUTTON>
    <span <%if((isbill.equals("1") && (formid>0 || formid==-1)) || isbill.equals("3")){%>style="display:none"<%}%> name="formidSelectSpan" id=formidSelectSpan><%if(isbill.equals("0")){%><%=FormComInfo.getFormname(""+formid)%><%}else if(formid<0){%><%=bname%><%}%></span>
    <button type="button" <%if(isbill.equals("0") || (formid<0 && formid!=-1) || isbill.equals("3")){%>style="display:none"<%}%> class=Browser id=billidSelect onClick="onShowFormSelect(isbill.value, billid, billidSelectSpan)" name=billidSelect></BUTTON>
    <span <%if(isbill.equals("0") || (formid<0 && formid!=-1) || isbill.equals("3")){%>style="display:none"<%}%> name="billidSelectSpan" id=billidSelectSpan><%if(formid>=0){%><%=bname%><%}%></span>
    <input type="hidden" name="formid" id="formid" onpropertychange="onchangeformid(this.value)" value="<%if(isbill.equals("0") || (isbill.equals("1") && formid<0)){%><%=formid%><%}%>"/>
    <input type="hidden" name="billid" id="billid" onpropertychange="onchangebillid(this.value)" value="<%if(isbill.equals("1") && formid>0){%><%=formid%><%}%>"/>    
    <%if(ajax.equals("1")){%>
    <font color="red"><%=SystemEnv.getHtmlLabelName(18720,user.getLanguage())%><a href="#" onclick="toformtab()" style="color:blue;TEXT-DECORATION:none"><b><%=SystemEnv.getHtmlLabelName(700,user.getLanguage())%></b></a><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></font>  
    <%}%>
    </td>
  </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <%if(!isTemplate.equals("1")){%>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(15591,user.getLanguage())%></td>
  <TD class=Field>
      <select id="isvalid" name="isvalid" <%=isvalidStr%> >
          <option value="0" <% if(!isvalid.equals("1")&&!isvalid.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
          <option value="1" <% if(isvalid.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
          <option value="2" <% if(isvalid.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(25496,user.getLanguage())%></option>
      </select>
	<input type="hidden" id="oldisvalid" name="oldisvalid" value="<%=isvalid%>">
	</TD>
   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <%}%>
  <!--tr>
  <td><%=SystemEnv.getHtmlLabelName(15592,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="needmark" value="1" <% if(needmark.equals("1")) {%> checked <%}%>></TD>
  </tr>   <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR-->
  <!--add by xhheng @ 2005/01/24 for 消息提醒 Request06-->
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(17582,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="messageType" value="1" <% if(messageType.equals("1")) {%> checked <%}%>></TD>
  <!--add by xwj 20051101 for 邮件提醒 td2965-->
  </tr>
  </tr><TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(17995,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="mailMessageType" value="1" <% if(mailMessageType.equals("1")) {%> checked <%}%>></TD>
  <!--add by xhheng @ 20050302 for TD 1545-->
  </tr>
  <%if(formid != 180){%>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR><tr>
  <td><%=SystemEnv.getHtmlLabelName(17601,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="multiSubmit" value="1" <% if(multiSubmit.equals("1")) {%> checked <%}%>></TD>
  <!--add by xhheng @ 20050303 for TD 1689-->
  </tr>
   <%}%>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR><tr>
  <td><%=SystemEnv.getHtmlLabelName(17606,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="defaultName" value="1" <% if(defaultName.equals("1")) {%> checked <%}%>></TD>
  </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
  <tr><td><%=SystemEnv.getHtmlLabelName(19649,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="isaffirmance" value="1" <% if(isaffirmance.equals("1")) {%> checked <%}%> <%if(!indaffirmance){%>disabled <%}%>></TD>
  </tr>   
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(22576,user.getLanguage())%></td>
    <td class=field>
  <INPUT type=checkbox name="isforwardrights" value="1" <% if(isforwardrights.equals("1")) {%> checked <%}%>>

    </td>
  </tr>    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<!--add by chujun @ 20080617 for 是否显示流程图	 TD8715-->
	<tr>
    <td><%=SystemEnv.getHtmlLabelName(21574,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="isShowChart" value="1" <% if(isShowChart.equals("1")) {%> checked <%}%> <%if(!indShowChart){%>disabled<%}%>>
    </td>
  </tr>    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<!-- added by cyril on 2008-07-14 for TD:8835 是否记录表单修改日志 -->
<tr>
    <td><%=SystemEnv.getHtmlLabelName(21681,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="isModifyLog" value="1" <% if(isModifyLog.equals("1")) {%> checked <%}%>>
    </td>
  </tr>    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<!--add by chujun @ 20080624 for  流程审批意见显示模式	 TD8883-->
	<tr>
    <td><%=SystemEnv.getHtmlLabelName(21603,user.getLanguage())%></td>
    <td class=field>
		<select class=inputstyle id=orderbytype name=orderbytype onchange="changeOrderShow()">
    <option value=1 <%if("1".equals(orderbytype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%></option>
    <option value=2 <%if("2".equals(orderbytype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%></option>
    </select>&nbsp;
	<span id=orderShowSpan>
		<%if("2".equals(orderbytype)){%>
		<%=SystemEnv.getHtmlLabelName(21628,user.getLanguage())%>
		<%}else{%>
		<%=SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>
		<%}%>
	</span>
    </td>
  </tr>    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>

  <!--add by xhheng @ 20050314 for 附件上传-->
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></td>
    <td class=field>
    <select class=inputstyle id=catalogtypeid name=catalogtype onchange="switchCataLogType(this.value)">
    <option value=0 <%if(catelogType == 0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19213,user.getLanguage())%></option>
    <option value=1 <%if(catelogType == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%></option>
    </select>&nbsp;
<%
    String sqlSelectCatalog=null;
	int tempFieldId=0;
	if("1".equals(isbill)){
		sqlSelectCatalog = "select formField.id,fieldLable.labelName as fieldLable "
                         + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                         + "where fieldLable.indexId=formField.fieldLabel "
                         + "  and formField.billId= " + formid
                         + "  and formField.viewType=0 "
                         + "  and fieldLable.languageid =" + user.getLanguage()
			             + "  and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
	}else{
		sqlSelectCatalog = "select formDict.ID, fieldLable.fieldLable "
                         + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                         + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                         + "and formField.formid = " + formid
                         + " and fieldLable.langurageid = " + user.getLanguage()
			             + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
	}
%>
    <select class=inputstyle id=selectcatalogid <%if(catelogType == 0){%>style="display:none"<%}%> name=selectcatalog>
    <%
	
	RecordSet.executeSql(sqlSelectCatalog);
	while(RecordSet.next()){
		tempFieldId = RecordSet.getInt("ID");
%>
        <OPTION value=<%= tempFieldId %> <% if(tempFieldId == selectedCateLog) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></OPTION>
    <%

    	}
    %>
    </select>&nbsp;

    <button type="button" class=Browser id=selectCategoryid onClick="onShowCatalog('mypath')" <%if(catelogType == 1){%>style="display:none"<%}%> name=selectCategory></BUTTON>
    <span id=mypath <%if(catelogType == 1){%>style="display:none"<%}%> ><%=docPath%></span>
    </td>
  </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>

  <tr>
  <td><%=SystemEnv.getHtmlLabelName(22944,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="candelacc" value="1" <%if(candelacc.equals("1")){%>checked<%}%>></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <!-- 删除流程的同时是否同时删除附件 -->
   <tr>
	  <td><%=SystemEnv.getHtmlLabelName(28571,user.getLanguage())%></td>
	  <TD class=Field> 
	  <input type="checkbox" 
	  <% if(isneeddelacc.equals("1")) {%> checked <%}%>
	   name="isneeddelacc" value="1">&nbsp;<span style="color:#ff0000"><%=SystemEnv.getHtmlLabelName(28572,user.getLanguage())%></span>
	  </TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
    <!--禁止附件批量下载-->
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(27025,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="forbidAttDownload" value="1" <% if(forbidAttDownload.equals("1")) {%> checked <%}%>></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR> 
  
  <!--是否跟随文档关联人赋权-->
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(18011,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="docRightByOperator" value="1" <% if(docRightByOperator.equals("1")) {%> checked <%}%>></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <!--新建文档目录-->
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(24621,user.getLanguage())%></td>
  <TD class=Field>
  <button type="button" class=Browser id=selectnewdoc onClick="onShowDocCatalog(newdocpathspan)" name=selectnewdoc></BUTTON>
  <span id="newdocpathspan"><%=newdocpathspan%></span></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <%if(isdocRightByHrmResource){%>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(19321,user.getLanguage())%></td>
    <TD class=Field>
        <INPUT type=checkbox name="docRightByHrmResource" value="1" <% if(docRightByHrmResource == 1){%> checked <%}%>>
    </TD>
  </tr>
  </tr><TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <%}%> 
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(22267,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="ShowDelButtonByReject" value="1" <% if(ShowDelButtonByReject.equals("1")) {%> checked <%}%>>
    </td>
  </tr>
 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR> 
 <tr style="<%=isOpenWorkflowImportDetail.equals("1")?"":"display:none"%>">
    <td><%=SystemEnv.getHtmlLabelName(26254,user.getLanguage())%></td>
    <td class=field>
	     <% 
  //如果不是系统单据,就出现允许明细导入的配置
  if(!("1".equals(isbill)&&formid>0)){%>
		<INPUT type=checkbox name="isImportDetail" id="isImportDetail"  value="1" <% if(isImportDetail.equals("1")) {%> checked <%}%>> 
		 <INPUT type=checkbox id='isImportDetail_fake' style='display:none' disabled='true'> 
		<%}else{%>
		 <INPUT type=checkbox name="isImportDetail" id="isImportDetail" style='display:none' value="1" <% if(isImportDetail.equals("1")) {%> checked <%}%>> 
		 <INPUT type=checkbox id='isImportDetail_fake' style='display:inline' disabled='true'>  
  <%}%>
    </td>
  </tr>   
   <TR class="Spacing" style="height:1px;<%=isOpenWorkflowImportDetail.equals("1")?"":"display:none"%>"><TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(24447,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="isrejectremind" value="1" <% if(isrejectremind.equals("1")) {%> checked <%}%> onclick="rejectremindChange(this,'ischangrejectnode')">
    </td>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(24448,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="ischangrejectnode" value="1" <% if(isrejectremind.equals("1")&&ischangrejectnode.equals("1")) {%> checked <%} if(!isrejectremind.equals("1")){%> disabled <%}%> >
    </td>
  </tr>
   <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr style="<%=isOpenWorkflowReturnNode.equals("1")?"":"display:none"%>"> 
   <td><%=SystemEnv.getHtmlLabelName(26435,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="isselectrejectnode" value="1" <% if(isselectrejectnode.equals("1")) {%> checked<%}%> >
    </td>
  </tr>
  <TR class="Spacing" style="height:1px;<%=isOpenWorkflowReturnNode.equals("1")?"":"display:none"%>"><TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(24269,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="isimportwf" value="1" <% if(isimportwf.equals("1")) {%> checked <%}%>>
    </td>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(26370,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="issignview" value="1" <% if(issignview.equals("1")) {%> checked <%}%>>
    </td>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  
  <!-- 特批件设置strat -->
  <%if(isOpenWorkflowSpecialApproval.equals("1")){ %>
  <!-- 是否特批件 -->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(26007,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27566,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=checkbox name="specialApproval" value="1" onclick="ShowORHidden2(this)" <% if(specialApproval.equals("1")) {%> checked <%}%> >
    </td>
  </tr>
   <TR id="Frequencytrline" class="Spacing" <%if(!"1".equals(specialApproval)){%>style="display:none"<%}else{%>style="height:1px"<%}%>><TD class="Line" colSpan=2></TD></TR>
   
   <!-- 次数 -->
  <tr id="Frequencytr" <%if(!"1".equals(specialApproval)){%>style="display:none"<%}%>>
    <td><%=SystemEnv.getHtmlLabelName(26755,user.getLanguage())%></td>
    <td class=field>
		<INPUT type=text name="Frequency" value="<%=Frequency %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" maxLength=10 size=10>
    </td>
  </tr>
   <TR id="Cycletrline"  class="Spacing" <%if(!"1".equals(specialApproval)){%>style="display:none"<%}else{%>style="height:1px"<%}%>><TD class="Line" colSpan=2></TD></TR>
    
   <!-- 周期 -->
  <tr id="Cycletr" <%if(!"1".equals(specialApproval)){%>style="display:none"<%}%>>
    <td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
    <td class=field>
		<select id=selCycle name="Cycle">
			<option value=1 <%if(Cycle.equals("1")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%></option>
			<option value=2 <%if(Cycle.equals("2")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
			<option value=3 <%if(Cycle.equals("3")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
			<option value=4 <%if(Cycle.equals("4")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
			<option value=5 <%if(Cycle.equals("5")){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
		</select>
    </td>
  </tr>
   <%}%>
  <!-- 特批件设置end -->
  
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></td>
    <td class=field>
    <button type="button" class=Browser onclick="showDoc()"></BUTTON>

      <SPAN ID=Documentname>
      <%if(helpdocid!=0){%>
      <a href="/docs/docs/DocDsp.jsp?id=<%=helpdocid%>"><%=Util.toScreen(DocComInfo.getDocname(""+helpdocid),user.getLanguage())%></a>
      <%}%>
      </SPAN>
    <input class=Inputstyle type=hidden name="helpdocid" size="80" value="<%=helpdocid%>">
    </td>
  </tr>    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>

<tr>
	<td><%=SystemEnv.getHtmlLabelName(28064,user.getLanguage())%></td>
	<td class=field>
		<BUTTON class=Browser onclick="showNoSynFields('nosynfields', 'nosynfieldsspan')"></BUTTON>
		<SPAN id="nosynfieldsspan"><%=nosynfieldsStr%>
		</SPAN>&nbsp;&nbsp;<font color="red"><%=SystemEnv.getHtmlLabelName(28065,user.getLanguage())%></font>
		<input type="hidden" id="nosynfields" name="nosynfields" value="<%=nosynfields%>">
	</td>
</tr>
<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
<%
	 if("0".equals(IsOpetype)){
%>	
		<!-- 选择SAP数据源 --> 
		<tr>
		<td>SAP<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></td>
		<td class=field>
			<select name="SAPSource" id="SAPSource">
			<option value=""></option>
			<%//System.out.println("SAPSource="+SAPSource);
			RecordSet.executeSql("select * from SAPCONN");
			while(RecordSet.next()){
				String code = RecordSet.getString("code");
			%>
				<option value="<%=code%>" <%if(SAPSource.equals(code)){%>selected<%}%>><%=code%></option>
			<%}%>	
			</select>
		</td>
	</tr>
	<TR class="Spacing"><TD class="Line" colSpan=2></TD></TR> 
<%
	 }
 %>

<%if(detachable==1){%>
    <tr>
        <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
        <td colspan=5 class=field >
            <%if(operatelevel>0){%>
                <button type="button" class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <%}%>
            <SPAN id=subcompanyspan> <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subCompanyId2))%>
                <%if(String.valueOf(subCompanyId2).equals("")){%>
                    <IMG src="/images/BacoError.gif" align=absMiddle>
                <%}%>
            </SPAN>
            <INPUT class=inputstyle id=subcompanyid type=hidden name=subcompanyid value="<%=subCompanyId2%>">
        </td>
    </tr>
    <tr class="Spacing" style="height:1px;"><td colspan=2 class="Line"></td></tr>
<%}%>
  </table>
  </div>
  <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td  class=field><textarea rows="3" class=Inputstyle name="wfdes" cols="65"><%=wfdes%></textarea></td>
  </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
   <input type="hidden" value="<%=type%>" name="src">
   <input type="hidden" value=<%=wfid%> name="wfid">
   <input type="hidden" name="oldtypeid" value="<%=typeid%>">
    <input type="hidden" name="oldiscust" value="<%=iscust%>">
    <input type="hidden" name="oldisbill" value="<%=isbill%>">
    <input type="hidden" name="oldformid" value="<%=formid%>">
    <input type="hidden" name="isTemplate" value="<%=isTemplate%>">
    <input type=hidden id='pathcategory' name='pathcategory' value="<%=docPath%>">
    <input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
    <INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
    <INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
    <input type=hidden id='annexmaincategory' name='annexmaincategory' value="<%=annexmaincategory%>">
    <INPUT type=hidden id='annexsubcategory' name='annexsubcategory' value="<%=annexsubcategory%>">
    <INPUT type=hidden id='annexseccategory' name='annexseccategory' value="<%=annexseccategory%>">
	<INPUT type=hidden id='newdocpath' name='newdocpath' value="<%=newdocpath%>">
  </table>
  <div id="addwf1div" name="addwf1div" <%if(isSaveas==1){%>style="display:none" <%}else{%>style="display:''"<%}%>>
  <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
  <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></TH></TR>
       <TR class="Spacing" style="height:1px;"><TD class="Line1" colSpan=2></TD></TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(23726,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="isSignDoc" value="1" <% if("1".equals(isSignDoc)) {%> checked <%}%> onclick="ShowORHidden(this,isSignDoctr,isSignDoclinetr,showDocTab)"></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr id="isSignDoctr" <%if(!"1".equals(isSignDoc)){%>style="display:none"<%}%>>
  <td><%=SystemEnv.getHtmlLabelName(23728,user.getLanguage())%></td>
  <TD class=Field>
  <INPUT type=checkbox name="showDocTab" value="1" <% if(showDocTab.equals("1")) {%> checked <%}%>>
  </TD>
  </tr>
  <TR class="Spacing" id="isSignDoclinetr" <%if(!"1".equals(isSignDoc)){%>style="display:none"<%}else{%> style="height:1px;"<%}%>><TD class="Line" colSpan=2></TD></TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(23727,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="isSignWorkflow" value="1" <% if("1".equals(isSignWorkflow)) {%> checked <%}%> onclick="ShowORHidden(this,isSignWorkflowtr,isSignWorkflowlinetr,showWorkflowTab)"></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr id="isSignWorkflowtr" <%if(!"1".equals(isSignWorkflow)){%>style="display:none"<%}%>>
  <td><%=SystemEnv.getHtmlLabelName(23729,user.getLanguage())%></td>
  <TD class=Field>
  <INPUT type=checkbox name="showWorkflowTab" value="1" <% if(showWorkflowTab.equals("1")) {%> checked <%}%>>
  </TD>
  </tr>
  <TR class="Spacing" id="isSignWorkflowlinetr" <%if(!"1".equals(isSignWorkflow)){%>style="display:none"<%}else{%> style="height:1px;"<%}%>><TD class="Line" colSpan=2></TD></TR>
  <tr>
  <td><%=SystemEnv.getHtmlLabelName(21417,user.getLanguage())%></td>
  <TD class=Field><INPUT type=checkbox name="isannexUpload" value="1" <% if("1".equals(isannexUpload)) {%> checked <%}%> onclick="ShowAnnexUpload(this,annxtCategorytr,linetr,showuploadtabtr,showuploadlinetr,showUploadTab)"></TD>
  </tr>
  <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=2></TD></TR>
  <tr id="annxtCategorytr" <%if(!"1".equals(isannexUpload)){%>style="display:none"<%}%>>
  <td><%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())%></td>
  <TD class=Field>
  <button type="button" class=Browser id=selectannexCategoryid onClick="onShowAnnexCatalog(annexpath)"  name=selectannxtCategory ></BUTTON>
    <span id=annexpath ><%=annexdocPath%></span>
  </TD>
  </tr>
  <TR class="Spacing" id="linetr" <%if(!"1".equals(isannexUpload)){%>style="display:none"<%}else{%> style="height:1px;" <%}%>><TD class="Line" colSpan=2></TD></TR>
  <tr id="showuploadtabtr" <%if(!"1".equals(isannexUpload)){%>style="display:none"<%}%>>
  <td><%=SystemEnv.getHtmlLabelName(23725,user.getLanguage())%></td>
  <TD class=Field>
  <INPUT type=checkbox name="showUploadTab" value="1" <% if(showUploadTab.equals("1")) {%> checked <%}%>>
  </TD>
  </tr>
  <TR class="Spacing" id="showuploadlinetr" <%if(!"1".equals(isannexUpload)){%>style="display:none"<%}else{%> style="height:1px;" <%}%>><TD class="Line" colSpan=2></TD></TR>
</table>
</div>

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
<%
if(!ajax.equals("1")){
%>
<script language=javascript>
function onchangeisbill(objval){
   var oldval=$G("oldisbill").value;
   if(oldval!=3 && objval!=oldval){
       if(!confirm("<%=SystemEnv.getHtmlLabelName(18682,user.getLanguage())%>")){
            $G("isbill").value=$G("oldisbill").value;
       }       
   }
   objval=$G("isbill").value;
   if(objval==0){
       $G("formid").style.display = '';
       $G("billid").style.display = 'none';
   }else{
      if(objval==1){
         $G("billid").style.display= '';
         $G("formid").style.display = 'none';
      }else{
         $G("formid").style.display = 'none';
         $G("billid").style.display = 'none';
      }
   }
}
function onchangeiscust(objval){
    var srctype=$G("src").value;
	if(srctype=="editwf"&&objval!=$G("oldiscust").value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18685,user.getLanguage())%>")){
            $G("iscust").value=$G("oldiscust").value;
        }
	}
}
function onchangeformid(objval){
    var oldisbillval=$G("oldisbill").value;
    var isbillval=$G("isbill").value;
	if(oldisbillval!=3 && objval!=$G("oldformid").value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18683,user.getLanguage())%>")){
            $G("formid").value=$G("oldformid").value;
        }
	}
}
function onchangebillid(objval){
    var oldisbillval=$G("oldisbill").value;
    var isbillval=$G("isbill").value;
	if(oldisbillval!=3 && objval!=$G("oldformid").value){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(18684,user.getLanguage())%>")){
            $G("billid").value=$G("oldformid").value;
        }
	}
}

//modify by xhheng @20050204 for TD 1538
function submitData(obj){
	if (check_form($G("weaver"),'wfname,subcompanyid')){
		$G("weaver").submit();
        obj.disabled=true;
    }
}
function ShowAnnexUpload(obj,tr1name,tr2name,tr3name,tr4name,tabobj){
    if(obj.checked){
        tr1name.style.display = '';
        tr2name.style.display = '';
        tr3name.style.display = '';
        tr4name.style.display = '';
    }else{
        tr1name.style.display = 'none';
        tr2name.style.display = 'none';
        tr3name.style.display = 'none';
        tr4name.style.display = 'none';
    }
    tabobj.checked=obj.checked;
}
function ShowORHidden(obj,tr1name,tr2name,tabobj){
    if(obj.checked){
        tr1name.style.display = '';
        tr2name.style.display = '';
    }else{
        tr1name.style.display = 'none';
        tr2name.style.display = 'none';
    }
    tabobj.checked=obj.checked;
}
function changeOrderShow(){
	var orderbytype = $G("orderbytype").value;
	if(orderbytype == 1){
		$G("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>";
	}else{
		$G("orderShowSpan").innerHTML="<%=SystemEnv.getHtmlLabelName(21628,user.getLanguage())%>";
	}
}

function switchCataLogType(objval){
	objval=document.weaver.catalogtype.value;
    if(objval == 0){
		$G("selectcatalog").style.display = 'none';
        $G("selectCategory").style.display = '';
        $G("mypath").style.display = '';
    }else{
    	$G("selectcatalog").style.display = '';
        $G("selectCategory").style.display = 'none';
        $G("mypath").style.display = 'none';
    }
}

function json2Array(josinobj) {
	if (josinobj == undefined || josinobj == null) {
		return null;
	}
	var ary = new Array();
	var _index = 0;
	try {
		for(var key in josinobj){
			ary[_index++] = josinobj[key];
		}
	} catch (e) {}
	return ary;
}

function onShowCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            $G(spanName).innerHTML=result[2];
            $G("pathcategory").value=result[2];
            $G("maincategory").value=result[3];
            $G("subcategory").value=result[4];
            $G("seccategory").value=result[1];
        }
          <!--added xwj for td2048 on 2005-6-1 begin -->
        else{
            $G(spanName).innerHTML="";
            $G("pathcategory").value="";
            $G("maincategory").value="";
            $G("subcategory").value="";
            $G("seccategory").value="";
            }
        <!--added xwj for td2048 on 2005-6-1 end -->
    }
}

function onShowWfCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML=result[2];
            $G("wfdocpath").value=result[3]+","+result[4]+","+result[1];
        }
        else{
            spanName.innerHTML="";
            $G("wfdocpath").value="";
            }
    }
}
function onShowDocCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML=result[2];
            $G("newdocpath").value=result[3]+","+result[4]+","+result[1];
        }
        else{
            spanName.innerHTML="";
            $G("newdocpath").value="";
            }
    }
}


function onShowAnnexCatalog(spanName) {
    var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
    result = json2Array(result);
    if (result != null) {
        if (result[0] > 0)  {
            spanName.innerHTML=result[2];
            $G("annexmaincategory").value=result[3];
            $G("annexsubcategory").value=result[4];
            $G("annexseccategory").value=result[1];
        }
          <!--added xwj for td2048 on 2005-6-1 begin -->
        else{
            spanName.innerHTML="";
            $G("annexmaincategory").value="";
            $G("annexsubcategory").value="";
            $G("annexseccategory").value="";
            }
        <!--added xwj for td2048 on 2005-6-1 end -->
    }
}
function rejectremindChange(obj,tdname){
    if(obj.checked){
        $G(tdname).disabled=false;
    }else{
        $G(tdname).checked=false;
        $G(tdname).disabled=true;
    }
}
</script>

<script type="text/javascript">
function onShowWorkflow(inputname,spanname){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=1");
	//datas = json2Array(datas);
	if(datas){
	    if(datas.id!="") {
			$G(spanname).innerTML = datas.name;
			$G(inputname).value = datas.id;
	        $G("addwf0div").style.display="none";
	        $G("addwf1div").style.display="none";
	    }else{
	    	$G(spanname).innerHTML = "";
	    	$G(inputname).value="";
	    	$G("addwf0div").style.display="";
	    	$G("addwf1div").style.display="";
	   }
	}
}

function showDoc(){
	datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp");
	//datas = json2Array(datas);
	if(datas){
		weaver.helpdocid.value=datas.id+"";
		$("#Documentname").html("<a href='/docs/docs/DocDsp.jsp?id="+datas.id+"'>"+datas.name+"</a>");
	}
}

function onShowSubcompany(){
	alert("ABC");
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All&isedit=1&selectedids="+weaver.subcompanyid.value);
	//datas = json2Array(datas);
	issame = false;
	if (datas){
	if(datas.id!="0"&&datas.id!=""){
		if(datas.id == weaver.subcompanyid.value){
			issame = true;
		}
		$(subcompanyspan).html(datas.name);  //ypc 2012-09-24
		$GetEle("subcompanyid").value=datas.id;  //ypc 2012-09-24
	}
	else{
		$GetEle("subcompanyspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>" ;//ypc 2012-09-24
		$GetEle("subcompanyid").value = "" ; //ypc 2012-09-24
	}
	}
}
</script>
<%}   %>
</body>
</html>
