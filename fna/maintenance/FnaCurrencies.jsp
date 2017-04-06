<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String activable = Util.null2String(request.getParameter("activable"));
ArrayList thecurrencyids = new ArrayList() ;
ArrayList defcurrencyids = new ArrayList() ;
ArrayList exchangerages = new ArrayList() ;
RecordSet.executeProc("FnaCurrencyExchange_SByLast","");
while(RecordSet.next()) {
	thecurrencyids.add(Util.null2String(RecordSet.getString("thecurrencyid"))) ;
	defcurrencyids.add(Util.null2String(RecordSet.getString("defcurrencyid"))) ;
	exchangerages.add(Util.null2String(RecordSet.getString("endexchangerage"))) ;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("FnaCurrenciesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/maintenance/FnaCurrenciesAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaCurrencies:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+39+",_self} " ;
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
<FORM id=frmMain name=frmMain action=FnaCurrencies.jsp method=post>
<TABLE class=ViewFORM>
  <COLGROUP>
  <COL width="10%">
  <COL width="90%">

   <TR class=Section>
    <TH colSpan=2>
      <P align=left><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></P></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
    <TD class=field><select class=inputstyle  id=activable onchange="frmMain.submit()" 
      size=1 name=activable> 
	  <OPTION value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION> 
	  <OPTION value=1 <% if(activable.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></OPTION> 
	  <OPTION value=0 <% if(activable.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%></OPTION></SELECT> </TD>
     </TR>
  </TABLE></FORM>
<TABLE class=ListStyle cellspacing=1 >
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></TH></TR>
</TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1 >
  <THEAD>
  <COLGROUP>
  <COL align=left width="15%">
  <COL align=left width="25%">
  <COL align=left width="35%">
  <COL align=middle width="10%">
  <COL align=middle width="10%">
   <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(588,user.getLanguage())%></TH>
    <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></TH>
    <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></TH>
  </TR>
  <TR class=Line><TD colspan="5" ></TD></TR> 
  </THEAD>
 <%
 int i = 0 ;
 RecordSet.executeProc("FnaCurrency_SelectAll","") ;
 while(RecordSet.next()) {
 	String activables = Util.null2String(RecordSet.getString("activable")) ;
	if(!activable.equals("") && !activable.equals(activables)) continue ;
	String ids = Util.null2String(RecordSet.getString("id")) ;
	String currencynames = Util.toScreen(RecordSet.getString("currencyname"),user.getLanguage()) ;
	String currencydescs = Util.toScreen(RecordSet.getString("currencydesc"),user.getLanguage()) ;
	String isdefaults = Util.null2String(RecordSet.getString("isdefault")) ;
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
    <TD><A href="FnaCurrenciesView.jsp?id=<%=ids%>"><%=currencynames%></A></TD>
    <TD><%=currencydescs%></TD>
    <TD>
	<% 
	int index = thecurrencyids.indexOf(ids) ;
	if(index != -1) { 
	String defcurrencyid = (String)defcurrencyids.get(index) ;
	String defcurrencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrencyid),user.getLanguage()) ;
	String exchangerage = (String)exchangerages.get(index) ;%>
	1 <%=defcurrencyname%> = <%=exchangerage%> <%=currencynames%>
	<%}%>
	</TD>
    <TD align=middle>
	<% if(activables.equals("1")) {%>
	<IMG src="/images/BacoCheck.gif">
	<%}%>
	</TD>
    <TD align=middle>
	<% if(isdefaults.equals("1")) {%>
	<IMG src="/images/BacoCheck.gif">
	<%}%></TD>
	</TR>
<%}%>
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
</BODY>
</HTML>
