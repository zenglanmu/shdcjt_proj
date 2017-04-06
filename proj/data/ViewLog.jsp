<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetL" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String log=Util.null2String(request.getParameter("log"));

RecordSetL.executeProc("Prj_Log_Select",ProjID);

RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage())+" - <a href='/proj/data/ViewModify.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"</a>"+" - "+SystemEnv.getHtmlLabelName(101,user.getLanguage())+":<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goSeeProjectBack(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name="form">
<input type="hidden" name="projid" value="<%=ProjID%>">
</form>
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


	  <TABLE class=liststyle cellspacing=1 >
        <COLGROUP>
		<COL width="13%">
  		<COL width="13%">
  		<COL width="13%">
		<COL width="13%">
  		<COL width="14%">
  		<COL width="14%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%> IP</th>
	      <th><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></th>
	    </TR>
			<tr class="Line">
		<th ></th>
		<th></th>
		<th ></th>
		<th ></th>
		<th ></th>
		<th ></th>
		</tr>
<%
boolean isLight = false;
int nLogCount=0;
while(RecordSetL.next())
{
	nLogCount++;
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetL.getString("submitdate")%></TD>
          <TD><%=RecordSetL.getString("submittime")%></TD>
          <TD>
	<%if(!user.getLogintype().equals("2")) {%>
		<%if(!RecordSetL.getString("submitertype").equals("2")) {%>		  
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetL.getString("submiter")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetL.getString("submiter")),user.getLanguage())%></a>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetL.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetL.getString("submiter")),user.getLanguage())%></a>		
		<%}%>
	<%}else{%>
		<%if(!RecordSetL.getString("submitertype").equals("2")) {%>		  
			<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetL.getString("submiter")),user.getLanguage())%>
		<%}else{%>
			<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetL.getString("submiter")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSetL.getString("submiter")),user.getLanguage())%></a>		
		<%}%>	
	<%}%>
		  </TD>
          <TD><%=RecordSetL.getString("clientip")%></TD>
		  <TD>
<%
	String strTemp1 = RecordSetL.getString("logtype");
	String strTemp2 = "";
	if(strTemp1.substring(0,1).equals("n"))
	{
		%><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%
	}
	else
	{
		%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%><%
	}
		%>&nbsp;<%
%>
		  </TD>
          <TD>
           <a href="/docs/docs/DocDsp.jsp?id=<%=RecordSetL.getString("documentid")%>"><%=Util.toScreen(DocComInfo.getDocname(RecordSetL.getString("documentid")),user.getLanguage())%></a>
          </TD>
<%
	isLight = !isLight;
}
%>
	  </TBODY>
	  </TABLE>
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
<script language="javascript">
function goSeeProjectBack(){
window.location.href="/proj/data/ViewProject.jsp?ProjID="+document.form.projid.value;
}

</script>
</HTML>
