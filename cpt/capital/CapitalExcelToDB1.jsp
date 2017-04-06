<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.AclManager " %>
<%@ page import="weaver.docs.category.* " %>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.net.URLDecoder.*"%>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryDocTypeComInfo" class="weaver.docs.category.SecCategoryDocTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput.js"></script>
<SCRIPT language="javascript" src="/js/weaver.js"></script>

</head>
<%
if(!HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(19314,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(19320,user.getLanguage())+",CapitalExcelToDB.jsp,_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<TABLE class=ViewForm>
				<COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY>
				<TR>
				  <TD vAlign=top>

<FORM id=cms name=cms action="CapitalExcelToDBOperation.jsp?isdata=2" method=post enctype="multipart/form-data">

<TABLE cols=2 width="100%">
<tr>
<td width=40%>
<%=SystemEnv.getHtmlLabelName(22396,user.getLanguage())%>
</td>
<td width=60% class=Field>
<input class=InputStyle  type=checkbox name="auto" id="auto" value="1">
</td>
</tr>
<TR class= Spacing style="height:1px"><TD class=Line colSpan=2></TD></TR>
<tr>
<td width=40%>
<%=SystemEnv.getHtmlLabelName(16699,user.getLanguage())%>
</td>
<td width=60% class=Field>
<input class=InputStyle  type=file size=40 name="filename" id="filename">
</td>
</tr>
<TR class= Spacing style="height:2px"><TD class=Line1 colSpan=2></TD></TR>
<tr>
<td id="msg" align="center" colspan="3"><font size="2" color="#FF0000">
<%

String msg=Util.null2String(request.getParameter("msg"));
//String msg1=Util.null2String(request.getParameter("msg1"));
//String msg2=Util.null2String(request.getParameter("msg2"));
String msg1=Util.null2String((String)session.getAttribute("cptmsg1"));
String msg2=Util.null2String((String)session.getAttribute("cptmsg2"));
int    dotindex=0;
int    cellindex=0;
int    msgsize;

if (Util.null2String(request.getParameter("msgsize"))==""){
   msgsize=0;
}else{
msgsize=Integer.valueOf(Util.null2String(request.getParameter("msgsize"))).intValue();
}

if (msg.equals("success")){
msg=SystemEnv.getHtmlLabelName(19317,user.getLanguage());
}else{

for (int i=0;i<msgsize;i++){
	dotindex=msg1.indexOf(",");
    cellindex=msg2.indexOf(",");
	out.println(msg1.substring(0,dotindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18620,user.getLanguage())+"&nbsp;"+msg2.substring(0,cellindex)+"&nbsp;"+SystemEnv.getHtmlLabelName(18621,user.getLanguage())+"&nbsp;"+SystemEnv.getHtmlLabelName(19327,user.getLanguage())+"<br>");

	 msg1=msg1.substring(dotindex+1,msg1.length());
     msg2=msg2.substring(cellindex+1,msg2.length());
}

}

out.println(msg);
%></font>
</td>
</tr>
<tr>
<td><a href="CapitalExcelToDB1.xls"><%=SystemEnv.getHtmlLabelName(18616,user.getLanguage())%></a></td>
</tr>
<tr>
<td  align="left" colspan="3">

<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>£º<%=SystemEnv.getHtmlLabelName(18617,user.getLanguage())%>

</td>
</tr>
<tr><td  align="left" colspan="3">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(19322,user.getLanguage())%></font></td></tr>
<tr><td  align="left" colspan="3">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(15302,user.getLanguage())%></font></td></tr>
<tr><td  align="left" colspan="3">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(17342,user.getLanguage())%></font></td></tr>
<tr><td align="left" colspan="3">
<%=SystemEnv.getHtmlLabelName(21029,user.getLanguage())%>£¨
<%
String sql_type="";
int num=0;
if (rs.getDBType().equals("oracle")){
sql_type="select subcompanyname from hrmsubcompany where rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select subcompanyname from hrmsubcompany fetch first 5 rows only";
}else{
sql_type="select top 5 subcompanyname from hrmsubcompany ";
}
rs.executeSql(sql_type);
while (rs.next()){
    num++;
out.print(rs.getString(1)+",");
}
if(num==5){
%>
.....
<%}%>£©
</td>
</tr>



<tr><td align="left" colspan="3">
<%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%>£¨
<%
sql_type="";
num=0;
if (rs.getDBType().equals("oracle")){
sql_type="select departmentname from HrmDepartment where rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select departmentname from HrmDepartment fetch first 5 rows only";
}else{
sql_type="select top 5 departmentname from HrmDepartment ";
}
rs.executeSql(sql_type);
while (rs.next()){
    num++;
out.print(rs.getString(1)+",");
}
if(num==5){
%>
.....
<%}%>£©
</td>
</tr>
<tr><td align="left" colspan="3">
<%=SystemEnv.getHtmlLabelName(21031,user.getLanguage())%>£¨
<%
sql_type="";
num=0;
if (rs.getDBType().equals("oracle")){
sql_type="select lastname from Hrmresource where rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select lastname from Hrmresource fetch first 5 rows only";
}else{
sql_type="select top 5 lastname from Hrmresource ";
}
rs.executeSql(sql_type);
while (rs.next()){
    num++;
out.print(rs.getString(1)+",");
}
if(num==5){
%>
.....
<%}%>£©
</td>
</tr>
<tr><td align="left" colspan="3">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%>£¨
<%
sql_type="";
num=0;
if (rs.getDBType().equals("oracle")){
sql_type="select subcompanyname from hrmsubcompany where rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select subcompanyname from hrmsubcompany fetch first 5 rows only";
}else{
sql_type="select top 5 subcompanyname from hrmsubcompany ";
}
rs.executeSql(sql_type);
while (rs.next()){
    num++;
out.print(rs.getString(1)+",");
}
if(num==5){
%>
.....
<%}%>£©
</font></td>
</tr>
<tr><td align="left" colspan="3">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%>£¨
<%
sql_type="";
num=0;
if (rs.getDBType().equals("oracle")){
sql_type="select departmentname from HrmDepartment where rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select departmentname from HrmDepartment fetch first 5 rows only";
}else{
sql_type="select top 5 departmentname from HrmDepartment ";
}
rs.executeSql(sql_type);
while (rs.next()){
    num++;
out.print(rs.getString(1)+",");
}
if(num==5){
%>
.....
<%}%>£©
</font></td>
</tr>
<tr><td align="left" colspan="3"><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></td></tr>
<tr><td align="left" colspan="3">
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(830,user.getLanguage())%>£¨<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(1378,user.getLanguage())%>,.....£©
</font></td>
</tr>
<tr><td align="left" colspan="3"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></font></td></tr>
<tr><td align="left" colspan="3"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></font></td></tr>
<tr><td align="left" colspan="3"><%=SystemEnv.getHtmlLabelName(903,user.getLanguage())%></td></tr>



<tr><td align="left" colspan="3">
<%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%>£¨
<%
num=0;
if (rs.getDBType().equals("oracle")){
sql_type="select name from CRM_CustomerInfo where type=2 and rownum<=5";
}else if (rs.getDBType().equals("db2")){
sql_type="select name from CRM_CustomerInfo where type=2 fetch first 5 rows only";
}else{
sql_type="select top 5 name from CRM_CustomerInfo where type=2 ";
}
rs.executeSql(sql_type);
while (rs.next()){
    num++;
out.print(rs.getString(1)+",");
}
if(num==5){
%>
.....
<%}%>£©
</td>
</tr>
</table>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
</FORM>

<script language="javascript">
function onSave(obj){
	if (cms.filename.value=="" || cms.filename.value.toLowerCase().indexOf(".xls")<0){
		alert("<%=SystemEnv.getHtmlLabelName(18618,user.getLanguage())%>");
	}else{
        var showTableDiv  = document.getElementById('_xTable');
		var message_table_Div = document.createElement("div");
		message_table_Div.id="message_table_Div";
		message_table_Div.className="xTable_message";
		showTableDiv.appendChild(message_table_Div);
		var message_table_Div  = document.getElementById("message_table_Div");
		message_table_Div.style.display="inline";
		message_table_Div.innerHTML="<%=SystemEnv.getHtmlLabelName(19316,user.getLanguage())%>....";
		var pTop= document.body.offsetHeight/2-60;
		var pLeft= document.body.offsetWidth/2-100;
		message_table_Div.style.position="absolute";
		message_table_Div.style.posTop=pTop;
		message_table_Div.style.posLeft=pLeft;

		cms.submit();
		obj.disabled = true;
    }
}
</script>
</body>
