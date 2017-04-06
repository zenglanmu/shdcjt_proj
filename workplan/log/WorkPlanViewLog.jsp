<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

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
int pageNum = Util.getIntValue(request.getParameter("vpagenum"), 1);

ArrayList logData = new ArrayList();
logData = logMan.getViewLog(Util.getIntValue(workPlanId, -1),
								Util.getIntValue(trmOperatorId, -1),
								trmStartDate,
								trmEndDate,
								pageNum);

boolean hasNextPage = logMan.hasNextPage();

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(17480,user.getLanguage());
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
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanViewLog.jsp">
		<INPUT type="hidden" name="workid" value="<%=workPlanId%>">
		<INPUT type="hidden" name="vpagenum" value="<%=pageNum%>">
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
			<td>
		<INPUT type="hidden" name="trmoperatorid" class="wuiBrowser" value="<%=trmOperatorId%>"
			_displayText="<%=Util.toScreen(resourceComInfo.getResourcename(trmOperatorId), user.getLanguage())%>"
			_displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>"
				_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
		</TD>
		<TD></TD>
		<TD><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></TD>
		<TD class="field" colspan="4"><button type="button" class="Calendar" id="SelectStartDate" onclick="getDate(trmstartdatespan,trmstartdate)"></BUTTON>
		  <SPAN id="trmstartdatespan"><%=trmStartDate%></SPAN>
		  <INPUT type="hidden" name="trmstartdate" value="<%=trmStartDate%>">&nbsp;-&nbsp;&nbsp;
		  <button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(trmenddatespan,trmenddate)"></BUTTON>
		  <SPAN id="trmenddatespan"><%=trmEndDate%></SPAN>
		  <INPUT type="hidden" name="trmenddate" value="<%=trmEndDate%>"></TD>
		
		</TR>
		<TR style="height:1px;"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="5"></TD></TR>					
	  </TBODY>
	</TABLE>
	</FORM>
	<TABLE class="ListStyle" cellspacing="1" id="result">
    <COLGROUP>
    <COL width="25%">
    <COL width="10%">
    <COL width="15%">
    <COL width="20%">
    <COL width="30%">	
    <TBODY>
    <TR class="Header">
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(16652,user.getLanguage())%></TD>      
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17483,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></TD>
      <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17484,user.getLanguage())%></TD>
	  <TD style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(2061,user.getLanguage())%></TD>	  
    </TR>
	<TR class="Line"><TD colspan="5" style="padding:0;"></TD></TR>
<%	
	boolean isLight = false;
	String[] data;
	String m_workPlanId;
	String m_viewType;
	String m_operatorId;
	String m_ipAddress;
	String m_logDate;
	String m_logTime;	
	for (int i = 0; i < logData.size(); i++) {
		data = (String[]) logData.get(i);

		m_workPlanId = data[0];
		m_viewType = data[1];
		m_operatorId = data[2];
		m_ipAddress = data[3];
		m_logDate = data[4];
		m_logTime = data[5];

		if (m_viewType.equals(WorkPlanLogMan.TP_CREATE))
			m_viewType = SystemEnv.getHtmlLabelName(82,user.getLanguage());
		else if (m_viewType.equals(WorkPlanLogMan.TP_EDIT))
			m_viewType = SystemEnv.getHtmlLabelName(93,user.getLanguage());
		else if (m_viewType.equals(WorkPlanLogMan.TP_VIEW))
			m_viewType = SystemEnv.getHtmlLabelName(367,user.getLanguage());
		else if (m_viewType.equals(WorkPlanLogMan.TP_DELETE))
			m_viewType = SystemEnv.getHtmlLabelName(91,user.getLanguage());
		else
			m_viewType = SystemEnv.getHtmlLabelName(400,user.getLanguage());

		isLight = !isLight;
%>
<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">
<TD><%=Util.toScreen(workPlanHandler.getWorkPlanName(m_workPlanId), user.getLanguage())%></TD>
<TD><%=m_viewType%></TD>
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
<SCRIPT language="javascript">
function doRefresh() {
    document.all("vpagenum").value = 1;
	document.frmmain.submit();
}

function goBack() {
    document.frmmain.action = "/workplan/data/WorkPlanDetail.jsp";
	document.frmmain.submit();
}

function goNextPage() {
	document.all("vpagenum").value = <%=pageNum+1%>;
    document.frmmain.submit();
}

function goBackPage() {
	document.all("vpagenum").value = <%=pageNum-1%>;
    document.frmmain.submit();
}
</SCRIPT>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>