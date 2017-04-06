<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("LgcAssetUnit_SelectByID",id);
RecordSet.next();
String unitmark = RecordSet.getString("unitmark");
String unitname = RecordSet.getString("unitname");
String unitdesc = RecordSet.getString("unitdesc");
boolean canedit = HrmUserVarify.checkUserRight("LgcAssetUnitEdit:Edit", user) ;

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) + ":&nbsp;"
				+ SystemEnv.getHtmlLabelName(705,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("LgcAssetUnitEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<script>
	alert("<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>");
</script>
</font>
</DIV>
<%}%>
  <FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="LgcAssetUnitOperation.jsp">
    <input type="hidden" name="operation">
    <input type="hidden" name="id" value="<%=id%>">
    <input type="hidden" name="unitmark" value="<%=unitmark%>">
<div>
<!--
<% if(HrmUserVarify.checkUserRight("LgcAssetUnit:Log", user)){%>
<BUTTON type="button" class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =44 and relatedid=<%=id%>'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}%>
-->
</div>    
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
   
		  <TABLE class=ViewForm>
			<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
			<TR class=Title> 
			  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></TH>
			</TR>
			<TR class=Spacing style="height:1px;"> 
			  <TD class=Line1 colSpan=2></TD>
			</TR>
		<!--
			<tr> 
			  <td>ฑ๊สถ</td>
			  <td class=Field> 
				<% if(canedit) { %>
				<input accesskey=Z name=unitmark onChange='checkinput("unitmark","unitmarkimage")' value="<%=Util.toScreenToEdit(unitmark,user.getLanguage())%>" maxlength="20">
				<span id=unitmarkimage></span> 
				<% } else {%>
				<%=Util.toScreen(unitmark,user.getLanguage())%> 
				<%}%>
			  </td>
			</tr>
		-->
			<TR> 
			  <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
			  <TD Class=Field> 
				<% if(canedit) { %>
				<input accesskey=Z name=unitname size="30" onChange='checkinput("unitname","unitnameimage")' value="<%=Util.toScreenToEdit(unitname,user.getLanguage())%>" maxlength="30" class="InputStyle">
				<span id=unitnameimage></span> 
				<% } else {%>
				<%=Util.toScreen(unitname,user.getLanguage())%> 
				<%}%>
			  </TD>
			</TR>
			<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			<tr> 
			  <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
			  <td class=Field> 
				<% if(canedit) { %>
				<textarea accesskey="Z" name="unitdesc" cols="60" class="InputStyle"><%=Util.toScreenToEdit(unitdesc,user.getLanguage())%></textarea>
				<% } else {%>
				<%=Util.toScreen(unitdesc,user.getLanguage())%> 
				<%}%>
			  </td>
			</tr>
			<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			</TBODY> 
		  </TABLE>

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

</FORM>
<script language=javascript>
 function onEdit(){
 	if(check_form(document.getElementsByName("frmMain")[0],'unitname')){
 		document.getElementsByName("operation")[0].value="editunit";
 		document.getElementsByName("frmMain")[0].submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.getElementsByName("operation")[0].value="deleteunit";
			document.getElementsByName("frmMain")[0].submit();
		}
}
 function doBack(){
   location = "LgcAssetUnit.jsp";
 }
 </script>
</BODY>
</HTML>

