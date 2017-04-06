<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String frompage = Util.null2String(request.getParameter("frompage"));
String canpass = Util.null2String(request.getParameter("canpass"));
String RedirectFile = Util.null2String(request.getParameter("RedirectFile"));
String id = String.valueOf(user.getUID());//增强安全性，通过Url修改id无效。打开的始终当前用户id。
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(409,user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String needfav ="1";
String needhelp ="";
String message = Util.null2String(request.getParameter("message"));
RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");
String openPasswordLock = settings.getOpenPasswordLock();
String passwordComplexity = settings.getPasswordComplexity();
int minpasslen=settings.getMinPasslen();
String usbType= settings.getUsbType();
String userUsbType="";
String needed="0";
String mainDactylogramImgSrc="/images/loginmode/5.gif";
String assistantDactylogramImgSrc="/images/loginmode/5.gif";
String hasMainDactylogram = "0";
String hasAssistantDactylogram = "0";
String isSystemManager = "1";
RecordSet.executeSql("select account,loginid,serial,needusb,userUsbType,dactylogram,assistantdactylogram from HrmResource where id = "+id );
if(RecordSet.next()){
    isSystemManager = "0";
	needed=String.valueOf(RecordSet.getInt("needusb"));
	userUsbType=Util.null2String(RecordSet.getString("userUsbType"));
	if(userUsbType.equals("")){
		userUsbType=usbType;
	}
	mainDactylogramImgSrc = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"/images/loginmode/5.gif":"/images/loginmode/4.gif";
	assistantDactylogramImgSrc = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"/images/loginmode/5.gif":"/images/loginmode/4.gif";
	hasMainDactylogram = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"0":"1";
	hasAssistantDactylogram = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"0":"1";
}
if(isSystemManager.equals("1")){
    RecordSet.executeSql("select dactylogram,assistantdactylogram from HrmResourceManager where id = "+id );
    if(RecordSet.next()){
        mainDactylogramImgSrc = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"/images/loginmode/5.gif":"/images/loginmode/4.gif";
	      assistantDactylogramImgSrc = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"/images/loginmode/5.gif":"/images/loginmode/4.gif";
	      hasMainDactylogram = (Util.null2String(RecordSet.getString("dactylogram")).equals(""))?"0":"1";
	      hasAssistantDactylogram = (Util.null2String(RecordSet.getString("assistantdactylogram")).equals(""))?"0":"1";
    }
}
needed = Util.null2String(needed);

String canmodifydactylogram = settings.getCanModifyDactylogram();
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	
<%
if(!isfromtab){
	if(frompage.length()<=0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/resource/HrmResource.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
	}else{
		if("1".equals(canpass)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+","+RedirectFile+",_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}else{
			request.getSession().setAttribute("changepwd","n");
			RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/login/Logout.jsp,_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
	}
%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
<%if(isfromtab) {%>
<TABLE width='100%'>
<%}else {%>
<TABLE class=Shadow>
<%} %>
<tr>
<td valign="top">
<% if(message.equals("1")) {%>
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(16092,user.getLanguage())%></font> 
<%}%>
<% if(message.equals("2")) {%>
<font color="#FF0000"><%=SystemEnv.getHtmlNoteName(17,user.getLanguage())%></font> 
<%}%>
<% if(message.equals("3")) {%>
<font color="#FF0000"><%=SystemEnv.getHtmlLabelName(23987,user.getLanguage())%></font> 
<%}%>
<FORM id=password name=frmMain style="MARGIN-TOP: 3px" action=HrmResourceOperation.jsp method=post>
<input type=hidden name=operation value="changepassword">
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=frompage value="<%=frompage%>">
<input type=hidden name=RedirectFile value="<%=RedirectFile%>">
<input type=hidden name=isfromtab value="<%=isfromtab%>">  
<TABLE class=viewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TH>
    </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
      <TD style="height:2px"><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(502,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle id=passwordold type=password 
    name=passwordold onchange='checkinput("passwordold","passwordoldimage")'>
	<SPAN id=passwordoldimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
	</TD>
    </TR>
    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></TD>




	  <script src="/wui/common/jquery/jquery.js" type="text/javascript"></script>
	  <link href="/wui/theme/<%=session.getAttribute("SESSION_TEMP_CURRENT_THEME") %>/jquery/plugin/passwordStrength/password_strength.css" rel="stylesheet" type="text/css" />
      <script src="/wui/theme/<%=session.getAttribute("SESSION_TEMP_CURRENT_THEME") %>/jquery/plugin/passwordStrength/jquery.passwordStrength.js" type="text/javascript"></script>

		<script type="text/javascript">
		$(document).ready(function(){
			var $pwd = $('input[name="passwordnew"]');					   
			$pwd.passwordStrength();
		});
		</script>
    <TD class=Field><INPUT class=inputstyle id=passwordnew type=password 
    name=passwordnew onchange='checkinput("passwordnew","passwordnewimage")'> <span id=passwordnewimage><img src="/images/BacoError.gif" align=absMiddle></span>
		<div>
		<table><tr style="height:2px"><td  id="passwordStrengthDiv" class="is0"></td></tr></table>
		</div>
		</TD>
    </TR>




    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(501,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle id=confirmpassword type=password 
      name=confirmpassword onchange='checkinput("confirmpassword","confirmpasswordimage")'>
        <span id=confirmpasswordimage><img src="/images/BacoError.gif" align=absMiddle></span></TD>
    </TR>
    <TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
<%if(GCONST.getONDACTYLOGRAM()){%>
<tr><td colspan=2 height=20></td></tr>
<TR class=title><TH colSpan=2>修改指纹</TH></TR>
<TR class=spacing><TD class=line1 colSpan=2></TD></TR>
<tr>
	<td valign="top"><%=SystemEnv.getHtmlLabelName(22143,user.getLanguage())%><br><%if(canmodifydactylogram.equals("1")){%><font color="red">(<%=SystemEnv.getHtmlLabelName(22144,user.getLanguage())%>)</font><%}%></td>
	<td class=Field>
		<table width="100%">
  		<COLGROUP>
  		<COL width="10%">
  		<COL width="10%">
 			<COL width="80%">
			<tr>
				<td valign="top"><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></td>
				<td valign="top"><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%><td>
				<td></td>
			</tr>
			<tr>
				<td align="left"><a <%if(canmodifydactylogram.equals("1")){%>style="cursor:hand" onclick="FingerEnroll('maindactylogram')"<%}%>><img width=80 height=100 src="<%=mainDactylogramImgSrc%>" align="absmiddle" border="0"></a></td>
				<td align="left"><a <%if(canmodifydactylogram.equals("1")){%>style="cursor:hand" onclick="FingerEnroll('assistantdactylogram')"<%}%>><img width=80 height=100 src="<%=assistantDactylogramImgSrc%>" align="absmiddle" border="0"></a></td>
				<td></td>
			</tr>
			<%if(canmodifydactylogram.equals("1")){%>
			<tr>
				<td valign="top"><%if(hasMainDactylogram.equals("1")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('maindactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22145,user.getLanguage())%></font></a><%}%></td>
				<td valign="top"><%if(hasAssistantDactylogram.equals("1")){%><a style="color:#262626;cursor:hand; TEXT-DECORATION:none" onclick="delDactylogram('assistantdactylogram')"><font color="red"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22146,user.getLanguage())%></a></font><%}%><td>
				<td></td>
			</tr>
			<%}%>
				<input type="hidden" id="maindactylogram" name="maindactylogram" value="">
				<input type="hidden" id="assistantdactylogram" name="assistantdactylogram" value="">
		</table>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<%}%>
    </TBODY>
    </TABLE>
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
<%
if(GCONST.getONDACTYLOGRAM())
{
%>
<object classid="clsid:1E6F2249-59F1-456B-B7E2-DD9F5AE75140" width="1" height="1" id="dtm" codebase="WellcomJZT998.ocx"></object>
<%
}
%>
<script language=javascript>  
var openStatus = 0;
function OpenDevice()
{
    dtm.DataType = 0;
    iRet = dtm.EnumerateDevicesSimple();
    if(iRet == 0)
    {
        devInfo = dtm.strInfo;
        devNum = devInfo.split(",")[1];
        iRet = dtm.OpenDevice(devNum);
        if(iRet == 0)
        {
            openStatus = 1;
        }
    }
}
function CloseDevice()
{
    iRet = dtm.CloseDevice();
}
//--------------------------------------------------------------//
// 登记指纹模板
//--------------------------------------------------------------//
function FingerEnroll(hiddenname){
	OpenDevice();
	if(openStatus==1){
		dtm.InputParam = "";
		iRet = dtm.EnrollSimple();
		if(iRet != 0){
			alert("<%=SystemEnv.getHtmlLabelName(22147,user.getLanguage())%>");
		}else{
	  	document.all(hiddenname).value=dtm.strInfo;
	  	frmMain.operation.value=hiddenname;
	  	frmMain.submit();
		}
		CloseDevice();
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(22148,user.getLanguage())%>");
	}
	
}
function delDactylogram(hiddenname){
	if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
  	frmMain.operation.value=hiddenname;
  	frmMain.submit();
	}
}

function submitData() {
	if(checkpassword ()){
		var flag = true;
		<%if("1".equals(needed) && "2".equals(userUsbType)){%>
			flag = changeKeyPassWd(); 
			if(flag) {
			   window.parent.parent.password = document.getElementById("confirmpassword").value;
			   window.top.password = document.getElementById("confirmpassword").value;
			}
		<%}%>
		if(flag == true){
			var checkpass = CheckPasswordComplexity();
			if(checkpass)
			{
				frmMain.submit();
			}
		}		
	}
}
function CheckPasswordComplexity()
{
	var ins = document.getElementById("passwordnew");
	var ics = document.getElementById("confirmpassword");
	var cs = "";
	if(ics)
	{
		cs = ics.value;
	}
	//alert(cs);
	var checkpass = true;
	<%
	if("1".equals(passwordComplexity))
	{
	%>
	var complexity11 = /[a-z]+/;
	var complexity12 = /[A-Z]+/;
	var complexity13 = /\d+/;
	if(cs!="")
	{
		if(complexity11.test(cs)&&complexity12.test(cs)&&complexity13.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("新密码不符合要求，必须为字母大写、字母小写、数字组合！请重新输入！");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	else if("2".equals(passwordComplexity))
	{
	%>
	var complexity21 = /[a-zA-Z_]+/;
	var complexity22 = /\W+/;
	var complexity23 = /\d+/;
	if(cs!="")
	{
		if(complexity21.test(cs)&&complexity22.test(cs)&&complexity23.test(cs))
		{
			checkpass = true;
		}
		else
		{
			alert("新密码不符合要求，必须为字母、数字、特殊字符组合！请重新输入！");
			ins.value = "";
			ics.value = "";
			checkpass = false;
		}
	}
	<%
	}
	%>
	return checkpass;
}
function checkpassword() {
if(!check_form(password,"passwordold,passwordnew,confirmpassword")) 
    return false;
if(password.passwordnew.value.length<<%=minpasslen%>){
    alert("<%=SystemEnv.getHtmlLabelName(20172,user.getLanguage())+minpasslen%>");
return false;
    }
if(password.passwordnew.value != password.confirmpassword.value) {
    alert("<%=SystemEnv.getHtmlNoteName(16,user.getLanguage())%>");
    return false;
}
return true;
	}
	</script>
		<%if("1".equals(needed) && "2".equals(usbType)){%>
		<script language=javascript>  
			function changeKeyPassWd(){
				var flag = false;
				var ret = changeKeyPW();
				if(ret == 1){
					flag = true;
				}else{
					alert("<%=SystemEnv.getHtmlLabelName(21608, user.getLanguage())%>"+", "+"<%=SystemEnv.getHtmlLabelName(21607, user.getLanguage())%>");
				}

				return flag;
			}
			</script>
<OBJECT id=htactx name=htactx 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
		<script language=VBScript>
			function changeKeyPW()
				dim ret
				ret = 1
				dim hCard
				hCard = 0
				on   error   resume   next
				hCard = htactx.OpenDevice(1)'打开设备
				If Err.number<>0 or hCard = 0 then
					'alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
					ret = 0
					Exit function
				End if
				htactx.VerifyUserPin hCard, CStr(password.passwordold.value) '校验口令
				If Err.number<>0 Then
					htactx.CloseDevice hCard
					ret = 0
					Exit function
				End if
				htactx.ChangeUserPin hCard, CStr(password.passwordold.value), CStr(password.passwordnew.value)
				If Err.number<>0 Then
					'alert "修改PIN码失败!"
					ret = 0
					htactx.CloseDevice hCard
					Exit function
				End If

				htactx.CloseDevice hCard
				changeKeyPW = ret

			End function
		</script>
		<%}%>

	 </BODY>
    </HTML>