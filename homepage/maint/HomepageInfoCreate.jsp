<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
    <link href="/css/Weaver.css" type=text/css rel=stylesheet>
  </head>
  
<body>
<%
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19100,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1876,user.getLanguage())+",javascript:preStep(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:nextStep(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
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
		
		<TABLE class="Shadow">
			<tr>
				<td valign="top">				
				 <TABLE class=viewform cellspacing=1>
					<COLGROUP>
					<COL width="30%">
					<COL width="70%">

					<TR class=Header>
						<TH colspan=2>请填写相关信息</TH>
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
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<!--
function preStep(){
	window.location='HomepageElementSele.jsp?subCompanyId=<%=subCompanyId%>';
}

function nextStep(){
	window.location='HomepageRight.jsp?subCompanyId=<%=subCompanyId%>';
}
//-->
</SCRIPT>