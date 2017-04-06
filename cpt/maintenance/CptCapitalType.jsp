<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(703,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",CptCapitalTypeAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("CptCapitalType:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=44,_self} " ;
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
			<TABLE class=ListStyle cellspacing="1">
			  <COLGROUP>
			  <COL width="30%">
			  <COL width="50%">
			  <COL width="20%">
			  <TBODY>
			  <TR class=Header>
				<TH colSpan=3><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></TH></TR>
			  <TR class=Header>
				<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></TD>
			  </TR>
			  <TR class=Line><TD colspan="3" ></TD></TR>

			<%
				   rs.executeProc("CptCapitalType_Select","");
				int needchange = 0;
				  while(rs.next()){
					String	name=rs.getString("name");
					String	description=rs.getString("description");
					String  typecode = Util.null2String(rs.getString("typecode"));
				   try{
					if(needchange ==0){
						needchange = 1;
			%>
			  <TR class=datalight>
			  <%
				}else{
					needchange=0;
			  %><TR class=datadark>
			  <%  	}
			  %>
				<TD><a href="CptCapitalTypeEdit.jsp?id=<%=rs.getString(1)%>"><%=name%></TD>
				<TD><%=description%></a></TD>
				<TD><%=typecode%></TD>
				
			  </TR>
			<%
				  }catch(Exception e){
					System.out.println(e.toString());
				  }
				}
			%>
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
</BODY>
</HTML>
