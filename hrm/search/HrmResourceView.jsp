<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
                     
String projectable = "1" ;
String crmable = "1" ;
String itemable = "1" ;
String docable = "1" ;
String workflowable = "1" ;
String workplanable = "1" ;
String subordinateable = "1" ;
String trainable = "1" ;
String budgetable = "1" ;
String fnatranable = "1" ;
String id  = Util.null2String(request.getParameter("id")) ;
//added by hubo,20060113
if(id.equals("")) id=String.valueOf(user.getUID());
String theid = id ;
String srcid  = Util.null2String(request.getParameter("srcid")) ;
if(srcid.equals("")) RecordSet.executeProc("HrmUserDefine_SelectByID",id);
else RecordSet.executeProc("HrmUserDefine_SelectByID",srcid);
if(RecordSet.next()){ 
	projectable = Util.null2String(RecordSet.getString("projectable")) ;
	crmable = Util.null2String(RecordSet.getString("crmable")) ;
	itemable = Util.null2String(RecordSet.getString("itemable")) ;
	docable = Util.null2String(RecordSet.getString("docable")) ;
	workflowable = Util.null2String(RecordSet.getString("workflowable")) ;
	subordinateable = Util.null2String(RecordSet.getString("subordinateable")) ;
	trainable = Util.null2String(RecordSet.getString("trainable")) ;
	budgetable = Util.null2String(RecordSet.getString("budgetable")) ;
	fnatranable = Util.null2String(RecordSet.getString("fnatranable")) ;
	workplanable = Util.null2String(RecordSet.getString("workplanable")) ;
}
RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();
String firstname = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage()) ;			/*名*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;	
String telephone = Util.toScreen(RecordSet.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/
String locationid = Util.toScreen(RecordSet.getString("locationid"),user.getLanguage()) ;		
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
String costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;		/*所属成本中心*/
String managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;			/*经理*/
String jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;
String assistantid = Util.toScreen(RecordSet.getString("assistantid"),user.getLanguage()) ;

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage()) + " : " + firstname + " " + lastname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(343,user.getLanguage())+",/hrm/userdefine/HrmUserDefine.jsp?returnurl=my,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">

<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
 <TABLE class=ListStyle cellspacing=1 id=tblReport>
    <colgroup> 
    <col valign=top align=left width="8%"> 
    <col valign=top align=left width="25%"> 
    <col valign=top align=left width="30%"> 
    <col valign=top align=left width="20%"> 
    <col valign=top align=left width="17%"> 
    <tbody> 
    <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(6008,user.getLanguage())%></th>
    </tr>

    <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(547,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(2120,user.getLanguage())%></th>
    </tr>

    <tr class=DataLight> 
      <td><%=id%></td>
      <td><a href="/hrm/resource/HrmResource.jsp?id=<%=id%>"><%=firstname%>&nbsp<%=lastname%></a></td>
      <td><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a></td>
      <td><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>"><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></a></td>
      <td><a href="/hrm/resource/HrmResource.jsp?id=<%=assistantid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(assistantid),user.getLanguage())%></td>
    </tr>
   <tr class=DataLight> 
      <td><% if((currentdate.compareTo(RecordSet.getString("startdate"))>=0 || RecordSet.getString("startdate").equals(""))&& (currentdate.compareTo(RecordSet.getString("enddate"))<=0 || RecordSet.getString("enddate").equals(""))){%>
      <img src="/images/BacoCheck.gif"><%}%>
	  <% if(HrmUserVarify.isUserOnline(RecordSet.getString("id"))) {%><img src="/images/State_LoggedOn.gif"><%}%>
	  </td>
      <td><%=telephone%></td>
      <td><a href="mailto:<%=email%>"><%=email%></a></td>
      <td><a href="/hrm/location/HrmLocationEdit.jsp?id=<%=locationid%>"><%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%></a></td>
      <td><a href="/hrm/resource/HrmResource.jsp?id=<%=managerid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%></a></td>
    </tr>
	<TR class=DataDark>
    <TD align=right colSpan=5>
    <% if(workplanable.equals("1")) {%>
    <a href="/workplan/data/WorkPlan.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></a>&nbsp;&nbsp; 
      <%}%> 
	<% if(workflowable.equals("1")) {%><A href="/workflow/request/RequestView.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<% if(docable.equals("1")) {%><A href="/docs/search/DocSearchTemp.jsp?hrmresid=<%=id%>&docstatus=6"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<%if(isgoveproj==0){%>
	<% if(projectable.equals("1")) {%><A href="/proj/search/SearchOperation.jsp?member=<%=id%>"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<% if((software.equals("ALL") || software.equals("CRM")) && crmable.equals("1")) {%><A href="/CRM/search/SearchOperation.jsp?destination=myAccount&resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<%}%>
	<%if(software.equals("ALL") && itemable.equals("1")) {%><A href="/cpt/search/SearchOperation.jsp?resourceid=<%=id%>&isdata=2"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>

	<% if(subordinateable.equals("1")) {%>
	<% if(srcid.equals("")) {%>
      <a href="HrmResourceView.jsp?id=<%=id%>&srcid=<%=id%>">
	  <%} else {%>
	  <a href="HrmResourceView.jsp?id=<%=id%>&srcid=<%=srcid%>">
	  <% } %>
	<%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<%// if(trainable.equals("1")) {%><!-- a href="#"><%=SystemEnv.getHtmlLabelName(532,user.getLanguage())%></a>&nbsp;&nbsp;< -->
      <%// }%>
	<%if(isgoveproj==0){%>
	<% if(budgetable.equals("1")) {%><A href="/fna/report/budget/FnaBudgetResourceDetail.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<% if(fnatranable.equals("1")) {%><A href="/fna/report/expense/FnaExpenseResourceDetail.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></A>&nbsp;&nbsp;<%}%>
	<%}%>
	</TD></TR>
  </table>
<%
RecordSet.executeProc("HrmResource_SCountBySubordinat",id);
RecordSet.next();
String subordinatescount = RecordSet.getString(1) ;
%>
<br>
<TABLE class=ListStyle cellspacing=1 >
  <tbody> 
  <tr class=Header>
    <th colspan=5><%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%>&nbsp;(<%=subordinatescount%>)</th>
  </tr>
  </tbody>
</table>

 <TABLE class=ListStyle cellspacing=1 id=tblReport>
  <colgroup> <col valign=top align=left width="8%"> 
  <col valign=top align=left width="25%"> 
  <col valign=top align=left width="30%"> 
  <col valign=top align=left width="20%"> 
  <col valign=top align=left width="17%"> 
  <tbody> 
  <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(6008,user.getLanguage())%></th>
    </tr>
    
    <tr class=Header> 
      <th><%=SystemEnv.getHtmlLabelName(547,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(378,user.getLanguage())%></th>
      <th><%=SystemEnv.getHtmlLabelName(2120,user.getLanguage())%></th>
    </tr>
  

<%
RecordSet.executeProc("HrmResource_SelectByManagerID",id);
while(RecordSet.next()) {
id = Util.toScreen(RecordSet.getString("id"),user.getLanguage()) ;
firstname = Util.toScreen(RecordSet.getString("firstname"),user.getLanguage()) ;			/*名*/
lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;	
telephone = Util.toScreen(RecordSet.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/
locationid = Util.toScreen(RecordSet.getString("locationid"),user.getLanguage()) ;		
departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;		/*所属成本中心*/
managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;			/*经理*/
jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;
assistantid = Util.toScreen(RecordSet.getString("assistantid"),user.getLanguage()) ;
%>
  <tr class=DataLight> 
    <td><%=id%></td>
    <td><a href="/hrm/resource/HrmResource.jsp?id=<%=id%>"><%=firstname%>&nbsp<%=lastname%></a></td>
    <td><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></a></td>
    <td><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=jobtitle%>"><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></a></td>
    <td><a href="/hrm/resource/HrmResource.jsp?id=<%=assistantid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(assistantid),user.getLanguage())%></td>
  </tr>
  <tr class=DataLight> 
    <td>
      <% if((currentdate.compareTo(RecordSet.getString("startdate"))>=0 || RecordSet.getString("startdate").equals(""))&& (currentdate.compareTo(RecordSet.getString("enddate"))<=0 || RecordSet.getString("enddate").equals(""))){%>
      <img src="/images/BacoCheck.gif"><%}%>
	  <% if(HrmUserVarify.isUserOnline(RecordSet.getString("id"))) {%><img src="/images/State_LoggedOn.gif"><%}%>
    </td>
    <td><%=telephone%></td>
    <td><a href="mailto:<%=email%>"><%=email%></a><!-- a href="/hrm/company/HrmCostcenterDsp.jsp?id=<%=costcenterid%>"><%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%></a--></td>
    <td><a href="/hrm/location/HrmLocationEdit.jsp?id=<%=locationid%>"><%=Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage())%></a></td>
    <td><a href="/hrm/resource/HrmResource.jsp?id=<%=managerid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage())%></a></td>
  </tr>
  <tr class=DataDark> 
    <td align=right colspan=5>
    <% if(workplanable.equals("1")) {%>
    <a href="/workplan/data/WorkPlan.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(407,user.getLanguage())%></a>&nbsp;&nbsp; 
      <%}%> 
      <% if(workflowable.equals("1")) {%>
      <a href="/workflow/request/RequestView.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
      <% if(docable.equals("1")) {%>
      <a href="/docs/search/DocSearchTemp.jsp?hrmresid=<%=id%>&docstatus=6"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
	  <%if(isgoveproj==0){%>
      <% if(projectable.equals("1")) {%>
      <A href="/proj/search/SearchOperation.jsp?member=<%=id%>"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
      <% if((software.equals("ALL") || software.equals("CRM")) && crmable.equals("1")) {%>
      <A href="/CRM/search/SearchOperation.jsp?destination=myAccount&resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
	  <%}%>
      <%if(software.equals("ALL") && itemable.equals("1")) {%>
      <a href="/cpt/search/SearchOperation.jsp?resourceid=<%=id%>&isdata=2"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
      <% if(subordinateable.equals("1")) {%>
	  <% if(srcid.equals("")) {%>
      <a href="HrmResourceView.jsp?id=<%=id%>&srcid=<%=theid%>">
	  <%} else {%>
	  <a href="HrmResourceView.jsp?id=<%=id%>&srcid=<%=srcid%>">
	  <% } %>
	  <%=SystemEnv.getHtmlLabelName(442,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
      <%// if(trainable.equals("1")) {%>
      <!-- a href="#"><%=SystemEnv.getHtmlLabelName(532,user.getLanguage())%></a>&nbsp;&nbsp;< -->
      <%// }%>
	  <%if(isgoveproj==0){%>
      <% if(budgetable.equals("1")) {%>
      <A href="/fna/report/budget/FnaBudgetResourceDetail.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(386,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
      <% if(fnatranable.equals("1")) {%>
      <A href="/fna/report/expense/FnaExpenseResourceDetail.jsp?resourceid=<%=id%>"><%=SystemEnv.getHtmlLabelName(428,user.getLanguage())%></a>&nbsp;&nbsp;
      <%}%>
      <%}%>
    </td>
  </tr>
<%}%>
</table>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>

</table>
</BODY>
</HTML>