<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page import="weaver.file.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitleComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename =SystemEnv.getHtmlLabelName(179,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(1915,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="projecttype";
int linecolor=0;
int total=0;
int totalnum = 0;
float resultpercent=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String location=Util.fromScreen(request.getParameter("location"),user.getLanguage());

String sqlwhere="";
 if(status.equals("")){
      status = "8";
    }

if(!fromdate.equals("")){
	sqlwhere+=" and t1.startdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.startdate<='"+enddate+"' or t1.startdate is null)";
}

if(!location.equals("")){
	sqlwhere+=" and t1.locationid ="+location;
}
if(!(status.equals("")||status.equals("9"))){
    if(status.equals("8")){
        sqlwhere+=" and t1.status <= 3";
    }else{
	    sqlwhere+=" and t1.status ="+status;
    }
}

String sql = "select count(id) from HrmResource t1 where (t1.accounttype is null or t1.accounttype=0) and 1=1"+sqlwhere;
RecordSet.executeSql(sql);
RecordSet.next();
total = RecordSet.getInt(1);

String sqlstr="";
if(sqlwhere.equals("")){
sqlstr = "select t3.id   resultid,COUNT(t1.id)   resultcount from HrmResource  t1,HrmJobTitles  t2,HrmJobActivities t3 where (t1.accounttype is null or t1.accounttype=0) and t1.jobtitle=t2.id and t2.jobactivityid = t3.id group by t3.id order by resultcount";
}
else 
sqlstr = "select t3.id   resultid,COUNT(t1.id)   resultcount from HrmResource  t1,HrmJobTitles  t2, HrmJobActivities t3 where (t1.accounttype is null or t1.accounttype=0) and t1.jobtitle=t2.id and t2.jobactivityid = t3.id "+sqlwhere+" group by t3.id order by resultcount";

RecordSet.executeSql(sqlstr);
while(RecordSet.next())  { 
      int resultcount = RecordSet.getInt(2);
      totalnum+=resultcount;
}
ExcelFile.init();
ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle2 = ExcelFile.newExcelStyle("total");
excelStyle2.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle2.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle2.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelRow er = es.newExcelRow();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"-Excel,javascript:exportExcel(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe name="ExcelOut" id="ExcelOut" src="" style="display:none" ></iframe>
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
<form name=frmmain id="frmmain" method=post action="HrmJobActivityRp.jsp">
<table class=ViewForm>
<tbody>
<tr>
    <TD><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TD>
    <TD class=Field>
    <input class=wuiBrowser id=location type=hidden name=location value="<%=location%>"
    _url="/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp"
    _displayText="<%=Util.toScreen(LocationComInfo.getLocationname(location),user.getLanguage())%>"
    >
   </TD>

     <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
     <TD class=Field> 
      <SELECT class=inputStyle id=status name=status value="<%=status%>"  style="width:100px">                                  
           <OPTION value="9" <% if(status.equals("9")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>                   
           <OPTION value="0" <% if(status.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15710,user.getLanguage())%></OPTION>
           <OPTION value="1" <% if(status.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15711,user.getLanguage())%></OPTION>
           <OPTION value="2" <% if(status.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%></OPTION>
           <OPTION value="3" <% if(status.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15844,user.getLanguage())%></OPTION>
           <OPTION value="4" <% if(status.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6094,user.getLanguage())%></OPTION>
           <OPTION value="5" <% if(status.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%></OPTION>
           <OPTION value="6" <% if(status.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(6092,user.getLanguage())%></OPTION>
           <OPTION value="7" <% if(status.equals("7")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></OPTION>
           <OPTION value="8" <% if(status.equals("8")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></OPTION>                   
     </SELECT>
     </TD>
    <td width=15%><%=SystemEnv.getHtmlLabelName(1908,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputStyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input  class=inputStyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
</tr>
<TR style="height:2px"><TD class=Line colSpan=8></TD></TR> 
</tbody>
</table>

<TABLE class=viewForm width="100%">
  <TBODY>
  <TR class=Title>
    <TH><%=SystemEnv.getHtmlLabelName(15861,user.getLanguage())%>：<%=totalnum%></TH>
  </TR>
 </TBODY></TABLE>
<TABLE class=ListStyle cellspacing=1  width="100%">
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="40%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
    <TR class=Line><TD colspan="4" ></TD></TR> 
<%
	er.addStringValue(SystemEnv.getHtmlLabelName(15861,user.getLanguage()) + "：" + totalnum, "total", 3);
	er = es.newExcelRow();
	er.addStringValue(SystemEnv.getHtmlLabelName(1915,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(1859,user.getLanguage()), "Header");
	er.addStringValue("%", "Header");
	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15868,user.getLanguage()),700,500,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();

/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15868,user.getLanguage()));
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/	RecordSet.first();
	if(totalnum!=0){
		do{
		String resultid = RecordSet.getString(1);
		int resultcount = RecordSet.getInt(2);
		resultpercent=(float)resultcount*100/(float)totalnum;
		resultpercent=(float)((int)(resultpercent*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = resultpercent;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

	%>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/jobactivities/HrmJobActivitiesEdit.jsp?id=<%=resultid%>"> <%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesmarks(resultid),user.getLanguage())%>-   
    <%=Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(resultid),user.getLanguage())%></TD>
    <TD height="100%">
		<%String className=(resultpercent==100)?"redgraph":"greengraph";%>
        <TABLE height="100%" cellSpacing=0 class=<%=className%> width="<%=resultpercentOfwidth%>%">
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
    <%
		er = es.newExcelRow();
		er.addStringValue(Util.toScreen(JobActivitiesComInfo.getJobActivitiesmarks(resultid),user.getLanguage()) + "- " + Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(resultid),user.getLanguage()), "Border");
		er.addStringValue("" + resultcount, "Border");
		er.addStringValue("" + resultpercent + "%", "Border");
    		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		String labelname =Util.toScreen(JobActivitiesComInfo.getJobActivitiesmarks(resultid),user.getLanguage()); 	
//      		GraphFile.addConditionlable(labelname) ;		
//      		GraphFile.addPiclinevalues ( ""+resultcount , labelname , GraphFile.random , null  );

			pie.addSeries(labelname,resultcount);
    		}while(RecordSet.next());
	} 
   ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15868,user.getLanguage()));
   ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15868,user.getLanguage()), es);
	%>
  </TBODY></TABLE>
  <br>
<!--<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
    </TD>
  </TR> 
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=4'>
    </TD>
  </TR>    
  </TBODY> 
</TABLE>
--> </form>
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
sub onShowLocation()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/location/LocationBrowser.jsp")
	if Not isempty(id) then 
	if id(0)<> 0 then
	locationspan.innerHtml = id(1)
	frmmain.location.value=id(0)
	else
	locationspan.innerHtml = ""
	frmmain.location.value=""
	end if
	end if
end sub
</script>
<script language=javascript>  
function submitData() {
 jQuery("#frmmain").submit();
}
function exportExcel()
{
	document.getElementById("ExcelOut").src = "/weaver/weaver.file.ExcelOut";
}
</script>

 </BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
