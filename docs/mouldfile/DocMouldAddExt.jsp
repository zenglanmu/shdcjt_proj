<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ include file="/docs/docs/iWebOfficeConf.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DocMouldAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String  docType=Util.null2String(request.getParameter("docType"));
if(docType.equals("")){
    docType=".doc";
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
//int subcompanyid1= -1;
int subcompanyid1 = Util.getIntValue(request.getParameter("subcompanyid1"));
    if(detachable==1){
        if(subcompanyid1 == -1){
            subcompanyid1 = user.getUserSubCompany1();
        }
    }
String  mouldname=Util.null2String(request.getParameter("mouldname"));

String docMouldExistedId=Util.null2String(request.getParameter("docMouldExistedId"));
if(docMouldExistedId==null||"0".equals(docMouldExistedId)) docMouldExistedId = "";

String docid = Util.null2String(request.getParameter("id"));
if(docid==null||"0".equals(docid)) docid = "";

String temStr = request.getRequestURI();
temStr=temStr.substring(0,temStr.lastIndexOf("/")+1);

String mServerUrl=temStr+mServerName;
String mClientUrl="/docs/docs/"+mClientName;

String docMouldExistedName = "";
String docMouldExistedText = "";
String docMouldExistedType = "";
if(!docMouldExistedId.equals("")){
	int currentMouldType = 2;
	MouldManager.setId(Util.getIntValue(docMouldExistedId,0));
	MouldManager.getMouldInfoById();
	docMouldExistedName=MouldManager.getMouldName();
	docMouldExistedText=MouldManager.getMouldText();
	currentMouldType = MouldManager.getMouldType();
	docMouldExistedType=".doc";
	if(currentMouldType==2){
		docMouldExistedType=".doc";
	}else if(currentMouldType==3){
		docMouldExistedType=".xls";
	}else if(currentMouldType==4){
		docMouldExistedType=".wps";
	}else if(currentMouldType==5){
		docMouldExistedType=".et";
	}else{
		docMouldExistedType=".doc";
	}
	MouldManager.closeStatement();
}

%>
<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver.js"></script>
<script language="javascript">
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
    //alert(weaver.WebOffice.WebGetMsgByName("CREATEID"));
    weaver.id.value=weaver.WebOffice.WebGetMsgByName("CREATEID");
    weaver.docType.value=weaver.WebOffice.WebGetMsgByName("DOCTYPE");
    //alert(weaver.id.value);
    //alert(weaver.docType.value);
    return true;
  }
}

function Load(){
  //weaver.WebOffice.WebUrl="<%=mServerUrl%>"
  try{
  weaver.WebOffice.WebUrl="<%=mServerUrl%>";
  weaver.WebOffice.RecordID="<%=docMouldExistedId%>";
  weaver.WebOffice.Template="";
  weaver.WebOffice.FileName="";
  weaver.WebOffice.FileType="<%=docType%>";
<%if(isIWebOffice2006 == true){%>
//iWebOffice2006 特有内容开始
  weaver.WebOffice.EditType="1,1";
  weaver.WebOffice.ShowToolBar="0";      //ShowToolBar:是否显示工具栏:1显示,0不显示
//iWebOffice2006 特有内容结束
<%}else{%>
  weaver.WebOffice.EditType="1";
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


</script>
</head>
<%

String urlfrom = Util.null2String(request.getParameter("urlfrom"));
//System.out.println("urlfrom#####:"+urlfrom);
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+",_self} " ;
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
<input TYPE="hidden" id="id" NAME="id" value="">
<input TYPE="hidden" id="docType" NAME="docType" value="">

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
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<input class=InputStyle size=70 name=mouldname value="<%=mouldname%>" onChange="checkinput('mouldname','mouldnamespan')">
<span id=mouldnamespan><%if(mouldname==null||"".equals(mouldname)){%><img src="/images/BacoError.gif" align=absMiddle><%}%></span>

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
<!--###@2007-08-27 modify by yeriwei!
<tr class=Spacing>
<td class=Line colspan=2></td></tr>
<tr><td>
</td><td>
<div id=divimg name="divimg" style="display:none">
<input type=file name=docimages_0 size=60></input>
</div>
<input type=hidden name=docimages_num value=0></input>
</td></tr>
--->

<tr><td>
<script language=javascript>
    var docSelectIndex=0;
    function onChangeDocType(doPage,docType){
        if(confirm("<%=SystemEnv.getHtmlLabelName(18691,user.getLanguage())%>")){
            location=doPage+'?urlfrom=<%=urlfrom%>&mouldname='+weaver.mouldname.value+'&docType='+docType+'&subcompanyid1='+<%=subcompanyid1%>;
        }
        weaver.sdoctype[docSelectIndex].checked=true;
        return false;

    }
</script>

<%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%>
</td><td>
<div >
<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".htm")?"checked":"")%> onClick="onChangeDocType('DocMouldAdd.jsp','.htm')">HTML&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".doc")?"checked":"")%> onClick="onChangeDocType('DocMouldAddExt.jsp','.doc')">WORD&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".xls")?"checked":"")%> onClick="onChangeDocType('DocMouldAddExt.jsp','.xls')">EXCEL&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".wps")?"checked":"")%> onClick="onChangeDocType('DocMouldAddExt.jsp','.wps')"><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%>&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%if("1".equals(isUseET)){%>
<input TYPE="radio" NAME="sdoctype" <%=(docType.equals(".et")?"checked":"")%> onClick="onChangeDocType('DocMouldAddExt.jsp','.et')"><%=SystemEnv.getHtmlLabelName(24545,user.getLanguage())%>&nbsp;<%=urlfrom.equals("hr")?SystemEnv.getHtmlLabelName(15786,user.getLanguage()):SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>
<%}%>
</div>
<script language=javascript>
for(i=0; i<weaver.sdoctype.length; i++){
    if(weaver.sdoctype[i].checked){
        docSelectIndex=i;
    }
}
</script>
</td></tr>
<tr>
	<td class=Line colSpan=2></td>
</tr>

<tr>
  <td><%=SystemEnv.getHtmlLabelName(19333,user.getLanguage())%></td>
  <td class=Field>
	<div >
    <button type="button" class=Browser onClick="onShowMould();"></button><input class="InputStyle" type="hidden" name="docMouldExistedId" value="<%=docMouldExistedId%>">
  	<span id="docMouldExistedName"><%=docMouldExistedName%></span>
	</div>
  </td>
</tr>
<tr>
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
</span>

</td>
</tr>
<tr>
	<td class=Line colSpan=2></td>
</tr>

<tr><td colspan=2>
<textarea name=mouldtext style="display:none;width:100%;height:500px"></textarea>
<!---###@2007-08-27 modify by yeriwei!
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
</tbody>
</table>
<input type=hidden name=operation>
<input type=hidden name=urlfrom value="<%=urlfrom%>">
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
var isdocexisted = false;
function onShowMould(){
	if("<%=urlfrom%>"=="hr"){

	var id = window.showModalDialog("DocMouldtwoBrowser.jsp?doctype=<%=docType%>&subcompanyid1=<%=subcompanyid1%>");
	if(id!=null){
		var idarray = id.toArray();
		document.weaver.docMouldExistedId.value = idarray[0];
		docMouldExistedName.innerHTML = "";
		if(isdocexisted)
		location="DocMouldAddExt.jsp?id="+weaver.id.value+"&subcompanyid1=<%=subcompanyid1%>&urlfrom=<%=urlfrom%>&mouldname="+document.weaver.mouldname.value+"&docType=<%=docType%>&docMouldExistedId="+idarray[0];
		else if("<%=docid%>"!="")
		location="DocMouldAddExt.jsp?id=<%=docid%>&subcompanyid1=<%=subcompanyid1%>&urlfrom=<%=urlfrom%>&mouldname="+document.weaver.mouldname.value+"&docType=<%=docType%>&docMouldExistedId="+idarray[0];
		else
		location="DocMouldAddExt.jsp?urlfrom=<%=urlfrom%>&subcompanyid1=<%=subcompanyid1%>&mouldname="+document.weaver.mouldname.value+"&docType=<%=docType%>&docMouldExistedId="+idarray[0];
	}
	}
	else{

	var id = window.showModalDialog("DocMouldBrowser.jsp?doctype=<%=docType%>");
	if(id!=null){
		var idarray = new Array(id.id, id.name);
		document.weaver.docMouldExistedId.value = idarray[0];
		docMouldExistedName.innerHTML = "";
		if(isdocexisted)
		location="DocMouldAddExt.jsp?id="+weaver.id.value+"&mouldname="+document.weaver.mouldname.value+"&docType=<%=docType%>&docMouldExistedId="+idarray[0];
		else if("<%=docid%>"!="")
		location="DocMouldAddExt.jsp?id=<%=docid%>&mouldname="+document.weaver.mouldname.value+"&docType=<%=docType%>&docMouldExistedId="+idarray[0];
		else
		location="DocMouldAddExt.jsp?mouldname="+document.weaver.mouldname.value+"&docType=<%=docType%>&docMouldExistedId="+idarray[0];
	}
}
	}


function onSave(){
	if(check_form(document.weaver,'mouldname,subcompanyid1')){
        document.weaver.operation.value='add';
        if(SaveDocument()){
		    document.weaver.submit();
        }
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