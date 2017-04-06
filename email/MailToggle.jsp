<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ include file="/systeminfo/init.jsp" %>
<html> 
<head>
<title></title>
<script type="text/javascript">
function mnToggleleft(obj){
	var frameSet = window.parent.document.getElementById("mailFrameSet");
	if($("#showFrame").attr("show")=="true"){
			$("#showFrame").removeClass("frmCenterOpen");
			$("#showFrame").addClass("frmCenterClose");
			frameSet.cols = "0,8,*";
			$("#showFrame").attr("show","false");
	}else{
			$("#showFrame").removeClass("frmCenterClose");
			$("#showFrame").addClass("frmCenterOpen");
			frameSet.cols = "160,8,*";
			$("#showFrame").attr("show","true");
	}
}
</script>
</head>
<body id="showFrame" class="frmCenterOpen" onclick="mnToggleleft(this)" show="true" >
</body>
</html>