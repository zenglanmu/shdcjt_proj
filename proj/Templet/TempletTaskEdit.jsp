<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<%
int ProjID = Integer.parseInt(Util.null2String(request.getParameter("templetid")));
int taskTempletId = Integer.parseInt(Util.null2String(request.getParameter("id")));
String loginType = ""+user.getLogintype();
/*È¨ÏÞ£­begin*/
boolean canview = true;
if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*È¨ÏÞ£­end*/
%>

<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav = "1";
String needhelp = "";
String sql = "";

String taskName = "";
String taskManager = "";
String taskBeginDate = "";
String taskEndDate = "";
String taskWorkDay = "";
String taskBudget = "";
String taskBefTaskID = "";
String taskDesc = "";

String sqlSelectTaskByID = "SELECT taskName,taskManager,beginDate,endDate,workDay,budget,parentTaskId,befTaskId,taskDesc FROM Prj_TemplateTask WHERE id="+taskTempletId;
RecordSet.executeSql(sqlSelectTaskByID);

if(RecordSet.next()){
	taskName = RecordSet.getString("taskName");
	taskManager = RecordSet.getString("taskManager");
	taskBeginDate = RecordSet.getString("beginDate");
	taskEndDate = RecordSet.getString("endDate");
	taskWorkDay = RecordSet.getString("workDay");
	taskBudget = RecordSet.getString("budget");
	taskBefTaskID = RecordSet.getString("befTaskId");
	taskDesc = RecordSet.getString("taskDesc");
}

String beforeTaskName = "";
if(!taskBefTaskID.equals("0")){
    ArrayList taskBefTaskIDs = Util.TokenizerString(taskBefTaskID,",");
    int taskidnum = taskBefTaskIDs.size();
    for(int j=0;j<taskidnum;j++){
		 String sql_1="SELECT taskName FROM Prj_TemplateTask WHERE id="+taskBefTaskIDs.get(j);
		 RecordSet2.executeSql(sql_1);
		 RecordSet2.next();
		 beforeTaskName +="<a href=/proj/Templet/TempletTaskView.jsp?id="+taskBefTaskIDs.get(j)+">"+ RecordSet2.getString("taskName")+ "</a>" +" ";
    }
}

%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/Templet/TempletTaskView.jsp?id="+taskTempletId+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<form name="weaver" id="weaver" action="TempletTaskOperation.jsp" method="post">
<input type="hidden" name="method" value="edit">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="taskTempletID" value="<%=taskTempletId%>">
<table class="viewform">
<tr>
<td width="50%">
	<!--TempletTaskForm Begin-->
	<TABLE class=viewform>
	<COLGROUP>
		<COL width="30%">
		<COL width="70%">
	</COLGROUP>
	<TBODY>
	<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
		 <TD class=Field>
			<INPUT class=inputstyle maxLength=80 size=40 name="subject" onChange="checkinput('subject','subjectspan')" value="<%=taskName%>">
			<span id=subjectspan></span>
		</TD>
	</TR>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
		<TD class=Field>
         <INPUT class="wuiBrowser" type=hidden name="hrmid" value="<%=taskManager%>"
         	_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(taskManager),user.getLanguage())%>"
         	_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
         	_url="/systeminfo/BrowserMain.jsp?url=/proj/Templet/ResourceBrowser_proj.jsp?ProjID=<%=ProjID%>">
		</TD>
	</TR>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
		<TD class=Field>
			<button type="button" class=Calendar onclick="gettheProjBDate()"></BUTTON>
         <SPAN id=begindatespan><%=taskBeginDate%></SPAN>
         <input type="hidden" name="begindate" id="begindate" value="<%=taskBeginDate%>">
		</TD>
	</TR>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
		<TD class=Field>
			<button type="button" class=Calendar onclick="gettheProjEDate()"></BUTTON>
         <SPAN id=enddatespan><%=taskEndDate%></SPAN>
         <input type="hidden" name="enddate" id="enddate" value="<%=taskEndDate%>">
		</TD>
	</TR>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
		<TD class=Field>
			<INPUT class=inputstyle maxLength=5 size=5 name="workday" value="<%=taskWorkDay%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("workday")'><SPAN id=workdayimage></SPAN>
		</TD>
	</TR>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
		<TD class=Field>
			<INPUT class=inputstyle maxLength=20 size=20 name="fixedcost" value="<%=taskBudget%>" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fixedcost")'>
		</TD>
	</TR>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
		<TD class=Field>
			<button type="button" class=Browser onclick="onShowMTask('taskids02span','taskids02','ProjID','taskTempletID')"></button>
			<input type=hidden name="taskids02" value="<%=taskBefTaskID%>">
			<span id="taskids02span"><%=beforeTaskName%></span>
		</TD>
	<TR style="height:1px;">
		<td height="10" colspan="2" class="line"></td>
	</TR>
	<tr>
		<TD></TD>
		<TD class=Field></TD>
	</TR>
	</TBODY>
	</TABLE>
</td>
<td width="50%" valign="top">
	<TABLE class=viewform>
   <TR>
		<TD><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
	</TR>
	<TR>
      <TD class=Field><TEXTAREA class=inputstyle name="content" ROWS=8 STYLE="width:100%"><%=Util.toHtml(taskDesc)%></TEXTAREA></TD>
   </TR>
   </TABLE>
</td>
</tr>
</table>
<!--TempletTaskForm End-->

<!--RequiredDocs Begin-->
<%
sql="SELECT docMainCategory,docSubCategory,docSecCategory,isNecessary FROM Prj_TempletTask_needdoc WHERE templetTaskId="+taskTempletId;
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 id="tblRequiredDoc">
<TBODY>
	<TR class=header>
		<TH colspan="2"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
		<th style="width:100px"><a href="javascript:void(0)" onClick="onSelectCategory()">Ìí¼Ó</a></th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=3 style="padding:0px;"></TD></TR>
<%
String docMainCategory="";
String docSubCategory="";
String docSecCategory = "";
String isNecessary = "";
while(RecordSet.next()){
	docMainCategory = RecordSet.getString("docMainCategory");
	docSubCategory = RecordSet.getString("docSubCategory");
	docSecCategory = RecordSet.getString("docSecCategory");
	isNecessary = RecordSet.getString("isNecessary");
%>
	<tr class=datadark>
      <td>
			<%=Util.toScreen(MainCategoryComInfo.getMainCategoryname(docMainCategory),user.getLanguage())%>/<%=Util.toScreen(SubCategoryComInfo.getSubCategoryname(docSubCategory),user.getLanguage())%>/<%=Util.toScreen(SecCategoryComInfo.getSecCategoryname(docSecCategory),user.getLanguage())%>
		</td>
      <td style="text-align:center;width:80px"><input type="checkbox" name="necessary<%=docSecCategory%>" value="1" <%if(isNecessary.equals("1")) out.println("checked");%>></td>
		<td>
			<a href='javascript:void(0)' onclick='deleteRequiredDocRow()'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><input type='checkbox' name='requireddocs_mainid' value='<%=docMainCategory%>' style='visibility:hidden' checked><input type='checkbox' name='requireddocs_subid' value='<%=docSubCategory%>' style='visibility:hidden' checked><input type='checkbox' name='requireddocs_secid' value='<%=docSecCategory%>' style='visibility:hidden' checked>
		</td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredDocs End  -->


<!--RefrenceDocs Begin-->
<%
sql="SELECT a.id, a.docsubject, a.ownerid, a.usertype, a.doccreatedate, a.doccreatetime FROM DocDetail a, Prj_TempletTask_referdoc b WHERE b.templetTaskId="+taskTempletId+" AND a.id=b.docid";
//out.println(sql);
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 id="tblRefDoc">
<TBODY>
	<TR class=header>
		<TH colSpan=3><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
		<th style="width:100px"><a href="javascript:void(0)" onclick="onShowMultiDocsRow('tblRefDoc')">Ìí¼Ó</a></th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=4 style="padding:0px;"></TD></TR>
<%
int docid = 0;
String docCreateDate="";
String docName="";
String ownerType = "";
String ownerID = "";
while(RecordSet.next()){
	docid = RecordSet.getInt("id");
	docCreateDate = RecordSet.getString("doccreatedate");
	docName = RecordSet.getString("docsubject");
	ownerType = RecordSet.getString("usertype");
	ownerID = RecordSet.getString("ownerid");
%>
	<tr class=datadark>
      <td><%=Util.toScreen(docCreateDate,user.getLanguage())%></td>
      <td>
			<%if(ownerType.equals("1")){%>
				<a href="/hrm/resource/HrmResource.jsp?id=<%=ownerID%>"><%=Util.toScreen(ResourceComInfo.getResourcename(ownerID),user.getLanguage())%></a>
			<%}else if(ownerType.equals("2")){%>
				<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=ownerID%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(ownerID),user.getLanguage())%></a>
			<%}%>
		</td>
      <td><a href="/docs/docs/DocDsp.jsp?id=<%=docid%>"><%=Util.toScreen(docName,user.getLanguage())%></a></td>
		<td>
			<a href='javascript:void(0)' onclick='deleteReferDocRow()'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
			<input type='checkbox' name='referdocs' value='<%=docid%>' style='visibility:hidden' checked>
		</td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RefrenceDocs End  -->

<!--RequiredWorkflow Begin-->
<%
sql="SELECT workflowId,isNecessary FROM Prj_TempletTask_needwf WHERE templetTaskId="+taskTempletId;
//out.println(sql);
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 id="tblRequiredWF">
<TBODY>
	<TR class=header>
		<TH colspan="2"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
		<th style="width:100px"><a href="javascript:onShowWorkflow()" onclick="">Ìí¼Ó</a></th>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=3 style="padding:0px;"></TD></TR>
<%
while(RecordSet.next()){
%>
	<tr class=datadark>
      <td><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString("workflowId")),user.getLanguage())%></td>
      <td style="text-align:center;width:80px"><input type="checkbox" name='necessaryWF<%=RecordSet.getString("workflowId")%>' value='<%=RecordSet.getString("workflowId")%>' <%if(RecordSet.getString("isNecessary").equals("1")) out.println("checked");%>></td>
		<td><a href='javascript:void(0)' onclick='delRequiredWF()'>É¾³ý</a><input type='checkbox' name='requiredWFIDs' id="requiredWFIDs" value='<%=RecordSet.getString("workflowId")%>' style='visibility:hidden' checked></td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredWorkflow End  -->
</form>






<script language=javascript>


function onShowMTask(spanname,inputename,prj,task){
	ProjID = $("input[name="+prj+"]").val();
   taskrecordid = $("input[name="+task+"]").val();
	taskids = $("input[name="+inputename+"]").val();
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/Templet/SingleTaskBrowser.jsp?taskids="+taskids+"&ProjID="+ProjID+"&taskrecordid="+taskrecordid);
        if (datas){
				if (datas.id){
					task_ids = datas.id.split(",");
					taskname = datas.name.split(",");
					sHtml = "";
					for(var i=0;i<task_ids.length;i++){
						if(task_ids[i]){
							sHtml+="<a href=/proj/templet/TempletTaskView.jsp?id="+task_ids[i]+">"+taskname[i]+"</a>&nbsp";
						}
					}
					$("#"+spanname).html(sHtml);
					$("input[name="+inputename+"]").val(datas.id.substr(1));
				}else{
					$("#"+spanname).html("");
					$("input[name="+inputename+"]").val("");
				}
        }
}


function onShowMultiDocsRow(tblID){
	var oTbl = document.getElementById(tblID);
	var refdocs = document.getElementsByName("referdocs");
	var tmpIds="";
	if (refdocs.length!=0 ){
		for(var i=0 ;i< refdocs.length;i++){
			tmpIds = tmpIds + refdocs[i].value + ","
		}
		tmpIds = tmpIds.substr(0,(tmpIds.length)-1)
	}

	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser_proj.jsp?documentids="+tmpIds)
	if (datas){
		if (datas.id!=""){
			docids = datas.id.split(",");
			docnames = datas.name.split(",");
			owners = datas.owner.split(",");
			doccreatedates = datas.doccreatedates.split(",");
			for(var i=0;i<docids.length;i++){
				if(docids!=""&&tmpIds.indexOf(docids[i])<0){
					var row = oTbl.insertRow(oTbl.rows.length);
					row.className =  "DataDark";
					var col = row.insertCell(0);
					col.innerHTML = doccreatedates[i];
					var col = row.insertCell(1);
					col.innerHTML = owners[i];
					var col = row.insertCell(2);
					col.innerHTML = "<a href='/docs/docs/DocDsp.jsp?id="+docids[i]+"'>"+docnames[i]+"</a>";
					var col = row.insertCell(3);
					col.innerHTML = "<a href='javascript:void(0)' onclick='deleteReferDocRow()'>É¾³ý</a><input type='checkbox' name='referdocs' value='"+docids[i]+"' style='visibility:hidden' checked>";
				}
			}
		}
	}
}


function onShowWorkflow(){
	var wfIDs = document.getElementsByName("requiredWFIDs");
	var tmpIds="";
	if(wfIDs.length!=0){
		for( var i=0 ;i<=wfIDs.length-1;i++){
			tmpIds = tmpIds + wfIDs[i].value + ",";
		}
		tmpIds = tmpIds.substr(0,tmpIds.length-1);
	}
	
	tmpIds2 = "," + tmpIds + ","
	
	var oTbl = document.getElementById("tblRequiredWF");
	var rows = oTbl.rows;
	
	datas = window.showModalDialog("/workflow/WFBrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpIds)
	if (datas){
		docids = datas.id;
		docnames = datas.name;
				
		arrWFID = docids.split(",");
		arrWFName = docnames.split(",");
		for(var i=0;i<arrWFID.length;i++){
			if(arrWFID[i]){
				var row = oTbl.insertRow(rows.length)
				row.className =  "DataDark";
				var cell = row.insertCell(0);
				cell.innerHTML = arrWFName[i];
				var cell = row.insertCell(1);
				cell.style.textAlign = "center";
				cell.innerHTML = "<input type='checkbox' name='necessaryWF"+arrWFID[i]+"' value='"+arrWFID[i]+"'>";
				var cell = row.insertCell(2);
				cell.innerHTML = "<a href='javascript:void(0)' onclick='delRequiredWF()'>É¾³ý</a><input type='checkbox' name='requiredWFIDs' id='requiredWFIDs' value='"+arrWFID[i]+"' style='visibility:hidden' checked>";
			}
		}		
		
	}
}

function submitData(){
	weaver.submit();
}


function msg(){
	o = document.getElementsByName("referdocs");
	var para = "";
	if(o!=null){
		for(j=0;j<o.length;j++){
			para += o(j).value + ",";
		}
	}
	alert(para);
}

function delRequiredWF(){
	
	var obj = $.event.fix(getEvent()).target;
	while(obj.tagName!="TR")	obj = obj.parentNode;
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.getElementById("tblRequiredWF").deleteRow(obj.rowIndex);
	}
}


function deleteReferDocRow(){
	var oTbl = document.getElementById("tblRefDoc");
	el = $.event.fix(getEvent()).target;
	if(el==null) return false;
	while(el.tagName!="TR"){
		el = el.parentElement;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		oTbl.deleteRow(el.rowIndex);
	}
}


function deleteRequiredDocRow(){
	var oTbl = document.getElementById("tblRequiredDoc");
	el = $.event.fix(getEvent()).target;
	if(el==null) return false;
	while(el.tagName!="TR"){
		el = el.parentElement;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		oTbl.deleteRow(el.rowIndex);
	}
}


function onShowMultiDocsRows(tblID){
}


function onSelectCategory() {
	var oTbl = document.getElementById("tblRequiredDoc");
	/* returnValue = Array(1, id, path, mainid, subid); */
   var datas = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/CategoryBrowser.jsp");
	if (datas) {
	   if (datas.id!=""&&datas.id>0)  {
	        //location = "TempletTaskOperation.jsp?method=addneeddoc&taskTempletID=<%=taskTempletId%>&secid="+result[1];
			row = oTbl.insertRow(oTbl.rows.length);
			row.className =  "DataDark";
			col = row.insertCell(0);
			col.innerHTML = datas.path;
			col = row.insertCell(1);
			col.style.textAlign = "center";
			col.innerHTML = "<input type='checkbox' name='necessary"+datas.id+"' value='1'>";
			col = row.insertCell(2);
			col.innerHTML = "<a href='javascript:void(0)' onclick='deleteRequiredDocRow()'>É¾³ý</a><input type='checkbox' name='requireddocs_mainid' value='"+datas.mainid+"' style='visibility:hidden' checked><input type='checkbox' name='requireddocs_subid' value='"+datas.subid+"' style='visibility:hidden' checked><input type='checkbox' name='requireddocs_secid' value='"+datas.id+"' style='visibility:hidden' checked>"
    	}
	}
}
</script>
</BODY>
<SCRIPT language="javascript"  src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>