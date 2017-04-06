<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%

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
String formid=Util.null2String(request.getParameter("formid"));
int isbill=Util.getIntValue(request.getParameter("isbill"),0);
String department =Util.null2String(request.getParameter("department"));
String status = Util.null2String(request.getParameter("status"));
String ismode = Util.null2String(request.getParameter("ismode"));
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
		sqlwhere += " where t1.requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
}

if(!creater.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.creater =" + creater +" " ;
	}
	else
		sqlwhere += " and t1.creater =" + creater +" " ;
}

if(!createdatestart.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.createdate >='" + createdatestart +"' " ;
	}
	else
		sqlwhere += " and t1.createdate >='" + createdatestart +"' " ;
}

if(!createdateend.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.createdate <='" + createdateend +"' " ;
	}
	else
		sqlwhere += " and t1.createdate <='" + createdateend +"' " ;
}

if(status.equals("1")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.currentnodetype <> 3 " ;
	}
	else
		sqlwhere += " and t1.currentnodetype <> 3 " ;
}

if(status.equals("2")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.currentnodetype = 3 " ;
	}
	else
		sqlwhere += " and t1.currentnodetype = 3 " ;
}

if(!formid.equals("")&&!formid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.workflowid in (select id from workflow_base where isbill='"+isbill+"' and formid=" + formid +")";
	}
	else
		sqlwhere += " and t1.workflowid in (select id from workflow_base where isbill='"+isbill+"' and formid=" + formid +")";
}

if(!workflowid.equals("")&&!workflowid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.workflowid = " + workflowid ;
	}
	else
		sqlwhere += " and t1.workflowid = " + workflowid ;
}

if(!department.equals("")&&!department.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.creater in (select id from hrmresource where departmentid in ("+department+"))";
	}
	else
		sqlwhere += " and t1.creater in (select id from hrmresource where departmentid in ("+department+"))";
}

if(!prjids.equals("")&&!prjids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}
}

if(!crmids.equals("")&&!crmids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}
}

if(!requestmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.requestmark like '%" + requestmark +"%' " ;
	}
	else
		sqlwhere += " and t1.requestmark like '%" + requestmark +"%' " ;
}

if (sqlwhere.equals("")){
    sqlwhere = " where t1.requestid <> 0 and t2.requestid = t1.requestid and t2.userid=" +userid + " and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and isvalid=1)" ;
}else{
    sqlwhere += " and t2.requestid = t1.requestid and t2.userid=" +userid + " and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and isvalid=1) " ;
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//2012-08-09 ypc 修改 把javascript后面直接通过Form的name提交表单数据改为调用js函数提交
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:ResetForm(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>



<FORM name="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="RequestImport.jsp" method="post">
<input name=formid type=hidden value="<%=formid%>">
<input name=isbill type=hidden value="<%=isbill%>">
<input name=ismode type=hidden value="<%=ismode%>">
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
      <TD width=35% class=field><%if(!user.getLogintype().equals("2")){%><button type=button  class=Browser id=SelectManagerID onClick="onShowManagerID('creater', 'createrspan')"></BUTTON><%}%>
	  <span id=createrspan><%=Util.toScreen(ResourceComInfo.getResourcename(creater),user.getLanguage())%></span>
              <INPUT class=Inputstyle id=creater type=hidden name=creater value="<%=creater%>"> </TD>
    </TR><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></TD>
      <TD width=35% class=field><button type=button  class=Calendar id=selectbirthday onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
  		  <SPAN id=createdatestartspan ><%=createdatestart%></SPAN>
  		  - &nbsp;<button type=button  class=Calendar id=selectbirthday1 onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
  		  <SPAN id=createdateendspan ><%=createdateend%></SPAN>
  		  <input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>">
  		  <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>"></TD>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></TD>
      <TD width=35% class=field><input name=requestmark class=Inputstyle value="<%=requestmark%>"></TD>
    </tr>

    </TR><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <TR>
	<TD width=15%><%=SystemEnv.getHtmlLabelName(19225,user.getLanguage())%></TD>
	<TD width=35% class=Field>
		<button type=button  class=Browser onClick="onShowDepartment()"></button>
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
	<TD width=15%><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></TD>
	<td width=35% class=field>
		<button type=button  class=browser onClick="onShowPrjids()"></button>
		<span id=prjidsspan><%=ProjectInfoComInfo.getProjectInfoname(prjids)%></span>
		<input name=prjids type=hidden value="<%=prjids%>">
	</td>
    </tr>

    </TR><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TD>
	  <td class=field>
		<button type=button  class=browser onClick="onShowFlowID('workflowid', 'workflowspan')"></button>
		<span id=workflowspan>
		<%=WorkflowComInfo.getWorkflowname(workflowid)%>
		</span>
		<input id="workflowid" name=workflowid type=hidden value="<%=workflowid%>">
	  </td>
	  <td width=15%><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
	  <td width=35% class=field><button type=button  class=browser onClick="onShowCrmids()"></button>
		<span id=crmidsspan><%=crmComInfo.getCustomerInfoname(crmids)%></span>
		<input name=crmids type=hidden value="<%=crmids%>"></td>
    </tr>
    </TR><TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
	<TR>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></TD>
		<TD width=35% class=field>
			<select id=status name=status>
				<OPTION value=""></OPTION>
				<OPTION value="1" <%if(status.equals("1")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></OPTION>
				<OPTION value="2" <%if(status.equals("2")) out.println("selected");%>><%=SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></OPTION>
			</select>
		</TD>
	</tr>
    <TR class="Spacing" style="height:1px;">
      <TD class="Line1" colspan=4></TD>
    </TR>

  </table>
<%
String backfields = " t1.requestid,t1.requestname,t1.creater,t1.createdate,t1.createtime ";
String fromSql  = " workflow_requestbase t1, workFlow_CurrentOperator t2 ";
String tableString = "";
int perpage=10;
//System.out.println("select "+backfields+" from "+fromSql+sqlwhere+" order by t1.createdate,t1.createtime");
tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"radio\" pagesize=\""+perpage+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"t1.createdate,t1.createtime\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfOnlyViewLink\" otherpara=\"column:requestid\" />"+
                "           <col width=\"140\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"50\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
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
  <input type="hidden" name="sqlwhere" value="<%=sqlwhere%>">
  <input type="hidden" name="isrequest" value="<%=isrequest%>">



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

</BODY></HTML>

<script type="text/javascript" src="/js/browser/WorkFlowBrowser.js"></script>
<script type="text/javascript">
<!--2012-08-09 ypc 修改 把javascript后面直接通过Form的name提交表单数据改为调用js函数提交-->
function SearchForm(){
	document.getElementById("SearchForm").submit();
}
function ResetForm(){
	document.getElementById("SearchForm").reset();
	//document.SearchForm.reset();
}
function onShowFlowID(inputname,spanname) {
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill='<%=isbill%>' and formid=<%=formid%>")
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G(spanname).innerHTML = rname;
			$G(inputname).value = rid;
		} else {
			$G(spanname).innerHTML = "";
			$G(inputname).value = "";
		}
	}
}

function onShowManagerID(inputname,spanname) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G(spanname).innerHTML = "<A href='HrmResource.jsp?id=" + rid + "'>" + rname + "</A>";
			$G(inputname).value = rid;
		} else {
			$G(spanname).innerHTML = "";
			$G(inputname).value = "";
		}
	}
}

function onShowCrmids() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G("crmidsspan").innerHTML = rname;
			$G("crmids").value = rid;
		} else {
			$G("crmidsspan").innerHTML = "";
			$G("crmids").value = "";
		}
	}
}

function onShowPrjids() {
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G("prjidsspan").innerHTML = rname;
			$G("prjids").value = rid;
		} else {
			$G("prjidsspan").innerHTML = "";
			$G("prjids").value = "";
		}
	}
}

function onShowDepartment() {
	//出现空值导致脚本错误
	//把SearchForm.deparament.value 改成 document.getElementById().deparament.value 才能得到值
	//2012-08-10 ypc 修改
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + document.getElementById("SearchForm").department.value)
	
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			$G("departmentspan").innerHTML = rname.substr(1);
			$G("department").value = rid.substr(1);
		} else {
			$G("departmentspan").innerHTML = "";
			$G("department").value = "";
		}
	}
}

</script>

<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText)
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText)
      window.parent.Close
   End If
End Sub

sub onShowFlowID(inputname,spanname)
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill='<%=isbill%>' and formid=<%=formid%>")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			spanname.innerHtml = id(1)
			inputname.value=id(0)
		else
				spanname.innerHtml = ""
				inputname.value=""
		end if
	end if
end sub

sub onShowManagerID(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowCrmids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		crmidsspan.innerHtml = id(1)
		SearchForm.crmids.value=id(0)
		else
		crmidsspan.innerHtml = ""
		SearchForm.crmids.value=""
		end if
	end if
end sub

sub onShowPrjids()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> "" then
		prjidsspan.innerHtml = id(1)
		SearchForm.prjids.value=id(0)
		else
		prjidsspan.innerHtml = ""
		SearchForm.prjids.value=""
		end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="&SearchForm.department.value)
    if Not isempty(id) then
	if id(0)<> "" then
	departmentspan.innerHtml = Mid(id(1),2)
	SearchForm.department.value=Mid(id(0),2)
	else
	departmentspan.innerHtml = ""
	SearchForm.department.value=""
	end if
	end if
end sub
</SCRIPT>
 -->
 <script language="javascript">
function submitData() {
    if(_xtable_CheckedRadioId()=="") {
		alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
	} else {
        if(confirm("<%=SystemEnv.getHtmlLabelName(24274,user.getLanguage())%>")){
	        var win = window.dialogArguments;
	        if(win != null){
	            win.doImport(_xtable_CheckedRadioId());            
	        }else{
	            top.opener.window.doImport(_xtable_CheckedRadioId());
	        }
	        window.parent.close();
        }
    }
}


</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
