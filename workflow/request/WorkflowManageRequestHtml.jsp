<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>

<%@ page import="weaver.system.code.CodeBuild" %>
<%@ page import="weaver.system.code.CoderBean" %>
<jsp:useBean id="wfNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page" />
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/Listener.js"></script>
<%
int creater= Util.getIntValue(request.getParameter("creater"),0);
int creatertype=Util.getIntValue(request.getParameter("creatertype"),0);
User user = HrmUserVarify.getUser(request, response);
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int nodetype = Util.getIntValue(request.getParameter("nodetype"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int billid=Util.getIntValue(request.getParameter("billid"),0);
int userid = Util.getIntValue(request.getParameter("userid"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
int isremark = Util.getIntValue(request.getParameter("isremark"), 0);
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String topage = Util.null2String(request.getParameter("topage"));
String docFlags = Util.null2String((String)session.getAttribute("requestAdd"+requestid));
int docfileid = Util.getIntValue(request.getParameter("docfileid"));	//新建文档的工作流字段
if(docFlags.equals("")){
	docFlags = Util.null2String((String)session.getAttribute("requestAdd"+userid));
}

wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(0);
Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
Hashtable otherPara_hs = wfLayoutToHtml.getOtherPara_hs();
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
StringBuffer jsStr = wfLayoutToHtml.getJsStr();
String needcheck = wfLayoutToHtml.getNeedcheck();
out.println(wfformhtml);

StringBuffer htmlHiddenElementsb = wfLayoutToHtml.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());

String logintype = Util.null2String(request.getParameter("logintype"));
String username = Util.null2String((String)session.getAttribute(userid+"_"+logintype+"username"));
String docCategory=Util.null2String((String)otherPara_hs.get("docCategory"));
Map secMaxUploads = (HashMap)otherPara_hs.get("secMaxUploads");//封装选择目录的信息
Map secCategorys = (HashMap)otherPara_hs.get("secCategorys");
ArrayList uploadfieldids=(ArrayList)otherPara_hs.get("uploadfieldids");    
int maxUploadImageSize_Para = Util.getIntValue((String)otherPara_hs.get("maxUploadImageSize"), -1);
int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
int maxUploadImageSize = -1;
if(maxUploadImageSize_Para > 0){
	maxUploadImageSize = maxUploadImageSize_Para;
}else{
	maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
}
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}
//获得触发字段名
DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
int detailsum=0;
String isFormSignature=null;
rs_html.executeSql("select isFormSignature from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(rs_html.next()){
	isFormSignature = Util.null2String(rs_html.getString("isFormSignature"));
}

CodeBuild cbuild = new CodeBuild(formid,String.valueOf(isbill),workflowid,creater,creatertype);
CoderBean cb = cbuild.getFlowCBuild();
String fieldCode=Util.null2String(cb.getCodeFieldId());
%>
<!-- ypc 2012-09-14 在这个地方 添加了 id="workflowid" id="isbill" id="formid"  -->
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input type=hidden name="workflowid" id="workflowid" value="<%=workflowid%>">	   <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">			   <!--当前节点id-->
<input type=hidden name="nodetype" value="<%=nodetype%>">					 <!--当前节点类型-->
<input type=hidden name="src">									<!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="0">					 <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" id="formid" value="<%=formid%>">			   <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">			<!--创建结束后返回的页面-->
<input type=hidden name ="isbill" id="isbill" value="<%=isbill%>">			<!--是否单据 0:否 1:是-->
<input type=hidden name="billid" value="<%=billid%>">			 <!--单据id-->
<input type=hidden name ="method">								<!--新建文档时候 method 为docnew-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type="hidden" id="requestid" name ="requestid" value="<%=requestid%>">
<input type="hidden" id="rand" name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0 style="border:none"></iframe>

<SCRIPT language="javascript">
function initFieldValue(fieldid){
	var fieldid4Sql = fieldid;
	var fieldExt = "";
	if(fieldid.indexOf("_") > -1){
		fieldExt = fieldid.substr(fieldid.indexOf("_"), fieldid.length);
		fieldid4Sql = fieldid.substr(0, fieldid.indexOf("_"));
	}
	var sqlcontent = "";
	try{
		sqlcontent = $G("fieldsql"+fieldid4Sql).value;
		sqlcontent = sqlcontent.replace(/\+/g, "%2B");
		sqlcontent = sqlcontent.replace(/\&/g, "%26");
	}catch(e){}
	var sql = "";
	var index = sqlcontent.indexOf("$");
	while(index > -1){
		try{
			sql += sqlcontent.substr(0, index);
			sqlcontent = sqlcontent.substr(index+1, sqlcontent.length);
			var tailindex = sqlcontent.indexOf("$");
			var sourceFieldid = sqlcontent.substr(0, tailindex);
			var sourceFieldValue = "";
			try{
				if(sourceFieldid == "-1"){
					sourceFieldValue = jQuery("[name=requestname]").val();
				}else if(sourceFieldid == "2"){
					sourceFieldValue = jQuery("[name=requestlevel]").val();
				}else if(sourceFieldid == "-3"){
					sourceFieldValue = jQuery("[name=messageType]").val();
				}else if(sourceFieldid.toLowerCase() == "requestid"){
					sourceFieldValue = "<%=requestid%>";
				}else{
					sourceFieldValue = $G("field"+sourceFieldid+fieldExt).value;
				}
			}catch(e){}
			sql += sourceFieldValue;
			sqlcontent = sqlcontent.substr(tailindex+1, sqlcontent.length);
		}catch(e){}
		index = sqlcontent.indexOf("$");
	}
	sql += sqlcontent;
	sql = sql.replace(new RegExp("%","gm"), "%25");
	sql = escape(sql);
	jQuery.ajax({
		url : "/workflow/request/WfFieldAttrAjax.jsp",
		type : "post",
		processData : false,
		data : "formid=<%=formid%>&isbill=<%=isbill%>&nodeid=<%=nodeid%>&sql="+sql+"&fieldid="+fieldid,
		dataType : "xml",
		success: function do4Success(msg){
			setFieldValueAjax(msg,fieldid,fieldid,true);
		}
	});
}

function doSqlFieldAjax(obj,fieldids){
	
	var thisfieldid = "";
	try{
		if(obj.id.indexOf("field") > -1){//普通字段
			thisfieldid = obj.id.substring(5);
		}else{
			if(obj.name == "requestname"){
				thisfieldid = "-1";
			}else if(obj.name == "requestlevel"){
				thisfieldid = "-2";
			}else if(obj.name == "messageType"){
				thisfieldid = "-3";
			}
		}
	}catch(e){}
	if(thisfieldid == ""){
		return;
	}
	var fieldExt = "";
	if(thisfieldid.indexOf("_") > -1){
		fieldExt = thisfieldid.substr(thisfieldid.indexOf("_"), thisfieldid.length);
	}
	var fieldidsz = fieldids.split(",");
	for(var i=0; i<fieldidsz.length; i++){
		var fieldidtmp = fieldidsz[i];
		if(fieldidtmp==null || fieldidtmp==""){
			continue;
		}
		doFieldAjax(thisfieldid,fieldidtmp,fieldExt);
	}
}

function doFieldAjax(thisfieldid,fieldidtmp,fieldExt){
	var sql = "";
	var sqlcontent = "";
	try{
		sqlcontent = $G("fieldsql"+fieldidtmp).value;
		sqlcontent = sqlcontent.replace(/\+/g, "%2B");
		sqlcontent = sqlcontent.replace(/\&/g, "%26");
	}catch(e){}
	var index = sqlcontent.indexOf("$");
	while(index > -1){
		try{
			sql += sqlcontent.substr(0, index);
			sqlcontent = sqlcontent.substr(index+1, sqlcontent.length);
			var tailindex = sqlcontent.indexOf("$");
			var sourceFieldid = sqlcontent.substr(0, tailindex);
			var sourceFieldValue = "";
			try{
				if(sourceFieldid == "-1"){
					sourceFieldValue = jQuery("[name=requestname]").val();
				}else if(sourceFieldid == "2"){
					sourceFieldValue = jQuery("[name=requestlevel]").val();
				}else if(sourceFieldid == "-3"){
					sourceFieldValue = jQuery("[name=messageType]").val();
				}else if(sourceFieldid.toLowerCase() == "requestid"){
					sourceFieldValue = "<%=requestid%>";
				}else{
					sourceFieldValue = $G("field"+sourceFieldid+fieldExt).value;
				}
			}catch(e){}
			sql += sourceFieldValue;
			sqlcontent = sqlcontent.substr(tailindex+1, sqlcontent.length);
		}catch(e){}
		index = sqlcontent.indexOf("$");
	}
	sql += sqlcontent;
	sql = sql.replace(new RegExp("%","gm"), "%25");
	sql = escape(sql);
	jQuery.ajax({
		url : "/workflow/request/WfFieldAttrAjax.jsp",
		type : "post",
		processData : false,
		data : "formid=<%=formid%>&isbill=<%=isbill%>&nodeid=<%=nodeid%>&sql="+sql+"&fieldid="+fieldidtmp,
		dataType : "xml",
		success: function do4Success(msg){
			setFieldValueAjax(msg,thisfieldid,fieldidtmp,false);
		}
	});
}

</script>
<SCRIPT language="javascript">
//默认大小
var uploadImageMaxSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
//填充选择目录的附件大小信息
var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo(){
	<%
	if(secCategorys!=null&&secMaxUploads!=null&&secMaxUploads.size()>0){
		Set selectValues = secMaxUploads.keySet();
	
		for(Iterator i = selectValues.iterator();i.hasNext();){
			String value = (String)i.next();
			String maxUpload = (String)secMaxUploads.get(value);
			String uplCategory=(String)secCategorys.get(value);
	%>
	selectValues.push('<%=value%>');
	maxUploads.push('<%=maxUpload%>');
    uploadCategorys.push('<%=uplCategory%>');
	<%
		}
	}
	%>
}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小
function reAccesoryChanage(){
	<%
	if(uploadfieldids!=null){
    for(int i=0;i<uploadfieldids.size();i++){
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,uploadImageMaxSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}}%>
}
//选择目录时，改变对应信息
function changeMaxUpload(fieldid){
	var efieldid = $G(fieldid);
	if(efieldid){
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++){
			var value = selectValues[i];
			if(value == tselectValue){
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		if(tselectValue=="")
		{
			uploadImageMaxSize = 5;
		}
		var euploadspans = document.getElementsByTagName("SPAN");
		if(euploadspans){
			for(var j=0;j<euploadspans.length;j++){
				var euploadid = euploadspans[j].id;
				if(euploadid&&euploadid=="uploadspan"){
					euploadspans[j].innerHTML = "(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)";
				}
			}
		}
	}
}
/*
function funcClsDateTime(){
	var onlstr = new clsDateTime();
}				

if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}*/

function createDoc(fieldbodyid,docVlaue,isedit)
{
	
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
	*/
  	if("<%=isremark%>"=="9"||"<%=isremark%>"=="1"){
  		frmmain.action = "RequestDocView.jsp?requestid=<%=requestid%>&docValue="+docVlaue;
  	}else{
  	frmmain.action = "RequestOperation.jsp?docView="+isedit+"&docValue="+docVlaue+"&isFromEditDocument=true";
  	}
	frmmain.method.value = "crenew_"+fieldbodyid ;
	frmmain.target="delzw";
	parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文
		document.frmmain.src.value='save';
		document.frmmain.isremark.value='0';
//保存签章数据
<%if("1".equals(isFormSignature)){%>
						if(SaveSignature()){
							//附件上传
        StartUploadAll();
        checkuploadcompletBydoc();
						}else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							return ;
						}
<%}else{%>
						//附件上传
        StartUploadAll();
        checkuploadcompletBydoc();
<%}%>
	}

}
function openDocExt(showid,versionid,docImagefileid,isedit){
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	
	// isAppendTypeField参数标识  当前字段类型是附件上传类型，不论该附件所在文档内容是否为空、或者存在最新版本，在该链接打开页面永远打开该附件内容、不显示该附件所在文档内容。
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&isAppendTypeField=1");
	}
}

function openAccessory(fileId){ 
	jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>");
}
function onNewDoc(fieldid) {
	frmmain.action = "RequestOperation.jsp" ;
	frmmain.method.value = "docnew_"+fieldid ;
	frmmain.isMultiDoc.value = fieldid ;
	document.frmmain.src.value='save';
	//附件上传
        StartUploadAll();
        checkuploadcomplet();
}

function datainput(parfield){				<!--数据导入-->
	//var xmlhttp=XmlHttp.create();
	var detailsum="0";
	try{
		detailsum=$G("detailsum").value;
	}catch(e){ detailsum="0";}
	var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum="+detailsum+"&trg="+parfield;
	<%
	if(!trrigerfield.trim().equals("")){
		ArrayList Linfieldname=ddi.GetInFieldName();
		ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
		for(int i=0;i<Linfieldname.size();i++){
			String temp=(String)Linfieldname.get(i);
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
	<%
		}
		for(int i=0;i<Lcondetionfieldname.size();i++){
			String temp=(String)Lcondetionfieldname.get(i);
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>")) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>").value;
	<%
		}
	}
	%>
	//alert(StrData);
	$G("datainputform").src="DataInputFrom.jsp?"+StrData;
	//xmlhttp.open("POST", "DataInputFrom.jsp", false);
	//xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	//xmlhttp.send(StrData);
}
function getWFLinknum(wffiledname){
	if($G(wffiledname) != null){
		return $G(wffiledname).value;
	}else{
		return 0;
	}
}
function datainputd(parfield){				<!--数据导入-->

	//var xmlhttp=XmlHttp.create();
  var tempParfieldArr = parfield.split(",");
	var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
	
	for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);
	
	<%
	if(!trrigerdetailfield.trim().equals("")){
		ArrayList Linfieldname=ddi.GetInFieldName();
		ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
		for(int i=0;i<Linfieldname.size();i++){
			String temp=(String)Linfieldname.get(i);
			
	%>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;
		
	<%
		}
	    for(int i=0;i<Lcondetionfieldname.size();i++){
              String temp=(String)Lcondetionfieldname.get(i);
      %>
        if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;
      <%
          }
		}
	%>
	}
	//alert(StrData);
	$G("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
	//xmlhttp.open("POST", "DataInputFrom.jsp", false); 
	//xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	//xmlhttp.send(StrData);
}

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitChildSelect(fieldid,pFieldid,finalvalue, cnt){
	try{
		var pField = $G("field"+pFieldid);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				if (cnt == null || cnt == "") {
					cnt = 0;
				}
				var _callbackfc = function() {
			        doInitChildSelect(fieldid, pFieldid, finalvalue, cnt + 1);
			    };
			    if (cnt < 10) {
					window.setTimeout(_callbackfc , 500);
				}
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
				$G("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    $G("selectChangeDetail").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
</script>
<script type="text/javascript">
function onShowBrowser3(id,url,linkurl,type1,ismand) {
	onShowBrowser2(id, url, linkurl, type1, ismand, 3);
}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    if (type1 == 9  && "<%=docFlags%>" == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	
	if (type1 == 23) {
		url += "?billid=<%=formid%>";
	}
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onFlownoShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
		if (type1==224 || type1==225 ){
			id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
		}if (type1==226 || type1==227 ){
			id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
		}
		 else if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161) {
				    id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				} else {
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
	        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
		        if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
		        	tmpids = "";
		        }
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];

						if (type1 == 171 || type1 == 152) {
	                        linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                        if (linkno>0) {
	                        	curid = curid + "&wflinkno=" + linkno;
							} else {
	                        	tlinkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid="
							}
						}
						
						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
				
				//zzl
				var id0lflag = true;
				if(wuiUtil.getJsonValueByIndex(id1, 1) != ""){
					id0lflag = true;
				}else{
					if(wuiUtil.getJsonValueByIndex(id1, 0) != "0"){
						id0lflag = true;
					}else{
						id0lflag = false;
					}
				}
				//zzl
				
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && id0lflag ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp"; ypc 2012-09-14 把此行代码注释掉 此行代码是没有的 会导致自定义多选浏览按钮出现重复值
							if(href==''){
								sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							}else{
								sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
							}
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						$GetEle("field"+id).value = ids;
						//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						if(href==''){
							sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						}else{
							sHtml = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
						}
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return ;
				   }

				   if (type1 == 16) {
					   curid = wuiUtil.getJsonValueByIndex(id1, 0);
                   	   linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                   if (linkno>0) {
	                       curid = curid + "&wflinkno=" + linkno;
	                   } else {
	                       linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
	                   }
	                   $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
					   if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
						   $GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1)+ "</a>&nbsp";
					   } else {
	                       $GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
					   }
	                   return;
				   }
				   
	               if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=createNewDoc]").html("");
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=createNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
	}
}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if ((id1)) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {
	var tmpids = $GetEle("field" + id).value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if (dialogId) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			
			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];
				if (shareTypeValue == "") {
					continue;
				}
				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;
				
				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("field" + id).value = fileIdValue;
			$GetEle("field" + id + "span").innerHTML = sHtml;
		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
	    }
	} 
}
</script>
<!-- 

<script LANGUAGE="VBS">

sub onShowResourceRole(id,url,linkurl,type1,ismand,roleid)
	tmpids = $G("field"+id).value
	url=url&roleid&"_"+tmpids

	id1 = window.showModalDialog(url)
		if NOT isempty(id1) then

		   if id1(0)<> ""  and id1(0)<> "0"  then

					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$G("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					$G("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
				end if
		end if
end sub

sub onShowBrowser2(id,url,linkurl,type1,ismand)

	if type1=9  and <%=docFlags%>="1" then
	url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp"
	end if

	if type1=23 then
	url=url+"?billid=<%=formid%>"
	end if

	if type1= 2 or type1 = 19 then
		spanname = "field"+id+"span"
		inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
		else
		  onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1<>162 and type1 <> 171 and type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			if type1 = 161 or type1=224 or type1=225 then
				id1 = window.showModalDialog(url&"|"&id,window)
			else
				id1 = window.showModalDialog(url,window)
			end if
		else
			 if type1=135 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=142 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
			elseif type1=162 then
			tmpids = $G("field"+id).value
			url = url&"|"&id&"&beanids="&tmpids
			url = Mid(url,1,(InStr(url,"url="))+3) & escape(Mid(url,(InStr(url,"url="))+4,len(url)))
			id1 = window.showModalDialog(url,window)
			elseif type1=165 or type1=166 or type1=167 or type1=168 then
			index=InStr(id,"_")
			if index>0 then
			tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid="& Mid(id,1,index-1)&"&resourceids="&$G("field"+id).value)
			id1 = window.showModalDialog(url&tmpids)
			else
			tmpids=uescape("?fieldid="&id&"&isbill=<%=isbill%>&resourceids="&$G("field"+id).value)
			id1 = window.showModalDialog(url&tmpids)
			end if
			else
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			end if
		end if
		if NOT isempty(id1) then
			if type1 = 171 or type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))
					tlinkurl=linkurl

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						if type1 = 171 or type1 = 152 then
						linkno=getWFLinknum("slink"&id&"_rq"&curid)
						if linkno>0 then
						curid=curid&"&wflinkno="&linkno
						else
						tlinkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
						end if
						end if
					if tlinkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							 sHtml = sHtml&"<a href="&tlinkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					end if
					   
					wend
					if type1 = 171 or type1 = 152 then
						linkno=getWFLinknum("slink"&id&"_rq"&resourceids)
						if linkno>0 then
						resourceids=resourceids&"&wflinkno="&linkno
						else
						tlinkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
						end if
					end if
					if tlinkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&tlinkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					end if
				   
					$G("field"+id+"span").innerHtml = sHtml
					$G("field"+id).value= resourceidss
				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
				end if

			else

			   if  id1(0)<>""   and id1(0)<> "0"  then
				   if type1=162 then
					 ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,1,len(ids))
					$G("field"+id).value= ids
					names = Mid(names,1,len(names))
					descs = Mid(descs,1,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					$G("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
					 name = id1(1)
					desc = id1(2)
					$G("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					$G("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1 = 16 then
						curid=id1(0)
						linkno=getWFLinknum("slink"&id&"_rq"&curid)
						if linkno>0 then
						curid=curid&"&wflinkno="&linkno
						else
						linkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
						end if
						$G("field"+id).value=id1(0)
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$G("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$G("field"+id+"span").innerHtml = "<a href="&linkurl&curid&" target='_new'>"&id1(1)&"</a>"
						end if

						exit sub
					end if
				   if type1=9 and <%=docFlags%>="1" then
					tempid=id1(0)
					$G("field"+id+"span").innerHtml = "<a href='#' onclick='createDoc("+id+","+tempid+",1)'>"&id1(1)&"</a><button id='createdoc' style='display:none' class=AddDoc onclick=createDoc("+id+","+tempid+",1)></button>"
					else
					if linkurl = "" then
						$G("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$G("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$G("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
						end if
						
					end if
					end if
					$G("field"+id).value=id1(0)
					if (type1=9 and <%=docFlags%>="1") then
					$G("CreateNewDoc").innerHtml=""
					end if

				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
  					if (type1=9 and <%=docFlags%>="1") then
					$G("createNewDoc").innerHtml="<button id='createdoc' class=AddDocFlow onclick=createDoc("+id+",'','1') title='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>"
					end if
				end if
			end if
		end if
	end if

end sub


sub onShowResourceConditionBrowser(id,url,linkurl,type1,ismand)

	tmpids = $G("field"+id).value
	dialogId = window.showModalDialog(url&"?resourceCondition="&tmpids)
	if (Not IsEmpty(dialogId)) then
	if dialogId(0)<> "" then
		shareTypeValues = dialogId(0)
		shareTypeTexts = dialogId(1)
		relatedShareIdses = dialogId(2)
		relatedShareNameses = dialogId(3)
		rolelevelValues = dialogId(4)
		rolelevelTexts = dialogId(5)
		secLevelValues = dialogId(6)
		secLevelTexts = dialogId(7)

		sHtml = ""
		fileIdValue=""
		shareTypeValues = Mid(shareTypeValues,2,len(shareTypeValues))
		shareTypeTexts = Mid(shareTypeTexts,2,len(shareTypeTexts))
		relatedShareIdses = Mid(relatedShareIdses,2,len(relatedShareIdses))
		relatedShareNameses = Mid(relatedShareNameses,2,len(relatedShareNameses))
		rolelevelValues = Mid(rolelevelValues,2,len(rolelevelValues))
		rolelevelTexts = Mid(rolelevelTexts,2,len(rolelevelTexts))
		secLevelValues = Mid(secLevelValues,2,len(secLevelValues))
		secLevelTexts = Mid(secLevelTexts,2,len(secLevelTexts))


		while InStr(shareTypeValues,"~") <> 0

			shareTypeValue = Mid(shareTypeValues,1,InStr(shareTypeValues,"~")-1)
			shareTypeText = Mid(shareTypeTexts,1,InStr(shareTypeTexts,"~")-1)
			relatedShareIds = Mid(relatedShareIdses,1,InStr(relatedShareIdses,"~")-1)
			relatedShareNames = Mid(relatedShareNameses,1,InStr(relatedShareNameses,"~")-1)
			rolelevelValue = Mid(rolelevelValues,1,InStr(rolelevelValues,"~")-1)
			rolelevelText = Mid(rolelevelTexts,1,InStr(rolelevelTexts,"~")-1)
			secLevelValue = Mid(secLevelValues,1,InStr(secLevelValues,"~")-1)
			secLevelText = Mid(secLevelTexts,1,InStr(secLevelTexts,"~")-1)

			shareTypeValues = Mid(shareTypeValues,InStr(shareTypeValues,"~")+1,Len(shareTypeValues))
			shareTypeTexts = Mid(shareTypeTexts,InStr(shareTypeTexts,"~")+1,Len(shareTypeTexts))
			relatedShareIdses = Mid(relatedShareIdses,InStr(relatedShareIdses,"~")+1,Len(relatedShareIdses))
			relatedShareNameses = Mid(relatedShareNameses,InStr(relatedShareNameses,"~")+1,Len(relatedShareNameses))
			rolelevelValues = Mid(rolelevelValues,InStr(rolelevelValues,"~")+1,Len(rolelevelValues))
			rolelevelTexts = Mid(rolelevelTexts,InStr(rolelevelTexts,"~")+1,Len(rolelevelTexts))
			secLevelValues = Mid(secLevelValues,InStr(secLevelValues,"~")+1,Len(secLevelValues))
			secLevelTexts = Mid(secLevelTexts,InStr(secLevelTexts,"~")+1,Len(secLevelTexts))

			fileIdValue=fileIdValue&"~"&shareTypeValue&"_"&relatedShareIds&"_"&rolelevelValue&"_"&secLevelValue

			if shareTypeValue= "1" then
				sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"
			else	if  shareTypeValue= "2" then
						 sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
					else   if shareTypeValue= "3" then
							   sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
						   else  if shareTypeValue= "4" then
									 sHtml = sHtml&","&shareTypeText&"("&relatedShareNames&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelText&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
								 else
									 sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValue&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
			end if
		wend

			fileIdValue=fileIdValue&"~"&shareTypeValues&"_"&relatedShareIdses&"_"&rolelevelValues&"_"&secLevelValues


			if shareTypeValues= "1" then
				sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"
			else	if  shareTypeValues= "2" then
						 sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18941,user.getLanguage())%>"
					else   if shareTypeValues= "3" then
							   sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18942,user.getLanguage())%>"
						   else  if shareTypeValues= "4" then
									 sHtml = sHtml&","&shareTypeTexts&"("&relatedShareNameses&")"&"<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>="&rolelevelTexts&"  <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18945,user.getLanguage())%>"
								 else
									 sHtml = sHtml&","&"<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>>="&secLevelValues&"<%=SystemEnv.getHtmlLabelName(18943,user.getLanguage())%>"
								 end if
						   end if
					end if
			end if

		sHtml = Mid(sHtml,2,len(sHtml))
		fileIdValue=Mid(fileIdValue,2,len(fileIdValue))

		$G("field"+id).value= fileIdValue
		$G("field"+id+"span").innerHtml = sHtml
	else
		if ismand=0 then
				$G("field"+id+"span").innerHtml = empty
		else
				$G("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
		end if
		$G("field"+id).value=""
	end if
	end if

end sub

sub onShowBrowser3(id,url,linkurl,type1,ismand)

	if type1=9  and <%=docFlags%>="1" then
    url="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
	end if

	if type1=23 then
	url=url+"?billid=<%=formid%>"
	end if

	if type1= 2 or type1 = 19 then
		spanname = "field"+id+"span"
		inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
		else
		  onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1<>162 and type1 <> 171 and type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
			 if type1=135 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=142 then
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
			elseif type1=162 then
			tmpids = $G("field"+id).value
			url = url&"&beanids="&tmpids
			url = Mid(url,1,(InStr(url,"url="))+3) & escape(Mid(url,(InStr(url,"url="))+4,len(url)))
			id1 = window.showModalDialog(url)
			elseif type1=165 or type1=166 or type1=167 or type1=168 then
			index=InStr(id,"_")
			if index>0 then
			tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid="& Mid(id,1,index-1)&"&resourceids="&$G("field"+id).value)
			id1 = window.showModalDialog(url&tmpids)
			else
			tmpids=uescape("?fieldid="&id&"&isbill=<%=isbill%>&resourceids="&$G("field"+id).value)
			id1 = window.showModalDialog(url&tmpids)
			end if
			else
			tmpids = $G("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			end if
		end if
		if NOT isempty(id1) then
			if type1 = 171 or type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))
					tlinkurl=linkurl

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						if type1 = 171 or type1 = 152 then
						linkno=getWFLinknum("slink"&id&"_rq"&curid)
						if linkno>0 then
						curid=curid&"&wflinkno="&linkno
						else
						tlinkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
						end if
						end if
					if tlinkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							 sHtml = sHtml&"<a href="&tlinkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					end if
					   
					wend
					if type1 = 171 or type1 = 152 then
						linkno=getWFLinknum("slink"&id&"_rq"&resourceids)
						if linkno>0 then
						resourceids=resourceids&"&wflinkno="&linkno
						else
						tlinkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
						end if
					end if
					if tlinkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&tlinkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					end if
				   
					$G("field"+id+"span").innerHtml = sHtml
					$G("field"+id).value= resourceidss
				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
				end if

			else

			   if  id1(0)<>""   and id1(0)<> "0"  then
				   if type1=162 then
					 ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,1,len(ids))
					$G("field"+id).value= ids
					names = Mid(names,1,len(names))
					descs = Mid(descs,1,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					$G("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
					 name = id1(1)
					desc = id1(2)
					$G("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					$G("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1 = 16 then
						curid=id1(0)
						linkno=getWFLinknum("slink"&id&"_rq"&curid)
						if linkno>0 then
						curid=curid&"&wflinkno="&linkno
						else
						linkurl=Mid(linkurl,1,InStr(linkurl,"?"))&"requestid="
						end if
						$G("field"+id).value=id1(0)
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$G("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$G("field"+id+"span").innerHtml = "<a href="&linkurl&curid&" target='_new'>"&id1(1)&"</a>"
						end if

						exit sub
					end if
				   if type1=9 and <%=docFlags%>="1" then
					tempid=id1(0)
					$G("field"+id+"span").innerHtml = "<a href='#' onclick='createDoc("+id+","+tempid+",1)'>"&id1(1)&"</a><button id='createdoc' style='display:none' class=AddDoc onclick=createDoc("+id+","+tempid+",1)></button>"
					else
					if linkurl = "" then
						$G("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$G("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$G("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
						end if
						
					end if
					end if
					$G("field"+id).value=id1(0)
					if (type1=9 and <%=docFlags%>="1") then
					$G("CreateNewDoc").innerHtml=""
					end if

				else
					if ismand=0 then
						$G("field"+id+"span").innerHtml = empty
					else
						$G("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$G("field"+id).value=""
  					if (type1=9 and <%=docFlags%>="1") then
					$G("createNewDoc").innerHtml="<button id='createdoc' class=AddDocFlow onclick=createDoc("+id+",'','1') title='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>"
					end if
				end if
			end if
		end if
	end if

end sub
</script>

 -->

<script language="javascript">
function getNumber(index){
  	$G("field_lable"+index).value = $G("field"+index).value;
}
function numberToChinese(index){
	if($G("field_lable"+index).value != ""){
	$G("field_lable"+index).value = floatFormat($G("field_lable"+index).value);
	$G("field"+index).value = $G("field_lable"+index).value;
	$G("field_lable"+index).value = numberChangeToChinese($G("field_lable"+index).value);
	}
	else{
	$G("field"+index).value = "";
	}
}
var tableformatted = false;
var needformatted = true;
function formatTables(){
	if(needformatted){
		jQuery("table[name^='oTable']").each(function(i,n){
			tableformatted = true;
			formatTable(n);
		});
		jQuery("table[name^='oTable']").bind("resize",function(){
			formatTable(this);
		});
	}
}
jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	formatTables();	
});

<%out.println(jsStr.toString());%>

if (window.addEventListener){
	window.addEventListener("load", showfieldpop, false);
}else if (window.attachEvent){
	window.attachEvent("onload", showfieldpop);
}else{
	window.onload=showfieldpop;
}
//发文字号初始值取得(TD20002)
	var hasinitfieldvalue=false
	var initfieldValue = -1;
	if($G("field<%=fieldCode%>")!=null&&$G("field<%=fieldCode%>span")!=null){
		if(!hasinitfieldvalue) {
			initfieldvalue = $G("field<%=fieldCode%>").value;
			hasinitfieldvalue = true;
		}
	}
function onChangeCode(ismand){
	if($G("field<%=fieldCode%>")!=null&&$G("field<%=fieldCode%>span")!=null){
		initDataForWorkflowCode();
		if($G("field<%=fieldCode%>").value == "" || $G("field<%=fieldCode%>").value == initfieldvalue) {
			return;
		} else {
        	$G("workflowKeywordIframe").src="/workflow/request/WorkflowCodeIframe.jsp?operation=ChangeCode&requestId=<%=requestid%>&workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId+"&ismand="+ismand+"&returnCodeStr="+$G("field<%=fieldCode%>").value +"&oldCodeStr="+initfieldvalue;
        }
	}
}
function doFieldDateAjax(para, fieldidtmp, fieldExt){
	var sql = para;
	//alert(sql+"&formid=<%=formid%>&isbill=<%=isbill%>&nodeid=<%=nodeid%>&fieldid="+fieldidtmp);
	var thisfieldid = "0"+fieldExt;
	jQuery.ajax({
		url : "/workflow/request/WfFieldDateAjax.jsp",
		type : "post",
		processData : false,
		data : sql+"&formid=<%=formid%>&isbill=<%=isbill%>&nodeid=<%=nodeid%>&fieldid="+fieldidtmp,
		dataType : "xml",
		success: function do4Success(msg){
			setFieldValueAjax(msg,thisfieldid,fieldidtmp,false);
		}
	});
}

//非ie能正常触发事件
jQuery(document).ready(function(){
	var l = new Listener();
	l.load("input[type=hidden][_listener!='']");
	l.start(500, "_listener");
});

var msgWarningJinEConvert = "<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>";
</script>
<script type="text/javascript" language="javascript" src="/js/datetime.js"></script>
<script type="text/javascript" language="javascript" src="/js/selectDateTime.js"></script>