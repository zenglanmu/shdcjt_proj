<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;
String username = user.getUsername() ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;

%>
<html>
<head>
<title>泛微协同商务系统(Weaver ecology)</title>
<link rel="stylesheet" href="/css/frame.css" type="text/css">
</head>

<SCRIPT language=javascript>
function mnToggleleft(){
	var f = window.top.MainBottom;
	if (f != null) {
		var c = f.cols;
		if (c == "0,8,*,8") 
			{f.cols = "162,8,*,8"; LeftHideShow.src = "/images_frame/dh/BP_Hide.gif"; LeftHideShow.title = "隐藏"}	
		else 
			{ f.cols = "0,8,*,8"; LeftHideShow.src = "/images_frame/dh/BP_Show.gif"; LeftHideShow.title = "显示"}
	}
}
function mnToggletop(){
	var f = window.top.Main;
	if (f != null) {
		var c = f.rows;
		if (c == "0,*") 
			{f.rows = "75,*"; TopHideShow.src = "/images_frame/dh/BP2_Hide.gif"; TopHideShow.title = "隐藏"}	
		else 
			{ f.rows = "0,*"; TopHideShow.src = "/images_frame/dh/BP2_Show.gif"; TopHideShow.title = "显示"}
	}
}
</SCRIPT>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td background="/images_frame/portal/bg_4.gif" height ="10" colspan="3">
  </tr>
  <tr>
    <td background="/images_frame/portal/bg_3.gif" style="PADDING-TOP: 3px" vAlign=top height ="27" width = "80">&nbsp; 
    <IMG id=LeftHideShow  title=隐藏 style="CURSOR: hand" onclick=mnToggleleft() src="/images_frame/dh/BP_Hide.gif" >
    <IMG id=TopHideShow  title=隐藏 style="CURSOR: hand" onclick=mnToggletop() src="/images_frame/dh/BP2_Hide.gif"></td>
	<td background="/images_frame/portal/bg_3.gif" align="left" class="wenhou">
	<%if(user.getLanguage()==7||user.getLanguage()==9){%>
		<%=username%> 
		<% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
			晚上好
		<%} else if(currenthour.compareTo("12") < 0 ) {%>
			上午好
		<%} else if(currenthour.compareTo("14") <= 0 ) {%>
			中午好
		<%} else if(currenthour.compareTo("18") < 0 ) {%>
			下午好
		<%}%>
			! 今天是<%=currentyear%>年<%=currentmonth%>月<%=currentdate%>日
	<%}else{%>
		<% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
			<%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		<%} else if(currenthour.compareTo("12") < 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		<%} else if(currenthour.compareTo("14") <= 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		<%} else if(currenthour.compareTo("18") < 0 ) {%>
			<%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		<%}%>
			!<%=username%> 
	<%}%>
	</td>
     <td background="/images_frame/portal/bg_3.gif"  width=232 style="PADDING-TOP: -3px" vAlign=top> 
	 <%if(!logintype.equals("2")){%>
			<iframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height=27 width=200 SCROLLING=no SRC=/system/SysRemind.jsp></iframe>
	 <%}%>
	 </td>
  </tr>
  <tr>
  <td height="5" colspan="3"></td>
  </tr>
</table>
</body>


</html>