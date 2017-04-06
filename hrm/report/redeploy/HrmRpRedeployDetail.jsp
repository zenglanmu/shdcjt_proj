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
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15997,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;
String filename = SystemEnv.getHtmlLabelName(15998,user.getLanguage());

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String olddepartment=Util.fromScreen(request.getParameter("olddepartment"),user.getLanguage());
String newdepartment=Util.fromScreen(request.getParameter("newdepartment"),user.getLanguage());

String oldjobtitle=Util.fromScreen(request.getParameter("oldjobtitle"),user.getLanguage());
String newjobtitle=Util.fromScreen(request.getParameter("newjobtitle"),user.getLanguage());
String joblevelfrom=Util.fromScreen(request.getParameter("joblevelfrom"),user.getLanguage());
String joblevelto=Util.fromScreen(request.getParameter("joblevelto"),user.getLanguage());

String newjoblevelfrom=Util.fromScreen(request.getParameter("newjoblevelfrom"),user.getLanguage());
String newjoblevelto=Util.fromScreen(request.getParameter("newjoblevelto"),user.getLanguage());
String sqlwhere = "";
/*
Calendar todaycal = Calendar.getInstance ();
String year = Util.add0(todaycal.get(Calendar.YEAR), 4);
if(fromdate.equals("")&&enddate.equals("")){
enddate = year+"-12-31";
fromdate = year+"-01-01";
}*/
if(!fromdate.equals("")){
	sqlwhere+=" and t1.changedate>='"+fromdate+"'";
	filename +=fromdate;
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.changedate<='"+enddate+"' or t1.changedate is null)";
	filename += "--"+enddate;
}
if(!joblevelfrom.equals("")){
	sqlwhere+=" and t1.oldjoblevel>="+joblevelfrom+" ";
}
if(!joblevelto.equals("")){
	sqlwhere+=" and (t1.oldjoblevel<="+joblevelto+" or t1.oldjoblevel is null) ";
}
if(!newjoblevelfrom.equals("")){
	sqlwhere+=" and t1.newjoblevel>="+newjoblevelfrom+" ";
}
if(!newjoblevelto.equals("")){
	sqlwhere+=" and (t1.newjoblevel<="+newjoblevelto+" or t1.newjoblevel is null) ";
}
if(!oldjobtitle.equals("")){
	sqlwhere+=" and t1.oldjobtitleid ="+oldjobtitle+" ";
}
if(!newjobtitle.equals("")){
	sqlwhere+=" and t1.newjobtitleid ="+newjobtitle+" ";
}
if(!olddepartment.equals("")){
	sqlwhere+=" and t1.oldjobtitleid = t2.id and t2.jobdepartmentid = "+olddepartment+" ";
}
if(!newdepartment.equals("")){
	sqlwhere+=" and t1.newjobtitleid = t2.id and t2.jobdepartmentid = "+newdepartment+" ";
}
String sql = "";
if(!oldjobtitle.equals("")||!newjobtitle.equals("")||!olddepartment.equals("")||!newdepartment.equals("")){
   sql = "select count(t1.id) from HrmStatusHistory t1,HrmJobtitles t2 where type_n = 4 "+sqlwhere;
}else{
   sql = "select count(t1.id) from HrmStatusHistory t1 where type_n = 4 "+sqlwhere;
}
//out.println(sql);
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "select t1.* from HrmStatusHistory t1,HrmJobtitles t2 where type_n = 4 and t1.newjobtitleid = t2.id "+sqlwhere+" order by changedate desc";
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/redeploy/HrmRpRedeploy.jsp,_self} " ;
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
<form name=frmmain method=post action="HrmRpRedeployDetail.jsp">
<table class=ViewForm>
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=line1></TD>
</TR>
<tr>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(15481,user.getLanguage())%></TD>
    <TD class=Field>
    <button class=Browser onClick="onShowOldDepartment()"></button> 
    <span class=inputStyle id=olddepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(olddepartment),user.getLanguage())%></span> 
    <input class=inputStyle type=hidden name=olddepartment value="<%=olddepartment%>">
    </TD>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></TD>
    <TD class=Field>
    <button class=Browser onClick="onShowNewDepartment()"></button> 
    <span class=inputStyle id=newdepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(newdepartment),user.getLanguage())%></span> 
    <input class=inputStyle type=hidden name=newdepartment value="<%=newdepartment%>">
    </TD>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(15999,user.getLanguage())%></TD>
    <TD class=Field>
    <button class=Browser onClick="onShowOldJobTitle()"></button> 
    <span class=inputStyle id=oldjobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(oldjobtitle),user.getLanguage())%></span> 
    <input class=inputStyle type=hidden name=oldjobtitle  value="<%=oldjobtitle%>">
    </TD>
    <TD width=10%><%=SystemEnv.getHtmlLabelName(16000,user.getLanguage())%></TD>
    <TD class=Field>
    <button class=Browser onClick="onShowNewJobTitle()"></button> 
    <span class=inputStyle id=newjobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(newjobtitle),user.getLanguage())%></span> 
    <input class=inputStyle type=hidden name=newjobtitle value="<%=newjobtitle%>">
    </TD>
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(15993,user.getLanguage())%></td>
    <td class=field>
    <BUTTON class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputStyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputStyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
    <TD><%=SystemEnv.getHtmlLabelName(15994,user.getLanguage())%>:</TD>
    <TD class=Field>
      <INPUT class=inputStyle maxLength=20 size=6 name="joblevelfrom"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")' value="<%=joblevelfrom%>">--
      <INPUT class=inputStyle maxLength=20 size=6 name="joblevelto"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")' value="<%=joblevelto%>">
    </TD>     
    <TD><%=SystemEnv.getHtmlLabelName(15995,user.getLanguage())%>:</TD>
    <TD class=Field colspan = 3>
      <INPUT class=inputStyle maxLength=20 size=6 name="newjoblevelfrom"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelfrom")' value="<%=newjoblevelfrom%>">--
      <INPUT class=inputStyle maxLength=20 size=6 name="newjoblevelto"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("joblevelto")' value="<%=newjoblevelto%>">
    </TD>     
</tr>
<TR><TD class=Line colSpan=6></TD></TR> 

</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<tbody>
  <TR class=Header >
    <TH colspan=8><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
  </TR>
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(16001,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15481,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15999,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(16000,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(6111,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15994,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15995,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="8" ></TD></TR> 
  <%
   ExcelFile.init ();
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(Util.toScreen(filename,user.getLanguage())) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(16001,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15481,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15999,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15480,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15480,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(6111,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15994,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(15995,user.getLanguage()) , "Header" ) ;  
  
   if(total!=0){
     while(rs.next()){
     String departmentid = JobTitlesComInfo.getDepartmentid(rs.getString("oldjobtitleid"));	
     String newdepartmentid = JobTitlesComInfo.getDepartmentid(rs.getString("newjobtitleid"));
     String resourcename = Util.toScreen(ResourceComInfo.getResourcename(rs.getString("resourceid")),user.getLanguage());	
     String olddepartnemtname = Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
     String oldjobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("oldjobtitleid")),user.getLanguage());
     String newdepartmentname = Util.toScreen(DepartmentComInfo.getDepartmentname(newdepartmentid),user.getLanguage());
     String newjobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("newjobtitleid")),user.getLanguage());
     String changedate = Util.toScreen(rs.getString("changedate"),user.getLanguage());
     String oldjoblevel = rs.getString("oldjoblevel");
     String newjoblevel = rs.getString("newjoblevel");
     
     er = et.newExcelRow() ;
     er.addStringValue(resourcename) ;
     er.addStringValue(olddepartnemtname) ;
     er.addStringValue(oldjobtitlename) ;
     er.addStringValue(newdepartmentname) ;
     er.addStringValue(newjobtitlename) ;
     er.addStringValue(changedate) ;
     er.addStringValue(oldjoblevel) ;
     er.addStringValue(newjoblevel) ;
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("resourceid")%>"> <%=resourcename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departmentid%>"> <%=olddepartnemtname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("oldjobtitleid")%>"> <%=oldjobtitlename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=newdepartmentid%>"> <%=newdepartmentname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("newjobtitleid")%>"> <%=newjobtitlename%></a></TD>
    <TD><%=changedate%></TD>    
    <TD><%=oldjoblevel%></TD>
    <TD><%=newjoblevel%></TD>
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
<script language=vbs>
sub onShowOldJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")	
	if id(0)<> 0 then
	oldjobtitlespan.innerHtml = id(1)
	frmmain.oldjobtitle.value=id(0)
	else 
	oldjobtitlespan.innerHtml = ""
	frmmain.oldjobtitle.value=""
	end if	
end sub
sub onShowNewJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")	
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	frmmain.newjobtitle.value=id(0)
	else 
	newjobtitlespan.innerHtml = ""
	frmmain.newjobtitle.value=""
	end if	
end sub
sub onShowOldDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.olddepartment.value)	
	if id(0)<> 0 then	
	olddepartmentspan.innerHtml = id(1)
	frmmain.olddepartment.value=id(0)
	else
	olddepartmentspan.innerHtml = ""
	frmmain.olddepartment.value=""	
	end if
end sub
sub onShowNewDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.newdepartment.value)	
	if id(0)<> 0 then	
	newdepartmentspan.innerHtml = id(1)
	frmmain.newdepartment.value=id(0)
	else
	newdepartmentspan.innerHtml = ""
	frmmain.newdepartment.value=""	
	end if
end sub
</script>
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>