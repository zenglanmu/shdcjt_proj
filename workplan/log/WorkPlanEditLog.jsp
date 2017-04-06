<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.*" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="logMan" class="weaver.WorkPlan.WorkPlanLogMan" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="workPlanHandler" class="weaver.WorkPlan.WorkPlanHandler" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>

<%
String workPlanId = Util.null2String(request.getParameter("workid"));
String trmOperatorId = Util.null2String(request.getParameter("trmoperatorid"));			//操作人
String trmStartDate = Util.null2String(request.getParameter("trmstartdate"));			//开始日期
String trmEndDate = Util.null2String(request.getParameter("trmenddate"));				//结束日期
int pageNum = Util.getIntValue(request.getParameter("epagenum"), 1);

ArrayList logData = new ArrayList();
logData = logMan.getEditLog(Util.getIntValue(workPlanId, -1),
							Util.getIntValue(trmOperatorId, -1),
								trmStartDate,
								trmEndDate,
								pageNum);

boolean hasNextPage = logMan.hasNextPage();

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17481,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doRefresh(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

if (pageNum > 1) {		
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:goBackPage(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

if (hasNextPage) {		
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:goNextPage(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanEditLog.jsp">
		<INPUT type="hidden" name="workid" value="<%=workPlanId%>">
		<INPUT type="hidden" name="epagenum" value="<%=pageNum%>">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">
	<TABLE class="ViewForm">
	  <COLGROUP>
	  <COL width="10%">
	  <COL width="37%">
	  <COL width="6%">
	  <COL width="10%">
	  <COL width="37%">	  
	  <TBODY>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
		<TD class="field"><INPUT type="hidden" name="trmoperatorid" class="wuiBrowser" value="<%=trmOperatorId%>"
			_displayText="<%=Util.toScreen(resourceComInfo.getResourcename(trmOperatorId), user.getLanguage())%>"
			_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"></TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></TD>
		<TD class="field"><button type="button" class="Calendar" id="SelectStartDate" onclick="getDate(trmstartdatespan,trmstartdate)"></BUTTON>
		  <SPAN id="trmstartdatespan"><%=trmStartDate%></SPAN>
		  <INPUT type="hidden" name="trmstartdate" value="<%=trmStartDate%>">&nbsp;-&nbsp;&nbsp;
		  <button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(trmenddatespan,trmenddate)"></BUTTON>
		  <SPAN id="trmenddatespan"><%=trmEndDate%></SPAN>
		  <INPUT type="hidden" name="trmenddate" value="<%=trmEndDate%>"></TD>
		<TD colSpan="3"></TD>
		</TR>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>					
	  </TBODY>
	</TABLE>
	</FORM>
	<TABLE class="ListStyle" cellspacing="1" id="result" >
    <COLGROUP>
    <COL width="20%">
    <COL width="10%">
    <COL width="10%">
	<COL width="10%">
	<COL width="10%">
    <COL width="15%">
    <COL width="25%">	
    </COLGROUP>
    <TBODY>
    <TR class="Header">
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(16652,user.getLanguage())%></TD>      
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17485,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17486,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17484,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></TD>	  
    </TR>
	<TR class="Line" ><TD colspan="7" style="padding:0;"></TD></TR>
<%	
	boolean isLight = false;
	String[] data;
	String m_workPlanId;
	String m_fieldName;
	String m_oldValue;
	String m_newValue;
	String m_operatorId;
	String m_ipAddress;
	String m_logDate;
	String m_logTime;	
	for (int i = 0; i < logData.size(); i++) {
		data = (String[]) logData.get(i);

		m_workPlanId = data[0];
		m_fieldName = data[1];
		m_oldValue = data[2];
		m_newValue = data[3];
		m_operatorId = data[4];
		m_ipAddress = data[5];
		m_logDate = data[6];
		m_logTime = data[7];
	
		
		if (m_fieldName.equals(WorkPlanLogMan.FD_REQUESTS)) {
			m_oldValue = logMan.getAssociatedRequest(m_oldValue);
			m_newValue = logMan.getAssociatedRequest(m_newValue);
		} else if (m_fieldName.equals(WorkPlanLogMan.FD_PROJECTS)) {
			m_oldValue = logMan.getAssociatedProject(m_oldValue);
			m_newValue = logMan.getAssociatedProject(m_newValue);
		} else if (m_fieldName.equals(WorkPlanLogMan.FD_CRMS)) {
			m_oldValue = logMan.getAssociatedCrm(m_oldValue);
			m_newValue = logMan.getAssociatedCrm(m_newValue);
		} else if (m_fieldName.equals(WorkPlanLogMan.FD_DOCS)) {
			m_oldValue = logMan.getAssociatedDoc(m_oldValue);
			m_newValue = logMan.getAssociatedDoc(m_newValue);
		}else if (m_fieldName.equals(WorkPlanLogMan.FD_MEMBERS)) {
			m_oldValue = logMan.getAssociatedMembers(m_oldValue);
			m_newValue = logMan.getAssociatedMembers(m_newValue);
		}else if (m_fieldName.equals(WorkPlanLogMan.FD_REMINDVALUE)) {
			m_oldValue = logMan.getAssociatedRemindValue(m_oldValue,user.getLanguage());
			m_newValue = logMan.getAssociatedRemindValue(m_newValue,user.getLanguage());
		}else if (m_fieldName.equals(WorkPlanLogMan.FD_NEEDREMIND)) {
			m_oldValue = logMan.getAssociatedNeedRemind(m_oldValue,user.getLanguage());
			m_newValue = logMan.getAssociatedNeedRemind(m_newValue,user.getLanguage());
		}else if (m_fieldName.equals(WorkPlanLogMan.FD_URGENTLEVEL)) {
			m_oldValue = logMan.getAssociatedUrgentLevel(m_oldValue,user.getLanguage());
			m_newValue = logMan.getAssociatedUrgentLevel(m_newValue,user.getLanguage());
		}


		isLight = !isLight;
%>
<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
<TD><%=Util.toScreen(workPlanHandler.getWorkPlanName(m_workPlanId), user.getLanguage())%></TD>
<TD><%=m_fieldName%></TD>
<TD><%=m_oldValue%></TD>
<TD><%=m_newValue%></TD>
<TD><%=Util.toScreen(resourceComInfo.getResourcename(m_operatorId), user.getLanguage())%></TD>
<TD><%=m_ipAddress%></TD>
<TD><%=m_logDate%>&nbsp;&nbsp;<%=m_logTime%></TD>
</TR>
<%
	}
%>
	</TABLE>

	  </TD>
		</TR>
		</TABLE>

	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

</BODY>
<SCRIPT language="VBS">
sub onSelectRequest(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/sales/SalesOrderBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0) <> "" then
	spanname.innerHtml = "<A href='/workflow/request/ViewRequest.jsp?requestid="&id(0)&"'>"&id(1)&"</A>"
	inputname.value = id(0)
	else
	spanname.innerHtml = ""
	inputname.value = ""
	end if
	end if
end sub

sub onSelectOperator(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0) <> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value = id(0)
	else
	spanname.innerHtml = ""
	inputname.value = ""
	end if
	end if
end sub
</SCRIPT>

<SCRIPT language="javascript">
function doRefresh() {
    document.all("epagenum").value = 1;
	document.frmmain.submit();
}

function goBack() {
    document.frmmain.action = "/workplan/data/WorkPlanDetail.jsp";
	document.frmmain.submit();
}

function goNextPage() {
	document.all("epagenum").value = <%=pageNum+1%>;
    document.frmmain.submit();
}

function goBackPage() {
	document.all("epagenum").value = <%=pageNum-1%>;
    document.frmmain.submit();
}
</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>