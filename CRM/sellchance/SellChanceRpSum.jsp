<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(2227,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15112,user.getLanguage());
String needfav ="1";
String needhelp ="";

String usertype = user.getLogintype();
int userid = user.getUID();
char flag=2;

String optional="projecttype";
int linecolor=0;
int totalproject=0;
float resultpercent=0;
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
<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15252,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colSpan=4></TD></TR>
<%
	int result = 0;
	String jointable = CrmShareBase.getTempTable(""+userid);
	String sql = "select count(distinct t1.id) as result from CRM_SellChance t1,"+jointable+" t2,CRM_CustomerInfo t3 where  t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
	RecordSet.executeSql(sql);
	if(RecordSet.next()) result = Util.getIntValue(RecordSet.getString("result"),0);
	
	if(result>0){
    int sucess = 0;
    int failure =  0;
    int nothing =  0;
    
		sql = "select count(distinct t1.id) as sucess from CRM_SellChance t1,"+jointable+" t2,CRM_CustomerInfo t3 where   t1.endtatusid ='1' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
		RecordSet.executeSql(sql);
		if(RecordSet.next()) sucess = Util.getIntValue(RecordSet.getString("sucess"),0);
    
		sql = "select count(distinct t1.id) as failure  from CRM_SellChance t1,"+jointable+" t2,CRM_CustomerInfo t3 where   t1.endtatusid ='2' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
		RecordSet.executeSql(sql);
		if(RecordSet.next()) failure = Util.getIntValue(RecordSet.getString("failure"),0);
    
		sql = "select count(distinct t1.id) as nothing  from CRM_SellChance t1,"+jointable+" t2,CRM_CustomerInfo t3 where   t1.endtatusid ='0' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid";
		RecordSet.executeSql(sql);
		if(RecordSet.next()) nothing = Util.getIntValue(RecordSet.getString("nothing"),0);

    float resultcount_0 = (float)nothing*100/(float)result; //Î´¹éµµ
    float resultcount_1 = (float)sucess*100/(float)result; //³É¹¦
    float resultcount_2 = (float)failure*100/(float)result; //Ê§°Ü
    resultcount_0=(float)((int)(resultcount_0*100))/(float)100;
    resultcount_1=(float)((int)(resultcount_1*100))/(float)100;
    resultcount_2=(float)((int)(resultcount_2*100))/(float)100;
	
%>

<TR CLASS=DataDark>
    <td>
    <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%>
    </td>
    <TD height=100%>
	<%if(!(resultcount_0==0)){%>
		<TABLE height="100%" cellSpacing=0 
		<%if(resultcount_0==100){%>
		class=redgraph 
		<%}else{%>
		class=greengraph 
		<%}%>
		width="<%=resultcount_0%>%">                       
		<TBODY>
		<TR>
		<TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
		</TR>
		</TBODY>
		</TABLE>
	<%}%>
    </TD>
    <td><%if(!(resultcount_0==0)){%><a href="/CRM/sellchance/SellChanceReport.jsp?endtatusid=0"><%}%> <%=nothing%></td>
    <td> <%=resultcount_0%>%</td>
</TR>
<TR CLASS=DataDark>
    <td>
    <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>
    </td>
    <TD height=100%>
	<%if(!(resultcount_1==0)){%>
		<TABLE height="100%" cellSpacing=0 
		<%if(resultcount_1==100){%>
		class=redgraph 
		<%}else{%>
		class=greengraph 
		<%}%>
		width="<%=resultcount_1%>%">                       
		<TBODY>
		<TR>
		<TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
		</TR>
		</TBODY>
		</TABLE>
	<%}%>
    </TD>
    <td> <%if(!(resultcount_1==0)){%><a href="/CRM/sellchance/SellChanceReport.jsp?endtatusid=1"><%}%><%=sucess%></td>
    <td> <%=resultcount_1%>%</td>
</TR>
<TR CLASS=DataDark>
    <td>
    <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%>
    </td>
    <TD height=100%>
	<%if(!(resultcount_2==0)){%>
		<TABLE height="100%" cellSpacing=0 
		<%if(resultcount_2==100){%>
		class=redgraph 
		<%}else{%>
		class=greengraph 
		<%}%>
		width="<%=resultcount_2%>%">                       
		<TBODY>
		<TR>
		<TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
		</TR>
		</TBODY>
		</TABLE>
	<%}%>
    </TD>
    <td> <%if(!(resultcount_2==0)){%><a href="/CRM/sellchance/SellChanceReport.jsp?endtatusid=2"><%}%><%=failure%></td>
    <td> <%=resultcount_2%>%</td>
</TR>
<%}%>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>    
</BODY></HTML>
