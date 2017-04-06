<%@ page import="weaver.general.Util,weaver.hrm.User,weaver.rtx.RTXConfig" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<script type="text/javascript" src="/js/EimUtil.js"></script>
<script type="text/javascript">
	function on_load(){
		if('sysadmin' == '<%=user.getLoginid() %>'){
			alert('<%=SystemEnv.getHtmlLabelName(27462,user.getLanguage())%>');
			return;
		}
		if(EimUtil.isInstall()){
			EimUtil.engine.Runeim('<%=user.getLoginid() %>', '<%=(String)session.getAttribute("password") %>');
		}else{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(27461,user.getLanguage())%>")){
				window.open('/weaverplugin/PluginMaintenance.jsp',"","height=800,width=600,scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
			}
		}
	}
</script>
</HEAD>

<BODY onLoad="on_load()">
</BODY>
</HTML>
