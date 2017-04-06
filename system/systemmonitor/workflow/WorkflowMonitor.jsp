<%@ page language="java" contentType="text/html; charset=GBK" %> <!--added by xwj  for td2903  20051019-->
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/><!--xwj for td3665 20060224-->
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page" />
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("ovfail".equals(info)){%>
 alert(<%=SystemEnv.getHtmlLabelName(18566,user.getLanguage())%>)
 <%}
 else if("rbfail".equals(info)){%>
 alert(<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>)
 <%}
 else{
 
 }
 }%>
</script>
<%----xwj for td3665 20060301 end---%>


<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(16758,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnChangePage(1),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:deleteWorkflow(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(RecordSet.getDBType().equals("db2")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=85,_self} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=85,_self} " ;
}
if(false)
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20387,user.getLanguage())+",javascript:doStop(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16210,user.getLanguage())+",javascript:doCancel(this)(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+",javascript:doRestart(this)(this),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18360,user.getLanguage())+",javascript:doOverBackMutil(this),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<FORM id=weaver name=weaver method=get action="WorkflowMonitor.jsp"><%--xwj for td2978 20051108--%>
<input type=hidden name=fromself value="1">
<input type=hidden name=operation>
<div style="display:none">
<%
if(false)
{
%>
<BUTTON type="button" class=btnDelete accessKey=D onclick="doStop(this)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(20387,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btnDelete accessKey=D onclick="doCancel(this)"><U>C</U>-<%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btnDelete accessKey=D onclick="doRestart(this)"><U>R</U>-<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></BUTTON>
<%
}
%>
<BUTTON type="button" class=btnRefresh accessKey=R type="button" onclick="OnChangePage(1)"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btnDelete accessKey=D onclick="deleteWorkflow(this)"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btn accessKey=R onClick="location.href='/system/SystemMaintenance.jsp'"><U>R</U>-返回</BUTTON>
</div>

<%

ArrayList canoperaternode = new ArrayList(); //added by xwj  for td2903  20051019

/* --- added by xwj  for td2903  20051019 --  B E G I N ---*/
ArrayList monitorWfList = new ArrayList();
String monitorWfStrs = "";
//RecordSet.executeSql("select * from workflow_monitor_bound where monitorhrmid = " + user.getUID());
//if(RecordSet.next()){
//	monitorWfStrs="1";
//monitorWfList.add(RecordSet.getString("workflowid"));
//}

/* --- added by xwj  for td2903  20051019 --  E N D ---*/

String workflowid = "" ;
String nodetype ="" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestlevel ="" ;
String requestname ="" ;//added xwj for for td2903  20051019
int requestid = -1;

String fromself =Util.null2String(request.getParameter("fromself"));

if(fromself.equals("1")) {
	workflowid = Util.null2String(request.getParameter("workflowid"));
	nodetype = Util.null2String(request.getParameter("nodetype"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestlevel = Util.null2String(request.getParameter("requestlevel"));
	requestname = Util.null2String(request.getParameter("requestname"));//added xwj for for td2903  20051019
	requestid = Util.getIntValue(Util.null2String(request.getParameter("requestid")),-1);

    SearchClause.setWorkflowId(workflowid);
    SearchClause.setNodeType(nodetype);
    SearchClause.setFromDate(fromdate);
    SearchClause.setToDate(todate);
    SearchClause.setCreaterType(creatertype);
    SearchClause.setCreaterId(createrid);
    SearchClause.setRequestLevel(requestlevel);
    SearchClause.setRequestName(requestname);//added xwj for for td2903  20051019
}
else {
	workflowid = SearchClause.getWorkflowId();
	nodetype = SearchClause.getNodeType();
	fromdate = SearchClause.getFromDate();
	todate = SearchClause.getToDate();
	creatertype = SearchClause.getCreaterType();
	createrid = SearchClause.getCreaterId();
	requestlevel = SearchClause.getRequestLevel();
	requestname = SearchClause.getRequestName();//added xwj for for td2903  20051019
}


String newsql=" ";



if(!workflowid.equals("")&&!workflowid.equals("0"))
newsql+=" and a.workflowid in("+workflowid+")" ;

if(!nodetype.equals(""))
    newsql += " and currentnodetype='"+nodetype+"'";


if(!fromdate.equals(""))
    newsql += " and createdate>='"+fromdate+"'";

if(!todate.equals(""))
    newsql += " and createdate<='"+todate+"'";



if(!createrid.equals("")){
    newsql += " and creater='"+createrid+"'";
    newsql += " and creatertype= '"+creatertype+"' ";
}

if(!requestlevel.equals(""))
    newsql += " and requestlevel="+requestlevel;

//added by xwj for td2903  20051019
if(!requestname.equals(""))
    newsql += " and requestname like '%"+requestname+"%' ";

if(Util.null2String(request.getParameter("fromdate")).equals("") && Util.null2String(request.getParameter("isInit")).equals(""))
    newsql += " and 1=2 ";

//added by xwj for td2903  20051019
//if(!monitorWfStrs.equals("")){
    //newsql += " and workflowid in ("+monitorWfStrs+") ";
    //modify by ben 上面的语句会导致当流程类型过多时（有的客户有4000个流程类型）sql过长，运行出错
//    newsql += " and workflowid in (select workflowid from workflow_monitor_bound where monitorhrmid = " + user.getUID()+" ) ";}
//else{
//    newsql += " and 1<>1";
//}
newsql+=" and a.workflowid=b.workflowid and b.monitorhrmid = " + user.getUID()+" ";
String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();
String userlang = ""+user.getLanguage();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String requestidvalue = "";
if(requestid!=-1){
    requestidvalue = ""+requestid;
    newsql += " and requestid="+requestid;
}
if(!"".equals(newsql)){
	newsql = newsql.replaceFirst("and", "");
}
String sqlwhere = "where  " +newsql + "  ";
if(false)
{
	
	if(RecordSet.getDBType().equals("oracle"))
	{
		sqlwhere += " and (nvl(a.currentstatus,-1) = -1 or (nvl(a.currentstatus,-1)=0 and a.creater="+user.getUID()+")) ";
	}
	else
	{
		sqlwhere += " and (isnull(a.currentstatus,-1) = -1 or (isnull(a.currentstatus,-1)=0 and a.creater="+user.getUID()+")) ";
	}
}
String orderby=" createdate ,createtime ";

String tablename = "wrktablename"+ Util.getRandom() ;

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

%>

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


<table class=ViewForm>
  <colgroup>
  <col width="10%">
  <col width="20%">
  <col width="5">
  <col width="10%">
  <col width="20%">
  <col width="3%">
  <col width="6%">
  <col width="15">
  <tbody>
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
    <td class=field>
   
	<input class="wuiBrowser" name="workflowid" type="hidden"  value="<%=workflowid%>" _displayText="<%=WorkflowComInfo.getWorkflowname(workflowid)%>" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp">

    </td>

    <td>&nbsp;</td>
    <td><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></td>
    <td class=field>
     <select size=1  class=InputStyle name=nodetype style=width:150>
     <option value="">&nbsp;</option>
     <option value="0" <% if(nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
     	<option value="1" <% if(nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
     	<option value="2" <% if(nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
     	<option value="3" <% if(nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
     </select>
    </td>
    <td>&nbsp;</td>
    <td ><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></td>
	<td class=field>
	<select name=requestlevel  class=InputStyle style=width:140 size=1>
	  <option value=""> </option>
	  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
	  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
	  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
	</select>
	</td>
  </tr>
    <TR style="height:1px;">
   <TD class=Line colSpan=8></TD>
 </TR>
  <tr>
  
  <!--xwj for td2903  20051019 begin--> 
       <td><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></td>
    <td class=field>
	  <input type="text" name="requestname" value="<%=requestname%>">
    </td>
    <td>&nbsp;</td>
  <!--xwj for td2903  20051019 end--> 
  
    <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate  onclick="getDateForDocMonitor()"></BUTTON>
      <SPAN id=fromdatespan style="color: #000000;font-weight: normal;">
        <%if(Util.null2String(fromdate).equals("")){%>
		    	<img src="/images/BacoError.gif" align=absMiddle>
		<%}else{%>
		      <%=fromdate %>
		<%}%>
      </SPAN>
      
      -&nbsp;&nbsp;<BUTTON type="button" class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
      <SPAN id=todatespan ><%=todate%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>" onPropertyChange="">
	  <input type="hidden" name="todate" value="<%=todate%>">
    </td>

      <td>&nbsp;</td>
      <td ><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
	  <td class=field>
	  <select name=creatertype   class=InputStyle onchange="onCreatertypeChange(event)">
<%if(!user.getLogintype().equals("2")){%>
<%if(isgoveproj==0){%>
	  <option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
<%}else{%>
	<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
<%}%>
<%}%>
<%if(isgoveproj==0){%>
	  <option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
	  <%}%>
	  </select>
	  &nbsp
	
	<input name=createrid type=hidden class="wuiBrowser" value="<%=createrid%>" _displayText="<% if(creatertype.equals("0")){%><%=ResourceComInfo.getResourcename(createrid)%><%}%>
    <% if(creatertype.equals("1")){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage())%><%}%>"></td>
  </tr>
      <TR style="height:1px;">
	<TD class=Line colSpan=8></TD>
  </TR>
  <tr>
  	<td><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%>ID</td>
  	<td class=field>
  		<input type="text" id="requestid" name="requestid" value="<%=requestidvalue%>" onKeyPress="ItemCount_KeyPress()" onBlur="checkcount1(this)">
  	</td>
  	<td colSpan=6></td>
  </tr>
	<TR style="height:1px;"><TD class=Line colSpan=8></TD></TR>
  </tbody>
</table>
<input name="start" type="hidden" value="<%=start%>">
<input type="hidden" name="multiRequestIds" value="">
<input type="hidden" name="multiSubIds" id="multiSubIds" value="">
<input type="hidden" name="flag" id="flag" value="">
<input type="hidden" name="requestfrom" id="requestfrom" value="">
<input type="hidden" name="requestidvalue" id="requestidvalue" value="">
<%
String tableString = "";
if(perpage <2) perpage=10;                                 
//String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel,b.isview ";
String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel,a.currentstatus,a.currentnodetype,b.isview ";
String fromSql  = " workflow_requestbase a,(select max(isview) isview,workflowid,monitorhrmid from workflow_monitor_bound where monitorhrmid="+user.getUID()+" group by workflowid,monitorhrmid) b";
String sqlWhere = sqlwhere;
//out.print("select "+backfields + "from "+fromSql+" where "+sqlWhere);
//String para2="column:requestid+"+CurrentUser+"+"+logintype+"+"+userlang;
String para2="column:requestid+"+CurrentUser+"+"+logintype+"+"+userlang+"+column:currentstatus+column:creater+column:currentnodetype";
String para11="column:requestname+"+"("+"column:requestid+"+")";
String para1="column:requestid+column:isview";
String para4=userlang+"+"+user.getUID();
String para3="column:workflowid+"+CurrentUser+"+"+logintype;
tableString =   " <table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
                " <checkboxpopedom    popedompara=\""+para3+"\" showmethod=\"weaver.general.WorkFlowTransMethod.getWFMonitorCheckBox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultFlowName\"  otherpara=\""+para1+"\" />"+
                "           <col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"a.workflowid,a.requestname\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
                "           <col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
                "           <col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" orderkey=\"currentnodeid\"  transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\" />"+
                "           <col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(18565,user.getLanguage())+"\" column=\"requestid\"  otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\" />"+
                "           <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" />"+
                "           <col width=\"8%\" height='120' text=\""+SystemEnv.getHtmlLabelName(18361,user.getLanguage())+"\" column=\"workflowid\" transmethod=\"weaver.general.WorkFlowTransMethod.getMonitorLink\" otherpara=\""+para2+"\" />"+
                "       </head>"+
                " </table>";
%>

<TABLE width="100%">
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>


<br>
<table align=right>
   <tr>
    <td>&nbsp;</td>
    <td>
    <%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    %>
    </td>
    <td>&nbsp;</td>
   </tr>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<SCRIPT type="text/javascript">
onCreatertypeChange();
function onCreatertypeChange(){
	var tmpval = $("select[name=creatertype]").val();
	if(tmpval=="0")
		$("input[name=createrid]").attr("_url","/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	else
		$("input[name=createrid]").attr("_url","/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
}
function doMonitorRequestSignle(requestid, flag){
	var tips = "";
	if(flag=="stop")
	{
		tips = "<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?";
	}
	else if(flag=="cancel")
	{
		tips = "<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?";
	}
	else if(flag=="restart")
	{
		tips = "<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?";
	}
	if(tips!="")
	{
		if(!confirm(tips))
		{
			return false;
		}
	}
	document.weaver.requestidvalue.value = requestid;
	document.weaver.method = "post";
	document.weaver.flag.value = flag;
	document.weaver.requestfrom.value = "mo";
	document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
	document.weaver.submit();
}
function OnChangePage(start){
        document.weaver.start.value = start;
        document.weaver.method = "post";
        if(check_form(document.weaver,'fromdate'))
		document.weaver.submit();
}
function doOverBackMutil(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	document.weaver.method = "post";
		document.weaver.multiRequestIds.value = requestids;
		document.weaver.flag.value = "ovmwfm";
		document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
		obj.disabled = true;
		document.weaver.submit();
	}else{
        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function doOverBackMutil(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	document.weaver.method = "post";
		document.weaver.multiRequestIds.value = requestids;
		document.weaver.flag.value = "ovmwfm";
		document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
		obj.disabled = true;
		document.weaver.submit();
	}else{
        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function doStop(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	//您确定要暂停当前流程吗?
		if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
	    	document.weaver.method = "post";
			document.weaver.multiRequestIds.value = requestids;
			document.weaver.flag.value = "mostop";
			document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
			obj.disabled = true;
			document.weaver.submit();
		}
		else
		{
			return false;
		}
	}else{
        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function doCancel(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	//您确定要撤销当前流程吗?
		if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?"))
		{
	    	document.weaver.method = "post";
			document.weaver.multiRequestIds.value = requestids;
			document.weaver.flag.value = "mocancel";
			document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
			obj.disabled = true;
			document.weaver.submit();
		}
		else
		{
			return false;
		}
	}else{
        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function doRestart(obj){
	var requestids = _xtable_CheckedCheckboxId();
    if(requestids != ""){
    	//您确定要启用当前流程吗?
		if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
	    	document.weaver.method = "post";
			document.weaver.multiRequestIds.value = requestids;
			document.weaver.flag.value = "morestart";
			document.weaver.action = "/workflow/workflow/wfFunctionManageLink.jsp";
			obj.disabled = true;
			document.weaver.submit();
		}
		else
		{
			return false;
		}
	}else{
        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}
function deleteWorkflow(obj){
    if(_xtable_CheckedCheckboxId()!=""){
        if(isdel()) {
//            obj.disabled=true;
//            //
//            
//            jQuery.get("/system/systemmonitor/MonitorOperation.jsp", { operation:'deleteworkflow',multiRequestIds:_xtable_CheckedCheckboxId() },
//				function(data){
//			    	//alert("Data Loaded: " + data);
//			    	_table.reLoad();
//			    	obj.disabled=false;  
//			    }
//			 ); 
            obj.disabled=true;
            document.weaver.multiRequestIds.value = _xtable_CheckedCheckboxId();
            document.weaver.operation.value='deleteworkflow';
            document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
            document.weaver.submit();
        }
	}else{
        alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
    }
}



var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
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
function showallreceived(requestid,returntdid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
	
    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态
    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}
function getDateForDocMonitor(){
	WdatePicker({el:$('#fromdatespan')[0],onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		$dp.$($('input[name=fromdate]')[0]).value = returnvalue;
	},oncleared:function(dp){
		$dp.$($('input[name=fromdate]')[0]).value="";
		$('#fromdatespan').html("<img src=\"/images/BacoError.gif\" align=\"absMiddle\">");
		
	}});
} 
</script>
</body>
</html>
<SCRIPT language="javascript"  src="/js/datetime.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker.js"></script>