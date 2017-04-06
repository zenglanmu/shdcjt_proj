<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<jsp:useBean id="wfNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page" />
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml.js"></script>

<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/Listener.js"></script>
<%
response.setHeader("Pragma","No-Cache");   
response.setHeader("Cache-Control","No-Cache");   
response.setDateHeader("Expires",0);   
User user = HrmUserVarify.getUser(request, response);
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int userid = Util.getIntValue(request.getParameter("userid"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String topage = Util.null2String(request.getParameter("topage"));
String docFlags = Util.null2String((String)session.getAttribute("requestAdd"+requestid));
int docfileid = Util.getIntValue(request.getParameter("docfileid"));	//新建文档的工作流字段
if(docFlags.equals("")){
	docFlags = Util.null2String((String)session.getAttribute("requestAdd"+userid));
}

wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(1);
Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
Hashtable otherPara_hs = wfLayoutToHtml.getOtherPara_hs();
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
StringBuffer jsStr = wfLayoutToHtml.getJsStr();
String needcheck = wfLayoutToHtml.getNeedcheck();
out.println(wfformhtml); //把模板解析后的文本输出到页面上

StringBuffer htmlHiddenElementsb = wfLayoutToHtml.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());//把hidden的input输出到页面上
int hasRemark = Util.getIntValue((String)otherPara_hs.get("hasRemark"), 0);
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
int titleFieldId=0;
int keywordFieldId=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet_nf1.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet_nf1.next()){
	titleFieldId=Util.getIntValue(RecordSet_nf1.getString("titleFieldId"),0);
	keywordFieldId=Util.getIntValue(RecordSet_nf1.getString("keywordFieldId"),0);
	isSignDoc_add=Util.null2String(RecordSet_nf1.getString("isSignDoc"));
	isSignWorkflow_add=Util.null2String(RecordSet_nf1.getString("isSignWorkflow"));
}
%>

<input type=hidden name="workflowRequestLogId" value="-1">
<%
String isSignMustInput="0";
String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet_nf1.next()){
	isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
	isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
}
int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevision_t != 1){
	isFormSignature = "";
}
if(hasRemark != 1){%>
<!-- 签字意见 -->
<table class="ViewForm" >
<colgroup>
	<col width="20%">
	<col width="80%">
</colgroup>
	<tr class="Title">
	  <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,languageid)%></font></td>
	</tr>
	<tr>
	  <td ><%=SystemEnv.getHtmlLabelName(17614,languageid)%></td>
	  <td style="text-align:right;">
	  <!-- modify by xhheng @20050308 for TD 1692 -->
		 <%

		 //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
		//add by cyril on 2008-09-30 for td:9014
 		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
 		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
 		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
 		int m = 0 ;
 		if (isSuccess) {
 			while (RecordSet_nf1.next()){
 				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
 				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
 				m ++ ;
 			}
 		}
 		//end by cyril on 2008-09-30 for td:9014

if("1".equals(isFormSignature)){
		 int workflowRequestLogId=-1;
%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
		</jsp:include>
<%
}else{
			 if(workflowPhrases.length>0){
		 %>
				<select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)' onmousewheel="return false;">
				<option value="">－－<%=SystemEnv.getHtmlLabelName(22409,languageid)%>－－</option>
				<%
				  for (int i= 0 ; i <workflowPhrases.length;i++) {
					String workflowPhrase = workflowPhrases[i] ;
					//这里把value改成内容
				%>
					<option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
				<%}%>
				</select>

		  <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,languageid)%>" value="">
			  <textarea class=Inputstyle name=remark id=remark rows=4 cols=40 style="width=80%;display:none" class=Inputstyle temptitle="<%=SystemEnv.getHtmlLabelName(17614,languageid)%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>></textarea>
			  </td>
			  <!-- HTML模板的新建 -->
			 <td style="text-align:left;">
				  <span id="remarkSpan">
						<%
						  if(isSignMustInput.equals("1")){
						%>
						  <img src="/images/BacoError.gif" align=absmiddle>
						<%
						  }
						%>
				  </span>
			  </td>
	  		   	<script defer>
	  		   	function funcremark_log(){
					CkeditorExt.initEditor("frmmain","remark",<%=languageid%>,CkeditorExt.NO_IMAGE, 200);
				<%if(isSignMustInput.equals("1")){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					CkeditorExt.toolbarExpand(false,"remark");
				}
	  		 	if (window.addEventListener){
	  			    window.addEventListener("load", funcremark_log, false);
	  			}else if (window.attachEvent){
	  			    window.attachEvent("onload", funcremark_log);
	  			}else{
	  			    window.onload=funcremark_log;
	  			}	
				//funcremark_log();
				</script>
			  
<%}%>

	</tr>
	 <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
	 <%
		 if("1".equals(isSignDoc_add)){
		 %>
		  <tr>
			<td><%=SystemEnv.getHtmlLabelName(857,languageid)%></td>
			<td class=field>
				<input type="hidden" id="signdocids" name="signdocids">
				<button type=button  class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,languageid)%>"></button>
				<span id="signdocspan"></span>
			</td>
		  </tr>
		  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
		 <%}%>
	 <%
		 if("1".equals(isSignWorkflow_add)){
		 %>
		  <tr>
			<td><%=SystemEnv.getHtmlLabelName(1044,languageid)%></td>
			<td class=field>
				<input type="hidden" id="signworkflowids" name="signworkflowids">
				<button type=button  class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,languageid)%>"></button>
				<span id="signworkflowspan"></span>
			</td>
		  </tr>
		  <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
		 <%}%>
	 <%
		 String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
		 if("1".equals(isannexupload_add)){
			int annexmainId=0;
			int annexsubId=0;
			int annexsecId=0;
			String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
			 if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
				annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
				annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
				annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
			  }
			 int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
			 if(annexmaxUploadImageSize<=0){
				annexmaxUploadImageSize = 5;
			 }
		 %>
		  <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,languageid)%></td>
            <td class=field>
            <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,languageid)+SystemEnv.getHtmlLabelName(15808,languageid)%>!</font>
           <%}else{%>
            <script>
          var oUploadannexupload;
          function fileuploadannexupload() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId":"<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgressannexupload",
                cancelButtonId : "btnCancelannexupload",
                uploadfiedid:"field-annexupload"
            },
            debug: false,


            // Button settings

            button_image_url : "/js/swfupload/add.png",    // Relative to the SWF file
            button_placeholder_id : "spanButtonPlaceHolderannexupload",

            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,languageid)%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,

            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,

            // The event handler functions are defined in handlers.js
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_2,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete    // Queue plugin event
        };


        try {
            oUploadannexupload=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileuploadannexupload);
          if (window.addEventListener){
			    window.addEventListener("load", fileuploadannexupload, false);
			}else if (window.attachEvent){
			    window.attachEvent("onload", fileuploadannexupload);
			}else{
			    window.onload=fileuploadannexupload;
			}	
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolderannexupload"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUploadannexupload.cancelQueue();" id="btnCancelannexupload">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,languageid)%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,languageid)%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,languageid)%>)</span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" >
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgressannexupload">
                  </div>
                  <div id="divStatusannexupload"></div>
              </td>
          </tr>
      </TABLE>
              <input type=hidden name='annexmainId' value=<%=annexmainId%>>
              <input type=hidden name='annexsubId' value=<%=annexsubId%>>
              <input type=hidden name='annexsecId' value=<%=annexsecId%>>
          </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}}%>
  </table>

<%}%>

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<input type=hidden name="workflowid" value="<%=workflowid%>">	   <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">			   <!--当前节点id-->
<input type=hidden name="nodetype" value="0">					 <!--当前节点类型-->
<input type=hidden name="src">									<!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="1">					 <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">			   <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">			<!--创建结束后返回的页面-->
<input type=hidden name ="isbill" value="<%=isbill%>">			<!--是否单据 0:否 1:是-->
<input type=hidden name ="method">								<!--新建文档时候 method 为docnew-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type=hidden name ="requestid" value="-1">
<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<iframe name="delzw" width=0 height=0></iframe>






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
			setFieldValueAjax(msg,fieldid,fieldid,true);//其中第2个fieldid，只是用来区分当前字段是主字段还是明细字段，所以在这里用fieldid代替
		}
	});
}

<%out.println(jsStr.toString());%>


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

function accesoryChanage(obj){
	var objValue = obj.value;
	if (objValue=="") return ;
	var fileLenth;
	try {
		File.FilePath=objValue;
		fileLenth= File.getFileSize();
	} catch (e){
		//alert('<%=SystemEnv.getHtmlLabelName(20253,languageid)%>');
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,languageid)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,languageid)%> ");
		}
		createAndRemoveObj(obj);
		return  ;
	}
	if (fileLenth==-1) {
		createAndRemoveObj(obj);
		return ;
	}
	var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
	if (fileLenthByM><%=maxUploadImageSize%>) {
		alert("<%=SystemEnv.getHtmlLabelName(20254,languageid)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,languageid)%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,languageid)%>");
		createAndRemoveObj(obj);
	}
}

</script>
<SCRIPT language="javascript">

function checkNodesNumFun() {
	try {
		<%
		int checkdetailno = 0;
		if(isbill > 0) {
			if(formid==7||formid==156 || formid==157 || formid==158) {
		%>
				var rowneed = $G('rowneed').value;
				var nodesnum = $G('nodesnum').value;
				nodesnum = nodesnum*1;
				if(rowneed=="1") {
					if(nodesnum>0) {
						return 0;
					} else {
						return 1;
					}
				} else {
					return 0;
				}
		<%
			} else {
				rs_html.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
				while(rs_html.next()) {
	   	%>
					var rowneed = $G('rowneed<%=checkdetailno%>').value;
					var nodesnum = $G('nodesnum<%=checkdetailno%>').value;
					nodesnum = nodesnum*1;
					if(rowneed == "1") {
						if(nodesnum>0) {
							return 0;
						} else {
							return 1;
						}
					} else {
						return 0;
					}
	   	<%
			   		checkdetailno ++;
				}
			}
		} else {
	    %>
	    <%
		  int checkGroupId=0;
		  rs_html.executeSql("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		  while (rs_html.next()) {
			checkGroupId=rs_html.getInt(1);
	    %>
			var rowneed = $G('rowneed<%=checkGroupId%>').value;
			var nodesnum = $G('nodesnum<%=checkGroupId%>').value;
			nodesnum = nodesnum*1;
			if(rowneed=="1") {
				if(nodesnum>0) {
					return 0;
				} else{
					return 1;
				}
			} else {
				return 0;
			}
	<%
		  }
		}
	%>
	} catch(e) {
		return 0;
	}
}

//默认大小
var uploadImageMaxSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
//填充选择目录的附件大小信息
var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo()
{
<%
if(secCategorys!=null&&secMaxUploads!=null&&secMaxUploads.size()>0)
{
	Set selectValues = secMaxUploads.keySet();

	for(Iterator i = selectValues.iterator();i.hasNext();)
	{
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
function reAccesoryChanage()
{
	<%
	if(uploadfieldids!=null){
    for(int i=0;i<uploadfieldids.size();i++){
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,uploadImageMaxSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}}%>
}
//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $G(fieldid);
	if(efieldid)
	{
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == tselectValue)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		if(tselectValue=="")
		{
			uploadImageMaxSize = 5;
		}
		var euploadspans = document.getElementsByTagName("SPAN");
		if(euploadspans)
		{
			for(var j=0;j<euploadspans.length;j++)
			{
				var euploadid = euploadspans[j].id;
				if(euploadid&&euploadid=="uploadspan")
				{
					euploadspans[j].innerHTML = "(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)";
				}
			}
		}
	}
}
function addannexRow(accname,maxsize){
	//区分两种添加方式
	var uploadspan = "";
	var checkMaxUpload = 0;
	if(accname!="field-annexupload"){
		maxsize = <%=maxUploadImageSize%>;
		uploadspan = "uploadspan";
  	}else{
		checkMaxUpload = maxsize;
  	}
	$G(accname+'_num').value=parseInt($G(accname+'_num').value)+1;
	var ncol = $G(accname+'_tab').cols;
	var oRow = $G(accname+'_tab').insertRow(-1);
	for(j=0; j<ncol; j++){
		var oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		switch(j){
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
	 		case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+$G(accname+'_num').value+"' onchange='accesoryChanage(this,"+checkMaxUpload+")'> (<%=SystemEnv.getHtmlLabelName(18976,languageid)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,languageid)%>) ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
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


function createDoc(fieldbodyid,docVlaue,tempDocView){
	
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
	*/
	var _isagent = "";
    var _beagenter = "";
	if($G("_isagent")!=null) _isagent=$G("_isagent").value;
    if($G("_beagenter")!=null) _beagenter=$G("_beagenter").value;
  	frmmain.action = "RequestOperation.jsp?isagent="+_isagent+"&beagenter="+_beagenter+"&docView=1&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文
        document.frmmain.src.value='save';

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
function onNewDoc(fieldbodyid) {

	frmmain.action = "RequestOperation.jsp" ;
	frmmain.method.value = "docnew_"+fieldbodyid ;
	frmmain.isMultiDoc.value = fieldbodyid ;
	if(check_form(document.frmmain,'requestname')){
         //附件上传
         StartUploadAll();
		document.frmmain.src.value='save';
		checkuploadcomplet();
	}
}


	function doSave(){			  <!-- 点击保存按钮 -->
		enableAllmenu();
	    var nodenum = checkNodesNumFun();
    	if(nodenum>0) {
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
			displayAllmenu();
    		return false;
    	}
	
		var ischeckok="";

		try{
		if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
		  ischeckok="true";
		}catch(e){
		  ischeckok="false";
		}
		if(ischeckok=="false"){
			if(check_form(document.frmmain,'<%=needcheck%>'))
				ischeckok="true";
		}

<%
	if(isSignMustInput.equals("1")){
		if("1".equals(isFormSignature)){
		}else{
%>
			if(ischeckok=="true"){
				if(!check_form(document.frmmain,'remarkText10404')){
					ischeckok="false";
				}
			}
<%
		}
	}
%>
		if(ischeckok=="true"){
			CkeditorExt.updateContent();
			if(checktimeok()) {
					document.frmmain.src.value='save';
					jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201


//保存签章数据
<%if("1".equals(isFormSignature)){%>
						if(SaveSignature()){
							//TD4262 增加提示信息  开始
							var content="<%=SystemEnv.getHtmlLabelName(18979,languageid)%>";
							showPrompt(content);
							//TD4262 增加提示信息  结束
							//附件上传
							StartUploadAll();
							checkuploadcomplet();
						}else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
						}
<%}else{%>
						//TD4262 增加提示信息  开始
						var content="<%=SystemEnv.getHtmlLabelName(18979,languageid)%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						//附件上传
						StartUploadAll();
						checkuploadcomplet();
<%}%>
				}
			} else {
				displayAllmenu();
			}
	}

	/*	
	 *	用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，
	 *	如果检查通过返回true，否则返回false
	 *	用户在使用html模板的时候，通过重写这个方法，来达到检查特殊数据的需求
	 */
	function checkCustomize(){
		return true;
	}
	
	function doSubmit(obj){			<!-- 点击提交 -->
		enableAllmenu();
	    var nodenum = checkNodesNumFun();
    	if(nodenum>0) {
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
			displayAllmenu();
    		return false;
    	}
	
	  //modify by xhheng @20050328 for TD 1703
	  //明细部必填check，通过try $G("needcheck")来检查,避免对原有无明细单据的修改
	  

		if(!checkCustomize()){
			displayAllmenu();
			return false;
		}

		var ischeckok="";
		try{
		if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
		  ischeckok="true";
		}catch(e){
		  ischeckok="false";
		}
		if(ischeckok=="false"){
		  if(check_form(document.frmmain,'<%=needcheck%>'))
			ischeckok="true";
		}

<%
	if(isSignMustInput.equals("1")){
		if("1".equals(isFormSignature)){
		}else{
%>
			if(ischeckok=="true"){
				if(!check_form(document.frmmain,'remarkText10404')){
					ischeckok="false";
				}
			}
<%
		}
	}
%>

		if(ischeckok=="true"){
			CkeditorExt.updateContent();
			if(checktimeok()) {
				document.frmmain.src.value='submit';
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

		if("<%=formid%>"==201){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。
			nodesnum = $G("nodesnum").value;
			for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
				var capitalcount = $G("node_"+tempindex1+"_capitalcount").value*1;
				var fetchingnumber=$G("node_"+tempindex1+"_number").value*1;
				for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
					if(tempindex2!=tempindex1&&$G("node_"+tempindex1+"_capitalid").value==$G("node_"+tempindex2+"_capitalid").value){
						fetchingnumber = fetchingnumber*1 + $G("node_"+tempindex2+"_number").value*1;
					}
				}
				if(fetchingnumber>capitalcount){
					alert("<%=SystemEnv.getHtmlLabelName(15313,languageid)%><%=SystemEnv.getHtmlLabelName(15508,languageid)%><%=SystemEnv.getHtmlLabelName(1446,languageid)%>");
					displayAllmenu();
					return;
				}
			}
		}

//保存签章数据
<%if("1".equals(isFormSignature)){%>
						if(SaveSignature()){
							//TD4262 增加提示信息  开始
							var content="<%=SystemEnv.getHtmlLabelName(18978,languageid)%>";
							showPrompt(content);
							//TD4262 增加提示信息  结束

							obj.disabled=true;
							//附件上传
							StartUploadAll();
							checkuploadcomplet();
						}else{
							if(isDocEmpty==1){
								alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
								isDocEmpty=0;
							}else{
								alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
							}
							displayAllmenu();
							return ;
						}
<%}else{%>
						//TD4262 增加提示信息  开始
						var content="<%=SystemEnv.getHtmlLabelName(18978,languageid)%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束

						obj.disabled=true;
						//附件上传
						StartUploadAll();
						checkuploadcomplet();
<%}%>
			}
		} else {
			displayAllmenu();
		}
	}

  setTimeout("doTriggerInit()",1000);
  function doTriggerInit(){
	  var tempS = "<%=trrigerfield%>";
	  datainput(tempS);
  }
  function getWFLinknum(wffiledname){
		if($G(wffiledname) != null){
			return $G(wffiledname).value;
		}else{
			return 0;
		}
	}
  function datainput(parfield){				<!--数据导入-->
	  //var xmlhttp=XmlHttp.create();
	  var tempParfieldArr = parfield.split(",");
	  var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
	  for(var i=0;i<tempParfieldArr.length;i++){
	  	var tempParfield = tempParfieldArr[i];
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
	  }
	  //alert(StrData);
	  $G("datainputform").src="DataInputFrom.jsp?"+StrData;
	  //xmlhttp.open("POST", "DataInputFrom.jsp", false);
	  //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	  //xmlhttp.send(StrData);
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
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+$G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value;

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

	$G("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
  //xmlhttp.open("POST", "DataInputFrom.jsp", false);
  //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  //xmlhttp.send(StrData);
}


if (window.addEventListener){
	window.addEventListener("load", showfieldpop, false);
}else if (window.attachEvent){
	window.attachEvent("onload", showfieldpop);
}else{
	window.onload=showfieldpop;
}

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitChildSelect(fieldid,pFieldid,finalvalue){
	try{
		var pField = $G("field"+pFieldid);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
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
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
			    document.body.appendChild(frm);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
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
</script>

<script type="text/javascript">
//<!--
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
	    if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161||type1 == 224||type1 == 225||type1 == 226||type1 == 227) {
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
					
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp";
						}
					}
					$GetEle("field" + id + "span").innerHTML = sHtml;
					$GetEle("field" + id).value= resourceids;
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
						if(href==''){
							sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						}else{
							sHtml = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
						}
						$GetEle("field" + id + "span").innerHTML = sHtml
						return ;
				   }
	               if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick='createDoc(" + id + ", " + tempid + ", 1)'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=button id='createdoc' style='display:none' class=AddDocFlow onclick=createDoc(" + id + ", " + tempid + ",1)></button>";
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
	               		jQuery(targetElement).next("span[id=createNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, languageid)%>'><%=SystemEnv.getHtmlLabelName(82, languageid)%></button>");
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
	if (id1) {

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
	if ((dialogId)) {
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
//-->
</script>
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
//非ie能正常触发事件
jQuery(document).ready(function(){
	var l = new Listener();
	l.load("input[type=hidden][_listener!='']");
	l.start(500, "_listener");
});

jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	formatTables();	
});

var msgWarningJinEConvert = "<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>";
</script>
<script type="text/javascript" language="javascript" src="/js/datetime.js"></script>
<script type="text/javascript" language="javascript" src="/js/selectDateTime.js"></script>