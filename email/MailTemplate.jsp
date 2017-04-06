<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

int userId = Util.getIntValue(request.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=gbk" />
<head>
<script type="text/javascript">
var isClear = false;
var radios;
var oSelectedIndex = -1;
function initMailAccount(){
	radios = document.getElementsByName("isDefault");
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			oSelectedIndex = i;
			break;
		}
	}
}
function detectRadioStatus(){
	var e = window.event.srcElement;
	if(oSelectedIndex==e.id && !isClear){
		clearRadioSelected();	
	}else{
		oSelectedIndex = e.id;
		isClear = false;
	}
}
function clearRadioSelected(){
	for(var i=0;i<radios.length;i++){radios[i].checked = false;}
	isClear = true;
}
function doSubmit(){
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			fMailTemplate.templateType.value = radios[i].getAttribute("templateType");
			fMailTemplate.defaultTemplateId.value = radios[i].value;
			break;
		}
	}
	document.forms[0].submit();
}
window.onload = function(){
	initMailAccount();
}
</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<style type="text/css">.href{color:blue;text-decoration:underline;cursor:hand}</style>
</head>
<body>
<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(userId!=0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
}
if(showTop.equals("")) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",MailTemplateAdd.jsp?userid="+userId+",_self} " ;    
} else if(showTop.equals("show800")) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",MailTemplateAdd.jsp?showTop=show800&userid="+userId+",_self} " ;    
}
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:98%;height:92%;border-collapse:collapse" align="center">

<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form id="fMailTemplate" method="post" action="MailTemplateOperation.jsp">
<input type="hidden" name="operation" value="default" />
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<input type="hidden" name="templateType" value="" />
<input type="hidden" name="defaultTemplateId" value="" />
<table class="liststyle" cellspacing="1">
<tr class="header">
<th style="width:30%"><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></th>
<th style="width:40%"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></th>
<%if(userId!=0){%>
<th style="width:15%"><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></th>
<%}%>
<th style="width:15%"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
</tr>

<%
int defaultTemplateId = -1;
String templateType = "";
rs.executeSql("SELECT * FROM MailTemplateUser WHERE userId="+user.getUID()+"");
if(rs.next()){
	templateType = rs.getString("templateType");//0:个人模板 1:公司模板
	defaultTemplateId = rs.getInt("templateId");
}
int i = 0;
rs.executeSql("SELECT * FROM DocMailMould ORDER BY mouldname");
while(rs.next()){
%>
<tr <%if((i%2)!=0){out.println("style='background-color:#EEE'");}%>>
	<%if(showTop.equals("")) {%>
	<td><a href="/docs/mail/DocMouldDsp.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("mouldname")%></a></td>
	<%} else if(showTop.equals("show800")) {%>
	<td><a href="/docs/mail/DocMouldDsp.jsp?showTop=show800&id=<%=rs.getInt("id")%>"><%=rs.getString("mouldname")%></a></td>
	<%}%>
	
	<td></td>
	<td>
		<input type="radio" 
		id="<%=i%>" 
		name="isDefault" 
		value="<%=rs.getInt("id")%>" 
		<%if(templateType.equals("1") && defaultTemplateId==rs.getInt("id")){out.print("checked");}%>
		templateType="1"
		onclick="detectRadioStatus()" />
	</td>
	<td> </td>
</tr>
<%
i++;}
rs.executeSql("SELECT * FROM MailTemplate WHERE userId="+userId+" ORDER BY templateName");
while(rs.next()){
%>
<tr <%if((i%2)!=0){out.println("style='background-color:#EEE'");}%>>
	<%if(showTop.equals("")) {%>
	<td><a href="MailTemplateEdit.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("templateName")%></a></td>
	<%} else if(showTop.equals("show800")) {%>
	<td><a href="MailTemplateEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>"><%=rs.getString("templateName")%></a></td>
	<%}%>
	<td><%=rs.getString("templateDescription")%></td>
	<td>
		<input type="radio" 
		id="<%=i%>" 
		name="isDefault" 
		value="<%=rs.getInt("id")%>" 
		<%if(templateType.equals("0") && defaultTemplateId==rs.getInt("id")){out.print("checked");}%>
		templateType="0"
		onclick="detectRadioStatus()" />
	</td>
	<td>
		<%if(showTop.equals("")) {%>
			<span onclick="javascript:location.href='MailTemplateEdit.jsp?id=<%=rs.getInt("id")%>&userid=<%=userId%>'" class="href"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
			<span 
				onclick="if(confirm('<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>')){location.href='MailTemplateOperation.jsp?id=<%=rs.getInt("id")%>';}"
				class="href"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
		<%} else if(showTop.equals("show800")) {%>
			<span onclick="javascript:location.href='MailTemplateEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>&userid=<%=userId%>'" class="href"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
			<span 
				onclick="if(confirm('<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>')){location.href='MailTemplateOperation.jsp?showTop=show800&id=<%=rs.getInt("id")%>';}"
				class="href"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
		<%}%>
   </td>
</tr>
<%i++;}%>
</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</TABLE>
	</td>
</tr>

</table>
</body>
</html>