<%@ page import="weaver.general.Util" %>
<%@ page import="java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaTransaction:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String departmentid = Util.null2String(request.getParameter("departmentid"));
String tranresourceid = Util.null2String(request.getParameter("tranresourceid"));
String trancostcenterid = Util.null2String(request.getParameter("trancostcenterid"));
if(!tranresourceid.equals("")) {
departmentid = ResourceComInfo.getDepartmentID(tranresourceid) ;
trancostcenterid = ResourceComInfo.getCostcenterID(tranresourceid) ;
}
String trancrmid = Util.null2String(request.getParameter("trancrmid"));
String tranitemid = Util.null2String(request.getParameter("tranitemid"));
String trandocid = Util.null2String(request.getParameter("trandocid"));
String tranprojectid = Util.null2String(request.getParameter("tranprojectid"));

String tranperiods = Util.null2String(request.getParameter("tranperiods"));
String fnayear = "" ;
String periodsid = "" ;
if(!tranperiods.equals("")) {
fnayear = tranperiods.substring(0,4) ;
periodsid = ""+Util.getIntValue(tranperiods.substring(4,6)) ;
}
else {
fnayear = Util.null2String(request.getParameter("fnayear"));
periodsid = Util.null2String(request.getParameter("periodsid"));
}
if(periodsid.equals("0")) periodsid ="";
String transtatus = Util.null2String(request.getParameter("transtatus"));
String dbperiods = "" ;
if(!fnayear.equals("") && !periodsid.equals("")) dbperiods = fnayear+Util.add0(Util.getIntValue(periodsid),2);

String sqlstr =" select *  from FnaTransaction " ;
boolean haswhere = false ;
if(!departmentid.equals("")) {
	sqlstr +=" where trandepartmentid = "+ departmentid ;
	haswhere = true ;
}
if(!trancostcenterid.equals("")) {
	if(!haswhere) sqlstr +=" where trancostercenterid = "+ trancostcenterid  ;
	else sqlstr +=" and trancostercenterid = "+ trancostcenterid  ;
	haswhere = true ;
}
if(!tranresourceid.equals("")) {
	if(!haswhere) sqlstr +=" where tranresourceid = "+ tranresourceid  ;
	else sqlstr +=" and tranresourceid = "+ tranresourceid  ;
	haswhere = true ;
}
if(!trancrmid.equals("")) {
	if(!haswhere) sqlstr +=" where trancrmid = "+ trancrmid  ;
	else sqlstr +=" and trancrmid = "+ trancrmid  ;
	haswhere = true ;
}
if(!tranitemid.equals("")) {
	if(!haswhere) sqlstr +=" where tranitemid = "+ tranitemid  ;
	else sqlstr +=" and tranitemid = "+ tranitemid  ;
	haswhere = true ;
}
if(!trandocid.equals("")) {
	if(!haswhere) sqlstr +=" where trandocid = "+ trandocid  ;
	else sqlstr +=" and trandocid = "+ trandocid ;
	haswhere = true ;
}
if(!tranprojectid.equals("")) {
	if(!haswhere) sqlstr +=" where tranprojectid = "+ tranprojectid ;
	else sqlstr +=" and tranprojectid = "+ tranprojectid  ;
	haswhere = true ;
}
if(!dbperiods.equals("")) {
	if(!haswhere) sqlstr +=" where tranperiods = '"+ dbperiods + "' " ;
	else sqlstr +=" and tranperiods = '"+ dbperiods + "' " ;
	haswhere = true ;
}
if(!transtatus.equals("")) {
	if(!haswhere) sqlstr +=" where transtatus = '"+ transtatus + "' " ;
	else sqlstr +=" and transtatus = '"+ transtatus + "' " ;
}

sqlstr += " order by tranmark desc " ;

boolean canprocess = HrmUserVarify.checkUserRight("FnaTransaction:Process", user) && (transtatus.equals("") || transtatus.equals("1")) ;

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(663,user.getLanguage())+" : "+ SystemEnv.getHtmlLabelName(361,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("FnaTransactionAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/fna/transaction/FnaTransactionAdd.jsp?departmentid="+departmentid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if( canprocess){
RCMenu += "{"+SystemEnv.getHtmlLabelName(664,user.getLanguage())+",javascript:doprocess(),_self} " ;
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

<FORM id=frmMain name=frmMain action=FnaTransactionDetail.jsp method=post>
   <TABLE class=viewForm>
    <COLGROUP> <COL width="12%"></COL> <COL width="40%"></COL> <COL width=24></COL> 
    <COL width="12%"></COL> <COL width="25%"></COL> <THEAD> 
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    </THEAD> <TBODY> 
    <TR class=spacing> 
      <TD class=line1 colSpan=5></TD>
    </TR>
    <TBODY> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(1814,user.getLanguage())%></TD>
      <TD class=Field> 
        <select class=inputstyle name="fnayear">
          <option value=""></option>
          <%
		RecordSet.executeProc("FnaYearsPeriods_Select","");
		while(RecordSet.next()) {
			String thefnayear = RecordSet.getString("fnayear") ;
		%>
          <option value="<%=thefnayear%>" <% if(thefnayear.equals(fnayear)) {%>selected<%}%>><%=thefnayear%></option>
          <%}%>
        </select>
        <input class=inputstyle id=periodsid name=periodsid maxlength="2" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("periodsid")' size="8" value="<%=periodsid%>">
      </TD>
      <TD></TD>
      <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
      <TD class=Field> 
        <select class=inputstyle name=transtatus>
          <option value=""> </option>
          <option value=0 <% if(transtatus.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%></option>
          <option value=1 <% if(transtatus.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
          <option value=2 <% if(transtatus.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1815,user.getLanguage())%></option>
          <option value=3 <% if(transtatus.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1816,user.getLanguage())%></option>
        </select>
      </TD>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
      <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
        <span class=inputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentmark(departmentid)+"-"+DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span> 
        <input class=inputstyle id=departmentid type=hidden name=departmentid value="<%=departmentid%>">
      </TD>
      <TD></TD>
      <TD>&nbsp;</TD>
      <TD>&nbsp; </TD>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(95,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=5></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></td>
      <td class=field><button class=Browser id=SelectCostCenter onClick="onShowCostCenter()"></button> 
        <span class=inputStyle id=trancostcenteridspan><%=Util.toScreen(CostcenterComInfo.getCostCentername(trancostcenterid),user.getLanguage())%></span> 
        <input class=inputstyle id=trancostcenterid type=hidden name=trancostcenterid value="<%=trancostcenterid%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class=field> <BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON> 
        <span id=tranresourceidspan> <A href="/hrm/resource/HrmResource.jsp?id=<%=tranresourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tranresourceid),user.getLanguage())%></A></span> 
        <INPUT class=inputStyle id=tranresourceid type=hidden name=tranresourceid value="<%=tranresourceid%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td>CRM</td>
      <td class=field> <button class=Browser id=SelectDeparment onClick="onShowParent()"></button> 
        <span class=inputStyle id=trancrmidspan><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=trancrmid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(trancrmid),user.getLanguage())%></a></span> 
        <input class=inputstyle type=hidden name=trancrmid value="<%=trancrmid%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
      <td class=field><button class=Browser onClick="onShowItemID(tranitemidspan,tranitemid)"></button> <span id=tranitemidspan><A href='/lgc/asset/LgcAsset.jsp?paraid=<%=tranitemid%>'><%=AssetComInfo.getAssetName(tranitemid)%></a></span> 
        <input class=inputstyle type="hidden" name="tranitemid" id=tranitemid value="<%=tranitemid%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
      <td class=field> <button class=Browser onClick="onShowProject()"></button> 
        <span id=tranprojectidspan><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(tranprojectid),user.getLanguage())%></span> 
        <input class=inputstyle type="hidden" name="tranprojectid" value="<%=tranprojectid%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
      <td class=field> <button class=Browser onClick="onShowDoc()"></button> <span id=trandocidspan><A href="<A href='/docs/docs/DocDsp.jsp?id=<%=trandocid%>"><%=Util.toScreen(DocComInfo.getDocname(trandocid),user.getLanguage())%></A></span> 
        <input class=inputstyle type="hidden" name="trandocid" value="<%=trandocid%>">
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    </TBODY> 
  </TABLE>
</FORM>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="15%">
   <COL width="8%">
  <COL width="20%">
  <COL width="12%">
  <COL width="15%">
  <COL align=right width="15%">
  <COL align=right width="15%">
  <COL width="10%">
  <TBODY>
  <THEAD>
  <TR class=header>
    <TH colSpan=8>
      <P align=left><b><%=SystemEnv.getHtmlLabelName(361,user.getLanguage())%></b></P>
    </TH></TR>
   <TR class=Header align=left>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1819,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%></TD>
    <TD style="TEXT-ALIGN: right"><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></TD>
    <TD><nobr><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></TD>
    </TR>
    <TR class=Line><TD colspan="8" ></TD></TR> 
    </THEAD>
  <TBODY>
 <%
int i=0 ;
RecordSet.executeSql(sqlstr);
BigDecimal  trandaccountsall = new BigDecimal("0") ;
BigDecimal  trancaccountsall = new BigDecimal("0") ;

while(RecordSet.next()){
String ids = RecordSet.getString("id") ;
String tranmarks= RecordSet.getString("tranmark") ;
String transtatuss = RecordSet.getString("transtatus") ;
String trandepartmentids = RecordSet.getString("trandepartmentid") ;
String trandates = RecordSet.getString("trandate") ;
String tranresourceids = RecordSet.getString("tranresourceid") ;
String trandaccounts = RecordSet.getString("trandaccount") ;
String trancaccounts = RecordSet.getString("trancaccount") ;
String trancurrencyids = RecordSet.getString("trancurrencyid") ;
trandaccountsall = trandaccountsall.add(new BigDecimal(trandaccounts));
trancaccountsall = trancaccountsall.add(new BigDecimal(trancaccounts));

if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><A 
      href="FnaTransactionEdit.jsp?id=<%=ids%>"><%=tranmarks%></A></TD>
   
    <TD>
	<% if(transtatuss.equals("0")) {%> <%=SystemEnv.getHtmlLabelName(360,user.getLanguage())%> 
	<%} else if(transtatuss.equals("1")) {%> <%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>
	<%} else if(transtatuss.equals("2")) {%> <%=SystemEnv.getHtmlLabelName(1815,user.getLanguage())%>
	<%} else if(transtatuss.equals("3")) {%> <%=SystemEnv.getHtmlLabelName(1816,user.getLanguage())%>
	<%}%> 
	</TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=trandepartmentids%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(trandepartmentids),user.getLanguage())%></a></TD>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=tranresourceids%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tranresourceids),user.getLanguage())%></a></TD>
    <TD><%=trandates%></TD>
	<TD><%=Util.getFloatStr(trandaccounts.toString(),3)%></TD>
    <TD><%=Util.getFloatStr(trancaccounts.toString(),3)%></TD>
    <TD><%=Util.toScreen(CurrencyComInfo.getCurrencyname(trancurrencyids),user.getLanguage())%></TD>
    </TR>
<%}%>
<tr class=header>
    <TD><B><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></B></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD></TD>
    <TD><B><%=Util.getFloatStr(trandaccountsall.toString(),3)%></B></TD>
    <TD><B><%=Util.getFloatStr(trancaccountsall.toString(),3)%></B></TD>
    <TD></TD>
</TR></TBODY></TABLE>
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
<script language=javascript>  
function submitData() {
frmMain.submit();
}
</script>

<script language=vbs>
sub onShowItemID(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		spanname.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
		inputname.value=id(0)
	else 
		spanname.innerHtml = ""
		inputname.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			if id(0) = frmMain.departmentid.value then
				issame = true 
			end if
			departmentspan.innerHtml = id(1)
			frmMain.departmentid.value=id(0)
		else
			departmentspan.innerHtml = ""
			frmMain.departmentid.value=""
		end if
		
		if issame = false then
			trancostcenteridspan.innerHtml = ""
			frmMain.trancostcenterid.value=""
			tranresourceidspan.innerHtml = ""
			frmMain.tranresourceid.value=""
		end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&frmMain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
		if id(0) = frmMain.trancostcenterid.value then
				issame = true 
		end if
		trancostcenteridspan.innerHtml = id(1)
		frmMain.trancostcenterid.value=id(0)
	else 
		trancostcenteridspan.innerHtml = ""
		frmMain.trancostcenterid.value=""
	end if
	if issame = false then
			tranresourceidspan.innerHtml = ""
			frmMain.tranresourceid.value=""
	end if
	end if
end sub




sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere= where costcenterid="&frmMain.trancostcenterid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	tranresourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmMain.tranresourceid.value=id(0)
	else 
	tranresourceidspan.innerHtml = ""
	frmMain.tranresourceid.value=""
	end if
	end if
end sub


sub onShowDoc()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
		trandocidspan.innerHtml = "<A href='/docs/docs/DocDsp.jsp?id="&id(0)&"'>"&id(1)&"</A>"
		frmMain.trandocid.value=id(0)
		else
		trandocidspan.innerHtml = Empty
		frmMain.trandocid.value=""
		end if
	end if
end sub

sub onShowParent()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	trancrmidspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	frmMain.trancrmid.value=id(0)
	else 
	trancrmidspan.innerHtml = ""
	frmMain.trancrmid.value="0"
	end if
	end if
end sub

sub onShowProject()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		tranprojectidspan.innerHtml = id(1)
		frmMain.tranprojectid.value=id(0)
		else
		tranprojectidspan.innerHtml = empty
		frmMain.tranprojectid.value=""
		end if
	end if
end sub

sub onShowLedger(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerBrowser.jsp?sqlwhere=where ledgertype='2' ")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = ""
		inputname.value=""
		end if
	end if
end sub
</script>
<script language=javascript>
function doprocess() {
	if(frmMain.departmentid.value=="") {
		alert("<%=SystemEnv.getHtmlNoteName(33,user.getLanguage())%>") ;
		return ;
	}
	if(frmMain.periodsid.value=="") {
		alert("<%=SystemEnv.getHtmlNoteName(34,user.getLanguage())%>") ;
		return ;
	}
	if(confirm("<%=SystemEnv.getHtmlNoteName(35,user.getLanguage())%>")) {
		location.href="FnaTransactionOperation.jsp?operation=processtransaction&departmentid="
		+frmMain.departmentid.value+"&tranperiods=<%=dbperiods%>" ;
	}
}
</script>
</BODY></HTML>
