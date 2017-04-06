<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<html>
<%



	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	int wfid=0;
	int formid=0;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:wfmsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;

RCMenuHeight += RCMenuHeightStep;
    }
%>
<!--add by xhheng @ 2004/12/08 for TDID 1317-->
<%
    if(!ajax.equals("1")){
if(RecordSet.getDBType().equals("db2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=88 and relatedid="+wfid+",_self} " ;
}else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=88 and relatedid="+wfid+",_self} " ;

}

RCMenuHeight += RCMenuHeightStep ;
    }
    }
%>
<%if(!ajax.equals("1")){%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}else{%>
<%@ include file="/systeminfo/RightClickMenu1.jsp" %>
<%}%>
<form id="wfmForm" name="wfmForm" method=post action="wfFunctionManageOp.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
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
<%if(!ajax.equals("1")){%>
       <TR class="Title">
    	  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH></TR>
    <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <td class=field><strong><%=wfname%><strong></td>
  </tr>    <TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field><strong><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></strong></td>
  </tr><TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td>
    <td class=field><strong>
    <%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%></strong></td>
  </tr><TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
<%}%><!--portal end-->
  <tr>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></td>
    <%if(isbill.equals("0")){
            %>
            <td class=field><strong><%=FormComInfo.getFormname(""+formid)%></strong></td>
            <%}
            else if(isbill.equals("1")){
            	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
            %>
            <td class=field><strong><%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></strong></td>
            <%}else{%>
            <<td class=field><strong></strong></td>
            <%}%>
  </tr><TR class="Spacing">
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td class=field><strong><%=wfdes%></strong></td>
  </tr><TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(18361,user.getLanguage())%></th><th>
    	  </TH></TR>
<%if(!ajax.equals("1")){%>
    <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
<%}%>
</table>


<div id="odiv">
 <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
      <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  </table>
 <%if(!ajax.equals("1")){%>
  <table class=liststyle cellspacing=1   cols=6 id="oTable">
  <%}else{%>
  <table class=liststyle cellspacing=1   cols=6 id="oTable4port">
 <%}%>
      	<COLGROUP>
    <COL width="50%">
    <%--
<COL width="14%">
  <COL width="14%">
 <COL width="11%">
  <COL width="11%">
  	<COL width="7%">
  	--%>
  	<COL width="25%">
  	<COL width="25%">
    	   <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(388,user.getLanguage())%></td>
            <%--
            <td><input type="checkbox" name="sv" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></td>
            <td><input type="checkbox" name="dv" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></td>
            <td><input type="checkbox" name="zc" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(18357,user.getLanguage())%></td>
            <td><input type="checkbox" name="mc" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(18358,user.getLanguage())%></td>
            <td><input type="checkbox" name="fw" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></td>
            --%>
            <td><%=SystemEnv.getHtmlLabelName(18359,user.getLanguage())%></td>
            <td><input type="checkbox" name="ov" onClick="CheckAll(this.checked,this.name)"><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></td>
</tr><tr class="Line"><td colspan="3"> </td></tr>

<%
String sv = "";
String dv = "";
String zc = "";
String mc = "";
String fw = "";
String rb = "";
String ov = "";

RecordSet.executeSql("select * from workflow_function_manage where workflowid = " + wfid + " and operatortype = -1");
if(RecordSet.next()){
sv = RecordSet.getString("typeview");
dv = RecordSet.getString("dataview");
zc = RecordSet.getString("automatism");
mc = RecordSet.getString("manual");
fw = RecordSet.getString("transmit");
rb = RecordSet.getString("retract");
ov = RecordSet.getString("pigeonhole");
}
%>

<TR class=DataDark>
	<td  height="23"><%=SystemEnv.getHtmlLabelName(16758,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
	<%--
   <td  height="23"><input type="checkbox" name="watch_sv" value="1" <%if("1".equals(sv)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="watch_dv" value="1" <%if("1".equals(dv)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="watch_zc" value="1" <%if("1".equals(zc)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="watch_mc" value="1" <%if("1".equals(mc)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="watch_fw" value="1" <%if("1".equals(fw)){%>checked<%}%>></td>
    --%>
    <td height="23">
    <select class=inputstyle  name="watch_rb" >
	    <option value="0" <%if("0".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18364,user.getLanguage())%></option>
	    <option value="1" <%if("1".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18365,user.getLanguage())%></option>
	    <option value="2" <%if("2".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18366,user.getLanguage())%></option>
	  </select>
   </td>

 <td  height="23"><input type="checkbox" name="watch_ov" value="1" <%if("1".equals(ov)){%>checked<%}%>></td>
</tr>

<%--

sv = "";
dv = "";
zc = "";
mc = "";
fw = "";
rb = "";
ov = "";

RecordSet.executeSql("select * from workflow_function_manage where workflowid = " + wfid + " and operatortype = -2");
if(RecordSet.next()){
sv = RecordSet.getString("typeview");
dv = RecordSet.getString("dataview");
zc = RecordSet.getString("automatism");
mc = RecordSet.getString("manual");
fw = RecordSet.getString("transmit");
rb = RecordSet.getString("retract");
ov = RecordSet.getString("pigeonhole");
}
%>

<TR class=DataDark>

	<td  height="23"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>

  <td  height="23"><input type="checkbox" name="carete_sv" value="1" <%if("1".equals(sv)){%>checked<%}%>></td>

    <td  height="23"><input type="checkbox" name="carete_dv" value="1" <%if("1".equals(dv)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="carete_zc" value="1" <%if("1".equals(zc)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="carete_mc" value="1" <%if("1".equals(mc)){%>checked<%}%>></td>

   <td  height="23"><input type="checkbox" name="carete_fw" value="1" <%if("1".equals(fw)){%>checked<%}%>></td>

    <td height="23">
    <select class=inputstyle  name="carete_rb" >
	    <option value="0" <%if("0".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18364,user.getLanguage())%></option>
	    <option value="1" <%if("1".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18365,user.getLanguage())%></option>
	    <option value="2" <%if("2".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18366,user.getLanguage())%></option>
	  </select>
   </td>

 <td  height="23"><input type="checkbox" name="carete_ov" value="1" <%if("1".equals(ov)){%>checked<%}%>></td>
</tr>
--%>
<%
int colorcount=0;
int nodeid = -1;
String nodename = "";
String nodetype = "";
ArrayList nodeids=WFLinkInfo.getCannotDrowBackNode(wfid);
WFNodeMainManager.setWfid(wfid);
	WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
nodeid = WFNodeMainManager.getNodeid();
nodename = WFNodeMainManager.getNodename();
nodetype = WFNodeMainManager.getNodetype();

sv = "";
dv = "";
zc = "";
mc = "";
fw = "";
rb = "";
ov = "";

RecordSet.executeSql("select * from workflow_function_manage where workflowid = " + wfid + " and operatortype = " + nodeid);
if(RecordSet.next()){
sv = RecordSet.getString("typeview");
dv = RecordSet.getString("dataview");
zc = RecordSet.getString("automatism");
mc = RecordSet.getString("manual");
fw = RecordSet.getString("transmit");
rb = RecordSet.getString("retract");
ov = RecordSet.getString("pigeonhole");
}


if(colorcount==0){
		colorcount=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<td  height="23">
	<%if(!"0".equals(nodetype)){%>
	<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>
	<%}else{%>
	<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>
	<%}%>
	(<%=nodename%>)
	</td>
	<%--
  <td  height="23"><input type="checkbox" name="node<%=nodeid%>_sv" value="1" <%if("1".equals(sv)){%>checked<%}%>></td>
    
   <td  height="23"><input type="checkbox" name="node<%=nodeid%>_dv" value="1" <%if("1".equals(dv)){%>checked<%}%>></td>
   
   <td  height="23"><input type="checkbox" name="node<%=nodeid%>_zc" value="1" <%if("1".equals(zc)){%>checked<%}%>></td>
   
   <td  height="23"><input type="checkbox" name="node<%=nodeid%>_mc" value="1" <%if("1".equals(mc)){%>checked<%}%>></td>
   
   <td  height="23"><input type="checkbox" name="node<%=nodeid%>_fw" value="1" <%if("1".equals(fw)){%>checked<%}%>></td>
    --%>
    <td height="23">
    <select class=inputstyle  name="node<%=nodeid%>_rb" <%if(nodeids.indexOf(""+nodeid)>-1){%> disabled<%}%>>
	    <option value="0" <%if("0".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18364,user.getLanguage())%></option>
        <option value="1" <%if("1".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18365,user.getLanguage())%></option>
	    <option value="2" <%if("2".equals(rb)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18366,user.getLanguage())%></option>        
      </select>
   </td>
   
 <td  height="23"><input type="checkbox" name="node<%=nodeid%>_ov" value="1" <%if("1".equals(ov)){%>checked<%}%>></td>
</tr>
<%
rowsum+=1;
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
	<td height="10" colspan="3"></td>
</tr>
</table>

<br>
<center>
<input type="hidden" value="<%=wfid%>" name="wfid">
<center>
</form>
</div>

<%if(!ajax.equals("1")){%>
<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>
var rowColor="" ;
rowindex = "<%=rowsum%>";
delids = "";

function selectall(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;

	window.document.portform.submit();
}


</script>
<%}else{%>
<div id=portrowsum style="display:none;"><%=rowsum%></div>

<%}%>
</body>
</html>