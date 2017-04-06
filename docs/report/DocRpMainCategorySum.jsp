<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<jsp:useBean id="DocRpSumManage" class="weaver.docs.report.DocRpSumManage" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;

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

DocRpSumManage.setOptional("maincategory") ;
DocRpSumManage.getRpResult(""+user.getUID());
/******************************************************/
	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(16605,user.getLanguage()),700,500,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();
/****************************************************/
%>
	

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="15%">
  <COL align=left width="28%">
  <COL align=right width="7%">
  <COL align=right width="7%">
  <COL align=left width="23%">
  <COL align=right width="6%">
  <COL align=right width="6%">
  <COL align=right width="6%">
  <COL align=right width="6%">
  <TBODY>

  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    <TH><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></TH>
    <TH>%</TH>
    <TH><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TH>
    <TH>%</TH></TR>
<TR class=Line><TD colSpan=9></TD></TR>
	<%  while(DocRpSumManage.next())  { 
		  String resultid = DocRpSumManage.getResultID();
		  String resultcount = DocRpSumManage.getResultCount();
		  String resultpercent = DocRpSumManage.getResultPercent() ;
		  String normalpercent = DocRpSumManage.getNormalPercent() ;
		  String normalcount =  DocRpSumManage.getNormalCount() ;
		  String replycount =  DocRpSumManage.getReplyCount() ;
		  String replypercent =  DocRpSumManage.getReplyPercent() ;
		pie.addSeries(Util.toScreen(MainCategoryComInfo.getMainCategoryname(resultid),user.getLanguage()),Integer.parseInt(resultcount));
	%>
  <TR class=datadark>
    <TD><A 
      href="DocRpSubCategorySum.jsp?id=<%=resultid%>"><%=Util.toScreen(MainCategoryComInfo.getMainCategoryname(resultid),user.getLanguage())%></A></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=redgraph <%if(Util.getFloatValue(resultpercent.substring(0,resultpercent.length()-1),0)>=1){%>width="<%=resultpercent%>"<%} else {%>width="1" <%}%> >&nbsp;</TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=bluegraph width="<%=normalpercent%>" <%if("0%".equals(normalpercent)) out.println("style='display:none'");%>>&nbsp;</TD>
          <TD class=greengraph width="<%=replypercent%>" <%if("0%".equals(replypercent)) out.println("style='display:none'");%>>&nbsp;</TD>
		</TR></TBODY></TABLE></TD>
    <TD><%=normalcount%></TD>
    <TD><%=normalpercent%></TD>
    <TD><%=replycount%></TD>
    <TD><%=replypercent%></TD></TR>
	<% } 
	%>
  </TBODY></TABLE>
<div class="chart">

<%
if ("true".equals(isIE)){
	pie.print(out);
}else{   %>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
</p>
<%} %>	

<br>
</div>
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
          
</BODY></HTML>
