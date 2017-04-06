<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ page import="weaver.workflow.workflow.WFOpinionInfo" %>
<%@ page import="weaver.workflow.request.RequestOpinionBrowserInfo" %>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="RequestOpinionFieldManager" class="weaver.workflow.request.RequestOpinionFieldManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">

<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext.js"></script>

<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf.js"></script>     
</head>
<%
int userid=user.getUID();
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
%>
<%
String needcheck = "";

String requestid=Util.null2String(request.getParameter("requestid"));
String remark = Util.null2String(request.getParameter("remark"));
int workflowRequestLogId = Util.getIntValue(request.getParameter("workflowRequestLogId"),0);
String signdocids = Util.null2String(request.getParameter("signdocids"));
String signworkflowids = Util.null2String(request.getParameter("signworkflowids"));
String field_annexupload = Util.null2String(request.getParameter("field-annexupload"));
FileUpload fu = null;
if(Util.null2String(request.getContentType()).toLowerCase().startsWith("multipart/form-data")){
	fu = new FileUpload(request);
	if(fu != null){
		requestid = Util.null2String(fu.getParameter("requestid"));
		remark = Util.null2String(fu.getParameter("remark"));
		workflowRequestLogId = Util.getIntValue(fu.getParameter("workflowRequestLogId"),0);
		signdocids = Util.null2String(fu.getParameter("signdocids"));
		signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
		field_annexupload = Util.null2String(fu.getParameter("field-annexupload"));
	}
}

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
    signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
}
session.setAttribute("slinkwfnum", "" + tempnum);
session.setAttribute("haslinkworkflow", "1");
        
//added by pony 
//RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
//RecordSet.next();
//modify by mackjoe 改为从session中取
int currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodeid"),0);
int wfid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
//added end.

String needconfirm="";
String isSignMustInput="0";
String isSignDoc_remark="";
String isSignWorkflow_remark="";
String isannexupload_remark="";
String annexdocCategory_remark="";
RecordSet.execute("select needAffirmance,isSignDoc,isSignWorkflow,isannexupload,annexdocCategory from workflow_base where id="+wfid);
if(RecordSet.next()){
    needconfirm=Util.null2o(RecordSet.getString("needAffirmance"));
    isSignDoc_remark=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_remark=Util.null2String(RecordSet.getString("isSignWorkflow"));
    isannexupload_remark=Util.null2String(RecordSet.getString("isannexupload"));
    annexdocCategory_remark=Util.null2String(RecordSet.getString("annexdocCategory"));
}

String isFormSignature="";
RecordSet.executeSql("select issignmustinput,isFormSignature from workflow_flownode where workflowId="+wfid+" and nodeId="+currentnodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
}
ArrayList forwardrights=WFForwardManager.getUserForwardRights(Util.getIntValue(requestid),wfid,currentnodeid,userid); 
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6011,user.getLanguage())+" - "+Util.toScreen(requestname,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
int hasright=0;
char flag=Util.getSeparator() ;
int rowindex=0;
//权限判断
//RecordSet.executeProc("workflow_RequestRemark_SByUser",""+requestid+flag+""+userid+flag+"0");
RecordSet.execute("select requestid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark in ('2','4','0','1','9','7') ");
if(RecordSet.next())	hasright=1;
if(hasright==0){
	//out.print(requestid+"-"+userid);
	response.sendRedirect("/notice/noright.jsp");
   	return;
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(this),_top} " ;//xwj for td2104 on 20050802
RCMenuHeight += RCMenuHeightStep;
%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(this),_self}";
//RCMenuHeight += RCMenuHeightStep;
%>

<%
/* Modified by Charoes Huang. No need of  add-row for there is a Multi-Resource Browser
RCMenu += "{"+SystemEnv.getHtmlLabelName(456,user.getLanguage())+",javascript:addRow(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:submitDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+",javascript:CheckAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
*/
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="RemarkOperate.jsp" enctype="multipart/form-data">
<input type=hidden name="operate">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowRequestLogId" value=<%=workflowRequestLogId%>>

<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:1px;">
	<td height="10" class=Line1 colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">



  <TABLE class=ViewForm cellspacing=1 id="oTable1" cols=2 border=0>
    <br/>
    <DIV align="center">
	<font style="font-size:14pt;FONT-WEIGHT: bold">
	  <%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())+SystemEnv.getHtmlLabelName(6011,user.getLanguage())%>
	</font>
    </DIV>
    <br/>
  	<TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR>
    <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></TD>
    <TD class=field><%=requestname%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=RequestComInfo.getRequestStatus(requestid)%></TD>
    </TR>
    <TR style="height:1px;"><TD class=Line1 colSpan=2></TD></TR>
<%
String para=requestid+flag+"1";
RecordSet.executeProc("workflow_RequestRemark_Select",para);
boolean islight=true;
String resourceids="";
String resourcenames ="";

String linkUrl ="/hrm/resource/HrmResource.jsp";
String spanInnerHtml ="";
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark<%}%> >
	  <td width="20%"><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())+SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
	  <td width="80%" class=field>
	  <input id="field5span"  class="wuiBrowser"  name="field5" value="<%=resourceids%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" _param="resourceids" _scroll="no" _displayTemplate="<a target=_blank href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>" _required="yes" _displayText="<%=spanInnerHtml%>"/>
	  </td>
	</tr>
	<TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
         <%
          if(forwardrights.size()>0){
        islight=!islight;
    %>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark<%}%> >
	  <td width="20%"><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></td>
	  <td width="80%" class=field>
        <table width="100%">
            <tr>
    <%
        for(int i=0;i<forwardrights.size();i++){
            HashMap forwardmap=(HashMap)forwardrights.get(i);
            String showname="";
            String itemname="";
            String itemvalue="";
            if(forwardmap!=null){
                showname=(String)forwardmap.get("showname"+user.getLanguage());
                itemname=(String)forwardmap.get("itemname");
                itemvalue=(String)forwardmap.get("itemvalue");
            }
    %>
	  <td><input type=checkbox name="<%=itemname%>" value="1" <%if("1".equals(itemvalue)){%>checked<%}%>><%=showname%></td>

    <%
           if(i>0&&(i+1)<forwardrights.size()&& (i+1)%2==0){
    %>
          </tr><tr>
    <%
           }
        }
    %>

            </tr>
            </table>
        </td>
	</tr>
	<TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
    <%
    }
         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+user.getUID());
        //add by cyril on 2008-09-30 for td:9014
  		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+user.getUID()); 
  		String workflowPhrases[] = new String[RecordSet.getCounts()];
  		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
  		int x = 0 ;
  		if (isSuccess) {
  			while (RecordSet.next()){
  				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
  				workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
  				x ++ ;
  			}
  		}
  		//end by cyril on 2008-09-30 for td:9014
         %>
        <tr class="Title">
          <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
        </tr>
            <tr>
              <td width="20%"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
              <td width="80%">
            <%

if("1".equals(isFormSignature)){

int workflowid=wfid;
int nodeid=currentnodeid;


int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet.next()){
	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
}
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
                <select class=inputstyle  id="phraseselect" name=phraseselect style="width:95%" onChange='onAddPhrase(this.value)'>
                <option value="">－－<%=SystemEnv.getHtmlLabelName(22409,user.getLanguage())%>－－</option>
                <%
                  for (int i= 0 ; i <workflowPhrases.length;i++) {
                    String workflowPhrase = workflowPhrases[i] ;  %>
                    <option value="<%=workflowPhrasesContent[i]%>"><%=workflowPhrase%></option>
                <%}%>
                </select>
          <%}%>
				<input type="hidden" id="remarkText10404" name="remarkText10404" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" value="">
              <textarea class=Inputstyle name=remark id=remark rows=4 cols=40 style="width:95%;display:none" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"   <%if(isSignMustInput.equals("1")){%>onChange="checkinput('remark','remarkSpan')"<%}%>><%=remark%></textarea>
	  		   	<script defer>
	  		   	function funcremark_log(){
	  		   		CkeditorExt.initEditor('frmmain','remark','<%=user.getLanguage()%>',CkeditorExt.NO_IMAGE,200)
					//FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
				<%if(isSignMustInput.equals("1")){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					//FCKEditorExt.getText("remarkText");
					CkeditorExt.toolbarExpand(false,"remark");
				}
				funcremark_log();
				</script>
              <span id="remarkSpan">
<%
	if(isSignMustInput.equals("1")&&"".equals(remark)){
%>
			  <img src="/images/BacoError.gif" align=absmiddle>
<%
	}
%>
              </span>

<%}%>
       </td>
    </tr>
	 <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
	 <%
         if("1".equals(isSignDoc_remark)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids" value="<%=signdocids%>">
                <button type=button  class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"><%=signdocname%></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_remark)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids" value="<%=signworkflowids%>">
                <button type=button  class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"><%=signworkflowname%></span>
            </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isannexupload_remark)){
            int annexmainId=0;
             int annexsubId=0;
             int annexsecId=0;

             if(annexdocCategory_remark!=null && !annexdocCategory_remark.equals("")){
                annexmainId=Util.getIntValue(annexdocCategory_remark.substring(0,annexdocCategory_remark.indexOf(',')));
                annexsubId=Util.getIntValue(annexdocCategory_remark.substring(annexdocCategory_remark.indexOf(',')+1,annexdocCategory_remark.lastIndexOf(',')));
                annexsecId=Util.getIntValue(annexdocCategory_remark.substring(annexdocCategory_remark.lastIndexOf(',')+1));
              }
             int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
             if(annexmaxUploadImageSize<=0){
                annexmaxUploadImageSize = 5;
             }
             char flag1 = Util.getSeparator();
             RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+user.getUID()+flag1+""+(Util.getIntValue(logintype)-1)+flag1+"1");
             String annexdocids = "" ;
             if(RecordSet.next())
             {
                annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
             }
             if(!field_annexupload.equals("")){
                 if(annexdocids.equals("")) annexdocids = field_annexupload;
                 else annexdocids += ","+field_annexupload;
             }
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
            <td class=field>
          <table cols=3 id="field-annexupload_tab">
          <tbody ><col width="50%" >
            <col width="25%" >
            <col width="25%">
           <%
            int linknum=-1;
            if(!annexdocids.equals("")){
            RecordSet.executeSql("select id,docsubject,accessorycount from docdetail where id in("+annexdocids+") order by id asc");
            while(RecordSet.next()){
              linknum++;
              String showid = Util.null2String(RecordSet.getString(1)) ;
              String tempshowname= Util.toScreen(RecordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=RecordSet.getInt(3);

              DocImageManager.resetParameter();
              DocImageManager.setDocid(Util.getIntValue(showid));
              DocImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(DocImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = DocImageManager.getImagefileid();
                docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = DocImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = DocImageManager.getVersionId();
              }
             if(accessoryCount>1){
               fileExtendName ="htm";
             }

              String imgSrc= AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
              %>

          <tr>
            <input type=hidden name="field-annexupload_del_<%=linknum%>" value="0" >
            <td >
              <%=imgSrc%>
              <%if(accessoryCount==1 && (Util.isExt(fileExtendName)||fileExtendName.equalsIgnoreCase("pdf"))){%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDspExt.jsp?id=<%=showid%>&imagefileId=<%=docImagefileid%>&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>')"><%=docImagefilename%></a>&nbsp
              <%}else{%>
                <a style="cursor:hand" onclick="addDocReadTag('<%=showid%>');openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=<%=showid%>&isrequest=1&requestid=<%=requestid%>')"><%=tempshowname%></a>&nbsp
              <%}%>
              <input type=hidden name="field-annexupload_id_<%=linknum%>" value=<%=showid%>>
            </td>
            <td >
                <button type=button  class=btnFlow accessKey=1  onclick='onChangeSharetype("span-annexupload_id_<%=linknum%>","field-annexupload_del_<%=linknum%>","0",<%=annexmaxUploadImageSize%>)'><u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
                </button><span id="span-annexupload_id_<%=linknum%>" name="span-annexupload_id_<%=linknum%>" style="visibility:hidden">
                    <b><font COLOR="#FF0033">√</font></b>
                  <span>
            </td>
            <%if(accessoryCount==1){%>
            <td >
              <span id = "selectDownload">
                <%
                  boolean isLocked=SecCategoryComInfo1.isDefaultLockedDoc(Util.getIntValue(showid));
                  if(!isLocked){
                %>
                  <button type=button  class=btnFlowd accessKey=1  onclick="addDocReadTag('<%=showid%>');downloads('<%=docImagefileid%>')">
                    <u><%=linknum%></u>-<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%>	  (<%=docImagefileSize/1000%>K)
                  </button>
                <%}%>
              </span>
            </td>
            <%}%>
          </tr>
              <%}}%>
            <input type=hidden name="field-annexupload_idnum" value=<%=linknum+1%>>
            <input type=hidden name="field-annexupload_idnum_1" value=<%=linknum+1%>>
          <tr>
            <td colspan=3>
            <%if(annexsecId<1){%>
           <font color="red"> <%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
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
            button_text : '<span class="button"><%=SystemEnv.getHtmlLabelName(21406,user.getLanguage())%></span>',
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

          jQuery(document).ready(function(){
        		fileuploadannexupload();
        		
        	});
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
									<span style="height:19px"><font style="margin:0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage())%></font><!--清除所有选择--></span>
								</span><span>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%><%=annexmaxUploadImageSize%><%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span>
                      <span id="field-annexuploadspan"></span>
                  </div>
                  <input  class=InputStyle  type=hidden size=60 name="field-annexupload" id="field-annexupload" value="<%=annexdocids%>">
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
           <%}%>
            <input type=hidden name='annexmainId' value=<%=annexmainId%>>
          <input type=hidden name='annexsubId' value=<%=annexsubId%>>
          <input type=hidden name='annexsecId' value=<%=annexsecId%>>
            </td>
          </tr>
          </tbody>
          </table>
          </td>
          </tr>
          <tr style="height:1px;"><td class=Line2 colSpan=2></td></tr>
         <%}%>
<!--added by pony on 2006-05-19 for TD4442 -->
	<%
	String workflowid = String.valueOf(wfid);
	String nodeid = String.valueOf(currentnodeid);
	List labelNames = RequestOpinionFieldManager.getOpinionFieldNames(workflowid, nodeid);
	if(labelNames != null){
		for(int i=0; i<labelNames.size(); i++){
			WFOpinionInfo info = (WFOpinionInfo) labelNames.get(i);
			String type = info.getType_cn();
			int fieldid = info.getId();
			String fieldidstr = String.valueOf(fieldid);
    		RequestOpinionBrowserInfo browserInfo = RequestOpinionFieldManager.getBrowserInfo(type);
  %>
  <TR>
    <TD width="20%"> <%=info.getLabel_cn()%></TD>
    <td width="80%" class=field>
		<button type=button  class=Browser onclick="onShowBrowser2('<%=browserInfo.getFieldid()+fieldidstr%>','<%=browserInfo.getUrl()%>','<%=browserInfo.getLinkurl()%>','<%=browserInfo.getFieldtype()%>','<%=browserInfo.getIsMust()%>')" title="<%=info.getLabel_cn()%>" 
		onChange="checkinput('opinionbrowser','field<%=browserInfo.getFieldid()+fieldidstr%>span')"> </button>
		<input type=hidden id="opinionbrowser" name="field<%=browserInfo.getFieldid()+fieldidstr%>">
        <span id="field<%=browserInfo.getFieldid()+fieldidstr%>span">
        <%if(info.getIsMust() == 1){ 
        	needcheck+=",field"+browserInfo.getFieldid()+fieldidstr;
        %>
        <img src="/images/BacoError.gif" align=absmiddle>
		<%}%>
        </span>
	</td>
  </TR>  	   	
  <TR style="height:1px;"><TD class=Line2 colSpan=2></TD></TR>
		<%}%>
	<%}%>
<!-- added end. -->
  </table>
  <br>
  	</td>
		</tr>

		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

  <input type="hidden" name="totaldetail" value=0> 

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>


<!--TD4262 增加提示信息  结束-->


</form>
<script type="text/javascript" src="/js/swfupload/workflowswfupload.js"></script>

<script type="text/javascript">
function getResource(tdname,inputename) {
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	if (id) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
		    resourceids = rid.substr(1);
		    resourcename = rname.substr(1);
			$G(tdname).innerHTML = resourcename;
			$G(inputename).value = resourceids;
		} else {
			$G(tdname).innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>";
			$G(inputename).value = "";
		}
	}
}

function onShowBrowser(id, url, linkurl, type1, ismand) {
    if (type1 == 2 || type1 == 19) {
        id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
        $GetEle("field" + id + "span").innerHTML = id1;
        $GetEle("field" + id).value = id1
    } else {
        if (type1 != 17 && type1 != 18 && type1 != 27 && type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65 && type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169 && type1 != 170) {
            id1 = window.showModalDialog(url)
        } else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?selectedids=" + tmpids)
        } else {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?resourceids=" + tmpids)
        }
        if (id1) {
            if (type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37 || type1 == 56 || type1 == 57 || type1 == 65) {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
                    resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
                    
                    $GetEle("field" + id).value = resourceids;
                    sHtml = "";
                    var idArray = resourceids.split(",");
                    var nameArray = resourcename.split(",");
                    
                    for (var i=0; i<idArray.length; i++) {
                    	curid = idArray[i];
	                    curname = nameArray[i];
	                   
	                    if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
	                        sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp"
	                    } else {
	                        sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname + "</a>&nbsp"
	                    }
                    }
                   
                    $GetEle("field" + id + "span").innerHTML = sHtml;
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = "";
                }
            } else {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    if (linkurl == "") {
                        $GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1)
                    } else {
                        if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
                            $GetEle("field" + id + "span").innerHTML = "<a href=javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp"
                        } else {
                            $GetEle("field" + id + "span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + ">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>"
                        }
                    }
                    $GetEle("field" + id).value = wuiUtil.getJsonValueByIndex(id1, 0);
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = ""
                }
            }
        }
    }
}

function onShowBrowser2(id, url, linkurl, type1, ismand) {
    if (type1 == 2 || type1 == 19) {
        id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");
        $GetEle("field" + id + "span").innerHTML = id1;
        $GetEle("field" + id).value = id1
    } else {
        if (type1 != 135 && type1 != 17 && type1 != 18 && type1 != 27 && type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65 && type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169 && type1 != 170) {
            id1 = window.showModalDialog(url)
        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170) {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?selectedids=" + tmpids)
        } else {
            tmpids = $GetEle("field" + id).value;
            id1 = window.showModalDialog(url + "?resourceids=" + tmpids)
        }
        if (id1) {
            if (type1 == 135 || type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37 || type1 == 56 || type1 == 57 || type1 == 65) {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
                    resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
                    
                    $GetEle("field" + id).value = resourceids;
                    sHtml = "";
                    var idArray = resourceids.split(",");
                    var nameArray = resourcename.split(",");
                    
                    for (var i=0; i<idArray.length; i++) {
                    	curid = idArray[i];
	                    curname = nameArray[i];
	                   
	                    if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
	                        sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp"
	                    } else {
	                        sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname + "</a>&nbsp"
	                    }
                    }
                   
                    $GetEle("field" + id + "span").innerHTML = sHtml;
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = "";
                }
            } else {
                if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                    if (linkurl == "") {
                        $GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1)
                    } else {
                        if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
                            $GetEle("field" + id + "span").innerHTML = "<a href=javaScript:openhrm(" + wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp"
                        } else {
                            $GetEle("field" + id + "span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + ">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>"
                        }
                    }
                    $GetEle("field" + id).value = wuiUtil.getJsonValueByIndex(id1, 0);
                } else {
                    if (ismand == 0) {
                        $GetEle("field" + id + "span").innerHTML = "";
                    } else {
                        $GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError.gif' align=absmiddle>"
                    }
                    $GetEle("field" + id).value = ""
                }
            }
        }
    }
}

function onShowSignBrowser(url, linkurl, inputname, spanname, type1) {
    tmpids = $GetEle(inputname).value;
    if (type1 == 37) {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids)
    } else {
        id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids)
    }
    if (id1) {
        if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
            resourceids = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
            resourcename = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
            sHtml = "";
            $GetEle(inputname).value = resourceids;
           	
           	var idArray = resourceids.split(",");
           	var nameArray = resourcename.split(",");
           	
           	for (var i=0; i<idArray.length; i++) {
           		curid = idArray[i];
	            curname = nameArray[i];
	            sHtml = sHtml + "<a href=" + linkurl + curid + " target='_blank'>" + curname + "</a>&nbsp";
           	}
           	
            $GetEle(spanname).innerHTML = sHtml
        } else {
            $GetEle(spanname).innerHTML = "";
            $GetEle(inputname).value = ""
        }
    }
}
</script>
<!-- 
<script language=vbs>
sub getResource(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if NOT isempty(id) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
	    resourceids=Mid(resourceids,2,len(resourceids))
	    resourcename = Mid(resourcename,2,len(resourcename))
		$GetEle(tdname).innerHtml = resourcename
		$GetEle(inputename).value=resourceids
		else
		$GetEle(tdname).innerHtml = "<img src='/images/BacoError.gif' align=absmiddle>"
		$GetEle(inputename).value=""
	end if
	end if
end sub

sub onShowBrowser(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		$GetEle("field"+id+"span").innerHtml = id1
		$GetEle("field"+id).value=id1
	else
		if type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = $GetEle("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = $GetEle("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$GetEle("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
						end if
					wend
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					end if
					
					$GetEle("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						$GetEle("field"+id+"span").innerHtml = empty
					else
						$GetEle("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$GetEle("field"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						$GetEle("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$GetEle("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$GetEle("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
						
					end if
					$GetEle("field"+id).value=id1(0)
				else
					if ismand=0 then
						$GetEle("field"+id+"span").innerHtml = empty
					else
						$GetEle("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$GetEle("field"+id).value=""
				end if
			end if
		end if
	end if

end sub
</script>
<SCRIPT LANGUAGE="VBS">
sub onShowBrowser2(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")
		$GetEle("field"+id+"span").innerHtml = id1
		$GetEle("field"+id).value=id1
	else
		if type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = $GetEle("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = $GetEle("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 then
				if id1(0)<> ""  and id1(0)<> "0" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					$GetEle("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
						end if
						
					wend
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					end if
					$GetEle("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						$GetEle("field"+id+"span").innerHtml = empty
					else
						$GetEle("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$GetEle("field"+id).value=""
				end if

			else
			   if  id1(0)<>""   and id1(0)<> "0"  then
			        if linkurl = "" then
						$GetEle("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							$GetEle("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							$GetEle("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
					end if
					$GetEle("field"+id).value=id1(0)
				else
					if ismand=0 then
						$GetEle("field"+id+"span").innerHtml = empty
					else
						$GetEle("field"+id+"span").innerHtml ="<img src='/images/BacoError.gif' align=absmiddle>"
					end if
					$GetEle("field"+id).value=""
				end if
			end if
		end if
	end if

end sub
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = $GetEle(inputname).value
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
					$GetEle(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					$GetEle(spanname).innerHtml = sHtml

		else
				    $GetEle(spanname).innerHtml = empty
					$GetEle(inputname).value=""
        end if
      end if
end sub
</script>

 -->
<script language=javascript>



var rowindex="<%=rowindex%>";
function addRow()
{	
	ncol = oTable1.cols;
	oRow = oTable1.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= "#D2D1F1";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_resource' value="+rowindex+">"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
            	var sHtml = "<button type=button  class=browser onclick=getResource('resourcespan"+rowindex+"','resourceid"+rowindex+"')></button>&nbsp;"+
            		"<span id='resourcespan"+rowindex+"'><img src='/images/BacoError.gif' align=absmiddle></span>"+
            		"<input type=hidden name='resourceid"+rowindex+"'>"; 
            	oDiv.innerHTML = sHtml;
            	oCell.appendChild(oDiv); 
				break;
		}
	}
	rowindex = rowindex*1 +1;
}

function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_resource')
			rowsum1 ++;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_resource'){
			if(document.forms[0].elements[i].checked==true)
				oTable1.deleteRow(rowsum1);	
			rowsum1--;
		}
	}
}

function doSave(obj){<%--xwj for td2104 on 2005-08-01--%>
    var parastr = "" ;
	var len = document.forms[0].elements.length;
	var i=0;
	for(i=len-1; i >= 0;i--){
		if (document.forms[0].elements[i].name=='check_resource'){
			parastr+=",resourceid"+document.forms[0].elements[i].value;
		}
	}
    if(parastr.length>0){
		parastr=parastr.substring(1);
    }
    if(check_form(frmmain,parastr)){
		frmmain.totaldetail.value=rowindex;
		frmmain.operate.value="save";
		getRemarkText_log();
		var ischeckok="true";
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
			if(check_form(frmmain,'field5'+'<%=needcheck%>')){
				if ("<%=needconfirm%>"=="1"){
					if (!confirm("<%=SystemEnv.getHtmlLabelName(19992,user.getLanguage())%>")){
						return false;
					}
				}				
<%
//保存签章数据
if("1".equals(isFormSignature)){%>
				if(SaveSignature()){
				    //TD4262 增加提示信息  开始
				    var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
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
					return ;
				}
<%}else{%>
        //TD4262 增加提示信息  开始
        var content="<%=SystemEnv.getHtmlLabelName(18981,user.getLanguage())%>";
        showPrompt(content);
        //TD4262 增加提示信息  结束
        obj.disabled=true;
        //附件上传
        StartUploadAll();
        checkuploadcomplet();
<%}%>
			}
		}
	}
}
function getRemarkText_log(){
	try{
		CkeditorExt.updateContent();
		var remarkText = CkeditorExt.getText("remark");
		document.getElementById("remarkText10404").value = remarkText;
	}catch(e){}
}
function doBack(obj)
{
	obj.disabled=true;
	history.go(-1);
}

function CheckAll() {
    len = document.frmmain.elements.length;
    var i=0;
    for( i=0; i<len; i++) {
        if (document.frmmain.elements[i].name=='check_resource') 
            document.frmmain.elements[i].checked=true;
    } 
}
</script>

<script language="javascript">
function submitData()
{
	if (check_form(weaver,'type,desc'))
		weaver.submit();
}

function submitDel()
{
	if(isdel()){
		deleteRow();
		}
}

//TD4262 增加提示信息  开始
//提示窗口
function showPrompt(content)
{

	var showTableDiv  = $GetEle('_xTable');
    var message_table_Div = document.createElement("div")
    message_table_Div.id="message_table_Div";
    message_table_Div.className="xTable_message";
    showTableDiv.appendChild(message_table_Div);
    var message_table_Div  = $GetEle("message_table_Div");
    message_table_Div.style.display="inline";
    message_table_Div.innerHTML=content;
    var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
    var pLeft= document.body.offsetWidth/2-50;
    message_table_Div.style.position="absolute"
    jQuery(message_table_Div).css("top", pTop);
    jQuery(message_table_Div).css("left", pLeft);

    message_table_Div.style.zIndex=1002;
    var oIframe = document.createElement('iframe');
    oIframe.id = 'HelpFrame';
    showTableDiv.appendChild(oIframe);
    oIframe.frameborder = 0;
    oIframe.style.position = 'absolute';
   
    jQuery(oIframe).css("top", pTop);
    jQuery(oIframe).css("left", pLeft);
    
    oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
    oIframe.style.width = parseInt(message_table_Div.offsetWidth);
    oIframe.style.height = parseInt(message_table_Div.offsetHeight);
    oIframe.style.display = 'block';
}

//TD4262 增加提示信息  结束

function onAddPhrase(phrase){            
	if(phrase!=null && phrase!=""){
		try{
			var remarkHtml = CkeditorExt.getHtml("remark");
			var remarkText = CkeditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				CkeditorExt.setHtml(phrase);
			}else{
				CkeditorExt.setHtml(remarkHtml+"<p>"+phrase+"</p>");
			}
		}catch(e){}
		document.getElementById("remarkSpan").innerHTML = "";
	}
}
function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=document.getElementById("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    document.getElementById(objName).outerHTML=outerHTML;
    document.getElementById(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  } 

 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";

    if($GetEle(delspan).style.visibility=='visible'){
      $GetEle(delspan).style.visibility='hidden';
      $GetEle(delid).value='0';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
    }else{
      $GetEle(delspan).style.visibility='visible';
      $GetEle(delid).value='1';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
    }
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($GetEle(fieldidnum).value=="0")
	  {
	    $GetEle("needcheck").value=$GetEle("needcheck").value+","+fieldid;
		$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";

		//$GetEle(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if ($GetEle("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     $GetEle("needcheck").value=$GetEle("needcheck").value.substr(0,$GetEle("needcheck").value.indexOf(","+fieldid));
		 $GetEle(fieldidspan).innerHTML="";
		// $GetEle(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
  }
</script>
</body>
</html>