<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("OutDataInterface:Setting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage());
String needfav ="1";
String needhelp ="";

String deteteviewid = Util.null2String(request.getParameter("deteteviewid"));
if(!deteteviewid.equals("")){
    RecordSet.executeSql("delete from outerdatawfset where id="+deteteviewid);
    RecordSet.executeSql("delete from outerdatawfsetdetail where mainid="+deteteviewid);
}
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",automaticsettingAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(23112,user.getLanguage())+",automaticperiodsetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="automaticsetting.jsp">
<input type="hidden" id="deteteviewid" name="deteteviewid" value="">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class=ListStyle cellspacing=1>
		<colgroup>
		<col width="5%">
		<col width="40%">
		<col width="45%">
		<col width="10%">
		<tbody>
		<tr class=spacing>
			<td class=Sep1 colSpan=3 ></td></tr>
		<tr class=Header>
			<th><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
			<th><%=SystemEnv.getHtmlLabelName(23113,user.getLanguage())%></th>
			<th></th>
		</tr>
		<%
		int colorindex = 0;
		int rowindex = 0;
		RecordSet.executeSql("select id,setname,workflowid from outerdatawfset order by id");
	  while(RecordSet.next()){
	      rowindex++;
	      String viewid = Util.null2String(RecordSet.getString("id"));
	      String setname = Util.null2String(RecordSet.getString("setname"));
	      String workflowid = Util.null2String(RecordSet.getString("workflowid"));
	      String workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname(workflowid));
	  %>
		<%if(colorindex==0){
		      colorindex=1;
		%>
		<tr CLASS=DataDark>
		<%}else{
			    colorindex=0;
		%>
		<tr CLASS=DataLight>    
		<%}%>
			<td><%=rowindex%></td>
			<td><a href="automaticsettingView.jsp?viewid=<%=viewid%>"><%=setname%></a></td>
			<td><%=workFlowName%></td>
			<td><a href="#" onclick="doDelete(<%=viewid%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a></td>
		</tr>
		<%}%>
		</tbody>
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
</form>
</body>
</html>
<script language="javascript">
function doDelete(viewid){
    if(isdel()){
        document.getElementById("deteteviewid").value=viewid;
        document.frmmain.submit();
    }
}
</script>
