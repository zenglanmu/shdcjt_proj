<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="weaver.conn.ConnStatement" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%
int ismultiprintmode = Util.getIntValue(request.getParameter("ismultiprintmode"));
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();
//TD9892
BaseBean bb_printmode = new BaseBean();
int urm_printmode = 1;
try{
	urm_printmode = Util.getIntValue(bb_printmode.getPropValue("systemmenu", "userightmenu"), 1);
	if(ismultiprintmode == 1){
		urm_printmode = 0;
	}
}catch(Exception e){}

String isbill = Util.null2String(request.getParameter("isbill"));
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String formid = Util.null2String(request.getParameter("formid"));
String billid = Util.null2String(request.getParameter("billid"));    
int requestid = Util.getIntValue(request.getParameter("requestid"));
String nodeid = Util.null2String(request.getParameter("nodeid"));
int urger=Util.getIntValue(request.getParameter("urger"),0);
int ismonitor=Util.getIntValue(request.getParameter("ismonitor"),0);    
//add by mackjoe at 2005-12-20 增加模板应用
String ismode="";
int modeid=0;
int isform=0;
int printdes=0;
int creater = 0;
int creatertype = 0;
int userid = user.getUID();
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
boolean canprint = false;
String modestr="";
String sql="";

sql = "select * from workflow_requestbase where requestid = " + requestid;
RecordSet.executeSql(sql);
if(RecordSet.next()){
   creater = RecordSet.getInt("creater");
   creatertype = RecordSet.getInt("creatertype");
}

//根据当前用户是否为流程的节点操作者来判断能否打印流程
sql = "select * from workflow_currentoperator where requestid = " + requestid + " and userid = " + userid;
RecordSet.executeSql(sql);
if(RecordSet.next()){
   canprint = true;
}
//相关流程可以打印
String wflinkno = Util.null2String((String) session.getAttribute(requestid+"wflinkno"));
if(!wflinkno.equals("")){
   canprint = true;
}
//主流程和子流程相互查看
ArrayList canviewwff = (ArrayList)session.getAttribute("canviewwf");
if(canviewwff!=null){
   if(canviewwff.indexOf(requestid+"")>-1)
         canprint = true;
}
if(creater == userid && creatertype == usertype){   // 创建者本人有打印权限
	canprint = true;
}
if(CoworkDAO.haveRightToViewWorkflow(Integer.toString(userid),Integer.toString(requestid))){//协作区
    canprint = true;
}

if(WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1)) || WFUrgerManager.getMonitorViewRight(requestid,userid)){//督办流程和监控流程的相关流程有打印权限
    canprint = true;    
}
if(!canprint){
    boolean isurger=false;
    boolean wfmonitor=false;
    if(urger==1)  isurger=WFUrgerManager.UrgerHaveWorkflowViewRight(requestid,userid,Util.getIntValue(logintype,1));
    if(ismonitor==1) wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);
    if(!isurger&&!wfmonitor){
    response.sendRedirect("/notice/noright.jsp");
    return;
    }
}
int toexcel=0;
RecordSet.executeSql("select ismode,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
    printdes=Util.getIntValue(Util.null2String(RecordSet.getString("printdes")),0);
    toexcel=Util.getIntValue(Util.null2String(RecordSet.getString("toexcel")),0);
}
if(  printdes!=1){
    RecordSet.executeSql("select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        modeid=RecordSet.getInt("id");
    }else{
        RecordSet.executeSql("select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc");
        while(RecordSet.next()){
            if(modeid<1){
                modeid=RecordSet.getInt("id");
                isform=1;
            }
        }
    }
}
if(modeid<=0){
	if(ismultiprintmode == 1){
		return;
	}
%>
<script type="text/javascript">
var redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&urger=<%=urger%>&ismonitor=<%=ismonitor%>" ;
<%//解决相关流程打印权限问题
if(!wflinkno.equals("")){
%>
redirectUrl = "PrintRequest.jsp?requestid=<%=requestid%>&isprint=1&fromFlowDoc=1&isrequest=1&wflinkno=<%=wflinkno%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>";
<%}%>
var width = screen.width ;
var height = screen.height ;
if (height == 768 ) height -= 75 ;
if (height == 600 ) height -= 60 ;
var szFeatures = "top=0," ;
szFeatures +="left=0," ;
szFeatures +="width="+width+"," ;
szFeatures +="height="+height+"," ;
szFeatures +="directories=no," ;
szFeatures +="status=yes," ;
szFeatures +="menubar=no," ;
szFeatures +="toolbar=yes," ;
szFeatures +="scrollbars=yes," ;

szFeatures +="resizable=yes" ; //channelmode
window.open(redirectUrl,"",szFeatures) ;
window.opener=null;
window.close();
</script>
<%
     return;
 }
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
     uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
     selectedfieldid = result.substring(0,result.indexOf(","));
 }    
//end by mackjoe
%>

<BODY id="flowbody" style="overflow:auto" onload="init()">
<%if(ismultiprintmode!=1){%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:doPrint(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18173,user.getLanguage())+",javascript:dosystemhead(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
if(toexcel==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+" Excel,javascript:ToExcel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<%}%>
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
		<TABLE class=Shadow>
		<tr>
		<td width="100%" height=100% valign="top">
<script language=javascript src="/workflow/mode/loadmode.js"></script>
<script language=javascript src="/js/characterConv.js"></script>
<script type="text/javascript">
function getOuterLanguage()
{
	return '<%=acceptlanguage%>';
}
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ShowCellChanged()"	LANGUAGE="JavaScript" >
var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
var cellvalue=frmmain.ChinaExcel.GetCellValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
cellvalue = Simplized(cellvalue);
var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
	showPopup(uservalue,cellvalue,ismand,0);   
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        hidePopup();
        <%if(urm_printmode==1){%>
        rightMenu.style.left=frmmain.ChinaExcel.GetMousePosX();
		rightMenu.style.top=frmmain.ChinaExcel.GetMousePosY();
		rightMenu.style.visibility="visible";
		<%}%>		
		return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="CellContentChanged()"	LANGUAGE="JavaScript" >
    imgshoworhide(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    var cellvalue=frmmain.ChinaExcel.GetCellValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    cellvalue = Simplized(cellvalue);
    var ismand=frmmain.ChinaExcel.GetCellUserValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col);
    changevalue(uservalue,cellvalue,ismand);
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="ComboSelChanged()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var selvalue=GetCellComboSelectedValue(nrow,ncol);
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    var nindx=uservalue.lastIndexOf("_");
    if(nindx>0){
        uservalue=uservalue.substring(0,nindx);
        nindx=uservalue.lastIndexOf("_");
        if(nindx>0){
            uservalue=uservalue.substring(0,nindx);
        }
    }
    document.all("selframe").src="/workflow/request/WorkflowModeSel.jsp?nrow="+nrow+"&ncol="+ncol+"&selvalue="+selvalue+"&fieldid="+uservalue+"&isbill=<%=isbill%>";
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="CheckBoxCliceked()"	LANGUAGE="JavaScript" >
    var nrow= frmmain.ChinaExcel.Row;
    var ncol=frmmain.ChinaExcel.Col;
    var checkvalue="0";
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(nrow,ncol);
    if(uservalue.indexOf("_sel")<0){
        var nindx=uservalue.lastIndexOf("_");
        if(nindx>0){
            uservalue=uservalue.substring(0,nindx);
            nindx=uservalue.lastIndexOf("_");
            if(nindx>0){
                uservalue=uservalue.substring(0,nindx);
            }
        }
        if(GetCellCheckBoxValue(nrow,ncol)){
            checkvalue="1";
        }
        document.getElementById(uservalue).value=checkvalue;
    }
	return false;
</script>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick()"	LANGUAGE="JavaScript" >
	<%if(urm_printmode==1){%>
    rightMenu.style.visibility="hidden";
    <%}%>
    var uservalue=frmmain.ChinaExcel.GetCellUserStringValue(frmmain.ChinaExcel.Row,frmmain.ChinaExcel.Col); 
    var fieldname=uservalue;
    if(uservalue!=null){
        var indx=uservalue.lastIndexOf("_");
        if(indx>0){
            var addordel=uservalue.substring(indx+1);
            uservalue=uservalue.substring(0,indx);
            if(addordel=="6"){
                indx=uservalue.indexOf("_");
                if(indx>0){
                    uservalue=uservalue.substring(0,indx);
                }
                var fieldvalue=document.getElementById(uservalue).value;
                if(fieldvalue.length>0){
                var selectfieldvalue="";
                <%
                if(!selectedfieldid.equals("")){
                %>
                if(document.getElementById("field<%=selectedfieldid%>")) selectfieldvalue=document.getElementById("field<%=selectedfieldid%>").value
                <%}%>    
                var redirectUrl = "/workflow/request/WorkFlowFileUP.jsp?fieldvalue="+fieldvalue+"&fieldname="+fieldname+"&workflowid=<%=workflowid%>&fieldid="+uservalue+"&isedit=0&isbill=<%=isbill%>&uploadType=<%=uploadType%>&selectedfieldid=<%=selectedfieldid%>&selectfieldvalue="+selectfieldvalue;
                var szFeatures = "top="+(screen.height-300)/2+"," ;
                szFeatures +="left="+(screen.width-750)/2+"," ;
                szFeatures +="width=750," ;
                szFeatures +="height=300," ; 
                szFeatures +="directories=no," ;
                szFeatures +="status=no," ;
                szFeatures +="menubar=no," ;
                szFeatures +="scrollbars=yes," ;
                szFeatures +="resizable=no" ; //channelmode
                window.open(redirectUrl,"fileup",szFeatures) ;
                frmmain.ChinaExcel.GoToCell(1,1);
                }
            }
        }
    }
	return false;
</SCRIPT>

<form name="frmmain" method="post" action="RequestOperation.jsp" enctype="multipart/form-data">
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj.js"></script>
<%} %>
<DIV id="ocontext" name="ocontext" style="LEFT: 0px;Top:0px;POSITION:ABSOLUTE ;display:none" >
<table id=otable cellpadding='0' cellspacing='0' width="200" border=1 style="WORD-WRAP:break-word">
</table>
</DIV>
<input type=hidden name="indexrow" id="indexrow" value=0>
<input type=hidden name="isform" id="isform" value="<%=isform%>">
<input type=hidden name="modeid" id="modeid" value="<%=modeid%>">
<input type=hidden name="modestr" id="modestr" value="">
<input type=hidden name ="needcheck" value="">

<jsp:include page="PrintHiddenField.jsp" flush="true">
    <jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="formid" value="<%=formid%>" />
    <jsp:param name="billid" value="<%=billid%>" />
    <jsp:param name="isbill" value="<%=isbill%>" />
    <jsp:param name="nodeid" value="<%=nodeid%>" />
    <jsp:param name="Languageid" value="<%=user.getLanguage()%>" />
	</jsp:include>
</form>
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
</body>
</html>
<script language=javascript>
function readmode(){
    frmmain.ChinaExcel.ReadHttpFile("/workflow/mode/ModeReader.jsp?modeid=<%=modeid%>&nodeid=<%=nodeid%>&isform=<%=isform%>");
}
</script>
<script language=vbs>
sub init()
    frmmain.ChinaExcel.SetOnlyShowTipMessage true
    chinaexcelregedit()
	readmode()
    frmmain.ChinaExcel.DesignMode = false
    frmmain.ChinaExcel.SetShowPopupMenu false
    frmmain.ChinaExcel.SetCanAutoSizeHideCols true
    frmmain.ChinaExcel.SetProtectFormShowCursor true
    frmmain.ChinaExcel.ShowGrid = false
    frmmain.ChinaExcel.SetShowScrollBar 1,false
    getRowGroup()
    setmantable()
    setdetailtable()
    setnodevalue()
    frmmain.ChinaExcel.ReCalculate()
    frmmain.ChinaExcel.FormProtect true
    frmmain.ChinaExcel.SetPasteType 1
    frmmain.ChinaExcel.height= "100%"
    frmmain.ChinaExcel.GoToCell 1,1
    RefreshViewSize()
    frmmain.ChinaExcel.SetOnlyShowTipMessage false
	convertText()
<%if(ismultiprintmode==1){%>
	bodyresize()
<%}%>
end sub
</script>
<script language=javascript>
function bodyresize(){
	var totalheight = gettotalheight();
	var totalwidth = gettotalwidth();
	parent.document.getElementById("requestiframe<%=requestid%>").height = totalheight + 50;
	parent.document.getElementById("requestiframe<%=requestid%>").width = totalwidth + 50;
	var objAList = document.getElementsByTagName("A");
	for(var i=0; i<objAList.length; i++){
		var obj = objAList[i];
		var href = obj.href;
		var target = obj.target;
		if(href.indexOf("javascript:") == -1){
			obj.target = "_blank";
		}
	}
}
function window.onresize(){
    frmmain.ChinaExcel.height= "100%"
    frmmain.ChinaExcel.SetShowScrollBar(1,true);
}
function doPrint(){
    frmmain.ChinaExcel.SetUseDefaultPrinter(true);
    frmmain.ChinaExcel.OnFilePrintPreview();
}
function RefreshViewSize(){
	<%if(urm_printmode==1){%>
    //rightMenu.focus();
	    try {
		    rightMenu.focus();
	    }catch(e) {
	    }
    <%}%>
    for(r=0;r<rowgroup.length;r++){
        rhead=frmmain.ChinaExcel.GetCellUserStringValueRow("detail"+r+"_head");
        frmmain.ChinaExcel.SetRowHide(rhead,rhead+rowgroup[r],true);
    }
    frmmain.ChinaExcel.RefreshViewSize();
}        
function dosystemhead(){
    frmmain.ChinaExcel.ShowHeader =!frmmain.ChinaExcel.ShowHeader;
}
function gettotalheight(){
	var maxrow=frmmain.ChinaExcel.GetMaxRow();
	var totalheight=0;
	for(var i=1;i<=maxrow;i++){
		totalheight+=frmmain.ChinaExcel.GetRowSize(i,1);
	}
	return totalheight;
}
function gettotalwidth(){
    var maxcol=parent.requestiframe<%=requestid%>.frmmain.ChinaExcel.GetMaxCol();
    var totalwidth=0;
    for(var i=1;i<=maxcol;i++){
    	totalwidth += parent.requestiframe<%=requestid%>.frmmain.ChinaExcel.GetColSize(i,1);
    }
    return totalwidth;
}
function openWindow(urlLink){

  	window.open(urlLink);

}
function convertText() {
	var cx = frmmain.ChinaExcel;
	cx.FormProtect = false; 
	var maxRow = cx.GetMaxRow();
	for (var x=1; x<=maxRow; x++) {
		var cellpx = cx.GetRowSize(x, 1);
		if (cellpx >= 1000) {
			for (var y=1; y<=cx.getMaxCol(); y++) {
			    cx.SetCellProtect(x, y, x, y, false);
				cx.SetCellLargeTextType(x, x, y);
				cx.SetCellProtect(x, y, x, y, true);
				maxRow = cx.GetMaxRow();
			}
		}
	}
	cx.FormProtect = true; 
}
</script>