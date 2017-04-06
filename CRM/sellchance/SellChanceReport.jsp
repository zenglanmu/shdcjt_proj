<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs22" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY> 
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
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
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String preyield=Util.null2String(request.getParameter("preyield"));
String product=Util.fromScreen(request.getParameter("product"),user.getLanguage());
String preyield_1=Util.null2String(request.getParameter("preyield_1"));
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());
String sufactor=Util.fromScreen(request.getParameter("sufactor"),user.getLanguage());
String defactor=Util.fromScreen(request.getParameter("defactor"),user.getLanguage());
String subCompanyId=Util.fromScreen(request.getParameter("subCompanyId"),user.getLanguage());//客户经理分部ID
String departmentId=Util.fromScreen(request.getParameter("departmentId"),user.getLanguage());//客户经理部门ID
String includeSubCompany=Util.fromScreen(request.getParameter("includeSubCompany"),user.getLanguage());
String includeSubDepartment=Util.fromScreen(request.getParameter("includeSubDepartment"),user.getLanguage());

//added by lupeng 2004.05.21 for TD470.
try {
	Float.parseFloat(preyield);
} catch (NumberFormatException ex) {
	preyield = "";
}

try {
	Float.parseFloat(preyield_1);
} catch (NumberFormatException ex) {
	preyield_1 = "";
}
//end

//out.print(customer);
String sqlwhere="";
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);


if(resource!=0){
	if(sqlwhere.equals(""))	sqlwhere+=" where t3.manager="+resource;
	else	sqlwhere+=" and t3.manager="+resource;
}
if(!fromdate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.predate>='"+fromdate+"'";
	else 	sqlwhere+=" and t1.predate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.predate<='"+enddate+"'";
	else 	sqlwhere+=" and t1.predate<='"+enddate+"'";
}


if(!sufactor.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.sufactor="+sufactor;
	else	sqlwhere+=" and t1.sufactor="+sufactor;
}

if(!defactor.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.defactor="+defactor;
	else	sqlwhere+=" and t1.defactor="+defactor;
}
/*=====*/
if(!subCompanyId.equals("")&&!subCompanyId.equals("0")){//客户经理分部ID
	 if(includeSubCompany.equals("2")){
		String subCompanyIds = "";
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		if(list.size()>0)subCompanyIds = subCompanyIds.substring(1);
		subCompanyIds = "("+subCompanyIds+")";
		
		if(sqlwhere.equals(""))	sqlwhere+=" where t1.subCompanyId in "+subCompanyIds;
		else	sqlwhere+=" and t1.subCompanyId in "+subCompanyIds;
		
	}else if(includeSubCompany.equals("3")){
		String subCompanyIds = subCompanyId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubCompanyLists(subCompanyId,list);
		for(int i=0;i<list.size();i++){
			subCompanyIds += ","+(String)list.get(i);
		}
		subCompanyIds = "("+subCompanyIds+")";

		if(sqlwhere.equals(""))	sqlwhere+=" where t1.subCompanyId in "+subCompanyIds;
		else	sqlwhere+=" and t1.subCompanyId in "+subCompanyIds;
	}else{
		if(sqlwhere.equals(""))	sqlwhere+=" where t1.subCompanyId="+subCompanyId;
		else	sqlwhere+=" and t1.subCompanyId="+subCompanyId;
	}
}
if(!departmentId.equals("")){//客户经理部门ID
	if(includeSubDepartment.equals("2")){
		String departmentIds = "";
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		if(list.size()>0)departmentIds = departmentIds.substring(1);
		departmentIds = "("+departmentIds+")";

		if(sqlwhere.equals(""))	sqlwhere+=" where t1.departmentId in "+departmentIds;
		else	sqlwhere+=" and t1.departmentId in "+departmentIds;
	}else if(includeSubDepartment.equals("3")){
		String departmentIds = departmentId;
		ArrayList list = new ArrayList();
		SubCompanyComInfo.getSubDepartmentLists(departmentId,list);
		for(int i=0;i<list.size();i++){
			departmentIds += ","+(String)list.get(i);
		}
		departmentIds = "("+departmentIds+")";

		if(sqlwhere.equals(""))	sqlwhere+=" where t1.departmentId in "+departmentIds;
		else	sqlwhere+=" and t1.departmentId in "+departmentIds;		
	}else{
		if(sqlwhere.equals(""))	sqlwhere+=" where t1.departmentId="+departmentId;
		else	sqlwhere+=" and t1.departmentId="+departmentId;
	}
}
if(!customer.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.customerid="+customer;
	else	sqlwhere+=" and t1.customerid="+customer;
}

if(!sellstatusid.equals("")){
	if(sqlwhere.equals(""))
        sqlwhere+=" where t1.sellstatusid="+sellstatusid;
	else
        sqlwhere+=" and t1.sellstatusid="+sellstatusid;
}
if(!preyield.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.preyield>="+preyield;
	else	sqlwhere+=" and t1.preyield>="+preyield;
}
if(!preyield_1.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.preyield<="+preyield_1;
	else	sqlwhere+=" and t1.preyield<="+preyield_1;
}
if(!endtatusid.equals("")&&!endtatusid.equals("4")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.endtatusid ="+endtatusid;
	else	sqlwhere+=" and t1.endtatusid ="+endtatusid;
}

String sellchanceid="";
if(!product.equals("")){
    String sql_P="select sellchanceid from CRM_ProductTable where productid ="+product;
    rs22.executeSql(sql_P);
    while(rs22.next()){
    sellchanceid += ","+rs22.getString("sellchanceid");
    }
    if(!sellchanceid.equals("")){
        sellchanceid = sellchanceid.substring(1); 
        if(sqlwhere.equals(""))	sqlwhere+=" where t1.id in("+sellchanceid+")";
        else	sqlwhere+=" and t1.id in("+sellchanceid+")";
    }
    else{//此产品没有客户，则就什么销售机会都没有
        if(sqlwhere.equals(""))	sqlwhere+=" where t1.id < 0";
        else	sqlwhere+=" and t1.id < 0";
    }
}
/*
if(user.getLogintype().equals("2")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.agentid!='' and  t1.agentid!='0'";
	else 	sqlwhere+=" and  t1.agentid!='' and  t1.agentid!='0'";
}
*/
String sqlstr = "";
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

String sql_count="";
if(user.getLogintype().equals("1")){
	sql_count="select sum(preyield) count_sum from CRM_SellChance t1 ,"+leftjointable+" t2, CRM_CustomerInfo t3 " + sqlwhere + " and t3.deleted=0  and t3.id = t1.customerid and t1.customerid = t2.relateditemid";
}else{
	sql_count="select sum(preyield) count_sum from CRM_SellChance t1 " + sqlwhere + " and t1.customerid="+user.getUID();
}
rs_count.executeSql(sql_count);
rs_count.next();
String count_sum= rs_count.getString("count_sum");//计算预期总收益

//add by xwj for TD 1554 on 2005-03-25
session.setAttribute("sqlwhere",sqlwhere);
/*
String temptable = "temptable"+ Util.getRandom() ;

if(RecordSet.getDBType().equals("oracle")){
	if(user.getLogintype().equals("1")){
        sqlstr = "create table "+temptable+"  as select * from (select distinct t1.* from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid order by t1.predate desc ) where rownum<"+ (pagenum*perpage+2);

	}else{
        sqlstr = "create table "+temptable+"  as select * from (select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + "  order by t1.predate desc ) where rownum<"+ (pagenum*perpage+2);
	}
}else if(RecordSet.getDBType().equals("db2")){
	if(user.getLogintype().equals("1")){
		sqlstr = "create table "+temptable+"  as (select distinct t1.* from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" ( select distinct t1.* from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid  order by t1.predate desc fetch first "+(pagenum*perpage+1)+"  rows only)";
    }else{
		sqlstr = "create table "+temptable+"  as (select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  ) definition only";
        RecordSet.executeSql(sqlstr);
        sqlstr = "insert into "+temptable+" ( select t1.* from CRM_SellChance  t1,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + "  order by t1.predate desc  fetch first "+(pagenum*perpage+1)+"  rows only)";
    }
}else{
	if(user.getLogintype().equals("1")){
        sqlstr = "select distinct top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0  and t3.id= t1.customerid and t1.customerid = t2.relateditemid ORDER BY t1.predate desc " ;
	}else{
        sqlstr = "select top "+(pagenum*perpage+1)+" t1.* into "+temptable+" from CRM_SellChance t1,CRM_CustomerInfo t3  "+ sqlwhere +" and t3.deleted=0 and t3.id= t1.customerid  and t1.customerid="+user.getUID() + " ORDER BY t1.predate desc " ;
	}

}

RecordSet.executeSql(sqlstr);
RecordSet.executeSql("Select count(distinct(id)) RecordSetCounts from "+temptable);
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
	sqltemp="select * from (select * from  "+temptable+"  ORDER BY predate) where rownum< "+(RecordSetCounts-(pagenum-1)*perpage+1) ;	
}else if(RecordSet.getDBType().equals("db2")){
    sqltemp="select   * from "+temptable+" ORDER BY predate fetch first "+(RecordSetCounts-(pagenum-1)*perpage)+" rows only";
}else{
	sqltemp="select top "+(RecordSetCounts-(pagenum-1)*perpage)+" * from "+temptable+" ORDER BY predate,id ";
}

RecordSet.executeSql(sqltemp);
*/

%>
<form id=weaver name=frmmain method=post action="SellChanceReport.jsp">
 <input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">

<table class=ViewForm>
<colgroup>
<col width="10%">
<col width="20%">
<col width="10%">
<col width="15%">
<col width="10%">
<col width="10%">
<col width="15%">
<col width="10%">
  <tbody>
  <TR class=Title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%></TH>
  </TR>
  <tr style="height: 1px"><td class=Line1 colspan=10></td></tr>
  <TR class=Spacing><TD colspan=9 class=sep2></TD></TR>
  <tr>
  <%if(!user.getLogintype().equals("2")){%>
  <td ><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
  <td class=field>
 	<input class="wuiBrowser" _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=resource%>'><%=Util.toScreen(resourcename,user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" _displayTemplate="<A href='HrmResource.jsp?id=#b{id}'>#b{name}</A>" type=hidden name=viewer value="<%=resource%>"></td>
  <%}%>
  <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
  <td class=Field>
  	<input class=wuiBrowser _displayText="<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subCompanyId),user.getLanguage())%>"  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" id=subCompanyId type=hidden name=subCompanyId value="<%=subCompanyId%>">
	</td>
	<td class=field><select class=InputStyle name="includeSubCompany">
  	<option value="1" <%if(includeSubCompany.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18919,user.getLanguage())%></option>
  	<option value="2" <%if(includeSubCompany.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18920,user.getLanguage())%></option>
  	<option value="3" <%if(includeSubCompany.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18921,user.getLanguage())%></option>
  </select></td>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td class=Field>
  	<input class=wuiBrowser _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentId),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" id=departmentId type=hidden name=departmentId value="<%=departmentId%>">
  </td>
  <td class=field><select class=InputStyle name="includeSubDepartment">
  	<option value="1" <%if(includeSubDepartment.equals("1")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18916,user.getLanguage())%></option>
  	<option value="2" <%if(includeSubDepartment.equals("2")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18917,user.getLanguage())%></option>
  	<option value="3" <%if(includeSubDepartment.equals("3")){%>SELECTED<%}%>><%=SystemEnv.getHtmlLabelName(18918,user.getLanguage())%></option>
  </select></td>
	</tr><tr style="height: 1px"><td class=Line colspan=9></td></tr>
	<tr>
    <TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%>  </TD>
    <TD class=Field><INPUT text class=InputStyle maxLength=20 size=6 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
     -- <INPUT text class=InputStyle maxLength=20 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </TD>
    <TD class=Field colspan="2">
    <select text class=InputStyle id=sellstatusid
      name=sellstatusid>
      <option value="" <%if(sellstatusid.equals("")){%> selected<%}%> ></option>
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
    <TD><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></TD>
    <TD class=Field colspan="2">
    <select text class=InputStyle id=endtatusid  name=endtatusid>
    <option value=4 <%if(endtatusid.equals("4")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%> </option>
    <option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
    <option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
    <option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
    </TD>
  </TR><tr style="height: 1px"><td class=Line colspan=9></td></tr>
  <tr>
    <TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></TD>
    <TD class=Field>
    <INPUT class=wuiBrowser _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customer%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%></a>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name="customer" value="<%=customer%>"></TD>

    <td><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></td>
    <td class=field colspan="2">
    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －&nbsp;<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
    <TD><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></TD>
    <TD class=Field colspan="2">
    <input class="wuiBrowser" _displayTemplate="<A href='/lgc/asset/LgcAsset.jsp?paraid=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp" _displayText="<A href='/lgc/asset/LgcAsset.jsp?paraid=<%=product%>' ><%=Util.toScreen(AssetComInfo.getAssetName(product),user.getLanguage())%></a>" type="hidden" name="product" value="<%=product%>">
    </TD >
  </TR><tr style="height: 1px"><td class=Line colspan=9></td></tr>
  <tr>
    <TD><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%> </TD>
    <TD class=Field>
    <select text class=InputStyle id=sufactor
      name=sufactor>
      <option value="" <%if(sufactor.equals("")){%> selected<%}%> ></option>
    <%  
    String theid_s="";
    String thename_s="";
    String sql_s="select * from CRM_Successfactor ";
    RecordSetM.executeSql(sql_s);
    while(RecordSetM.next()){
        theid_s = RecordSetM.getString("id");
        thename_s = RecordSetM.getString("fullname");
        if(!thename_s.equals("")){
        %>
    <option value=<%=theid_s%>  <%if(sufactor.equals(theid_s)){%> selected<%}%> ><%=thename_s%></option>
    <%}
    }%>
    </TD>
    <TD><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%> </TD>
    <TD class=Field colspan="2">
    <select text class=InputStyle id=defactor 
      name=defactor>
      <option value="" <%if(defactor.equals("")){%> selected<%}%> ></option>
    <%  
    String theid_d="";
    String thename_d="";
    String sql_d="select * from CRM_Failfactor ";
    RecordSetM.executeSql(sql_d);
    while(RecordSetM.next()){
        theid_d = RecordSetM.getString("id");
        thename_d = RecordSetM.getString("fullname");
        if(!thename_d.equals("")){
        %>
    <option value=<%=theid_d%>  <%if(defactor.equals(theid_d)){%> selected<%}%> ><%=thename_d%></option>
    <%}
    }%>
    </TD>
		<td></td>
		<td></td>
  </TR><tr style="height: 1px"><td class=Line colspan=9></td></tr>



</tbody>

<table class=ListStyle cellspacing=0>
    <tr> <td valign="top">
  			<%
  			String  tableString  =  "";
  			String  backfields  =  "t1.id,t1.subject,t1.predate,t1.preyield,t1.probability,t1.sellstatusid,t1.createdate,t1.endtatusid,t1.CustomerID ";     
            String  fromSql=" CRM_SellChance  t1,"+leftjointable+" t2,CRM_CustomerInfo t3 ";
            String   sqlmei=" and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t2.relateditemid ";
			String linkstr = "";
			linkstr = "/CRM/data/ViewCustomer.jsp";
  			String orderby  =  "";
  			if(!sqlwhere.equals("")){
  				sqlwhere += sqlmei;
  			}
              tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
  									 "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"  sqlisdistinct=\"true\"  />"+
  									 "<head>";
  			tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"id\"  linkkey=\"t1.subject\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMNamecont\" otherpara=\"column:customerid+column:subject\" orderkey=\"t1.subject\" />";
  			tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2247,user.getLanguage())+"\" column=\"predate\" orderkey=\"t1.predate\" />";
            tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2248,user.getLanguage())+"\"  column=\"preyield\" orderkey=\"t1.preyield\"/>";
            tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2249,user.getLanguage())+"\" column=\"probability\" orderkey=\"t1.probability\" transmethod=\"\"/>";
            tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate\" transmethod=\"\"/>";
            tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2250,user.getLanguage())+"\" column=\"sellstatusid\" orderkey=\"t1.sellstatusid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMSellStatus\"/>";
            tableString+="<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(15112,user.getLanguage())+"\" column=\"endtatusid\" orderkey=\"t1.endtatusid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getPigeonholeStatus\" otherpara=\""+user.getLanguage()+"\"/>";
			tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"\" href=\""+linkstr+"\" linkkey=\"CustomerID\" column=\"customerid\" orderkey=\"t1.customerid\" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\" />";
            tableString+="</head>";
          tableString+="</table>";
        %>

			<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" topLeftText='<%="<font color=red style=font:bold>"+SystemEnv.getHtmlLabelName(15251,user.getLanguage())+":"+count_sum+"</font>"%>' />
		</td>
	</tr>
</table>
<table align=right>
<tr style="display:none">
   <td colspan=2 >&nbsp;</td>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>
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

function comparenumber() {
    if ((document.frmmain.preyield.value != "") && (document.frmmain.preyield_1.value != "")) {
		lownumber = eval(toFloat(document.all("preyield").value,0));
		highnumber = eval(toFloat(document.all("preyield_1").value,0));		

		if (lownumber > highnumber) {
			alert("<%=SystemEnv.getHtmlLabelName(15243,user.getLanguage())%>！");			
		}		
	}	
}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
</script>
<!-- modified by xwj 2005-03-25 for TD 1554 -->
<iframe id="searchexport" style="display:none"></iframe>
<script language=javascript>
function ContractExport(){
     $("#searchexport")[0].src="ShellChanceReportExport.jsp";
}
</script>

</body>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</html>