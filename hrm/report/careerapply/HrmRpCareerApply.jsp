<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="CareerApplyManager" class="weaver.hrm.report.RpCareerApplyManager" scope="session"/>
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(15885,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15938,user.getLanguage());
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String planid=Util.fromScreen(request.getParameter("planid"),user.getLanguage());
int space=Util.getIntValue(request.getParameter("space"));
int content=Util.getIntValue(request.getParameter("content"),1);
if(content == 4){
  space=Util.getIntValue(request.getParameter("space"),10000);
}
if(content == 5){
  space=Util.getIntValue(request.getParameter("space"),1);
}
String salaryfrom=Util.fromScreen(request.getParameter("salaryfrom"),user.getLanguage());
String salaryto=Util.fromScreen(request.getParameter("salaryto"),user.getLanguage());
String worktimefrom=Util.fromScreen(request.getParameter("worktimefrom"),user.getLanguage());
String worktimeto=Util.fromScreen(request.getParameter("worktimeto"),user.getLanguage());

String sqlwhere = "";
boolean ischange = false;
if(fromdate.equals("")&&enddate.equals("")){
//  fromdate = year+"-"+month+"-01";
//  enddate = year+"-"+month+"-31";
}
if(!fromdate.equals("")){
	sqlwhere+=" and createdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (createdate<='"+enddate+"' and createdate is not null)";
  }else{
    sqlwhere+=" and (createdate<='"+enddate+"' and createdate is not null and createdate <> '')";
  }
}
if(!planid.equals("")){
  ischange = true;
  sqlwhere += " and t1.careerinviteid = t3.id and t3.careerplanid = "  +planid;
}
if(!salaryfrom.equals("")){
  sqlwhere += " and t2.salaryneed >= "  +salaryfrom;
}
if(!salaryto.equals("")){
  sqlwhere += " and t2.salaryneed <= "  +salaryto;
}
if(!worktimefrom.equals("")){
  sqlwhere += " and t2.worktime >= "  +worktimefrom;
}
if(!worktimeto.equals("")){
  sqlwhere += " and t2.worktime <= "  +worktimeto;
}
String sql = "";
sql= "select count(t1.id) from HrmCareerApply t1,HrmCareerApplyOtherInfo t2 where t2.applyid = t1.id "+sqlwhere;
if(ischange){
  sql= "select count(t1.id) from HrmCareerApply t1,HrmCareerApplyOtherInfo t2,HrmCareerInvite t3 where t2.applyid = t1.id "+sqlwhere;
}
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(15101,user.getLanguage())+",/hrm/report/careerapply/HrmCareerApplyReport.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApplySearch.jsp,_self} " ;
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

<form name=frmmain method=post action="HrmRpCareerApply.jsp">
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
    <td width=10%><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getDate(fromdatespan,fromdate)></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button class=calendar id=SelectDate onclick=getDate(enddatespan,enddate)></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input class=inputstyle type="hidden" name="enddate" value=<%=enddate%>>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%></td>
    <td class=Field>
      <input   class=wuiBrowser class=inputstyle id=planid type=hidden name=planid value="<%=planid%>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/career/careerplan/CareerPlanBrowser.jsp"
      _displayText="<%=CareerPlanComInfo.getCareerPlantopic(planid)%>"
      >
    </td>
</tr>
<TR style="height:2px" ><TD class=Line colSpan=6></TD></TR>
<tr>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%></td>
    <td class=field>
      <INPUT  class=inputstyle maxLength=6 size=6 name="salaryfrom"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("salaryfrom")' value="<%=salaryfrom%>">－
      <INPUT  class=inputstyle maxLength=6 size=6 name="salaryto"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("salaryto")' value="<%=salaryto%>">
    </td>
    <td width=10%><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></td>
    <td class=field>
      <INPUT  class=inputstyle maxLength=6 size=6 name="worktimefrom"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktimefrom")' value="<%=worktimefrom%>">－
      <INPUT  class=inputstyle maxLength=6 size=6 name="worktimeto"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("worktimeto")' value="<%=worktimeto%>">
    </td>
</tr>
<TR style="height:2px" ><TD class=Line colSpan=6></TD></TR>
<tr>
    <td><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></td>
    <td class=Field>
       <select class=inputstyle name="content" value="<%=content%>" onChange="dosubmit()">
         <option value=1 <%if(content == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%> </option>
         <option value=2 <%if(content == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%> </option>
         <option value=3 <%if(content == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </option>
         <option value=4 <%if(content == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%> </option>
         <option value=5 <%if(content == 5){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%> </option>
       </select>
    </td>
<%if(content == 4 || content == 5){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%></td>
    <td class=field>
      <INPUT  class=inputstyle maxLength=6 size=6 name="space"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("space")' value="<%=space%>">
    </td>
<%}%>
</tr>
 <TR style="height:2px" ><TD class=Line colSpan=2></TD></TR>
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
<%if(content==1){%><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%><%}%>
<%if(content==2){%><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%><%}%>
<%if(content==3){%><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%><%}%>
<%if(content==4){%><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%><%}%>
<%if(content==5){%><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%><%}%>
    </td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1859,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>
  </tr>
 <TR class=Line><TD colspan="5" ></TD></TR>
  <%
   rs.first();

	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15936,user.getLanguage()),700,350,PieTeeChart.SMS_LabelPercent);
//	pie.isDebug();

/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 );
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15936,user.getLanguage()));
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/
   int totalnum = 0;
   if(total!=0){
     Hashtable ht = new Hashtable();
     Hashtable show = new Hashtable();
     ht = CareerApplyManager.getResultByContent(content,sqlwhere,space,ischange);
     show = CareerApplyManager.getShow();
     Enumeration keys = ht.keys();
     while(keys.hasMoreElements()){
	Integer resultid = (Integer)keys.nextElement();
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
        <TABLE height="100%" cellSpacing=0 class=<%=className%> width="<%=resultpercent%>%">
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
    	if(content != 2){
//    		GraphFile.addConditionlable( SystemEnv.getHtmlLabelName(375,user.getLanguage()) ) ;
//		    GraphFile.addPiclinevalues ( ""+(total-totalnum ),  SystemEnv.getHtmlLabelName(375,user.getLanguage()) , GraphFile.random , null  );
			pie.addSeries(SystemEnv.getHtmlLabelName(375,user.getLanguage()),total-totalnum);
		}
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
<script language=javascript>
function submitData() {
 frmmain.submit();
}
</script>
<script language=vbs>
sub onShowCareerPlan()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/career/careerplan/CareerPlanBrowser.jsp")
	if id(0)<> 0 then
	planspan.innerHtml = id(1)
	frmmain.planid.value=id(0)
	else
	planspan.innerHtml = ""
	frmmain.planid.value=""
	end if
end sub
</script>
<script language=javascript>
  function dosubmit(){
    frmmain.submit();
  }
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>