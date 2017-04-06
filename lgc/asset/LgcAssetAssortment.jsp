<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css></HEAD>
<%
	RecordSet.executeProc("LgcAssetAssortment_SelectLeaf","");
	if(RecordSet.getFlag()!=1)
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
String imagefilename = "/images/hdLOG.gif";
String titlename =  Util.toScreen("²úÆ·",user.getLanguage(),"2")+" : " + SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

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

<TABLE class=ListStyle cellspacing=1>
	<TR class=header>
		<TH colSpan=1><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TH>
	</TR>
<TR class=Line><TD colSpan=1></TD></TR>
<%
int i=0;
while(RecordSet.next()){
	String assortmentid = RecordSet.getString("id");
	String assortmentname = Util.toScreen(RecordSet.getString("assortmentname"),user.getLanguage());
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD><A HREF="LgcAssetAdd.jsp?paraid=<%=assortmentid%>"><%=assortmentname%></A></TD>
</TR>
<%}
%>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
</BODY></HTML>
