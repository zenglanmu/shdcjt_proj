<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(389,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/finance/bank/HrmBankAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmBank:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+33+",_self} " ;
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
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
   <COL width="20%">
    <COL width="40%"> 
    <!-- COL width="40%" -->
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <!-- TD><%=SystemEnv.getHtmlLabelName(559,user.getLanguage())%></TD -->    
  </TR>
   
  <%
  int i=0;
  String bankid="";
  String bankname="";
  String bankdesc="";
  String checkstr="";
  while(BankComInfo.next()){
  	bankid=BankComInfo.getBankid();
  	bankname=BankComInfo.getBankname();
  	bankdesc=BankComInfo.getBankdesc();
  	checkstr=BankComInfo.getCheckstr();
  	%>
  	<tr <%if(i==0){%> class=datalight <%} else {%> class=datadark <%}%>>
  	   <td><a href="HrmBankEdit.jsp?id=<%=bankid%>"><%=Util.toScreen(bankname,user.getLanguage())%></a></td>
  	   <td><%=Util.toScreen(bankdesc,user.getLanguage())%></td>
  	   <!-- td><%=Util.toScreen(checkstr,user.getLanguage())%></td -->
  	</tr>
  	<%
  	if(i==0)   i=1;
  	else i=0;
  }
  %>
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
</body>
</html>