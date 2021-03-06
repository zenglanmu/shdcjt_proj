<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
%>
<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
window.onload=function(){
	//FCKEditorExt.initEditor('weaver','mouldtext',lang);
};
</script>

</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%

//编辑：王金永
String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"),-1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

int id = Util.getIntValue(request.getParameter("id"),0);

String urlfrom = Util.null2String(request.getParameter("urlfrom"));

MouldManager.setId(id);
MouldManager.getMouldInfoById();
String mouldname=MouldManager.getMouldName();
String mouldtext=MouldManager.getMouldText();
int mouldType = MouldManager.getMouldType();
String docType=".doc";
if(mouldType==2){
    docType=".doc";
}else if(mouldType==3){
    docType=".xls";
}else if(mouldType==4){
    docType=".wps";
}else if(mouldType==5){
    docType=".et";
}else{
    docType=".doc";
}


MouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(64,user.getLanguage());
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"："+mouldname;
}
String needfav ="1";
String needhelp ="";
%>

<script language="javascript" >

function StatusMsg(mString){
  StatusBar.innerText=mString;
}

function WebSaveLocal(){
  try{
    weaver.WebOffice.WebSaveLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){}
}

function WebOpenLocal(){
  try{
    weaver.WebOffice.WebOpenLocal();
    StatusMsg(weaver.WebOffice.Status);
  }catch(e){
  }
}

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=id%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
  //weaver.WebOffice.EditType="1";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.EditType="3,1";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
//iWebOffice2006 特有内容结束
<%}else{%>
  weaver.WebOffice.EditType="3";
<%}%>
  weaver.WebOffice.UserName="<%=user.getUsername()%>";
  weaver.WebOffice.WebOpen();  	//打开该文档
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.ShowType="1";  //文档显示方式  1:表示文字批注  2:表示手写批注  0:表示文档核稿
//iWebOffice2006 特有内容结束
<%}%>
  StatusMsg(weaver.WebOffice.Status);

  }catch(e){}
}



function UnLoad(){
  try{
  if (!weaver.WebOffice.WebClose()){
     StatusMsg(weaver.WebOffice.Status);
  }else{
     StatusMsg("关闭文档...");
  }
  }catch(e){}
}

function changeFileType(xFileType){
	if(xFileType==".docx"||xFileType==".dot"){
		xFileType=".doc";
	}else if(xFileType==".xlsx"||xFileType==".xlt"||xFileType==".xlw"||xFileType==".xla"){
		xFileType=".xls";
	}else if(xFileType==".pptx"){
		xFileType=".ppt";
	}
	return xFileType;
}

function SaveDocument(){
    weaver.WebOffice.WebSetMsgByName("SAVETYPE","EDIT");

    var tempFileName=document.all("mouldname").value;
	tempFileName=tempFileName.replace(/\\/g,'＼');
	tempFileName=tempFileName.replace(/\//g,'／');
	tempFileName=tempFileName.replace(/:/g,'：');
	tempFileName=tempFileName.replace(/\*/g,'×');
	tempFileName=tempFileName.replace(/\?/g,'？');
	tempFileName=tempFileName.replace(/\"/g,'“');
	tempFileName=tempFileName.replace(/</g,'＜');
	tempFileName=tempFileName.replace(/>/g,'＞');
	tempFileName=tempFileName.replace(/\|/g,'｜');
	tempFileName=tempFileName.replace(/\./g,'．');
	tempFileName = tempFileName+'<%=docType%>';
    document.getElementById("WebOffice").FileName=tempFileName;

    weaver.WebOffice.FileType=changeFileType(weaver.WebOffice.FileType);

    if (!weaver.WebOffice.WebSave(<%=isNoComment%>)){
        StatusMsg(weaver.WebOffice.Status);
        alert("文档保存错误！");
        return false;
    }else{
        StatusMsg(weaver.WebOffice.Status);
        return true;
    }
}

</script>
<body onLoad="Load()" onUnload="UnLoad()">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16381,user.getLanguage())+",javascript:WebOpenLocal(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16382,user.getLanguage())+",javascript:WebSaveLocal(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?urlfrom="+urlfrom+",_self} " ;
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
<input type=hidden name=urlfrom value="<%=urlfrom%>">

<br>
<table class=ViewForm>
<tbody>
<tr class=Spacing><td aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</td></tr>
<tr class=Spacing><td class=Line1 colspan=2></td></tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<tr>
	<td class=Line colSpan=2></td>
</tr>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<input class=InputStyle size=70 name=mouldname  value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
<span id=mouldnamespan>
<%if(mouldname==null||mouldname.trim().equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
</span>

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
    <tr class="Spacing"><td colspan=6 class="Line"></td></tr>
<%}%>
<%}%>
<tr>
	<td class=Line1 colSpan=2></td>
</tr>
</tbody>
</table>
<div id=imgfield>
</div>
<table class=ViewForm>
<tbody>
<tr><td>

</td><td>
<!--##@2007-08-27 modify by yeriwei!
<div id=divimg name="divimg" style="display:none">
<input type="file" class="InputStyle" name="docimages_0" size="60">
</div>
<input type="hidden" name="docimages_num" value="0">
-->
</td></tr>
<%
int oldpicnum = 0;
int pos = mouldtext.indexOf("<img alt=\"");
while(pos!=-1){
	pos = mouldtext.indexOf("?fileid=",pos);
	int endpos = mouldtext.indexOf("\"",pos);
	String tmpid = mouldtext.substring(pos+8,endpos);
	int startpos = mouldtext.lastIndexOf("\"",pos);
	String servername = request.getServerName();
	String tmpcontent = mouldtext.substring(0,startpos+1);
	tmpcontent += "http://"+servername;
	tmpcontent += mouldtext.substring(startpos+1);
	mouldtext=tmpcontent;
%>
<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
<%
	pos = mouldtext.indexOf("<img alt=\"",endpos);
	oldpicnum += 1;
}
%>
<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">

<tr><td colspan="2">

<textarea name="mouldtext" style="display:none;width:100%;height:500px"><%=Util.encodeAnd(mouldtext)%></textarea>
<!--##@2007-08-27 modify by yeriwei!
<div id=divifrm style="display:;">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height:500px;display:none" id="dhtmlFrm"></iframe>
</div>
-->
</td>
</tr>
<tr><td colspan = 2>
<div style="POSITION: relative;width:100%;height:660;OVERFLOW:hidden;">
    <object  id="WebOffice" style="POSITION: relative;top:-20" width="100%"  height="680"  value="" classid="<%=mClassId%>" codebase="<%=mClientUrl%>" >
    </object>
</div>
</td></tr>
<tr><td colspan = 2>
    <span id=StatusBar>&nbsp;</span>
</td></tr>


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
function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid1')){
	document.weaver.operation.value='edit';
	if(SaveDocument()){
    	document.weaver.submit();
    }
	}
}

</script>
<script language="VBScript">
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=DocMouldEdit:Edit&selectedids="&weaver.subcompanyid1.value)
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