<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" src="/js/chechinput.js"></script>

</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(389,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmBankAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<form name=frmmain method=post action="HrmBankOperation.jsp" onSubmit="check_form(this,'bankname,bankdesc')">
<input type=hidden name="operation" value="insert">
<table class=Viewform>
  <col width="20%">
  <col width="80%">
  <TR class=Title> 
     <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15812,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing style="height:2px"> 
    <TD class=Line1 colSpan=2></TD>
  </TR>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></td>
     <td class=field><input class="InputStyle" maxLength="30" size="30" name="bankname" onchange="checkinput('bankname','banknamespan')" size=15 maxlength=30>
     <span id=banknamespan><IMG src="/images/BacoError.gif" align=absMiddle></span></td>
  </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></td> 
     <td class=field><input class="InputStyle" type="input" name="bankdesc" onchange="checkinput('bankdesc','bankdescspan')" size=50 maxlength=100>
     <span id=bankdescspan><IMG src="/images/BacoError.gif" align=absMiddle></span></td>
  </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <!-- tr>
     <td><%=SystemEnv.getHtmlLabelName(559,user.getLanguage())%></td>
     <td class=field><input type="input" name="checkstr" size=50 maxlength=100 ></td>
  </tr -->
</table>
</form>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
 if(check_form(frmmain,'bankname,bankdesc')){
 frmmain.submit();
 }
}

function test(){
	alert(document.all("bankname").value);

}
</script>
</body>
</html>