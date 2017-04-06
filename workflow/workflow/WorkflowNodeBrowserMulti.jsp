<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String printNodes=Util.null2String(request.getParameter("printNodes"));
List printNodesList=Util.TokenizerString(printNodes,",");
int workflowId=Util.getIntValue(request.getParameter("workflowId"),0);

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
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
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WorkflowNodeBrowserMulti.jsp" method=post>

<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSure(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="js_btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0;width:100%;" >
<TR class=DataHeader>
<TH width=30%><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></TH>
<TH width=30%><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></TH>
</tr><TR class=Line><TH colSpan=4></TH></TR>
<%
int i=0;
int rowNum=0;
String tempPrintNodes=null;
String tempPrintNodesName=null;
String tempPrintNodesType=null;

StringBuffer printNodesSb=new StringBuffer();
printNodesSb.append(" select a.nodeId,b.nodeName,a.nodeType ")
			.append(" from  workflow_flownode a,workflow_nodebase b ")
			.append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
			.append("   and a.workflowId=").append(workflowId)
			.append(" order by a.nodeType asc,a.nodeId asc ")				
			;
RecordSet.executeSql(printNodesSb.toString());
while(RecordSet.next()){
	tempPrintNodes=Util.null2String(RecordSet.getString("nodeId"));
	tempPrintNodesName=Util.null2String(RecordSet.getString("nodeName"));
	tempPrintNodesType=Util.null2String(RecordSet.getString("nodeType"));

	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
	<%
	}
	%>
	<TD><input type=checkbox value=1 name="checkbox_<%=rowNum%>" <%=printNodesList.indexOf(tempPrintNodes)>=0?"checked":""%> ></TD>
    <input class=inputstyle type=hidden name="printNodes_<%=rowNum%>" value="<%=tempPrintNodes%>">
    <input class=inputstyle type=hidden name="printNodesName_<%=rowNum%>" value="<%=tempPrintNodesName%>">
	<TD><%=tempPrintNodesName%></TD>
	<TD>
<%if(tempPrintNodesType.equals("0")){%><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%}%>
<%if(tempPrintNodesType.equals("1")){%><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%><%}%>
<%if(tempPrintNodesType.equals("2")){%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%}%>
<%if(tempPrintNodesType.equals("3")){%><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%><%}%>
	</TD>

</TR>
<%
	rowNum++;
}
%>

<input class=inputstyle type=hidden name=rowNum value="<%=rowNum%>">
</TABLE></FORM>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>

<script language="javascript">
function onSure(){
    var printNodes="";
    var printNodesName="";
	var rowNum=$("input[name=rowNum]").val();

	for(i=0;i<rowNum;i++){
		if($("input[name=checkbox_"+i+"]")[0].checked){
			printNodes=printNodes+","+$("input[name=printNodes_"+i+"]").val();
			printNodesName=printNodesName+"£¬"+$("input[name=printNodesName_"+i+"]").val();
		}
	}
    if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}
     window.parent.returnValue = {id:printNodes,name:printNodesName};
     window.parent.close();
}


function js_btnclear_onclick(){
     window.parent.returnValue = {id:"",name:""};
     window.parent.close();
}
</script>