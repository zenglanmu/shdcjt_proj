<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
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
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16019,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String sqlwhere = "";

if(!fromdate.equals("")){
	sqlwhere+=" and (t1.startdate>='"+fromdate+"' or ((startdate is null or startdate = '') and createdate>='"+fromdate+"'))";
}
if(!enddate.equals("")){
   	if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and ((t1.startdate<='"+enddate+"' and startdate is not null) or ((startdate is null )and (createdate is not null and createdate <='"+enddate+"')))";
	}else{
	sqlwhere+=" and ((t1.startdate<='"+enddate+"' and startdate is not null and startdate<>'') or ((startdate is null )and (createdate is not null and createdate<>'' and createdate <='"+enddate+"')))";
	}
}

String sql = "select count(id) from HrmResource t1 where (t1.accounttype is null or t1.accounttype=0) and 4 = 4 "+sqlwhere;
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "select t2.id resultid, count(t1.id) resultcount from HrmResource t1,HrmDepartment t2 where (t1.accounttype is null or t1.accounttype=0) and t1.departmentid = t2.id "+sqlwhere+" group by t2.id";
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16020,user.getLanguage())+",/hrm/report/resourceadd/HrmRpResourceAddTime.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",/hrm/report/resourceadd/HrmRpResourceAddReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<form name=frmmain method=post action="HrmRpResourceAdd.jsp">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="35%">
<col width="15%">
<col width="35%">
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=line1></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(2082,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>         
</tr>
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<tbody>
  <TR class=Header>
    <TH colspan=4 ><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
  </TR>
   <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>
  </tr>
<TR class=Line><TD colspan="4" ></TD></TR> 
  <%
  	BarTeeChart bar=TeeChartFactory.createBarChart(SystemEnv.getHtmlLabelName(16021,user.getLanguage()),800,500);
	bar.setMarksStyle(BarTeeChart.SMS_Value);
	List list1=new ArrayList();
    BarChartModel bc=null;
	//bar.isDebug();//考虑新增Chart的附加功能，如改变chartType
	
/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable (  SystemEnv.getHtmlLabelName(16021,user.getLanguage()) );
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/   
   rs.first();
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
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=resultid%>"> <%=Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage())%></TD>
    <TD height="100%">        
		<% String className=(resultpercent==100)?"redgraph":"greengraph";%>
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
    		
			bc=new BarChartModel();
			bc.setCategoryName(Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage()));
				bc.setValue(resultcount);
			list1.add(bc);
			
//    		GraphFile.addConditionlable(Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage())) ;		
//            GraphFile.addPiclinevalues ( ""+resultcount , Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage()) , GraphFile.random , null  );    		
    	}while(rs.next());
	int sub=total-totalnum;
	if(sub>0){//如果剩余的其他大于零则显示，否则不显示
			bc=new BarChartModel();
			bc.setCategoryName(SystemEnv.getHtmlLabelName(375,user.getLanguage()));
				bc.setValue(sub);
			list1.add(bc);
			
		
//        GraphFile.addConditionlable( SystemEnv.getHtmlLabelName(375,user.getLanguage()) ) ;		
//		GraphFile.addPiclinevalues ( ""+(total-totalnum ), SystemEnv.getHtmlLabelName(375,user.getLanguage()) , GraphFile.random , null  );    		    		
	resultpercent=(float)(sub)*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/(float)100;	
	%>  
	<tr>
	<td><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></td>
	<td height="100%">
		<% String className=(resultpercent==100)?"redgraph":"greengraph";%>
        <TABLE height="100%" cellSpacing=0 class="<%=className%>" width="<%=resultpercent%>%">                       
        <TBODY>
        <TR>
        <TD width="100%" height="100%"><img src="/images/ArrowUpGreen.gif" width="1" height="1"></td>
        </TR>
        </TBODY>
        </TABLE> 
	</td>
	<td><%=sub%></td>
	<td><%=resultpercent%>%</td>
	</tr>
<%}
	bar.addSeries("新增情况",list1,"");
	
	}
%>	
</table>
<br>
<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
<!--        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
-->		
    </TD>
  </TR>     
  </TBODY> 
</TABLE>
</form>
<div class="chart">
<%
if ("true".equals(isIE)){
	if(bar!=null)bar.print(out);
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
 frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>