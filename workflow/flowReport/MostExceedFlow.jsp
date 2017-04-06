<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.Util,java.util.*,java.math.*"%>
<%@ include file="/systeminfo/init.jsp"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="MostExceedFlow" class="weaver.workflow.report.MostExceedFlow" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY>
<%
	String imagefilename = "/images/hdReport.gif";
	String titlename = SystemEnv.getHtmlLabelName(19036, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	String userRights = shareRights.getUserRights("-9", user);//得到用户查看范围
	if (userRights.equals("-100")) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String typeId = Util.null2String(request.getParameter("typeId"));//得到搜索条件
	String flowId = Util.null2String(request.getParameter("flowId"));//得到搜索条件

	String fromcredate = Util.null2String(request.getParameter("fromcredate"));//得到创建时间搜索条件
	String tocredate = Util.null2String(request.getParameter("tocredate"));//得到创建时间搜索条件
	String objStatueType = Util.null2String(request.getParameter("objStatueType"));//得到流程状态搜索条件
	int objType1 = Util.getIntValue(request.getParameter("objType"), 0);//得到创建时间搜索条件
	String rhobjNames = Util.null2String(request.getParameter("rhobjNames"));
	String rhobjId = Util.null2String(request.getParameter("rhobjId"));
	
	session.setAttribute("flowReport_flowId",flowId);
    session.setAttribute("flowReport_userRights",userRights);

	String objIds = Util.null2String(request.getParameter("objId"));
	String objNames = Util.null2String(request.getParameter("objNames"));
	String sqlCondition = "";

	if (objType1 != 0 && !"".equals(rhobjId)) {
		switch (objType1) {
		case 1:
			sqlCondition = " and userid in (select id from hrmresource where id in (" + rhobjId + ") )";
			break;
		case 2:
			sqlCondition = " and userid in (select id from hrmresource where departmentid in (" + rhobjId + ") )";
			break;
		case 3:
			sqlCondition = " and userid in (select id from hrmresource where subcompanyid1 in (" + rhobjId + ") )";
			break;
		}
	}
	if (!"".equals(fromcredate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and createdate >='" + fromcredate + "')";
	}
	if (!"".equals(tocredate)) {
		sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and createdate <='" + tocredate + "')";
	}
	if (!"".equals(objStatueType)) {
		if ("1".equals(objStatueType)) {
			sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and currentnodetype = '3')";
		} else {
			sqlCondition += " and exists (select 1 from workflow_requestbase where requestid=t1.requestid and currentnodetype <>'3') ";
		}
	}

	if (!typeId.equals("")) sqlCondition += " and workflowtype=" + typeId + " ";
	if (!flowId.equals("")) sqlCondition += " and workflowid=" + flowId + " ";
	if (!objIds.equals("")) sqlCondition += " and requestid in (" + objIds + ")  ";

	List sortsExceed = new ArrayList();
	ArrayList requestnamelist = new ArrayList();
	ArrayList workflowlist = new ArrayList();
	ArrayList overtimelist = new ArrayList();
   
    if(!"".equals(sqlCondition)) {
		sortsExceed = MostExceedFlow.getMostExceedSort(sqlCondition);
		if(sortsExceed.size() > 0) {
		   requestnamelist = (ArrayList)sortsExceed.get(0);
		   workflowlist = (ArrayList)sortsExceed.get(1);
		   overtimelist = (ArrayList)sortsExceed.get(2);
		}
	}
%>
<%@ include file="/systeminfo/TopTitle.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())+ ",javascript:submitData(this),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp"%>
<table width=100% height=100% border="0" cellspacing="0"
	cellpadding="0">
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
						<FORM id=frmMain name=frmMain action=MostExceedFlow.jsp
							method=post>
							<!--查询条件-->
							<input type="hidden" name="pagenum" value=''>
							<table class="viewform">
								<tr>
									<td width="10%">
										<%=SystemEnv.getHtmlLabelName(15433, user.getLanguage())%>
									</td>
									<td class=field width="30%">												
										<BUTTON type="button" class=Browser onClick="onShow('typeId','typeName')"
											name=showrequest></BUTTON>
										<SPAN id=typeName> <%=WorkTypeComInfo.getWorkTypename("" + typeId)%>
										</SPAN>
										<input type=hidden name="typeId" id="typeId" value="<%=typeId%>">
										<SPAN id=nameimage>
										  <%if(typeId.equals("")) {%>
										    <IMG src='/images/BacoError.gif' align=absMiddle></IMG>
										  <%}%>
										</span>
									</td>

									<td width="10%">
										<%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%>
									</td>
									<td class=field width="30%">
										<BUTTON type="button" class=Browser onClick="onShow2('flowId','flowName')"
											name=showflow></BUTTON>
										<SPAN id=flowName> <%=WorkflowComInfo.getWorkflowname("" + flowId)%>
										</SPAN>
										<input type=hidden name="flowId" id="flowId"value="<%=flowId%>">										<SPAN id=nameimage1><%if(flowId.equals("")) {%>
										  <IMG src='/images/BacoError.gif' align=absMiddle></IMG>
										<%}%></span>		
									</td>
								</tr>
								<TR class=Separartor style="height: 1px">
									<TD class="Line" COLSPAN=6></TD>
								</TR>
								<tr>
									<td width="10%">
										<%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%>
									</td>
									<td width="30%" class=field>
										<BUTTON type="button" class=Browser onClick="onShowRequest('objId','objName')" name=showrequest></BUTTON>
										<SPAN id=objName> <%=objNames%> </SPAN>
										<input type=hidden name="objId" id="objId" value="<%=objIds%>">
										<input type=hidden name="objNames" id="objNames" value="<%=objNames%>">
									</td>
									<td width="10%">
										<%=SystemEnv.getHtmlLabelName(1339, user.getLanguage())%>
									</td>
									<td class=field width="20%">
										<BUTTON type="button" class=calendar id=SelectDate1 onclick=getDate(fromcredatespan,fromcredate)></BUTTON>
										<SPAN id=fromcredatespan><%=fromcredate%>
										</SPAN> &nbsp;- &nbsp;
										<BUTTON type="button" class=calendar id=SelectDate2 onclick=getDate(tocredatespan,tocredate)></BUTTON>
										<SPAN id=tocredatespan><%=tocredate%>
										</SPAN>
										<input type="hidden" name="fromcredate" value="<%=fromcredate%>">
										<input type="hidden" name="tocredate" value="<%=tocredate%>">
									</td>
									</td>
								</tr>
								<TR class=Separartor  style="height: 1px">
									<TD class="Line" COLSPAN=6></TD>
								</TR>
								<tr>
									<td width="10%">
										<select class=inputstyle name=objType
											onchange="onChangeType()">
											<option value="1" <%if (objType1==1) {%> selected <%}%>>
												<%=SystemEnv.getHtmlLabelName(1867, user.getLanguage())%>
											</option>
											<option value="2" <%if (objType1==2) {%> selected <%}%>>
												<%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%>
											</option>
											<option value="3" <%if (objType1==3) {%> selected <%}%>>
												<%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%>
											</option>
										</select>
									</td>
									<td class=field width="20%">
										<BUTTON type="button" class=Browser <%if (objType1==2||objType1==3) {%> style="display:none" <%}%>
											onClick="onShowResource('rhobjId','rhobjName')"
											name=showresource></BUTTON>
										<BUTTON type="button" class=Browser <%if (objType1==0||objType1==1||objType1==3) {%> style="display:none" <%}%>
											onClick="onShowDepartment('rhobjId','rhobjName')"
											name=showdepartment></BUTTON>
										<BUTTON type="button" class=Browser <%if (objType1==0||objType1==1||objType1==2) {%> style="display:none" <%}%>
											onclick="onShowBranch('rhobjId','rhobjName')"
											name=showBranch></BUTTON>
										<SPAN id=rhobjName><%=rhobjNames%>
										</SPAN>
										<input type=hidden name="rhobjId" id="rhobjId" value="<%=rhobjId%>">
										<input type=hidden name="rhobjNames" id="rhobjNames" value="<%=rhobjNames%>">
									</td>
									<td width="10%">
										<%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%>
									</td>
									<td class=field width="20%">
										<select class=inputstyle name=objStatueType>
											<option value=""></option>
											<option value="1" <%if("1".equals(objStatueType)){%> selected <%}%>>
												<%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%>
											</option>
											<option value="2" <%if("2".equals(objStatueType)){%> selected <%}%>>
												<%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%>
											</option>
										</select>
									</td>
								</tr>
								<TR class=Separartor style="height: 1px">
									<TD class="Line" COLSPAN=6></TD>
								</TR>
							</table>

							<TABLE class=ListStyle cellspacing=1>
								<!--详细内容在此-->
								<COLGROUP>
									<col width="5%">
									<col width="30%">
									<col width="10%">
									<col width="10%">
									<col width="10%">
								<tr class=header>
									<TD>
										<%=SystemEnv.getHtmlLabelName(19082, user.getLanguage())%>
									</Td>
									<!-- 排名-->
									<TD>
										<%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%>
									</TD>
									<!--具体流程-->
									<TD>
										<%=SystemEnv.getHtmlLabelName(259, user.getLanguage())%>
									</TD>
									<!--工作流-->
									<TD>
										<%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%>
									</TD>
									<!-- 流程类型-->
									<TD>
										<%=SystemEnv.getHtmlLabelName(1982, user.getLanguage())%>
									</TD>
									<!--超期-->
								</tr>									
								<%
								boolean isLight = false;
								int i = 1;
								for (int j=0;j<overtimelist.size();j++) {
									String theworkflowid = (String)workflowlist.get(j);
									String requestName = (String)requestnamelist.get(j);
									String spends = (String)overtimelist.get(j);
									if (WorkflowComInfo.getIsValid(theworkflowid).equals("1")) {
										isLight = !isLight;
										String typeName = WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(theworkflowid));
										String flowName = WorkflowComInfo.getWorkflowname(theworkflowid);
								%>
								<tr class='<%=(isLight ? "datalight" : "datadark")%>'>
									<td>
										<%=i%>
									</td>
									<td>
										<%=requestName%>
									</td>
									<td>
										<%=typeName%>
									</td>
									<td>
										<%=flowName%>
									</td>
									<td>
										<%=spends%>
									</td>
								</tr>
								<TR class=Line style="height: 1px">
									<TD colspan="5"></TD>
								</TR>
								<%
									i++;
									}
								}
								%>
							</TABLE>
							<!--详细内容结束-->
					</td>
				</tr>
			</TABLE>
			</FORM>
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</table>
<script>
function chageFlowType(eventobj,list_obj,target_obj){
	var oOption ;
	var tempstr = eventobj.value +"$";
	target_obj.options.length = 0 ;
	
	oOption = document.createElement("OPTION");
	oOption.text = "";
	oOption.value = "";
	target_obj.options.add(oOption);
	
	if (eventobj.value.length > 0) {
		for (var i=0; i< list_obj.options.length; i++) {
			if (list_obj.options(i).value.indexOf(tempstr)>=0) {
				oOption = document.createElement("OPTION");
				oOption.text=list_obj.options(i).text;
				oOption.value=list_obj.options(i).value.substr(list_obj.options(i).value.indexOf('$')+1,list_obj.options(i).value.length) ;
				target_obj.options.add(oOption);
			}
		}
    }
}
 
function onChangeType(){
	thisvalue=document.frmMain.objType.value;
	$GetEle("rhobjId").value="";
	$GetEle("rhobjName").innerHTML ="";
	if(thisvalue==3){
 		$GetEle("showBranch").style.display='';
	}
	else{
		$GetEle("showBranch").style.display='none';
	}
	if(thisvalue==2){
 		$GetEle("showdepartment").style.display='';		
	}
	else{
		$GetEle("showdepartment").style.display='none';
	}
	if(thisvalue==1){
 		$GetEle("showresource").style.display='';		
	}
	else{
		$GetEle("showresource").style.display='none';
		
    }	
}     

function submitData(obj) {
   if (check_form(frmMain,'typeId,flowId')){
        obj.disabled = true;
		frmMain.submit();
   }
}


function onShowDepartment(inputename, showname) {
	tmpids = $GetEle(inputename).value;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser1.jsp?selectedids=" + $GetEle(inputename).value + "+selectedDepartmentIds=" + tmpids);
	if (data) {
		if (data.id != "") {
			resourceids = data.id;
			resourcename = data.name;
			var sHtml = "";
			resourceids = resourceids.substring(1);
			$GetEle(inputename).value = resourceids;
			resourcename = resourcename.substring(1);
			ids = resourceids.split(",");
			names = resourcename.split(",");
			for(var i=0;i<ids.length;i++){
				if(ids[i]!="0"){
					sHtml = sHtml + "<a href=/hrm/company/HrmDepartmentDsp.jsp?id=" + ids[i] + ">" + names[i] + "</a>&nbsp;";
				}
			}
			$GetEle(showname).innerHTML = sHtml;
			$GetEle("rhobjNames").value = sHtml;
		} else {
			$GetEle(showname).innerHTML = "";
			$GetEle(inputename).value = "";
			$GetEle("rhobjNames").value = "";
		}
	}
}

function onShowResource(inputename, showname) {
	tmpids = $GetEle(inputename).value;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" + tmpids);
	if (data) {
		if (data.id != "") {
			resourceids = data.id;
			resourcename = data.name;
			var sHtml = "";
			resourceids = resourceids.substring(1);
			$GetEle(inputename).value = resourceids;
			resourcename = resourcename.substring(1);
			ids = resourceids.split(",");
			names = resourcename.split(",");
			for(var i=0;i<ids.length;i++){
				if(ids[i]!="0"){
					sHtml = sHtml + "<a href=javaScript:openhrm("+ ids[i] +  "); onclick='pointerXY(event);'>" + names[i] + "</a>&nbsp;";
				}
			}
			$GetEle(showname).innerHTML = sHtml;
			$GetEle("rhobjNames").value = sHtml;
		} else {
			$GetEle(inputename).value = "";
			$GetEle(showname).innerHTML = "";
			$GetEle("rhobjNames").value = "";
		}
	}
}

function onShowBranch(inputename, showname) {
	tmpids = $GetEle(inputename).value;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + $GetEle(inputename).value + "+selectedDepartmentIds=" + tmpids);
	if (data) {
		if (data.id != "") {
			resourceids = data.id;
			resourcename = data.name;
			var sHtml = "";
			resourceids = resourceids.substring(1);
			$GetEle(inputename).value = resourceids;
			resourcename = resourcename.substring(1);
			ids = resourceids.split(",");
			names = resourcename.split(",");
			for(var i=0;i<ids.length;i++){
				if(ids[i]!="0"){
					sHtml = sHtml + "<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="+ ids[i] +   ">"+ names[i] + "</a>&nbsp;";
				}
			}
			$GetEle(showname).innerHTML = sHtml;
			$GetEle("rhobjNames").value = sHtml;
		} else {;
			$GetEle(showname).innerHTML = "";
			$GetEle(inputename).value = "";
			$GetEle("rhobjNames").value = "";
		}
	}
}

function onShowRequest(inputename, showname) {
	flowid = $GetEle("flowId").value;
	tmpids = $GetEle(inputename).value;
	tmpids = flowid + "-" + tmpids;

	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowserRight.jsp?resourceids=" + tmpids);
	if (data) {
		if (data.id != "") {
			resourceids = data.id;
			resourcename = data.name;
			var sHtml = "";
			resourceids = resourceids.substring(1);
			$GetEle(inputename).value = resourceids;
			resourcename = resourcename.substring(1);
			ids = resourceids.split(",");
			names = resourcename.split(",");
			for(var i=0;i<ids.length;i++){
				if(ids[i]!="0"){
					sHtml = sHtml + "<a href=/workflow/request/ViewRequest.jsp?requestid="+ ids[i] +   ">"+ names[i] + "</a>&nbsp;";
				}
			}
			$GetEle(showname).innerHTML = sHtml;
			$GetEle("objNames").value = sHtml;
		} else {
			$GetEle(showname).innerHTML = "";
			$GetEle(inputename).value = "";
			$GetEle("objNames").value = "";
		}
	}
}

function onShow(inputename, showname) {
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp");
	if (data) {
		if (data.id != "0") {
			$GetEle("nameimage").innerHTML = "";
			$GetEle(showname).innerHTML = data.name;
			$GetEle(inputename).value = data.id;
		} else {
			$GetEle(showname).innerHTML = "";
			$GetEle(inputename).value = "";
			$GetEle("nameimage").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
		}
		$GetEle("flowName").innerHTML = "";
		$GetEle("flowId").value = "";
		$GetEle("nameimage1").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
	}
}

function onShow2(inputename, showname) {
	typeid = $GetEle("typeId").value;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + typeid);
	if ((data)) {
		if (data.id != "") {
			$GetEle("nameimage1").innerHTML = "";
			$GetEle(showname).innerHTML = data.name;
			$GetEle(inputename).value = data.id;
		} else {
			$GetEle("nameimage1").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle></IMG>";
			$GetEle(showname).innerHTML = "";
			$GetEle(inputename).value = "";
		}
	}
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
