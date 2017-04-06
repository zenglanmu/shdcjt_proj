<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15115,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="projecttype";
int linecolor=0;
float total=0;
float resultpercent=0;

 
int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String sqlwhere="";
String sqlwhere_0="";

if(resource!=0){
	sqlwhere =" and t2.manager="+resource;
}
if(!fromdate.equals("")){	
    sqlwhere +=" and t2.startDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
    sqlwhere +=" and t2.startDate<='"+enddate+"'";
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
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

<form id=weaver name=frmmain method=post action="SellProductRpSum.jsp">

<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=6 class=sep2></TD></TR>
<tr>
    <%if(!user.getLogintype().equals("2")){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <td class=field ><input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
    _displayText="<%=resourcename%>"
    ></td>
    <%}%>

    <td width=15%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    гн<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td >
</TR><tr  style="height:2px"><td class=Line colspan=6></td></tr>
</tbody>
</table>

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="20%">
  <COL align=left width="10%">
  <COL align=left width="10%">
  <COL align=left width="20%">
  <COL align=left width="30%">
  <COL align=left width="10%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colSpan=6></TD></TR>
<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    String sqlstr ="";
    if(sqlwhere.equals("")){
	    sqlstr ="select t1.productId  productId,sum(t1.number_n) amount, sum(t1.sumPrice) sumprice from CRM_ContractProduct t1,  CRM_Contract t2 ,"+leftjointable+" t3 where t2.crmId = t3.relateditemid and  t1.contractId = t2.id and (t2.status=2 or t2.status =3) group by productId order by sumprice";
    }else{
        sqlstr = "select t1.productId  productId,sum(t1.number_n) amount, sum(t1.sumPrice) sumprice from CRM_ContractProduct t1,  CRM_Contract t2 ,"+leftjointable+" t3 where t2.crmId = t3.relateditemid and  t1.contractId = t2.id and (t2.status=2 or t2.status =3) "+sqlwhere+" group by productId order by sumprice";
    }
	RecordSet.executeSql(sqlstr);

	while(RecordSet.next())  { 
		  float resultcount = RecordSet.getFloat("sumprice");
		  total+=resultcount;       
	}
    
	RecordSet.first();
	if(total!=0){
		do{
		String productid = RecordSet.getString("productId");
        String sql_A= "select assetunitid from LgcAsset where id = "+ productid;
        rs.executeSql(sql_A);
        rs.next();
        String assetunitid = rs.getString("assetunitid");
		int amount = RecordSet.getInt("amount");

		// modified by lupeng 2004-8-18 for TD880
		String resultcount = Util.null2String(RecordSet.getString("sumprice"));
		BigDecimal b1 = new BigDecimal(resultcount);
		BigDecimal b2 = new BigDecimal(String.valueOf(total));
		b1 = b1.multiply(new BigDecimal("100"));
		resultpercent = b1.divide(b2, 2, BigDecimal.ROUND_HALF_UP).floatValue();
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;
		// end.
		
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><A href="/lgc/asset/LgcAsset.jsp?paraid=<%=productid%>" >    
    <%=Util.toScreen(AssetComInfo.getAssetName(productid),user.getLanguage())%></TD>
    <TD>    
    <%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></TD> 
    <TD><%=amount%></TD>  
    <TD><%=resultcount%></TD>
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
        </TABLE></TD>

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
	<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
  <script language=vbs>  
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	viewerspan.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.viewer.value=id(0)
	else 
	viewerspan.innerHtml = ""
	frmmain.viewer.value=""
	end if
	end if
end sub

</script>
  </HTML>
