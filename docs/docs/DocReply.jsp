<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<html><head>
<link href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language="JavaScript" src="/js/checkinput.js"></script>
<script language="javascript" src="/js/weaver.js"></script>
<script src="/js/prototype.js" type="text/javascript"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<script language="javascript" type="text/javascript">
var lang=<%=(user.getLanguage()==8)?"true":"false"%>;
window.onload=function(){
	FCKEditorExt.initEditor('weaver','doccontent',lang);
};
</script>
</head>
<%
    int docid = Util.getIntValue(request.getParameter("id"),0);
  
    String parentids=Util.null2String(request.getParameter("parentids"));
   
    String docName="";
    String newParentIds=","+parentids;
    int lastFlagIndex=newParentIds.lastIndexOf(",");
    String replyedDoc=newParentIds.substring(lastFlagIndex+1);
    String replyedName=DocComInfo.getDocname(replyedDoc);
    if (replyedName.indexOf("Re:")!=-1)  docName=replyedName;
    else  docName="Re: "+replyedName;
       

    DocManager.resetParameter();
    DocManager.setId(docid);
    DocManager.getDocInfoById();

    int maincategory=DocManager.getMaincategory();
    int subcategory=DocManager.getSubcategory();
    int seccategory=DocManager.getSeccategory();
    int replydocid=DocManager.getReplydocid();
    String docsubject=DocManager.getDocsubject();
    DocManager.closeStatement();


    String imagefilename = "/images/hdDOC.gif";
    String titlename = SystemEnv.getHtmlLabelName(117,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(58,user.getLanguage());
    String needfav ="1";
    String needhelp ="";

    int maxUploadImageSize = DocUtil.getMaxUploadImageSize2(docid);
%>
<body>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+",javascript:onDraft(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:FCKEditorExt.switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+",javascript:addannexRow(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;


%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>





<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<tr>	
	<td valign="top">
		<table width='100%'>
		<tr>
		<td valign="top">

<form id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=docapprovable value="0">
<input type=hidden name=docreplyable value="1">
<input type=hidden name=isreply value="1">
<input type=hidden name=docpublishtype value="1">
<input type=hidden name=replydocid value="<%=docid%>">
<input type=hidden name=usertype value="<%=user.getLogintype()%>">
<input type=hidden name=maincategory value="<%=maincategory%>">
<input type=hidden name=docdepartmentid value="<%=user.getUserDepartment()%>">
<input type=hidden name=subcategory value="<%=subcategory%>">
<input type=hidden name=doclangurage value="<%=user.getLanguage()%>">
<input type=hidden name=seccategory value="<%=seccategory%>">
<input type=hidden name=operation value="addsave">
<input type=hidden name=parentids value="<%=parentids%>">
<input type=hidden name=docstatus>
<input type=hidden name=ownerid value="<%=user.getUID()%>">



<table class=ViewForm>
<tbody>
<tr>
<td width=10%><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></td>
<td width=90% class=field>
	<input type="hidden" name="namerepeated" value="0">
	<input class=InputStyle size=70 name="docsubject" 
	value="<%=docName%>" 
	onkeydown="if(window.event.keyCode==13)return false"
	onChange="checkDocSubject(this);"
	onMouseDown="docSubjectMouseDown(this);"
	onBlur="checkDocSubject(this);"
	>
	<span id="docsubjectspan"><%if(docName.equals("")){%><img src="/images/BacoError.gif" align=absMiddle><%} %></span>

	<script type="text/javascript">
		var isChecking = false;
		var prevValue = "";
		<%if(!docsubject.equals("")){%>
		checkDocSubject($GetEle('docsubject'));
		<%}%>
		function docSubjectMouseDown(obj){
			if(event.button==2){
				checkDocSubject(obj)
			}
		}
		function checkDocSubject(obj){
			if(obj!=null&&obj.value!=null&&obj.value!=""&&obj.value!=prevValue){
			  //$('docsubjectspan').innerHTML = "<font color=red><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%></font>";
			  $GetEle('namerepeated').value = 1;
			  isChecking = true;
			  
			  var subject = encodeURIComponent(obj.value);
			  var url = 'DocSubjectCheck.jsp';
			  var pars = 'subject='+subject+'&secid=<%=seccategory%>';
			  var myAjax = new Ajax.Request(
				url,
				{method: 'post', parameters: pars, onComplete: doCheckDocSubject}
			  );
			  prevValue = subject;
			}else{
				checkinput('docsubject','docsubjectspan');
			}
		}
		function doCheckDocSubject(req){
			var num = req.responseXML.getElementsByTagName('num')[0].firstChild.data;
			if(num>0){
				//alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
				$GetEle('docsubjectspan').innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"+" <font color=red><%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%></font>";
				$GetEle('namerepeated').value = 1;
			} else {
				$GetEle('namerepeated').value = 0;
				checkinput('docsubject','docsubjectspan');
			}
			isChecking = false;
		}
		function checkSubjectRepeated(){
			if($GetEle('namerepeated')==1){
				if(isChecking){
					alert("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
				} else {
					alert("<%=SystemEnv.getHtmlLabelName(20073,user.getLanguage())%>");
				}
				return false;
			}
			else return true;
		}
	</script>

</td>
</tr>
</tbody>
</table>
<table cols=2 id="rewardTable" class="viewform">
<tbody >
<tr style="height: 1px"><td class=Line colSpan=4></td></tr>
<td width=10%>附件</td>
<td width=90% class="field">
<input class=InputStyle  type=file size=55 name="accessory1" onchange='accesoryChanage(this)'>&nbsp;&nbsp;(附件最大为<%=maxUploadImageSize%>M)
</td>
</tr>

</tbody>
</table>
<input type=hidden name=accessorynum value="1">



<div id=imgfield>
</div>
<table class=ViewForm>
<colgroup>
  <col width="10%">
  <col width=90%>

<tbody>
<tr class=Spacing style="height: 1px">
<td class=Line colspan=2></td></tr>
<!--###@2007-08-27 modify by yeriwei!
<tr><td>
<%=SystemEnv.getHtmlLabelName(681,user.getLanguage())%>
</td><td>
<div id=divimg name="divimg">
<input type=file class=InputStyle name=docimages_0  size=70 ></input>
</div>
<input type=hidden name=docimages_num value=0></input>
</td></tr>
<tr>
	<td class=Line1 colSpan=2></td>
</tr>
--->

<tr><td colspan=2>
<textarea id="doccontent" name=doccontent style="display:none;width:100%;height:350"></textarea>
<!--###@2007-08-27 modify by yeriwei!
<div id=divifrm style="display:;">
<iframe src="/docs/docs/dhtml.jsp" frameborder=0 style="width:100%;height=500px" id="dhtmlFrm"></iframe>
</div>
-->
</td>
</tr>

</tbody>
</table>
</form>

		</td>
		</tr>
		</table>
	</td>

</tr>
</table>
<input type=hidden id='btnSave' name='btnSave' onclick='onSave(this)'>
<input type=hidden id=btnDraft onclick=onDraft(this)>
<input type=hidden id=btnHtml onclick=FCKEditorExt.switchEditMode()>
<input type=hidden id=btnAccAdd onclick=addannexRow()>

<script language=javascript><!--
function onSave(obj){
	if(check_form(document.weaver,'docsubject')&&checkSubjectRepeated()){
		/****####@2007-08-27 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		**/
		FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='addsave';
		var objSubmit;
		try{
			objSubmit=obj.parentNode.parentNode.parentNode.firstChild.nextSibling.firstChild.firstChild;
			objSubmit.disabled = true ;
			enableAllmenu();
		}catch(e){}
        obj.disabled = true ;
		document.weaver.submit();
	}
}

function onDraft(obj){
	if(check_form(document.weaver,'docsubject')&&checkSubjectRepeated()){
		/***###@2007-08-27 modify by yeriwei!
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		***/
		FCKEditorExt.updateContent();
		
		document.weaver.docstatus.value=0;
		document.weaver.operation.value='adddraft';
		var objSubmit;
		try{
			objSubmit=obj.parentNode.parentNode.parentNode.firstChild.firstChild.firstChild;
			objSubmit.disabled = true ;
			enableAllmenu();
		}catch(e){}
        obj.disabled = true ;
		document.weaver.submit();
	}
}

/****
function onHtml(){
	if(document.weaver.doccontent.style.display==''){

		text = document.weaver.doccontent.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.weaver.doccontent.style.display='none';
		divifrm.style.display='';
	}
	else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.weaver.doccontent.value=text;
		document.weaver.doccontent.style.display='';
		divifrm.style.display='none';
	}
}
***/

accessorynum = 2 ;
function addannexRow()
{
	ncol = jQuery(rewardTable).attr("cols");
	oRow = rewardTable.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		switch(j) {
             case 0:
				var oDiv = document.createElement("div");
				var sHtml = "&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1:
				oCell.className="field";
				var oDiv = document.createElement("div");
				var sHtml = "<input class=InputStyle  type=file size=55 name='accessory"+accessorynum+"'  onchange='accesoryChanage(this)'>&nbsp;&nbsp;(附件最大为<%=maxUploadImageSize%>M)";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;

		}
	}
	accessorynum = accessorynum*1 +1;
	document.weaver.accessorynum.value = accessorynum ;
}


function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    /*try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert("用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！");
        createAndRemoveObj(obj);
        return  ;
    }*/
    var fileLenth=-1;
    try {
    	var fso = new ActiveXObject("Scripting.FileSystemObject");
    	fileLenth=parseInt(fso.getFile(objValue).size);
    } catch (e){
        try{
    		fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
			alert("您的浏览器不支持获取文件大小的操作");
			createAndRemoveObj(obj)
			return;
		}
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = fileLenth/(1024*1024) 
	var fileLenthByK =  fileLenth/1024;
	var fileLenthByM =  fileLenthByK/1024;

	var fileLenthName;
	if(fileLenthByM>=0.1){
		fileLenthName=fileLenthByM.toFixed(1)+"M";
	}else if(fileLenthByK>=0.1){
		fileLenthName=fileLenthByK.toFixed(1)+"K";
	}else{
		fileLenthName=fileLenth+"B";
	}
    if (fileLenthByM><%=maxUploadImageSize%>) {
        //alert("所传附件为:"+fileLenthByM+"M,此目录下不能上传超过<%=maxUploadImageSize%>M的文件,如果需要传送大文件,请与管理员联系!");
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthName+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");		
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    var  newObj = document.createElement("input");
    newObj.name=objName;
    newObj.className="InputStyle";
    newObj.type="file";
    newObj.size=55;
    newObj.onchange=function(){accesoryChanage(this);};
    
    var objParentNode = obj.parentNode;
    var objNextNode = obj.nextSibling;
    jQuery(obj).remove()
    //obj.removeNode();
    objParentNode.insertBefore(newObj,objNextNode); 
}
--></script>
</body>