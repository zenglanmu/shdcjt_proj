<%@ page language="java" contentType="text/html; charset=gbk" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
String showTop = Util.null2String(request.getParameter("showTop"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sendneedSSL = "0";
String getneedSSL = "0";
int mailAccountId = Util.getIntValue(request.getParameter("id"));
String accountName="", accountMailAddress="", accountId="", accountPassword="", popServer="", smtpServer="", needCheck="", needSave="",autoreceive="";
int serverType=1, popServerPort=25, smtpServerPort=110;
String encryption="";
rs.executeSql("SELECT * FROM MailAccount WHERE id="+mailAccountId+"");
if(rs.next()){
	accountName = rs.getString("accountName");
	accountMailAddress = rs.getString("accountMailAddress");
	accountId = rs.getString("accountId");
	accountPassword = rs.getString("accountPassword");
	serverType = rs.getInt("serverType");
	popServer = rs.getString("popServer");
	//解决第一次邮箱配置，显示-1的情况
	popServerPort = Util.getIntValue(rs.getInt("popServerPort")+"", 25);
	smtpServer = rs.getString("smtpServer");
	//解决第一次邮箱配置，显示-1的情况
	smtpServerPort = Util.getIntValue(rs.getInt("smtpServerPort")+"",110);
	needCheck = rs.getString("needCheck");
	needSave = rs.getString("needSave");
	sendneedSSL =  rs.getString("sendneedSSL");
	getneedSSL =  rs.getString("getneedSSL");
	autoreceive = rs.getString("autoreceive");
	encryption = Util.null2String(rs.getString("encryption"));
}
if(encryption.equals("1")) accountPassword = EmailEncoder.DecoderPassword(accountPassword);
%>

<script type="text/javascript" src="/js/weaver.js"></script>
<script type="text/javascript" src="/js/prototype.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver.css" />
<script type="text/javascript" src="/js/dojo.js"></script>
</head>

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
 
 function redirect(url){    
    if(url == "" || url == undefined){
    <%if(showTop.equals("")) {%>
		url = "MailAccount.jsp";
	<%} else if(showTop.equals("show800")) {%>
		url = "MailAccount.jsp?showTop=show800";
	<%}%>
    }
    window.location.href = url;
 }
</script>


<%if(showTop.equals("")) {%>
	<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} else if(showTop.equals("show800")) {%>
	
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailAccountSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:redirect(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
<form method="post" action="MailAccountOperation.jsp" id="fMailAccount">
<input type="hidden" name="operation" value="update" />
<input type="hidden" name="id" value="<%=mailAccountId%>" />
<%if(showTop.equals("")) {%>

<%} else if(showTop.equals("show800")) {%>
<input type="hidden" name="showTop" value="show800" />
<%}%>
<table class="ViewForm">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="accountName" class="inputstyle" style="width:90%" maxlength="50" value="<%=accountName%>" onchange="checkinput('accountName','accountNameSpan')" />
		<SPAN id="accountNameSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="accountMailAddress" class="inputstyle" style="width:90%" maxlength="50" value="<%=accountMailAddress%>" onchange="checkinput('accountMailAddress','accountMailAddressSpan')" />
		<SPAN id="accountMailAddressSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="accountId" class="inputstyle" style="width:90%" maxlength="50" value="<%=accountId%>" onchange="checkinput('accountId','accountIdSpan')" />
		<SPAN id="accountIdSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
	<td class="Field">
		<input type="password" name="accountPassword" class="inputstyle" style="width:90%" maxlength="50" value="<%=accountPassword%>"
		onchange="checkinput('accountPassword','accountPasswordSpan')"/>
		<SPAN id="accountPasswordSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(19806,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td>
		<select name="serverType">
		<option value="1" <%if(serverType==1)out.println("selected=selected");%>>POP3</option>
		<option value="2" <%if(serverType==2)out.println("selected=selected");%>>IMAP</option></select>
	</td>
	<td class="Field">
		<input type="text" name="popServer" class="inputstyle" style="width:90%" maxlength="100" value="<%=popServer%>" onchange="checkinput('popServer','popServerSpan')" />
		<SPAN id="popServerSpan"></SPAN>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>接收端口</td>
	<td class="Field">
		<input type="text" name="popServerPort" class="inputstyle" value="<%=popServerPort%>" onchange="checkinput('popServerPort','popServerPortSpan')" />
		<SPAN id="popServerPortSpan"></SPAN>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>是否SSL协议接收</td>
	<td class="Field">
		<input type="checkbox" name="getneedSSL" value="1" class="inputstyle" <%if(getneedSSL.equals("1"))out.println("checked=checked");%> />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>SMTP<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></td>
	<td class="Field">
		<input type="text" name="smtpServer" class="inputstyle" style="width:90%" maxlength="100" value="<%=smtpServer%>" onchange="checkinput('smtpServer','smtpServerSpan')" />
		<SPAN id="smtpServerSpan"></SPAN>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>发送端口</td>
	<td class="Field">
		<input type="text" name="smtpServerPort" class="inputstyle" value="<%=smtpServerPort%>" onchange="checkinput('smtpServerPort','smtpServerPortSpan')" />
		<SPAN id="smtpServerPortSpan"></SPAN>
	</td>
</tr>

<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>是否SSL协议发送</td>
	<td class="Field">
		<input type="checkbox" name="sendneedSSL" value="1" class="inputstyle" <%if(sendneedSSL.equals("1"))out.println("checked=checked");%> />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())//是否需要发件认证%></td>
	<td class="Field">
		<input type="checkbox" name="needCheck" value="1" class="inputstyle" <%if(needCheck.equals("1"))out.println("checked=checked");%> />
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19807,user.getLanguage())//是否保留服务器上的邮件%></td>
	<td class="Field">
		<input type="checkbox" name="needSave" value="1" class="inputstyle" <%if(needSave.equals("1"))out.println("checked=checked");%> />
	</td>
</tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(24310 ,user.getLanguage())%></td>
	<td class="Field">
		<input type="checkbox" name="autoreceive" value="1" class="inputstyle" <%if(autoreceive.equals("1"))out.println("checked=checked");%>/>
	</td>
</tr>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
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