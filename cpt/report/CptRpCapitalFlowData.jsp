<%@ page language="java" contentType="text/html; charset=GBK" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList,weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String showString = "";
String datasql = Util.null2String(request.getParameter("datasql"));
int Language=  Util.getIntValue(request.getParameter("Language"),7);
int rowcolorindex = 0;
%>

<table class=ListStyle cellspacing="1">
	<COLGROUP>
	<COL width="11%">
	<COL width="13%">
	<COL width="10%">
	<COL width="10%">
	<COL width="11%">
	<COL width="11%">
	<COL width="11%">
	<COL width="11%">
	<COL width="12%">
	<TR class=Header>
		<TD><%=SystemEnv.getHtmlLabelName(714,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(195,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1394,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1434,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1435,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1436,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1380,Language)%><%=SystemEnv.getHtmlLabelName(602,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(22562,Language)%></TD>
		<TD><%=SystemEnv.getHtmlLabelName(1380,Language)%><%=SystemEnv.getHtmlLabelName(534,Language)%></TD>
	</TR>
<%
double usecountall = 0;
double feeall = 0;
rs.executeSql(datasql);
while(rs.next()){
    String	tempcapitalid=Util.toScreen(rs.getString("capitalid"),Language);
    String	usedate=Util.toScreen(rs.getString("usedate"),Language);
    String	olddeptid=rs.getString("olddeptid");
    String	usedeptid=rs.getString("usedeptid");
    String  useresourceid = rs.getString("useresourceid");
    String  usestatus = rs.getString("usestatus");
    String  usecount = Util.toScreen(rs.getString("usecount"),Language);
    String  useaddress = Util.toScreen(rs.getString("useaddress"),Language);
    String  fee = Util.toScreen(rs.getString("fee"),Language);
    String  mark = rs.getString("mark");
    usecountall += Util.getDoubleValue(usecount,0);
		feeall += Util.getDoubleValue(fee,0);
		
    if(rowcolorindex==0){
        rowcolorindex = 1;
    %>
    <TR class="datalight">
    <%}else if(rowcolorindex==1){
        rowcolorindex = 0;
    %>
    <TR class="datadark">
    <%}
    showString += "<TR><TD>"+mark+"</TD>"+
                  "<TD><A HREF='../capital/CptCapital.jsp?id="+tempcapitalid+"'>"+Util.toScreen(CapitalComInfo.getCapitalname(tempcapitalid),Language)+"</A></TD>"+
                  "<TD>"+usedate+"</TD>"+
                  "<TD>"+Util.toScreen(DepartmentComInfo.getDepartmentname(olddeptid),Language)+"</TD>"+
                  "<TD>"+Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),Language)+"</TD>"+
                  "<TD>"+Util.toScreen(ResourceComInfo.getResourcename(useresourceid),Language)+"</TD>"+
                  "<TD>"+Util.toScreen(CapitalStateComInfo.getCapitalStatename(usestatus),Language)+"</TD>"+
                  "<TD>"+usecount+"</TD>"+
                  "<TD>"+fee+"</TD></TR>";
    %>
    <TD><%=mark%></TD>
    <TD><A HREF="../capital/CptCapital.jsp?id=<%=""+tempcapitalid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(tempcapitalid),Language)%></A></TD>
    <TD><%=usedate%></TD>
    <TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(olddeptid),Language)%> </TD>
    <TD><%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),Language)%> </TD>
    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(useresourceid),Language)%></TD>
    <TD><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(usestatus),Language)%></TD>
    <TD><%=usecount%></TD>
    <TD><%=fee%></TD>
    <TR>
<%
}
%>
	<TR class=datadark>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD></TD>
		<TD><font color=red><%=SystemEnv.getHtmlLabelName(523,Language)%></font></TD>
		<TD><font color=red><%=usecountall%></font></TD>
		<TD><font color=red><%=feeall%></font></TD>
	</TR>
</table>
