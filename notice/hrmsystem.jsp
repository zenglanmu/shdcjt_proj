<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<%
String sqlerror = Util.null2String(request.getParameter("sql")) ;
%>
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css">
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<DIV class="HdrTitle">
<TABLE width=100% border=0 cellpadding=0 cellspacing=0>
<TR><TD width=55px align=left><IMG src="/images/hdMaintenance.gif" height=24px></TD><TD align=left><SPAN style="font-size:medium; font-weight:bold"><%=SystemEnv.getHtmlLabelName(16139,user.getLanguage())%></SPAN></TD><TD align=right>&nbsp;</TD></TR>
</TABLE>
</DIV>
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


				<TABLE class=Form>
				<TR>
					<TD valign=top>
						<TABLE>
							<TR class=Section><TH style="font-size:8pt"><%=SystemEnv.getHtmlLabelName(19066,user.getLanguage())%></TH></TR>
							
							<TR><TD><%=SystemEnv.getHtmlLabelName(19067,user.getLanguage())%></TD></TR>
							
						</TABLE>
					</TD>
					
				</TR>
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