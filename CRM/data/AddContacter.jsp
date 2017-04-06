<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c2");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp");
	return;
}
RecordSet.first();

/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSet.getString("department") ;
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

if(useridcheck.equals(RecordSet.getString("agent"))){
	 canedit=true;
 }

if(RecordSet.getInt("status")==7 || RecordSet.getInt("status")==8){
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(572,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectContacter()">
<%if(!isfromtab){ %>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isfromtab){
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+CustomerID+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/CRM/data/ViewCustomerBase.jsp?log=n&CustomerID="+CustomerID+"',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
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

<FORM id=weaver name="weaver" action="/CRM/data/ContacterOperation.jsp" method=post onsubmit='return check_form(this,"Title,FirstName,JobTitle,Manager")' enctype="multipart/form-data">
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab %>">


	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style='height:1px'>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp" name=Title></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="FirstName"  onchange='checkinput("FirstName","FirstNameimage")'><SPAN id=FirstNameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(475,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=14 name="LastName" ></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="JobTitle" onchange='checkinput("JobTitle","JobTitleimage")'><SPAN id=JobTitleimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT name="CEmail" class=InputStyle maxLength=150 size=30 onblur="mailValid()"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="PhoneOffice"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(619,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="PhoneHome"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="Mobile"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=30 name="CFax"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6066,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="interest"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6067,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="hobby"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>		 <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="managerstr"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>		 <TD><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="subordinate"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6068,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="strongsuit"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <%--<TR>--%>
		 <%--<TD><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></TD>--%>
        <%--  <TD class=Field><INPUT class=InputStyle maxLength=3 size=10 name="age" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("age")'></TD>--%>
        <%--</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>--%>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1884,user.getLanguage())%></TD>
          <TD class=Field><button type="button" class=Calendar id=selectbirthday onClick="getbirthday()"></button><span id=birthdayspan></span>
		  <INPUT type = "hidden" class=InputStyle name="birthday"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%></TD>
          <TD class=Field><%=SystemEnv.getHtmlLabelName(17548,user.getLanguage())%><INPUT class=InputStyle maxLength=2 size=5 name="birthdaynotifydays" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("birthdaynotifydays")' value="<%=Util.toScreenToEdit(RecordSet.getString("birthdaynotifydays"),user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1967,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="home"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1518,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="school"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="speciality"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="nativeplace"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="IDCard"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("IDCard")'  ></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		 <TD><%=SystemEnv.getHtmlLabelName(812,user.getLanguage())%></TD>
          <TD class=Field>
		  <TEXTAREA class=InputStyle NAME=experience ROWS=3 STYLE="width:60%"></TEXTAREA></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=Util.toScreen(LanguageComInfo.getLanguagename(""+user.getLanguage()),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" name=Language value="<%=user.getLanguage()%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%if(!user.getLogintype().equals("2")) {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field>
              <INPUT class=wuiBrowser _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _required="yes" _displayText="<%=user.getUsername()%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=Manager value="<%=user.getUID()%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%}else{%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144,user.getLanguage())%></TD>
          <TD class=Field> <span
            id=manageridspan></span>
              <INPUT class=InputStyle type=hidden name=Manager value="<%=RecordSet.getString("manager")%>"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
<%}%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1262,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="Main" value="1"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
    <!--    <TR>
          <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Photo" value="0"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        -->
        <TR>
           <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle type="file" maxLength=100 size=30  name="photoid">
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
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(73,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
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
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 size=30 name="nff0<%=i%>" value="0.0"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="tff0<%=i%>"></TD>
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
          <INPUT type=checkbox  name="bff0<%=i%>" value="1"></TD>
        </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px;">
          <TD class=Line1 colSpan=2></TD></TR>
		<TR>
		  <TD rowspan="1" colspan=2><TEXTAREA class=InputStyle NAME=Remark ROWS=3 STYLE="width:100%"></TEXTAREA>
		  </TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
      
        <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=RemarkDoc value=0></TD>  </TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
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
<SCRIPT language="javascript">
//added by lupeng 2004.06.04.
function mailValid() {
	var emailStr = document.all("CEmail").value;
	emailStr = emailStr.replace(" ","");
	if (!checkEmail(emailStr)) {
		alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
		document.all("CEmail").focus();
		return;
	}
}

function onSave(obj){
	window.onbeforeunload=null;
	if(check_form(document.weaver,'Title,FirstName,JobTitle')){
		obj.disabled=true;
	    	weaver.submit();
	}
}
function protectContacter(){
	if(!checkDataChange())//added by cyril on 2008-06-12 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19004,user.getLanguage())%>";
}
</SCRIPT>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
<!-- added by cyril on 2008-06-12 for td8828-->
<script language=javascript src="/js/checkData.js"></script>
<!-- end by cyril on 2008-06-12 for td8828-->
</HTML>
