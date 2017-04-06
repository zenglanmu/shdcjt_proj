<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
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
String id = Util.null2String(request.getParameter("id")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("FnaTransaction_SelectByID",id);
RecordSet.next();

String trandepartmentid = Util.null2String(RecordSet.getString("trandepartmentid"));

if(!HrmUserVarify.checkUserRight("FnaTransaction:View",user , trandepartmentid)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
   
String tranmark = Util.toScreen(RecordSet.getString("tranmark"),user.getLanguage());
String trandate = Util.null2String(RecordSet.getString("trandate"));
String trancostercenterid = Util.null2String(RecordSet.getString("trancostercenterid"));
String trancurrencyid = Util.null2String(RecordSet.getString("trancurrencyid"));

String tranexchangerate = Util.null2String(RecordSet.getString("tranexchangerate"));
String tranaccessories = Util.null2String(RecordSet.getString("tranaccessories"));
String tranresourceid = Util.null2String(RecordSet.getString("tranresourceid"));
String trancrmid = Util.null2String(RecordSet.getString("trancrmid"));

String tranitemid = Util.null2String(RecordSet.getString("tranitemid"));
String trandocid = Util.null2String(RecordSet.getString("trandocid"));
String tranprojectid = Util.null2String(RecordSet.getString("tranprojectid"));
String transtatus = Util.null2String(RecordSet.getString("transtatus"));

String tranremark = RecordSet.getString("tranremark") ;
String createrid = Util.null2String(RecordSet.getString("createrid"));
String createdate = Util.null2String(RecordSet.getString("createdate"));
String approverid = Util.null2String(RecordSet.getString("approverid"));
String approverdate = Util.null2String(RecordSet.getString("approverdate"));

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

boolean canedit = false ;
boolean candelete = false ;
if(HrmUserVarify.checkUserRight("FnaTransactionEdit:Edit",user , trandepartmentid) && transtatus.equals("0")) canedit = true ;
if(HrmUserVarify.checkUserRight("FnaTransactionEdit:Delete",user , trandepartmentid) && transtatus.equals("0")) candelete = true ;

String imagefilename = "/images/hdFIN.gif";
String titlename =SystemEnv.getHtmlLabelName(428,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<B><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>:&nbsp;</B><%=createdate%>&nbsp;&nbsp; <b><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%>:&nbsp;</b><A 
href="HrmResource.jsp?id=<%=createrid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(createrid),user.getLanguage())%></A>&nbsp;&nbsp;<B><%=SystemEnv.getHtmlLabelName(359,user.getLanguage())%>:&nbsp;</B><%=approverdate%>&nbsp;&nbsp;<B><%=SystemEnv.getHtmlLabelName(439,user.getLanguage())%>:&nbsp;</B><A 
href="HrmResource.jsp?id=<%=approverid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(approverid),user.getLanguage())%></A>&nbsp;&nbsp;</DIV>
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
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(candelete){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaTransaction:Approve",user , trandepartmentid)){
if(transtatus.equals("0")) { 
RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:onApprove(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(transtatus.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:onReopen(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<form id=frmMain name=frmMain method=post action=FnaTransactionOperation.jsp>
  <input class=inputstyle type=hidden name="operation">
  <input class=inputstyle type=hidden name="createdate" value="<%=currentdate%>">
  <input class=inputstyle type=hidden name="id" value="<%=id%>">
  <input class=inputstyle type="hidden" name="totaldetail"> 
  <input class=inputstyle type=hidden name="trandefcurrencyid" value="<%=defcurrenyid%>">
  <input class=inputstyle type=hidden name="olddepartmentid" value="<%=trandepartmentid%>">
   <table class=viewform>
    <COLGROUP> <COL width="10%"> <COL width="33%"> <COL width=10> <COL width="15%"> 
    <COL width="40%"> <TBODY> 
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=5></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
      <td class=field>
        <%=tranmark%>
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=field>
	  <% if(canedit) {%>
	  <button class=Browser onClick="getdate()"></button> 
        <input class=inputstyle type="hidden" name="trandate" value="<%=trandate%>">
        <span id=trandatespan><%=trandate%></span>
		<%} else {%> <%=trandate%><%}%>
		</td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%>
	  <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
	 <span class=inputStyle id=departmentspan>
	 <%=Util.toScreen(DepartmentComInfo.getDepartmentmark(trandepartmentid)+"-"+DepartmentComInfo.getDepartmentname(trandepartmentid),user.getLanguage())%>
	 </span> 
	<input class=inputstyle id=trandepartmentid type=hidden name=trandepartmentid value="<%=trandepartmentid%>">
	<%} else {%> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(trandepartmentid),user.getLanguage())%><%}%>
	  </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%> 
       <button class=Browser id=SelectCostCenter onClick="onShowCostCenter()"></button> 
              <span class=inputStyle id=trancostercenteridspan><%=Util.toScreen(CostcenterComInfo.getCostCentername(trancostercenterid),user.getLanguage())%></span> 
              <input class=inputstyle id=trancostercenterid type=hidden name=trancostercenterid value="<%=trancostercenterid%>">
	  <%} else {%> <%=Util.toScreen(CostcenterComInfo.getCostCentername(trancostercenterid),user.getLanguage())%><%}%>	  
      </td>
    </tr>
     <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%> 
	   <BUTTON class=Browser 
            id=SelectCurrencyID onClick="onShowCurrencyID()"></BUTTON> <SPAN class=inputStyle 
            id=trancurrencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(trancurrencyid),user.getLanguage())%></SPAN> 
        <input class=inputstyle id=trancurrencyid type=hidden name=trancurrencyid value="<%=trancurrencyid%>">
		<%} else {%> <%=Util.toScreen(CurrencyComInfo.getCurrencyname(trancurrencyid),user.getLanguage())%><%}%>
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%> 
        <input class=inputstyle type="text" name="tranaccessories" maxlength="2" size="5" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tranaccessories");checkinput("tranaccessories","tranaccessoriesimage")' value="<%=tranaccessories%>">
        <span id=tranaccessoriesimage></span> 
		<%} else {%> <%=tranaccessories%> <%}%>
      </td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(588,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%>  
        <input class=inputstyle type="text" name="tranexchangerate" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tranexchangerate");checkinput("tranexchangerate","tranexchangerateimage")' size=20 value="<%=tranexchangerate%>" maxlength="10">
        <span id=tranexchangerateimage></span>
		<%} else {%> <%=tranexchangerate%> <%}%>
		</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp; </td>
    </tr>
    <TR><TD class=Line colSpan=2></TD></TR>
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(95,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=5></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%>  
	  <BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON>
	  <span id=tranresourceidspan>
	  <A href="/hrm/resource/HrmResource.jsp?id=<%=tranresourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tranresourceid),user.getLanguage())%></A></span> 
              <INPUT class=inputStyle id=tranresourceid type=hidden name=tranresourceid value="<%=tranresourceid%>">
			  <%} else {%><A href="/hrm/resource/HrmResource.jsp?id=<%=tranresourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(tranresourceid),user.getLanguage())%></A><%}%>
			  </td>
      <td>&nbsp;</td>
      <td>CRM</td>
      <td class=field><% if(canedit) {%>  
	  <button class=Browser id=SelectDeparment onClick="onShowParent()"></button> 
              <span class=inputStyle id=trancrmidspan><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=trancrmid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(trancrmid),user.getLanguage())%></A></span> 
              <input class=inputstyle type=hidden name=trancrmid value="<%=trancrmid%>">
	  <%} else {%><A href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=trancrmid%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(trancrmid),user.getLanguage())%></A><%}%>
	  </td>
    </tr>
     <TR><TD class=Line colSpan=6></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%>  
	  <button class=Browser onClick="onShowProject()"></button>
  	        <span id=tranprojectidspan><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(tranprojectid),user.getLanguage())%></span>
  	        <input class=inputstyle type="hidden" name="tranprojectid" value="<%=tranprojectid%>">
			<%} else {%><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(tranprojectid),user.getLanguage())%><%}%></td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%>  
	  <button class=Browser onClick="onShowItemID(tranitemidspan,tranitemid)"></button>
	  <span id=tranitemidspan><A href='/lgc/asset/LgcAsset.jsp?paraid=<%=tranitemid%>'><%=AssetComInfo.getAssetName(tranitemid)%></a></span>
	  <input class=inputstyle type="hidden" name="tranitemid" id=tranitemid value="<%=tranitemid%>">
	  <%} else {%><A href='/lgc/asset/LgcAsset.jsp?paraid=<%=tranitemid%>'><%=AssetComInfo.getAssetName(tranitemid)%></a><%}%>
	  </td>
    </tr>
     <TR><TD class=Line colSpan=6></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
      <td class=field>
	  <% if(canedit) {%>  
	  <button class=Browser onClick="onShowDoc()"></button> 
        <span id=trandocidspan><A href="<A href='/docs/docs/DocDsp.jsp?id=<%=trandocid%>"><%=Util.toScreen(DocComInfo.getDocname(trandocid),user.getLanguage())%></A></span>
		<input class=inputstyle type="hidden" name="trandocid" value="<%=trandocid%>">
		<%} else {%><A href="<A href='/docs/docs/DocDsp.jsp?id=<%=trandocid%>"><%=Util.toScreen(DocComInfo.getDocname(trandocid),user.getLanguage())%></A><%}%>
		</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td></td>
    </tr>
     <TR><TD class=Line colSpan=2></TD></TR>
    <tr> 
      <td height="18"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
      <td class=field><% if(canedit) {%>  
        <textarea name="tranremark" cols="30"><%=Util.toScreenToEdit(tranremark,user.getLanguage())%></textarea>
		<%} else {%><%=Util.toScreen(tranremark,user.getLanguage())%><%}%>
      </td>
      <td >&nbsp;</td>
      <td >&nbsp;</td>
      <td > </td>
    </tr>
     <TR><TD class=Line colSpan=2></TD></TR>
    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(663,user.getLanguage())%></TH>
    </TR>
    
    <tr> 
      <td colspan=5><% if(canedit) {%> 
        <BUTTON class=btnSave accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON> 
      <%}%>
	  </td>
    </tr>
     <TR><TD class=Line colSpan=6></TD></TR>
    </tbody> 
  </table>
  <TABLE class=ListStyle cellspacing=1 id="oTable" cols=4>
    <COLGROUP> 
    <COL width="35%"> 
    <COL width="25%"> 
    <COL width="20%"> 
    <COL width="20%"> 
    <TBODY> 
    <TR class=Header> 
      <TD><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(585,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(1818,user.getLanguage())%></TD>
    </TR>
   <TR class=Line><TD colspan="4" ></TD></TR> 
<%
RecordSet.executeProc("FnaTransactionDetail_SByID",id);
int recorderindex = 0 ;
while(RecordSet.next()) {
String ledgerid = Util.null2String(RecordSet.getString("ledgerid"));
String tranaccount = Util.null2String(RecordSet.getString("tranaccount"));
String tranbalance = Util.null2String(RecordSet.getString("tranbalance"));
String tranremarks = RecordSet.getString("tranremark") ;
%>
    <tr> 
      <td> 
        <% if(canedit) {%>
        <input class=inputstyle type="text" name="tranremark<%=recorderindex%>" size=30 maxlength="100" value="<%=Util.toScreenToEdit(tranremarks,user.getLanguage())%>">
      <%} else {%><%=Util.toScreen(tranremarks,user.getLanguage())%><%}%>
      </td>
      <td> <% if(canedit) {%>
	  <button class=Browser id=SelectCostCenter onClick='onShowLedger(ledgeridspan<%=recorderindex%>,ledgerid<%=recorderindex%>)'></button> 
        <span class=inputStyle id=ledgeridspan<%=recorderindex%>><%=LedgerComInfo.getLedgermark(ledgerid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%></span> 
        <input class=inputstyle id=ledgerid<%=recorderindex%> type=hidden name=ledgerid<%=recorderindex%> value="<%=ledgerid%>">
		<%} else {%><%=LedgerComInfo.getLedgermark(ledgerid)%>-<%=Util.toScreen(LedgerComInfo.getLedgername(ledgerid),user.getLanguage())%><%}%>
      </td>
      <td><% if(canedit) {%>
        <input class=inputstyle type="text" id=tranaccount<%=recorderindex%> name="tranaccount<%=recorderindex%>" size=15 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' maxlength="15" value="<%=tranaccount%>">
		<button class=Calculate id=SelectNumber onClick='onShowNumber(tranaccount<%=recorderindex%>)'></button> 
		<%} else {%><%=tranaccount%><%}%>
      </td>
      <td><% if(canedit) {%>
        <input class=inputstyle type="radio" name="tranbalance<%=recorderindex%>" value="1" <% if(tranbalance.equals("1")) {%>checked<%}%> >
        <%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%> 
        <input class=inputstyle type="radio" name="tranbalance<%=recorderindex%>" value="2" <% if(tranbalance.equals("2")) {%>checked<%}%> >
        <%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%>
		<%} else {%>
		<% if(tranbalance.equals("1")) {%> <%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%>
		<%} else {%> <%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%>
		<%}}%>
		</td>
    </tr>
<% recorderindex ++ ;} %>
    </tbody> 
  </table>
</form>
<script language=vbscript>
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.trandepartmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
		if id(0)<> 0 then
			if id(0) = frmMain.trandepartmentid.value then
				issame = true 
			end if
			departmentspan.innerHtml = id(1)
			frmMain.trandepartmentid.value=id(0)
		else
			departmentspan.innerHtml = "<img src='/images/BacoError.gif' align=absMiddle>"
			frmMain.trandepartmentid.value=""
		end if
		
		if issame = false then
			trancostercenteridspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			frmMain.trancostercenterid.value=""
			tranresourceidspan.innerHtml = ""
			frmMain.tranresourceid.value=""
		end if
	end if
end sub

sub onShowCostCenter()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&frmMain.trandepartmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
		if id(0) = frmMain.trancostercenterid.value then
				issame = true 
		end if
		trancostercenteridspan.innerHtml = id(1)
		frmMain.trancostercenterid.value=id(0)
	else 
		trancostercenteridspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		frmMain.trancostercenterid.value=""
	end if
	if issame = false then
			tranresourceidspan.innerHtml = ""
			frmMain.tranresourceid.value=""
	end if
	end if
end sub

sub onShowCurrencyID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		trancurrencyidspan.innerHtml = id(1)
		frmMain.trancurrencyid.value=id(0)
		else
		trancurrencyidspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		frmMain.trancurrencyid.value= ""
		end if
	end if
end sub

sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere= where costcenterid="&frmMain.trancostercenterid.value)
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
	frmMain.trancrmid.value=""
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
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/FnaLedgerBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
		else
		spanname.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		inputname.value=""
		end if
	end if
end sub

sub onShowNumber(inputename) 
	returnnumber = window.showModalDialog("/systeminfo/Calculate.jsp",,"dialogHeight:230px;dialogwidth:208px")
	if returnnumber <> "" then
	inputename.value = returnnumber
	end if
end sub

sub getdate()
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if returndate <> "" then
	trandatespan.innerHtml= returndate
	frmMain.trandate.value= returndate
	else
	trandatespan.innerHtml= "<%=currentdate%>"
	frmMain.trandate.value= "<%=currentdate%>"
	end if
end sub

</script>
<script language="JavaScript" src="/js/addRowBg.js" >   
</script>  
<script language=javascript>
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
</script>
<script language=javascript>
var rowindex=0;
var totalrows=0;
var totaldebit = 0 ;
var totalcredit = 0 ;
var rowColor="" ;
function addRow()
{	
	ncol = oTable.cols;
	oRow = oTable.insertRow();
    rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
        oCell.style.background= rowColor;
		switch(j) {
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='text' name='tranremark"+rowindex+"' size='30' maxlength='100'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<button class=Browser id=SelectCostCenter onClick='onShowLedger(ledgeridspan"+rowindex+",ledgerid"+rowindex+")'></button> " + 
        					"<span class=inputStyle id=ledgeridspan"+rowindex+"><img src='/images/BacoError.gif' align=absMiddle></span> "+
        					"<input class=inputstyle id=ledgerid"+rowindex+" type=hidden name=ledgerid"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='text' name='tranaccount"+rowindex+"' size=15 onKeyPress='ItemCount_KeyPress()' onBlur='checknumber1(this)' maxlength='15'>"+
							"<button class=Calculate id=SelectNumber onClick='onShowNumber(tranaccount"+rowindex+")'></button>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='radio' name='tranbalance"+rowindex+"' value='1' checked> ½è·½ "+ 
        					"<input class=inputstyle type='radio' name='tranbalance"+rowindex+"' value='2'> ´û·½ ";
				oDiv.innerHTML = sHtml;    
				oCell.appendChild(oDiv);   
				break;
		}
	}
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
}

function checkvalue() {
	parastr = "tranmark,trandate,trandepartmentid,trancostercenterid,trancurrencyid,tranexchangerate,tranaccessories" ;
	for(i=0; i<totalrows ; i++) {
		if(document.all("tranaccount"+i).value != "") {
			parastr += ",ledgerid"+i ;
			radiosel = document.all("tranbalance"+i) ;
			for(j =0 ; j< radiosel.length ; j++) {
				if(radiosel[j].value=='1' && radiosel[j].checked) {totaldebit += eval(document.all("tranaccount"+i).value) ;}
				if(radiosel[j].value=='2' && radiosel[j].checked) totalcredit += eval(document.all("tranaccount"+i).value) ;
			}
		}
	}
	if(!check_form(document.frmMain,parastr)) return false ;
	if(eval(frmMain.tranexchangerate.value) == 0) {
		alert("<%=SystemEnv.getHtmlNoteName(32,user.getLanguage())%>") ;
		return false ;
	}
	if(totalcredit != totaldebit) {
		totalcredit = 0; totaldebit=0 ;
		return confirm("<%=SystemEnv.getHtmlNoteName(31,user.getLanguage())%>") ;
	}
	totalcredit = 0; totaldebit=0 ;
	return true ;
}

function onEdit() {
	if(checkvalue()) {
		frmMain.operation.value="edittransaction" ;
		frmMain.submit() ;
	}
}

function onDelete() {
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmMain.operation.value="deletetransaction";
		document.frmMain.submit();
	}
}

function onApprove() {
	frmMain.operation.value="approvetransaction" ;
	frmMain.submit() ;
}

function onReopen() {
	frmMain.operation.value="reopentransaction" ;
	frmMain.submit() ;
}


</script>


</body>
</html>