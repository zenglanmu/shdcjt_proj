<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="ContractComInfo" class="weaver.crm.Maint.ContractComInfo" scope="page"/>
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(15117,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xwj on 2005-03-25 for TD 1554
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
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
<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());

String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String product=Util.fromScreen(request.getParameter("product"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String province=Util.fromScreen(request.getParameter("province"),user.getLanguage());
String city=Util.fromScreen(request.getParameter("city"),user.getLanguage());
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);
String parentid=Util.fromScreen(request.getParameter("parentid"),user.getLanguage());


//out.print(customer);
String sqlwhere="";
String sqlstr ="";
String currentvalue = "";
if(!parentid.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t4.parentid="+parentid;
	else	sqlwhere+=" and t4.parentid="+parentid;
}
if(resource!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.manager="+resource;
	else	sqlwhere+=" and t1.manager="+resource;
}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.payDate>='"+fromdate+"'";
	else 	sqlwhere+=" and t3.payDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.payDate<='"+enddate+"'";
	else 	sqlwhere+=" and t3.payDate<='"+enddate+"'";
}

if(!customer.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.crmId="+customer;
	else	sqlwhere+=" and t1.crmId="+customer;
}

if(!preyield.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.payPrice>="+preyield;
	else	sqlwhere+=" and t3.payPrice>="+preyield;
}
if(!preyield_1.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.payPrice<="+preyield_1;
	else	sqlwhere+=" and t3.payPrice<="+preyield_1;
}

if(!department.equals("")) {
	if(sqlwhere.equals("")) sqlwhere+=" where t4.department="+department;
    else sqlwhere+=" and t4.department="+department;
}

if(!province.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t4.province="+province;
	else	sqlwhere+=" and t4.province="+province;
}
if(!city.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t4.city="+city;
	else	sqlwhere+=" and t4.city="+city;
}


String temptable = "ContractFnaTempTable"+ Util.getRandom() ;

if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}

String orderStr = "";
String orderStr1 = "";
if (ViewType == 0 ) {orderStr = "  order by t3.id desc "; orderStr1 = "  order by id asc ";}
if (ViewType == 1 ) {orderStr = "  order by t1.manager asc "; orderStr1 = "  order by manager desc "; }


//add by xwj for TD 1554 on 2005-03-25
session.setAttribute("sqlwhere",sqlwhere);
session.setAttribute("orderStr",orderStr);
session.setAttribute("orderStr1",orderStr1);

//t4.deleted = 1  or  t4.deleted = 0

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
        sqlstr = "create table "+temptable+"  as select * from (select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid  and t1.crmId = t4.id and t3.contractId = t1.id " + orderStr + " ) where rownum<"+ (pagenum*perpage+2);

	}else{
        sqlstr = "create table "+temptable+"  as select * from (select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr + " ) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
        sqlstr = "create table "+temptable+"  as (select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,ContractShareDetail  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4 ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (select t3.* , t1.name , t1.crmId,t1.manager from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid  and t1.crmId = t4.id and t3.contractId = t1.id " +orderStr + "  fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
        sqlstr = "create table "+temptable+"  as (select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4 ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" (select t3.*  , t1.name , t1.crmId,t1.manager from CRM_Contract  t1 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4   "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr + "  fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
        sqlstr = "select top "+(pagenum*perpage+1)+" t3.*  , t1.name , t1.crmId,t1.manager into "+temptable+" from CRM_Contract  t1,(select contractid,max(sharelevel) as sharelevel from ContractShareDetail where  userid="+user.getUID()+" and usertype=1  group by contractid )  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid  and t1.crmId = t4.id and t3.contractId = t1.id "+ orderStr ;
                                                                                                                                        
	}else{
        sqlstr = "select top "+(pagenum*perpage+1)+" t3.* , t1.name , t1.crmId,t1.manager into "+temptable+" from CRM_Contract t1 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.crmId = t4.id and t3.contractId = t1.id and t1.crmId="+user.getUID() + orderStr ;
	}
}



RecordSet.executeSql(sqlstr);

RecordSet.executeSql("Select count(id) RecordSetCounts from "+temptable);
boolean hasNextPage=false;
int RecordSetCounts = 0;
if(RecordSet.next()){
	RecordSetCounts = RecordSet.getInt("RecordSetCounts");
}
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
	String sqltemp="";
if(RecordSet.getDBType().equals("oracle")){
	sqltemp="select * from (select * from  "+temptable+orderStr1+" ) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1) ;	
}else if(RecordSet.getDBType().equals("db2")){
	sqltemp="select * from  "+temptable+orderStr1+" fetch first  "+(RecordSetCounts-(pagenum-1)*perpage+1)+"  rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+orderStr1;
}
RecordSet.executeSql(sqltemp);

%>
<form id=weaver name=frmmain method=post action="ContractFnaReport.jsp">
 <input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">

<table class=ViewForm>


  <tbody>
<TR style="height:2px"><TD class=Line1 colSpan=6></TD></TR>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td ><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
  <td class=field>
  <input  class=wuiBrowser type=hidden name=viewer value="<%=resource%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
    _displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
    _displayText="<%=resourcename%>"
    ></td>
  <%}%>

    <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
    <TD class=Field><INPUT class=InputStyle maxLength=50 size=6 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")' value="<%=preyield%>">
     -- <INPUT class=InputStyle maxLength=50 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1")' value="<%=preyield_1%>">
    </TD>

	<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
	<TD class=Field>
	<input class=wuiBrowser id=department type=hidden name=department value="<%=department%>" 
	_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	_displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>"
	>
	</TD>
  <TR style="height:2px"><TD class=Line1 colSpan=6></TD></TR>

  <tr>  
    <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
    <TD class=Field>
    <INPUT  class=wuiBrowser type=hidden id="customer" name="customer" value="<%=customer%>"
	    _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
	    _displayTemplate="<a target='_blank' href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=#b{id}'>#b{name}</a>"
	    _displayText="<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%>"
    >
    </TD>

    <td><%=SystemEnv.getHtmlLabelName(15135,user.getLanguage())%></td>
    <td class=field>
    <BUTTON  type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    £­<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>

	<TD> <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
  <TD class=Field>
  <INPUT class=wuiBrowser  id=province type=hidden name="province" value="<%=province%>"
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp"
  _displayText="<%=ProvinceComInfo.getProvincename(province)%>">  
  </TD>
  <TR style="height:2px"><TD class=Line1 colSpan=6></TD></TR>

  <TR>
  <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
  <TD class=Field>  
  <INPUT class=wuiBrowser id=city type=hidden name="city" value="<%=city%>"
  _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
  _displayText="<%=CityComInfo.getCityname(city)%>">  
  </TD>  <TD><%=SystemEnv.getHtmlLabelName(455,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></TD>
  <TD class=Field>
  <select  class=InputStyle size="1" name="ViewType">
			<option value="0" <%if (ViewType==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></option>
			<option value="1" <%if (ViewType==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
			</select>
  </TD>
  <TD> <%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
  <TD class=Field>
    <INPUT class=wuiBrowser type=hidden id="parentid" name="parentid" value="<%=parentid%>"
    _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
    _displayTemplate="<a target='_blank' href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=#b{id}'>#b{name}</a>"
    _displayText="<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(parentid),user.getLanguage())%>"
    >
  </TD>
  <TR style="height:2px"><TD class=Line1 colSpan=6></TD></TR> 

<%//added by xwj for td 1554 on 2005-03-27 ºÏ¼Æ    t4.deleted = 1  or  t4.deleted = 0
String temptable1 = "ContractFnaTempTable"+ Util.getRandom() ;
if(RecordSet.getDBType().equals("oracle")){
RecordSet_count.executeSql("  create table "+temptable1+" as select distinct  t3.* , t1.name , t1.crmId,t1.manager,t4.name CustomerName  from CRM_Contract  t1,ContractShareDetail  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid  and t1.crmId = t4.id   and t3.contractId = t1.id and t2.usertype=1  and t2.userid="+user.getUID()+" "+orderStr);
}
else
{
RecordSet_count.executeSql("select distinct  t3.* , t1.name , t1.crmId,t1.manager,t4.name CustomerName into "+temptable1+" from CRM_Contract  t1,ContractShareDetail  t2 , CRM_ContractPayMethod t3,CRM_CustomerInfo  t4  "+ sqlwhere +"  and t1.id = t2.contractid  and t1.crmId = t4.id   and t3.contractId = t1.id and t2.usertype=1  and t2.userid="+user.getUID()+" "+orderStr);
}
RecordSet_count.executeSql("Select sum(payPrice),sum(factPrice),sum(payPrice)-sum(factPrice)  from "+temptable1+" where typeid='1'");
String sum_get="0";
String sum_getfact="0";
String sum_getfuture="0";
if (RecordSet_count.next()){
sum_get=RecordSet_count.getString(1);
sum_getfact=RecordSet_count.getString(2);
sum_getfuture=RecordSet_count.getString(3);
}
RecordSet_count.executeSql("Select sum(payPrice),sum(factPrice),sum(payPrice)-sum(factPrice)  from "+temptable1+" where typeid='2'");
String sum_pay="0";
String sum_payfact="0";
String sum_payfuture="0";
if (RecordSet_count.next()){
sum_pay=RecordSet_count.getString(1);
sum_payfact=RecordSet_count.getString(2);
sum_payfuture=RecordSet_count.getString(3);
}
%>

</tbody>
</table>
<table class=ListStyle cellspacing=1>
    <COLGROUP>
    <COL width="10%">
    <COL width="10%">
    <COL width="10%">
    <COL width="10%">
    <COL width="10%">
    <COL width="10%">
    <COL width="10%">
    <COL width="10%">
	<COL width="10%">
    <COL width="10%">
    
    <%--added by xwj for td1554 on 2005-03-25--%>
<tr class=header>
        <th><b><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%>:</b></th>
        <th></th>
        <th><%=sum_get%></th>
		<th><%=sum_getfact%></th>
		<th><%=sum_getfuture%></th>
		<th><%=sum_pay%></th>
		<th><%=sum_payfact%></th>
		<th><%=sum_payfuture%></th>
		<th></th>
        <th></th>
  </tr>
  
    <TR class=Header>
		<th><%=SystemEnv.getHtmlLabelName(6161,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(15132,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(15137,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(15224,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(15225,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(15138,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(15226,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(15227,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(15135,user.getLanguage())%></th>
        <th><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></th>
    </TR>
<TR class=Line><TD colSpan=10></TD></TR>
<%
boolean islight=false;
int totalline=1;
if(RecordSet.last()){
	do{
	String id=RecordSet.getString("id");
	switch(ViewType)
	{
	case 1: if (!currentvalue.equals(RecordSet.getString("manager"))) {%>
			<tr class=datadark><td colspan = 10>
			<span id = viewtypename class ="fontred">
			<%=ResourceComInfo.getResourcename(RecordSet.getString("manager"))%>
			</span></td>
			</tr><%} break;
	default: %><% break;
	}

	if (!islight && (ViewType==0))
	{%>
	<tr class=datadark>	
	<%} else {%>
	<tr class=DataLight>	
	<% }%>
	<TD>
   <a href="/CRM/data/ContractView.jsp?CustomerID=<%=RecordSet.getString("crmId")%>&id=<%=RecordSet.getString("contractId")%>"><%=RecordSet.getString("name")%></a>
    </TD> 
          </TD>
	<TD><%=RecordSet.getString("prjName")%></TD>
	<td>
	<%if (RecordSet.getInt("typeId")==1) {%>
	<%=Util.getPointValue(RecordSet.getString("payPrice"))%>
	<%} else {%>
	-
	<%}%>
	</td>
	<td>
	<%if (RecordSet.getInt("typeId")==1) {%>
	<%=Util.getPointValue(RecordSet.getString("factPrice"))%>
	<%} else {%>
	-
	<%}%>
	</td>
	<td>
	<%if (RecordSet.getInt("typeId")==1) {%>
	<%=Util.getPointValue(Double.toString(Util.getDoubleValue(RecordSet.getString("payPrice"),0) - Util.getDoubleValue(RecordSet.getString("factPrice"),0)))%>
	<%} else {%>
	-
	<%}%>
	</td>
	<td>
	<%if (RecordSet.getInt("typeId")==2) {%>
	<%=Util.getPointValue(RecordSet.getString("payPrice"))%>
	<%} else {%>
	-
	<%}%>
	</td>
	<td>
	<%if (RecordSet.getInt("typeId")==2) {%>
	<%=Util.getPointValue(RecordSet.getString("factPrice"))%>
	<%} else {%>
	-
	<%}%>
	</td>
	<td>
	<%if (RecordSet.getInt("typeId")==2) {%>
	<%=Util.getPointValue(Double.toString(Util.getDoubleValue(RecordSet.getString("payPrice"),0) - Util.getDoubleValue(RecordSet.getString("factPrice"),0)))%>
	<%} else {%>
	-
	<%}%>
	</td>
	<TD><%=Util.toScreen(RecordSet.getString("payDate"),user.getLanguage())%>
    <TD>
    <a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=RecordSet.getString("crmId")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("crmId")),user.getLanguage())%></a>
    </TD> 
</tr>
<%
	islight=!islight;
	if(hasNextPage){
		totalline+=1;
		if(totalline>perpage)	break;
	}

	switch(ViewType)
	{
	case 1: currentvalue = RecordSet.getString("manager"); break;
	default: %><% break;
	}

}while(RecordSet.previous());
}
RecordSet.executeSql("drop table "+temptable);
RecordSet.executeSql("drop table "+temptable1);
%>
</tr>
</table>
<table align=right>
<tr style="display:none">
   <td colspan=2 >&nbsp;</td>
   <td><%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
   <button class=btn accessKey=P id=prepage onclick='OnSubmit(<%=pagenum-1%>)'><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%></td>
   <td><%if(hasNextPage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
<button class=btn accessKey=N id=nextpage onclick='OnSubmit(<%=pagenum+1%>)'><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   </tr>
</table>
</form>


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

<SCRIPT language="javascript">
function OnSubmit(pagenum){
        document.frmmain.pagenum.value = pagenum;
		document.frmmain.submit();
}
</script>
<script language=vbs>

sub onGetProduct(spanname1,inputename1)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	productspan.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
	frmmain.product.value=id(0)   
	else 
	productspan.innerHtml = ""
	frmmain.product.value = ""
	end if
	end if
end sub

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

sub onShowCustomerID(span,input)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	span.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	input.value=id(0)
	else 
	span.innerHtml = ""
	input.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.Department.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml = id(1)
	frmmain.Department.value=id(0)
	else
	departmentspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmmain.department.value=""
	end if
	end if
end sub

sub onShowProvinceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	provinceidspan.innerHtml = id(1)
	frmmain.province.value=id(0)
	else 
	provinceidspan.innerHtml = ""
	frmmain.province.value=""
	end if
	end if
end sub

sub onShowCityID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp?provinceid="&frmmain.province.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	cityidspan.innerHtml = id(1)
	frmmain.city.value=id(0)
	else 
	cityidspan.innerHtml = ""
	frmmain.city.value=""
	end if
	end if
end sub
</script>

<!-- modified by xwj 2005-03-25 for TD 1554 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>
function comparenumber(){
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
}

function ContractExport(){
     searchexport.location="ContractFnaReportExport.jsp";
}
</script>
</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>