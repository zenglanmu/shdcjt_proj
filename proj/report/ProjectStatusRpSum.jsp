<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(587,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="projectstatus";
int linecolor=0;
int totalproject=0;
float resultpercent=0;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
<%@ include file="/systeminfo/RightClickMenu.jsp"%>

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

<TABLE class=viewform width="100%">
  <TBODY>
  <TR class=title>
    <TH><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
  </TR></TBODY></TABLE>
<TABLE class=liststyle cellspacing=1  width="100%">
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
	 <TR class=line ><Th></Th><Th></Th><Th></Th><Th></Th>
    </TR>
<%
	String sqlstr = "select t1.status AS resultid,COUNT(t1.id) AS resultcount from Prj_ProjectInfo  t1,PrjShareDetail  t2 where t1.id=t2.prjid and t2.usertype="+user.getLogintype()+" and t2.userid="+user.getUID()+"  group by t1.status order by resultcount";
	RecordSet.executeSql(sqlstr);

	while(RecordSet.next())  { 
		  int resultcount = RecordSet.getInt(2);
		  totalproject+=resultcount;
	}
	RecordSet.first();
	if(totalproject!=0){
		do{
		String resultid = RecordSet.getString(1);
		int resultcount = RecordSet.getInt(2);
		resultpercent=(float)resultcount*100/(float)totalproject;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
		
		float resultpercentOfwidth=0;
		resultpercentOfwidth = resultpercent;
		if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;
		
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD>
    <%if(resultid.equals("0")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
    <%=Util.toScreen(SystemEnv.getHtmlLabelName(Util.getIntValue(ProjectStatusComInfo.getProjectStatusname(resultid)),user.getLanguage()),user.getLanguage())%><%}%></TD>
    <TD>
      <TABLE height="100%" cellSpacing=0 width="100%">
        <TBODY>
        <TR>
          <TD class=redgraph width="<%=resultpercentOfwidth%>%">&nbsp;</TD>
          <TD>&nbsp;</TD></TR></TBODY></TABLE></TD>
    <TD>
    <%if(resultcount!=0){%><a href="/proj/search/SearchOperation.jsp?msg=report&settype=projectstatus&id=<%=resultid%>"><%=resultcount%></a>
    <%} else {%><%=resultcount%><%}%></TD>
    <TD><%=resultpercent%>%</TD>
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
