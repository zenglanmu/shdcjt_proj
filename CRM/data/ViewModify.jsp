<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="AddressTypeComInfo" class="weaver.crm.Maint.AddressTypeComInfo" scope="page" />

<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String log=Util.null2String(request.getParameter("log"));

RecordSetM.executeProc("CRM_Modify_Select",CustomerID);

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(264,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log="+log+"&CustomerID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<DIV class=HdrProps></DIV>

<%
if(RecordSetM.getCounts()<=0)
{%>
<p><%=SystemEnv.getHtmlNoteName(30,user.getLanguage())%>£¡</p>
<%}
else
{%>
  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="25%">
  		<COL width="25%">
  		<COL width="25%">
		<COL width="25%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>)</th>
	      <th><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(612,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(563,user.getLanguage())%></th>
	    </TR>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(424,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%>IP</th>
	    </TR>
<%
	boolean isLight = false;
	while(RecordSetM.next())
	{
		if(isLight)
		{%>	
		<TR CLASS=DataDark>
<%		}else{%>
		<TR CLASS=DataLight>
<%		}%>
		  <td width="25%">
			<%if(RecordSetM.getInt("tabledesc")==1){%><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%>
			<%} else if(RecordSetM.getInt("tabledesc")==2){%>
			<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>(<a href="/CRM/data/ViewContacter.jsp?ContacterID=<%=RecordSetM.getString("type")%>"><%=Util.toScreen(CustomerContacterComInfo.getCustomerContactername(RecordSetM.getString("type")),user.getLanguage())%></a>)
			<%} else if(RecordSetM.getInt("tabledesc")==3){%>
			<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>(<a href="/CRM/data/ViewAddressDetail.jsp?CustomerID=<%=RecordSetM.getString("customerid")%>&TypeID=<%=RecordSetM.getString("type")%>"><%=Util.toScreen(AddressTypeComInfo.getAddressTypename(RecordSetM.getString("type")),user.getLanguage())%></a>)
			<%}%>
		  </td>
		  <td width="25%"><%=Util.toScreen(RecordSetM.getString("fieldname"),user.getLanguage())%></td>
		  <td width="25%"><%=Util.toScreen(RecordSetM.getString("original"),user.getLanguage())%></td>
		  <td width="25%"><%=Util.toScreen(RecordSetM.getString("modified"),user.getLanguage())%></td>
        </TR>
<%		if(isLight)
		{%>	
		<TR CLASS=DataDark>
<%		}else{%>
		<TR CLASS=DataLight>
<%		}%>
		  <td width="25%"><%=RecordSetM.getString("modifydate")%></td>
		  <td width="25%"><%=RecordSetM.getString("modifytime")%></td>
		  <td width="25%">
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetM.getString("modifier")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("modifier")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("modifier")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("modifier")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetM.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetM.getString("modifier")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetM.getString("modifier")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetM.getString("modifier")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
				</td>
		  <td width="25%"><%=RecordSetM.getString("clientip")%></td>
        </TR>
<%
		isLight = !isLight;
	}%>
	  </TBODY>
	  </TABLE>
<%}%>

<SCRIPT language="JavaScript">
function goBack() {
	window.history.go(-1);
}
</SCRIPT>
</body>
</html>
