<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>

<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
<TITLE></TITLE>
</HEAD>

<BODY scroll="no" >
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<TABLE height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
<TR>
	<TD bgcolor="#B3B3B3" align="center" valign="middle">
        <img  name="ViewInfo" src="/images/HomePageShow.gif" onclick="javascript:pdocTogglebottom()" border="0" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>">
    </TD>
</TR>	
</TABLE>
</BODY>
</HTML>

<SCRIPT language="javascript">
function pdocTogglebottom() {    
	var f = window.parent.pdocMain;
	if (f != null) {      
		var c = f.cols;		
		if (c == "175,6,*") {
			f.cols = "0,6,*";
			document.all("ViewInfo").src="/images/HomePageHidden.gif";
			document.all("ViewInfo").title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>";
		} else { 
			f.cols = "175,6,*";
			document.all("ViewInfo").src="/images/HomePageShow.gif";
			document.all("ViewInfo").title="<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>";
		}
	}
}
</SCRIPT>



