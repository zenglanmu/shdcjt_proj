<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(23141,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userId = 0;
userId = user.getUID();
if(userId!=1){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver.css" type=text/css rel=stylesheet>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name="frmMain" method="post" action="loginTemplateOperation.jsp">
<input type="hidden" name="operationType" value="selectLoginTemplate"/>

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
<TABLE class="Shadow">
<tr>
<td valign="top">
		
<!--=================================-->
<TABLE class=ListStyle cellspacing=1>
<TR class=Header>
	<th width="40">ID</th>
	<TH><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></TH>
	<th width="150"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></th>
	<th width="60"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></th>
</TR>
<TR class=Line>
	<TD colSpan=4></TD>
</TR>
<%
String templateType="";
String extendloginid="";

String sql= "SELECT * FROM SystemLoginTemplate";
rs.executeSql(sql);
while(rs.next()){
	templateType=Util.null2String(rs.getString("templateType"));
	extendloginid=Util.null2String(rs.getString("extendloginid"));


	String extendUrl="";
	rs1.executeSql("select extendurl from extendlogin where id="+Util.getIntValue(extendloginid,0));
	if(rs1.next()){
		extendUrl=Util.null2String(rs1.getString(1));
	}



%>
<TR>
	<TD><%=rs.getInt("loginTemplateId")%></TD>
	<td>
		<a href="loginTemplateEdit.jsp?id=<%=rs.getInt("loginTemplateId")%>">
		<%=rs.getString("loginTemplateName")%>
		</a>
	</td>
	<td><a href="javascript:preview(<%=rs.getInt("loginTemplateId")%>,'<%=templateType%>','<%=extendUrl%>')"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></a></td>
	<td><input type="radio" id="<%=rs.getInt("loginTemplateId")%>" name="loginTemplateId" value="<%=rs.getInt("loginTemplateId")%>" <%if(rs.getString("isCurrent").equals("1")){out.println("checked");}%>></td>
</TR>
<%}%>
</TABLE>
<!--=================================-->

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
function checkSubmit(){
	document.frmMain.submit();
	window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}

function preview(id,type,url){
	if(type=="E"){
		openFullWindowForXtable("/"+url+"index.jsp"); 
	} else {
		openFullWindowForXtable('loginTemplatePreview.jsp?loginTemplateId='+id);
	}	
}
</script>