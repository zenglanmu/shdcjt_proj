<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:MoveIn", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}else{
	rightStr = "CptCapital:MoveIn";
	session.setAttribute("cptuser",rightStr);
}
String hrmid=Util.fromScreen(request.getParameter("hrmid"),user.getLanguage());
String replacecapitalid = Util.null2String(request.getParameter("replacecapitalid"));
String owner=Util.fromScreen(request.getParameter("owner"),user.getLanguage());
String remark=Util.fromScreen(request.getParameter("remark"),user.getLanguage());

String departmentid ="";
if (!replacecapitalid.equals("")){
String sql="select departmentid from CptCapital ";
sql+=" where id= " + replacecapitalid;
    RecordSet.executeSql(sql);
    RecordSet.next();    
	departmentid=Util.null2String(RecordSet.getString("departmentid"));
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(883,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",/cpt/capital/CptCapitalUse.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(883,user.getLanguage())+",/cpt/capital/CptCapitalMove.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6051,user.getLanguage())+",/cpt/capital/CptCapitalLend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6054,user.getLanguage())+",/cpt/capital/CptCapitalLoss.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6052,user.getLanguage())+",/cpt/capital/CptCapitalDiscard.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(22459,user.getLanguage())+",/cpt/capital/CptCapitalMend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6055,user.getLanguage())+",/cpt/capital/CptCapitalModifyOperation.jsp?isdata=2,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",/cpt/capital/CptCapitalBack.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15306,user.getLanguage())+",/cpt/capital/CptCapitalInstock1.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15307,user.getLanguage())+",/cpt/search/CptInstockSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmain name=frmain method=post action="/cpt/capital/CapitalMoveOperation.jsp" >
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

			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="15%"> <COL width="85%"> <TBODY> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(15309,user.getLanguage())%></td>
						<td class=Field> <button type=button  class=Browser onClick="onShowReplacecapitalid()"></button>
						  <span id=replacecapitalidspan><%if(!replacecapitalid.equals("")){%><%=CapitalComInfo.getCapitalname(replacecapitalid)%><%}else{%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
						  <input type=hidden name=replacecapitalid value=<%=replacecapitalid%>>
						</td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
                <tr>
				  <td><%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1508,user.getLanguage())%></td>
				  <td class=field><SPAN id="ownerspan"><%=owner%></SPAN>
				  <input type=hidden name=owner value=<%=owner%>>
				   </td>
				   <td>&nbsp;</td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(15310,user.getLanguage())%></td>
				  <td class=field><button type=button  class=browser onClick="onShowResource()"></button>
			  <span id=viewerspan><%if(!hrmid.equals("")){%><a href="/hrm/resource/HrmResource.jsp?id=<%=hrmid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(""+hrmid),user.getLanguage())%></a><%}else{%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span>
			  <input type=hidden name=hrmid value="<%=hrmid%>">
				   </td>
				   <td>&nbsp;</td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(15311,user.getLanguage())%></td>
					  <TD class=Field><button type=button  class=Browser id=SelDeparment onClick="ToDeparment_1()"></button> 
						  <span class=saveHistory id=ToDeparment><%if(!hrmid.equals("")){%><A href='/hrm/company/HrmDepartmentDsp.jsp?id=<%=ResourceComInfo.getDepartmentID(hrmid)%>'><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(hrmid)),user.getLanguage())%></A><%}else{%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></span> 
					   <input id=CptDept_to type=hidden name="CptDept_to" value="<%=ResourceComInfo.getDepartmentID(hrmid)%>"></TD>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
				  <td class=Field colspan=2>
					<textarea class="InputStyle"  style="width:100%" name=remark rows="6"><%=Util.toScreen(remark,user.getLanguage())%></textarea>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				</TBODY>
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
 
 <script type="text/javascript">
 
 function onShowReplacecapitalid() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=2",
						"", "dialogWidth:550px;dialogHeight:550px;");// 只显示状态为使用的资产
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
				$GetEle("replacecapitalidspan").innerHTML = wuiUtil
						.getJsonValueByIndex(id, 1);
				$GetEle("replacecapitalid").value = wuiUtil.getJsonValueByIndex(id,
						0);
				$GetEle("ownerspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 4);
				$GetEle("owner").value = wuiUtil.getJsonValueByIndex(id, 4);
			} else {
				$GetEle("replacecapitalidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("replacecapitalid").value = "";
				$GetEle("ownerspan").innerHTML = "";
				$GetEle("owner").value = "";
			}
		}
	}

	function onShowResource() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
						"", "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("viewerspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="
						+ wuiUtil.getJsonValueByIndex(id, 0)
						+ "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
				$GetEle("hrmid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("viewerspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("hrmid").value = "";
			}
			$GetEle("frmain").action = "CptCapitalMove.jsp";
			$GetEle("frmain").submit();
		}
	}

	function FromDeparment_1() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								+ $GetEle("CptDept_from").value, "",
						"dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("FromDeparment").innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="
						+ wuiUtil.getJsonValueByIndex(id, 0)
						+ "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
				$GetEle("CptDept_from").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("FromDeparment").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("CptDept_from").value = "";
			}
		}
	}

	function ToDeparment_1() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
								+ $GetEle("CptDept_to").value, "",
						"dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("ToDeparment").innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="
						+ wuiUtil.getJsonValueByIndex(id, 0)
						+ "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
				$GetEle("CptDept_to").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("ToDeparment").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("CptDept_to").value = "";
			}
		}
	}

	function onShowUseRequest() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1",
						"", "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("userequestspan").innerHTML = wuiUtil.getJsonValueByIndex(
						id, 1);
				$GetEle("userequest").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("userequestspan").innerHTML = "";
				$GetEle("userequest").value = "";
			}
		}
	}
	function onShowCapitalid() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'",
						"", "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("capitalidspan").innerHTML = wuiUtil.getJsonValueByIndex(
						id, 1);
				$GetEle("capitalid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("capitalidspan").innerHTML = "";
				$GetEle("capitalid").value = "";
			}
		}
	}
 </script>
 
 <script language="javascript">
 function onSubmit(){
 	if(check_form(document.frmain,"hrmid,replacecapitalid,CptDept_to")){
		document.frmain.submit();
        }
 }
</script>
<script language="javascript">
function back()
{
	window.history.back(-1);
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
