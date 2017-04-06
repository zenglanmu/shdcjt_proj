<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script>

var canDelete="<%=Util.null2String(request.getParameter("state"))%>";
if(canDelete=="nodelete")alert("<%=SystemEnv.getHtmlLabelName(21799,user.getLanguage())%>");

</script>
</head>
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subcompanyid1 =  Util.getIntValue(request.getParameter("subcompanyid1"),0);
String urlfrom = request.getParameter("urlfrom");
session.setAttribute("DocMouldDsp_",String.valueOf(subcompanyid1));
String mouldname,mouldtext;
int mouldType,subcompanyid;
	MouldManager.setId(id);
	MouldManager.getMouldInfoById();
	MouldManager.getMouldSubInfoById();
	mouldname=MouldManager.getMouldName();
	mouldtext=MouldManager.getMouldText();
	mouldType= MouldManager.getMouldType();
	subcompanyid = MouldManager.getSubcompanyid1();
	MouldManager.closeStatement();

boolean canNotDelete = false;
RecordSet.executeSql("select t1.* from DocSecCategoryMould t1 where t1.mouldId = "+id+" and mouldType in(2,4,6,8)");
if(RecordSet.getCounts()>0){
    canNotDelete = true;
}
	//System.out.println("MouldText:"+mouldtext);
	//System.out.println("id:"+id);


if(mouldType > 1){//Modify by Ñî¹úÉú 2004-10-25 For TD1271
    response.sendRedirect("DocMouldDspExt.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1);
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
String log_id = "";
if(urlfrom.equals("hr")){
  titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(64,user.getLanguage());
  log_id ="110";
}else{
  titlename = SystemEnv.getHtmlLabelName(16449,user.getLanguage())+"£º"+mouldname;
  log_id ="75";
}
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

<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=urlfrom value="<%=urlfrom%>">
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMouldEdit:Edit", user)){
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/docs/mouldfile/DocMouldEdit.jsp?id="+id+"&urlfrom="+urlfrom+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/docs/mouldfile/DocMouldAdd.jsp?urlfrom="+urlfrom+"',_top} " ;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere=where operateitem=110 and relatedid="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%
}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/mouldfile/DocMould.jsp?id="+id+"&urlfrom="+urlfrom+"&subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
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
<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=2></TD></TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td width=85% class=field>
<%=id%>
</td>
</tr>
<TR style="height: 1px">
	<TD class=Line colSpan=2></TD>
</TR>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></td>
<td width=85% class=field>
<%=mouldname%>
</td>
</tr>
<%if(urlfrom.equals("hr")){%>
<%if(detachable==1){%>
<tr>
<td width=15%><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></td>
<td width=85% class=field>
<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>
</td>
</tr>
<%}%>
<%}%>
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
<textarea id="mouldtext" name=mouldtext style="display:none;width:100%;height=500px">##<%=mouldtext%></textarea>
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
</body>

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