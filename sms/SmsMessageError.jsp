<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,
                 java.sql.Timestamp" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</HEAD>
<%
    String imagefilename = "/images/hdReport.gif";
    String titlename = SystemEnv.getHtmlLabelName(2220, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
	int noback = Util.getIntValue(request.getParameter("noback"), 0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(noback != 1){
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/sms/SmsMessageEdit.jsp,_self} ";
    RCMenuHeight += RCMenuHeightStep;
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

			<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
			<TABLE width="100%" height="100%">
				<TR><TD align=center style="font-size: 36pt;">∂Ã–≈∑¢ÀÕ ß∞‹</TD></TR>
			</TABLE>
			</DIV>

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

</FORM>

</BODY>
</HTML>
