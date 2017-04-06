<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("AnnualPeriod:All" , user)) {
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
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
Calendar today = Calendar.getInstance() ; 
String currentyear = Util.add0(today.get(Calendar.YEAR) , 4) ; 
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + 
				 Util.add0(today.get(Calendar.MONTH) + 1 , 2) + "-" + 
				 Util.add0(today.get(Calendar.DAY_OF_MONTH) , 2) ; 
RecordSet.executeSql("select * from hrmannualperiod where subcompanyid = " +subcompanyid+ " order by annualyear desc") ; 
if(RecordSet.next()) { 
	 currentyear = (Util.getIntValue(RecordSet.getString("annualyear"))+1)+"";
}

String imagefilename = "/images/hdMaintenance.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(445 , user.getLanguage()) + " : "+SystemEnv.getHtmlLabelName(365 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback(),_self} " ;
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

<%
if(msgid != -1) {
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid , user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmMain action=AnnualPeriodOperation.jsp method=post >
<input class=inputstyle type=hidden name=operation value="add">
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
        <input class=inputstyle id=annualyear name=annualyear value="<%=currentyear%>" maxlength="4" size=5 
		onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("annualyear");checkinput("annualyear","annualyearimage")'>
              <SPAN id=annualyearimage></SPAN>
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Calendar type="button" id=selectstartdate onclick="onShowDate(startdatespan,startdate)"></BUTTON> 
              <SPAN id=startdatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
              <input class=inputstyle type="hidden" name="startdate" value="">
      </TD>
	  </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
      <TD class=Field><BUTTON class=Calendar type="button" id=selectenddate onclick="onShowDate(enddatespan,enddate)"></BUTTON> 
              <SPAN id=enddatespan ><IMG src='/images/BacoError.gif' align=absMiddle></SPAN> 
              <input class=inputstyle type="hidden" name="enddate" value="">
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
	<td height="0" colspan="3"></td>
</tr>
</table>

<Script language=javascript>
function checkvalue() {
	if(!check_form(frmMain,"annualyear,startdate,enddate")) return false ;
	if(frmMain.annualyear.value.length != 4 ) {
		alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
		return false;
	}
	return true ;
}

function submitData(obj) {
	if(checkvalue()) {frmMain.submit();obj.disabled = true;}
}
function goback(){
    location="AnnualPeriodView.jsp?subcompanyid=<%=subcompanyid%>";
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker.js?rnd="+Math.random()></script>
</HTML>

