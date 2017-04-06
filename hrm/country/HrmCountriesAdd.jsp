<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmCountriesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCountriesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/country/HrmCountries.jsp,_self} " ;
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
<FORM id=weaver name=frmMain action="CountryOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="10%">
  <COL width="40%">
  <COL width="40%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=3 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=50 name="countryname" maxlength="30" onchange='checkinput("countryname","countrynameimage")'>
          <SPAN id=countrynameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
		  <td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font></td>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=50 name="countrydesc" maxlength="50" onchange='checkinput("countrydesc","countrydescimage")'>
          <SPAN id=countrydescimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
		  <td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27087,user.getLanguage())%></font></td>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <input class=inputstyle type="hidden" name=operation value=add>
 </TBODY></TABLE>
 </form>
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
var submit_flag=false;
function submitData() {
if(submit_flag){return;}else{submit_flag=true;}
 if(check_form($GetEle("frmMain"), 'countryname,countrydesc')){
	 $GetEle("frmMain").submit();
 }
}
</script>
</BODY>
</HTML>