<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% 
if(!HrmUserVarify.checkUserRight("OutDataInterface:Setting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operate = Util.null2String(request.getParameter("operate"));
if(operate.equals("add")){
    int periodvalue = Util.getIntValue(Util.null2String(request.getParameter("periodvalue")),0);
    RecordSet.executeSql("delete from outerdatawfperiodset");
    RecordSet.executeSql("insert into outerdatawfperiodset(periodvalue) values("+periodvalue+")");
}
String periodvalue = "";
RecordSet.executeSql("select periodvalue from outerdatawfperiodset");
if(RecordSet.next()) periodvalue = Util.null2String(RecordSet.getString("periodvalue"));
%>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<script type="text/javascript">
function formsubmit() {
	$GetEle("frmmain").submit()
}

</script>
</head>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(23112,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formsubmit();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="automaticperiodsetting.jsp">
<input type="hidden" id="operate" name="operate" value="add">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td></td>
<td valign="top">
	<TABLE class=Shadow>
	<tr>
	<td valign="top">
	<table class=viewform cellspacing=1>
		<colgroup>
		<col width="10%">
		<col width="90%">
		<tbody>
		<tr class=spacing><td class=Sep1 colSpan=3></td></tr>
		<tr><th colspan=2 align=left><%=SystemEnv.getHtmlLabelName(23112,user.getLanguage())%></th></tr>
		<tr style="height:1px;"><td class=line1 colspan=2></td></tr>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(23136,user.getLanguage())%></td>
			<td class=field><input type=text class=inputstyle size=10 maxlength=8 id="periodvalue" name="periodvalue" value="<%=periodvalue%>" onKeyPress="ItemCount_KeyPress()">
			<span><font color=red>(<%=SystemEnv.getHtmlLabelName(23137,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(23138,user.getLanguage())%>)</font></span>
			</td>
		</tr>
		<tr style="height:1px;"><td class=line colspan=2></td></tr>
		</tbody>
	</table>
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
</form>
</body>
</html>
