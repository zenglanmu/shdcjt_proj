<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("FnaCurrency_SelectByID",id);
RecordSet.next();
String currencyname = Util.toScreen(RecordSet.getString("currencyname"),user.getLanguage());
String currencydesc = Util.toScreen(RecordSet.getString("currencydesc"),user.getLanguage());
String activable = Util.null2String(RecordSet.getString("activable"));
String isdefault = Util.null2String(RecordSet.getString("isdefault"));

boolean canedit = HrmUserVarify.checkUserRight("FnaCurrenciesEdit:Edit", user) ;
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(406,user.getLanguage())+" : "+ currencyname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/fna/maintenance/FnaCurrenciesEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaCurrenciesAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/maintenance/FnaCurrenciesAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaCurrencies:Log",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+39+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{-}" ;
if(HrmUserVarify.checkUserRight("FnaCurrencyExchangeAdd:Add",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+SystemEnv.getHtmlLabelName(588,user.getLanguage())+",/fna/maintenance/FnaCurrencyExchangeAdd.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaCurrencyExchange:Log",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(22047,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+40+" and relatedid="+id+",_self} " ;
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
<TABLE class=viewForm id=tblCurrency>
  <THEAD> 
  <COLGROUP> 
  <COL width="20%"> 
  <COL width="80%"> 
  <TR class=title> 
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
  </TR>
  </THEAD> <TBODY> 
  <TR style="height:1px;"> 
    <TD class=line1 colSpan=2></TD>
  </TR>
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD class=Field><B><%=currencyname%></B> </TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TD>
    <TD class=Field><%=currencydesc%></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  <tr> 
    <td><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%></td>
    <td class=Field><% if(activable.equals("1")) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
    </td>
  </tr>
  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  <TR> 
    <TD><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></TD>
    <TD class=Field><% if(isdefault.equals("1")) {%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%} else {%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
    </TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
  </TBODY> 
</TABLE>
<br>
<TABLE class=viewForm>
  <COLGROUP> 
  <COL width="45%"> 
  <COL width="10%"> 
  <COL width="15%"> 
  <COL width="30%"> 
  <TBODY> 
  <TR class=title> 
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(588,user.getLanguage())%></TH>
  </TR>
  <TR> 
  </TR>
  <TR> 
    <TD> 
    
    </TD>
  </TR>
  </TBODY>
</TABLE>

<table class=ListStyle cellspacing=1  style="WIDTH: 100%">
  <colgroup> 
  <col width="25%"> 
  <col width="35%"> 
  <col width="35%">  
  <tbody> 
  <tr class=Header> 
    <td><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
    <td style="TEXT-ALIGN: center" colspan=2><%=SystemEnv.getHtmlLabelName(588,user.getLanguage())%></td>
  </tr>
  <tr class=Header> 
    <td>&nbsp;</td>
    <td style="TEXT-ALIGN: left"><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></td>
    <td style="TEXT-ALIGN: left"><%=SystemEnv.getHtmlLabelName(1460,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="48" ></TD></TR> 
<%
int i = 0 ;
 RecordSet.executeProc("FnaCurrencyExchange_SByCurrenc",id) ;
 while(RecordSet.next()) {
 	String ids = Util.null2String(RecordSet.getString("id")) ;
	String defcurrencyids = Util.null2String(RecordSet.getString("defcurrencyid")) ;
	String defcurrencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrencyids),user.getLanguage()) ;
	String fnayears = Util.null2String(RecordSet.getString("fnayear")) ;
	String periodsids = Util.null2String(RecordSet.getString("periodsid")) ;
	String avgexchangerates = Util.null2String(RecordSet.getString("avgexchangerate")) ;
	String endexchangerages = Util.null2String(RecordSet.getString("endexchangerage")) ;
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
    <td><a 
      href="FnaCurrencyExchangeEdit.jsp?id=<%=ids%>"><%=fnayears%> - <%=periodsids%></a></td>
    <td>1 <%=defcurrencyname%> = <%=avgexchangerates%> <%=currencyname%></td>
    <td>1 <%=defcurrencyname%> = <%=endexchangerages%> <%=currencyname%></td>
  </tr>

 <%}%>
  </tbody> 
</table>
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
