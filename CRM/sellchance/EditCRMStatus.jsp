<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = request.getParameter("id");

	RecordSet.executeProc("CRM_SellStatus_SelectByID",id);
    
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	if(RecordSet.getCounts()<=0)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
	RecordSet.first();
boolean canedit = HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance",user);

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdMaintenance.gif";
String titlename = "";
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(2250,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(2250,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


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
if(msgid!=-1) {
%>
<DIV>
<FONT color="red" size="2">
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</FONT>
</DIV >    
<%}%>
<FORM id=weaver name="weaver" action="/CRM/sellchance/CRMStatusOperation.jsp" method=post onsubmit='return check_form(this,"type,desc")'>
<DIV style="display:none">
<%
if(canedit){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnSave accessKey=S id=myfun1  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
}
if(canedit){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnDelete id=Delete accessKey=D onclick='doDel()'><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
</DIV>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">
<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="100%">
	<TBODY>
<TR>
<TD vAlign=top>
<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="20%">
	<COL width="80%">
	<TBODY>
	<TR class=Title>	<TH><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
	</TR>
	 <TR class=Spacing style='height:1px'>
	<TD class=Line1 colSpan=2></TD></TR>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
	<TD class=Field><% if(canedit) {%><INPUT text class=InputStyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>"><SPAN id=typeimage></SPAN><%}else {%> <%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%> <%}%></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
	<TR>
	<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
	<TD class=Field><% if(canedit) {%><INPUT text class=InputStyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><SPAN id=descimage></SPAN><%}else {%> <%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%> <%}%></TD>
	</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
	</TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
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
<script type="text/javascript">
function doDel(){
	if(isdel()){location.href="/CRM/sellchance/CRMStatusOperation.jsp?method=delete&id=<%=id%>"}
}
</script>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY>
</HTML>
