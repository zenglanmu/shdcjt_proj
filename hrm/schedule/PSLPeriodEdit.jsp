<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("PSLPeriod:All" , user)) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));

String sql = "select * from HrmPSLPeriod where id = " + id;
RecordSet.executeSql(sql);
RecordSet.next();
String PSLYear = Util.null2String(RecordSet.getString("PSLyear"));
String startdate = Util.null2String(RecordSet.getString("startdate"));
String enddate = Util.null2String(RecordSet.getString("enddate"));

String imagefilename = "/images/hdMaintenance.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(445,user.getLanguage()) + " : "+SystemEnv.getHtmlLabelName(93,user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:ondelete(),_self} " ;
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

<%
if(msgid != -1) {
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain action=PSLPeriodOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation value="edit">
<input class=inputstyle type=hidden name=id value="<%=id%>">
<input class=inputstyle type=hidden name=subcompanyid value="<%=subcompanyid%>">
<TABLE class=ViewForm>
  <TBODY>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH></TR>
  <TR class=Spacing>
    <TD class=sep1></TD></TR></TBODY></TABLE>
  <TABLE class=ViewForm width="60%">
    <COLGROUP> <COL width="15%"> <COL width="85%"><TBODY> 
  <TR style="height:2px"><TD class=Line1 colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></TD>
      <TD class=Field> 
        <input class=inputstyle id=PSLyear name=PSLyear value="<%=PSLYear%>" maxlength="4" size=5 
		onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("PSLyear");checkinput("PSLyear","PSLyearimage")'>
              <SPAN id=PSLyearimage></SPAN>
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate('startdatespan','startdate')"></BUTTON> 
              <SPAN id=startdatespan><%=startdate%></SPAN> 
              <input class=inputstyle type="hidden" name="startdate" value="<%=startdate%>">
      </TD>
	  </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Calendar type="button" id=selectenddate onclick="onShowDate('enddatespan','enddate')"></BUTTON> 
              <SPAN id=enddatespan><%=enddate%></SPAN> 
              <input class=inputstyle type="hidden" name="enddate" value="<%=enddate%>">
      </TD>
	</TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>    
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

<Script language=javascript>
function checkvalue() {
	if(!check_form(frmMain,"PSLyear,startdate,enddate")) return false ;
	if(frmMain.PSLyear.value.length != 4 ) {
		alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
		return false;
	}
	return true ;
}

function submitData() {
	if(checkvalue()) frmMain.submit();
}
function goback(){
    location="PSLPeriodView.jsp?subcompanyid=<%=subcompanyid%>";
}
function ondelete(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
      location="PSLPeriodOperation.jsp?subcompanyid=<%=subcompanyid%>&operation=delete&id=<%=id%>";
    } 
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY>
</HTML>