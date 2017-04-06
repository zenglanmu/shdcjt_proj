<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.teechart.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
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
String isFirst = Util.null2String(request.getParameter("isFirst"));
String from = Util.null2String(request.getParameter("from"));
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String subcompanyid1 = Util.null2String(request.getParameter("subcompanyid1"));
if(subcompanyid1.equals("") && detachable == 1)
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21922,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
/*
if(from.equals("contract")){
	subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
}*/
String address_to = (String)session.getAttribute("HrmRpContract_left_"+user.getUID());
if(address_to == null || "".equals(address_to) || "null".equalsIgnoreCase(address_to)){
	address_to = "HrmRpContract.jsp";
}
if(!"HrmRpContract.jsp".equals(address_to) && "new".equals(isFirst)){
	try{
		response.sendRedirect(address_to+"?subcompanyid1="+subcompanyid1+"&from="+from);
	}catch(Exception e){}
}

session.setAttribute("HrmRpContract_left_"+user.getUID(),"HrmRpContract.jsp");
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+ SystemEnv.getHtmlLabelName(15941,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;

String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String fromTodate=Util.fromScreen(request.getParameter("fromTodate"),user.getLanguage());
String endTodate=Util.fromScreen(request.getParameter("endTodate"),user.getLanguage());

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
	sqlwhere+=" and t1.contractstartdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.contractstartdate<='"+enddate+"' or t1.contractstartdate is null)";
}
if(!fromTodate.equals("")){
	sqlwhere+=" and t1.contractenddate>='"+fromTodate+"'";
}
if(!endTodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.contractenddate<='"+endTodate+"' and t1.contractenddate is not null)";
  }else{
    sqlwhere+=" and (t1.contractenddate<='"+endTodate+"' and t1.contractenddate is not null and t1.contractenddate <> '')";
  }
}
if(detachable==1){
	if(!subcompanyid1.equals("") && from.equals("")){
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 =  "+subcompanyid1+")";
	}/*else if(subcompanyid1.equals("") && from.equals("")){
		subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 = "+user.getUserSubCompany1()+")";
	}*/else if(subcompanyid1.equals("") && from.equals("contract")){
		subcompanyid1 = String.valueOf(user.getUserSubCompany1()); 
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 = "+subcompanyid1+")";
	}else if(from.equals("contract")){
		sqlwhere+=" and t2.id in (select id from HrmResource where subcompanyid1 = "+subcompanyid1+")";
	}
}
String sql = "select count(t1.id) from HrmContract t1,HrmResource t2 where 4 = 4 "+sqlwhere;
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "select t3.id resultid, count(t1.id) resultcount from HrmContract t1,HrmResource t2,HrmDepartment t3 where (t2.accounttype is null or t2.accounttype=0) and t1.contractman = t2.id and t2.departmentid = t3.id "+sqlwhere+" group by t3.id";
//System.out.println(sqlstr);
rs.executeSql(sqlstr);
%>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15942,user.getLanguage())+",/hrm/report/contract/HrmRpContractType.jsp?subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15943,user.getLanguage())+",/hrm/report/contract/HrmRpContractTime.jsp?subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15939,user.getLanguage())+",/hrm/report/contract/HrmContractReport.jsp?subcompanyid1="+subcompanyid1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",/hrm/report/contract/HrmRpContractDetail.jsp?subcompanyid1="+subcompanyid1+",_self} " ;
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
<form name=frmmain method=post action="HrmRpContract.jsp">
<input type="hidden" name="from" value ="<%=from%>" >
<input type="hidden" name="isFirst" value="new">
<input type="hidden" name="subcompanyid1" value="<%=subcompanyid1%>">
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
    <td width=10%><%=SystemEnv.getHtmlLabelName(1936,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON type=button  class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td>
     <td width=10%><%=SystemEnv.getHtmlLabelName(15944,user.getLanguage())%></td>
    <td class=field>
    <BUTTON type=button  class=calendar id=SelectDate onclick=getfromToDate()></BUTTON>&nbsp;
    <SPAN id=fromTodatespan ><%=Util.toScreen(fromTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromTodate" value=<%=fromTodate%>>
    －<BUTTON type=button  class=calendar id=SelectDate onclick=getendToDate()></BUTTON>&nbsp;
    <SPAN id=endTodatespan ><%=Util.toScreen(endTodate,user.getLanguage())%></SPAN>
    <input type="hidden" name="endTodate" value=<%=endTodate%>>  
    </td>          
</tr>
<TR style="height:2px"><TD class=Line colSpan=6></TD></TR> 
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
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15946,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(336,user.getLanguage())%></td>    
  </tr>
  <TR class=Line><TD colspan="5" ></TD></TR> 
  <%

   rs.first();
   
   	PieTeeChart pie=TeeChartFactory.createPieChart(SystemEnv.getHtmlLabelName(15947,user.getLanguage()),700,350,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();
   
/*   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable ( SystemEnv.getHtmlLabelName(15947,user.getLanguage()) );
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
    <td><a href="HrmRpContractDetail.jsp?department=<%=resultid%>">>>></a></td>
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
    		
//            GraphFile.addConditionlable(Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage())) ;		
//            GraphFile.addPiclinevalues ( ""+resultcount , Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage()) , GraphFile.random , null  );
			pie.addSeries(Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage()),resultcount);

    	}while(rs.next());
    	
//        GraphFile.addConditionlable( SystemEnv.getHtmlLabelName(375,user.getLanguage()) ) ;		
//		GraphFile.addPiclinevalues ( ""+(total-totalnum ),  SystemEnv.getHtmlLabelName(375,user.getLanguage()) , GraphFile.random , null  );
		pie.addSeries(SystemEnv.getHtmlLabelName(375,user.getLanguage()),total-totalnum);
	}
	int colcount = GraphFile.getConditionlableCount() + 1 ;
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
<script language=javascript>  
function submitData() {
 document.frmmain.from.value = "contract";
 frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
