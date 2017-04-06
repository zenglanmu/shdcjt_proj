<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%WFNodeMainManager.resetParameter();%>
<html>
<%
int design = Util.getIntValue(request.getParameter("design"),0);
	String submitKey="";
	String total="";
	int currentnodeid=0;
	String saveIds="";
	String saveFlag="-1";//  "1"  代表 "全选" 或 "选择部分"
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	total=Util.null2String(request.getParameter("total"));
	currentnodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
	submitKey = Util.null2String(request.getParameter("submitKey"));
	String[] selectIds = request.getParameterValues("check_node");
	
if("save".equals(submitKey)){
	
  if(selectIds!=null){

	if(!String.valueOf(selectIds.length).equals(total)){
	for(int i=0; i < selectIds.length; i++){
	  saveIds += selectIds[i] + ",";
	}
	RecordSet1.executeSql("update workflow_flownode set viewnodeids='" + saveIds + "' where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	}
	else{
	RecordSet1.executeSql("update workflow_flownode set viewnodeids='-1' where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	}
	
	saveFlag ="1";
	}
	
 else{
	RecordSet1.executeSql("update workflow_flownode set viewnodeids='' where workflowid= " + wfid + " and nodeid = " + currentnodeid);
	saveFlag ="-1";
	}
	
}
	
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
  String message = Util.null2String(request.getParameter("message"));
  String viewIdsStr = "-1";
%>
<head>

<script language=vbs>
if "<%=submitKey%>" = "save" then
	window.parent.returnvalue = "<%=saveFlag%>"
	window.parent.close
end if
</script>


<%
ArrayList list = new ArrayList();
RecordSet.executeSql("select viewnodeids from workflow_flownode where workflowid=" + wfid + " and nodeid = " +currentnodeid);
if(RecordSet.next()){
viewIdsStr = RecordSet.getString("viewnodeids");
}
if("-1".equals(viewIdsStr)){//查看全部
RecordSet.executeSql("select nodeid from workflow_flownode where workflowid=" + wfid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and requestid is null )");
while(RecordSet.next()){
list.add(RecordSet.getString("nodeid"));
}
}
else if( viewIdsStr == null || "".equals(viewIdsStr)){//全部不能查看
viewIdsStr = "";
}
else{//部分可查看
String tempnodeids[] = Util.TokenizerString2(viewIdsStr, ",");
for(int i=0; i<tempnodeids.length; i++){
list.add(tempnodeids[i]);
}
}

%>

<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
if(message.equals("1")){

titlename = titlename + "<font color=red>Create" +SystemEnv.getHtmlLabelName(15595,user.getLanguage());
titlename = titlename +"!</font>";
}
String needfav ="1";
String needhelp ="";
%>
</head>
<body>
<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
}
%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:save(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.parent.close(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form id=weaver name=weaver method=post action="wfNodeBrownser.jsp">
<input type="hidden" value="<%=design%>" name="design">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="20">
<col width="">
<col width="20">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table class="ViewForm" cols=3>
 
      	<COLGROUP>
  	<COL width="10%">
  	<COL width="45%">
  	<COL width="45%">
        <TR class="Title">
    	  <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15596,user.getLanguage())%></TH></TR>
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
</table>
<table class="ViewForm" cols=3 id="oTable">
 
      	<COLGROUP>
  	<COL width="25%">
  	<COL width="75%">
  
    	   <tr class=header> 
            <td>
            <%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>
            <input type='checkbox' name='check_all' <%if("-1".equals(viewIdsStr)){%>checked<%}%> onclick="selectAll()">
            </td>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
            
</tr>  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
<%
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode(); 
while(WFNodeMainManager.next()){
int tmpid = WFNodeMainManager.getNodeid();
String tmpname = WFNodeMainManager.getNodename();
String tmptype = WFNodeMainManager.getNodetype();
%>
<tr>
<td  height="23"><input type='checkbox' name='check_node' value="<%=tmpid%>" <%if(list.contains(String.valueOf(tmpid))){%> checked <%}%> ></td>
<td  height="23">
<%if(tmpid!=currentnodeid){%><%=tmpname%><%}else{%><b><%=tmpname%></b><%}%>
</td>
</tr>
<%
}
%>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="2"></td>
</tr>
</table>


<center>
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=currentnodeid%>" name="nodeid">
<input type="hidden" value="<%=total%>" name="total">
<input type="hidden" value="<%=submitKey%>" name="submitKey">
<center>
</form>

<script>

function selectAll(){
	var rows = document.all("check_node").length;
	if(document.all("check_all").checked){
   for(var i=0; i < rows; i++){
	  document.all("check_node")[i].checked = true;
	  
	}
	}
	else{
	for(var i=0; i < rows; i++){
	  document.all("check_node")[i].checked = false;
	 
	}
	}
	
}

function save(){
	document.all("submitKey").value = "save";
	document.all("total").value = document.all("check_node").length;
	document.weaver.submit();
}
//工作流图形化确定
function designOnClose() {
//td19600
	<%
		boolean bolFlag = false;
		if("1".equals(saveFlag)) {
			bolFlag = true;			
		}
	%>
	window.parent.design_callback('wfNodeBrownser','<%=bolFlag%>');
	//td19600
}

</script>

</body>

</html>
