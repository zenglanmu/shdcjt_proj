<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 

<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
String wfid=Util.null2String(request.getParameter("wfid"));
String workflowId = wfid.split("_")[0];
String nodeid = wfid.split("_")[1];
List printNodesList=Util.TokenizerString(wfid.split("_")[2],",");
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(21738,user.getLanguage())+",javascript:checkAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 STYLE="margin-top:0">
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
			.append(" from  workflow_flownode a,workflow_nodebase b")
			.append(" where a.workflowId=").append(workflowId)
			.append(" and a.nodeId<>").append(nodeid)
			.append(" and a.nodeid=b.id")
			//添加本条件, 限制查询条件不包括自由流转中的节点
			.append(" and (b.isFreeNode != '1' OR b.isFreeNode IS null)")
			.append(" order by b.nodeName asc")				
			;
System.out.println(printNodesSb.toString());
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
	<TD><input type="checkbox" value="1" name="checkbox_<%=rowNum%>" id="checkbox_<%=rowNum%>" <%=printNodesList.contains(tempPrintNodes)?"checked":""%>></TD>	
    <input type="hidden" id="printNodes_<%=rowNum%>" name="printNodes_<%=rowNum%>" value="<%=tempPrintNodes%>">
    <input type="hidden" id="printNodesName_<%=rowNum%>" name="printNodesName_<%=rowNum%>" value="<%=tempPrintNodesName%>">
	<TD><%=tempPrintNodesName%></TD>
	<TD>
<%if(tempPrintNodesType.equals("0")){%><strong>Create</strong><%}%>
<%if(tempPrintNodesType.equals("1")){%><strong>Approve</strong><%}%>
<%if(tempPrintNodesType.equals("2")){%><strong>Realize</strong><%}%>
<%if(tempPrintNodesType.equals("3")){%><strong>Process</strong><%}%>
	</TD>

</TR>
<%
	rowNum++;
}
%>

<input type="hidden" id="rowNum" name="rowNum" value="<%=rowNum%>">
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
	var rowNum=document.getElementById("rowNum").value;

	for(i=0;i<rowNum;i++){
		if(document.getElementById("checkbox_"+i).checked){
			printNodes=printNodes+","+document.getElementById("printNodes_"+i).value;
			printNodesName=printNodesName+","+document.getElementById("printNodesName_"+i).value;
		}
	}
    if(printNodes!=""){
		printNodes=printNodes.substr(1);
		printNodesName=printNodesName.substr(1);
	}

     window.parent.returnValue = Array(1,printNodes,printNodesName);
     window.parent.close();
}


function js_btnclear_onclick(){
     window.parent.returnValue = Array(0,0,"");
     window.parent.close();
}

function checkAll(){
	var rowNum=document.getElementById("rowNum").value;
	for(i=0;i<rowNum;i++){
		document.getElementById("checkbox_"+i).status = true;
	}
	onSure();
}
function btnclear_onclick(){
    js_btnclear_onclick()
}
</script>