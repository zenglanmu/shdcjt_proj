<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<%!
/**
 * @Date June 21,2004
 * @Author Charoes Huang
 * @Description 检测是否是个人用户的添加
 */
	private boolean isPerUser(String type){
		RecordSet rs = new RecordSet();
		String sqlStr ="Select * From CRM_CustomerType WHERE ID = "+type+" and candelete='n' and canedit='n' and fullname='个人用户'";
		rs.executeSql(sqlStr);
		if(rs.next()){
			return true;
		}
		return false;
	}
%>
<%

String type = Util.null2String(request.getParameter("type1"));
String name = Util.null2String(request.getParameter("name1"));
// check the "type" null value added by lupeng 2004-8-9. :)
/*Added by Charoes Huang On June 21,2004*/
if(!type.equals("") && isPerUser(type)){
	response.sendRedirect("AddPerCustomer.jsp?type1="+type+"&name1=" + new String(name.getBytes("GBK") , "ISO8859_1"));
	
	return;
}


boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script language=javascript >
function checkSubmit(obj){
	window.onbeforeunload=null;
	if(check_form(weaver,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime")){
		obj.disabled = true; // added by 徐蔚绛 for td:1553 on 2005-03-22
		weaver.submit();
	}
}
function protectCus(){
	if(!checkDataChange())//added by cyril on 2008-06-12 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
}
function mailValid() {
	var emailStr = document.all("CEmail").value;
	emailStr = emailStr.replace(" ","");
	if (!checkEmail(emailStr)) {
		alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
		document.all("CEmail").focus();
		return;
	}
}
function checktext(){
	if(document.all("introduction").value.length>100){
		document.all("introduction").value=document.all("introduction").value.substring(0,99);
		alert('最大长度为100');
		return;
	
	}


}
</script>

</HEAD>
<%

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectCus()">
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/CRM/data/AddCustomerExist.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

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

<FORM id=weaver name= weaver action="/CRM/data/CustomerOperation.jsp" method=post onsubmit='return check_form(this,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime")' enctype="multipart/form-data">
<input type="hidden" name="method" value="add">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
	
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Name" onchange='checkinput("Name","Nameimage")' STYLE="width:300" value="<%=name%>"><SPAN id=Nameimage><%if(name.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <!--add CRM CODE by lupeng 2004.03.30-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="crmcode" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Abbrev" onchange='checkinput("Abbrev","Abbrevimage")' STYLE="width:95%"><SPAN id=Abbrevimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address1" onchange='checkinput("Address1","Address1image")' STYLE="width:95%"><SPAN id=Address1image><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address2" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address3" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 name="Zipcode" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN>
		
              <INPUT id=CityCode class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" type=hidden name=City>          
            <SPAN STYLE="width:1%"></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <td class=Field id=txtLocation>
              <INPUT id=CountryCode class="wuiBrowser" _displayText="<%=Util.toScreen(CountryComInfo.getCountryname(""+user.getCountryid()),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp" type=hidden name=Country value="<%=user.getCountryid()%>">          
            <SPAN STYLE="width:5%"></SPAN>
			<!--BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON> 
              <SPAN id=provinceidspan STYLE="width:39%"></SPAN>
              <INPUT id=ProvinceCode type=hidden name=Province>          
            <SPAN STYLE="width:1%"></SPAN></TD -->
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="County" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <td class=Field id=txtLocation>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=Util.toScreen(LanguageComInfo.getLanguagename(""+user.getLanguage()),user.getLanguage())%>" _required="yes"  _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" name=Language value="<%=user.getLanguage()%>">        </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Phone" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN><INPUT class=InputStyle maxLength=50 name="Fax" STYLE="width:45%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field>
		  <INPUT maxLength=150 class=InputStyle name="Email" onblur='checkinput_email("Email","Emailimage")' STYLE="width:95%">
		  <SPAN id=Emailimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
		  </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="Website" value="http://" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        
           <!-- 介绍 -->
	         <TR>
	           <TD><%=SystemEnv.getHtmlLabelName(634,user.getLanguage())%></TD>
	            <TD class=Field>
	              <textarea class=inputstyle  name ="introduction" wrap="virtual"   wrap="hard" cols=20  id="introduction" STYLE="width:330;" onKeyPress="checktext();"></textarea>
	            </TD>
	        </TR>
	        <tr style="height: 1px"><td class=Line colspan=2></td></tr>     
           <!-- /介绍 -->
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          
           <td class=Field id=txtLocation>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp" name=Title>        </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="FirstName" onchange='checkinput("FirstName","FirstNameimage")' STYLE="width:95%"><SPAN id=FirstNameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="JobTitle" onchange='checkinput("JobTitle","JobTitleimage")' STYLE="width:95%"><SPAN id=JobTitleimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="CEmail" onblur='mailValid()' STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="PhoneOffice" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(619,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="PhoneHome" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="Mobile" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
           <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle maxLength=20 type="file" STYLE="width:95%" name="photoid">
            </TD>
        </TR>
     
        
        
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

	</TD>

    <TD></TD>
    
	<TD vAlign=top>
      
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=hidden class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" name="CustomerStatus" value="1"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _displayText="<%if (type!="") {%><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(type),user.getLanguage())%><%}else {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp" name=Type value="<%=type%>">        </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation>
              <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp" _required="yes" type=hidden name=Description>        </TD>
         </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
      
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
        
              <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp" _required="yes" type=hidden name=Size></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field>
          
              <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" _required="yes" type=hidden name=Source></td>
              
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp" _required="yes" type=hidden name=Sector>
              </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>  
<%if(!user.getLogintype().equals("2")) {%>		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
          
              <INPUT class="wuiBrowser" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _required="yes" _displayText="<%=user.getUsername()%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=Manager value="<%=user.getUID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
          <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input class=InputStyle id=departmentid type=hidden name=Department value="<%=user.getUserDepartment()%>"></TD>
        </TR -->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
              <input class=wuiBrowser _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)" type=hidden name=Agent></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>     
<%} else {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
          <span             id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(user.getManagerid()),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=Manager value="<%=user.getManagerid()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
              <span id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input class=InputStyle id=departmentid type=hidden name=Department value="<%=user.getUserDepartment()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
              <span id=Agentspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage())%></span> 
              <input class=InputStyle type=hidden name=Agent value="<%=user.getUID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>   

<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field>
              <input class="wuiBrowser" type=hidden _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" name=Parent>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
         
        <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=Document></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr> 
		
		 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></TD>
          <TD class=Field>
        <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=introductionDocid></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>  

	<%if(!user.getLogintype().equals("2")){%>
        <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
		  <TD class=Field> <INPUT class=InputStyle maxLength=3 size=5 	name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="0">
		   <SPAN id=seclevelimage></SPAN>
		  </TD>
	    </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>		
	<%}else{%>
		 <INPUT type=hidden	name=seclevel value="0">
	<%}%>
<!--        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Photo"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
-->        </TBODY>
	  </TABLE>
		<%
		String sqlStr = "select * from CRM_CustomerCredit";
		String CreditAmount = "" ;
		String CreditTime = "";
		RecordSet.executeSql(sqlStr);
		if (RecordSet.next()) {
			CreditAmount = RecordSet.getString("CreditAmount");
			CreditTime = RecordSet.getString("CreditTime");
		}
		%>

        <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colspan = 2><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" onchange='checkinput("CreditAmount","CreditAmountimage");checkdecimal_length("CreditAmount",8)' onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("CreditAmount")' value = "<%=CreditAmount%>"><SPAN id=CreditAmountimage></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=20 name="CreditTime" onchange='checkinput("CreditTime","CreditTimeimage")' onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditTime")' value = "<%=CreditTime%>"><SPAN id=CreditTimeimage></SPAN></TD>
         </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>       

<%}else{%>
		<INPUT type=hidden class=InputStyle name="CreditAmount"  value = "<%=CreditAmount%>">
		<INPUT type=hidden class=InputStyle name="CreditTime"  value = "<%=CreditTime%>">
<%}%>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="bankname"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="accountname"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="accounts" onKeyPress="ItemCount_KeyPress()"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
    </TABLE>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
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
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field>
          <BUTTON type="button" class=Calendar onclick="getCrmDate(<%=i%>)"></BUTTON> 
              <SPAN id=datespan<%=i%> ></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff0<%=i%>")' name="nff0<%=i%>" value="0.0" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="tff0<%=i%>" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  name="bff0<%=i%>" value="1"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>	  

	</TD>
  </TR>
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
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<!-- added by cyril on 2008-06-12 for td8828-->
<script language=javascript src="/js/checkData.js"></script>
<!-- end by cyril on 2008-06-12 for td8828-->
</HTML>
