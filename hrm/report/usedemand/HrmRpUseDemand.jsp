<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="UseDemandManager" class="weaver.hrm.report.UseDemandManager" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
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
String titlename = SystemEnv.getHtmlLabelName(16060,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15938,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());

int content=Util.getIntValue(request.getParameter("content"),1);

String sqlwhere = "";
if(fromdate.equals("")&&enddate.equals("")){
  fromdate = year+"-"+month+"-01";
  enddate = year+"-"+month+"-31";
}
if(!fromdate.equals("")){
	sqlwhere+=" and demandregdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (demandregdate<='"+enddate+"' and demandregdate is not null)";
  }else{
    sqlwhere+=" and (demandregdate<='"+enddate+"' and demandregdate is not null and demandregdate <> '')";
  }
}

if(!fromTodate.equals("")){
	sqlwhere+=" and referdate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (referdate<='"+endTodate+"' and referdate is not null)";
  }else{
    sqlwhere+=" and (referdate<='"+endTodate+"' and referdate is not null and referdate <> '')";
  }
}

String sql = "";
sql= "select demandnum from HrmUseDemand  where 4 = 4 "+sqlwhere;
rs.executeSql(sql);
while(rs.next()){
total += rs.getInt(1);
}
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",/hrm/report/usedemand/HrmUseDemandReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",/hrm/report/usedemand/HrmRpUseDemandDetail.jsp,_self} " ;
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
<form name=frmmain method=post action="HrmRpUseDemand.jsp">
<table class=ViewForm>
<colgroup>
<col width="15%">
<col width="25%">
<col width="15%">
<col width="25%">
<col width="5%">
<col width="15%">
<tbody>
<TR class= Spacing>
  <TD colspan=8 class=sep2></TD>
</TR>
<tr>    
    <td width=10%><%=SystemEnv.getHtmlLabelName(15934,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getDate(fromTodatespan,fromTodate)></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromTodate" value=<%=fromTodate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getDate(endTodatespan,endTodate)></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>          
</tr>
<TR style="height:2px"><TD class=Line colSpan=6></TD></TR> 
<tr>
    <td><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></td>
    <td class=Field>
       <select class=inputstyle name="content" value="<%=content%>" onChange="dosubmit()">                
         <option value=1 <%if(content == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> </option>
         <option value=2 <%if(content == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </option>
         <option value=3 <%if(content == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%> </option>
         <option value=4 <%if(content == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </option>         
       </select>
    </td>    
</tr>
<TR style="height:2px"><TD class=Line colSpan=2></TD></TR> 
</tbody>
</table>
<table class=ListStyle cellspacing=1 >
<colgroup>
<tbody>
  <TR class=Header >
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(15861,user.getLanguage())%>: <%=total%></TH>
  </TR>
  
  <tr class=header>    
    <td>
<%if(content==1){%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%}%>    
<%if(content==2){%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><%}%>    
<%if(content==3){%><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%><%}%>    
<%if(content==4){%><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%><%}%>    
    </td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>    
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR> 
  <%
   rs.first();

   	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(16061,user.getLanguage()),700,350,PieTeeChart.SMS_LabelPercent);
//	pie.isDebug();

/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(16061,user.getLanguage()) );
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/   
   int totalnum = 0;
   if(total!=0){
     Hashtable ht = new Hashtable();
     Hashtable show = new Hashtable();
     ht = UseDemandManager.getResultByContent(content,sqlwhere);
     show = UseDemandManager.getShow();
     Enumeration keys = ht.keys();
     while(keys.hasMoreElements()){        
	String resultid = (String)keys.nextElement();
	int  resultcount = Util.getIntValue((String)ht.get(resultid));
	String name = Util.toScreen((String)show.get(resultid),user.getLanguage());	
	if(resultcount < 0){
	  resultcount = 0;
	}
	totalnum+=resultcount;
	resultpercent=(float)resultcount*100/(float)total;
	resultpercent=(float)((int)(resultpercent*100))/(float)100;			
	
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>    
    <TD><%=name%></TD>
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
    		
//            GraphFile.addConditionlable(name) ;		
//            GraphFile.addPiclinevalues ( ""+resultcount , name, GraphFile.random , null  );    		
			
			pie.addSeries(name,resultcount);
    	}  

//    	GraphFile.addConditionlable( SystemEnv.getHtmlLabelName(375,user.getLanguage()) ) ;		
//		GraphFile.addPiclinevalues ( ""+(total-totalnum ), SystemEnv.getHtmlLabelName(375,user.getLanguage()) , GraphFile.random , null  );
		pie.addSeries(SystemEnv.getHtmlLabelName(375,user.getLanguage()),total-totalnum);    	  		
	}	
	%>  
</table>
<br>
<!--<TABLE class=ViewForm>
  <TBODY>     
  <TR> 
    <TD align=center>
        <img src='/weaver/weaver.file.GraphOut?pictype=3'>
    </TD>
  </TR>     
  </TBODY> 
</TABLE>
--></form>
<div class="chart">
<%
if ("true".equals(isIE)){
	 if(pie!=null)pie.print(out);
}else{   %>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			您当前使用的浏览器不支持【报表视图】，如需使用该功能，请使用IE浏览器！
</p>
<%} %>	
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
sub onShowScheduleDiff(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/HrmScheduleDiffBrowser.jsp")
	if NOT isempty(id) then
	        if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = ""
		document.all(inputename).value=""
		end if
	end if
end sub
</script>
<script language=javascript>
  function dosubmit(){
    document.frmmain.submit();
  }
 function submitData() {
 frmmain.submit();
}
 </script>
</body>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>