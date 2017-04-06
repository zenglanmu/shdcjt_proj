<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(705,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("LgcAssetUnitAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",LgcAssetUnitAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("LgcAssetUnit:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=45,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id="weaver" name="frmmain" method="post">
<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">		  

			<TABLE class="ListStyle" cellspacing="1">
				  <COLGROUP>
				  <COL width="40%">
				  <COL width="60%">
				  <TBODY>
				  <TR class="Header">
					<TH colSpan="2"><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TH></TR>
				  <TR class="Header">
					<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
					<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
					
				  </TR>
				  <TR class="Line"><TD colspan="2"></TD></TR>
				 
				<%
					String id = "";
					String assetunitmark = "";
					String assetunitname = "";
					boolean isLight = false;

					rs.executeProc("LgcAssetUnit_Select","");						
					while (rs.next()) {
						id = rs.getString(1);
						assetunitmark = rs.getString(4);
						assetunitname = rs.getString(3);
						isLight = !isLight;
				%>
				  <TR class="<%=(isLight ? "DataLight" : "DataDark")%>">				  
					<TD><A href="LgcAssetUnitEdit.jsp?id=<%=id%>"><%=assetunitname%></A></TD>
					<TD><%=Util.toScreen(assetunitmark, user.getLanguage())%></TD>
				  </TR>
				<%					  
					}
				%>  
				 </TBODY>
				 </TABLE>

		</TD>
		</TR>
		</TABLE>
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

</FORM>
</BODY>
</HTML>