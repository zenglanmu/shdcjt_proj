<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
RecordSet.executeProc("TransBudgetCount_Select","");
RecordSet.next() ;
String trancount = RecordSet.getString(1) ;

//added by lupeng 2004.05.20 to fix TD498.
//get all the currency names in the system.
String existCurrencyNames = "";
RecordSet.executeSql("SELECT currencyname FROM FnaCurrency");
while (RecordSet.next()) 
	existCurrencyNames += Util.null2String(RecordSet.getString("currencyname")) + ",";
//end

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain name=frmMain action=FnaCurrenciesOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation value="addcurrencies">
  <table class=viewForm id=tblCurrency>
    <thead> 
    <colgroup> 
    <col width="20%"> 
    <col width="80%">
	<tbody> 
    <tr class=title> 
      <th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
    <tr style="height:1px;"> 
      <td class=line1 colspan=2></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputStyle style="TEXT-TRANSFORM: uppercase" maxlength=3 
      	onChange='checkinput("currencyname","currencynameimage")' name=currencyname size="10">
        <span id=currencynameimage><img src="/images/BacoError.gif" align=absMiddle></span></td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputStyle maxlength=60
      	onChange='checkinput("currencydesc","currencydescimage")' name=currencydesc>
        <span id=currencydescimage><img src="/images/BacoError.gif" align=absMiddle></span></td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputStyle id=activable type=checkbox  CHECKED name="activable" value="1">
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></td>
      <td class=Field> 
        <input class=inputStyle id=isdefault type=checkbox name="isdefault" value="1" <% if(!trancount.equals("0")) {%> disabled <%}%> onclick="check();">
      </td>
    </tr>
    <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
    </TBODY> 
  </table>
</FORM>
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
<script language=javascript>  
var submit_flag=false;
function submitData() {
	if(submit_flag){return;}else{submit_flag=true;}
	if(checkactivable()){
		 if(checkvalue() && isValid()){
			frmMain.submit();
		 }
	}
}

function checkvalue() {
	if(!check_form(frmMain,"currencyname,currencydesc")) return false ;
	if(frmMain.isdefault.checked) {
		if(!confirm("<%=SystemEnv.getHtmlNoteName(29,user.getLanguage())%>"))
		return false;
	}
	return true ;
}

//added by lupeng 2004.05.20 to fix TD498.
var existCurrencyNames = "<%=existCurrencyNames%>";

function isValid() {
	var elem = document.all("currencyname");
	var currencyName = elem.value + ",";
	if (existCurrencyNames.indexOf(currencyName) != -1) {
		alert("<%=SystemEnv.getErrorMsgName(33,user.getLanguage())%>");
		elem.focus();
		return false;
	}

	return true;
}
//end

function check() {
	 if(document.getElementById("isdefault").checked){
		document.getElementById("activable").checked = true;
	 }
	 return true;
}

function checkactivable() {
	 if(document.getElementById("isdefault").checked == true && document.getElementById("activable").checked == false){
		alert("<%=SystemEnv.getHtmlLabelName(27080,user.getLanguage())%>");
		return false
	 }
	 return true;
}
</script>
</BODY>
</HTML>