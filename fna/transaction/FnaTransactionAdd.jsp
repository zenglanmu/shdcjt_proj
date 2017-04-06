<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaTransactionAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>

</head>
<%
String departmentid = Util.null2String(request.getParameter("departmentid")) ;
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

RecordSet.executeProc("FnaCurrency_SelectByDefault","");
RecordSet.next();
String defcurrenyid = RecordSet.getString(1);

String maxtranmark = "1" ;
RecordSet.executeProc("FnaTransaction_SelectByMaxmark","");
if(RecordSet.next())   maxtranmark = ""+(Util.getIntValue(RecordSet.getString(1),0)+1);

String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(428,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(365,user.getLanguage());
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<form id=frmMain name=frmMain method=post action=FnaTransactionOperation.jsp >
<input class=inputstyle type=hidden name="operation" value="addtransaction">
  <input class=inputstyle type=hidden name="trandefcurrencyid" value="<%=defcurrenyid%>">
  <input class=inputstyle type=hidden name="createdate" value="<%=currentdate%>">
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
        <input class=inputstyle type="text" name="tranmark" maxlength="10" size="10" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tranaccessories");checkinput("tranmark","tranmarkimage")' value="<%=maxtranmark%>">
		<span id=tranmarkimage></span>
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=field><button class=Browser onClick="getdate()"></button> 
        <input class=inputstyle type="hidden" name="trandate" value="<%=currentdate%>">
        <span id=trandatespan><%=currentdate%></span></td>
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
      <td class=field>
	  <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
	 <span class=InputStyle id=departmentspan>
	 <% if(!departmentid.equals("")) {%>
	 <%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>
	 <%} else {%><img src="/images/BacoError.gif" align=absMiddle><%}%>
	 </span> 
              		<input class=inputstyle id=trandepartmentid type=hidden name=trandepartmentid value="<%=departmentid%>">
	  </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></td>
      <td class=field> 
       <button class=Browser id=SelectCostCenter onClick="onShowCostCenter()"></button> 
              <span class=InputStyle id=trancostercenteridspan><IMG src="/images/BacoError.gif" 
            align=absMiddle></span> 
              <input class=inputstyle id=trancostercenterid type=hidden name=trancostercenterid>
      </td>
    </tr>
        <TR><TD class=Line colSpan=6></TD></TR> 

    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
      <td class=field> <BUTTON class=Browser 
            id=SelectCurrencyID onClick="onShowCurrencyID()"></BUTTON> <SPAN class=InputStyle 
            id=trancurrencyidspan><%=Util.toScreen(CurrencyComInfo.getCurrencyname(defcurrenyid),user.getLanguage())%></SPAN> 
        <input class=inputstyle id=trancurrencyid type=hidden name=trancurrencyid value="<%=defcurrenyid%>">
      </td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(156,user.getLanguage())%></td>
      <td class=field>
        <input class=inputstyle type="text" name="tranaccessories" maxlength="2" size="5" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tranaccessories");checkinput("tranaccessories","tranaccessoriesimage")'>
        <span id=tranaccessoriesimage><img src="/images/BacoError.gif" align=absMiddle></span> 
      </td>
    </tr>
        <TR><TD class=Line colSpan=6></TD></TR> 

    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(588,user.getLanguage())%></td>
      <td class=field> 
        <input class=inputstyle type="text" name="tranexchangerate" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("tranexchangerate");checkinput("tranexchangerate","tranexchangerateimage")' size=20 value="1.000" maxlength="10">
        <span id=tranexchangerateimage></span></td>
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
      <td class=field><BUTTON class=Browser id=SelecResourceid onClick="onShowResourceID()"></BUTTON> <span 
            id=tranresourceidspan></span> 
              <INPUT class=InputStyle id=tranresourceid type=hidden name=tranresourceid></td>
      <td>&nbsp;</td>
      <td>CRM</td>
      <td class=field>
	  <button class=Browser id=SelectDeparment onClick="onShowParent()"></button> 
              <span class=InputStyle id=trancrmidspan></span> 
              <input class=inputstyle type=hidden name=trancrmid>
	  </td>
    </tr>
        <TR><TD class=Line colSpan=6></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
      <td class=field><button class=Browser onClick="onShowProject()"></button>
  	        <span id=tranprojectidspan></span>
  	        <input class=inputstyle type="hidden" name="tranprojectid"></td>
      <td>&nbsp;</td>
      <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
      <td class=field><button class=Browser onClick="onShowItemID(tranitemidspan,tranitemid)"></button>
	   <span id=tranitemidspan></span>
	  <input class=inputstyle type="hidden" name="tranitemid" id=tranitemid>
	  </td>
    </tr>
        <TR><TD class=Line colSpan=6></TD></TR> 

    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></td>
      <td class=field><button class=Browser onClick="onShowDoc()"></button> 
        <span id=trandocidspan></span><input class=inputstyle type="hidden" name="trandocid"></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td></td>
    </tr>
    <tr> 
      <td height="18"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
      <td class=field>
        <textarea class=inputstyle name="tranremark" cols="30"></textarea>
      </td>
      <td >&nbsp;</td>
      <td >&nbsp;</td>
      <td > </td>
    </tr>
        <TR><TD class=Line colSpan=2></TD></TR> 

    <TR class=title> 
      <TH colSpan=5><%=SystemEnv.getHtmlLabelName(663,user.getLanguage())%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=5></TD>
    </TR>
    <tr > 
      <td colspan=5> 
        <BUTTON class=btnSave accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON> 
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
    <tr class="datadark"> 
      <td> 
        <input class=inputstyle type="text" name="tranremark0" size=30 maxlength="100">
      </td>
      <td><button class=Browser id=SelectCostCenter onClick='onShowLedger(ledgeridspan0,ledgerid0)'></button> 
        <span class=InputStyle id=ledgeridspan0><img src="/images/BacoError.gif" align=absMiddle></span> 
        <input class=inputstyle id=ledgerid0 type=hidden name=ledgerid0>
      </td>
      <td>
        <input class=inputstyle type="text"  id=tranaccount0 name="tranaccount0" size=15 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' maxlength="15">
        <button class=Calculate id=SelectNumber onClick='onShowNumber(tranaccount0)'></button> 
	  </td>
      <td> 
        <input class=inputstyle type="radio" name="tranbalance0" value="1" checked>
        <%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%> 
        <input class=inputstyle type="radio" name="tranbalance0" value="2">
        <%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></td>
    </tr>
    <tr class="datalight"> 
      <td> 
        <input class=inputstyle type="text" name="tranremark1" size=30 maxlength="100">
      </td>
      <td><button class=Browser id=SelectCostCenter onClick='onShowLedger(ledgeridspan1,ledgerid1)'></button> 
        <span class=InputStyle id=ledgeridspan1><img src="/images/BacoError.gif" align=absMiddle></span> 
        <input class=inputstyle id=ledgerid1 type=hidden name=ledgerid1>
      </td>
      <td> 
        <input class=inputstyle type="text" id=tranaccount1 name="tranaccount1" size=15 onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' maxlength="15">
        <button class=Calculate id=SelectNumber onClick='onShowNumber(tranaccount1)'></button> 
	  </td>
      <td> 
        <input class=inputstyle type="radio" name="tranbalance1" value="1">
        <%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%> 
        <input class=inputstyle type="radio" name="tranbalance1" value="2" checked>
        <%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></td>
    </tr>
    </tbody> 
  </table>
<input class=inputstyle type="hidden" name="totaldetail" value=2> 
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
		if id(0) = frmMain.trandepartmentid.value then
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
var rowindex=2;
var totalrows=2;
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
        					"<span class=InputStyle id=ledgeridspan"+rowindex+"><img src='/images/BacoError.gif' align=absMiddle></span> "+
        					"<input class=inputstyle id=ledgerid"+rowindex+" type=hidden name=ledgerid"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='text' id='tranaccount"+rowindex+"' name='tranaccount"+rowindex+"' size=15 onKeyPress='ItemCount_KeyPress()' onBlur='checknumber1(this)' maxlength='15'>" +
							"<button class=Calculate id=SelectNumber onClick='onShowNumber(tranaccount"+rowindex+")'></button> ";
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
function submitData() {
 if(checkvalue()){
 frmMain.submit();
 }
}
</script>
</body>
</html>