<%@ page language="java" contentType="text/html; charset=GBK" %>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mould.DocMouldComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("DocMouldAdd:Add", user)){
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
<%
String docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".htm";
}
String  mouldname=Util.null2String(request.getParameter("mouldname"));
String docMouldExistedId=Util.null2String(request.getParameter("docMouldExistedId"));
if(docMouldExistedId==null||"0".equals(docMouldExistedId)) docMouldExistedId = "";
String docMouldExistedName = "";
String docMouldExistedText = "";
if(!docMouldExistedId.equals("")){
	MouldManager.setId(Util.getIntValue(docMouldExistedId,0));
	MouldManager.getMouldInfoById();
	docMouldExistedText = MouldManager.getMouldText();
	docMouldExistedName = MouldManager.getMouldName(); 
	MouldManager.closeStatement();
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16450,user.getLanguage());
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
<colgroup>
  <col width="15%">
  <col width=85%>
<tbody>
<tr class=Spacing><td aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</td></tr>
<tr class=Spacing style="height: 1px"><td class=Line1 colspan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<input class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
<span id=mouldnamespan><%if(mouldname==null||"".equals(mouldname)){%><img src="/images/BacoError.gif" align=absMiddle><%}%></span>

</td>
<tr style="height: 1px">
	<td class=Line colSpan=2></td>
</tr>
</tbody>
</table>
<div id=imgfield>
</div>
<table class=ViewForm>
<colgroup>
  <col width="15%">
  <col width=85%>

<tbody>
<tr><td>

<script language=javascript>
    function onChangeDocType(doPage,docType){	
        if(confirm("<%=SystemEnv.getHtmlLabelName(18691,user.getLanguage())%>")){
            location=doPage+'?mouldname='+document.weaver.mouldname.value+'&docType='+docType;
        }else{
            weaver.sdoctype[0].checked=true;
		}
        return false;
    }   
</script>

<%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%>
</td><td class=field>
<div >
<input TYPE="radio" NAME="sdoctype" checked >HTML&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<%if("true".equals(isIE)){ %>
<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('DocMouldAddExt.jsp','.doc')">WORD&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('DocMouldAddExt.jsp','.wps')"><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=SystemEnv.getHtmlLabelName(16450,user.getLanguage())%>
<%} %>
</div>
</td></tr>

<tr style="height: 1px">
	<td class=Line colSpan=2></td>
</tr>

<tr>
  <td><%=SystemEnv.getHtmlLabelName(19333,user.getLanguage())%></td>
  <td class=Field>
	<div >
    <button class=Browser type="button" onClick="onShowMould();"></button><input class="InputStyle" type="hidden" name="docMouldExistedId" value="<%=docMouldExistedId%>">
  	<span id="docMouldExistedName"><a href="DocMouldDsp.jsp?id=<%=docMouldExistedId%>"><%=docMouldExistedName%></a></span>
	</div>
  </td>
</tr>

<tr style="height: 1px">
	<td class=Line colSpan=2></td>
</tr>


<%
if(!docMouldExistedId.equals("")){
	int oldpicnum = 0;
	int pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload");    
	
	while(pos!=-1){    
	     try {
	            pos = docMouldExistedText.indexOf("?fileid=",pos);
	            if(pos == -1) {
	                pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload",pos+1);
	                continue ;
	            }
	            int endpos = docMouldExistedText.indexOf("\"",pos);
	            String tmpid = docMouldExistedText.substring(pos+8,endpos);

	        %>
	        <input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
	        <%
	            pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload",endpos);
	            oldpicnum += 1;    
	    }catch(Exception ex){        
	        pos = docMouldExistedText.indexOf("/weaver/weaver.file.FileDownload",pos+1);
	        continue ;
	    }
	}
%>
<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
<% } %>
<tr><td colspan=2>
<textarea name="mouldtext" id="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(docMouldExistedText)%></textarea>

</td></tr>
</TBODY>
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
var opts={
		_dwidth:'550px',
		_dheight:'550px',
		_url:'about:blank',
		_scroll:"no",
		_dialogArguments:"",
		
		value:""
	};
var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
opts.top=iTop;
opts.left=iLeft;
function onShowMould(){
	data = window.showModalDialog("DocMouldBrowser.jsp?doctype=.htm","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data!=null){
		
		document.weaver.docMouldExistedId.value = data.id
		docMouldExistedName.innerHTML = "<a href='DocMouldDsp.jsp?id="+data.id+"'>"+data.name+"</a>";
		
		location="/docs/mould/DocMouldAdd.jsp?mouldname="+document.weaver.mouldname.value+"&docMouldExistedId="+data.id;
	}
}
function onSave(){
	if(check_form(document.weaver,'mouldname')){

		var editor_data = CKEDITOR.instances.mouldtext.getData();
		jQuery("#mouldname").val(editor_data);
		
		document.weaver.operation.value='add';
		document.weaver.submit();

	}//End if.
	
}

function openHelp(){
    window.open('/docs/mould/tag_help.jsp',"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
}
</script>
</body>