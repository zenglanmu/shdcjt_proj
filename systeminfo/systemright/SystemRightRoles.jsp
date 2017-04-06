<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String id = Util.null2String(request.getParameter("id"));
String groupID = Util.null2String(request.getParameter("groupID"));//

int detachable = Util.getIntValue(Util.null2String(request.getParameter("detachable")));
String coulddetach=Util.null2String(request.getParameter("coulddetach"));
String languageid = ""+ user.getLanguage();
char separator = Util.getSeparator() ;
RecordSet.executeProc("SystemRightsLanguage_SByIDLang",id+separator+languageid);
RecordSet.next()  ;
String righttype = RecordSet.getString("righttype");
String rightname = Util.toScreen(RecordSet.getString("rightname"),user.getLanguage());
String rightdesc = Util.toScreen(RecordSet.getString("rightdesc"),user.getLanguage());
String typename="";
if(righttype.equals("0")) typename= SystemEnv.getHtmlLabelName(147,user.getLanguage()) ;
else if(righttype.equals("1")) typename= SystemEnv.getHtmlLabelName(58,user.getLanguage()) ;
else if(righttype.equals("2")) typename= SystemEnv.getHtmlLabelName(189,user.getLanguage()) ;
else if(righttype.equals("3")) typename= SystemEnv.getHtmlLabelName(179,user.getLanguage()) ;
else if(righttype.equals("8")) typename= SystemEnv.getHtmlLabelName(535,user.getLanguage()) ;
else if(righttype.equals("5")) typename= SystemEnv.getHtmlLabelName(259,user.getLanguage()) ;
else if(righttype.equals("6")) typename= SystemEnv.getHtmlLabelName(101,user.getLanguage()) ;
else if(righttype.equals("7")) typename= SystemEnv.getHtmlLabelName(468,user.getLanguage()) ;

boolean canadd = HrmUserVarify.checkUserRight("SystemRightRolesAdd:Add",user) ;
boolean candelete = HrmUserVarify.checkUserRight("SystemRightRolesEdit:Delete",user) ;	
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(385,user.getLanguage()) ;
String needfav ="";
String needhelp ="1";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/systeminfo/systemright/SystemRightGroupEdit.jsp?id="+groupID+",_self} " ;
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
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			<TABLE class=ViewForm>
				<COLGROUP> <COL width="15%"> <COL width="85%">  <TBODY> 
				<TR class=Spacing style="height:1px;"> 
				  <TD class=Line1 colSpan=2></TD>
				 </TR>
				<TR> 
				  
				<TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
				  
				<TD class=Field><%=id%></TD>
				  
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<tr> 
				  
				<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
				  <td class=Field><%=rightname%></td>
				  
				</tr>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<TR> 
				  
				<TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
				  <TD class=Field><%=rightdesc%></TD>
				  
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
				<TR> 
				  
				<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
				  
				<TD class=Field> <%=typename%></TD>
				  
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                <%if(detachable==1){%>
				<TR> 
				<TD><%=SystemEnv.getHtmlLabelName(17861,user.getLanguage())%></TD>
                <%if(coulddetach.equals("1")){%>
                    <td class=Field><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></td>
                <%}else{%>
                    <td class=Field><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></td>
                <%}%>
				</TR>
				<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
                <%}%>
				</TBODY> 
			  </TABLE>
			<br>
			<TABLE class=ListStyle cellspacing="1">
			<COLGROUP>
			  <COL width="20%">
			  <COL width="45%">
			  <COL width="25%">
			<% if(candelete) {%>
			<COL width="15%">
			<% }%>
			  <TBODY>
			  <TR class=Header>
				<TD ><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
				<TD align=right colSpan=3><% if(canadd) {%><BUTTON class=Btn id=button1 accessKey=1 
				  onclick='location.href="SystemRightRolesAdd.jsp?id=<%=id%>&groupID=<%=groupID%>"' 
				  name=button1><U>1</U>-<%=SystemEnv.getHtmlLabelName(193,user.getLanguage())%></BUTTON><%}%> 
				</TD>
			  </TR>
			  <TR class=Header>
				<TD>ID</TD>
				<TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
				<TD><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
			<% if(candelete) {%>	<td><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></td> <%}%>
			  </TR>
			  <TR class=Line  style="height:1px;"><TD colspan="4" ></TD></TR>
			<%
			RecordSet.executeProc("SystemRightRoles_SByRightid",id);
			int i=0;
			while(RecordSet.next()) {
			String rolerightid = RecordSet.getString("id") ;
			String roleid = RecordSet.getString("roleid") ;
			String rolelevel = RecordSet.getString("rolelevel") ;
			String levelname = "" ;
			if(rolelevel.equals("0")) levelname = SystemEnv.getHtmlLabelName(124,user.getLanguage()) ;
			if(rolelevel.equals("1")) levelname = SystemEnv.getHtmlLabelName(141,user.getLanguage()) ;
			if(rolelevel.equals("2")) levelname = SystemEnv.getHtmlLabelName(140,user.getLanguage()) ;
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
				<TD><%=roleid%></TD>
				<TD>
				<%
					RecordSet1.executeSql("select rolesmark from HrmRoles where id = "+roleid);
					RecordSet1.next();
				%>
				<A href="SystemRightRolesEdit.jsp?id=<%=rolerightid%>&groupID=<%=groupID%>"><%=Util.toScreen(RecordSet1.getString(1),user.getLanguage())%></A></TD>
				<TD><%=levelname%></TD>
			<% if(candelete) {%>	<td><a href="SystemRightGroupOperation.jsp?operationType=deleterightroles&id=<%=rolerightid%>&rightid=<%=id%>&roleid=<%=roleid%>&groupID=<%=groupID%>" ><img border=0 src="/images/icon_delete.gif"></a></td> <% }%>
				</TR>
			<%}%>
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

</BODY></HTML>
