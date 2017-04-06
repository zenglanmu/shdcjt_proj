<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<%
String ids = Util.null2String(request.getParameter("ids"));
String src = Util.null2String(request.getParameter("src"));
String status = "";
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(23082,user.getLanguage())+"-";
if(src.equals("reject")) {
	titlename += SystemEnv.getHtmlLabelName(23048,user.getLanguage());
	status = "2";
}
else {
	titlename += SystemEnv.getHtmlLabelName(236,user.getLanguage());
	status = "3";
}
String needfav ="";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="frmmain" method="post" action="/docs/change/ReceiveDocOpterator.jsp">
<input type=hidden name="src" value="<%=src%>">
<input type=hidden name="ids" value="<%=ids%>">
<input type=hidden name="status" value="<%=status%>">

<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" class=Line1 colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">



  <TABLE class=ViewForm cellspacing=1 id="oTable1" cols=2 border=0>
    <br/>
    <DIV align="center">
	<font style="font-size:14pt;FONT-WEIGHT: bold">
	  <%=titlename%>
	</font>
    </DIV>
    <br/>
  	<TR><TD class=Line1 colSpan=2></TD></TR>

    <tr class=datadark>
	  <td width="20%"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
	  <td width="80%" class=field>
		<textarea class="InputStyle" id="description" name="detail" rows="5" style="width:98%"></textarea>
	  </td>
	</tr>
	<TR><TD class=Line2 colSpan=2></TD></TR>

  </table>
  <br>
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

  <input type="hidden" name="totaldetail" value=0> 

</form>
</body>
</html>
<script>
function doSave(mobj) {
	document.frmmain.submit();
	mobj.disabled = true;
}
</script>