<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(581,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="tradeinfo";


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

String sqlstr = "";
int total=0;

if(sqlwhere.equals("")){    
    sqlstr="select sum(t2.price) money ,t1.id customerid,count(distinct t2.id) resultcount  from CRM_CustomerInfo t1,CRM_Contract t2 ,"+leftjointable+" t3  where  t1.id = t3.relateditemid and  t1.id=t2.crmId group by t1.id ";
}else{
    sqlstr="select sum(t2.price) money ,t1.id customerid,count(distinct t2.id) resultcount  from CRM_CustomerInfo t1,CRM_Contract t2 ,"+leftjointable+" t3  where  t1.id = t3.relateditemid and  t1.id=t2.crmId "+sqlwhere+ " group by t1.id ";
}

ArrayList contract_sum=new ArrayList();
ArrayList crmid=new ArrayList();

RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
    contract_sum.add(RecordSet.getString("money"));
	crmid.add(RecordSet.getString("customerid"));
    total++;
}

sqlstr="select * from  CRM_TradeInfo ";

int linecolor=0;
int totalcustomer=0;
float resultpercent=0;
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

<form id=weaver name=frmmain method=post action="TradeInfoRpSum.jsp">
<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=6 class=sep2></TD></TR>
<tr>
    <%if(!user.getLogintype().equals("2")){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
    <td class=field >
    <input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
    _displayText="<%=resourcename%>"
    >
</td>
    <%}%>

    <!--TD width=10%>?</TD>
    <TD class=Field><BUTTON class=Browser onClick="onShowCustomerID()"></BUTTON> <span 
    id=customerspan><a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customer%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%></a></span> 
    <INPUT class=InputStyle type=hidden name="customer" value="<%=customer%>"></TD -->

    <td width=15%><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td>
    <td class=field >
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>> ---
    <BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</TR><tr style="height: 1px;"><td class=Line colspan=6></td></tr>
</tbody>
</table>

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15231,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line style="height: 1px;"><TD colSpan=4></TD></TR>
<%  RecordSet.executeSql(sqlstr);
	RecordSet.first();
	if(total!=0){
		do{
        String resultid = RecordSet.getString(1);
        String fullname =  RecordSet.getString(2);

        //modify by dongping for TD874
        String rangelower=  RecordSet.getString(3);
        if (rangelower.indexOf(",")>0&&rangelower.length()>=2) 
            rangelower = rangelower.substring(0,rangelower.length()-2);
        String rangeupper= RecordSet.getString(4);
        if (rangeupper.indexOf(",")>0&&rangeupper.length()>=2) 
            rangeupper = rangeupper.substring(0,rangeupper.length()-2); 

        float rangelower_0=  RecordSet.getFloat(3);
        float rangeupper_0= RecordSet.getFloat(4);
        int resultcount=0;
        String crmid_every="";
        for (int j=0 ; j<contract_sum.size();j++){
            float temp_sum = Util.getFloatValue((String)contract_sum.get(j));
            if(temp_sum >=rangelower_0 && temp_sum<=rangeupper_0 ){
                resultcount++;
                crmid_every +=","+ (String)crmid.get(j);                 
            }
            
        }
        if(!crmid_every.equals("")) crmid_every = crmid_every.substring(1);
		
		resultpercent=(float)resultcount*100/(float)total;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;
		
	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><b> <%=fullname%>:</b><%=rangelower%> -- <%=rangeupper%> </TD>
    <TD height="100%">
        <%if(!(resultpercent==0)){%>
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
        <%}%></TD>
    <!--TD>
    <%if(resultcount!=0){%><a href="/CRM/search/SearchOperation.jsp?msg=report&settype=tradeinfo&id=<%=resultid%>"><%=resultcount%></a>
    <%} else {%><%=resultcount%><%}%></TD -->
     <TD><%=resultcount%></TD>
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
</script></HTML>
