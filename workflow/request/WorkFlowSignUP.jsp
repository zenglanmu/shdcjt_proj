<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import = "weaver.general.Util"%>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="DocUtil" class="weaver.docs.docs.DocUtil" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RequestLogIdUpdate" class="weaver.workflow.request.RequestLogIdUpdate" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<BODY id="flowbody">
<%
int userlanguage=Util.getIntValue(request.getParameter("languageid"),7);
String fieldvalue=Util.null2String(request.getParameter("fieldvalue"));
String remark=Util.null2String(request.getParameter("remark"));
String signdocids=Util.null2String(request.getParameter("signdocids"));
String signworkflowids=Util.null2String(request.getParameter("signworkflowids"));
String signdocname="";
String signworkflowname="";
ArrayList templist=Util.TokenizerString(signdocids,",");
for(int i=0;i<templist.size();i++){
    signdocname+="<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
}
templist=Util.TokenizerString(signworkflowids,",");
int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
for(int i=0;i<templist.size();i++){
    tempnum++;
    session.setAttribute("resrequestid" + tempnum, "" + templist.get(i));
    signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
}
session.setAttribute("slinkwfnum", "" + tempnum);
session.setAttribute("haslinkworkflow", "1");
//System.out.println("remark=="+remark);
remark = Util.StringReplace(remark,"\n","<br>");
remark = Util.StringReplace(remark,"<br>","\n");
String fieldname=Util.null2String(request.getParameter("fieldname"));
String fieldid=Util.null2String(request.getParameter("fieldid"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
int isedit=Util.getIntValue(request.getParameter("isedit"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"));
int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
int ismonitor=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"ismonitor"),0);

int userid = user.getUID();
//String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
//add by cyril on 2008-09-30 for td:9014
boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
String workflowPhrases[] = new String[RecordSet.getCounts()];
String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
int x = 0 ;
if (isSuccess) {
	while (RecordSet.next()){
		workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
		workflowPhrasesContent[x] = Util.toHtmlA(Util.null2String(RecordSet.getString("phrasedesc")));
		x ++ ;
	}
}
//end by cyril on 2008-09-30 for td:9014
String username=user.getUsername();
String isFormSignature=Util.null2String(request.getParameter("isFormSignature"));
int formSignatureWidth= Util.getIntValue(request.getParameter("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
int formSignatureHeight= Util.getIntValue(request.getParameter("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);

int workflowRequestLogId=-1;
if(isFormSignature.equals("1")){
	workflowRequestLogId=Util.getIntValue(request.getParameter("workflowRequestLogId"));
}
int currentnodeid=Util.getIntValue(request.getParameter("nodeid"),0);
String isSignMustInput="0";
RecordSet.execute("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+currentnodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"));
}
String isSignDoc_signup="";
String isSignWorkflow_signup="";
RecordSet.execute("select isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
	isSignDoc_signup=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_signup=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
int annexmainId=0;
int annexsubId=0;
int annexsecId=0;
String isannexupload_add=(String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
if("1".equals(isannexupload_add) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
	annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
	annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
	annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
%>
<script language="javascript">
opener.document.all("annexmainId").value="<%=annexmainId%>";
opener.document.all("annexsubId").value="<%=annexsubId%>";
opener.document.all("annexsecId").value="<%=annexsecId%>";
</script>
<%
}
int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
if(annexmaxUploadImageSize<=0){
	annexmaxUploadImageSize = 5;
}
%>
<form name="frmmain" method="post" action="WorkFlowSignUPOption.jsp" enctype="multipart/form-data">
	<input type="hidden" name="tempannexmainId" value="<%=annexmainId%>">
	<input type="hidden" name="tempannexsubId" value="<%=annexsubId%>">
	<input type="hidden" name="tempannexsecId" value="<%=annexsecId%>">
	<input type="hidden" name="isFormSignature" value="<%=isFormSignature%>">
	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  <%
 		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:dosubmit(this),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
   %>
	<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table  class=ViewForm cellspacing=1>
<tbody>
<COL width="10%" >
<COL width="90%" >
<tr class="Title">
          <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT:bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
        </tr>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
		<td valign="top" class=field>
		<%if("1".equals(isFormSignature)){

%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
			<jsp:param name="isFromWorkFlowSignUP" value="1" />
		</jsp:include>
<%
}else{
		if(workflowPhrases.length>0){%>
      <select class=inputstyle  id="phraseselect" name=phraseselect style="width:80%" onChange='onAddPhrase(this.value)'>
      <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>－－</option>
      <%for (int i= 0 ; i <workflowPhrases.length;i++) {
         String workflowPhrase = workflowPhrases[i] ;  %>
      <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
      <%}%>
      </select><br>
		<%}%>
			<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>" value="">
			<textarea class=Inputstyle name=remark id="remark" rows=4 cols=40 style="width=80%;display:none" class=Inputstyle temptitle="<%=SystemEnv.getHtmlLabelName(17614,userlanguage)%>"  <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>></textarea>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")&&"".equals(remark)){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>
              
	  		   	<script defer>
	  		   	function funcremark_log(){		  		   	
	  		   	$GetEle("remark").value = opener.document.getElementById("remark").value;
	  		   	CkeditorExt.initEditor('frmmain','remark','<%=userlanguage%>',CkeditorExt.NO_IMAGE,200)
				<%if(isSignMustInput.equals("1")){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					CkeditorExt.toolbarExpand(false,"remark");
				}
	  		 	if(ieVersion>=8) {
		  		 	if (window.addEventListener){
					    window.addEventListener("load", funcremark_log(), false);
					}else if (window.attachEvent){
					    window.attachEvent("onload", funcremark_log());
					}else{
					    window.onload=funcremark_log();
					}
	  		 	} else {
		  		 	if (window.addEventListener){
					    window.addEventListener("load", funcremark_log, false);
					}else if (window.attachEvent){
					    window.attachEvent("onload", funcremark_log);
					}else{
					    window.onload=funcremark_log;
					}
	  		 	}
				</script>
              
<%}%>
</td>
</tr>
<tr><td class=Line2 colSpan=2></td></tr>
<%
         if("1".equals(isSignDoc_signup)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_signup)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
<%
boolean flag = true;
if(!fieldvalue.trim().equals("")||(isedit>0&&annexsecId!=0)){
%>
<tr>
<td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
<td class=field>
<table cols=3 id="<%=fieldid%>_tab">
<TBODY >
<COL width="80%" >
<COL width="10%" >
<%
if(!fieldvalue.trim().equals("")){
    String sql="select id,docsubject,accessorycount from docdetail where id in("+fieldvalue+") order by id asc";
    int linknum=-1;
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
    		flag = false;
        linknum++;
        String showid = Util.null2String(RecordSet.getString(1)) ;
        String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
        int accessoryCount=RecordSet.getInt(3);

        DocImageManager.resetParameter();
        DocImageManager.setDocid(Integer.parseInt(showid));
        DocImageManager.selectDocImageInfo();

        String docImagefileid = "";
        long docImagefileSize = 0;
        String docImagefilename = "";
        String fileExtendName = "";
        int versionId = 0;

        String imgSrc=AttachFileUtil.getImgSrcByDocId(showid,"20");

        if(DocImageManager.next()){
            docImagefileid = DocImageManager.getImagefileid();
            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
            docImagefilename = DocImageManager.getImagefilename();
            fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1);
            versionId = DocImageManager.getVersionId();
        }
%>
        <tr>
            <INPUT type=hidden name="<%=fieldid%>_del_<%=linknum%>" value="0" >
            <td valign="top">
              <%=imgSrc%>

              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&versionId=<%=versionId%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a href="javascript:addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp

              <%}%>
              <input type=hidden name="<%=fieldid%>_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td align="left">
                <%if(isedit>0){%>
                <BUTTON class=AddDocFlow accessKey=1  onclick='onChangeSharetype("span<%=fieldid%>_id_<%=linknum%>","<%=fieldid%>_del_<%=linknum%>")'><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><span id="span<%=fieldid%>_id_<%=linknum%>" name="span<%=fieldid%>_id_<%=linknum%>" style="visibility:hidden"><B><FONT COLOR="#FF0033">√</FONT></B><span></BUTTON>
                <%}%>
            </td>
          </tr>
<%
    }
%>
    <input type=hidden name="<%=fieldid%>_idnum" value=<%=linknum+1%>>
<%
}
if(isedit>0&&annexsecId!=0){
%>
    <tr>
            <td valign="top" colspan="3">
            <%
          if(annexsecId<1){
            %>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
           <%}else {
           %>
            <script>
            var oUpload<%=fieldid%>;
          function fileupload<%=fieldid%>() {
        var settings = {
            flash_url : "/js/swfupload/swfupload.swf",
            upload_url: "/docs/docupload/MultiDocUploadByWorkflow.jsp",    // Relative to the SWF file
            post_params: {
                "mainId": "<%=annexmainId%>",
                "subId":"<%=annexsubId%>",
                "secId":"<%=annexsecId%>",
                "userid":"<%=user.getUID()%>",
                "logintype":"<%=user.getLogintype()%>",
                "workflowid":"<%=workflowid%>"
            },
            file_size_limit :"<%=annexmaxUploadImageSize%> MB",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 100,
            file_queue_limit : 0,
            custom_settings : {
                progressTarget : "fsUploadProgress<%=fieldid%>",
                cancelButtonId : "btnCancel<%=fieldid%>",
                SubmitButtonId : "btnSubmit<%=fieldid%>",
                uploadspan : "<%=fieldid%>span",
                uploadfiedid : "<%=fieldid%>"
            },
            debug: false,
            button_image_url : "/js/swfupload/add.png",
            button_placeholder_id : "spanButtonPlaceHolder<%=fieldid%>",
            button_width: 100,
            button_height: 18,
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
            button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
            button_text_top_padding: 0,
            button_text_left_padding: 18,
            button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
            button_cursor: SWFUpload.CURSOR.HAND,
            file_queued_handler : fileQueued,
            file_queue_error_handler : fileQueueError,
            file_dialog_complete_handler : fileDialogComplete_1,
            upload_start_handler : uploadStart,
            upload_progress_handler : uploadProgress,
            upload_error_handler : uploadError,
            upload_success_handler : uploadSuccess_1,
            upload_complete_handler : uploadComplete_1,
            queue_complete_handler : queueComplete
        };
        try {
            oUpload<%=fieldid%>=new SWFUpload(settings);
        } catch(e) {
            alert(e)
        }
    }
        	//window.attachEvent("onload", fileupload<%=fieldid%>);
        	if (window.addEventListener){
  			    window.addEventListener("load", fileupload<%=fieldid%>, false);
  			}else if (window.attachEvent){
  			    window.attachEvent("onload", fileupload<%=fieldid%>);
  			}else{
  			    window.onload=fileupload<%=fieldid%>;
  			}	
        </script>
      <TABLE class="ViewForm">
          <tr>
              <td colspan="2">
                  <div>
                      <span>
                      <span id="spanButtonPlaceHolder<%=fieldid%>"></span><!--选取多个文件-->
                      </span>
                      &nbsp;&nbsp;
								<span style="color:#262626;cursor:hand;TEXT-DECORATION:none" disabled onclick="oUpload<%=fieldid%>.cancelQueue();" id="btnCancel<%=fieldid%>">
									<span><img src="/js/swfupload/delete.gif" border="0"></span>
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span id="uploadspan">(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="<%=fieldid%>span"></span>
                  </div>
                  <input  class=InputStyle  type=hidden name="<%=fieldid%>" viewtype="0" value="<%=fieldvalue%>">
              </td>
          </tr>
          <tr>
              <td colspan="2">
                  <div class="fieldset flash" id="fsUploadProgress<%=fieldid%>">
                  </div>
                  <div id="divStatus<%=fieldid%>"></div>
              </td>
          </tr>
      </TABLE>
            <%}%>
    </td>
          </tr>
<%}%>
</tbody>
</table>
</td>
</tr>
<tr><td class=Line2 colSpan=2></td></tr>
<%}%>
<input type=hidden name='<%=fieldid%>_num' value="1">
<input type=hidden name="fieldname" value="<%=fieldname%>">
<input type=hidden name="fieldid" value="<%=fieldid%>">
</tbody>
</table>
</form>
 </body>
</html>

<script type="text/javascript" src="/js/swfupload/workflowswfupload.js"></script>
<script language=javascript>
function onAddPhrase(phrase){
    if(phrase!=null && phrase!=""){
		$G("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = CkeditorExt.getHtml("remark");
			CkeditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>","remark");
		}catch(e){alert(e)}
	}
}
function dosubmit(obj){

    var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form(document.frmmain,'remark')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
    if(ischeckok=="true"){

<%
	    if("1".equals(isFormSignature)){
%>
		    if(SaveSignature()){
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
		    }
<%
	    }else{
%>
	        //附件上传
	        StartUploadAll();
	        checkuploadcomplet();
<%
	    }
%>
    }
}


  function onChangeSharetype(delspan,delid){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if(document.getElementById(delspan).style.visibility=='visible'){
      document.getElementById(delspan).style.visibility='hidden';
      document.getElementById(delid).value='0';
        var tempvalue=document.getElementById(fieldid).value;
          if(tempvalue==""){
              tempvalue=document.getElementById(delfieldid).value;
          }else{
              tempvalue+=","+document.getElementById(delfieldid).value;
          }
	     document.getElementById(fieldid).value=tempvalue;
    }else{
      document.getElementById(delspan).style.visibility='visible';
      document.getElementById(delid).value='1';
        var tempvalue=document.getElementById(fieldid).value;
        var tempdelvalue=","+document.getElementById(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     document.getElementById(fieldid).value=tempvalue;
    }
  }

function returnTrue(o){
	return;
}

function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
</script>
<script type="text/vbscript">
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = document.all(inputname).value
    if type1=37 then
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?documentids="&tmpids)
    else
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?resourceids="&tmpids)
    end if
        if NOT isempty(id1) then
		   if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.all(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					document.all(spanname).innerHtml = sHtml

		else
				    document.all(spanname).innerHtml = empty
					document.all(inputname).value=""
        end if
      end if
end sub
</script>