<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(580,user.getLanguage());
String needfav ="1";
String needhelp ="";




int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!customer.equals("")){
	sqlwhere+=" and t1.id="+customer;
}
if(!fromdate.equals("")){
	sqlwhere+=" and t1.createdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t1.createdate<='"+enddate+"'";
}

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String optional="creditinfo";
String sqlstr = "";
if(user.getLogintype().equals("1")){
    if(sqlwhere.equals("")){
	sqlstr = "select t2.id  resultid,COUNT(DISTINCT t1.id)  resultcount from CRM_CustomerInfo  t1,CRM_CreditInfo  t2,"+leftjointable+" t3  where  t1.id = t3.relateditemid and  t1.CreditAmount >= t2.creditamount and t1.CreditAmount<= t2.highamount  group by t2.id order by resultid ";
    }else{
    sqlstr = "select t2.id  resultid,COUNT(DISTINCT t1.id)  resultcount from CRM_CustomerInfo  t1,CRM_CreditInfo  t2,"+leftjointable+" t3  where  t1.id= t3.relateditemid and  t1.CreditAmount >= t2.creditamount and t1.CreditAmount<= t2.highamount "+sqlwhere+ "  group by t2.id order by resultid ";
    }

}else{
    if(sqlwhere.equals("")){
	sqlstr = "select  t2.id  resultid,COUNT(DISTINCT t1.id)  resultcount from CRM_CustomerInfo  t1,CRM_CreditInfo  t2 where t1.CreditAmount >= t2.creditamount and t1.CreditAmount<= t2.highamount and t1.agent="+user.getUID() + " group by t2.id order by resultid ";
    }else{
    sqlstr = "select  t2.id  resultid,COUNT(DISTINCT t1.id)  resultcount from CRM_CustomerInfo  t1,CRM_CreditInfo  t2 where t1.CreditAmount >= t2.creditamount and t1.CreditAmount<= t2.highamount and t1.agent="+user.getUID() +sqlwhere+" group by t2.id order by resultid ";
    }

}

int linecolor=0;
int totalcustomer=0;
float resultpercent=0;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

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
  <COL align=left width="35%">
  <COL align=left width="35%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15231,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colSpan=4></TD></TR>
<%  RecordSet.executeSql(sqlstr);
	while(RecordSet.next())  { 
		  int resultcount = RecordSet.getInt(2);
		  totalcustomer+=resultcount;
	}
	RecordSet.first();
	if(totalcustomer!=0){
		do{
		String resultid = RecordSet.getString(1);
		int resultcount = RecordSet.getInt(2);
		resultpercent=(float)resultcount*100/(float)totalcustomer;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;
		
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD>
    
    <%=Util.toScreen(CreditInfoComInfo.getCreditInfoname(resultid),user.getLanguage())%>:<%=Util.toScreen(CreditInfoComInfo.getCreditInfodesc(resultid),user.getLanguage())%>--<%=Util.toScreen(CreditInfoComInfo.getCreditInfohighamount(resultid),user.getLanguage())%></TD>
    <TD height="100%">
        <TABLE height="100%" cellSpacing=0 
        <%if(resultpercent==100){%>
        class=redgraph 
        <%}else{%>
        class=greengraph 
        <%}%>
        width="<%=resultpercentOfwidth%>%">                       
        <TBODY>
        <TR>
        <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
        </TR>
        </TBODY>
        </TABLE> </TD>
    <TD>
    <%if(resultcount!=0){%><a href="/CRM/report/CreditInfoResult.jsp?credit=<%=resultid%>&sqlterm=<%=sqlwhere%>"><%=resultcount%></a>
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
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
  </BODY>
  </HTML>
