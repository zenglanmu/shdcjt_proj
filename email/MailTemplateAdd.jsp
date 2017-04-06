<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
String showTop = Util.null2String(request.getParameter("showTop"));
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<head>
<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
window.onload = function(){
	CkeditorExt.initEditor('fMailTemplate','mouldtext',lang);
}
</script>
<script type="text/javascript">
function doSubmit(){
	if(check_form(fMailTemplate,'templateName')){
	with(document.getElementById("fMailTemplate")){
		/***###@2007-08-29 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.fMailTemplate.mouldtext.value=text;
		***/
		CkeditorExt.updateContent();
		
		submit();
	}}
}
/**
function onHtml(){
	if(document.fMailTemplate.mouldtext.style.display==''){
		text = document.fMailTemplate.mouldtext.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.fMailTemplate.mouldtext.style.display='none';
		divifrm.style.display='';
	}else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.fMailTemplate.mouldtext.value=text;
		document.fMailTemplate.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
**/
</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
</head>
<body>
<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:CkeditorExt.switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:window.open(\\\"MailTemplateTag.jsp\\\",null,\\\"height=600,width=500,scrollbar=true\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">

<tr>
	<td valign="top">
		<table class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailTemplateOperation.jsp" id="fMailTemplate" name="fMailTemplate" enctype="multipart/form-data">
<input type="hidden" name="operation" value="add" />
<input type="hidden" name="userid" value="<%=request.getParameter("userid")%>" />
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<table class="ViewForm">
<colgroup>
<col width="25%">
<col width="75%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="templateName" class="inputstyle" style="width:90%" onChange="checkinput('templateName','templateNameSpan')" />
		<span id="templateNameSpan"><img src='/images/BacoError.gif' align="absMiddle"></span>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="templateDescription" class="inputstyle" style="width:100%" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19853,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="templateSubject" class="inputstyle" style="width:100%" />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<!---###@2007-08-29 modify by yeriwei!
<tr>
	<td><%//SystemEnv.getHtmlLabelName(74,user.getLanguage())%></td>
	<td class="Field">
		<div id=divimg name="divimg"><input type=file class=InputStyle name=docimages_0 size="55"></input></div>
		<input type=hidden name=docimages_num value=0></input>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
-->

<tr>
	<td colspan="2">
	<textarea name="mouldtext" style="display:none;width:100%;height:500px"></textarea>
	<!--###@2007-08-29 modify by yeriwei!
	<div id=divifrm style="display:;">
	<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height=300px" id="dhtmlFrm"></iframe>
	</div>
	-->
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<!--
<tr>
	<td>附件</td>
	<td class="Field">
		<input type="file" name="templateAttachment" class="inputstyle" size="40" />&nbsp;
		<button class="btnNew" accesskey="A"><u>A</u>-添加</button>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
-->
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>

</table>
</body>
</html>