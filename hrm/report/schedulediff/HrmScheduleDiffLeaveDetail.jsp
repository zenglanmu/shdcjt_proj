<%@ page language="java" contentType="text/html; charset=GBK" %>

<%@ page import="weaver.file.ExcelStyle" %>
<%@ page import="weaver.file.ExcelSheet" %>
<%@ page import="weaver.file.ExcelRow" %>

<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>


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
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(16559,user.getLanguage())+"—"+SystemEnv.getHtmlLabelName(20092,user.getLanguage());
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
   String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelName(20092,user.getLanguage()) ;

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
   er.addStringValue(SystemEnv.getHtmlLabelName(742,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(743,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15378,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(828,user.getLanguage()), "Header" ) ; 
   er.addStringValue(SystemEnv.getHtmlLabelName(1881,user.getLanguage()), "Header" ) ;    
%>

<table  class=ListStyle  width="100%" >
  <COLGROUP>
  <COL width="15%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <COL width="15%">
  <COL width="10%">
<tbody>

<tr class=header>
  <td align="center"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td> 
  <td align="center"><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(15378,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(828,user.getLanguage())%></td>
  <td align="center"><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></td>
</tr> 
 

<%  

    String tempDepartmentId="";
	String tempDepartmentName="";
	String tempResourceName="";
	String tempFromDate="";
	String tempFromTime="";
	String tempToDate="";
	String tempToTime="";
	String leaveDays="";
	int leaveType=-1;
	String leaveTypeName="";
	int otherLeaveType=-1;
	String otherLeaveTypeName="";
	String approveStatus="";


    String trClass="DataLight";

	StringBuffer sb=new StringBuffer();
	sb.append(" select c.departmentId,c.lastName,b.fromDate,b.fromTime,b.toDate,b.toTime,b.leaveDays,b.leaveType,b.otherLeaveType,a.status ")
	  .append("   from Workflow_Requestbase a,Bill_BoHaiLeave b,HrmResource c ")
	  .append("  where a.requestId=b.requestId ")
	  .append("    and b.resourceId=c.id ")
	  .append("    and c.status in(0,1,2,3) ");

	if("oracle".equals(RecordSet.getDBType())){
		sb.append(" and c.loginid is not null ");
	}else{
		sb.append(" and c.loginid is not null and c.loginid<>'' ");
	}
		
	if(!fromDate.equals("")){
		sb.append(" and  b.toDate>='").append(fromDate).append("'");
	}

	if(!toDate.equals("")){
		sb.append(" and  b.fromDate<='").append(toDate).append("'");
	}

	if(subCompanyId>0){
		sb.append(" and  c.subCompanyId1=").append(subCompanyId);
	}

	if(departmentId>0){
		sb.append(" and  c.departmentId=").append(departmentId);
	}
		
	if(resourceId>0){
		sb.append(" and  c.id=").append(resourceId);
	}

	sb.append("  order by c.subCompanyId1 asc,c.departmentId asc,c.id asc,b.id asc ");

	RecordSet.executeSql(sb.toString());
    while(RecordSet.next()){

		tempDepartmentId=Util.null2String(RecordSet.getString("departmentId"));
		tempDepartmentName=DepartmentComInfo.getDepartmentname(tempDepartmentId);
		tempResourceName=Util.null2String(RecordSet.getString("lastName"));
		tempFromDate=Util.null2String(RecordSet.getString("fromDate"));
		tempFromTime=Util.null2String(RecordSet.getString("fromTime"));
		tempToDate=Util.null2String(RecordSet.getString("toDate"));
		tempToTime=Util.null2String(RecordSet.getString("toTime"));
		leaveDays=Util.null2String(RecordSet.getString("leaveDays"));
		leaveType=Util.getIntValue(Util.null2String(RecordSet.getString("leaveType")).trim(),-1);
        leaveTypeName=HrmScheduleDiffUtil.getBillSelectName(180,"leaveType",leaveType);
		otherLeaveType=Util.getIntValue(Util.null2String(RecordSet.getString("otherLeaveType")).trim(),-1);
        otherLeaveTypeName=HrmScheduleDiffUtil.getBillSelectName(180,"otherLeaveType",otherLeaveType);
		approveStatus=Util.null2String(RecordSet.getString("status"));

		er = es.newExcelRow() ;
        er.addStringValue(tempDepartmentName);
        er.addStringValue(tempResourceName);
        er.addStringValue(tempFromDate+" "+tempFromTime);
        er.addStringValue(tempToDate+" "+tempToTime);
        er.addStringValue(approveStatus);
        er.addStringValue(leaveDays);
		if(leaveType==3||leaveType==4){
			er.addStringValue(leaveTypeName+"（"+otherLeaveTypeName+"）");
		}else{
			er.addStringValue(leaveTypeName);
		}
%>
<tr class="<%=trClass%>">
  <td><%=tempDepartmentName%></td>
  <td><%=tempResourceName%></td>
  <td><%=tempFromDate+" "+tempFromTime%></td>
  <td><%=tempToDate+" "+tempToTime%></td>
  <td><%=approveStatus%></td>
  <td><%=leaveDays%></td>
<%
		if(leaveType==3||leaveType==4){
%>
  <td><%=leaveTypeName+"（"+otherLeaveTypeName+"）"%></td>
<%
		}else{
%>
  <td><%=leaveTypeName%></td>
<%
		}
%>
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




