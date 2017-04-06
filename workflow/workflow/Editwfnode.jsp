<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsName" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<%WFNodeOperatorManager.resetParameter();%>
<html>
<%
Prop prop = Prop.getInstance();
String ifchangstatus=Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	int wfid=0;
	int formid=0;
    boolean hassetting=false;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	int typeid = 0;
	typeid = WFManager.getTypeid();

	int rowsum=0;


    String sql2 = "select objid from workflow_addinoperate where workflowid = "+wfid+" and isnode=1 and ispreadd = '0'";
    String hasRolesIds = "";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("objid");
    }
    
    //zzl默认显示绿色钩子，表示有节点后操作
    sql2 = "select w_nodeid from int_BrowserbaseInfo where w_fid = "+wfid+" and ispreoperator=0 and w_enable=1";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("w_nodeid");
    }
    //zzl-end
    
    /*---xwj for td3130 20051122 begin---*/
    sql2 = "select objid from workflow_addinoperate where workflowid = "+wfid+" and isnode=1 and ispreadd = '1'";
    String hasPreRolesIds = "";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasPreRolesIds += ","+RecordSet.getString("objid");
    }
    
     //zzl默认显示绿色钩子，表示有节点后操作
    sql2 = "select w_nodeid from int_BrowserbaseInfo where w_fid = "+wfid+" and ispreoperator=1 and w_enable=1";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasPreRolesIds += ","+RecordSet.getString("w_nodeid");
    }
    //zzl-end
    
    /*---xwj for td3130 20051122 end---*/
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
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
    
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(operatelevel>0){
if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",addwfnode.jsp?src=editwf&wfid="+wfid+",_self} " ;
else
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:nodeedit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
if(!ajax.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=86 and relatedid="+wfid+",_self} " ;   
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=86 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;



RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",addwfnode.jsp?src=editwf&wfid="+wfid+",_self} " ;
}
}
%>
<%
if(!ajax.equals("1")){
%>
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

<%
if(!ajax.equals("1")){
%>
<form name="form1">
   <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <td class=field><b><%=wfname%></b></td>
  </tr>   <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field><b><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></b></td>
  </tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td>
    <td class=field><b>
    <%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%></b></td>
  </tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<%}%><!--portal end-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></td>
    <%if(isbill.equals("0")){
            %>
            <td class=field><b><%=FormComInfo.getFormname(""+formid)%></b></td>
            <%}
            else if(isbill.equals("1")){
            	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
            %>
            <td class=field><b><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></b></td>
            <%}else{%>
            <<td class=field><b></b></td>
            <%}%>
  </tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td class=field><b><%=wfdes%></b></td>
  </tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="7" align="center" height="15"></td>
        </tr>
</table>
</form>
<%}%>

<form method=post action="wf_operation.jsp">
    <table class="ViewForm">
      	<COLGROUP>
   <%--xwj taiping wf_log  control  2005-07-25  B E G I N --%>
  	 <%--xwj for td3130 20051122 begin--%>
  	<COL width="10%">
	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
  	<COL width="10%">
    <COL width="10%">
    <COL width="10%">
	<COL width="10%">
  	<COL width="10%">
  	 <%--xwj for td3130 20051122 end--%>
  	<%--xwj taiping wf_log  control  2005-07-25  E N D--%>
        <TR class="Title">
    	  <TH colSpan=><%=SystemEnv.getHtmlLabelName(15615,user.getLanguage())%></TH></TR>
		  <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=10></TD></TR>	<%--xwj for td3130 20051122 --%>  <%--xwj taiping wf_log  control  2005-07-25  --%>
    	  <tr class=header>
            <td ><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
			<td ><%=SystemEnv.getHtmlLabelName(21393,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(21737,user.getLanguage())%></td><%--chuj for td8781 20080611 --%>
            <td><%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%></td><%--xwj for td3130 20051122 --%>
            <td><%=SystemEnv.getHtmlLabelName(18010,user.getLanguage())%></td><%--xwj for td3130 20051122 --%>
            <td><%=SystemEnv.getHtmlLabelName(17750,user.getLanguage())%></td><%--xwj taiping wf_log  control  2005-07-25  --%>
            <td><%=SystemEnv.getHtmlLabelName(18887,user.getLanguage())%></td>
           
            <td ><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></td>
</tr> <TR class="Spacing" style="height:1px;">
    	   <TD class="Line" colSpan=10></TD></TR>	<%--xwj for td3130 20051122 --%> <%--xwj taiping wf_log  control  2005-07-25  --%>
<%
int linecolor=0;
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
hassetting=false;	

int tmpid = WFNodeMainManager.getNodeid();
String tmpname = WFNodeMainManager.getNodename();
String tmptype = WFNodeMainManager.getNodetype();
String tmpIsFormSignature = WFNodeMainManager.getIsFormSignature();
String nodetitle = WFNodeMainManager.getNodetitle();
String tmpViewIds = WFNodeMainManager.getViewnodeids();//xwj for td2104  2005-08-1
String IsPendingForward = WFNodeMainManager.getIsPendingForward();
String IsWaitForwardOpinion = WFNodeMainManager.getIsWaitForwardOpinion();
String IsBeForward = WFNodeMainManager.getIsBeForward();
String IsSubmitedOpinion = WFNodeMainManager.getIsSubmitedOpinion();
String IsSubmitForward = WFNodeMainManager.getIsSubmitForward();
String IsFreeWorkflow = WFNodeMainManager.getIsFreeWorkflow();
int issignmustinput = WFNodeMainManager.getIssignmustinput();
if(!hassetting&&tmpIsFormSignature.equals("1")) hassetting=true;
if(!hassetting&&!nodetitle.equals("")) hassetting=true;
if(!hassetting&&IsPendingForward.equals("1")) hassetting=true;
if(!hassetting&&IsWaitForwardOpinion.equals("1")) hassetting=true;
if(!hassetting&&IsBeForward.equals("1")) hassetting=true;
if(!hassetting&&IsSubmitedOpinion.equals("1")) hassetting=true;
if(!hassetting&&IsSubmitForward.equals("1")) hassetting=true;
if(!hassetting&&issignmustinput==1) hassetting=true;
if(!hassetting&&IsFreeWorkflow.equals("1")) hassetting=true;
String tmpIsButtonName = "0";
String submitName7 = "";
String submitName8 = "";
String submitName9 = "";
String forwardName7 = "";
String forwardName8 = "";
String forwardName9 = "";
String saveName7 = "";
String saveName8 = "";
String saveName9 = "";
String rejectName7 = "";
String rejectName8 = "";
String rejectName9 = "";
String forsubName7 = "";
String forsubName8 = "";
String forsubName9 = "";
String ccsubName7 = "";
String ccsubName8 = "";
String ccsubName9 = "";
String haswfrm = "";
String hassmsrm = "";
String hasnoback = "";
String hasback = "";
String hasfornoback = "";
String hasforback = "";
String hasccnoback = "";
String hasccback = "";
String hasovertime = "";
rsName.executeSql("select * from workflow_nodecustomrcmenu where wfid="+wfid+" and nodeid="+tmpid);
if(rsName.next()){
	submitName7 = Util.null2String(rsName.getString("submitName7"));
	submitName8 = Util.null2String(rsName.getString("submitName8"));
	submitName9 = Util.null2String(rsName.getString("submitName9"));
	forwardName7 = Util.null2String(rsName.getString("forwardName7"));
	forwardName8 = Util.null2String(rsName.getString("forwardName8"));
	forwardName9 = Util.null2String(rsName.getString("forwardName9"));
	saveName7 = Util.null2String(rsName.getString("saveName7"));
	saveName8 = Util.null2String(rsName.getString("saveName8"));
	saveName9 = Util.null2String(rsName.getString("saveName9"));
	rejectName7 = Util.null2String(rsName.getString("rejectName7"));
	rejectName8 = Util.null2String(rsName.getString("rejectName8"));
	rejectName9 = Util.null2String(rsName.getString("rejectName9"));
	forsubName7 = Util.null2String(rsName.getString("forsubName7"));
	forsubName8 = Util.null2String(rsName.getString("forsubName8"));
	forsubName9 = Util.null2String(rsName.getString("forsubName9"));
	ccsubName7 = Util.null2String(rsName.getString("ccsubName7"));
	ccsubName8 = Util.null2String(rsName.getString("ccsubName8"));
	ccsubName9 = Util.null2String(rsName.getString("ccsubName9"));
	haswfrm = Util.null2String(rsName.getString("haswfrm"));
	hassmsrm = Util.null2String(rsName.getString("hassmsrm"));
	hasnoback = Util.null2String(rsName.getString("hasnoback"));
	hasback = Util.null2String(rsName.getString("hasback"));
	hasfornoback = Util.null2String(rsName.getString("hasfornoback"));
	hasforback = Util.null2String(rsName.getString("hasforback"));
	hasccnoback = Util.null2String(rsName.getString("hasccnoback"));
	hasccback = Util.null2String(rsName.getString("hasccback"));
	hasovertime = Util.null2String(rsName.getString("hasovertime"));
}
if((!"".equals(forwardName7) || !"".equals(forwardName8)|| !"".equals(forwardName9) || !"".equals(saveName7) || !"".equals(saveName8)|| !"".equals(saveName9) || !"".equals(rejectName7) || !"".equals(rejectName8)|| !"".equals(rejectName9) || "1".equals(haswfrm) || "1".equals(hassmsrm) || "1".equals(hasnoback) || "1".equals(hasback) || "1".equals(hasfornoback) || "1".equals(hasforback) || "1".equals(hasccnoback) || "1".equals(hasccback) || "1".equals(hasovertime)) && !"".equals(ifchangstatus)){
	tmpIsButtonName = "1";
}else if((!"".equals(forwardName7) || !"".equals(forwardName8)|| !"".equals(forwardName9) || !"".equals(saveName7) || !"".equals(saveName8)|| !"".equals(saveName9) || !"".equals(rejectName7) || !"".equals(rejectName8)|| !"".equals(rejectName9) || !"".equals(submitName7) || !"".equals(submitName8)|| !"".equals(submitName9) || !"".equals(forsubName7) || !"".equals(forsubName8)|| !"".equals(forsubName9) || !"".equals(ccsubName7) || !"".equals(ccsubName8)|| !"".equals(ccsubName9) || "1".equals(haswfrm) || "1".equals(hassmsrm) || "1".equals(hasovertime)) && "".equals(ifchangstatus)){
	tmpIsButtonName = "1";
}

String isTriDiffWorkflow=null;
RecordSet.executeSql("select isTriDiffWorkflow from workflow_base where id="+wfid);
if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
}
if(!"1".equals(isTriDiffWorkflow)){
	isTriDiffWorkflow="0";
}
String subwfSetTableName="Workflow_SubwfSet";
if("1".equals(isTriDiffWorkflow)){
	subwfSetTableName="Workflow_TriDiffWfDiffField";
}
String triSubwfName7=null;
String triSubwfName8=null;
RecordSet.executeSql("select triSubwfName7,triSubwfName8 from Workflow_TriSubwfButtonName where workflowId="+wfid+" and nodeId="+tmpid+" and subwfSetTableName='"+subwfSetTableName+"'");
while(RecordSet.next()){
	triSubwfName7=Util.null2String(RecordSet.getString("triSubwfName7"));
	triSubwfName8=Util.null2String(RecordSet.getString("triSubwfName8"));
	if(!triSubwfName7.equals("")||!triSubwfName8.equals("")){
		tmpIsButtonName = "1";
	}
}

%>
 <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >

<td><b><%=tmpname%></b></td>
<td>
<%if(tmptype.equals("0")){%><b><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></b><%}%>
<%if(tmptype.equals("1")){%><b><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></b><%}%>
<%if(tmptype.equals("2")){%><b><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></b><%}%>
<%if(tmptype.equals("3")){%><b><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></b><%}%>
</td>
<td>
<%if(operatelevel>0){%>
<button type="button"  class=Browser onclick="onShowNodeAttrBrowser(<%=tmpid%>)"></button>
<span id="nodeattr<%=tmpid%>Span">
 <%if(hassetting){%>
    <img src="/images/BacoCheck.gif" width="16" height="16" border="0">
 <%}%>
 </span>
<%}%>
</td>
<td>
<%if(operatelevel>0){%>
<button type="button"  class=Browser onclick="onShowButtonNameBrowser(<%=tmpid%>)"></button>
<span id="buttonName<%=tmpid%>Span">
 <%if("1".equals(tmpIsButtonName)){%>
    <img src="/images/BacoCheck.gif" width="16" height="16" border="0">
 <%}%>
 </span>
<%}%>
</td>
<%--xwj for td3130 20051122 begin--%>
<td>
 <%if(operatelevel>0){%>
<button type="button"  class=Browser onclick="onShowPreBrowser(<%=tmpid%>)"></button>
<span id="ischeckpre<%=tmpid%>span">
 <%if(hasPreRolesIds.indexOf(tmpid+"")!=-1){%>
    <img src="/images/BacoCheck.gif" width="16" height="16" border="0">
 <%}%>
 </span>
  <%}%>
</td>
<%--xwj for td3130 20051122 end--%>
<td>
    <%if(operatelevel>0){%>
<button type="button"  class=Browser onclick="onShowBrowser(<%=tmpid%>)"></button>
<span id="ischeck<%=tmpid%>span">
 <%if(hasRolesIds.indexOf(tmpid+"")!=-1){%>
    <img src="/images/BacoCheck.gif" width="16" height="16" border="0">
 <%}%>
 </span>
    <%}%>
</td>

<%--xwj taiping wf_log  control  2005-07-25  B E G I N --%>
<td>
    <%if(operatelevel>0){%>
    <button type="button"  class=Browser onclick="onShowBrowser1(<%=wfid%>,<%=tmpid%>)"></button>
    <span  name="por<%=tmpid%>_conspan" id="por<%=tmpid%>_conspan">
    <%if(!"".equals(tmpViewIds) && tmpViewIds != null){%><img src="/images/BacoCheck.gif" border=0></img>
    <%}%>
    </span>
    <%}%>
</td>
<%--xwj taiping wf_log  control  2005-07-25  E N D--%>
<%--mackjoe  2005-12-08  B E G I N --%>
    <td>
<%
    if(operatelevel>0){
if(!ajax.equals("1")){
%>
 <a href="addwfnodefield.jsp?wfid=<%=wfid%>&nodeid=<%=tmpid%>"><img src="/images/iedit.gif" width="16" height="16" border="0"></a>
<%}else{%>
 <a href="javascript:nodefieldedit(<%=tmpid%>)"><img src="/images/iedit.gif" width="16" height="16" border="0"></a>
<%}
}%>
 </td>
<%--end by mackjoe --%>



 <td>
<%
if(operatelevel>0){
if(!ajax.equals("1")){
%>
 <a href="addnodeoperator.jsp?wfid=<%=wfid%>&nodeid=<%=tmpid%>&formid=<%=formid%>&isbill=<%=isbill%>&iscust=<%=iscust%>"><img src="/images/iedit.gif" width="16" height="16" border="0">
<%}else{%>
 <a href="javascript:nodeopadd(<%=formid%>,<%=tmpid%>,<%=isbill%>,<%=iscust%>)"><img src="/images/iedit.gif" width="16" height="16" border="0">
<%}
}%>
 </a>
 <%

 WFNodeOperatorManager.resetParameter();
 WFNodeOperatorManager.setNodeid(tmpid);
WFNodeOperatorManager.selectNodeOperator();
%>
<%
while(WFNodeOperatorManager.next()){
 %>
<%
if(operatelevel>0){
if(!ajax.equals("1")){
%>
 <a href="editoperatorgroup.jsp?nodeid=<%=tmpid%>&wfid=<%=wfid%>&formid=<%=formid%>&isbill=<%=isbill%>&iscust=<%=iscust%>&id=<%=WFNodeOperatorManager.getId()%>">
<%}else{%>
 <a href="javascript:nodeopedit(<%=formid%>,<%=tmpid%>,<%=WFNodeOperatorManager.getId()%>,<%=isbill%>,<%=iscust%>)">
<%}
}%>
 <%=WFNodeOperatorManager.getName()%>
 </a> &nbsp
 <%}
 WFNodeOperatorManager.closeStatement();
 %>
</tr>
<TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=10></TD></TR><%--xwj for td3130 20051122--%>  <%--xwj taiping wf_log  control  2005-07-25 --%>
<%
rowsum += 1;
 if(linecolor==0) linecolor=1;
          else linecolor=0;
}
%>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="4"></td><%--xwj taiping wf_log  control  2005-07-25 --%>
</tr>
</table>

<br>
<center>

<input type="hidden" value="wfnode" name="src">
  <input type="hidden" value="<%=wfid%>" name="wfid">
  <input type="hidden" value="<%=formid%>" name="formid">
  <input type="hidden" value="0" name="nodesnum" value="<%=rowsum%>">
<center>
</form>
<%
 if(!ajax.equals("1")){
%>
<script>
function selectall(){
	window.document.forms[1].submit();

}

<%--xwj taiping wf_log  control  2005-07-25  B E G I N --%>
function onShowBrowser1(wfid,nodeid){
  url = "BrowserMain.jsp?url=wfNodeBrownser.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:400px');
    if(con != undefined){
        if(con=="1"){// "1" 代表 "全选" 或 "选择部分"
            document.all("por"+nodeid+"_conspan").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("por"+nodeid+"_conspan").innerHTML="";
        }
    }

}
<%--xwj taiping wf_log  control  2005-07-25  E N D --%>


function onShowBrowser(row){
//	alert(row);
	url = "BrowserMain.jsp?url=showaddinoperate.jsp?wfid=<%=wfid%>&nodeid="+row;
//	alert(url);
	con = window.showModalDialog(url);
//  alert(con==undefined);
    if(con != undefined){
        if(con=="1"){
            document.all("ischeck"+row+"span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("ischeck"+row+"span").innerHTML="";
        }
    }

}
<%--xwj for td3130 20051122 begin--%>
function onShowPreBrowser(row){
	url = "BrowserMain.jsp?url=showpreaddinoperate.jsp?wfid=<%=wfid%>&nodeid="+row;
	con = window.showModalDialog(url);
    if(con != undefined){
        if(con=="1"){
            document.all("ischeckpre"+row+"span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("ischeckpre"+row+"span").innerHTML="";
        }
    }

}
<%--xwj for td3130 20051122 end--%>
function onShowNodeAttrBrowser(nodeid){
	url = "BrowserMain.jsp?url=showNodeAttrOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url,'','dialogHeight:500px;dialogwidth:600px');
    if(con != undefined){
        if(con=="1"){
            document.all("nodeattr"+nodeid+"Span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("nodeattr"+nodeid+"Span").innerHTML="";
        }
    }
}

function onShowButtonNameBrowser(nodeid){
	url = "BrowserMain.jsp?url=showButtonNameOperate.jsp?wfid=<%=wfid%>&nodeid="+nodeid;
	con = window.showModalDialog(url);
    if(con != undefined){
        if(con=="1"){
            document.all("buttonName"+nodeid+"Span").innerHTML="<img src=\"/images/BacoCheck.gif\" width=\"16\" height=\"16\" border=\"0\">";
        }else{
            document.all("buttonName"+nodeid+"Span").innerHTML="";
        }
    }
}

function openFullWindow(url){
  var redirectUrl = url ;
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
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}

function openFullWindowHaveBar(url){
  var redirectUrl = url ;
  var width = screen.availWidth-10 ;
  var height = screen.availHeight-50 ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
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

//为了删除时用
function openFullWindow1(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  if (height == 768 ) height -= 75 ;
  if (height == 600 ) height -= 60 ;
  var szFeatures = "top="+height/2+"," ;
  szFeatures +="left="+width/2+"," ;
  szFeatures +="width=181," ;
  szFeatures +="height=129," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  if (height <= 600 ) szFeatures +="scrollbars=yes," ;
  else szFeatures +="scrollbars=no," ;
  szFeatures +="resizable=no" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}


function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  var szFeatures = "top=100," ;
  szFeatures +="left=400," ;
  szFeatures +="width="+width/2+"," ;
  szFeatures +="height="+height/2+"," ;
  szFeatures +="directories=no," ;
  szFeatures +="status=yes," ;
  szFeatures +="menubar=no," ;
  szFeatures +="scrollbars=yes," ;
  szFeatures +="resizable=yes" ; //channelmode
  window.open(redirectUrl,"",szFeatures) ;
}
</script>
<%}%>
</body>

</html>
