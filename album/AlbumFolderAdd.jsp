<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
int id = Util.getIntValue(request.getParameter("id"));

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(92,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<html>
<head>
<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript">
function doSubmit(){
	if(check_form(weaver,'folderName')){
		$("weaver").submit();
	}
}
</script>
<link rel="stylesheet" type="text/css" href="/css/Weaver.css" />
<style type="text/css" media="screen">
input{width:90%;}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<table class="Shadow">
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="AlbumFolderOperation.jsp" id="weaver" name="weaver">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="parentId" value="<%=id%>" />
<table class="ViewForm">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr>
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="folderName" class="inputstyle" maxlength="20" onchange="checkinput('folderName','folderNameSpan')" />
		<SPAN id="folderNameSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
	</td>
</tr>
<tr  style="height:2px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="photoDescription" class="inputstyle" maxlength="20" />
	</td>
</tr>
<tr  style="height:2px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="orderNum" class="inputstyle" maxlength="3" />
	</td>
</tr>
<tr  style="height:2px"><td class="Line" colspan="2"></td></tr>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>