<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<%
	RecordSet.executeProc("CRM_ContacterTitle_SelectAll","");
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
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(462,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("AddContacterTitle:Add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/CRM/Maint/AddContacterTitle.jsp',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
RCMenuHeight += RCMenuHeightStep ;

if(HrmUserVarify.checkUserRight("ContacterTitle:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+143+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+143+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}

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

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <COL width="10%">
  <COL width="10%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(17504,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(568,user.getLanguage())%></th>
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
		<TD><a href="/CRM/Maint/EditContacterTitle.jsp?id=<%=Util.toScreen(RecordSet.getString(1),user.getLanguage())%>"><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%></a></TD>
		<TD>
		<%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%>
		</TD>
		<TD>
		<%	int labelid = 0;
			String tmp = RecordSet.getString(4);
			if(tmp.equals("s"))
				labelid = 584;
			if(tmp.equals("p"))
				labelid = 583;
		%>
		<%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%></TD>
		<TD><%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString(5)),user.getLanguage())%></TD>
		<TD><%=Util.toScreen(RecordSet.getString(6),user.getLanguage())%></TD>
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
</BODY>
</HTML>
