<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CptRpSumManage" class="weaver.cpt.report.CptRpSumManage" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(63,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
CptRpSumManage.setOptional("capitalcustomerid") ;
CptRpSumManage.getRpResult() ;
%>
	
<TABLE class=Form width="100%">
  <TBODY>
  <TR class=Section>
    <TH><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1></TD></TR></TBODY></TABLE>
<TABLE class=ListShort width="100%">
  <COLGROUP> 
  <COL align=left width="20%"> 
  <COL align=left width="50%"> 
  <COL align=right width="15%"> 
  <COL align=right width="15%"> 
  <TBODY> 
  <TR class=Header> 
    <TH><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
  </TR>
  <%
	int i=0;
	while(CptRpSumManage.next())  { 
		  String resultid = CptRpSumManage.getResultID();
		  String resultcount = CptRpSumManage.getResultCount();
		  String resultpercent = CptRpSumManage.getResultPercent() ;
		  String imagepercent = CptRpSumManage.getImagePercent() ;
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
  <TR class=datadark> 
    <TD><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(resultid),user.getLanguage())%></TD>
    <TD> 
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY> 
        <TR> 
          <a href="/cpt/search/SearchOperation.jsp?customerid=<%=resultid%>&operation=search">
          <TD class=redgraph <%if(Util.getFloatValue(imagepercent.substring(0,imagepercent.length()-1),0)>=1){%>width="<%=imagepercent%>"<%} else {%>width="1" <%}%> style="CURSOR:HAND">&nbsp;</TD></a>
          <TD>&nbsp;</TD>
        </TR>
        </TBODY>
      </TABLE>
    </TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%></TD>
  </TR>
  <% } %>
  </TBODY>
</TABLE>
</BODY></HTML>
