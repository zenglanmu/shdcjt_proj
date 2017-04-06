<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>

<html>
<head>
<title></title>
<link rel="stylesheet" href="/css/frame.css" type="text/css">

<SCRIPT language=javascript>
function mnToggleleft(){
	with(window.parent.parent.document.getElementById("frameBottom")){
		if(cols == '0,100%'){
			cols = '50%,50%';
			window.document.getElementById("LeftHideShow").src = "/cowork/images/show.gif";
			window.document.getElementById("LeftHideShow").title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>'
		}else{
			cols = '0,100%';
			window.document.getElementById("LeftHideShow").src = "/cowork/images/hide.gif";
			window.document.getElementById("LeftHideShow").title = '<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>'
		}
	}
}

</SCRIPT>
</head>

<body bgcolor="white" onclick=mnToggleleft() >
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
document.body.oncontextmenu=""
document.body.onclick=mnToggleleft
</script>
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <td width="2" align=left valign=middle>
    <IMG id=LeftHideShow name=LeftHideShow title=<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%> style="CURSOR: hand"  src="/cowork/images/show.gif" width=6>
    </td>
</table>
</body>
</html>
