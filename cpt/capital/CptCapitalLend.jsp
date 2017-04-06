<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:Lend", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}else{
		rightStr = "CptCapital:Lend";
		session.setAttribute("cptuser",rightStr);
	}
//String capitalid = request.getParameter("capitalid");

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
// added by lupeng 2004-07-26 for TD577.
int msgid = Util.getIntValue(request.getParameter("msgid"), 0);
String borrowedCptId = "";
rs.executeSql("SELECT cptId FROM CptBorrowBuffer");
while (rs.next())
    borrowedCptId += Util.null2String(rs.getString(1)) + ",";
// end.

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(6051,user.getLanguage());
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
<FORM id=weaver name=weaver method=post >
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
<DIV>
<%
if (msgid == -1) {
%>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(36,user.getLanguage())%>
</FONT>
<%}%>
</DIV>

			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="15%"> <COL width="85%"> <TBODY>
				 <tr>
				  <td><%=SystemEnv.getHtmlLabelName(15304,user.getLanguage())%></td>
				  <td class=Field> <button type=button  class=Browser onClick="onShowCapitalid()"></button> 
						  <span id=capitalidspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
						  <input type=hidden name=capitalid >
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(368,user.getLanguage())%></td>
				  <td class=field><button type=button  class=browser onClick="onShowResource()"></button>
			  <span id=viewerspan><IMG src='/images/BacoError.gif' align=absMiddle>
			  </span>
			  <input type=hidden name=hrmid value="">
				   </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				 <tr> 
				  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
					  <TD class=Field><button type=button  class=Browser id=SelDeparment onClick="ShowDeparment()" ></button> 
						  <span class=InputStyle id=FromDeparment><IMG src='/images/BacoError.gif' align=absMiddle></span> 
					   <input id=CptDept_from type=hidden name="departmentid" value=""></TD>
				</tr>  
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(1404,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Calendar id=selectlenddate onClick="getlendDate()"></button> 
					<span id=lenddatespan ><IMG src="/images/BacoError.gif" align=absMiddle></span> 
					<input type="hidden" name="lenddate">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<!--tr> 
				  <td><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Browser id=SelectCrmID onClick="onShowCrmID()"></button> 
					<span id=crmidspan><img src="/images/BacoError.gif" align=absMiddle></span> 
					<input class=InputStyle id=crmid type=hidden name=crmid>
				  </td>
				</tr>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Browser id=SelectUseRequest onClick="onShowUseRequest()"></button> 
					<span 
						id=userequestspan></span> 
					<input class=InputStyle id=userequest type=hidden name=userequest>
				  </td>
				</tr>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(1393,user.getLanguage())%></td>
				  <td class=Field> 
					<input type=text size=15 maxlength=13 name="fee"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fee")'>
				 </td>
				</tr-->
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td>
				  <td class=Field> 
					<input type=text size=60 maxlength=100 name="location" class="InputStyle">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
				  <td class=Field colspan=2>
					<textarea class="InputStyle"  style="width:100%" name=remark rows="6"></textarea>
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
 function onShowCrmID() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("crmidspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				$GetEle("crmid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("crmidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("crmid").value = "";
			}
		}
	}


	function onShowUseRequest() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("userequestspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				$GetEle("userequest").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("userequestspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("userequest").value = "";
			}
		}
	}

	function onShowCapitalid() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1&cptsptcount=1"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("capitalidspan").innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				$GetEle("capitalid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("capitalidspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("capitalid").value = "";
			}
		}
	}

	function onShowResource() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("viewerspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
				$GetEle("hrmid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("viewerspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("hrmid").value = "";
			}
		}
	}


	function ShowDeparment() {
		var id = window.showModalDialog(
						"/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" + $GetEle("departmentid").value
						, ""
						, "dialogWidth:550px;dialogHeight:550px;");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				$GetEle("FromDeparment").innerHTML = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
				$GetEle("departmentid").value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				$GetEle("FromDeparment").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$GetEle("departmentid").value = "";
			}
		}
	}
	 
 
 </script>
 <script language="javascript">
 function onSubmit(){
 	if(check_form(document.weaver,'capitalid,hrmid,departmentid,lenddate')){
		document.weaver.action="CapitalLendOperation.jsp"
		document.weaver.submit();
	}
 }

// added by lupeng 2004-07-26 for TD577
var borrowedCptId = "<%=borrowedCptId%>";

function checkValid(cptId) {
    if (borrowedCptId.indexOf(cptId+",") != -1) {
        alert("<%=SystemEnv.getErrorMsgName(36,user.getLanguage())%>");
        return false;
    }

    return true;
}
// end.

function back()
{
	window.history.back(-1);
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
