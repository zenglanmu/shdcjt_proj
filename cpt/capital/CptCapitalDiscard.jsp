<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:Discard", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}else{
		rightStr = "CptCapital:Discard";
		session.setAttribute("cptuser",rightStr);
	}
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String capitalid = Util.fromScreen(request.getParameter("capitalid"),user.getLanguage());
String sptcount = "";
if (!capitalid.equals("")) {
	String sqlstr ="select sptcount from CptCapital where id = " + capitalid;
	RecordSet.executeSql(sqlstr);
	RecordSet.next();
	sptcount = RecordSet.getString("sptcount");
	if (sptcount.equals("")){
		sptcount="0" ;
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(6052,user.getLanguage());
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
<FORM id=weaver name=frmain method=post >
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
				  <td><%=SystemEnv.getHtmlLabelName(15300,user.getLanguage())%></td>
				  <td class=Field> <button type=button  class=Browser onClick="onShowCapitalid()"></button> 
						  <span id=capitalidspan><%if (capitalid.equals("") ){%><IMG src='/images/BacoError.gif' align=absMiddle><%} else { %><%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%><%}%></span> 
						  <input type=hidden name=capitalid value="<%=capitalid%>">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<%if(!sptcount.equals("1")) { %>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
				  <td class=Field> 
					<input class=InputStyle 
						maxlength=10 size=10 name="capitalnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum");checkinput("capitalnum","capitalnumimage")'>
					<span id=capitalnumimage><IMG src="/images/BacoError.gif" align=absMiddle>
					<%if(msgid!=-1){
					%>            
					<font color=red size=2>
					<%=SystemEnv.getHtmlLabelName(1405,user.getLanguage())%>
					</font>           
					<%}%></span> 
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<%}%>
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(1392,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Calendar id=selectdiscarddate onClick="getdiscardDate(discarddatespan,discarddate)"></button> 
					<span id=discarddatespan ><IMG src="/images/BacoError.gif" align=absMiddle></span> 
					<input type="hidden" name="discarddate">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<!--tr> 
				  <td><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Browser id=SelectUseRequest onClick="onShowUseRequest()"></button> 
					<span 
						id=userequestspan></span> 
					<input class=InputStyle id=userequest type=hidden name=userequest>
				  </td>
				</tr-->
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(1393,user.getLanguage())%></td>
				  <td class=Field> 
					<input type=text size=15 maxlength=13 name="fee"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("fee")' class=InputStyle>
				 </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
				  <td class=Field colspan=2> 
					<textarea class=InputStyle  style="width:100%" name=remark rows="6"></textarea>
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			<input type=hidden id=sptcount name=sptcount value="<%=sptcount%>">
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

function onShowUseRequest() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp?isrequest=1"
			, $GetEle("userequestspan")
			, $GetEle("userequest")
			, false);
}

function onShowCapitalid() {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3,4"
			, $GetEle("capitalidspan")
			, $GetEle("capitalid")
			, true);
}
</script>
 
 <script language="javascript">
 function onSubmit(){
 	if(check_form(document.frmain,'capitalid,<%if(!sptcount.equals("1")) {%>capitalnum,<%}%>discarddate')){
		document.frmain.action="CapitalDiscardOperation.jsp"
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
