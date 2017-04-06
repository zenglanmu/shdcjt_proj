<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="GraphFile2" class="weaver.file.GraphFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15991,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String olddepartment=Util.fromScreen(request.getParameter("oldepartment"),user.getLanguage());
String newdepartment=Util.fromScreen(request.getParameter("newdepartment"),user.getLanguage());
String oldjobtitle=Util.fromScreen(request.getParameter("oldjobtitle"),user.getLanguage());
String newjobtitle=Util.fromScreen(request.getParameter("newjobtitle"),user.getLanguage());

String joblevelfrom=Util.fromScreen(request.getParameter("joblevelfrom"),user.getLanguage());
String joblevelto=Util.fromScreen(request.getParameter("joblevelto"),user.getLanguage());
String newjoblevelfrom=Util.fromScreen(request.getParameter("newjoblevelfrom"),user.getLanguage());
String newjoblevelto=Util.fromScreen(request.getParameter("newjoblevelto"),user.getLanguage());

String sqlwhere = "";

if(!fromdate.equals("")){
	sqlwhere+=" and t1.changedate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.changedate<='"+enddate+"' or t1.changedate is null)";
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

String sql = "select count(id) from HrmStatusHistory t1 where type_n = 4 "+sqlwhere;
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "select t3.id resultid, count(t1.id) resultcount from HrmStatusHistory t1,HrmJobtitles t2,HrmDepartment t3 where type_n = 4 and t1.newjobtitleid = t2.id and t2.jobdepartmentid = t3.id "+sqlwhere+" group by t3.id";
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15992,user.getLanguage())+",/hrm/report/redeploy/HrmRpRedeployTime.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15989,user.getLanguage())+",/hrm/report/redeploy/HrmRedeployReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",/hrm/report/redeploy/HrmRpRedeployDetail.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form name=frmmain id="frmmain" method=post action="HrmRpRedeploy.jsp">
<table class=ViewForm>
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=sep2></TD>
</TR>
<!--
<tr>
    <TD width=10%>调出部门</TD>
    <TD class=Field>
    <button class=Browser onClick="onShowOldDepartment()"></button> 
    <span class=inputStyle id=olddepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(olddepartment),user.getLanguage())%></span> 
    <input type=hidden name=olddepartment value="<%=olddepartment%>">
    </TD>
    <TD width=10%>调入部门</TD>
    <TD class=Field>
    <button class=Browser onClick="onShowNewDepartment()"></button> 
    <span class=inputStyle id=newdepartmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(newdepartment),user.getLanguage())%></span> 
    <input type=hidden name=newdepartment value="<%=newdepartment%>">
    </TD>
    <TD width=10%>调出岗位</TD>
    <TD class=Field>
    <button class=Browser onClick="onShowOldJobTitle()"></button> 
    <span class=inputStyle id=oldjobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(oldjobtitle),user.getLanguage())%></span> 
    <input type=hidden name=oldjobtitle value="<%=oldjobtitle%>">
    </TD>
    <TD width=10%>调入岗位</TD>
    <TD class=Field>
    <button class=Browser onClick="onShowNewJobTitle()"></button> 
    <span class=inputStyle id=newjobtitlespan><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(newjobtitle),user.getLanguage())%></span> 
    <input type=hidden name=newjobtitle value="<%=newjobtitle%>">
    </TD>
</tr>
-->
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(15993,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
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
<TR style="height:2px"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<colgroup>
<col width="5%">
<tbody>
  <TR class=Header>
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
  </TR>
  <tr class=header>
    <td></td>
    <td><%=SystemEnv.getHtmlLabelName(15480,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR> 
  <%
   rs.first();
  	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15996,user.getLanguage()),700,350,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();
  
/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable (  SystemEnv.getHtmlLabelName(15996,user.getLanguage()) );
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/   
   
   int totalnum = 0;
   if(total!=0){
     do{
	String resultid = rs.getString(1);
	int resultcount = rs.getInt(2);
	if(resultcount < 0){
	  resultcount = 0;
	}
	totalnum+=resultcount;
	resultpercent=(float)resultcount*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/(float)100;			
	
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <td><a href="HrmRpRedeployDetail.jsp?newdepartment=<%=resultid%>">>>></a></td>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=resultid%>"> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage())%></TD>
    <TD height="100%">
		<% String className=(resultpercent==100)?"redgraph":"greengraph"; %>        
        <TABLE height="100%" cellSpacing=0 class="<%=className%>" width="<%=resultpercent%>%">                       
        <TBODY>
        <TR>
        <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width=1 height=1></td>
        </TR>
        </TBODY>
        </TABLE>    
    </TD>
    <TD><%=resultcount%></TD>
    <TD><%=resultpercent%>%</TD>
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		
/*            GraphFile.addConditionlable(Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage())) ;		
            GraphFile.addPiclinevalues ( ""+resultcount , Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage()) , GraphFile.random , null  );
*/			pie.addSeries(Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage()),resultcount);
    	}while(rs.next());
    	pie.addSeries(SystemEnv.getHtmlLabelName(375,user.getLanguage()),total-totalnum);
//        GraphFile.addConditionlable( SystemEnv.getHtmlLabelName(375,user.getLanguage()) ) ;		
//		GraphFile.addPiclinevalues ( ""+(total-totalnum ), SystemEnv.getHtmlLabelName(375,user.getLanguage()) , GraphFile.random , null  );    		    		
	}
	int colcount = GraphFile.getConditionlableCount() + 1 ;
	%>  
</table>
<br>
<!--<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'><br>
    </TD>
  </TR>     
  </TBODY> 
</TABLE>-->
</form>
<div class="chart">
<%
if ("true".equals(isIE)){
	if(pie!=null)pie.print(out);
}else{   %>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
</p>
<%} %>	
<br>
</div>
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
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	oldjobtitlespan.innerHtml = id(1)
	frmmain.oldjobtitle.value=id(0)
	else 
	oldjobtitlespan.innerHtml = ""
	frmmain.oldjobtitle.value=""
	end if
	end if
end sub
sub onShowNewJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	newjobtitlespan.innerHtml = id(1)
	frmmain.newjobtitle.value=id(0)
	else 
	newjobtitlespan.innerHtml = ""
	frmmain.newjobtitle.value=""
	end if
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
 jQuery("#frmmain").submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>