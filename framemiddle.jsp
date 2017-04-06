<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=gbk">
<link rel="stylesheet" href="/css/frame.css" type="text/css">

<SCRIPT language=javascript>
function mnToggleleft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 			
			document.getElementById("mybody").title = '<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>'
				document.getElementById("mybody").className="frmCenterClose";
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
			document.getElementById("mybody").title = '<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>'
				document.getElementById("mybody").className="frmCenterOpen";
		}
	}
}

</SCRIPT>
</head>

<body class="frmCenterOpen" id="mybody">
<script>
document.body.oncontextmenu=""
document.body.onclick=mnToggleleft
</script>
</html>
