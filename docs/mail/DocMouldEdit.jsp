<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("DocMailMouldEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
%>
<html><head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
<script language="javascript" src="/js/weaver.js"></script>
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
<jsp:useBean id="MailMouldManager" class="weaver.docs.mail.MailMouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
	MailMouldManager.setId(id);
	MailMouldManager.getMailMouldInfoById();
	String mouldname=MailMouldManager.getMailMouldName();
	String mouldtext=MailMouldManager.getMailMouldText();
	MailMouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+":"+mouldname;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:window.open(\\\"/email/MailTemplateTag.jsp\\\",null,\\\"height=600,width=500,scrollbar=true\\\"),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
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
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<tr style="height: 1px"><td class=Line colSpan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
<td width=85% class=field>
<input class=InputStyle size=70 name=mouldname  value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
<span id=mouldnamespan>
<%if(mouldname==null||mouldname.trim().equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
</span>

</td>
</tr>
<tr style="height: 1px"><td class=Line colSpan=2></td></tr>
</tbody>
</table>
<div id=imgfield>
</div>
<table class=ViewForm>
<tbody>
<tr><td width=15%>
<%=SystemEnv.getHtmlLabelName(681,user.getLanguage())%>
</td><td width=85%>
<!---####@2007-08-24 modify by yeriwei!
<div id=divimg name="divimg">
<input type=file class=InputStyle name=docimages_0 size="60"/>
</div>
<input type=hidden name=docimages_num value="0"/>
--->
</td></tr>
<tr style="height: 1px"><td class=Line colSpan=2></td></tr>
<%
int oldpicnum = 0;
int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload");
while(pos!=-1){
	pos = mouldtext.indexOf("?fileid=",pos);
	int endpos = mouldtext.indexOf("\"",pos);
	String tmpid = mouldtext.substring(pos+8,endpos);
	int startpos = mouldtext.lastIndexOf("\"",pos);
	//String servername = request.getServerName();
	//if(request.getServerPort()!=80)servername+=":"+request.getServerPort();
	String tmpcontent = mouldtext.substring(0,startpos+1);
	//tmpcontent += "http://"+servername;
	tmpcontent += mouldtext.substring(startpos+1);
	mouldtext=tmpcontent;
%>
<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
<%
	pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",endpos);
	oldpicnum += 1;
}
%>
<input type="hidden" name="olddocimagesnum" id="olddocimagesnum" value="<%=oldpicnum%>">

<tr><td colspan=2>
<textarea name="mouldtext" id="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>
<!--
<div id=divifrm style="display:;">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height:500px" id="dhtmlFrm"></iframe>
</div>
-->
</td>
</tr>
</TBODY>
</table>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
</form>
<!--####@2007-08-24 modify yeriwei!
<span id="thepretext" name="thepretext" style="display:none">
<%//mouldtext%>
</span>
<script FOR=window event="onload" LANGUAGE=javascript>
  document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=thepretext.innerHTML;
</script>
---->
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
		/***###@2007-08-24 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
			text = "<HTML><HEAD><META NAME='GENERATOR' Content='Weaver DHTML Editing Control'>"+
				   "<TITLE></TITLE></HEAD>"+text.substring(text.indexOf("<BODY>"), text.length) ;
		document.weaver.mouldtext.innerText=text;
		***/
		var editor_data = CKEDITOR.instances.mouldtext.getData();
		jQuery("#mouldname").val(editor_data);
		
		document.weaver.operation.value='edit';
		document.weaver.submit();
	}
}

/*
function onHtml(){
	if(document.weaver.mouldtext.style.display==''){
		text = document.weaver.mouldtext.innerText;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.mouldtext.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
        text = "<HTML><HEAD><META NAME='GENERATOR' Content='Weaver DHTML Editing Control'>"+
               "<TITLE></TITLE></HEAD>"+text.substring(text.indexOf("<BODY>"), text.length) ;
		document.weaver.mouldtext.innerText=text;
		document.weaver.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}
*/
</script>
</body>