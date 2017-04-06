<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellsuccessComInfo" class="weaver.crm.sellchance.SellsuccessComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(2227,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15103,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
String optional="projecttype";
int linecolor=0;
int total=0;
float resultpercent=0;

int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());

String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and t1.creater="+resource;
}
if(!fromdate.equals("")){
	sqlwhere+=" and t1.predate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and t1.predate<='"+enddate+"'";
}
if(!customer.equals("")){
	sqlwhere+=" and t1.customerid="+customer;
}
if(!preyield.equals("")){
	sqlwhere+=" and t1.preyield>="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and t1.preyield<="+preyield_1;
}

if(!sellstatusid.equals("")){	
        if(sellstatusid.equals("0")){
        sqlwhere+=" and t1.sellstatusid <> 0";
        }else{
        sqlwhere+=" and t1.sellstatusid="+sellstatusid;
        }
}
if(!endtatusid.equals("")&&!endtatusid.equals("4")){
	sqlwhere+=" and t1.endtatusid ="+endtatusid;
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
<form id=weaver name=frmmain method=post action="SuccessRpSum.jsp">

<table class=ViewForm>
<tbody>
<TR class=Spacing><TD colspan=9 class=sep2></TD></TR>
<tr>
    <%if(!user.getLogintype().equals("2")){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <td class=field width=20% >
    <input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
    _displayText="<%=resourcename%>"
    ></td>
    <%}%>

    <td width=15%><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></td>
    <td class=field width=30%>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>

    <!--TD >销售状态 </TD>
    <TD class=Field>
    <select text class=InputStyle id=sellstatusid style="width:60px"
      name=sellstatusid>
      <option value=0 <%if(sellstatusid.equals("")||sellstatusid.equals("0")){%> selected<%}%> ></option>
    <%  
    String theid="";
    String thename="";
    String sql="select * from CRM_SellStatus ";
    RecordSetM.executeSql(sql);
    while(RecordSetM.next()){
        theid = RecordSetM.getString("id");
        thename = RecordSetM.getString("fullname");
        if(!thename.equals("")){
        %>
    <option value=<%=theid%>  <%if(sellstatusid.equals(theid)){%> selected<%}%> ><%=thename%></option>
    <%}
    }%>
    </TD>

    
    </TR>
<tr>
    <TD width=10%>客户</TD>
    <TD class=Field><BUTTON class=Browser onClick="onShowCustomerID()"></BUTTON> <span 
    id=customerspan><a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customer%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%></a></span> 
    <INPUT text class=InputStyle type=hidden name="customer" value="<%=customer%>"></TD>

    <TD>预期收益  </TD>
    <TD class=Field ><INPUT text class=InputStyle maxLength=20 size=12 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
     -- <INPUT text class=InputStyle maxLength=20 size=12 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
    </TD>

    <TD>归档状态</TD>
    <TD class=Field>
    <select text class=InputStyle id=endtatusid  name=endtatusid style="width:60px" >
    <option value=4 <%if(endtatusid.equals("4")){%> selected <%}%> > 所 有 </option>
    <option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > 成 功 </option>
    <option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > 失 败 </option>
    <option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > 进行中 </option>
    </TD -->
</TR><tr style="height:2px"><td class=Line colspan=9></td></tr>
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
    <TH><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colSpan=4></TD></TR>
<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

    String sqlstr="";
    if(sqlwhere.equals("")){
    	sqlstr =  "select t1.sufactor AS resultid,COUNT(distinct t1.id) AS resultcount from CRM_SellChance  t1,CRM_Successfactor  t2 ,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.sufactor=t2.id  and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid group by t1.sufactor order by resultcount";
    }
    else 
        sqlstr =  "select t1.sufactor AS resultid,COUNT(distinct t1.id) AS resultcount from CRM_SellChance  t1,CRM_Successfactor  t2 ,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.sufactor=t2.id  and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid "+sqlwhere+" group by t1.sufactor order by resultcount";

	RecordSet.executeSql(sqlstr);

	while(RecordSet.next())  { 
		  int resultcount = RecordSet.getInt(2);
		  total+=resultcount;
	}
	RecordSet.first();
	if(total!=0){
		do{
		String resultid = RecordSet.getString(1);
		int resultcount = RecordSet.getInt(2);
		resultpercent=(float)resultcount*100/(float)total;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD>
    <%if(resultid.equals("0")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
    <%=Util.toScreen(SellsuccessComInfo.getSuStatusname(resultid),user.getLanguage())%><%}%></TD>
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
    <TD>
    <a href="/CRM/sellchance/SellChanceReport.jsp?sufactor=<%=resultid%>&fromdate=<%=fromdate%>&enddate=<%=enddate%>&viewer=<%=resource%>&customer=<%=customer%>&sellstatusid=<%=sellstatusid%>&endtatusid=<%=endtatusid%>&preyield=<%=preyield%>&preyield_1=<%=preyield_1%>"><%=resultcount%></TD>
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
