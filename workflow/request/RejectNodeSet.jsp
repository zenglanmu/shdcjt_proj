<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestRejectManager" class="weaver.workflow.request.RequestRejectManager" scope="page" />

<%
    int requestid=Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
	 int workflowid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
    int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    int isrejectremind=Util.getIntValue(Util.null2String(request.getParameter("isrejectremind")),0);
    int ischangrejectnode=Util.getIntValue(Util.null2String(request.getParameter("ischangrejectnode")),0);
    int isselectrejectnode=Util.getIntValue(Util.null2String(request.getParameter("isselectrejectnode")),0);
    ArrayList[] nodelist;
    ArrayList nodeids=new ArrayList();
    ArrayList nodenames=new ArrayList();
	/*
    String sql="select a.nodeid,b.nodename from workflow_currentoperator a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" order by a.id";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        if(nodeids.indexOf(Util.null2String(RecordSet.getString("nodeid")))<0){
            nodeids.add(Util.null2String(RecordSet.getString("nodeid")));
            nodenames.add(Util.null2String(RecordSet.getString("nodename")));
        }
    }*/ 
	//根据requestid和userid查询到当前的节点id!不知道为什么nodeid不准确,....可能是以前的bug,...不动以前的东西.
	int realnodeid = -1; 
    String sql2 = "SELECT  nodeid FROM workflow_currentoperator WHERE  userid = "+user.getUID()+" and islasttimes=1  AND requestid = "+requestid;
	RecordSet.executeSql(sql2);
	while(RecordSet.next()){ 
		realnodeid =Util.getIntValue(RecordSet.getString("nodeid"));
	}
	String ss = "SELECT  nb.id , nb.nodename FROM workflow_nodelink nl , workflow_nodebase nb WHERE wfrequestid IS NULL AND NOT EXISTS ( SELECT 1 FROM workflow_nodebase b WHERE nl.nodeid = b.id AND b.IsFreeNode = '1' ) AND NOT EXISTS ( SELECT 1 FROM workflow_nodebase b WHERE nl.destnodeid = b.id AND b.IsFreeNode = '1' ) AND nl.destnodeid = nb.id AND nl.nodeid = "+realnodeid+" AND nl.workflowid = "+workflowid+" AND nl.isreject = 1 ORDER BY nodeid , nl.id ";
	
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css" href="/css/xpSpin.css">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<body>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onsave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=97% border="0" cellspacing="0" cellpadding="0">
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
		<td valign="top">
  <table class=liststyle cellspacing=1>
      	<COLGROUP>
  	<COL width="30%">
  	<COL width="70%">
           	<% 
if(isselectrejectnode==1){  
nodelist=RequestRejectManager.getPathWayNodes(workflowid,requestid,realnodeid); 
int defaultnodeid=RequestRejectManager.getDefaultRejectNode(requestid,realnodeid);  

ArrayList rejectnodeids=nodelist[0];
ArrayList rejectnodenames=nodelist[1];
%>
<TR class="Title"><!-- 可退回节点 -->
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(26437,user.getLanguage())%></th><th>
    	  </TH></TR>
      <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
           <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
</tr><tr class="Line"><td colspan="2"> </td></tr>
<%
    int colorcount=0;  
	RecordSet.executeSql(ss); 
	//添加默认的节点.
	while(RecordSet.next()){ 
		if(!rejectnodeids.contains(RecordSet.getInt("id")+"")){
			rejectnodeids.add(RecordSet.getInt("id")+"");
			rejectnodenames.add(RecordSet.getString("nodename"));
		}
	} 
	//删除当前节点.
	int indexid=rejectnodeids.indexOf(realnodeid+"");
	if(indexid>-1){
		rejectnodeids.remove(indexid);
		rejectnodenames.remove(indexid);
	}
	//下面是已经走过的节点.
    for(int i=0;i<rejectnodeids.size();i++){
        if(colorcount==0){
		colorcount=1;
		%>
		<TR class=DataLight>
		<%
			}else{
				colorcount=0;
		%>
		<TR class=DataDark>
			<%
			}
			%>
			<td>
				        <input type="radio" name="rejectnodeid" value="<%=rejectnodeids.get(i)%>" <%if(defaultnodeid==Util.getIntValue((String)rejectnodeids.get(i))){%>checked<%}%>>

			</td>
			<td>
				<%=rejectnodenames.get(i)%>
			</td>
		</tr>
		<%
		}   
%>
<tr><td colspan="2" height="15"></td></tr>
<%
} 
if(isrejectremind==1&&ischangrejectnode==1){
    nodelist=RequestRejectManager.getProcessNodes(requestid);
    nodeids=nodelist[0];
    nodenames=nodelist[1];
%>
              <TR class="Title"><!-- 退回时提醒节点 --><!--  退回时提醒节点 -->
    	  <TH colspan=2><%=SystemEnv.getHtmlLabelName(26438,user.getLanguage())%></th><th>
</TH></TR>
      <TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>
           <tr class=header>
            <td><input type="checkbox" value="-1" id="checkall" checked onclick="oncheckall()"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
</tr><tr class="Line"><td colspan="2"> </td></tr>
<%
    int colorcount=0;
    for(int i=0;i<nodeids.size();i++){
        if(colorcount==0){
		colorcount=1;
%>
<TR class=DataLight>
<%
	}else{
		colorcount=0;
%>
<TR class=DataDark>
	<%
	}
	%>
    <td>
        <input type="checkbox" name="nodeid_<%=nodeids.get(i)%>" value="<%=nodeids.get(i)%>" checked onclick="clearcheckall()">
    </td>
    <td>
        <%=nodenames.get(i)%>
    </td>
</tr>
<%
}}
%>
</table>
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
<script language=javascript>
function onsave(){
   	  var nodeids="";
    <%if(isrejectremind==1&&ischangrejectnode==1){%>
    if($G("checkall").checked){ 
		 nodeids="-1";
    }else{ 
        <%
        for(int j=0;j<nodeids.size();j++){
        %>
        if($G("nodeid_<%=nodeids.get(j)%>").checked){
            if(nodeids.length>0){
                nodeids+=","+$G("nodeid_<%=nodeids.get(j)%>").value;
            }else{
                nodeids=$G("nodeid_<%=nodeids.get(j)%>").value;
            }
        }
        <%}%>
        //alert(nodeids);
           }
    <%}%>
    var rejectnodeid="";
    <%if(isselectrejectnode==1){%>
    rejectnodeid=getRadioValue("rejectnodeid");
    if(rejectnodeid==""){
        alert("<%=SystemEnv.getHtmlLabelName(26436,user.getLanguage())%>");
        return false;
    }
    <%}%>
    window.parent.returnValue=nodeids+"|"+rejectnodeid;
    window.parent.close();
}
function oncheckall(){
    <%
        for(int j=0;j<nodeids.size();j++){
        %>
        $G("nodeid_<%=nodeids.get(j)%>").checked=$G("checkall").checked;
        <%}%>
}
function getRadioValue(name){
if(document.getElementsByName(name)){
var radioes = document.getElementsByName(name);
for(var i=0;i<radioes.length;i++)
{
     if(radioes[i].checked){
      return radioes[i].value;
     }
}
}
return "";
}
function clearcheckall(){
     if($G("checkall").checked){
          $G("checkall").checked=false;
     }
}
</script>
</body>
</html>