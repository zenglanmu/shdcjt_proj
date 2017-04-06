<%@ page language="java" contentType="text/html; charset=GBK" %>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<html>

<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"£º"+SystemEnv.getHtmlLabelName(16559,user.getLanguage())+"¡ª"+SystemEnv.getHtmlLabelName(15505,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:frmMain.reset(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
boolean hasViewAllRight=false;

if(HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
	hasViewAllRight=true;
}

Calendar today = Calendar.getInstance ();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

//int resourceId=0;
//int departmentId=0;
//int subCompanyId=0;
String fromDate = Util.null2String(request.getParameter("fromDate"));
String toDate = Util.null2String(request.getParameter("toDate"));

if(fromDate.equals("")||toDate.equals("")){
	fromDate=currentDate;
	toDate=currentDate;
}

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);
int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);

if(!hasViewAllRight){
	resourceId=user.getUID();
    departmentId=user.getUserDepartment();
    subCompanyId=user.getUserSubCompany1();
}


%>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:1px">
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<form name=frmMain method=post action="HrmScheduleDiffReportResult.jsp">


<TABLE class=Viewform>
  <COLGROUP>
  <COL width="15%">
  <COL width="35%">
  <COL width="15%">
  <COL width="35%">
  <TBODY> 
    <TR class=title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH>
    </TR>
    <TR style="height:1px">
      <TD class=line1 colspan=4></TD>
    </TR>

  <tr>    
    <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=onShowDate(fromDateSpan,fromDate)></BUTTON>&nbsp;
    <SPAN id=fromDateSpan ><%=fromDate%></SPAN>
    <input class=inputstyle type="hidden" name="fromDate" value=<%=fromDate%>>
    £­<BUTTON type=button class=calendar id=SelectDate onclick=onShowDate(toDateSpan,toDate)></BUTTON>&nbsp;
    <SPAN id=toDateSpan ><%=toDate%></SPAN>
    <input class=inputstyle type="hidden" name="toDate" value=<%=toDate%>>  
    </td>
      <td><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
      <td class=Field>
<%if(hasViewAllRight){%>
	   <input  class=wuiBrowser  class=inputStyle id=subCompanyId type=hidden name=subCompanyId value="<%=subCompanyId%>"
        _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
        _displayText="<%=SubCompanyComInfo.getSubCompanyname(subCompanyId+"")%>"
        >
<%}else{%>
        <span id=subCompanyNameSpan><%=SubCompanyComInfo.getSubCompanyname(subCompanyId+"")%></span> 
        <input class=inputStyle id=subCompanyId type=hidden name=subCompanyId value="<%=subCompanyId%>">
<%} %>
      </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 

  <tr>    
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
    </td>
    <td class=field>
<%if(hasViewAllRight){%>
      <input class=wuiBrowser id=departmentId type=hidden name=departmentId value="<%=departmentId%>" 
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
	  _displayText="<%=DepartmentComInfo.getDepartmentname(""+departmentId)%>"
	  >
<%}else{%>
      <SPAN id=departmentNameSpan><%=DepartmentComInfo.getDepartmentname(""+departmentId)%></SPAN> 
      <INPUT class=inputstyle type=hidden name=departmentId value="<%=departmentId%>" >
<%} %>
    </td>

    <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
    </td>
    <td class=field>
<%if(hasViewAllRight){%>
    <INPUT class=wuiBrowser  class=inputstyle type=hidden name=resourceId value="<%=resourceId%>" 
      _displayText="<%=ResourceComInfo.getResourcename(resourceId+"")%>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
      >
    
<%}else{%>
    <SPAN id=resourceNameSpan><%=ResourceComInfo.getResourcename(resourceId+"")%></SPAN> 
    <INPUT class=inputstyle type=hidden name=resourceId value="<%=resourceId%>" >
<%}%>
   
     
    </td>
  </tr>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 




  </TBODY> 
</TABLE>

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
</body>
</html>

<script language=vbs>

sub onShowSubCompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="&frmMain.subCompanyId.value)
	issame = false 
	if (Not IsEmpty(id)) then
	    if id(0)<> 0 then
	        subCompanyNameSpan.innerHtml = id(1)
	        frmMain.subCompanyId.value=id(0)
	    else
	        subCompanyNameSpan.innerHtml = ""
	        frmMain.subCompanyId.value=""
	    end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.departmentid.value)
	issame = false 
	if (Not IsEmpty(id)) then
	    if id(0)<> 0 then
	        departmentNameSpan.innerHtml = id(1)
	        frmMain.departmentid.value=id(0)
	    else
	        departmentNameSpan.innerHtml = ""
	        frmMain.departmentid.value=""
	    end if	
	end if
end sub

sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if Not isempty(id) then
	    if id(0)<> "" then
	        resourceNameSpan.innerHtml = id(1)
	        frmMain.resourceId.value=id(0)
	    else
	        resourceNameSpan.innerHtml = ""
	        frmMain.resourceId.value=""
	    end if
	end if
end sub

</script>

<script language=javascript>

function submitData() {
	if(check_form(document.frmMain,"fromDate,toDate")){
		if(document.frmMain.fromDate.value > document.frmMain.toDate.value) {
			alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>") ;
		}else if("<%=hasViewAllRight%>"=="true"&&$G("subCompanyId").value=="0"&&$G("departmentId").value=="0"&&$G("resourceId").value=="0"){
		    alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())+SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>");
		}else{
			document.frmMain.submit();
		}
		
	}
}

</script>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>

