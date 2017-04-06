<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15968,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;
String filename = SystemEnv.getHtmlLabelName(15969,user.getLanguage()) ;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());
String olddepartment=Util.fromScreen(request.getParameter("olddepartment"),user.getLanguage());
String oldjobtitle=Util.fromScreen(request.getParameter("oldjobtitle"),user.getLanguage());

String sqlwhere = "";

if(!fromdate.equals("")){
	sqlwhere+=" and t1.changedate>='"+fromdate+"'";
	filename += fromdate;
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.changedate<='"+enddate+"' or t1.changedate is null)";
	filename += "--"+enddate;
}
if(!fromTodate.equals("")){
	sqlwhere+=" and t1.changeenddate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.changeenddate<='"+endTodate+"' and t1.changeenddate is not null)";
  }else{
    sqlwhere+=" and (t1.changeenddate<='"+endTodate+"' and t1.changeenddate is not null and t1.changeenddate <> '')";
  }
}
if(!oldjobtitle.equals("")){
	sqlwhere+=" and t1.oldjobtitleid ="+oldjobtitle+" ";
}

if(!olddepartment.equals("")){
	sqlwhere+=" and t1.oldjobtitleid = t2.id and t2.jobdepartmentid = "+olddepartment+" ";
}

String sql = "";
if(!olddepartment.equals("")){
  sql = "select count(t1.id) from HrmStatusHistory t1,HrmJobtitles t2 where type_n = 3 "+sqlwhere;
}else{
  sql = "select count(t1.id) from HrmStatusHistory t1 where type_n = 3 "+sqlwhere;
}
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "";
if(!olddepartment.equals("")){
  sqlstr = "select t1.* from HrmStatusHistory t1,HrmJobtitles t2 where type_n = 3 "+sqlwhere+" order by changedate desc";
}else{
  sqlstr = "select t1.* from HrmStatusHistory t1 where type_n = 3 "+sqlwhere+" order by changedate desc";
}
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/extend/HrmRpExtend.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
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
<form name=frmmain method=post action="HrmRpExtendDetail.jsp">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="35%">
<col width="15%">
<col width="35%">
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=sep2></TD>
</TR>
<tr>
    <TD ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD class=Field>
    <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
     _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(olddepartment),user.getLanguage())%>"
     name="olddepartment" id="olddepartment" value="<%=olddepartment%>">
   
    </TD>
    <TD ><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></TD>
    <TD class=Field>
    <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
     _displayText="<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(oldjobtitle),user.getLanguage())%>"
     name="oldjobtitle" id="oldjobtitle" value="<%=oldjobtitle%>">
    </TD>    
</tr>
<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
<tr>    
    <td ><%=SystemEnv.getHtmlLabelName(15965,user.getLanguage())%></td>
    <td class=field >
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON  type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>   
    <td width=10%><%=SystemEnv.getHtmlLabelName(15966,user.getLanguage())%></td>
    <td class=field>
    <BUTTON  type="button" class=calendar id=SelectDate onclick=getfromToDate()></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromTodate" value=<%=fromTodate%>>
    －<BUTTON  type="button" class=calendar id=SelectDate onclick=getendToDate()></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>   
</tr>
<TR style="height: 1px"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<tbody>
  <TR class=Header>
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
    </TR>
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15970,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15971,user.getLanguage())%></td>    
  </tr>
  <TR class=Line style="height: 1px"><TD colspan="5" ></TD></TR> 
  <%
   ExcelFile.init ();   
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;   
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(1867,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(124,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(6086,user.getLanguage()) , "Header" ) ;     
   er.addStringValue( SystemEnv.getHtmlLabelName(15970,user.getLanguage()) , "Header" ) ;     
   er.addStringValue( SystemEnv.getHtmlLabelName(15971,user.getLanguage()) , "Header" ) ;     
     
   if(total!=0){
     while(rs.next()){
     String departmentid = JobTitlesComInfo.getDepartmentid(rs.getString("oldjobtitleid"));	
     String newdepartmentid = JobTitlesComInfo.getDepartmentid(rs.getString("newjobtitleid"));
     String resourcename = Util.toScreen(ResourceComInfo.getResourcename(rs.getString("resourceid")),user.getLanguage());	
     String olddepartnemtname = Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
     String oldjobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("oldjobtitleid")),user.getLanguage());     
     String changedate = Util.toScreen(rs.getString("changedate"),user.getLanguage());
     String changeenddate = Util.toScreen(rs.getString("changeenddate"),user.getLanguage());
     
     er = et.newExcelRow() ;
     er.addStringValue(resourcename) ;
     er.addStringValue(olddepartnemtname) ;
     er.addStringValue(oldjobtitlename) ;     
     er.addStringValue(changedate) ;    
     er.addStringValue(changeenddate) ;     
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("resourceid")%>"> <%=resourcename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"> <%=olddepartnemtname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("oldjobtitleid")%>"> <%=oldjobtitlename%></a></TD>    
    <TD><%=changedate%></TD>        
    <TD><%=changeenddate%></TD>        
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}
	} %>  
</table>
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
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
