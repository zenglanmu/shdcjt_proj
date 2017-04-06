<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
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
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String typeId=Util.fromScreen(request.getParameter("typeId"),user.getLanguage());
 
String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!fromdate.equals("")){
	sqlwhere+=" and t2.startDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t2.startDate<='"+enddate+"'";
}

if(!preyield.equals("")){
	sqlwhere+=" and t2.price >="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and t2.price <="+preyield_1;
}
if(!(typeId.equals("")||typeId.equals("0"))){
	sqlwhere+=" and t2.typeId ="+typeId;
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
<form id=weaver name=frmmain method=post action="SellClientRpSum.jsp">

<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=9 class=sep2></TD></TR>
<tr>
    <%if(!user.getLogintype().equals("2")){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <td class=field >
<input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
    _displayText="<%=resourcename%>"
    >
    </td>
    <%}%>

    <td width=10%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    £­<BUTTON class=calendar type="button" id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
<tr>
	<TD><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></TD>
	<TD class=Field>
	<select text class=InputStyle id=typeId 
	name=typeId>
	<option value=0 <%if(typeId.equals("")||typeId.equals("0")){%> selected<%}%> ></option>
	<% 
	while(ContractTypeComInfo.next()){ %>
	<option value=<%=ContractTypeComInfo.getContractTypeid()%>  <%if(typeId.equals(ContractTypeComInfo.getContractTypeid())){%> selected <%}%>><%=ContractTypeComInfo.getContractTypename()%></option>
	<%}%>
	</select>
	</TD>
	<TD width=10%><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>  </TD>
	<TD class=Field ><INPUT text class=InputStyle maxLength=20 size=12 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
	-- <INPUT text class=InputStyle maxLength=20 size=12 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
	</TD>    
    </TR>
</tbody>
</table>

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="15%">
  <COL align=left width="15%">
  <COL align=left width="25%">
  <COL align=left width="30%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15253,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>   
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colSpan=5></TD></TR>
<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    String sqlstr="";
    if(sqlwhere.equals("")){
    	sqlstr = "select t1.id id,sum(t2.price)  resultcount,count(distinct t2.id) conids from CRM_CustomerInfo  t1,CRM_Contract  t2 ,"+leftjointable+" t3  where  t2.crmId = t3.relateditemid and  t1.id=t2.crmId and t2.status >=2 group by t1.id order by id";
    }
    else 
        sqlstr = "select t1.id id,sum(t2.price)  resultcount,count(distinct t2.id) conids from CRM_CustomerInfo  t1,CRM_Contract  t2 ,"+leftjointable+" t3  where  t2.crmId = t3.relateditemid and  t1.id=t2.crmId and t2.status >=2 "+sqlwhere+" group by t1.id order by id";
	RecordSet.executeSql(sqlstr);

	while(RecordSet.next())  { 
		  float resultcount = RecordSet.getFloat(2);
		  total+=resultcount;
	}
	RecordSet.first();
	if(total!=0){
		do{
		String crmid = RecordSet.getString(1);
        String D_resultcount =RecordSet.getString(2);
        int contractid = RecordSet.getInt(3);		

		// modified by lupeng 2004-8-18 for TD880
		String resultcount = Util.null2String(RecordSet.getString(2));
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
    <TD><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>">     
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></TD>
    <TD><a href="/CRM/report/ContractReport.jsp?customer=<%=crmid%>&sign=30"><%=contractid%></TD>
    <TD><%=D_resultcount%></TD>
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
        </TABLE>    
    </TD>
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
  </BODY></form>
<script type="text/javascript">
  function doSearch(){
    jQuery("#weaver").submit();
  }
</script>  
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
sub onShowCustomerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	frmmain.customer.value=id(0)
	else 
	customerspan.innerHtml = ""
	frmmain.customer.value=""
	end if
	end if
end sub
</script>
<SCRIPT language="javascript">

function comparenumber(){
    if((document.frmmain.preyield.value != "")&&(document.frmmain.preyield_1.value != "")) {
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
    if(lownumber > highnumber){
        alert("<%=SystemEnv.getHtmlLabelName(15254,user.getLanguage())%>£¡");
    }
    }
}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
</script>
</HTML>
