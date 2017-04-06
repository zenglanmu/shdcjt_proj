<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.file.ExcelStyle" %>
<%@ page import="weaver.file.ExcelSheet" %>
<%@ page import="weaver.file.ExcelRow" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="HrmScheduleDiffManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffManager" scope="page"/>
<TABLE class=Shadow>
		<tr>
		<td valign="top">

<%
Calendar today = Calendar.getInstance ();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                   + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                   + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);

String fromDate = Util.null2String(request.getParameter("fromDate"));
String toDate = Util.null2String(request.getParameter("toDate"));

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);
int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
   ExcelFile.init ();
   String fileName = fromDate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+toDate+" "+SystemEnv.getHtmlLabelName(20078,user.getLanguage()) ;

   ExcelFile.setFilename(fileName) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle excelStyle = ExcelFile.newExcelStyle("Header") ;
   //excelStyle.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   excelStyle.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   excelStyle.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   excelStyle.setAlign(ExcelStyle.WeaverHeaderAlign) ;

   ExcelSheet es = ExcelFile.newExcelSheet(fileName) ;
   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   //es.addColumnwidth(8000) ;

%>

<%
    User tempUser=new User();
    String sql="select id,lastname,subcompanyid1,countryid from HrmResource where 1=1 ";    
    if(resourceId>0)
    	   sql=sql+" and id="+resourceId;
    if(departmentId>0)
    	   sql=sql+" and departmentid="+departmentId; 
    if(subCompanyId>0)
 	   sql=sql+" and subcompanyid1="+subCompanyId; 
    RecordSet recordSet=new RecordSet();
    recordSet.execute(sql);
    if(recordSet.next()){
    	tempUser.setUserSubCompany1(Util.getIntValue(recordSet.getString("subcompanyid1")));
    	tempUser.setCurrencyid(recordSet.getString("countryid"));
    }
    HrmScheduleDiffManager.setUser(tempUser);
    //HrmScheduleDiffManager.setUser(user);
    int totalWorkingDays=HrmScheduleDiffManager.getTotalWorkingDays(fromDate,toDate);
    String totalWorkingDaysDesc=SystemEnv.getHtmlLabelName(18861,user.getLanguage())+totalWorkingDays+SystemEnv.getHtmlLabelName(20079,user.getLanguage());

    ExcelRow er  = es.newExcelRow() ;
    er.addStringValue(fileName, "Header" ) ;

    er  = es.newExcelRow() ;
    er.addStringValue(totalWorkingDaysDesc, "Header" ) ;
%>

<table  border=0 width="100%" >
<tbody>
<tr>
  <td align="center" ><font size=4><b><%=fileName%></b></font></td>
</tr>
<tr>
  <td align="right" ><%=totalWorkingDaysDesc%></td>
</tr>
</tbody>
</table>

<%
   er  = es.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15390,user.getLanguage()), "Header" ) ; 
   er.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20081,user.getLanguage())+"（A）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20081,user.getLanguage())+"（B）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20082,user.getLanguage())+"（A）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20082,user.getLanguage())+"（B）"+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1919,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(1920,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20083,user.getLanguage())+"（A）"+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20083,user.getLanguage())+"（B）"+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20084,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20085,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(20086,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(18929,user.getLanguage())+"）", "Header" ) ;
   er.addStringValue(SystemEnv.getHtmlLabelName(454,user.getLanguage()), "Header" ) ;
   
%>

<table  border=1  bordercolor=black style="border-collapse:collapse;" width="100%" >
  <COLGROUP>
  <COL width="12%">
  <COL width="12%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="6%">
  <COL width="10%">
<tbody>
<tr>
  <td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></td>
  <td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
  <td colspan=11 align="center"><%=SystemEnv.getHtmlLabelName(20080,user.getLanguage())%></td> 
  <td rowspan=3 align="center"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>  
</tr>

<tr>
  <td colspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
  <td colspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20082,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td> 
  <td colspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20083,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td> 
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20084,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
  <td rowspan=2 align="center"><%=SystemEnv.getHtmlLabelName(20086,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(18929,user.getLanguage())%>）</td>
</tr> 
 
<tr>
  <td align="center">A</td>
  <td align="center">B</td>
  <td align="center">A</td>
  <td align="center">B</td>
  <td align="center">A</td>
  <td align="center">B</td> 
</tr>
 
<%  
   
   


   



    List scheduleList=HrmScheduleDiffManager.getScheduleList(fromDate,toDate,subCompanyId,departmentId,resourceId);
    Map scheduleMap=null;

	String departmentName="";
	String resourceName="";
	String beLateA="";
	String beLateB="";
	String leaveEarlyA="";
	String leaveEarlyB="";
	String sickLeave="";
	String privateAffairLeave="";
	String otherLeaveA="";
	String otherLeaveB="";
	String evection="";
	String tempOut="";
	String absentFromWork="";
	String noSign="";
	String remark="";

    for(int i=0 ; i<scheduleList.size() ; i++ ) {

		scheduleMap=(Map)scheduleList.get(i);
		departmentName=Util.null2String((String)scheduleMap.get("departmentName"));
		resourceName=Util.null2String((String)scheduleMap.get("resourceName"));
		beLateA=Util.null2String((String)scheduleMap.get("beLateA"));
		beLateB=Util.null2String((String)scheduleMap.get("beLateB"));
		leaveEarlyA=Util.null2String((String)scheduleMap.get("leaveEarlyA"));
		leaveEarlyB=Util.null2String((String)scheduleMap.get("leaveEarlyB"));
		sickLeave=Util.null2String((String)scheduleMap.get("sickLeave"));
		privateAffairLeave=Util.null2String((String)scheduleMap.get("privateAffairLeave"));
		otherLeaveA=Util.null2String((String)scheduleMap.get("otherLeaveA"));
		otherLeaveB=Util.null2String((String)scheduleMap.get("otherLeaveB"));
		evection=Util.null2String((String)scheduleMap.get("evection"));
		tempOut=Util.null2String((String)scheduleMap.get("out"));
		absentFromWork=Util.null2String((String)scheduleMap.get("absentFromWork"));
		noSign=Util.null2String((String)scheduleMap.get("noSign"));
		remark=Util.null2String((String)scheduleMap.get("remark"));


		er = es.newExcelRow() ;
        er.addStringValue(departmentName);
        er.addStringValue(resourceName);
        er.addStringValue(beLateA);
        er.addStringValue(beLateB);
        er.addStringValue(leaveEarlyA);
        er.addStringValue(leaveEarlyB);
        er.addStringValue(sickLeave);
        er.addStringValue(privateAffairLeave);
        er.addStringValue(otherLeaveA);
        er.addStringValue(otherLeaveB);
        er.addStringValue(evection);
//        er.addStringValue(tempOut);
        er.addStringValue(absentFromWork);
        er.addStringValue(noSign);
        er.addStringValue(remark);

%>
<tr>
  <td><%=departmentName%></td>
  <td><%=resourceName%></td>
  <td align="right"><%=beLateA%></td>
  <td align="right"><%=beLateB%></td>
  <td align="right"><%=leaveEarlyA%></td>
  <td align="right"><%=leaveEarlyB%></td>
  <td align="right"><%=sickLeave%></td>
  <td align="right"><%=privateAffairLeave%></td>
  <td align="right"><%=otherLeaveA%></td>
  <td align="right"><%=otherLeaveB%></td>
  <td align="right"><%=evection%></td>
<!--  <td align="right"><%=tempOut%></td>-->
  <td align="right"><%=absentFromWork%></td>
  <td align="right"><%=noSign%></td>
  <td align="right"><%=remark%></td>

</tr>
<%    
 } 
%>
</tbody>
</table>

<%
    er  = es.newExcelRow() ;
    er.addStringValue(SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate) ;

    er  = es.newExcelRow() ;
    er.addStringValue(SystemEnv.getHtmlLabelName(85,user.getLanguage())+":") ;


	if(user.getLanguage()==8){
        er  = es.newExcelRow() ;
        er.addStringValue("Be Late:A:before 9 o'clock,B:after 9 o'clock(include 9 o'clock);") ;

        er  = es.newExcelRow() ;
        er.addStringValue("Leave Early:A:after 17 o'clock,B:before 17 o'clock(include 17 o'clock);") ;

        er  = es.newExcelRow() ;
        er.addStringValue("Other Leave Type:A:has salary;B:no salary.") ;
	}else{
        er  = es.newExcelRow() ;
        er.addStringValue("迟到：A：09点以前迟到，B：09点后迟到(包括09点)；") ;

        er  = es.newExcelRow() ;
        er.addStringValue("早退：A：17点以后早退，B：17点前早退（包括17点）；") ;

        er  = es.newExcelRow() ;
        er.addStringValue("其他假别：A：带薪假；B：非带薪。") ;
	}

%>


<table class=ViewForm border=0 width="100%">
<tbody>

<tr>
  <td align="right" ><%=SystemEnv.getHtmlLabelName(20087,user.getLanguage())+"："+currentDate%></td>
</tr>
<TR class=Title> 
<TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>:</TH>
</TR>
<tr>
  <td align="left" >
<%if(user.getLanguage()==8){%>
Be Late:A:before 9 o'clock,B:after 9 o'clock(include 9 o'clock);<br>
Leave Early:A:after 17 o'clock,B:before 17 o'clock(include 17 o'clock);<br>
Other Leave Type:A:has salary;B:no salary.<br>
<%}else{%>
迟到：A：09点以前迟到，B：09点后迟到(包括09点)；<br>
早退：A：17点以后早退，B：17点前早退（包括17点）；<br>
其他假别：A：带薪假；B：非带薪。<br>
<%}%>
  </td>
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