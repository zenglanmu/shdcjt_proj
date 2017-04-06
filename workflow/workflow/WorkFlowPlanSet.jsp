<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
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
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
%>
<%

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
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
	String frequencyt="";
	String status="1";
	String dateType="";
	String timeSet="";
	String dateSum="0";
	String alertType="0";
	
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
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
 if(operatelevel>0){
    if(!ajax.equals("1"))
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowPlanSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
    if(!ajax.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;

RCMenuHeight += RCMenuHeightStep;
    }
%>

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
<form id="flowPlanForm" name="flowPlanForm" method=post action="WorkFlowPlanSetOperation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
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
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></td>
    <td class=field><strong><%=wfname%><strong></td>
  </tr>    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
 <tr>
    <td><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></td>
    <td class=field><strong><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></strong></td>
  </tr><TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
<%if(isPortalOK){%><!--portal begin-->
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></td>
    <td class=field><strong>
    <%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%></strong></td>
  </tr><TR class="Spacing" style="height:1px;">
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
  </tr><TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
   <tr>
    <td><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></td>
    <td class=field><strong><%=wfdes%></strong></td>
  </tr><TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
          <td colspan="2" align="center" height="15"></td>
        </tr>
<%}%>
          <TR class="Title">
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(18812,user.getLanguage())%></th><th>
    	  </TH></TR>
<%if(!ajax.equals("1")){%>
    <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
<%}%>
</table>


<div id="odiv">
 <table class="viewform">
   <COLGROUP>
   <COL width="20%">
   <COL width="80%">
      <TR class="Spacing" style="height:1px;">
    	  <TD class="Line1" colSpan=2></TD></TR>
  <tr>
  </table>
  <%
  RecordSet.execute("select * from WorkFlowPlanSet where flowid="+wfid);
  if(RecordSet.next())
  {
  status=RecordSet.getString("status");
  frequencyt=RecordSet.getString("frequencyt");
  dateType=RecordSet.getString("dateType");
  timeSet=RecordSet.getString("timeSet");
  dateSum=RecordSet.getString("dateSum");
  alertType=RecordSet.getString("alertType");
  }
  %>
 <%if(!ajax.equals("1")){%>
  <table class=viewform cellspacing=1  id="oTable">
  <%}else{%>
  <table class=viewform cellspacing=1  id="oTable4port">
 <%}%>
  <COLGROUP>
    <COL width="20%">
  	<COL width="80%">
    	   <tr>
            <td><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18812,user.getLanguage())%></td>
            <td class=Field><input class=inputstyle type="checkbox" name="status" value="0" <%if (status.equals("0")) {%>checked<%}%> >
             <!-- 是否起用--></td>
</tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
</table>
<table  class="viewform" border="0" cellspacing="0" cellpadding="0">
 <TR class="Spacing" style="height:1px;">
   <TD class="Line1" ></TD></TR>
 <TR class="Title">
    <TH><br><%=SystemEnv.getHtmlLabelName(16498,user.getLanguage())%></th><th>
  </TH></TR>
 <TR class="Spacing" style="height:1px;">
   <TD class="Line1" ></TD></TR>
</table>
 <%if(!ajax.equals("1")){%>
  <table class=ViewForm cellspacing=1   cols=6 id="oTable">
  <%}else{%>
  <table class=ViewForm cellspacing=1   cols=6 id="oTable4port">
 <%}%>
  <COLGROUP>
    <COL width="20%">
  	<COL width="80%">
             <!-- 频率-->
    	   <tr>
            <td><%=SystemEnv.getHtmlLabelName(18813,user.getLanguage())%></td>
            <td class=Field>
            <select class=inputstyle  name="frequencyt" onchange="changeset(this)">
            <option value="4" <%if (frequencyt.equals("4")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%></option><!--每日-->
            <option value="0" <%if (frequencyt.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%></option><!--每周-->
            <option value="1" <%if (frequencyt.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option><!--每月-->
            <option value="2" <%if (frequencyt.equals("2")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option><!--每季度-->
            <option value="3" <%if (frequencyt.equals("3")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option><!--每年-->          
            </select>
             </td>
          </tr> 
          <TR class="Spacing" style="height:1px;">
    	     <TD class="Line" colSpan=2></TD>
    	  </TR>
          <!-- 日期设置-->
          <tr id="datetypetr" <%if(frequencyt.equals("4")||frequencyt.equals("")) out.println("style='display:none'");%>>
            <td><%=SystemEnv.getHtmlLabelName(18814,user.getLanguage())%></td>
            <td class=Field id="datetypetd"><select class=inputstyle name="dateType">
            <option value="0" <%if (dateType.equals("0")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></option><!--正数-->
            <option value="1" <%if (dateType.equals("1")){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></option><!--倒数-->
            </select><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%><input class=inputstyle value="<%=dateSum%>" name="dateSum"  maxLength=3 size=3  onchange="checkint('dateSum')"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
            </td>
          </tr>
          <TR id="datetypetr" class="Spacing" <%if(frequencyt.equals("4")||frequencyt.equals("")) {out.println("style='display:none'");}else{%> style="height:1px;"<%}%>>
    	     <TD class="Line" colSpan=2></TD>
    	  </TR>
          <!-- 时间设置-->
          <tr id="timesettr">
            <td><%=SystemEnv.getHtmlLabelName(16498,user.getLanguage())%></td>
            <td class=Field><button type="button" class=Clock onclick="onShowTime(timesetspan,timeSet)"></button><span id=timesetspan><%=timeSet%></span><input type=hidden class=inputstyle name="timeSet"  maxLength=2 size=2 value="<%=timeSet%>"></td>
		  </tr> 
		  <TR id="timesettr" class="Spacing" style="height:1px;">
    	    <TD class="Line" colSpan=2></TD>
    	  </TR>
		  </table>

<table  class="viewform" border="0" cellspacing="0" cellpadding="0">
 <TR class="Spacing" style="height:1px;">
   <TD class="Line1"></TD></TR>
 <TR class="Title">
    <TH><br><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></th><th>
  </TH></TR>
 <TR class="Spacing" style="height:1px;">
   <TD class="Line1" ></TD></TR>
</table>
 <%if(!ajax.equals("1")){%>
  <table class=ViewForm cellspacing=1   cols=6 id="oTable">
  <%}else{%>
  <table class=ViewForm cellspacing=1   cols=6 id="oTable4port">
 <%}%>
  <COLGROUP>
    <COL width="20%">
  	<COL width="80%">
    	   <tr>
            <td><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></td>
            <td class=Field><input class=inputstyle type="checkbox" name="alertType1" value="1" <%if (alertType.equals("1")||alertType.equals("3")) {%>checked<%}%>>
             <!-- 短信提醒--></td>
			</tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
    	   <tr>
            <td><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
            <td class=Field><input class=inputstyle type="checkbox" name="alertType2" value="2" <%if (alertType.equals("2")||alertType.equals("3")) {%>checked<%}%>>
             <!-- 邮件提醒--></td>
			</tr> <TR class="Spacing" style="height:1px;">
    	  <TD class="Line" colSpan=2></TD></TR>
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