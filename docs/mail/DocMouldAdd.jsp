<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("DocMailMouldAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
%>
<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<!-- 
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
 -->
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<script language="javascript" type="text/javascript">
jQuery(document).ready(function(){

	var lang=<%=(user.getLanguage()==8)?"true":"false"%>;


	//FCKEditorExt.initEditor('weaver','mouldtext',lang);
	CkeditorExt.initEditor('weaver','mouldtext',lang,'',500)
})


</script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:window.open(\\\"/email/MailTemplateTag.jsp\\\",null,\\\"height=600,width=500\\\"),_top} " ;
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
		<table class=Shadow>
		<tr>
		<td valign="top">
<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">

<br>
<table class=ViewForm>
<tbody>
<tr class=Spacing><td align=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</td></tr>
<tr class=Spacing style="height: 1px"><td class=Line1 colspan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
<td width=85% class=field>
<input class=InputStyle size=70 name=mouldname onChange="checkinput('mouldname','mouldnamespan')">
<span id=mouldnamespan><img src="/images/BacoError.gif" align=absMiddle></span>

</td>
</tbody>
</table>
<div id=imgfield>
</div>
<table class=ViewForm>
<colgroup>
  <col width="15%">
  <col width=85%>

<tbody>
<!--###@2007-08-27 modify by yeriwei
<tr><td class=Line colSpan=2></td></tr>
<tr><td>
<%=SystemEnv.getHtmlLabelName(681,user.getLanguage())%>
</td><td>
<div id=divimg name="divimg">
<input type=file class=InputStyle name=docimages_0 size=60></input>
</div>
<input type=hidden name=docimages_num value=0></input>
</td></tr>
<tr><td class=Line colSpan=2></td></tr>
-->

<tr><td colspan=2>
<textarea id="mouldtext" name=mouldtext style="display:none;width:100%;height:500px"></textarea>
<!--###@2007-08-27 modify by yeriwei!
<div id="divifrm" style="display:;">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height:500px" id="dhtmlFrm"></iframe>
</div>
-->
</td>
</tr>
</tbody>
</table>
<input type=hidden name=operation>
</form>

		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<script>
function switchEditMode(ename){
	
	var oEditor = CKEDITOR.instances.mouldtext;
	oEditor.execCommand("source");
}
function onSave(){
	if(check_form(document.weaver,'mouldname')){
	/*###@2007-07-27 modify by yeriwei 
	text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
	text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
	document.weaver.mouldtext.value=text;
	*/
	//FCKEditorExt.updateContent();
	var editor_data = CKEDITOR.instances.mouldtext.getData();
	jQuery("#mouldname").val(editor_data);
	document.weaver.operation.value='add';
	document.weaver.submit();
	/***##@2007-08-27 modify by yeriwei
//	alert(text);
	number=0;
	startpos=text.indexOf("src=\"");
	while(startpos!=-1){
		endpos=text.indexOf("\"",startpos+5);
	//	alert(startpos+'shit'+endpos);
		curpath = text.substring(startpos+5,endpos);
		number++;
	//	alert(curpath);
	//	var oDiv = document.createElement("div");
	//	var sHtml = "<input type='file' size='25' name='docimages"+number+"' value="+curpath+">";
	//	var sHtml = "<input type='file' size='25' name='docimages"+number+"' value='c:\\'>";
	//	oDiv.innerHTML = sHtml;
	//	imgfield.appendChild(oDiv);
		startpos = text.indexOf("src=\"",endpos);
	}
	***/
	}
}

/****###@2007-08-27 modify by yeriwei!
function onHtml(){
	if(document.weaver.mouldtext.style.display==''){

		text = document.weaver.mouldtext.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.mouldtext.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.mouldtext.value=text;
		document.weaver.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
**/
</script>
</body>