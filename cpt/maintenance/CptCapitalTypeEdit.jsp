<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

int id = Util.getIntValue(request.getParameter("id"),0);
 rs.executeProc("CptCapitalType_SelectById",""+id);

	String name = "";
	String description = "";
	String typecode = "";
 if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	description = Util.toScreenToEdit(rs.getString("description"),user.getLanguage());
	typecode = Util.null2String(rs.getString("typecode"));
	}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) 
				+ ":&nbsp;" + SystemEnv.getHtmlLabelName(703,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Edit", user)){
canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CptCapitalTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//if(HrmUserVarify.checkUserRight("CptCapitalType:Log", user)){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=75 and relatedid="+id+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=weaver name=frmMain action="CapitalTypeOperation.jsp" method=post>
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
<%
if (msgid!=-1) {
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid, user.getLanguage())%>
</FONT>
</DIV>
<%}%>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

		<TABLE class=ViewForm>
		  <COLGROUP>
		  <COL width="20%">
		  <COL width="80%">
		  <TBODY>
		  <TR class=Title>
			<TH colSpan=2><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></TH></TR>
		  <TR class=Spacing style="height:1px;">
			<TD class=Line1 colSpan=2 ></TD></TR>
		  <TR>
				  <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
				  <TD class=Field><%if(canEdit){%><INPUT type=text size=30 name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")' class="InputStyle">
				  <SPAN id=nameimage></SPAN><%}else{%><%=name%><%}%></TD>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<TR>
				  <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				  <TD class=Field><%if(canEdit){%><INPUT type=text size=60 name="description"   value="<%=description%>" onchange='checkinput("description","descriptionimage")' class="InputStyle">
				  <SPAN id=descriptionimage></SPAN><%}else{%><%=description%><%}%></TD>
				</TR>
		  </TR>
			<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR>
				<TR>
				  <TD><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></TD>
				  <TD class=Field><%if(canEdit){%><INPUT type=text size=60 maxlength=100 name="typecode"   value="<%=typecode%>" class="InputStyle">
				  <%}else{%><%=description%><%}%></TD>
				</TR>
		  </TR>
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

 <input type=hidden name=operation>
 <input type=hidden name=id value="<%=id%>">
 </form>

 <script language=javascript>
 function onSave(){
	if(check_form(document.getElementsByName("frmMain")[0],'name,description')){
		document.getElementsByName("operation")[0].value="edit";
		document.getElementsByName("frmMain")[0].submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.getElementsByName("operation")[0].value="delete";
			document.getElementsByName("frmMain")[0].submit();
		}
}
function goBack(){
	location.href = "/cpt/maintenance/CptCapitalType.jsp";
}
 </script>
</BODY></HTML>
