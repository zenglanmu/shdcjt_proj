<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver.js"></script>
<LINK href="/js/jquery/jquery_dialog.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/green/wui.css'/>
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont.css' id="FONT2SYSTEMF">
<link href="/js/swfupload/default.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogressBywf.js"></script>
<script type="text/javascript" src="/js/swfupload/handlersBywf.js"></script>
<script language=javascript src="/js/jquery/jquery.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt.js"></script>
</HEAD>
<body>
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<form id="frmmain" name="frmmain" target="self" action="" method="post">
<div id="rightMenu" name="rightMenu"  style="Z-INDEX:1000;height:0px;width:0px">
<iframe id="rightMenuIframe" name="rightMenuIframe"  frameborder=0 marginheight=0 marginwidth=0 hspace=0 vspace=0 scrolling=no width="0px" height="0px" >
</iframe>
</div>
<%

int modeid = Util.getIntValue(request.getParameter("modeid"), 0);
wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(1);
Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
out.println(wfformhtml);
StringBuffer jsStr = wfLayoutToHtml.getJsStr();
%>

</form>
</body>
</HTML>
<script type="text/javascript" src="/js/swfupload/workflowswfupload.js"></script>
<SCRIPT language="javascript">
<%out.println(jsStr.toString());%>
function initFieldValue(fieldid){

}

function doSqlFieldAjax(obj,fieldids){

}

function doFieldAjax(thisfieldid,fieldidtmp,fieldExt){

}

</script>
<SCRIPT language="javascript">

function setMaxUploadInfo(){

}
setMaxUploadInfo();
//目录发生变化时，重新检测文件大小
function reAccesoryChanage(){

}
//选择目录时，改变对应信息
function changeMaxUpload(fieldid){

}
function funcClsDateTime(){

}				

function createDoc(fieldbodyid,docVlaue,isedit){

}
function openDocExt(showid,versionid,docImagefileid,isedit){

}

function openAccessory(fileId){ 

}
function onNewDoc(fieldid) {

}

function datainput(parfield){

}
function getWFLinknum(wffiledname){

}
function datainputd(parfield){

}

function changeChildField(obj, fieldid, childfieldid){

}
function doInitChildSelect(fieldid,pFieldid,finalvalue){

}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){

}
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){

}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){

}
</script>
<script type="text/javascript">
function onShowBrowser3(id,url,linkurl,type1,ismand) {

}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {

}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {

}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {

}
function doFieldDateAjax(para, fieldidtmp, fieldExt){
}
</script>
<script language="javascript">
function getNumber(index){

}
function numberToChinese(index){

}
var tableformatted = false;
var needformatted = true;
function formatTables(){

}
function doDisableAll_s(){
	jQuery("*").removeAttr("onchange");
	jQuery("*").removeAttr("onclick");
	jQuery("*").removeAttr("onBlur");
	jQuery("*").removeAttr("onKeyPress");
	jQuery("*").removeAttr("onpropertychange");
	jQuery("*").removeAttr("onfocus");
	//jQuery("*").removeAttr("onblur");
}
jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	formatTables();
	doDisableAll_s();
});


function onChangeCode(ismand){

}
</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<script type="text/javascript" src="/js/selectDateTime.js"></script>