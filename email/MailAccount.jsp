<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
int msgLabelId = Util.getIntValue(request.getParameter("msgLabelId"));

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

if(msgLabelId!=-1){
	titlename += " <span style='color:red;font-weight:bold'>" + SystemEnv.getHtmlLabelName(msgLabelId,user.getLanguage()) + "</span>";
}
%>

<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
</head>

<script language="javascript">
 function  formSubmit(){
    
     fMailAccount.submit();
 }
 
 function redirect(url){    
    if(url == "" || url == undefined){
    <%if(showTop.equals("")) {%>
		url = "MailAccountAdd.jsp";
	<%} else if(showTop.equals("show800")) {%>
		url = "MailAccountAdd.jsp?showTop=show800";
	<%}%>
    }
    window.location.href = url;
 }
 
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
function MailAccountSubmit(form, tab){
	if(check_form(fMailAccount,'accountName') && check_form(fMailAccount,'accountMailAddress') && check_form(fMailAccount,'accountId') && check_form(fMailAccount,'accountPassword') && check_form(fMailAccount,'popServer') && check_form(fMailAccount,'smtpServer')){
		if(!checkEmail(dojo.byId("fMailAccount").accountMailAddress.value)){
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
			dojo.byId("fMailAccount").accountMailAddress.focus();
			return false;
		}
		formSubmit(form, tab);
	}
}
/*=========start==========暂时提示代码，正式版本需废弃===================*/
<%if(showTop.equals("")) {%>
	
<%} else if(showTop.equals("show800")) {%>
(function(msgLabelId){
	if(msgLabelId!=-1){
		alert("<%=SystemEnv.getHtmlLabelName(msgLabelId,user.getLanguage())%>");
	}
})(<%=msgLabelId%>);
<%}%>
/*=========end==========暂时提示代码，正式版本需废弃===================*/

</script>

<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:redirect(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<body style="overflow-x: hidden" onload="initMailAccount();">

<table style="width:98%;height:92%;border-collapse:collapse" align="center">

<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form id="fMailAccount" method="post" action="MailAccountOperation.jsp">
<input type="hidden" name="operation" value="default" />
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<table class="liststyle" cellspacing="1">
<tr class="header">
<th><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage())%></th>
<th><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></th>
<th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
<th><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></th>
<th><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></th>
</tr>

<%
int i = 0;
rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+" ORDER BY accountName");
while(rs.next()){
%>
<tr <%if((i%2)!=0){out.println("style='background-color:#EEE'");}%>>
<td>
	<%if(showTop.equals("")) {%>
	<span class="href" onclick="javascript:redirect('MailAccountEdit.jsp?id=<%=rs.getInt("id")%>', 'tab1')"><%=rs.getString("accountName")%></span>
	<%} else if(showTop.equals("show800")) {%>
	<span class="href" onclick="javascript:redirect('MailAccountEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>', 'tab1')"><%=rs.getString("accountName")%></span>
	<%}%>
	
</td>
<td><%=rs.getString("accountmailaddress")%></td>
<td><%if(rs.getInt("serverType")==1){out.println("POP3");}else{out.println("IMAP");}%></td>
<td><input type="radio" 
		id="<%=i%>" 
		name="isDefault" 
		value="<%=rs.getInt("id")%>" 
		<%if(rs.getString("isDefault").equals("1")){out.println("checked=checked");}%> 
		onclick="detectRadioStatus()" /></td>
<td>
	<%if(showTop.equals("")) {%>
	<span class="href" onclick="javascript:redirect('MailAccountEdit.jsp?id=<%=rs.getInt("id")%>', 'tab1')"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
	<span class="href" onclick="javascript:if(confirm('<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>')){redirect('MailAccountOperation.jsp?id=<%=rs.getInt("id")%>', 'tab1')}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
	<%} else if(showTop.equals("show800")) {%>
	<span class="href" onclick="javascript:redirect('MailAccountEdit.jsp?showTop=show800&id=<%=rs.getInt("id")%>', 'tab1')"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></span>
	<span class="href" onclick="javascript:if(confirm('<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>')){redirect('MailAccountOperation.jsp?showTop=show800&id=<%=rs.getInt("id")%>', 'tab1')}"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span>
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
 