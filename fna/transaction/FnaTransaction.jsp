<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaTransaction:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String departmentid = Util.null2String(request.getParameter("departmentid"));
String fnayearfrom = Util.null2String(request.getParameter("fnayearfrom"));
String periodsidfrom = Util.null2String(request.getParameter("periodsidfrom"));
String fnayearto = Util.null2String(request.getParameter("fnayearto"));
String periodsidto = Util.null2String(request.getParameter("periodsidto"));
String dbperiodsfrom = "" ;
if(!fnayearfrom.equals("") && !periodsidfrom.equals("")) 
dbperiodsfrom = fnayearfrom + Util.add0(Util.getIntValue(periodsidfrom),2) ;
String dbperiodsto = "";
if(!fnayearto.equals("") && !periodsidto.equals("")) 
dbperiodsto = fnayearto + Util.add0(Util.getIntValue(periodsidto),2) ;
if(dbperiodsfrom.compareTo(dbperiodsto) > 0) {
	String tempperiods = dbperiodsfrom ; dbperiodsfrom = dbperiodsto ; dbperiodsto = tempperiods ;
	tempperiods = fnayearfrom ; fnayearfrom = fnayearto ; fnayearto = tempperiods ;
	tempperiods = periodsidfrom ; periodsidfrom = periodsidto ; periodsidto = tempperiods ;
}
String sqlstr =" select tranperiods , transtatus , count(id), avg(trandefcurrencyid), sum(trandefdaccount) ,sum(trandefcaccount)  from FnaTransaction " ;
boolean haswhere = false ;
if(!departmentid.equals("")) {
	sqlstr +=" where trandepartmentid = "+ departmentid ;
	haswhere = true ;
}
if(!dbperiodsfrom.equals("")) {
	if(!haswhere) sqlstr +=" where tranperiods >= '"+ dbperiodsfrom + "' " ;
	else sqlstr +=" and tranperiods >= '"+ dbperiodsfrom + "' " ;
	haswhere = true ;
}
if(!dbperiodsto.equals("")) {
	if(!haswhere) sqlstr +=" where tranperiods <= '"+ dbperiodsto + "' " ;
	else sqlstr +=" and tranperiods <= '"+ dbperiodsto + "' " ;
}

sqlstr += " group by tranperiods , transtatus " ;

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(428,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("FnaTransactionAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/transaction/FnaTransactionAdd.jsp,_self} " ;
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

<FORM id=frmMain name=frmMain action=FnaTransaction.jsp method=post>
<TABLE class=viewForm>
  <COLGROUP>
  <COL width="10%"></COL>
  <COL width="25%"></COL>
   <COL width="10%"></COL>
  <COL width="25%"></COL>
  <COL width="10%"></COL>
  <COL width="25%"></COL>
  <THEAD>
  <TR class=title>
    <TH colSpan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR></THEAD>
  <TBODY>
  <TR class=spacing>
    <TD class=line1 colSpan=6></TD></TR>
  <TBODY>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
	 <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
   <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
       </TD>
   
      <TD><%=SystemEnv.getHtmlLabelName(1812,user.getLanguage())%></TD>
    <TD class=Field>
	<select class=InputStyle name="fnayearfrom">
		<option value=""></option>
		<%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
				  <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayearfrom)) {%>selected<%}%>><%=thefnayear%></option>
		<%}
		RecordSet.beforFirst() ;
		%>
    </select>
	<input class=inputstyle id=periodsidfrom name=periodsidfrom maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidfrom")' size="8" value="<%=periodsidfrom%>">
    </TD>
	
      <TD><%=SystemEnv.getHtmlLabelName(1813,user.getLanguage())%></TD>
    <TD class=Field>
		<select class=InputStyle name="fnayearto">
		<option value=""></option>
		<%
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
				  <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayearto)) {%>selected<%}%>><%=thefnayear%></option>
		<%}%>
    </select>
	<input class=inputstyle id=periodsidto name=periodsidto maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsidto")' size="8" value="<%=periodsidto%>">
    </TD></TR></TBODY></TABLE></FORM>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL>
  <COL>
  <COL align=right>
  <COL>
  <COL align=right>
  <COL align=right>
  <TBODY>
  <THEAD>
  <TR class=header>
    <TH colSpan=6>
      <P align=left><%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></P></TH></TR>
   <TR class=Header align=left>
    <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(1824,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: center" colSpan=5><%=SystemEnv.getHtmlLabelName(1823,user.getLanguage())%></TD>
  </TR>
  <TR class=Header align=left>
    <TD><%=SystemEnv.getHtmlLabelName(1814,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1822,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1820,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1821,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="8" ></TD></TR> 
  </THEAD>
  <TBODY>
<%
int i=0 ;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
String tranperiodss= RecordSet.getString(1) ;
String transtatuss = RecordSet.getString(2) ;
String countids = RecordSet.getString(3) ;
String defcurrencys = RecordSet.getString(4) ;
String daccounts = RecordSet.getString(5) ;
String caccounts = RecordSet.getString(6) ;
String newtranperiods = tranperiodss.substring(0,4)+ "-" + Util.getIntValue(tranperiodss.substring(4,6)) ;
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><A 
      href="FnaTransactionDetail.jsp?tranperiods=<%=tranperiodss%>&departmentid=<%=departmentid%>&transtatus=<%=transtatuss%>"><%=newtranperiods%></A> 
    </TD>
    <TD>
	<% if(transtatuss.equals("0")) {%> <%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%> 
	<%} else if(transtatuss.equals("1")) {%> <%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>
	<%} else if(transtatuss.equals("2")) {%> <%=SystemEnv.getHtmlLabelName(1815,user.getLanguage())%>
	<%} else if(transtatuss.equals("3")) {%> <%=SystemEnv.getHtmlLabelName(1816,user.getLanguage())%>
	<%}%> 
	</TD>
    <TD align=right><%=countids%></TD>
    <TD><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrencys),user.getLanguage())%></TD>
    <TD align=right><%=Util.getFloatStr(daccounts,3)%></TD>
    <TD align=right><%=Util.getFloatStr(caccounts,3)%></TD></TR>
<%}%>
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
<script language=javascript>  
function submitData() {
 frmMain.submit();
}
</script>

<script language=vbs>
sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmMain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmMain.departmentid.value=""
	end if
	end if
end sub
</script>
</BODY>
</HTML>