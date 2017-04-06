<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="BankComInfo" class="weaver.hrm.finance.BankComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(389,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanEdit=HrmUserVarify.checkUserRight("HrmBankEdit:Edit", user);
boolean CanDelete=HrmUserVarify.checkUserRight("HrmBankEdit:Delete", user);
boolean CanAdd=HrmUserVarify.checkUserRight("HrmBankAdd:Add", user);

String id=Util.null2String(request.getParameter("id"));
String message=Util.null2String(request.getParameter("message"));

String bankname=BankComInfo.getBankname(id);
String bankdesc=BankComInfo.getBankdesc(id);
String checkstr=BankComInfo.getCheckstr(id);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/finance/bank/HrmBankAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanDelete){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
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
<% if(message.equals("fail")){ %> <font color=red><%=SystemEnv.getHtmlLabelName(15813,user.getLanguage())%></font><%}%>
</DIV>
<form name=frmmain method=post action="HrmBankOperation.jsp">
<input type=hidden name="operation">
<input type=hidden name="id" value="<%=id%>">
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
     <td class=field>
     <%if(CanEdit){%>
     <input type="input" name="bankname" onchange="checkinput('bankname','banknamespan')" 
     size=15 maxlength=30 value="<%=Util.toScreenToEdit(bankname,user.getLanguage())%>">
     <span id=banknamespan><%if(bankname.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
     <%} else {%><%=Util.toScreen(bankname,user.getLanguage())%><%}%>
     </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></td> 
     <td class=field>
     <%if(CanEdit){%>
     <input type="input" name="bankdesc" onchange="checkinput('bankdesc','bankdescspan')" 
     size=50 maxlength=100 value="<%=Util.toScreenToEdit(bankdesc,user.getLanguage())%>">
     <span id=bankdescspan><%if(bankdesc.equals("")){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></span>
     <% } else {%><%=Util.toScreen(bankdesc,user.getLanguage())%><%}%>
     </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  <!-- tr>
     <td><%=SystemEnv.getHtmlLabelName(559,user.getLanguage())%></td>
     <td class=field>
     <%if(CanEdit){%>
     <input type="input" name="checkstr" size=50 maxlength=100 value="<%=Util.toScreenToEdit(checkstr,user.getLanguage())%>">
     <% } else {%><%=Util.toScreen(checkstr,user.getLanguage())%><%}%>
     </td>
  </tr -->
</table>
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
	function doSave(){
		if(check_form(document.frmmain,'bankname,bankdesc')){
			document.frmmain.operation.value="save";
			document.frmmain.submit();
		}
	}
	function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmmain.operation.value="delete";
			document.frmmain.submit();
		}
	}
</script>
</body>
</html>