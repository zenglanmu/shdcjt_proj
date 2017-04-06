<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css"></HEAD>

<%
Enumeration em = request.getParameterNames();
boolean isinit = true;
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("splitflag"))
		isinit = false;
	break;
}
int date2during= Util.getIntValue(request.getParameter("date2during"),0) ;
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(isinit)
{
	date2during = olddate2during;
}
String requestname = Util.null2String(request.getParameter("requestname"));
String creater = Util.null2String(request.getParameter("creater"));
String createdatestart = Util.null2String(request.getParameter("createdatestart"));
String createdateend = Util.null2String(request.getParameter("createdateend"));
String isrequest = Util.null2String(request.getParameter("isrequest"));
String requestmark = Util.null2String(request.getParameter("requestmark"));
String prjids=Util.null2String(request.getParameter("prjids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String department =Util.null2String(request.getParameter("department"));
String status = Util.null2String(request.getParameter("status"));
String sqlwhere = "";
if (isrequest.equals("")) isrequest = "1";

String userid = ""+user.getUID() ;
String usertype="0";

if(user.getLogintype().equals("2")) usertype="1";

String check_per = Util.null2String(request.getParameter("resourceids"));

String resourceids = "";
String resourcenames = "";

if (!check_per.equals("")) {
	if(check_per.indexOf(',')==0){
		check_per=check_per.substring(1);
	}
	String strtmp = "select requestid,requestname from workflow_requestbase  where requestid in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while (RecordSet.next()) {
		ht.put( Util.null2String(RecordSet.getString("requestid")), Util.null2String(RecordSet.getString("requestname")));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}
	try{
		StringTokenizer st = new StringTokenizer(check_per,",");

		while(st.hasMoreTokens()){
			String s = st.nextToken();
			if(ht.containsKey(s)){//如果check_per中的已选的流程此时不存在会出错
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}
	}catch(Exception e){
		resourceids ="";
		resourcenames ="";
	}
}

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!requestname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
}

if(!creater.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where creater =" + creater +" and creatertype=0 " ;
	}
	else
		sqlwhere += " and creater =" + creater +" and creatertype=0 " ;
}

if(!createdatestart.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where createdate >='" + createdatestart +"' " ;
	}
	else
		sqlwhere += " and createdate >='" + createdatestart +"' " ;
}

if(!createdateend.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where createdate <='" + createdateend +"' " ;
	}
	else
		sqlwhere += " and createdate <='" + createdateend +"' " ;
}

if(status.equals("1")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where currentnodetype < 3 " ;
	}
	else
		sqlwhere += " and currentnodetype < 3 " ;	
}

if(status.equals("2")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where currentnodetype = 3 " ;
	}
	else
		sqlwhere += " and currentnodetype = 3 " ;	
}

if(!workflowid.equals("")&&!workflowid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflow_requestbase.workflowid = " + workflowid ;
	}
	else
		sqlwhere += " and workflow_requestbase.workflowid = " + workflowid ;	
}

if(!department.equals("")&&!department.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where workflow_requestbase.creater in (select id from hrmresource where departmentid in ("+department+"))";
	}
	else
		sqlwhere += " and workflow_requestbase.creater in (select id from hrmresource where departmentid in ("+department+"))";
}

if(!prjids.equals("")&&!prjids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(workflow_requestbase.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,workflow_requestbase.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(workflow_requestbase.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,workflow_requestbase.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}	
}

if(!crmids.equals("")&&!crmids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(workflow_requestbase.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,workflow_requestbase.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(workflow_requestbase.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,workflow_requestbase.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}	
}

if(!requestmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where requestmark like '%" + requestmark +"%' " ;
	}
	else
		sqlwhere += " and requestmark like '%" + requestmark +"%' " ;
}

if (sqlwhere.equals("")) sqlwhere = " where workflow_requestbase.requestid <> 0 " ;
if(RecordSet.getDBType().equals("oracle"))
{
	sqlwhere += " and (nvl(workflow_requestbase.currentstatus,-1) = -1 or (nvl(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+")) ";
}
else
{
	sqlwhere += " and (isnull(workflow_requestbase.currentstatus,-1) = -1 or (isnull(workflow_requestbase.currentstatus,-1)=0 and workflow_requestbase.creater="+user.getUID()+")) ";
}
sqlwhere += WorkflowComInfo.getDateDuringSql(date2during);
String sqlstr = "" ;
String temptable = "wftemptable"+ Util.getRandom() ;
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=50;

if(RecordSet.getDBType().equals("oracle")){
		//sqlstr = "create table "+temptable+"  as select * from (select distinct workflow_requestbase.requestid ,requestname,creater,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc, createtime desc) where rownum<"+ (pagenum*perpage+2);
		sqlstr = "(select * from (select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc, createtime desc) where rownum<"+ (pagenum*perpage+2) + ") s";
}else if(RecordSet.getDBType().equals("db2")){
		//sqlstr = "create table "+temptable+"  as (select distinct workflow_requestbase.requestid ,requestname,creater,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base) definition only ";

        //RecordSet.executeSql(sqlstr);

       //sqlstr = "insert  into "+temptable+" (select distinct  workflow_requestbase.requestid ,requestname,creater,createdate,createtime  from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc fetch  first "+(pagenum*perpage+1)+" rows only )" ;
}else{
		//sqlstr = "select distinct top "+(pagenum*perpage+1)+" workflow_requestbase.requestid ,requestname,creater,createdate,createtime into "+temptable+" from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc" ;
		sqlstr = "(select distinct top "+(pagenum*perpage+1)+" workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc) as s " ;
}

//System.out.println("sqlstr="+sqlstr);
//RecordSet.executeSql(sqlstr);


//RecordSet.executeSql("Select count(requestid) RecordSetCounts from "+temptable);
RecordSet.executeSql("Select count(requestid) RecordSetCounts from "+sqlstr);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}

String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	//sqltemp="select * from (select * from  "+temptable+" order by createdate , createtime ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
	sqltemp="select * from (select * from  "+sqlstr+" order by createdate , createtime ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1);
}else if(RecordSet.getDBType().equals("db2")){
    //sqltemp="select  * from "+temptable+"  order by createdate , createtime fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only ";
}else{
	//sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by createdate , createtime ";
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sqlstr+"  order by createdate , createtime ";
}
RecordSet.executeSql(sqltemp);
%>
<BODY scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver name=SearchForm style="margin-bottom:0" action="MultiRequestBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value="<%=sqlwhere%>">
		<input type="hidden" name="pagenum" id="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<input type="hidden" name="isrequest" value='<%=isrequest%>'>
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<button type="button" class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<button type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>

			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<button type="button" class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>


			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			%>
			<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
	<table width=100% class="viewform">
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input name=requestname class=Inputstyle value="<%=requestname%>">
      </TD>
      <TD width=15%><%if(!user.getLogintype().equals("2")){%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%}%></TD>
      <TD width=35% class=field>
      
      <%if(!user.getLogintype().equals("2")){%>
   
       <INPUT class="wuiBrowser" id=creater type=hidden name=creater value="<%=creater%>"
       			_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%>" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}' target='blank'>#b{name} </A>"
       		 _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"> 
        <%}%>
      </TD>
    </TR><TR  style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
      <TD width=35% class=field><button type="button" class=Calendar id=selectbirthday onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
  		  <SPAN id=createdatestartspan ><%=createdatestart%></SPAN>
  		  - &nbsp;<button type="button" class=Calendar id=selectbirthday1 onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
  		  <SPAN id=createdateendspan ><%=createdateend%></SPAN>
  		  <input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>">
  		  <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>"></TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></TD>
      <TD width=35% class=field><input name=requestmark class=Inputstyle value="<%=requestmark%>"></TD>
    </tr>
	<TR  style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></TD>
	<TD width=35% class=Field>
		
		<input class="wuiBrowser" id=department type=hidden name=department value="<%=department%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
			_displayText="<%
			String departments[] = Util.TokenizerString2(department,",");
			String departmentnames = "";
			for(int i=0;i<departments.length;i++){
				if(!departments[i].equals("")&&!departments[i].equals("0")){
					departmentnames += (!departmentnames.equals("")?",":"") + DepartmentComInfo.getDepartmentname(departments[i]);
				}
			}
			out.println(departmentnames);	
		%>"
		>
	</TD>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
	<td width=35% class=field>
	
		<input name=prjids type=hidden class="wuiBrowser" value="<%=prjids%>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
			_displayText="<%=ProjectInfoComInfo.getProjectInfoname(prjids)%>"
		>
	</td>      
    </tr>

    <TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
	  <td class=field>
		
		<input name=workflowid class="wuiBrowser" type=hidden value="<%=workflowid%>" _displayText="<%=WorkflowComInfo.getWorkflowname(workflowid)%>"
			_url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp">	
	  </td>
	  <td width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
	  <td width=35% class=field>
		<input name=crmids type=hidden class="wuiBrowser" value="<%=crmids%>"
			_displayText="<%=crmComInfo.getCustomerInfoname(crmids)%>"
			 _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"></td>
    </tr>
	<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></TD>
		<TD width=35% class=field>
			<select id=status name=status>
				<OPTION value=""></OPTION>
				<OPTION value="1" <%if(status.equals("1")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23773,user.getLanguage())%></OPTION>
				<OPTION value="2" <%if(status.equals("2")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(23774,user.getLanguage())%></OPTION>
			</select>
		</TD>
		<%
		if(date2duringTokens.length>0)
		{
		%>
		<!-- 接收期间 -->
        <td class="lable"><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
	    <td class="field">
	     <select class=inputstyle  size=1 id=date2during name=date2during style=width:80%>
	     	<option value="">&nbsp;</option>
	     	<%
	     	for(int i=0;i<date2duringTokens.length;i++)
	     	{
	     		int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
	     		if(tempdate2during>36||tempdate2during<1)
	      		{
	      			continue;
	      		}
	     	%>
	     	<!-- 最近个月 -->
	     	<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
	     	<%
	     	} 
	     	%>
	     	<!-- 全部 -->
	     	<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	     </select>
	    </td>
	    <%
	    }
		else
	    {
	    %>
	    <TD colSpan=2>&nbsp;</TD>
	    <%
	    } 
	    %>
	</tr>

    <TR class="Spacing"  style="height:1px;">
      <TD class="Line1" colspan=4></TD>
    </TR>
  </table>
<!--#################Search Table END//######################-->
<tr width="100%">
<td width="60%" valign="top">
	<!--############Browser Table START################-->
	<TABLE class="BroswerStyle" cellspacing="0" cellpadding="0" style="width:100%">
		<TR class=DataHeader>
	  <TH width=47%><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></TH>
	  <TH width=19%><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TH>
      <TH width=34%><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH></tr>
	  <TR class=Line  style="height:1px;"><Th colspan="3" ></Th></TR>

		<tr>
		<td colspan="3" width="100%">
			<div style="overflow-y:scroll;width:100%;height:260px">
			<table width="100%" id="BrowseTable"  style="width:100%;">
			<COLGROUP>
			<COL width="50%">
			<COL width="20%">
			<COL width="30%">
				<%
				int i=0;
				int totalline=1;
				RequestBrowser rb = new RequestBrowser();
				if(RecordSet.last()){
					do{
					String requestids = RecordSet.getString("requestid");
					String requestnames = Util.toScreen(RecordSet.getString("requestname"),user.getLanguage());
					String creaters = RecordSet.getString("creater");
					int creatertype = Util.getIntValue(RecordSet.getString("creatertype"), 0);
					String createdates = RecordSet.getString("createdate");
					String createtimes = RecordSet.getString("createtime");
					String _temp = rb.getWfNewLink(requestnames,requestids+"+"+user.getLanguage());
					String creatername = "";
					if(creatertype == 0){
						creatername = Util.toScreen(ResourceComInfo.getResourcename(creaters),user.getLanguage());
					}else{
						creatername = Util.toScreen(crmComInfo.getCustomerInfoname(creaters),user.getLanguage());
					}
					if(i==0){
						i=1;
				%>
					<TR class=DataLight>
					<%
						}else{
							i=0;
					%>
					<TR class=DataDark>
					<%
					}
					%>
					<TD style="display:none"><A HREF=#><%=requestids%></A></TD>
					<TD style="display:none"><%=requestnames%></TD>
		<TD style="word-break:break-all"><%=_temp%></TD>
		<TD style="word-break:break-all"><%=creatername%></TD>
		<TD style="word-break:break-all"><%=createdates%> <%=createtimes%></TD>
				</TR>
				<%
					if(hasNextPage){
						totalline+=1;
						if(totalline>perpage)	break;
					}
				}while(RecordSet.previous());
				}
				//RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>
							   <%if(pagenum>1){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type="button" type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum-1%>;document.SearchForm.submit();"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>
							   <%if(hasNextPage){%>
						<%
						RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
						RCMenuHeight += RCMenuHeightStep ;
						%>
									<button type="button" type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum+1%>;document.SearchForm.submit();"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
							   <%}%>
						   </td>
						   <td>&nbsp;</td>
						</tr>
						<input type="hidden" id=forAddSingleClick name="forAddSingleClick" >
						</table>
			</div>
		</td>
	</tr>
	</TABLE>
</td>
<!--##########Browser Table END//#############-->
<td width="40%" valign="top">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" width="30%">
				<img src="/images/arrow_u.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084,user.getLanguage())%>" onclick="javascript:upFromList();">
				<br>
				<img src="/images/arrow_left_all.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025,user.getLanguage())%>" onClick="javascript:addAllToList();">
				<br>	
				<!--
				<img src="/images/arrow_left.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onClick="javascript:addToList();">
				<br>
				-->
				<img src="/images/arrow_right.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="javascript:deleteFromList();">				
				<br>			
				<img src="/images/arrow_right_all.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%>" onclick="javascript:deleteAllFromList();">				
				<br>
				<img src="/images/arrow_d.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085,user.getLanguage())%>" onclick="javascript:downFromList();">
  		</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->

</td>
</tr>

	</FORM>

		</td>
		</tr>
		</TABLE>
		<!--##############Shadow Table END//######################-->
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>

<script type="text/javascript">
<!--
	resourceids = "<%=resourceids%>";
	resourcenames = "<%=resourcenames%>";
	function btnclear_onclick(){
	    window.parent.parent.returnValue = {id:"",name:""};
	    window.parent.parent.close();
	}


function btnok_onclick(){
	  setResourceStr();
	 window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
    window.parent.parent.close();
}

function btnsub_onclick(){
    setResourceStr();
   $("#resourceids").val(resourceids);
   document.SearchForm.submit();
}
	
function BrowseTable_onclick(e){
	var target =  e.srcElement||e.target ;
	try{
	if(target.nodeName == "TD" || target.nodeName == "A"){
		var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+$($(target).parents("tr")[0].cells[1]).text() ;
		if(!isExistEntry(newEntry,resourceArray)){
			addObjectToSelect($("select[name=srcList]")[0],newEntry);
			reloadResourceArray();
		}
	}
	}catch (en) {
		alert(en.message);
	}
}
function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark";
      }else{
         p.className = "DataLight";
      }
   }
}

jQuery(document).ready(function(){
	jQuery("#BrowseTable").bind("click",BrowseTable_onclick)
	jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover)
	jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout)
})
//-->
</script>
<script language="javascript">
//var resourceids = "<%=resourceids%>"
//var resourcenames = "<%=resourcenames%>"

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = document.all("srcList");
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
/**
加入一个object 到Select List
 格式object ="1~董芳"
*/
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	for(var i=0;i<arrayObj.length;i++){
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $G("srcList");
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $G("srcList");
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList = $("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+destList.options[i].text ;
	}
	//alert(resourceArray.length);
}

function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	$("input[name=resourceids]").val(resourceids.substring(1));
}

function doSearch()
{
	setResourceStr();
    document.all("resourceids").value = resourceids.substring(1) ;
    document.SearchForm.submit();
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>