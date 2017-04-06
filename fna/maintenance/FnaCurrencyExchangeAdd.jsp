<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaCurrencyExchangeAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next() ;
String defaultcurrencyid = RecordSet.getString("id") ;
String defaultcurrencyname = RecordSet.getString("currencyname") ;
String currencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(id),user.getLanguage()) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+ currencyname ;
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
<input class=inputstyle type=hidden name=operation value="addcurrencyexchange">
  <input class=inputstyle type=hidden name=thecurrencyid value="<%=id%>">
  <input class=inputstyle type=hidden name=defcurrencyid value="<%=defaultcurrencyid%>">
   
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
      <TD class=Field>
	  <select class=inputstyle name="fnayear">
<%
RecordSet.executeProc("FnaYearsPeriods_Select","");
boolean hasYear = false;
while(RecordSet.next()) {
	String fnayear = RecordSet.getString("fnayear") ;
	hasYear = true;
%>
          <option value="<%=fnayear%>"><%=fnayear%></option>
<%}%>
	</select>
	<%
		if(!hasYear){%>
	<SPAN id=fnayearimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
	
	<%}%>
	<span class=fontred>&nbsp&nbsp<%=SystemEnv.getHtmlLabelName(17562,user.getLanguage())%></span>
	</TD>
    <TD></TD>
    <TD><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></TD>
    <TD class=Field>1 <%=defaultcurrencyname%> = <input class=inputstyle id=avgexchangerate name=avgexchangerate maxlength="8" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("avgexchangerate");checkinput("avgexchangerate","avgexchangerateimage")' size="10"> <%=currencyname%>
        <SPAN id=avgexchangerateimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
      </TD></TR>
      <TR style="height:1px;"><TD class=Line colSpan=6></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></TD>
    <TD class=Field>
        <select class=inputstyle id=periodsid name=periodsid onBlur='checknumber("periodsid");checkinput("periodsid","periodsidimage")'>
            <option></option>
            <option value=1>1</option>
            <option value=2>2</option>
            <option value=3>3</option>
            <option value=4>4</option>
            <option value=5>5</option>
            <option value=6>6</option>
            <option value=7>7</option>
            <option value=8>8</option>
            <option value=9>9</option>
            <option value=10>10</option>
            <option value=11>11</option>
            <option value=12>12</option>
        </select>    
        <SPAN id=periodsidimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    <TD></TD>
      <TD><%=SystemEnv.getHtmlLabelName(1460,user.getLanguage())%></TD>
    <TD class=Field>1 <%=defaultcurrencyname%> = <input class=inputstyle id=endexchangerage name=endexchangerage maxlength="8" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("endexchangerage");checkinput("endexchangerage","endexchangerageimage")' size="10"> <%=currencyname%>
        <SPAN id=endexchangerageimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
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
<script language=javascript>  
function submitData() {
 if(check_form(document.frmMain,"fnayear,periodsid,avgexchangerate,endexchangerage")){
 frmMain.submit();
 }
}
</script>
</BODY>
</HTML>