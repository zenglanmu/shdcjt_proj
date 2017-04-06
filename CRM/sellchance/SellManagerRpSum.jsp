<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15116,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="projecttype";
int linecolor=0;
float totalproject=0;
float resultpercent=0;


String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String sqlwhere="";

 
if(!fromdate.equals("")){
	sqlwhere+=" and t2.startDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t2.startDate<='"+enddate+"'";
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<form id=weaver name=frmmain method=post action="SellManagerRpSum.jsp">

<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=6 class=sep2></TD></TR>
<tr>
    <td width=15%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td >
</TR><tr style="height:2px"><td class=Line colspan=6></td></tr>
</tbody>
</table>

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="20%">
  
  <COL align=left width="35%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(15255,user.getLanguage())%></TH>
    <!--TH>计数（合同）</TH -->
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colSpan=4></TD></TR>

<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    String sqlstr ="";
    if(sqlwhere.equals("")){
	    sqlstr =  "select  sum(t2.price) price,t1.manager hrmid   from CRM_CustomerInfo t1,CRM_Contract t2,HrmResource t3  ,"+leftjointable+" t4  where  t2.crmId = t4.relateditemid and  t1.id=t2.crmId and t1.manager = t3.id and (t2.status=2 or t2.status =3) group by t1.manager";
    }else{
        sqlstr =  "select  sum(t2.price) price,t1.manager hrmid   from CRM_CustomerInfo t1,CRM_Contract t2,HrmResource t3  ,"+leftjointable+" t4  where  t2.crmId = t4.relateditemid and  t1.id=t2.crmId and t1.manager = t3.id "+sqlwhere+"and t2.status >=2  group by t1.manager";
    }


	RecordSet.executeSql(sqlstr);

	while(RecordSet.next())  { 
		  float resultcount = RecordSet.getFloat(1);
		  totalproject+=resultcount;        
	}
	RecordSet.first();
	if(totalproject!=0){
		do{
		String hrmid = RecordSet.getString(2);
        String d_price = RecordSet.getString(1);

		// modified by lupeng 2004-8-18 for TD880
		String resultcount = Util.null2String(RecordSet.getString(1));
		BigDecimal b1 = new BigDecimal(resultcount);
		BigDecimal b2 = new BigDecimal(String.valueOf(totalproject));
		b1 = b1.multiply(new BigDecimal("100"));
		resultpercent = b1.divide(b2, 2, BigDecimal.ROUND_HALF_UP).floatValue();
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;
		// end.

        String Sql="select count(id) from CRM_CustomerInfo where manager="+hrmid ;
        rs.executeSql(Sql);
        rs.next();
        int crmids = rs.getInt(1);
		
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=hrmid%>">   
    <%=ResourceComInfo.getResourcename(hrmid)%></TD>
    <!--TD><a href="/CRM/report/ContractReport.jsp?viewer=<%=hrmid%>&fromdate=<%=fromdate%>&enddate=<%=enddate%>"><%=crmids%></TD -->
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
        </TABLE>  </TD>
    <TD>
    <%=d_price%></TD>
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
  </form>
  <script type="text/javascript">
    function doSearch(){
       jQuery("#weaver").submit();
    }
  </script>
  <SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
  </HTML>
