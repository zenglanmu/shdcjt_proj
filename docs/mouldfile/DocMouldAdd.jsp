<%@ page language="java" contentType="text/html; charset=GBK" %>


<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

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
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid1= -1;
    if(detachable==1){
    	subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"));
        if(subcompanyid1 == -1){
            subcompanyid1 = user.getUserSubCompany1();
        }
    }
String urlfrom = Util.null2String(request.getParameter("urlfrom"));

String isUseET=BaseBean.getPropValue("weaver_obj","isUseET");

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else{
  titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16449,user.getLanguage());
}
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="0" colspan="3"></td>
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
<tr class=Spacing><td align="left" colspan="2">
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
        if("true"!="<%=isIE%>"){
            alert("当前浏览器不支持此功能，请使用IE访问");
            weaver.sdoctype[0].checked=true;
			return;
        }
        if(confirm("<%=SystemEnv.getHtmlLabelName(18691,user.getLanguage())%>")){
            location=doPage+'?urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&mouldname='+weaver.mouldname.value+'&docType='+docType;
        }else{
            weaver.sdoctype[0].checked=true;
		}
        return false;
    }   
</script>

<%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%>
</td><td class=Field>
<div >
<input TYPE="radio" NAME="sdoctype" checked >HTML&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>

<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('DocMouldAddExt.jsp','.doc')">WORD&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('DocMouldAddExt.jsp','.xls')">EXCEL&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('DocMouldAddExt.jsp','.wps')"><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>

<%if("1".equals(isUseET)){%>
<input TYPE="radio" NAME="sdoctype" onClick="onChangeDocType('DocMouldAddExt.jsp','.et')"><%=SystemEnv.getHtmlLabelName(24545,user.getLanguage())%>&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%}%>
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
  	<span id="docMouldExistedName"><%=docMouldExistedName%></span>
	</div>
  </td>
</tr>
<%if(urlfrom.equals("hr")){%>
<%if(detachable==1){%>
    <tr>
        <td ><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
        <td colspan=5 class=field >
                <BUTTON type="button" class=Browser id=SelectSubCompany onclick="onShowSubcompany()"></BUTTON>
            <SPAN id=subcompanyid1span> <%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid1))%>
            </SPAN>
		    <INPUT class=inputstyle id=subcompanyid1 type=hidden name=subcompanyid1 value="<%=subcompanyid1%>">
			
        </td>
    </tr>
    <tr class="Spacing" style="height: 1px"><td colspan=6 class="Line"></td></tr>
<%}%>
<%}%>
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

		</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>

<input type=hidden name=operation>
<input type=hidden name=urlfrom value="<%=urlfrom%>">
</FORM>
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
function onShowMould() {

	if("<%=urlfrom%>"=="hr"){
     data = window.showModalDialog("DocMouldtwoBrowser.jsp?doctype=.htm&subcompanyid1=<%=subcompanyid1%>","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data!=null){
		
		document.weaver.docMouldExistedId.value = data.id
		docMouldExistedName.innerHTML = "";
		
		location="/docs/mouldfile/DocMouldAdd.jsp?urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&mouldname="+document.weaver.mouldname.value+"&docMouldExistedId="+data.id;
	}
      
  }
else{
	var data = window.showModalDialog("DocMouldBrowser.jsp?doctype=.htm","","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if(data!=null){
		
		document.weaver.docMouldExistedId.value = data.id;
		docMouldExistedName.innerHTML = "";
		
		location="/docs/mouldfile/DocMouldAdd.jsp?mouldname="+document.weaver.mouldname.value+"&docMouldExistedId="+data.id;
	}
}
}
function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid1')){

		var editor_data = CKEDITOR.instances.mouldtext.getData();
		jQuery("#mouldname").val(editor_data);
		
		document.weaver.operation.value='add';
		document.weaver.submit();

	}
}

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
</script>
<script language="VBScript">
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=DocMouldAdd:Add&selectedids="&weaver.subcompanyid1.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = weaver.subcompanyid1.value then
		issame = true
	end if
	subcompanyid1span.innerHtml = id(1)
	weaver.subcompanyid1.value=id(0)
	else
	subcompanyid1span.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	weaver.subcompanyid1.value=""
	end if
	end if
end sub
</script>
</body>