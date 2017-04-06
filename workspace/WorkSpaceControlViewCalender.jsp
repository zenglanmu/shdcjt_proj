<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
<TITLE></TITLE>
</HEAD>

<BODY scroll="no" >
<TABLE width="6" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="6">
<TR>
	<TD bgcolor="#B3B3B3" valign="middle">
		<img id="ViewCalender" name="ViewCalender" src="/images/HomePageHidden.gif" onclick="javascript:workPlanToggleleft()" border="0" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>">
	</TD>
</TR>	
</TABLE>
</BODY>
</HTML>

<SCRIPT language="javascript">
function workPlanToggleleft() {
	var f = window.parent.workspace;
	if (f != null) {
		var c = f.cols;
		if (c == "*,6,0") {
			f.cols = "*,6,200";
			document.all("ViewCalender").src="/images/HomePageHidden.gif";
			document.all("ViewCalender").title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";
		} else { 
			f.cols = "*,6,0";
			document.all("ViewCalender").src="/images/HomePageShow.gif";
			document.all("ViewCalender").title="<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";
		}
	}
}

</SCRIPT>