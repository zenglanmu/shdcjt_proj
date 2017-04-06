<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>

</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<%

int messageid = Util.getIntValue(request.getParameter("messageid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
	MouldManager.setId(id);
	MouldManager.getMouldInfoById();
	String mouldname=MouldManager.getMouldName();
	String mouldtext=MouldManager.getMouldText();
	MouldManager.closeStatement();
boolean canNotDelete = false;
RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 where t1.mouldId = "+id+" and mouldType in(1,3,5,7)");
if(RecordSet.getCounts()>0){
    canNotDelete = true;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename =SystemEnv.getHtmlLabelName(16450,user.getLanguage())+"："+mouldname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

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

<%if(messageid!=0){%>
<font color=red><%=SystemEnv.getErrorMsgName(messageid,user.getLanguage())%></font>
<%}%></DIV>
<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/docs/mould/DocMouldEdit.jsp?id="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/docs/mould/DocMouldAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere=where operateitem=5 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
//TD.4617 增加返回按钮
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/docs/mould/DocMould.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

</DIV>

<br>
<TABLE class=ViewForm>
<TBODY>

<TR class=Spacing><TD aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
</b>
</TD></TR>
<TR style="height: 1px!important;"><TD class=Line1 colSpan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<%=mouldname%>
</td>
</tr>
<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
</tbody>
</table>
<div id=imgfield>
</div>

<TABLE class=ListStyle cellspacing=1>
<TBODY>
<TR class=header>
<TD>
<%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%>
</TD>
</TR>
<TR class=dataLight>
<TD>
<%=mouldtext%></TD>
</TR>
</TBODY>
</TABLE>


<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=mouldname value="<%=mouldname%>">
<textarea name=mouldtext style="display:none;width:100%;height=500px"><%=mouldtext%></textarea>
</FORM>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script>
function onDelete(){
	if(<%=canNotDelete%>){
		alert("<%=SystemEnv.getHtmlLabelName(23134,user.getLanguage())%>");
		return;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='delete';
	document.weaver.submit();
	}
}
</script>
</body>