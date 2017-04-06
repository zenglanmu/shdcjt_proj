<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);


if(!HrmUserVarify.checkUserRight("CptCapital:FlowView", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

rs.executeProc("CptUseLog_SelectByID",""+id);

String capitalid = "";
String usedate = "";
String usedeptid = "";
String useresourceid = "";
String usecount = "";
String useaddress = "";
String userequest = "";
String maintaincompany = "";
String fee = "";
String usestatus = "";
String remark = "";
String resourceid = "";
String mendperioddate ="";

if(rs.next()){
	capitalid = Util.toScreen(rs.getString("capitalid"),user.getLanguage());
	usedate = Util.toScreen(rs.getString("usedate"),user.getLanguage());
	usedeptid = Util.toScreen(rs.getString("usedeptid"),user.getLanguage());
	useresourceid = Util.toScreen(rs.getString("useresourceid"),user.getLanguage());
	usecount = Util.toScreen(rs.getString("usecount"),user.getLanguage());
	useaddress = Util.toScreen(rs.getString("useaddress"),user.getLanguage());
	userequest = Util.toScreen(rs.getString("userequest"),user.getLanguage());
	maintaincompany = Util.toScreen(rs.getString("maintaincompany"),user.getLanguage());
	fee = Util.toScreen(rs.getString("fee"),user.getLanguage());
	usestatus = Util.toScreen(rs.getString("usestatus"),user.getLanguage());
	remark = Util.toScreen(rs.getString("remark"),user.getLanguage());
	resourceid = Util.toScreen(rs.getString("resourceid"),user.getLanguage());
	mendperioddate = Util.toScreen(rs.getString("mendperioddate"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(1501,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

		<TABLE class=ViewForm>
		  <COLGROUP>
		  <COL width="10%">
		  <COL width="90%">
		  <TBODY>
		  <TR class=Title>
			<TH colSpan=2><A HREF="CptCapital.jsp?id=<%=capitalid%>">
			<%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%></A>
			</TH>
		  </TR>
		  <TR class=Spacing style="height:2px">
			<TD class=Line1 colSpan=2 ></TD></TR>
		  <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></TD>
			  <TD class=Field><%=usedate%></TD>
		  </TR>
		  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		  <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
			  <TD class=Field><%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())%></TD>
		  </TR>
		  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		  <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
			   <TD class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())%></TD>
		  </TR>
		  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
			<TR>
			  <TD><%=SystemEnv.getHtmlLabelName(1047,user.getLanguage())%></TD>
			   <TD class=Field><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></TD>
		  </TR>
		  <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		  <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
			   <TD class=Field>
					<% if(usestatus.equals("-7")) {%>
					<%=SystemEnv.getHtmlLabelName(1385,user.getLanguage())%>
					<%} else if(usestatus.equals("-6")) {%>
					<%=SystemEnv.getHtmlLabelName(1381,user.getLanguage())%>
					<%} else if(usestatus.equals("-5")) {%>
					<%=SystemEnv.getHtmlLabelName(1377,user.getLanguage())%>
					<%} else if(usestatus.equals("-4")) {%>
					<%=SystemEnv.getHtmlLabelName(1376,user.getLanguage())%>
					<%} else if(usestatus.equals("-3")) {%>
					<%=SystemEnv.getHtmlLabelName(1396,user.getLanguage())%>
					<%} else if(usestatus.equals("-2")) {%>
					<%=SystemEnv.getHtmlLabelName(1397,user.getLanguage())%>
					<%} else if(usestatus.equals("-1")) {%>
					<%=SystemEnv.getHtmlLabelName(1398,user.getLanguage())%>
					<%} else if(usestatus.equals("0")) {%>
					<%=SystemEnv.getHtmlLabelName(1384,user.getLanguage())%>
					<%} else if(usestatus.equals("1")) {%>
					<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%> 
					<%} else if(usestatus.equals("2")) {%>
					<%=SystemEnv.getHtmlLabelName(160,user.getLanguage())%> 
					<%} else if(usestatus.equals("3")) {%>
					<%=SystemEnv.getHtmlLabelName(1379,user.getLanguage())%> 
					<%} else if(usestatus.equals("4")) {%>
					<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage())%> 
					<%} else if(usestatus.equals("5")) {%>
					<%=SystemEnv.getHtmlLabelName(1386,user.getLanguage())%> 
					<%} else{%>
					<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(usestatus),user.getLanguage())%>
					<%}%>
			   </TD>
		  </TR>		
          <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		  <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TD>
			  <TD class=Field><%=usecount%></TD>
		  </TR>
		 <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>  
		 <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(793,user.getLanguage())%></TD>
			  <TD class=Field>
			  <%if(!usestatus.equals("-1")&&!usestatus.equals("-2")) {%>
			  <%=Util.toScreen(RequestComInfo.getRequestname(userequest),user.getLanguage())%>
			  <%}%>
			  </TD>
		  </TR>
	      <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		   <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(1399,user.getLanguage())%></TD>
			  <TD class=Field><%=CustomerInfoComInfo.getCustomerInfoname(maintaincompany)%></TD>
		  </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<TR>
			  <TD><%=SystemEnv.getHtmlLabelName(22457,user.getLanguage())%></TD>
			  <TD class=Field><%=mendperioddate%></TD>
		  </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>     
		<TR>
			  <TD><%=SystemEnv.getHtmlLabelName(1400,user.getLanguage())%></TD>
			  <TD class=Field><%=fee%></TD>
		  </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		  <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></TD>
			  <TD class=Field><%=useaddress%></TD>
		  </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		   <TR>
			  <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
			  <TD class=Field><%=remark%></TD>
		  </TR>
		<TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		</TBODY>
		</TABLE>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr style="height:0px">
	<td height="0" colspan="3"></td>
</tr>
</table>

<script language="javascript">
 function back()
{
	window.history.back(-1);
}
</script>
</BODY></HTML>
