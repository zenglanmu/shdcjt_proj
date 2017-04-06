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

<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String TypeID = Util.null2String(request.getParameter("TypeID"));

char flag = 2;

RecordSetT.executeProc("CRM_AddressType_SelectByID",TypeID);
if(RecordSetT.getFlag()!=1)
{
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_1");
	return;
}
RecordSetT.first();

RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData_2");
	return;
}
RecordSetC.first();

RecordSet.executeProc("CRM_CustomerAddress_Select",TypeID+flag+CustomerID);
boolean isEqual = false;
if(RecordSet.getCounts()<=0)
{
	isEqual = true;
}
else
{
	RecordSet.first();
	isEqual = (RecordSet.getInt("isequal")!=0);
}

boolean hasFF = true;
    // commented by lupeng 2004-08-17 for TD828
RecordSetFF.executeProc("Base_FreeField_Select","c3");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();


/*check right begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;
boolean isCustomerSelf=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype="+user.getLogintype()+" and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 canviewlog=true;
//	 canmailmerge=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;	  
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//		canapprove=true;		
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}
 if( useridcheck.equals(RecordSetC.getString("agent"))) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;

 }
if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

/*check right end*/

if(!canview && !isCustomerSelf){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(110,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";

titlename+="   "+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+Util.toScreen(RecordSetT.getString("fullname"),user.getLanguage());
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
<% if(canedit || isCustomerSelf) {
%>

<%if(isEqual){%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17539,user.getLanguage()) +",javascript:doClick1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON  class=Btn accesskey="1"  style="display:none" id=domyfun1  onclick='doClick1()'><U>1</U>-<%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%>&nbsp;<IMG src=/images/BacoCross.gif border=0 align=absmiddle></BUTTON>
<%}else{%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17540,user.getLanguage())+",javascript:doClick2(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON  class=Btn accesskey="1"  style="display:none" id=domyfun2 onclick='doClick2()'><U>1</U>-<%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%>&nbsp;<IMG src=/images/BacoCheck.gif border=0 align=absmiddle></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnEdit id=Edit accessKey=E  style="display:none"  onclick='doEdit()'><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
<%
	}
}%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:Cancel.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnDelete id=Cancel accessKey=C  style="display:none"  onclick='location.href="/CRM/data/ViewAddress.jsp?CustomerID=<%=CustomerID%>"'><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>

</DIV>

<%
	if(isEqual)
	{
%>
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
          <TD class=Field><%=Util.toScreen(RecordSetC.getString("address1"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</TD>
          <TD class=Field><%=Util.toScreen(RecordSetC.getString("address2"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3</TD>
          <TD class=Field><%=Util.toScreen(RecordSetC.getString("address3"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSetC.getString("zipcode")%>  <%=CityComInfo.getCityname(RecordSetC.getString("city"))%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field><%=CountryComInfo.getCountrydesc(RecordSetC.getString("country"))%>  <%=ProvinceComInfo.getProvincename(RecordSetC.getString("province"))%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSetC.getString("county"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSetC.getString("phone")%>  <%=RecordSetC.getString("fax")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><a href="mailto:<%=RecordSetC.getString("email")%>"><%=Util.toScreen(RecordSetC.getString("email"),user.getLanguage())%></a></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
    <%
        String contacterId = "";
        String contacterName = "";
        RecordSetC.executeProc("CRM_Find_CustomerContacter", CustomerID);
        RecordSetC.next();
        contacterId = Util.null2String(RecordSetC.getString(1));
        contacterName = Util.null2String(RecordSetC.getString(3));
    %>
          <a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=contacterId%>"><%=contacterName%></a>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
<%
	}
	else
	{
%>
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
          <TD class=Field><%=Util.toScreen(RecordSet.getString("address1"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2</TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("address2"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3</TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("address3"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("zipcode")%>  <%=CityComInfo.getCityname(RecordSet.getString("city"))%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <TD class=Field><%=CountryComInfo.getCountrydesc(RecordSet.getString("country"))%>  <%=ProvinceComInfo.getProvincename(RecordSet.getString("province"))%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("county"),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("phone")%>  <%=RecordSetC.getString("fax")%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><a href="mailto:<%=RecordSet.getString("email")%>"><%=Util.toScreen(RecordSet.getString("email"),user.getLanguage())%></a></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TD>
          <TD class=Field>
          <a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSet.getString("contacter")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSet.getString("contacter")),user.getLanguage())%></a>
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>        
        </TBODY>
	  </TABLE>
<%
	}
%>

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
//RecordSetFF.executeProc("Base_FreeField_Select","c3");

if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field><%=RecordSet.getString("datefield"+i)%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><%=RecordSet.getString("numberfield"+i)%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><%=Util.toScreen(RecordSet.getString("textfield"+i),user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  value=1 <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%> checked <%}%> disabled >
          </TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>

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
function doClick1(){
	document.location.href="/CRM/data/AddressOperation.jsp?CustomerID=<%=CustomerID%>&TypeID=<%=TypeID%>&method=toNoEqual";
}
function doClick2(){
	location.href="/CRM/data/AddressOperation.jsp?CustomerID=<%=CustomerID%>&TypeID=<%=TypeID%>&method=toEqual";
}
function doEdit(){
	location.href="/CRM/data/EditAddress.jsp?CustomerID=<%=CustomerID%>&TypeID=<%=TypeID%>"
}
</script>
</BODY>
</HTML>
