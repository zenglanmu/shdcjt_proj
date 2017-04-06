<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.file.ExcelStyle" %>
<%@ page import="weaver.file.ExcelSheet" %>
<%@ page import="weaver.file.ExcelRow" %>

<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="HrmScheduleDiffDetNoSignManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffDetNoSignManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%@ include file="/systeminfo/init.jsp" %>

<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>

<%

String fromDate = Util.null2String(request.getParameter("fromDate"));
String toDate = Util.null2String(request.getParameter("toDate"));

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);
int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);

//安全检查  
//查询的开始日期和结束日期必须有值且长度为10
if(fromDate==null||fromDate.trim().equals("")||fromDate.length()!=10
 ||toDate==null||toDate.trim().equals("")||toDate.length()!=10){
	return;
}
//非考勤管理员只能看到自己的记录
if(!HrmUserVarify.checkUserRight("BohaiInsuranceScheduleReport:View", user)){
	resourceId=user.getUID();
}

//根据resourceId给departmentId、subCompanyId赋值
if(resourceId>0){
	departmentId=Util.getIntValue(ResourceComInfo.getDepartmentID(""+resourceId),0);
}

//根据departmentId给、subCompanyId赋值
if(departmentId>0){
	subCompanyId=Util.getIntValue(DepartmentComInfo.getSubcompanyid1(""+departmentId),0);
}
%>

<%

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16559,user.getLanguage())+"—"+SystemEnv.getHtmlLabelName(20091,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='HrmScheduleDiffReportResult.jsp?fromDate="+fromDate+"&toDate="+toDate+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&resourceId="+resourceId+"',_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep;

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

<%
   ExcelFile.init ();
   String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelName(20091,user.getLanguage()) ;

   ExcelFile.setFilename(fileName) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle excelStyle = ExcelFile.newExcelStyle("Header") ;
   excelStyle.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   excelStyle.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   excelStyle.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   excelStyle.setAlign(ExcelStyle.WeaverHeaderAlign) ;

   ExcelSheet es = ExcelFile.newExcelSheet(fileName) ;
   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   //es.addColumnwidth(8000) ;

%>

<%
    ExcelRow er  = es.newExcelRow() ;
    er.addStringValue(fileName) ;
%>

<table  border=0 width="100%" >
<tbody>
<tr>
  <td align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
</tbody>
</table>

<%
   er  = es.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header" ) ; 
   er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(602,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(97,user.getLanguage()), "Header" ) ;
%>

<table  class=ListStyle  width="100%" >
  <COLGROUP>
  <COL width="30%">
  <COL width="25%">
  <COL width="20%">
  <COL width="25%">
<tbody>

<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
</tr> 
 

<%  

	String tempDepartmentName="";
	String tempResourceName="";
	String tempStatusName="";
	String tempCurrentDate="";

    String trClass="DataLight";

    HrmScheduleDiffDetNoSignManager.setUser(user);
    List scheduleList=HrmScheduleDiffDetNoSignManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		tempDepartmentName=Util.null2String((String)scheduleMap.get("departmentName"));
		tempResourceName=Util.null2String((String)scheduleMap.get("resourceName"));
		tempStatusName=Util.null2String((String)scheduleMap.get("statusName"));
		tempCurrentDate=Util.null2String((String)scheduleMap.get("currentDate"));

		er = es.newExcelRow() ;
        er.addStringValue(tempDepartmentName);
        er.addStringValue(tempResourceName);
        er.addStringValue(tempStatusName);
        er.addStringValue(tempCurrentDate);

%>
<tr class="<%=trClass%>">
  <td><%=tempDepartmentName%></td>
  <td><%=tempResourceName%></td>
  <td><%=tempStatusName%></td>
  <td><%=tempCurrentDate%></td>
</tr>
<%    
        if(trClass.equals("DataLight")){
	        trClass="DataDark";
        }else{
	        trClass="DataLight";
		}
 } 
%>
</tbody>
</table>

<table class=ViewForm border=0 width="100%">
<tbody>

<tr height=15>
<td>&nbsp;</td>
</tr>
<tr>
  <td align="center" >
  [<a href="HrmScheduleDiffSignInDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20241,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffSignOutDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20242,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffBeLateDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20088,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffLeaveEarlyDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20089,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffAbsentFromWorkDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20090,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffNoSignDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20091,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffLeaveDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffEvectionDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20093,user.getLanguage())%></a>]
  [<a href="HrmScheduleDiffOutDetail.jsp?fromDate=<%=fromDate%>&toDate=<%=toDate%>&subCompanyId=<%=subCompanyId%>&departmentId=<%=departmentId%>&resourceId=<%=resourceId%>"><%=SystemEnv.getHtmlLabelName(20094,user.getLanguage())%></a>]
  </td>
</tr>


</tbody>
</table>

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