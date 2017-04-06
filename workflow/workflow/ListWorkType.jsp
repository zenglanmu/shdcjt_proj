<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	RecordSet.executeSql("select * from workflow_type order by dsporder");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16579,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
%>
	  <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",AddWorkType.jsp,_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%}%>
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


<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="30%">
  <COL width="50%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th>
  </tr>
  <tr class=Line><th></th><th></th><th ></th></tr>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="EditWorkType.jsp?id=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("typename"),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString("typedesc"),user.getLanguage())%></TD>
		<TD><%=Util.getIntValue(RecordSet.getString("dsporder"),0)%></TD>
	</TR>
<%
	}
%>
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
