<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.conn.RecordSet" %>

<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>

<%
int taskTempletId = Integer.parseInt(Util.null2String(request.getParameter("id")));
String loginType = ""+user.getLogintype();
/*权限－begin*/
boolean canMaint = false ;
if (HrmUserVarify.checkUserRight("ProjTemplet:Maintenance", user)) {       
  canMaint = true ;
}
/*权限－end*/
%>

<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav = "1";
String needhelp = "";
String sql = "";

String templetId = "";
String taskName = "";
String taskManager = "";
String taskBeginDate = "";
String taskEndDate = "";
String taskWorkDay = "";
String taskBudget = "";
String taskBefTaskID = "";
String taskDesc = "";

String sqlSelectTaskByID = "SELECT templetId,taskName,taskManager,beginDate,endDate,workDay,budget,parentTaskId,befTaskId,taskDesc FROM Prj_TemplateTask WHERE id="+taskTempletId;
RecordSet.executeSql(sqlSelectTaskByID);

if(RecordSet.next()){
	templetId = RecordSet.getString("templetId");
	taskName = RecordSet.getString("taskName");
	taskManager = RecordSet.getString("taskManager");
	taskBeginDate = RecordSet.getString("beginDate");
	taskEndDate = RecordSet.getString("endDate");
	taskWorkDay = RecordSet.getString("workDay");
	taskBudget = RecordSet.getString("budget");
	taskBefTaskID = RecordSet.getString("befTaskId");
	taskDesc = RecordSet.getString("taskDesc");
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    if (canMaint) {      
        RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='TempletTaskEdit.jsp?templetid="+templetId+"&id="+taskTempletId+"',_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='ProjTempletView.jsp?templetId="+templetId+"',_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
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



<!--TempletTaskForm Begin-->
<TABLE class=viewform>
<COLGROUP>
	<COL width="30%">
	<COL width="70%">
</COLGROUP>
<TBODY>
<TR>
	 <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
	 <TD class=Field><%=taskName%></TD>
</TR>
<TR  style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></TD>
	<TD class=Field>
		<%if(user.getLogintype().equals("1")){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=taskManager%>">
		<%}%>	
		<%=Util.toScreen(ResourceComInfo.getResourcename(taskManager),user.getLanguage())%>
		<%if(user.getLogintype().equals("1")){%></a><%}%>
	</TD>
</TR>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
	<TD class=Field><%=taskBeginDate%></TD>
</TR>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
	<TD class=Field><%=taskEndDate%></TD>
</TR>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
	<TD class=Field><%=taskWorkDay%></TD>
</TR>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<TR>
	<TD><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></TD>
	<TD class=Field><%=taskBudget%> </TD>
</TR>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<TR>
	<%
	String taskBefTaskName="";
	if(!taskBefTaskID.equals("")){
		String sql_1="SELECT taskName FROM Prj_TemplateTask WHERE id='"+taskBefTaskID+"'";
		RecordSet3.executeSql(sql_1);
		RecordSet3.next();
		taskBefTaskName +="<a href=/proj/Templet/TempletTaskView.jsp?id="+taskBefTaskID+">"+ RecordSet3.getString("taskName")+ "</a>" +" ";
	}
	%>
	<TD><%=SystemEnv.getHtmlLabelName(2233,user.getLanguage())%></TD>
	<TD class=Field><%=taskBefTaskName%></TD>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
<tr>
	<TD><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
	<TD class=Field><%=Util.toHtml(taskDesc)%></TD>
</TR>
<TR style="height:1px;">
	<td height="10" colspan="2" class="line"></td>
</TR>
</TBODY>
</TABLE>
<!--TempletTaskForm End-->

<!--RequiredDocs Begin-->
<%
sql="SELECT docMainCategory,docSubCategory,docSecCategory,isNecessary FROM Prj_TempletTask_needdoc WHERE templetTaskId="+taskTempletId;
RecordSet.executeSql(sql);
%>
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=2><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
	</TR>
   <TR class=Header>
      <th width="*"><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></th>
	   <th width="100" style="text-align:center"><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=3 style="padding:0;"></TD></TR>
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
      <td style="text-align:center"><input type="checkbox" <%if(isNecessary.equals("1")) out.println("checked");%> disabled></td>
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
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=3><%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
	</TR>
   <TR class=Header>
      <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
	   <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=3 style="padding:0;"></TD></TR>
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
      <TD></TD>
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
<TABLE class=liststyle cellspacing=1 >
<TBODY>
	<TR class=header>
		<TH colSpan=3><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
	</TR>
   <TR class=Header>
      <th width="*"><%=SystemEnv.getHtmlLabelName(17905,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
	   <th width="100" style="text-align:center"><%=SystemEnv.getHtmlLabelName(17906,user.getLanguage())%></th>
	</TR>
	<TR class=line><TD colSpan=3 style="padding:0;"></TD></TR>
<%
while(RecordSet.next()){
%>
	<tr class=datadark>
      <td><%=Util.toScreen(WorkflowComInfo.getWorkflowname(RecordSet.getString("workflowId")),user.getLanguage())%></td>
      <td style="text-align:center"><input type="checkbox" <%if(RecordSet.getString("isNecessary").equals("1")) out.println("checked");%> disabled></td>
   </tr>
<%}%>
</TBODY>
</TABLE>
<!--RequiredWorkflow End  -->




<script language=vbs>

sub onShowMDoc(spanname,inputename)
		tmpids = document.all(inputename).value
		id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="&tmpids)
         if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					docids = id1(0)
					docname = id1(1)
					sHtml = ""
					docids = Mid(docids,2,len(docids))
					document.all(inputename).value= docids
					docname = Mid(docname,2,len(docname))
					while InStr(docids,",") <> 0
						curid = Mid(docids,1,InStr(docids,",")-1)
						curname = Mid(docname,1,InStr(docname,",")-1)
						docids = Mid(docids,InStr(docids,",")+1,Len(docids))
						docname = Mid(docname,InStr(docname,",")+1,Len(docname))
						sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&curid&">"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href=/docs/docs/DocDsp.jsp?id="&docids&">"&docname&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

				else
					document.all(spanname).innerHtml =""
					document.all(inputename).value=""
				end if
        end if
end sub

sub onShowDoc()
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and id(0)<>"0" then
		window.location = "/proj/process/DocOperation.jsp?method=add&type=2&taskid=<%=taskTempletId%>&docid=" & id(0)
	end if
	end if
end sub

sub onShowRequest()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and id(0)<>"0" then
		window.location = "/proj/process/RequestOperation.jsp?method=add&type=2&taskid=<%=taskTempletId%>&requestid=" & id(0)
	end if
	end if
end sub

sub onShowCptRequest()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata=2")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and id(0)<>"0" then
		window.location = "/proj/process/CptOperation.jsp?method=add&type=2&taskid=<%=taskTempletId%>&requestid=" & id(0)
	end if
	end if
end sub
</script>

<script language=javascript>
function displaydiv_1()
{
    if(WorkFlowDiv.style.display == ""){
        WorkFlowDiv.style.display = "none";
        WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
    }
    else{
        WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></a>";
        WorkFlowDiv.style.display = "";
    }
}

function doDeletePlan(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.delplan.submit();
    }
}
</script>
</BODY>
</HTML>

