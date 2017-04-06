<%@ page language="java" contentType="text/html; charset=gbk" %>
<%@ include file="/systeminfo/init.jsp" %>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>


<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<script type="text/javascript" src="/js/dojo.js"></script>
</head>


<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailAccountSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:getConfig(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:redirect(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<script type="text/javascript">
	function setPortMsg(){
	 	$G("popServer").value="";
	}
</script>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailAccountOperation.jsp" id="fMailAccount" name="fMailAccount">
<input type="hidden" name="operation" value="add" />
<table class="ViewForm" id="MailAccountInfo">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())//基本信息%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage())//帐户名称%></td>
	<td class="Field">
		<input type="text" name="accountName" class="inputstyle" style="width:90%" maxlength="50" onchange="checkinput('accountName','accountNameSpan')" />
		<SPAN id="accountNameSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())//邮件地址%></td>
	<td class="Field">
		<input type="text" name="accountMailAddress" class="inputstyle" style="width:90%" maxlength="50" onchange="checkinput('accountMailAddress','accountMailAddressSpan')" />
		<SPAN id="accountMailAddressSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())//用户名%></td>
	<td class="Field">
		<input type="text" name="accountId" class="inputstyle" style="width:90%" maxlength="50" onchange="checkinput('accountId','accountIdSpan')" />
		<SPAN id="accountIdSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())//密码%></td>
	<td class="Field">
		<input type="password" name="accountPassword" class="inputstyle" style="width:90%" maxlength="50" onchange="checkinput('accountPassword','accountPasswordSpan')" />
		<SPAN id="accountPasswordSpan"><IMG src='/images/BacoError.gif' align="absMiddle"></SPAN>
	</td>
</tr>
<!--  -->

</table>
</form>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>

</table>


<script language="javascript">

	function Mtrim(str){ //删除左右两端的空格
		 return str.replace(/(^\s*)|(\s*$)/g, "");
	}

 function MailAccountSubmit(){
	 
	if(check_form(fMailAccount,'accountName') && check_form(fMailAccount,'accountMailAddress') && check_form(fMailAccount,'accountId') && check_form(fMailAccount,'accountPassword') && check_form(fMailAccount,'popServer') && check_form(fMailAccount,'smtpServer')){
		if(!checkEmail(Mtrim(dojo.byId("fMailAccount").accountMailAddress.value))){
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
			dojo.byId("fMailAccount").accountMailAddress.focus();
			return false;
		}
		
		fMailAccount.submit();
		
		
	}
}
function getConfig(){
	if(check_form(fMailAccount,'accountName') && check_form(fMailAccount,'accountMailAddress') && check_form(fMailAccount,'accountId') && check_form(fMailAccount,'accountPassword') && check_form(fMailAccount,'popServer') && check_form(fMailAccount,'smtpServer')){
		if(!checkEmail(Mtrim(dojo.byId("fMailAccount").accountMailAddress.value))){
			alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
			dojo.byId("fMailAccount").accountMailAddress.focus();
			return false;
		}
		var param =  {accountMailAddress:$G("accountMailAddress").value,accountPassword:$G("accountPassword").value}
		jQuery.post("/email/new/GetMailServerConfig.jsp",param,function(data){
				if(jQuery.browser.msie) { 
					var temp_length=jQuery(data).length;
					for(var i=0;i<temp_length;i++){
						jQuery("#MailAccountInfo").append("<tr>"+jQuery(data)[i].innerHTML+"</tr>");
					}
				}else{
					jQuery("#MailAccountInfo").append(data);
				}
		});
		
		 showRCMenuItem(0)
		 hiddenRCMenuItem(1)
	}
}
 function redirect(url){    
    if(url == "" || url == undefined){
      url = "MailAccount.jsp";
    }
    window.location.href = url;
 }
 
 hiddenRCMenuItem(0)
</script>
<style>
	#rightMenuIframe{
		background-color: transparent; height:<%=RCMenuHeight+6%>!important;
	}
</style>