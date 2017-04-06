<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(370,user.getLanguage())+SystemEnv.getHtmlLabelName(371,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(77,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user);
String countryid=Util.null2String(request.getParameter("countryid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmPubHoliday.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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

<FORM id=weaver name=frmmain method=post action="HrmPubHolidayOperation.jsp" onSubmit="return check_form(this,'fromyear,toyear')">
<input class=inputstyle type="hidden" name="operation" value="copy">
<table class=Viewform>
<col width="30%">
<col width="70%">
    <tr>
    	<td><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></td>
    	<td class=field><%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%>
    	<input class=inputstyle type="hidden" name="countryid" value="<%=countryid%>"></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
    	<td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>)</td>
    	<td class=field>
    	  <input class=inputstyle type="input" name="fromyear" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("fromyear")' size=15 maxlength=4>
    	   - <input class=inputstyle type="input" name="toyear" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("toyear")' size=15 maxlength=4></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</table>
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
 function submitData() {
     if(check_form(frmmain,'fromyear,toyear')){
         frmmain.submit();
     }
}
</script>
</body>
</html>