<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver.css">
</HEAD>

<%
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
%>
<script language="JavaScript">
<%if(isovertime==1){%>
        window.opener.location.href=window.opener.location.href;
<%}%>
</script>
<BODY>
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
		<TABLE width='100%'>
		<tr>
		<td valign="top">

			<TABLE class=ViewForm>
			<TR>
				<TD valign=top>
					<TABLE>
						<TR class=Section><TH style="font-size:8pt"> <%=SystemEnv.getHtmlLabelName(2012,user.getLanguage())%></TH></TR>
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