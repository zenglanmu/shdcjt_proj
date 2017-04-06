<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<% if(!HrmUserVarify.checkUserRight("SmsManage:View",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

<%@ include file="/docs/docs/DocCommExt.jsp"%>
<script type="text/javascript" src="/js/WeaverTableExt.js"></script>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid.css" />
</head>
<%
String isdelete=Util.null2String(request.getParameter("delete"));
String deleteids=Util.null2String(request.getParameter("deleteids"));
if(isdelete.equals("1")){ 
	String tempdeleteids = deleteids.substring(0,deleteids.lastIndexOf(","));
	RecordSet.executeSql("delete from SMS_Message where id in ("+tempdeleteids+")");
}

    int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
    int perpage = Util.getPerpageLog();

    if (perpage <= 1) perpage = 10;

    String fromdate = Util.fromScreen(request.getParameter("fromdate"), user.getLanguage());
    String enddate = Util.fromScreen(request.getParameter("enddate"), user.getLanguage());
    String messagetype = Util.fromScreen(request.getParameter("messagetype"), user.getLanguage());
    String messagestatus=Util.fromScreen(request.getParameter("messagestatus"),user.getLanguage());
    String deleted=Util.null2String(request.getParameter("deleted"));

    int objType = Util.getIntValue(request.getParameter("objType"), 1);
	String objId = Util.null2String(request.getParameter("objId"));
	String objName = "";
	if(objType == 1){
		objName = "<a href='javaScript:openhrm("+objId+");' onclick='pointerXY(event);'>"+resourceComInfo.getLastname(objId)+"</a>&nbsp";
	}else if(objType == 2){
		objName = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/company/HrmDepartmentDsp.jsp?id="+objId+"')\">"+departmentComInfo.getDepartmentname(objId)+"</a>&nbsp";
	}else if(objType == 3){
		objName = "<a href=\"javaScript:openFullWindowHaveBar('/hrm/company/HrmSubCompanyDsp.jsp?id="+objId+"')\">"+subCompanyComInfo.getSubCompanyname(objId)+"</a>&nbsp";
	}

    String sqlwhere = " where 1=1 ";

	if(!deleted.equals("")){
		sqlwhere += " and s.isdelete="+deleted;
	}
    if (!"".equals(objId)) {
    	if(objType == 1){
			sqlwhere += " and h.id=" + objId;
    	}else if(objType == 2){
    		sqlwhere += " and h.departmentid=" + objId;
    	}else if(objType == 3){
    		sqlwhere += " and h.subcompanyid1=" + objId;
    	}
    }
    if (!fromdate.equals("")) {
        sqlwhere += " and s.finishtime>='" + fromdate + " 00:00:00'";
    }
    if (!enddate.equals("")) {
        sqlwhere += " and s.finishtime<='" + enddate + " 23:59:59'";
    }

    if(!messagetype.equals("")){
        sqlwhere+=" and s.messagetype = '"+messagetype+"'";
    }
    if(!messagestatus.equals("")){
        sqlwhere+=" and s.messagestatus = '"+messagestatus+"'";
    }
    //System.out.println("sqlwhere:"+sqlwhere);

    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(16891, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
%>
<BODY>
<iframe id="iframeSmsManage" style="display: none"></iframe>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
    RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:doSubmit(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    
    RCMenu += "{" + SystemEnv.getHtmlLabelName(2031, user.getLanguage()) + ",javascript:doDelete(),_self} ";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{" + "Excel,javascript:exportXSL(),_self} ";
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
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<form name=frmmain method=post action="SmsManage.jsp">
				<input type="hidden" name="delete" value="">
				<input type="hidden" name="deleteids" value="">
			<table class=ViewForm>
			  <colgroup>
			  <%
                  if(!user.getLogintype().equals("2")){
              %>
			  <col width="6%">
			  <col width="15%">
			  <col width="6%">
			  <col width="31%">
			  <col width="6%">
			  <col width="8%">
			  <col width="6%">
			  <col width="8%">
              <col width="6%">
              <col width="8%">
			  <tbody>
			  <tr>
					<td><%=SystemEnv.getHtmlLabelName(172, user.getLanguage())%></td>
					<td class=field>
						<select class=inputstyle  name=objType onChange="onChangeType()">
							<option value="1" <%if (objType==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
							<option value="2" <%if (objType==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							<option value="3" <%if (objType==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
						</select>
						<BUTTON type=button class=Browser <%if (objType==2||objType==3) {%>  style="display:none"  <%}%> onClick="onShowResource('objId','objName');" name=showresource></BUTTON>
						<BUTTON type=button class=Browser <%if (objType==0||objType==1||objType==3) {%> style="display:none" <%}%> onClick="onShowDepartment('objId','objName')" name=showdepartment></BUTTON>
						<BUTTON type=button class=Browser <%if (objType==0||objType==1||objType==2) {%> style="display:none"  <%}%> onClick="onShowBranch('objId','objName')" name=showBranch></BUTTON>
						<SPAN id=objName>
							<%=objName%>
						</SPAN>
						<input type=hidden name="objId" id="objId" value="<%="0".equals(objId)?"":objId%>">
					</td>
				<%
					}else{
				%>
			  <col width="8%">
			  <col width="29%">
			  <col width="9%">
			  <col width="12%">
			  <col width="9%">
			  <col width="12%">
              <col width="9%">
              <col width="12%">
			  <tbody>
			  <tr>
				<%}%>
			  <td><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></td>
			  <td class=field>
			  <BUTTON class=calendar type=button id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
			  <SPAN id=fromdatespan ><%=Util.toScreen(fromdate, user.getLanguage())%></SPAN>
			  <input type="hidden" name="fromdate" value=<%=fromdate%>>
			  － &nbsp
				<BUTTON class=calendar type=button id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
			  <SPAN id=enddatespan ><%=Util.toScreen(enddate, user.getLanguage())%></SPAN>
			  <input type="hidden" name="enddate" value=<%=enddate%>>

			  </td>

              <td><%=SystemEnv.getHtmlLabelName(18523,user.getLanguage())%></td>
              <td class=field>
              <select class=saveHistory id=messagestatus  name=messagestatus>
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=0 <%if(messagestatus.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18525,user.getLanguage())%></option>
				<option value=1 <%if(messagestatus.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18524,user.getLanguage())%></option>
				<option value=2 <%if(messagestatus.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18966,user.getLanguage())%></option>
			 </select>
              </td>

			  <td><%=SystemEnv.getHtmlLabelName(18527,user.getLanguage())%></td>
			  <td class=field>
			  <select class=saveHistory id=messagetype  name=messagetype>
				<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value=2 <%if(messagetype.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18528,user.getLanguage())%></option>
				<option value=1 <%if(messagetype.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())%></option>
			 </select>
			  </td>
			  <td><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td>
			  <td class=field>
			  <select class=saveHistory id=deleted  name=deleted>
				<option value="" <%if(deleted.equals("")){%>selected<%}%>></option>
				<option value=0 <%if(deleted.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21269,user.getLanguage())%></option>
				<option value=1 <%if(deleted.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18967,user.getLanguage())%></option>
			 </select>
			  

			  <TR style="height:2px"><TD class=Line colSpan=10></TD></TR>
			</tbody>
			</table>
			<BR>
		 
			 <%@ page import="weaver.common.xtable.*" %>
			 <%
				ArrayList tcList=new ArrayList();

				TableColumn tc1=new TableColumn();
				tc1.setColumn("messageType");
				tc1.setDataIndex("messageType");
				tc1.setHeader(SystemEnv.getHtmlLabelName(16975,user.getLanguage()));
				tc1.setTransmethod("weaver.splitepage.transform.SptmForSms.getSend");
				tc1.setPara_1("column:messageType");
				tc1.setPara_2("column:userType+column:userid+column:sendNumber+column:toUserType+column:toUserID");
				tc1.setSortable(false);				
				tc1.setHideable(false);
				tc1.setWidth(0.1); 
				tcList.add(tc1);	
				
				TableColumn tc2=new TableColumn();
				tc2.setColumn("messageType2");
				tc2.setDataIndex("messageType2");
				tc2.setHeader(SystemEnv.getHtmlLabelName(15525,user.getLanguage()));
				tc2.setTransmethod("weaver.splitepage.transform.SptmForSms.getRecieve");
				tc2.setPara_1("column:messageType");
				tc2.setPara_2("column:toUserType+column:toUserID+column:recieveNumber+column:UserType+column:UserID");
				tc2.setSortable(false);				
				tc2.setHideable(false);
				tc2.setWidth(0.1); 
				tcList.add(tc2);

				TableColumn tc3=new TableColumn();
				tc3.setColumn("message");
				tc3.setDataIndex("message");
				tc3.setHeader(SystemEnv.getHtmlLabelName(18529,user.getLanguage()));
				tc3.setSortable(false);				
				tc3.setHideable(false);
				tc3.setWidth(0.44); 
				tcList.add(tc3);

				TableColumn tc4=new TableColumn();
				tc4.setColumn("messagestatus");
				tc4.setDataIndex("messagestatus");
				tc4.setHeader(SystemEnv.getHtmlLabelName(18523,user.getLanguage()));
				tc4.setTransmethod("weaver.splitepage.transform.SptmForSms.getPersonalViewMessageStatus");
				tc4.setPara_1("column:messagestatus");
				tc4.setPara_2(""+user.getLanguage()+"+column:isdelete");
				tc4.setSortable(false);				
				tc4.setHideable(false);
				tc4.setWidth(0.1); 
				tcList.add(tc4);


				TableColumn tc5=new TableColumn();
				tc5.setColumn("messagetype3");
				tc5.setDataIndex("messagetype3");
				tc5.setHeader(SystemEnv.getHtmlLabelName(18527,user.getLanguage()));
				tc5.setTransmethod("weaver.splitepage.transform.SptmForSms.getMessageType");
				tc5.setPara_1("column:messageType");
				tc5.setPara_2(""+user.getLanguage());
				tc5.setSortable(false);				
				tc5.setHideable(false);
				tc5.setWidth(0.1); 
				tcList.add(tc5);

				TableColumn tc6=new TableColumn();
				tc6.setColumn("finishtime");
				tc6.setDataIndex("finishtime");
				tc6.setHeader(SystemEnv.getHtmlLabelName(18530,user.getLanguage()));
				tc6.setSortable(true);				
				tc6.setHideable(false);
				tc6.setWidth(0.16); 
				tcList.add(tc6);

				TableSql ts=new TableSql();
				ts.setBackfields("s.*");
				ts.setPageSize(perpage);
				ts.setSqlform(" from SMS_Message s left join hrmresource h on s.userid=h.id ");
				ts.setSqlwhere(sqlwhere);
				ts.setSqlgroupby("");
				ts.setSqlprimarykey("s.id");
				ts.setSqlisdistinct("true");
				ts.setSort("s.id");
				ts.setDir(TableConst.DESC);
				
				Table xTable=new Table(request); 
				xTable.setTableId("xTable_SmsManage");//必填而且与别的地方的Table不能一样
				xTable.setTableGridType(TableConst.CHECKBOX);									
				xTable.setTableSql(ts);
				xTable.setTableColumnList(tcList);
				xTable.setUser(user);
				xTable.setColumnWidth(50);
				xTable.setTableNeedRowNumber(false);
				out.println(xTable.toString());			
			 %>
		
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
</body>
<script language="javascript">
function onChangeType(){
	 
	thisvalue=document.frmmain.objType.value;
	$G("objId").value="";
	$G("objName").innerHTML ="";

	if(thisvalue==3){
 		$G("showBranch").style.display='';
	}
	else{
		$G("showBranch").style.display='none';
	}
	if(thisvalue==2){
		$G("showdepartment").style.display='';
		
	}
	else{
		$G("showdepartment").style.display='none';
	}
	if(thisvalue==1){
		$G("showresource").style.display='';
		
	}
	else{
		$G("showresource").style.display='none';
		
    }
	
}
function doSubmit()
{
	document.frmmain.submit();
}
function hiddenDel(){
    doSubmit();
}
function doDelete(){
	var deleteids = _table._xtable_CheckedCheckboxId();;
	if(deleteids==""){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}else{
		if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
			document.all("delete").value = 1;
			document.all("deleteids").value = deleteids;
			document.frmmain.submit();
		}
	}
}

</script>

<script type="text/javascript">
//<!--
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

function onShowDepartment(inputename,showname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedDepartmentIds=" + $G(inputename).value + "&selectedids=" + $G(inputename).value
			, $G(showname)
			, $G(inputename)
			, false
			, "/hrm/company/HrmDepartmentDsp.jsp?id=");
}

function onShowResource(inputename,showname) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids=" + $G(inputename).value;
	var spanobj =  $G(showname);
	var inputobj = $G(inputename);

	var id = window.showModalDialog(url, "", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			spanobj.innerHTML = "<A href='javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id, 0) + ")' onclick='pointerXY(event);' "
					+ ">"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = "";
			inputobj.value = "";
		}
	}
}

function onShowBranch(inputename,showname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" + $G(inputename).value + "&selectedDepartmentIds=" + $G(inputename).value
			, $G(showname)
			, $G(inputename)
			, false
			, "/hrm/company/HrmSubCompanyDsp.jsp?id=");
}
//-->
</script>
<!-- 
<SCRIPT language=VBS>
sub onShowDepartment(inputename,showname)
    tmpids = document.all(inputename).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedDepartmentIds="&tmpids&"&selectedids="&document.all(inputename).value)
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			resourceid = id(0)
			resourcename = id(1)
			sHtml = ""

			document.all(inputename).value= resourceid
			sHtml = "<a href=/hrm/company/HrmDepartmentDsp.jsp?id="&resourceid&">"&resourcename&"</a>&nbsp"

			document.all(showname).innerHtml = sHtml
		else
			document.all(showname).innerHtml =""
			document.all(inputename).value=""
		end if
	end if
end sub

sub onShowResource(inputename,showname)
    tmpids = document.all(inputename).value
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="&tmpids)
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			resourceid = id(0)
			resourcename = id(1)
			sHtml = ""

			document.all(inputename).value= resourceid
			sHtml = sHtml&"<a href=javaScript:openhrm("&resourceid&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"

			document.all(showname).innerHtml = sHtml
		else
			document.all(showname).innerHtml =""
			document.all(inputename).value=""
		end if
	end if
end sub


sub onShowBranch(inputename,showname)
	tmpids = document.all(inputename).value
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&tmpids&"&selectedDepartmentIds="&tmpids)
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			resourceid = id(0)
			resourcename = id(1)
			sHtml = ""

			document.all(inputename).value= resourceid
			sHtml = sHtml&"<a href=/hrm/company/HrmSubCompanyDsp.jsp?id="&resourceid&">"&resourcename&"</a>&nbsp"

			document.all(showname).innerHtml = sHtml
		else
			document.all(showname).innerHtml =""
			document.all(inputename).value=""
		end if
	end if
end sub
</SCRIPT>
 -->
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>


<script  language="javascript">
function exportXSL()
{
	document.getElementById("iframeSmsManage").src = "SmsManageExcel.jsp?fromdate=<%=fromdate%>&enddate=<%=enddate%>&messagetype=<%=messagetype%>&messagestatus=<%=messagestatus%>&objType=<%=objType%>&objId=<%=objId%>";
}
Ext.onReady(function(){
    Ext.get('loading').fadeOut();
});
</script>