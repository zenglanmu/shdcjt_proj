<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="GraphFile2" class="weaver.file.GraphFile" scope="session"/>
<html>
<head>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(6140,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16044,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(16036,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());

String fromtime=Util.fromScreen(request.getParameter("fromtime"),user.getLanguage());
String endtime=Util.fromScreen(request.getParameter("endtime"),user.getLanguage());
String fromTotime=Util.fromScreen(request.getParameter("fromTotime"),user.getLanguage());
String endTotime=Util.fromScreen(request.getParameter("endTotime"),user.getLanguage());

String depid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
String difftype=Util.fromScreen(request.getParameter("difftype"),user.getLanguage());


String sqlwhere = "";
if(fromdate.equals("")&&enddate.equals("")){
  fromdate = year+"-"+month+"-01";
  enddate = year+"-"+month+"-31";
}

if(!fromdate.equals("")){
	sqlwhere+=" and t1.startdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.startdate<='"+enddate+"' or t1.startdate is null)";
}
if(!fromTodate.equals("")){
	sqlwhere+=" and t1.enddate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.enddate<='"+endTodate+"' and t1.enddate is not null)";
  }else{
    sqlwhere+=" and (t1.enddate<='"+endTodate+"' and t1.enddate is not null and t1.enddate <> '')";
  }
}
if(!depid.equals("")){
	sqlwhere+=" and t1.resourceid= t3.id and t3.departmentid = "+depid+"";
}
if(!difftype.equals("")){
	sqlwhere+=" and t2.difftype="+difftype+"";
}
String sql = "";
if(!depid.equals("")){
 sql = "select count(t1.id) from HrmScheduleMaintance t1,HrmScheduleDiff t2,HrmResource t3 where t1.diffid = t2.id "+sqlwhere;
}else{
 sql = "select count(t1.id) from HrmScheduleMaintance t1,HrmScheduleDiff t2 where t1.diffid = t2.id "+sqlwhere;
}
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr ="";
if(!depid.equals("")){
 sqlstr = "select t2.id resultid, count(t1.id) resultcount from HrmScheduleMaintance t1,HrmScheduleDiff t2,HrmResource t3 where t1.diffid = t2.id "+sqlwhere+" group by t2.id"; 
}else{
 sqlstr = "select t2.id resultid, count(t1.id) resultcount from HrmScheduleMaintance t1,HrmScheduleDiff t2 where t1.diffid = t2.id "+sqlwhere+" group by t2.id"; 
}
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/report/schedulediff/HrmRpScheduleDiff.jsp,_self} " ;
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
<form name=frmmain id="frmmain" method=post action="HrmRpScheduleDiffType.jsp">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class=Spacing style="height: 1px;">
  <TD colspan=8 class=line1></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(16037,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    ��<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(16038,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=calendar id=SelectDate onclick=getDate(fromTodatespan,fromTodate)></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromTodate" value=<%=fromTodate%>>
    ��<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(endTodatespan,endTodate)></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>          
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(16039,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=Clock  onclick=onShowTime(fromtimespan,fromtime)></BUTTON>&nbsp;
    <SPAN id=fromtimespan ><%=Util.toScreen(fromtime,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromtime" value=<%=fromtime%>>
    ��<BUTTON type="button" class=Clock  onclick=onShowTime(endtimespan,endtime)></BUTTON>&nbsp;
    <SPAN id=endtimespan ><%=Util.toScreen(endtime,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="endtime" value=<%=endtime%>>  
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(16040,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type="button" class=Clock  onclick=onShowTime(fromTotimespan,fromTotime)></BUTTON>&nbsp;
    <SPAN id=fromTotimespan ><%=Util.toScreen(fromTotime,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromTotime" value=<%=fromTotime%>>
    ��<BUTTON type="button" class=Clock  onclick=onShowTime(endTotimespan,endTotime)></BUTTON>&nbsp;
    <SPAN id=endTotimespan ><%=Util.toScreen(endTotime,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="endTotime" value=<%=endTotime%>>  
    </td>          
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
<tr>
    <td><%=SystemEnv.getHtmlLabelName(16041,user.getLanguage())%></td>
    <td class=Field>
       <select class=inputstyle name="difftype" value="<%=difftype%>">       
         <option value=""></option>
         <option value=0 <%if(difftype.equals("0")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%> </option>
         <option value=1 <%if(difftype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(457,user.getLanguage())%> </option>
       </select>
    </td>
    <TD><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></TD>
    <TD class=Field>         
      <input type="hidden" class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
       _displayText="<%=DepartmentComInfo.getDepartmentname(depid)%>" name="departmentid" id="departmentid" value="<%=depid%>"
      >
    </TD>  
</tr>
<TR style="height: 1px;"><TD class=Line colSpan=6></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<colgroup>
<col width="5%">
<tbody>
  <TR class=Header >
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(15945,user.getLanguage())%>: <%=total%></TH>
  </TR>
    <tr class=header>
    <td></td>
    <td><%=SystemEnv.getHtmlLabelName(16044,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1892,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>    
  </tr>
  <TR class=Line style="height: 1px;"><TD colspan="5" ></TD></TR> 
  <%
   rs.first();
   
   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15942,user.getLanguage()) );
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
   
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
    <td><a href="HrmRpScheduleDiffDetail.jsp?typeid=<%=resultid%>">>>></a></td>
    <TD><a href="/hrm/ScheduleDiff/ScheduleDifftype/HrmScheduleDiffTypeEdit.jsp?id=<%=resultid%>"> <%=Util.toScreen(ScheduleDiffComInfo.getDiffname(resultid),user.getLanguage())%></TD>
    <TD height="100%">        
        <TABLE height="100%" cellSpacing=0 
        <%if(resultpercent==100){%>
        class=redgraph 
        <%}else{%>
        class=greengraph 
        <%}%>
        width="<%=resultpercent%>%">                       
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
    		
		GraphFile.addConditionlable(Util.toScreen(ScheduleDiffComInfo.getDiffname(resultid),user.getLanguage())) ;		
		GraphFile.addPiclinevalues ( ""+resultcount , Util.toScreen(ScheduleDiffComInfo.getDiffname(resultid),user.getLanguage()) , GraphFile.random , null  );    		
    		}while(rs.next());    		
	}
	int colcount = GraphFile.getConditionlableCount() + 1 ;
	%>  
</table>
<br>
<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
    </TD>
  </TR>     
  </TBODY> 
</TABLE>
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
 jQuery("#frmmain").submit();
}
</script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>