<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17630,user.getLanguage());
String needfav ="1";
String needhelp ="";

String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
String name="";
String description="";
String usefee="";
String CanDelete=request.getParameter("CanDelete");
RecordSet.executeProc("CarType_SelectByID",id);
if(RecordSet.next()){
    name=RecordSet.getString("name");
    description=RecordSet.getString("description");
    usefee=RecordSet.getString("usefee");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
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
			
			<TABLE class="Shadow">
			<tr>
			<td valign="top">
			
<form name=frmmain action="CarTypeOperation.jsp">
<input type="hidden" name=operation>
<input type="hidden" name=id value=<%=id%>>

<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <% if(CanDelete!=null && CanDelete.equals("1")){%>
  <tr><font color="red">已经被引用，不能够删除！</font>
  </tr>
  <%}%>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=2></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")' value="<%=name%>">
    <SPAN id=nameimage></SPAN></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=60 name="description" value="<%=description%>"></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=inputstyle type=text size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
    onBlur="checknumber1(this);checkinput('usefee','usefeespan')" value="<%=usefee%>">
    <SPAN id=usefeespan></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%></TD>
  </TR>
  <TR style="height:1px;"><TD class=Line colspan=2></TD></TR> 
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
 function onSave(){
	if(check_form($GetEle("frmmain"),'name,usefee')){
		$GetEle("operation").value="edit";
		$GetEle("frmmain").submit();
	}
 }
 function onDelete(){
		if(isdel()) {
			$GetEle("operation").value="delete";
			$GetEle("frmmain").submit();
		}
}
function submitData() {
    window.history.back();
}
 </script>
 </TBODY></TABLE>
</BODY></HTML>
