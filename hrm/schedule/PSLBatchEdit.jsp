<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% 
if(!HrmUserVarify.checkUserRight("AnnualBatch:All", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
String id = Util.null2String(request.getParameter("id"));
String sql = "select * from HrmPSLBatchProcess where id = " + id;
RecordSet.executeSql(sql);
int workingage = 0;
float PSLdays = 0;
if(RecordSet.next()){
   workingage = (int)RecordSet.getFloat("workingage");
   PSLdays = RecordSet.getFloat("PSLdays");
}

String imagefilename = "/images/hdMaintenance.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(24038,user.getLanguage()) + " : "+SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 
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
<FORM id=frmMain action=PSLBatchOperation.jsp method=post >
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
      <TD><%=SystemEnv.getHtmlLabelName(15878,user.getLanguage())%></TD>
      <TD class=Field> 
        <input class=inputstyle size=4 type="text" id=workingage name=workingage value="<%=workingage%>" maxlength="5" onKeyPress="AllNumber_KeyPress()" onBlur='checkallnumber("workingage");checkinput("workingage","workingageimage")'>
        <SPAN id=workingageimage></SPAN>
      </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(24043,user.getLanguage())%></TD>
      <TD class=Field>
         <input class=inputstyle size=4 type="text" id="PSLdays" name="PSLdays" maxlength="5" value="<%=PSLdays%>" onKeyPress="IsNumber_KeyPress()" onBlur='checkisnumber("PSLdays");checkinput("PSLdays","PSLdaysimage")'> 
         <SPAN id=PSLdaysimage></SPAN>               
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
  if(!check_form(frmMain,"workingage,PSLdays")) return false ;
  return true ;
}

function submitData() {
  if(checkvalue()) frmMain.submit();
}
function goback(){
  location="PSLBatchView.jsp?subcompanyid=<%=subcompanyid%>";
}
function ondelete(){
  if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
    location="PSLBatchOperation.jsp?operation=delete&id=<%=id%>&subcompanyid=<%=subcompanyid%>";
  }
}
function AllNumber_KeyPress()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))))
  {
     window.event.keyCode=0;
  }
}
function IsNumber_KeyPress()
{
 if(!(((window.event.keyCode>=48) && (window.event.keyCode<=57))||window.event.keyCode==46))
  {
     window.event.keyCode=0;
  }
}
function checkallnumber(objectname)
{
	valuechar = jQuery("#"+objectname).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	  charnumber = parseInt(valuechar[i]) ; 
	  if( isNaN(charnumber)) jQuery("#"+objectname).val("");
	}	 
}
function checkisnumber(objectname)
{
	valuechar = jQuery("#"+objectname).val().split("") ;
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	  charnumber = parseInt(valuechar[i]) ; 
	  if( isNaN(charnumber)&&valuechar[i]!='.') jQuery("#"+objectname).val("");
	}	 
}
</script>
</BODY>
</HTML>

