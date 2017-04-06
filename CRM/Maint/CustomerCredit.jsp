<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canedit = HrmUserVarify.checkUserRight("CRM_CustomerCreditAdd:Add",user);
if (!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6097,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(6098,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sqlstr = "select * from CRM_CustomerCredit" ;
String CreditAmount = "" ;
String CreditTime = "";
RecordSet.executeSql(sqlstr);
if (RecordSet.next()) {
	CreditAmount = RecordSet.getString("CreditAmount");
	CreditTime = RecordSet.getString("CreditTime");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver action="/CRM/Maint/CustomerCreditOperation.jsp" method=post >
	<input type="hidden" name="method" value="edit">
<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=ViewForm>
      <COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
        <TBODY>
		<TR >
        <TD colSpan=2>

		</TD></TR>
         <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD>
	    </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" onchange='checkinput("CreditAmount","CreditAmountimage");checkdecimal_length("CreditAmount",8)' onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("CreditAmount")' value = "<%=CreditAmount%>"><SPAN id=CreditAmountimage><%if (CreditAmount.equals("")) {%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR>
        <tr  style="height: 1px"><td class=Line colspan=2></td>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=10 name="CreditTime" onchange='checkinput("CreditTime","CreditTimeimage")' onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditTime")' value = "<%=CreditTime%>"><SPAN id=CreditTimeimage><%if (CreditTime.equals("")) {%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
         </TR>        
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
function doSave1(){	
	if (check_form(document.forms[0],"CreditAmount,CreditTime")) 
	document.forms[0].submit();
	}
</script>
</BODY>
</HTML>
