<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellfailureComInfo" class="weaver.crm.sellchance.SellfailureComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(2227,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15113,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

 
<%
String sql="select * from CRM_SelltimeSpan";
RecordSet.executeSql(sql);
RecordSet.next();

int day= RecordSet.getInt("timespan");
int num= RecordSet.getInt("spannum");

Calendar thedate1 = Calendar.getInstance ();//今天的日期


String CurrentDate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
        Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;
//开始日期

String begindate=""; //定义每个区间段的开始日期
String enddate ="";  //定义每个区间段的结束日期

/*先算出从今天开始的销售机会的总金额*/

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

String sql_1="select sum(t1.preyield) moneysum,count(distinct t1.id) totel from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+CurrentDate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid";

//RecordSet.writeLog(sql_1);

RecordSet.executeSql(sql_1);
RecordSet.next();
String moneysum_D= RecordSet.getString("moneysum"); //由于位数太多，显示的时候是科学计数法，所以用String型显示。
int totelsell = RecordSet.getInt("totel");
float moneysum = Util.getFloatValue(moneysum_D);
if(moneysum==-1) moneysum=0;
//out.print(moneysum);
float remainsum=0;
float xxresum=0;
int xxsell=0;
int remainsell =0;


int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());

String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and creater="+resource;
}
if(!customer.equals("")){
	sqlwhere+=" and customerid="+customer;
}
if(!preyield.equals("")){
	sqlwhere+=" and preyield>="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and preyield<="+preyield_1;
}

if(!sellstatusid.equals("")){	
        if(sellstatusid.equals("0")){
        sqlwhere+=" and sellstatusid <> 0";
        }else{
        sqlwhere+=" and sellstatusid="+sellstatusid;
        }
}
if(!endtatusid.equals("")&&!endtatusid.equals("4")){
	sqlwhere+=" and endtatusid ="+endtatusid;
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
<form id=weaver name=frmmain method=post action="SellTimeRpSum.jsp">

<TABLE class=ViewForm>
<COLGROUP>
	<%if (!user.getLogintype().equals("2")) {%>
	<COL width="10%">
    <COL width="20%">
    <COL width="10%">
    <COL width="20%">
	<COL width="10%">
	<COL width="30%">
	<%} else {%>
    <COL width="20%">
    <COL width="30%">
    <COL width="20%">
    <COL width="30%">
	<%}%>
<TBODY>
<TR class=Spacing><TD colspan=9 class=sep2></TD></TR>
<TR>
    <%if (!user.getLogintype().equals("2")) {%>
    <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <TD class=Field><input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
    _displayText="<%=resourcename %>"    
    ></td>
    <%}%>

    <TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%></TD>
    <TD class=Field>
    <select id=sellstatusid
      name=sellstatusid>
      <option value=0 <%if(sellstatusid.equals("")||sellstatusid.equals("0")){%> selected<%}%> ></option>
    <%  
    String theid="";
    String thename="";
    String sql_0="select * from CRM_SellStatus ";
    RecordSetM.executeSql(sql_0);
    while(RecordSetM.next()){
        theid = RecordSetM.getString("id");
        thename = RecordSetM.getString("fullname");
        if(!thename.equals("")){
        %>
    <option value=<%=theid%>  <%if(sellstatusid.equals(theid)){%> selected<%}%> ><%=thename%></option>
    <%}
    }%>
    </TD>

    <TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></TD>
    <TD class=Field ><INPUT text class=InputStyle maxLength=20 size=12 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
     -- <INPUT text class=InputStyle maxLength=20 size=12 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
    </TD>   
</TR><%if (!user.getLogintype().equals("2")) {%><tr style="height:2px" ><td class=Line colspan=6></td></tr><%} else {%><tr><td class=Line colspan=4></td></tr><%}%>
</tbody>
</table>

<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="25%">
  <COL align=left width="35%">
  <COL align=left width="8%">
  <COL align=left width="18%">
  <COL align=left width="14%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(15256,user.getLanguage())%>）</TH>
    <TH><%=SystemEnv.getHtmlLabelName(15257,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15258,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(15259,user.getLanguage())%></TH>    
    <TH>（<%=SystemEnv.getHtmlLabelName(15260,user.getLanguage())%>）%</TH>
    </TR>
<TR class=Line><TD colSpan=5></TD></TR>
<%for(int i=0;i<num ; i++){

thedate1.add(Calendar.DATE, 1) ;
if(i==0){
    begindate= CurrentDate;
}else{
begindate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
        Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;
}

thedate1.add(Calendar.DATE, day-1) ; //增加天数

enddate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
        Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
        Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;

float everysum =0;
int   sellnum =0;
float per =0;
String sql_P="";
if(sqlwhere.equals(""))
    sql_P="select sum(t1.preyield) moneysum,count(distinct t1.id) sellnum from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+begindate+"' and t1.predate <= '"+enddate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid";
else
    sql_P="select sum(t1.preyield) moneysum,count(distinct t1.id) sellnum from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+begindate+"' and t1.predate <= '"+enddate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid " + sqlwhere;

RecordSet.executeSql(sql_P);
RecordSet.next();
if(!((RecordSet.getInt("sellnum"))==0)){
everysum = RecordSet.getFloat("moneysum");
sellnum= RecordSet.getInt("sellnum");

// modified by lupeng 2004-8-23 for TD875.
BigDecimal b1 = new BigDecimal(String.valueOf(everysum));
BigDecimal b2 = new BigDecimal(String.valueOf(moneysum));
b1 = b1.multiply(new BigDecimal("100"));
// modified by XWJ 2005-03-15 for TD875.
if(b2.compareTo(new BigDecimal(0.0f)) != 0){
per = b1.divide(b2, 2, BigDecimal.ROUND_HALF_UP).floatValue();
}
else
{
per = 0;
}
        //per=everysum/moneysum*100;
        //per=(float)((int)(per*1000))/(float)1000;
// end.

}



xxresum += everysum;
xxsell += sellnum;

%>
<TR <%if((i%2)==0){%>class=datalight <%} else {%> class=datadark <%}%>>
<td><%=begindate%>--<%=enddate%></td>
<td height="100%" >
    <%if(!(per==0)){%>
        <TABLE height="100%" cellSpacing=0 
            <%if(per==100){%>
            class=redgraph 
            <%}else{%>
            class=greengraph 
            <%}%>
            width="<%=per%>%">                       
        <TBODY>
        <TR>
          <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
         </TR>
         </TBODY>
         </TABLE>
    <%}%>
</td>
<td>
    <%if(sellnum!=0){%>
    <a href="/CRM/sellchance/SellChanceReport.jsp?fromdate=<%=begindate%>&enddate=<%=enddate%>&viewer=<%=resource%>&customer=<%=customer%>&sellstatusid=<%=sellstatusid%>&preyield=<%=preyield%>&preyield_1=<%=preyield_1%>">
    <%}%><%=sellnum%></td>
<td>
<%

String SS=""+everysum;
if(SS.indexOf("E") != -1){%>
    <%=Util.getfloatToString(""+everysum)%>
<%}else{%>
    <%=everysum%>
<%}%> 
</td>
<td><%=per%>%</td>
</TR>
<%}%>

<%

//remainsum= moneysum - xxresum;
//remainsell = totelsell - xxsell;
thedate1.add(Calendar.DATE, 1) ;
enddate = Util.add0(thedate1.get(Calendar.YEAR), 4) +"-"+
          Util.add0(thedate1.get(Calendar.MONTH) + 1, 2) +"-"+
          Util.add0(thedate1.get(Calendar.DAY_OF_MONTH), 2) ;
float reper =0;


String sql_Q="";
if(sqlwhere.equals(""))
    sql_Q="select sum(t1.preyield) moneysum,count(distinct t1.id) sellnum from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+enddate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid";
else
    sql_Q="select sum(t1.preyield) moneysum,count(distinct t1.id) sellnum from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+enddate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid "+sqlwhere;

RecordSet.executeSql(sql_Q);
RecordSet.next();
remainsum=RecordSet.getFloat("moneysum");
remainsell= RecordSet.getInt("sellnum");
if(remainsell==-1)remainsell=0;
if(remainsum==-1)remainsum=0;

// modified by lupeng 2004-8-23 for TD875.
BigDecimal b1 = new BigDecimal(String.valueOf(remainsum));
BigDecimal b2 = new BigDecimal(String.valueOf(moneysum));
b1 = b1.multiply(new BigDecimal("100"));
// modified by XWJ 2005-03-15 for TD875.
if(b2.compareTo(new BigDecimal(0.0f)) != 0){
reper = b1.divide(b2, 2, BigDecimal.ROUND_HALF_UP).floatValue();
}
else{
reper = 0;
}
        //reper=remainsum/moneysum*100;
		//reper=(float)((int)(reper*1000))/(float)1000;
// end.
%>

<tr class=datadark>
<td><%=enddate%>--</td>
<td height="100%">
    <%if(!(reper==0)){%>
        <TABLE height="100%" cellSpacing=0 
            <%if(reper==100){%>
            class=redgraph 
            <%}else{%>
            class=greengraph 
            <%}%>
            width="<%=reper%>%">                       
        <TBODY>
        <TR>
          <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
         </TR>
         </TBODY>
         </TABLE>
    <%}%>
</td>
<td><%if(remainsell!=0){%><a href="/CRM/sellchance/SellChanceReport.jsp?fromdate=<%=enddate%>&viewer=<%=resource%>&customer=<%=customer%>&sellstatusid=<%=sellstatusid%>&endtatusid=0&preyield=<%=preyield%>&preyield_1=<%=preyield_1%>"><%}%><%=remainsell%></td>
<td>
<%
String DD=""+remainsum;
if(DD.indexOf("E") != -1){%>
    <%=Util.getfloatToString(""+remainsum)%>
<%}else{%>
    <%=remainsum%>
<%}%>    
</td>
<td><%=reper%>%</td>
</tr>

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
        alert("<%=SystemEnv.getHtmlLabelName(15243,user.getLanguage())%>！");
    }
    }
}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
</script>
</HTML>
