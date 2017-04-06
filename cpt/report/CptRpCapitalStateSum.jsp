<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String CurrentUser = ""+user.getUID();
/*if(!user.getLogintype().equals("1")){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}*/
if(!HrmUserVarify.checkUserRight("CptRpCapital:Display", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(602,user.getLanguage());
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));//·Ö²¿ID

if(subcompanyid1.equals("") && detachable==1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
String sqlstr = "";
if(detachable == 0){
	 sqlstr = "select stateid AS resultid,COUNT(distinct id) AS resultcount from CptCapital  t1,CptShareDetail  t2 where t1.isdata='2'   and t1.id = t2.cptid and t2.userid="+ CurrentUser +" group by stateid order by resultid";
}else{
	 sqlstr = "select stateid AS resultid,COUNT(distinct id) AS resultcount from CptCapital  t1,CptShareDetail  t2 where t1.blongsubcompany = "+subcompanyid1+" and t1.isdata='2'   and t1.id = t2.cptid and t2.userid="+ CurrentUser +" group by stateid order by resultid";
}

int linecolor=0;
int totalcapital=0;
float resultpercent=0;
float basepercent=0;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

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
		<TABLE class=ListStyle width="100%" cellspacing="1">
			  <COLGROUP>
			  <COL align=left width="30%">
			  <COL align=left width="40%">
			  <COL align=left width="15%">
			  <COL align=left width="15%">
			  <TBODY>
			  <TR class=Header>
			  <TH colspan="4"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
			  </TR>
			  <TR class=Header>
				<TH><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>
				<TH><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></TH>
				<TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
				<TH>%</TH>
				</TR>
				<TR class=Line ><TD colspan="4"></TD></TR>
	
	<%  
		int max = 0;
		RecordSet.executeSql(sqlstr);
		//out.println(sqlstr);
		while(RecordSet.next())  { 
			  int resultcount = RecordSet.getInt(2);
			  if(resultcount>max) max=resultcount;
			  totalcapital+=resultcount;
		}
		RecordSet.first();
		if(totalcapital!=0){
			do{
			String resultid = RecordSet.getString(1);
			int resultcount = RecordSet.getInt(2);
			resultpercent=(float)resultcount*100/(float)max;
			resultpercent=(float)((int)(resultpercent*100))/(float)100;
			basepercent=(float)resultcount*100/(float)totalcapital;
			basepercent=(float)((int)(basepercent*100))/(float)100;
		%>
	  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
		<TD><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(resultid),user.getLanguage())%></TD>
		<TD>
		  <TABLE height="100%" cellSpacing=0 width="100%">
			<TBODY>
			<TR>
			  <TD class=redgraph <%if(resultpercent<1){%>width="1%"<%} else {%>
			  width="<%=resultpercent%>%"<%}%>>&nbsp;</TD>
			  <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
		<TD><a href="../search/SearchOperation.jsp?isdata=2&stateid=<%=resultid %>&blongsubcompany=<%=subcompanyid1%>"><%=resultcount%></a>
		</TD>
		<TD><%=basepercent%>%</TD>
		</TR>
		<%		if(linecolor==0) linecolor=1;
				else	linecolor=0;
				}while(RecordSet.next());
		} %>
	  </TBODY></TABLE>
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
