<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file = "/systeminfo/init.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
 }
%>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page"/>

<HTML><HEAD>
<LINK href = "/css/Weaver.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) + ":" +                                 SystemEnv.getHtmlLabelName(82 , user.getLanguage()) ; 

String needfav = "1" ;
String needhelp = "" ;  
boolean CanAdd =  HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>		
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id = weaver name=frmmain method=post action = "HrmArrangeShiftOperation.jsp">
<input class=inputstyle type = "hidden" name = "operation" value = "insertshift">

<table class=viewform>
  <colgroup>
  <col width = "15%">
  <col width = "85%">
    <tbody>
    <tr class = Title>
      <TH colSpan = 2><%=SystemEnv.getHtmlLabelName(16255,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:2px"> 
      <TD class =Line1 colSpan = 2></TD></TR>

    <tr>
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=field>
        <input class=inputstyle type = "text" name = "shiftname" maxLength = 10 onchange = "checkinput('shiftname','shiftamespan')" size = 43 >
    	<span id="shiftamespan"><IMG src = '/images/BacoError.gif' align = absMiddle></span>
      </td>
    </tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
    <td class=field>
    <button class = Clock type="button" onclick="onShowTime(shiftbegintimespan,shiftbegintime)"></button>
    <span id="shiftbegintimespan"></span>
    <input class=inputstyle type = hidden name ="shiftbegintime" value = "">
    </td>     
    </tr>
<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
    <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
    <td class=field>
    <button class = Clock type="button" onclick = "onShowTime(shiftendtimespan,shiftendtime)"></button>
    <span id = "shiftendtimespan"></span>
    <input class=inputstyle type = hidden name = "shiftendtime" value = "">
    </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    </tbody>
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr style="height:0px">
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData() {
	if(jQuery("input[name=shiftname]").val()!=""){
		weaver.submit();
	}else{
		alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}
}
</script>
</body>
<SCRIPT language="javascript"  src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>