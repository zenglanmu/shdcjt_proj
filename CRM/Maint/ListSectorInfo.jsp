<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<%
	String parentid = Util.null2String(request.getParameter("parentid"));
	if(parentid.equals("")) parentid="0";
	RecordSet.executeProc("CRM_SectorInfo_SelectByID",parentid);
	RecordSet.first();
	String pparent = RecordSet.getString("parentid");
	
	RecordSet.executeProc("CRM_SectorInfo_SelectAll",parentid);
	if(RecordSet.getFlag()!=1)
	{
		response.sendRedirect("/CRM/DBError.jsp?type=FindData");
		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(575,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage());
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
if(HrmUserVarify.checkUserRight("AddSectorInfo:add", user)){
%>
<DIV class=BtnBar>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/CRM/Maint/AddSectorInfo.jsp?parentid="+parentid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>

<%if((!parentid.equals("0"))&&(!parentid.equals(""))){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(596,user.getLanguage())+",javascript:location='/CRM/Maint/ListSectorInfo.jsp?parentid="+pparent+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%}%>
</DIV>

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <COL width="20%">
  <COL width="10%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17507,user.getLanguage())%></th>
  <th colspan=2><%=SystemEnv.getHtmlLabelName(605,user.getLanguage())%></th>
  </tr>
<TR class=Line><TD colSpan=5 style="padding: 0"></TD></TR>
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
		<TD><a href="/CRM/Maint/EditSectorInfo.jsp?id=<%=RecordSet.getString(1)%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></TD>
		<TD><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(SectorInfoComInfo.getSectorInfoname(RecordSet.getString(4)),user.getLanguage())%>&nbsp;</TD>
		<TD>
<%
if(HrmUserVarify.checkUserRight("AddSectorInfo:add", user)){
%>			
		<a href="/CRM/Maint/AddSectorInfo.jsp?parentid=<%=RecordSet.getString(1)%>"><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%></a>
<%}%>	
		</TD>
		<TD><a href="/CRM/Maint/ListSectorInfo.jsp?parentid=<%=RecordSet.getString(1)%>"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></a></TD>
	</TR>
<%
	}
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
</BODY>
</HTML>
