<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("FnaCurrencyExchange_SelectByID",id);
RecordSet.next() ;
String defaultcurrencyid = RecordSet.getString("defcurrencyid") ;
String thecurrencyid = RecordSet.getString("thecurrencyid") ;
String fnayear = RecordSet.getString("fnayear") ;
String periodsid = RecordSet.getString("periodsid") ;
String avgexchangerate = RecordSet.getString("avgexchangerate") ;
String endexchangerage = RecordSet.getString("endexchangerage") ;
String defaultcurrencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(defaultcurrencyid),user.getLanguage()) ;
String currencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(thecurrencyid),user.getLanguage()) ;

boolean canedit = HrmUserVarify.checkUserRight("FnaCurrencyExchangeEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+ currencyname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
 if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaCurrencyExchangeEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/maintenance/FnaCurrencyExchangeAdd.jsp?id="+thecurrencyid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaCurrencyExchangeEdit:Delete",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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

<FORM id=frmMain action=FnaCurrenciesOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation>
  <input class=inputstyle type=hidden name=thecurrencyid value="<%=thecurrencyid%>">
  <input class=inputstyle type=hidden name=id value="<%=id%>">
  <input class=inputstyle type=hidden name=fnayear value="<%=fnayear%>">
  <input class=inputstyle type=hidden name=periodsid value="<%=periodsid%>">
  <TABLE class=viewForm>
  <COLGROUP>
  <COL width="45%">
  <COL width="5%">
  <COL width="50%">
  <TBODY>
  <TR>
      <TH class=title align=left><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
    <TH></TH>
    <TH class=title align=left><%=SystemEnv.getHtmlLabelName(1461,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1></TD>
    <TD></TD>
    <TD class=line1></TD></TR></TBODY></TABLE>
<TABLE class=viewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="30%">
  <COL width="5%">
  <COL width="15%">
  <COL width="35%">
  <TBODY>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
      <TD class=Field><%=fnayear%>
	</TD>
    <TD></TD>
    <TD><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></TD>
    <TD class=Field>1 <%=defaultcurrencyname%> = <input class=inputstyle id=periodsid name=avgexchangerate maxlength="8" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("avgexchangerate");checkinput("avgexchangerate","avgexchangerateimage")' size="10" value="<%=avgexchangerate%>"> <%=currencyname%>
        <SPAN id=avgexchangerateimage></SPAN>
      </TD></TR>
      <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TD>
    <TD class=Field> <%=periodsid%>
        <SPAN id=periodsidimage></SPAN></TD>
    <TD></TD>
      <TD><%=SystemEnv.getHtmlLabelName(1460,user.getLanguage())%></TD>
    <TD class=Field>1 <%=defaultcurrencyname%> = <input class=inputstyle id=periodsid name=endexchangerage maxlength="8" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("endexchangerage");checkinput("endexchangerage","endexchangerageimage")' size="10" value="<%=endexchangerage%>"> <%=currencyname%>
        <SPAN id=endexchangerageimage></SPAN>
</TD></TR>
<TR style="height:1px;"><TD class=Line colSpan=6></TD></TR>
</TBODY></TABLE><BR>
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
<Script language=javascript>
function onEdit() {
	if(check_form(frmMain,"avgexchangerate,endexchangerage")) {
		frmMain.operation.value="editcurrencyexchange";
		frmMain.submit();
	}
}
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			frmMain.operation.value="deletecurrencyexchange";
			frmMain.submit();
		}
}
</script>
</BODY>
</HTML>