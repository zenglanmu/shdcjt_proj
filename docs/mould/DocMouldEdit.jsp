<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
%>
<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
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
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
	MouldManager.setId(id);
	MouldManager.getMouldInfoById();
	String mouldname=MouldManager.getMouldName();
	String mouldtext=MouldManager.getMouldText();
	MouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(16450,user.getLanguage())+"£º"+mouldname;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:openHelp(),_top} " ;
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
<tr style="height: 1px"><td class=Line1 colSpan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<tr style="height: 1px"><td class=Line colSpan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
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

<%
int oldpicnum = 0;
int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload");    

while(pos!=-1){    
     try {
       
            pos = mouldtext.indexOf("?fileid=",pos);
            if(pos == -1) {
                pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
                continue ;
            }
            int endpos = mouldtext.indexOf("\"",pos);
            String tmpid = mouldtext.substring(pos+8,endpos);

        %>
        <input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
        <%
            pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",endpos);
            oldpicnum += 1;    
    }catch(Exception ex){        
        System.out.println(ex);   
        pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload",pos+1);
        continue ;
    }
}

%>
<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">

<tr><td colspan=2>
<textarea name="mouldtext" id="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>

</tr>
</TBODY>
</table>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
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

		var editor_data = CKEDITOR.instances.mouldtext.getData();
		jQuery("#mouldname").val(editor_data);
		
		
		document.weaver.operation.value='edit';
		document.weaver.submit();
	}
}


function openHelp(){
    window.open('tag_help.jsp',null,'height=600,width=500,scrollbar=true')
}
</script>
</body>