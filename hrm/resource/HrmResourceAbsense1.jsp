<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String resourceid = Util.null2String(request.getParameter("resourceid")) ;

boolean isSelf	= resourceid.equals(""+user.getUID()) ;

char separator = Util.getSeparator() ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(1505,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<% if(!isSelf && !HrmUserVarify.checkUserRight("HrmResource:Absense1",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmResource:Absense1",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",/hrm/resource/HrmResourceAbsense1Add.jsp?resourceid="+resourceid+",_self} " ;
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
<TABLE class=ListStyle cellspacing=1 >
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=9><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <a href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></TH>
  </TR>
   <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="10%"><%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%></TD>
    <TD width="10%"><%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%></TD>
    <TD width="10%"><%=SystemEnv.getHtmlLabelName(1921,user.getLanguage())%></TD>
	<TD width="10%"><%=SystemEnv.getHtmlLabelName(1922,user.getLanguage())%></TD>
	<TD width="10%"><%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%></TD>
	<TD width="10%"><%=SystemEnv.getHtmlLabelName(1924,user.getLanguage())%></TD>
	<TD width="10%"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
	<TD width="10%"></TD>
  </TR>
  <TR class=Line><TD colspan="9" ></TD></TR> 
<%
int i=0;
RecordSet.executeProc("HrmAbsense1_SelectByResourceId",resourceid);

while(RecordSet.next()){
String id = RecordSet.getString("id");
String datefrom = RecordSet.getString("startdate");
String dateto = RecordSet.getString("enddate");
//与中文字串比较,用fromScreen2
String absensetype = Util.fromScreen2(RecordSet.getString("workflowname"),user.getLanguage());
int absenseday = (int)(RecordSet.getFloat("absenseday"));

if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%}%>
	<TD width="20%"><%=Util.toScreen(datefrom,user.getLanguage())%>-<%=Util.toScreen(dateto,user.getLanguage())%></TD>
    <TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(1919,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
    <TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(1920,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
    <TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(1921,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(1922,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(1923,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(1924,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals(SystemEnv.getHtmlLabelName(811,user.getLanguage()))) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<td><a href="HrmResourceAbsense1Edit.jsp?paraid=<%=id%>"><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></a></td>
</TR>
<%}
%>
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
</BODY>
</HTML>