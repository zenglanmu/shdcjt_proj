<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(22876,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:add(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<LINK href="../css/Weaver.css" type=text/css rel=STYLESHEET>
<FORM name="frmmain" action="/docs/change/DocChangeOpterator.jsp" method="post">
<input name="method" value="del" type="hidden" />
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

<TABLE class="Shadow">
<tr>
<td valign="top">

<TABLE class=ListStyle cellspacing=1>
<COLGROUP>
<COL width="30">
<COL width="150">
<COL width="200">

<COL width="100">
<COL width="100">

<TR class=Header>
<TH><input type="checkbox" name="selectAll" onclick="selecAll()"></TH>
<TH><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(23025,user.getLanguage())%></TH>
<!--
<TH><%=SystemEnv.getHtmlLabelName(24825,user.getLanguage())%></TH>
-->
</TR>
<TR class=Line style="height:1px;">
<TD colSpan=5 style="height:1px;margin:0;padding:0;"></TD>
</TR>

<%
int i = 0;
rs.executeSql("select * from DocChangeWorkflow order by createdate,createtime desc");
while(rs.next()) {
%>
<TR class=<%if((i%2)==0){%>DataDark<%}else{%>DataLight<%}%>>
<TD><input type="checkbox" name="id" value=<%=rs.getInt("id")%>></TD>
<TD><%=rs.getString("createdate")%> <%=rs.getString("createtime")%></TD>
<TD><%=WorkTypeComInfo.getWorkTypename(WorkflowComInfo.getWorkflowtype(rs.getString("workflowid")))%></TD>
<TD><%=WorkflowComInfo.getWorkflowname(rs.getString("workflowid"))%></TD>
<TD><a href="javascript:editField(<%=rs.getString("workflowid")%>,<%=rs.getInt("id")%>)"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
<!--
<TD><a href="javascript:assField(<%=rs.getString("workflowid")%>,<%=rs.getInt("id")%>)"><img src="/images/iedit.gif" width="16" height="16" border="0"></a></TD>
-->
</TR>
<%
	i++;
}
%>

</TABLE>

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

</FORM>
</html>
<script>
//±à¼­×Ö¶Î
function editField(wfid,cid) {
	location.href = 'DocChangeField.jsp?wfid='+wfid+'&docchangeid='+cid;
}
//×Ö¶Î¶ÔÓ¦
function assField(wfid,cid) {
	location.href = 'WorkflowFieldConfig.jsp?wfid='+wfid+'&isView=true';
}

function add(obj) {
	location.href = '/docs/change/WorkflowSelect.jsp';
	obj.disabled = true;
}
function del(obj) {
	var flag = false;
	var ids = document.getElementsByName('id');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
	if(!flag) {
		alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
		return;
	}
	if(confirm('<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>')) {
		document.frmmain.submit();
		obj.disabled = true;
	}
}
function selecAll(){
	var flag = document.all('selectAll').checked;
	var ids = document.getElementsByName('id');
	for(i=0; i<ids.length; i++) {
		ids[i].checked = flag;
	}
}
</script>