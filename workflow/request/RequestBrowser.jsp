<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
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
    //System.out.println("requestname = " + requestname);
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
		sqlstr = " (select * from (select distinct workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc, createtime desc) where rownum<"+ (pagenum*perpage+2) + ") s";
}else{
		//sqlstr = "select distinct top "+(pagenum*perpage+1)+" workflow_requestbase.requestid ,requestname,creater,createdate,createtime into "+temptable+" from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc" ;
		sqlstr = " (select distinct top "+(pagenum*perpage+1)+" workflow_requestbase.requestid ,requestname,creater,creatertype,createdate,createtime from workflow_requestbase , workflow_currentoperator , workflow_base" + sqlwhere + " and workflow_currentoperator.requestid = workflow_requestbase.requestid and workflow_currentoperator.userid=" +userid + " and workflow_currentoperator.usertype="+usertype+" and workflow_requestbase.workflowid = workflow_base.id and workflow_base.isvalid=1 order by createdate desc , createtime desc) as s" ;
}


    //RecordSet.executeSql(sqlstr);
    //System.out.println("");
    //System.out.println("sqltemp = " + sqlstr);

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
}else{
	//sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+"  order by createdate , createtime ";
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+sqlstr+"  order by createdate , createtime ";
}
RecordSet.executeSql(sqltemp);

%>
<BODY style='overflow-x:hidden'>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>



<FORM NAME=SearchForm STYLE="margin-bottom:0" action="RequestBrowser.jsp" method=post>
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

  <table width=100% class="viewform">
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></TD>
      <TD width=35% class=field>
        <input name=requestname class=Inputstyle value="<%=requestname%>">
      </TD>
      <TD width=15%><%if(!user.getLogintype().equals("2")){%><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><%}%></TD>
      <TD width=35% class=field><%if(!user.getLogintype().equals("2")){%><BUTTON class=Browser type="button" id=SelectManagerID onClick="onShowManagerID(creater,createrspan)"></BUTTON><%}%>
	  <span id=createrspan><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></span>
              <INPUT class=Inputstyle id=creater type=hidden name=creater value="<%=creater%>"> </TD>
    </TR><TR style="height: 1px"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
      <TD width=35% class=field><BUTTON class=Calendar type="button" id=selectbirthday onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
  		  <SPAN id=createdatestartspan ><%=createdatestart%></SPAN>
  		  - &nbsp;<BUTTON class=Calendar type="button" id=selectbirthday1 onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
  		  <SPAN id=createdateendspan ><%=createdateend%></SPAN>
  		  <input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>">
  		  <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>"></TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></TD>
      <TD width=35% class=field><input name=requestmark class=Inputstyle value="<%=requestmark%>"></TD>
    </tr>

    </TR><TR style="height: 1px"><TD class=Line colSpan=4></TD></TR>
    <TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></TD>
	<TD width=35% class=Field>
		<button type="button" class=Browser onClick="onShowDepartment();"></button>
		<span id=departmentspan>
		<%
			String departments[] = Util.TokenizerString2(department,",");
			String departmentnames = "";
			for(int i=0;i<departments.length;i++){
				if(!departments[i].equals("")&&!departments[i].equals("0")){
					departmentnames += (!departmentnames.equals("")?",":"") + DepartmentComInfo.getDepartmentname(departments[i]);
				}
			}
			out.println(departmentnames);	
		%>
		</span>
		<input class=inputstyle id=department type=hidden name=department value="<%=department%>">
	</TD>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TD>
	<td width=35% class=field>
		
		<input class="wuiBrowser" _displayText="<%=ProjectInfoComInfo.getProjectInfoname(prjids)%>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" name=prjids type=hidden value="<%=prjids%>">
	</td>      
    </tr>

    </TR><TR style="height: 1px"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
	  <td class=field>
		<button type="button" class=browser onClick="onShowWorkFlow('workflowid','workflowspan')"></button>
		<span id=workflowspan name="workflowspan">
		<%=WorkflowComInfo.getWorkflowname(workflowid)%>
		</span>
		<input id="workflowid" name=workflowid type=hidden value="<%=workflowid%>">	
	  </td>
	  <td width=15%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
	  <td width=35% class=field>
		<input class="wuiBrowser" _displayText="<%=crmComInfo.getCustomerInfoname(crmids)%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" name=crmids type=hidden value="<%=crmids%>"></td>
    </tr>

	</TR><TR style="height: 1px"><TD class=Line colSpan=4></TD></TR>
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
        
    <TR class="Spacing" style="height: 1px">
      <TD class="Line1" colspan=4></TD>
    </TR>

  </table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"></TH>
	  <TH width=40%><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></TH>
	  <TH width=25%><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></TH>
      <TH width=35%><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH></tr>
	  <TR class=Line style="height: 1px"><Th colspan="4" ></Th></TR>
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
		<TD><%=_temp%></TD>
		<TD><%=creatername%>
		</TD>
		<TD><%=createdates%> <%=createtimes%></TD>
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

</TABLE>
  <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>">
  <input type="hidden" name="isrequest" value='<%=isrequest%>'>
  <input type="hidden" name="pagenum" value=''>



	   <%if(pagenum>1){%>

		<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",RequestBrowser.jsp?pagenum="+(pagenum-1)+"&crmids="+crmids+"&prjids="+prjids+"&status="+status+"&department="+department+"&workflowid="+workflowid+"&creater="+creater+"&requestname="+requestname+"&createdatestart="+createdatestart+"&createdateend="+createdateend+"&isrequest="+isrequest+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> <%}%>
	   <%if(hasNextPage){%>
		<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",RequestBrowser.jsp?pagenum="+(pagenum+1)+"&crmids="+crmids+"&prjids="+prjids+"&status="+status+"&department="+department+"&workflowid="+workflowid+"&creater="+creater+"&requestname="+requestname+"&createdatestart="+createdatestart+"&createdateend="+createdateend+"&isrequest="+isrequest+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%> <%}%>


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

</FORM>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser.js"></script>
<script type="text/javascript">

function onShowManagerID(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if (data.id!=""){
			spanname.innerHTML = "<A href='HrmResource.jsp?id="+data.id+"'>"+data.name+"</A>";
			inputname.value=data.id;
		}else{
			spanname.innerHTML = "";
			inputname.value="";
		}
	}
}

function onShowDepartment(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$G("department").value)    
    if (results) {
		if (results.id!="") {
		  $G("departmentspan").innerHTML =results.name.substr(1);
		  $G("department").value=results.id.substr(1);
		}else{
		  $G("departmentspan").innerHTML ="";
		  $G("department").value="";
		}
     }		
  }

jQuery(document).ready(function(){
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
		window.parent.close();
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

});

function submitClear()
{
	window.parent.returnValue = {id:"",name:"",fieldtype:"",options:""};
	window.parent.close()
}

</script>
</BODY></HTML>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
