<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head><%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(385,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(122,user.getLanguage());
String needfav ="1";
String needhelp ="1";
String id = Util.null2String(request.getParameter("id")) ;
String groupID = Util.null2String(request.getParameter("groupID")) ;

RecordSet.executeProc("SystemRightRoles_SelectByID",id);
RecordSet.next()  ;
String rightid = RecordSet.getString("rightid");
String roleid = RecordSet.getString("roleid");
String rolelevel = RecordSet.getString("rolelevel");
boolean canedit = HrmUserVarify.checkUserRight("SystemRightRolesEdit:Edit",user) ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if(canedit)
{
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("SystemRightRolesAdd:Add",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",SystemRightRolesAdd.jsp?id="+rightid+"&groupID="+groupID+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("SystemRightRolesEdit:Delete",user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM ID=editroles  name=editroles ACTION=SystemRightGroupOperation.jsp METHOD=POST>
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name=operationType>
<input type=hidden name="groupID" value="<%=groupID%>">
<input type=hidden name="rightid" value="<%=rightid%>">
<input type=hidden name="roleid" value="<%=roleid%>">
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

		<TABLE class="ViewForm" style="width:50%">
			<TR>
				
			  <TD><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></TD>
				
			  <TD class="field"><%=Util.toScreen(RightComInfo.getRightname(rightid,""+user.getLanguage()),user.getLanguage())%></TD>
			</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			<TR>
				
			  <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
			  <%
				RecordSet1.executeSql("select rolesmark from HrmRoles where id = "+roleid);
				RecordSet1.next();
			%>
				<TD class="field"><%=Util.toScreen(RecordSet1.getString(1),user.getLanguage())%></TD>
			</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
			<TR>
				
			  <TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
				<TD class="field"><% if(canedit) {%><SELECT ID=rolelevel CLASS=saveHistory NAME=rolelevel>
				<OPTION VALUE="2" <% if(rolelevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></OPTION>
				<OPTION VALUE="1" <% if(rolelevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION>
				<OPTION VALUE="0" <% if(rolelevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION></SELECT>
				<%} else {%>
				<% if(rolelevel.equals("2")) {%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><%}%>
				<% if(rolelevel.equals("1")) {%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%}%>
				<% if(rolelevel.equals("0")) {%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>
				<%}%>
				</TD>
			</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
<script language="javascript">
  
  function onEdit(){
	  document.editroles.operationType.value="editrightroles";
	  document.editroles.submit();
  }
  function onDelete(){
	  if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
		document.editroles.operationType.value="deleterightroles";
		document.editroles.submit();
	  }
  }
</script> 
</BODY>
</HTML>