<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String rightStr = "";
if(!HrmUserVarify.checkUserRight("CptCapital:Mend", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}else{
		rightStr = "CptCapital:Mend";
		session.setAttribute("cptuser",rightStr);
	}
//String capitalid = request.getParameter("capitalid");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
Calendar current = Calendar.getInstance();
String currDate = Util.add0(current.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(current.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(current.get(Calendar.DAY_OF_MONTH), 2) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(22459,user.getLanguage());
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
				  <td><%=SystemEnv.getHtmlLabelName(15308,user.getLanguage())%></td>
				  <td class=Field> <button type=button  class=Browser onClick="onShowCapitalid()"></button> 
						  <span id=capitalidspan><IMG src='/images/BacoError.gif' align=absMiddle></span> 
						  <input type=hidden name=capitalid >
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <TD><%=SystemEnv.getHtmlLabelName(1047,user.getLanguage())%></TD>
		            <TD class=Field>
		              <button type=button  class=Browser id=SelectManagerID onClick="onShowresource('resourceidspan','resourceid')"></BUTTON>
		              <span id=resourceidspan>
		              <img src="/images/BacoError.gif" align=absMiddle>
		              </span>
		              <INPUT type=hidden name=resourceid>
		            </TD>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(1409,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Calendar id=selectmenddate onClick="getmendDate()"></button> 
					<span id=menddatespan ><IMG src="/images/BacoError.gif" align=absMiddle></span> 
					<input type="hidden" name="menddate">
				  </td>
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  <td><%=SystemEnv.getHtmlLabelName(22457,user.getLanguage())%></td>
				  <td class=Field><button type=button  class=Calendar id=selectmenddate onClick="onShowDate(mendperioddatespan,mendperioddate)"></button> 
					<span id=mendperioddatespan ><IMG src="/images/BacoError.gif" align=absMiddle></span> 
					<input type="hidden" name="mendperioddate">
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
					<td><%=SystemEnv.getHtmlLabelName(1399,user.getLanguage())%></td>
					<td class=Field> <button type=button  class=Browser onClick="onShowCustomerid('maintaincompanyimage', 'maintaincompany')"></button> 
					  <span id=maintaincompanyimage><IMG src='/images/BacoError.gif' align=absMiddle></span> 
					  <input type=hidden name=maintaincompany>
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
			"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2'&cptstateid=1,2,3&cptsptcount=1"
			, $GetEle("capitalidspan")
			, $GetEle("capitalid")
			, true);
}

function onShowCustomerid(spanname,inputname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2"
			, $GetEle(spanname)
			, $GetEle(inputname)
			, true);
}

function onShowresource(spanname,inputname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			, $GetEle(spanname)
			, $GetEle(inputname)
			, true);
}
</script>
 <script language="javascript">
 function onSubmit(){
 	if(check_form(document.frmain,'capitalid,menddate,maintaincompany,resourceid,mendperioddate')){
        if (checkDateValid()) {
            $GetEle("frmain").action="CapitalMendOperation.jsp";
            $GetEle("frmain").submit();
       }
	}
 }

 function back()
{
	window.history.back(-1);
}

// added by lupeng 2004-07-26 for TD589.
function checkDateValid() {
    var currDate = "<%=currDate%>";
    var mendDate = document.all("menddate").value;
    if (mendDate > currDate) {
        alert("<%=SystemEnv.getHtmlNoteName(60,user.getLanguage())%>");
        return false;
    }

    return true;
}
// end.
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
