<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String TypeID = Util.null2String(request.getParameter("TypeID"));
char flag = 2;

RecordSetT.executeProc("CRM_AddressType_SelectByID",TypeID);
if(RecordSetT.getFlag()!=1)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_EA0");
	return;
}
RecordSetT.first();

RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData_EA1");
	return;
}
RecordSetC.first();

RecordSet.executeProc("CRM_CustomerAddress_Select",TypeID+flag+CustomerID);
boolean isEqual = false;
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_EA2");
	return;
}
else
	RecordSet.first();

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c3");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;
boolean canedit=false;
boolean isCustomerSelf=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 if(RecordSetV.getString("sharelevel").equals("2") || RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//	 }
//}
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}
if(useridcheck.equals(RecordSetC.getString("agent"))){ 
	 canedit=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit && !isCustomerSelf) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(110,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";

String temStr="";
temStr+=SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+Util.toScreen(RecordSetT.getString("fullname"),user.getLanguage());
titlename+="&nbsp;&nbsp;&nbsp;&nbsp;"+temStr;
String needfav ="1";
String needhelp ="";
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

<FORM id=weaver name=weaver action="/CRM/data/AddressOperation.jsp" method=post onsubmit='return check_form(this,"Address1")'>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="TypeID" value="<%=TypeID%>">
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:document.weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

	<BUTTON class=btnSave accessKey=S id=myfun1 type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

	<BUTTON class=btnReset accessKey=R id=myfun2 type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(589,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doCancel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

	<BUTTON class=btnDelete id=Cancel accessKey=C onclick='doCancel()'><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
</DIV>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Address1" onchange='checkinput("Address1","Adrress1image")' value="<%=Util.toScreenToEdit(RecordSet.getString("address1"),user.getLanguage())%>"><SPAN id=Adrress1image></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Address2" value="<%=Util.toScreenToEdit(RecordSet.getString("address2"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="Address3" value="<%=Util.toScreenToEdit(RecordSet.getString("address3"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="Zipcode" value="<%=Util.toScreenToEdit(RecordSet.getString("zipcode"),user.getLanguage())%>" ><SPAN STYLE="width:5%"></SPAN>
		  
              <INPUT id=CityCode class="wuiBrowser" _displayText="<%=CityComInfo.getCityname(RecordSet.getString("city"))%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" type=hidden name="City" value="<%=Util.toScreenToEdit(RecordSet.getString("city"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT id=CountryCode class="wuiBrowser" _displayText="<%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp" type=hidden name="Country" value="<%=Util.toScreenToEdit(RecordSet.getString("country"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN>
        
              <INPUT id=ProvinceCode class="wuiBrowser" _displayText="<%=ProvinceComInfo.getProvincename(RecordSet.getString("province"))%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp" type=hidden name="Province" value="<%=Util.toScreenToEdit(RecordSet.getString("province"),user.getLanguage())%>">  
              
              <SPAN STYLE="width:1%"></SPAN>
		  </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=30 name="County" value="<%=Util.toScreenToEdit(RecordSet.getString("county"),user.getLanguage())%>" ></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="Phone" value="<%=Util.toScreenToEdit(RecordSet.getString("phone"),user.getLanguage())%>">  <INPUT class=InputStyle maxLength=50 size=14 name="Fax" value="<%=Util.toScreenToEdit(RecordSet.getString("fax"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 size=30 name="Email" value="<%=Util.toScreenToEdit(RecordSet.getString("email"),user.getLanguage())%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>  
              <INPUT class=wuiBrowser type=hidden id="ContacterID" _displayText="<a href='/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSet.getString("contacter")%>'><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSet.getString("contacter")),user.getLanguage())%></a>" _displayTemplate="<A href='/CRM/data/ViewContacter.jsp?ContacterID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactBrowser.jsp?sqlwhere=where customerid=<%=CustomerID%>" name="ContacterID" value="<%=Util.toScreenToEdit(RecordSet.getString("contacter"),user.getLanguage())%>">
               </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY>
	  </TABLE>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2),user.getLanguage())%></TD>
          <TD class=Field><BUTTON class=Calendar onclick="getCrmDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ><%=RecordSet.getString("datefield"+i)%></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield"+i)%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+10),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 size=30 name="nff0<%=i%>" value="<%=RecordSet.getString("numberfield"+i)%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="tff0<%=i%>" value="<%=RecordSet.getString("textfield"+i)%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=Util.toScreen(RecordSetFF.getString(i*2+30),user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked<%}%>></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>
</FORM>

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

<script type="text/javascript">
function doCancel(){
	location.href="/CRM/data/ViewAddressDetail.jsp?TypeID=<%=TypeID%>&CustomerID=<%=CustomerID%>";
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
