<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
if(!HrmUserVarify.checkUserRight("WorkflowMonitor:All",user)) 
{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(2239,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
	<%
	if(user.getUID()==1)
	{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",MonitorTypeAdd.jsp,_self}" ;
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
					<TABLE class=liststyle cellspacing=1  >
					  <COLGROUP>
					  <COL width="10%">
					  <COL width="30%">
					  <COL width="60%">
					  <TBODY>
					  <TR class="Header">
					    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(2239,user.getLanguage())%></TH>
					  </TR>
					
					  <TR class=Header>
					    <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
					    <TD><%=SystemEnv.getHtmlLabelName(15520,user.getLanguage())%></TD>
					    <TD><%=SystemEnv.getHtmlLabelName(15521,user.getLanguage())%></TD>
					  </TR><tr class="Line"><td colspan="3"></td></tr>
					<%
					    rs.executeSql("select * from Workflow_MonitorType");
					    int needchange = 0;
					    while(rs.next())
					    {
					       	if(needchange ==0)
					       	{
					       		needchange = 1;
					%>
					  <TR class=datalight>
					<%
					  		}
					       	else
					  		{
					  			needchange=0;
					%>
					  <TR class=datadark>
					<%  	
					  		}
					%>
					    <TD><a href='MonitorTypeEdit.jsp?id=<%=rs.getString("id")%>'><%=rs.getString("id")%></a></TD>
					    <TD><a href='MonitorTypeEdit.jsp?id=<%=rs.getString("id")%>'><%=Util.toScreen(rs.getString("typename"),user.getLanguage())%></a></TD>
					    <TD><%=Util.toScreen(rs.getString("typedesc"),user.getLanguage())%></TD>
					  </TR>
					<%
						}
					%>  
					 </TBODY></TABLE>
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
