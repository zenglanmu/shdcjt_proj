<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>

<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String message = Util.null2String(request.getParameter("message"));
%>
<BODY>

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
<% if(message.equals("1")) {%>
<font color="#FF0000">旧的验证码不正确！</font>
<%}%>
<% if(message.equals("2")) {%>
<font color="#FF0000"></font>
<%}%>
<FORM id=password name=frmMain style="MARGIN-TOP: 3px" action=CodeOperation.jsp method=post onsubmit="return checkpassword()">
<input type=hidden name=operation value="changecode">
<TABLE class=viewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2>验证码变更</TH>
    </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
      <TD>旧验证码:</TD>
    <TD class=Field><INPUT class=inputstyle id=passwordold type=password
    name=passwordold onchange='checkinput("passwordold","passwordoldimage")'>
	<SPAN id=passwordoldimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
	</TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>
  <TR>
      <TD>新验证码:</TD>
    <TD class=Field><INPUT class=inputstyle id=passwordnew type=password
    name=passwordnew onchange='checkinput("passwordnew","passwordnewimage")'>
        <span id=passwordnewimage><img src="/images/BacoError.gif" align=absMiddle></span></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>
  <TR>
      <TD>确认新验证码:</TD>
    <TD class=Field><INPUT class=inputstyle id=confirmpassword type=password
      name=confirmpassword onchange='checkinput("confirmpassword","confirmpasswordimage")'>
        <span id=confirmpasswordimage><img src="/images/BacoError.gif" align=absMiddle></span></TD>
    </TR>
    <TR><TD class=Line colSpan=2></TD></TR>
    <tr>
        <td><input type="submit" value="提交" ></td>
        <td></td>
    </tr>
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
<script language=javascript>
function submitData() {
 if(checkpassword ()){
 frmMain.submit();
 }
}
function check_form(thiswins,items)
{
	thiswin = thiswins
	items = items + ",";

	for(i=1;i<=thiswin.length;i++)
	{
	tmpname = thiswin.elements[i-1].name;
	tmpvalue = thiswin.elements[i-1].value;
    if(tmpvalue==null){
        continue;
    }
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);

	if(tmpname!="" &&items.indexOf(tmpname+",")!=-1 && tmpvalue == ""){
		 alert("必填信息不完整！");
		 return false;
		}

	}
	return true;
}

function checkpassword() {
if(!check_form(password,"passwordold,passwordnew,confirmpassword"))
    return false;
if(password.passwordnew.value != password.confirmpassword.value) {
    alert("两次输入的新验证码不同!");
    return false;
}
return true;
	}
	</script>
	 </BODY>
    </HTML>