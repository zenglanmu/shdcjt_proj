<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="requestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></SCRIPT>
</HEAD>
<%
String paraId = Util.null2String(request.getParameter("paraid")) ;

String organizationid = "";
String organizationtype = "";
String occurDate = "";
String amount = "";
String credenceNo = "";
String relatedWFId = "";
String remark = "";

rs.executeSql("SELECT * FROM FnaLoanInfo WHERE id = " + paraId);
if (rs.next()) {
	organizationid = Util.null2String(rs.getString("organizationid"));
	organizationtype = Util.null2String(rs.getString("organizationtype"));
	occurDate = Util.null2String(rs.getString("occurdate"));
	amount = Util.null2String(rs.getString("amount"));
	credenceNo = Util.null2String(rs.getString("debitremark"));
	relatedWFId = Util.null2String(rs.getString("requestid"));
	remark = Util.null2String(rs.getString("remark"));
} else
	return;

    String showname="";
    if(organizationtype.equals("3")){
                                showname = "<A href='/hrm/resource/HrmResource.jsp?id="+organizationid+"'>"+Util.toScreen(ResourceComInfo.getLastname(organizationid),user.getLanguage()) +"</A>";
                                }else if(organizationtype.equals("2")){
                                showname = "<A href='/hrm/company/HrmDepartmentDsp.jsp?id="+organizationid+"'>"+Util.toScreen(DepartmentComInfo.getDepartmentname(organizationid),user.getLanguage()) +"</A>";
                                }else if(organizationtype.equals("1")){
                                showname = "<A href='/hrm/company/HrmSubCompanyDsp.jsp?id="+organizationid+"'>"+Util.toScreen(SubCompanyComInfo.getSubCompanyname(organizationid),user.getLanguage())+"</A>";
                                }
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(1052,user.getLanguage()) + ":&nbsp;"
                            +SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
if (HrmUserVarify.checkUserRight("FinanceWriteOff:Maintenance",user)) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//added by lupeng 2004.2.25
//add the Back menu item to popup menu
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//end
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
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">

	<TABLE class="ViewForm">
	  <COL width="10%">
	  <COL width="37%">
	  <COL width="6%">
	  <COL width="10%">
	  <COL width="37%">    
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(18797,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
        <TD class="Field"><%=showname%></TD>
		<TD></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15394,user.getLanguage())%></TD>
        <TD class="Field"><%=occurDate%></TD>
		<TD></TD>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></TD>
        <TD class="Field"><%if(Util.getDoubleValue(amount,0)<=0){%><%=SystemEnv.getHtmlLabelName(24862,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(24861,user.getLanguage())%><%}%></TD>
        <TD></TD>
        <TD><%=SystemEnv.getHtmlLabelName(15395,user.getLanguage())%></TD>
        <TD class="Field"><%=Math.abs(Util.getDoubleValue(amount,0))%></TD>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR>
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(874,user.getLanguage())%></TD>
        <TD class="Field"><%=credenceNo%></TD>
        <TD></TD>
        <TD><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></TD>
        <TD class="Field"><%=Util.toScreen(requestComInfo.getRequestname(relatedWFId),user.getLanguage())%></TD>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="2"></TD><TD></TD><TD class="Line" colSpan="2"></TD></TR> 
    <TR>
        <TD><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
        <TD class="Field">
            <%=Util.toScreen(remark,user.getLanguage())%></TD>
        <td colspan=4></td>
    </TR>
    <TR style="height: 1px"><TD class="Line" colSpan="5"></TD></TR> 
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
<SCRIPT language="javascript">
function doEdit(){
    document.location.href="FnaPersonalReturnEdit.jsp?paraid=<%=paraId%>";
}

function doDelete(){
    if (!isdel())
        return;

    document.location.href="FnaPersonalReturnOperation.jsp?operation=delete&paraid=<%=paraId%>";
}

function goBack() {
	document.location.href = "FnaPersonalReturn.jsp?organizationtype=<%=organizationtype%>&organizationid=<%=organizationid%>";
}
</SCRIPT>
</BODY>
</HTML>

