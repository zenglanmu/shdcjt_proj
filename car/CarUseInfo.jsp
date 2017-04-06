<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CarInfoComInfo" class="weaver.car.CarInfoComInfo" scope="page"/>
<jsp:useBean id="mrr" class="weaver.car.CarInfoReport" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%!
public String getDayOccupied(String thisDate, List beginDateList, List beginTimeList, List endDateList, List endTimeList, List cancelList)
{
	String[] minute = new String[24 * 60 + 1];
	
	for (int i = 0; i < beginDateList.size(); i++)
	{
		String beginDate = (String)beginDateList.get(i);
		String beginTime = (String)beginTimeList.get(i);
		String endDate = (String)endDateList.get(i);
		String endTime = (String)endTimeList.get(i);
		String cancel = (String)cancelList.get(i);
		
		//System.out.println(thisDate + "#" + beginDate + "%" + beginTime + "^" + endDate + "&" + endTime + "#" + cancel);
		
		if(!"1".equals(cancel) && beginDate.compareTo(thisDate) <= 0 && thisDate.compareTo(endDate) <= 0)
		{
			if(beginDate.compareTo(thisDate) < 0)
			{
				beginTime = "00:00";
			}
			if(thisDate.compareTo(endDate) < 0)
			{
				endTime = "23:59";
			}
			
			int beginMinuteOfDay = getMinuteOfDay(beginTime);
			int endMinuteOfDay  = getMinuteOfDay(endTime);
			
			while(beginMinuteOfDay <= endMinuteOfDay)
			{
				if("1".equals(minute[beginMinuteOfDay]))
				{
					return "2";
				}
				else
				{
					minute[beginMinuteOfDay] = "1";
				}
			
				beginMinuteOfDay++;
			}
		}	
	}
	
	for(int i = 0; i < 24 * 60; i++)
	{
		if("1".equals(minute[i]))
		{
			return "1";
		}
	}
	
	return "0";
}

public String getHourOccupied(String thisDate, String thisHour, List beginDateList, List beginTimeList, List endDateList, List endTimeList, List cancelList)
{
	String[] minute = new String[24 * 60 + 1];
	
	for (int i = 0; i < beginDateList.size(); i++) 
	{
		String beginDate = (String)beginDateList.get(i);
		String beginTime = (String)beginTimeList.get(i);
		String endDate = (String)endDateList.get(i);
		String endTime = (String)endTimeList.get(i);
		String cancel = (String)cancelList.get(i);
				
		if
		(
			!"1".equals(cancel) 
			&& (beginDate.compareTo(thisDate) < 0 || (beginDate.compareTo(thisDate) == 0 && beginTime.compareTo(thisHour + ":59") <= 0)) 
			&& (thisDate.compareTo(endDate) < 0 || (thisDate.compareTo(endDate) == 0 && (thisHour + ":00").compareTo(endTime) <= 0))
		)
		{
			if(beginDate.compareTo(thisDate) < 0 || beginTime.compareTo(thisHour + ":00") < 0)
			{
				beginTime = thisHour + ":00";
			}
			if(thisDate.compareTo(endDate) < 0 || (thisHour + ":59").compareTo(endTime) <= 0)
			{
				endTime = thisHour + ":59";
			}
			
			int beginMinuteOfHour = getMinuteOfDay(beginTime);
			int endMinuteOfHour  = getMinuteOfDay(endTime);
			
			while(beginMinuteOfHour <= endMinuteOfHour)
			{
				if("1".equals(minute[beginMinuteOfHour]))
				{
					return "2";
				}
				else
				{
					minute[beginMinuteOfHour] = "1";
				}
			
				beginMinuteOfHour++;
			}
		}	
	}
		
	for(int i = 0; i < 24 * 60; i++)
	{
		if("1".equals(minute[i]))
		{
			return "1";
		}
	}

	return "0";
}

private int getMinuteOfDay(String time)
{
	List timeList = Util.TokenizerString(time, ":");
	
	return (Integer.parseInt((String)timeList.get(0)) * 60 + Integer.parseInt((String)timeList.get(1)));
}
%>

<%
int fg=2;
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(19018,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean cancelRight = HrmUserVarify.checkUserRight("Car:Maintenance",user);

char flag=2;
String tempuserid=user.getUID()+"" ;
RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next()){
    detachable=RecordSet.getInt("detachable");
   
}

int subCompanyId=0;
if(detachable==1){ 
if(request.getParameter("subCompanyId")!=null){
	subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
}else{
	subCompanyId = user.getUserSubCompany1();
}

}
else
{
subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));

}
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
}
int currentyear=today.get(Calendar.YEAR);
int thisyear=currentyear;
int currentmonth=today.get(Calendar.MONTH);
int currentday=today.get(Calendar.DATE);

switch(bywhat) {
	case 1:
		today.set(currentyear,0,1) ;
		if(movedate.equals("1")) today.add(Calendar.YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.YEAR,-1) ;
		break ;
	case 2:
		today.set(currentyear,currentmonth,1) ;
		if(movedate.equals("1")) today.add(Calendar.MONTH,1) ;
		if(movedate.equals("-1")) today.add(Calendar.MONTH,-1) ;
		break ;
	case 3:
		Date thedate = today.getTime() ;
		int diffdate = (-1)* thedate.getDay() ;
		today.add(Calendar.DATE,diffdate) ;
		if(movedate.equals("1")) today.add(Calendar.WEEK_OF_YEAR,1) ;
		if(movedate.equals("-1")) today.add(Calendar.WEEK_OF_YEAR,-1) ;
		today.add(Calendar.DATE,1);
		break;
	case 4:
		if(movedate.equals("1")) today.add(Calendar.DATE,1) ;
		if(movedate.equals("-1")) today.add(Calendar.DATE,-1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;
currentday=today.get(Calendar.DATE);  

currentdate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
temptoday1.set(currentyear,currentmonth-1,currentday) ;
temptoday2.set(currentyear,currentmonth-1,currentday) ;
switch (bywhat) {
	case 1 :
		today.add(Calendar.YEAR,1) ;
		break ;
	case 2:
		today.add(Calendar.MONTH,1) ;
		break ;
	case 3:
		today.add(Calendar.WEEK_OF_YEAR,1) ;
		break;
	case 4:
		today.add(Calendar.DATE,1) ;
		break;
}

currentyear=today.get(Calendar.YEAR);
currentmonth=today.get(Calendar.MONTH)+1;  
currentday=today.get(Calendar.DATE);  

String currenttodate = Util.add0(currentyear,4)+"-"+Util.add0(currentmonth,2)+"-"+Util.add0(currentday,2) ;
String currentWeekEnd = "";
String datefrom = "" ;
String dateto = "" ;
String datenow = "" ;

switch (bywhat) {
	case 1 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4) ;
		temptoday1.add(Calendar.YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4) ;

		temptoday2.add(Calendar.YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4) ;
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2) ;
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.WEEK_OF_YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		
		Calendar datetos = Calendar.getInstance();
		temptoday2.add(Calendar.DATE,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
}


ArrayList carIds = new ArrayList() ;
ArrayList factoryNos  = new ArrayList() ;
ArrayList carNos  = new ArrayList() ;
ArrayList carTypes  = new ArrayList() ;
//ArrayList meetingroomnames = new ArrayList() ;
if (subCompanyId!=-1)
RecordSet.executeSql("select * from CarInfo where subCompanyId="+subCompanyId);
else
RecordSet.executeSql("select * from CarInfo ");
while(RecordSet.next()){
    String carId=RecordSet.getString("id");
    String factoryNo=RecordSet.getString("factoryNo");
    String carNo=RecordSet.getString("carNo");
    String carType=RecordSet.getString("carType");
    //String tmpmeetingroomname=RecordSet.getString(2);
    carIds.add(carId) ;
    factoryNos.add(factoryNo);
    carNos.add(carNo);
    carTypes.add(carType);
    //meetingroomnames.add(tmpmeetingroomname) ;
}

//get the mapping from the select type
HashMap mrrHash= mrr.getMapping(datenow,bywhat);	
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1926,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowWeek(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(390,user.getLanguage())+SystemEnv.getHtmlLabelName(160,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())+",javascript:ShowDay(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		<FORM id=frmmain NAME=frmmain action="CarUseInfo.jsp" method=post>
		<input type=hidden name=currentdate value="<%=currentdate%>">
		<input type=hidden name=bywhat value="<%=bywhat%>">
		<input type=hidden name=movedate value="">
		<TABLE class=ViewForm>
		<TR class=Title> 
			<TH><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
		</TR>
		</table>
<div> 
<BUTTON type='button' title=<%=datefrom%> onClick="getSubdate();" name=But1>&lt;</button>
<BUTTON type='button' class=Calendar id=selectbirthday onClick="getSubTheDate()"></BUTTON> 
<span id="hiddenSpan"><%=datenow%></span>
<BUTTON type='button' title=<%=dateto%> onClick="getSupdate();"  name=But2>&gt;</button>
<style type=text/css>
.TH {
	CURSOR: auto; BACKGROUND-COLOR: beige
}
.PARENT {
	CURSOR: auto
}
.TH1 {
	CURSOR: auto; HEIGHT: 25px; BACKGROUND-COLOR: beige
}
.TODAY {
	CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.T_HOUR {
	BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.TI TD {
	BORDER-TOP: 0px; FONT-SIZE: 1px; LEFT: -1px; BORDER-LEFT: 0px; CURSOR: auto; POSITION: relative; TOP: -1px
}
.CU {
	
}
.SD {
	CURSOR: auto; COLOR: white; BACKGROUND-COLOR: mediumblue
}
.L {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.LI {
	BORDER-TOP: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.L1 {
	BORDER-TOP: white 1px solid; BORDER-LEFT: white 1px solid; CURSOR: auto; BACKGROUND-COLOR: lightgrey
}
.MI TD {
	BORDER-TOP: 1px solid; BORDER-LEFT: 1px solid
}
.WE {
	BORDER-LEFT-WIDTH: 0px
}
.PI TD {
	BORDER-RIGHT: 1px solid; BORDER-TOP: 1px solid; BORDER-LEFT: lightgrey 1px solid; BORDER-BOTTOM: 1px solid
}
</style>
</div>
<!--========================== 月 ==========================-->
<% if(bywhat==2) {%>
	<table border=0 cellspacing=0 cellpadding=0 bgcolor="">
	<TR class=Title>
		<TH align="left"><%=SystemEnv.getHtmlLabelName(18517,user.getLanguage())%></TH>
		<td align="right" width="25%">
			<table>
			<tr><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19096,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="green" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19097,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="red" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19098,user.getLanguage())%>
			</td></tr>
			</table>
		</td>
	</TR>	
	</table>
	<table class=MI id=AbsenceCard 
		style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
		cellSpacing=0 cellPadding=0>
		<tr>	
			<td>
				<table border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=9%><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></td>
						 	<td width=8%><%=SystemEnv.getHtmlLabelName(21028,user.getLanguage())%></td>
						 	<td width=8%><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
							<td width=8%><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(17647,user.getLanguage())+")"%></td>
							<td width=8%><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
						<%
						int days = Util.dayDiff(currentdate,currenttodate)-1;
					//System.out.println("days---1:"+days);
						%> 	
						<%for(int i=1;i<=days;i++){%>
							<td align=center><%=i%></td>
						<%}%>
				    </tr>
				    
				  <TR class=Line><TD colspan="<%=days+5%>"></TD></TR> 
				  
				   <% 			
				    for(int k=0;k<carIds.size();k++){
				        String carId=(String) carIds.get(k);				     
				   %>
				        <tr>
					            <td width=9%><%=Util.toScreen(CarInfoComInfo.getFactoryNo(""+carId),user.getLanguage())%></td>
					            <td width=8%><a href="CarUseInfoTwo.jsp?fg=2&carId=<%=carId%>" target="_self"><%=Util.toScreen(CarInfoComInfo.getCarNo(""+carId),user.getLanguage())%></a></td>
					            <td width=8%><%=Util.toScreen(CarTypeComInfo.getCarTypename(CarInfoComInfo.getCarType(""+carId)),user.getLanguage())%></td>
								<td width=8%><%=Util.null2String(CarInfoComInfo.getUsefee(""+carId))%>&nbsp;</td>
								<td width=8%><%=Util.null2String(SubCompanyComInfo.getSubCompanyname(CarInfoComInfo.getSubcompanyid(""+carId)))%>&nbsp;</td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)carIds.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	if (ids.size()==0) {
			            		for (int p=1 ;p<=days;p++) {
			            			out.println("<td>&nbsp;</td>");
			            		}
			            		out.println(" <TR class=Line><TD colspan='"+(days+5)+"'></TD></TR> ");
			            		continue;
			            	};	
			            				            	
								
							ArrayList drivers = (ArrayList)tempMap.get("drivers");	
							ArrayList userids = (ArrayList)tempMap.get("userids");	
							ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
							ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
							ArrayList startDates = (ArrayList)tempMap.get("startDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
								
					        for(int j=1; j<=days; j++){
					            String bgcolor=""; 
								String tdTitle = "" ;				
								String tmpdate = datenow + "-"+Util.add0(j,2) ;								
								String temp = getDayOccupied(tmpdate, startDates, startTimes, endDates, endTimes, cancels);
								for (int h=0 ;h<ids.size();h++) {
									String driver = (String)drivers.get(h);
									String userid = (String)userids.get(h);
									String startTime = (String)startTimes.get(h);
									String endTime = (String)endTimes.get(h);
									String startDate = (String)startDates.get(h);
									//System.out.println("startDate---2:"+startDate);
									String endDate = (String)endDates.get(h);
									String cancel = (String)cancels.get(h);
									if(cancel.equals("1"))continue;
									if(tmpdate.compareTo(startDate)>=0&& tmpdate.compareTo(endDate)<=0){
										tdTitle += mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+carId),driver,userid,startDate,endDate,startTime,endTime)
											+"----------------------------------------------------------"+"\n";
									}
								}
								
								if("2".equals(temp))
								{
									bgcolor="red";
								}
								else if("1".equals(temp))
								{
									bgcolor="green";
								}
					        %>      
						         <td bgcolor="<%=bgcolor%>"
						         	<%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%>
						         >&nbsp;</td>
					        <%}%> 
						</tr>
				    <tr height=2></tr>
				<%  }%>
			</table>
		</td>
	</tr>
</table>
<%}%>

<!--========================== 周 ==========================-->
<% if(bywhat==3) {%>
	<table border=0 cellspacing=0 cellpadding=0 bgcolor="">
	<TR class=Title>
		<TH align="left"><%=SystemEnv.getHtmlLabelName(18516,user.getLanguage())%></TH>
		<td align="right" width="25%">
			<table>
			<tr><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19096,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="green" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19097,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="red" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19098,user.getLanguage())%>
			</td></tr>
			</table>
		</td>
	</TR>
	</table>
	<table class=MI id=AbsenceCard 
		style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
		cellSpacing=0 cellPadding=0>
		<tr>	
			<td>
				<table width="100%" border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=9%><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></td>
						 	<td width=9%><%=SystemEnv.getHtmlLabelName(21028,user.getLanguage())%></td>
						 	<td width=9%><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
							<td width=8%><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(17647,user.getLanguage())+")"%></td>
							<td width=9%><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
						<%for(int i=0;i<7;i++){%>
							<td width=8% align=center><%=i+1%></td>
						<%}%>
				    </tr>
				    
				  <TR class=Line><TD colspan="12" ></TD></TR> 
				  
				   <% 			
				    for(int k=0;k<carIds.size();k++){
				        String carId=(String) carIds.get(k);				     
				   %>
				        <tr>
					            <td width=9%><%=Util.toScreen(CarInfoComInfo.getFactoryNo(""+carId),user.getLanguage())%></td>
					            <td width=9%><a href="CarUseInfoTwo.jsp?fg=2&carId=<%=carId%>" target="_self"><%=Util.toScreen(CarInfoComInfo.getCarNo(""+carId),user.getLanguage())%></a></td>
					            <td width=9%><%=Util.toScreen(CarTypeComInfo.getCarTypename(CarInfoComInfo.getCarType(""+carId)),user.getLanguage())%></td>
								<td width=8%><%=Util.null2String(CarInfoComInfo.getUsefee(""+carId))%>&nbsp;</td>
								<td width=9%><%=Util.null2String(SubCompanyComInfo.getSubCompanyname(CarInfoComInfo.getSubcompanyid(""+carId)))%>&nbsp;</td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)carIds.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	if (ids.size()==0) { 
			            		for (int p=0 ;p<7;p++) {
			            			out.println("<td>&nbsp;</td>");
			            		}
			            		out.println(" <TR class=Line><TD colspan='12'></TD></TR> ");
			            		continue;
			            	};	
			            				            	
							ArrayList drivers = (ArrayList)tempMap.get("drivers");	
							ArrayList userids = (ArrayList)tempMap.get("userids");	
							ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
							ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
							ArrayList startDates = (ArrayList)tempMap.get("startDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
								
					        for(int j=0; j<7; j++){
					            String bgcolor=""; 
								String tdTitle = "" ;				
								String tmpdate = TimeUtil.dateAdd(datenow,j) ;						
								String temp = getDayOccupied(tmpdate, startDates, startTimes, endDates, endTimes, cancels);
								for (int h=0 ;h<ids.size();h++) {
									String driver = (String)drivers.get(h);
									String userid = (String)userids.get(h);
									String startTime = (String)startTimes.get(h);
									String endTime = (String)endTimes.get(h);
									String startDate = (String)startDates.get(h);
									String endDate = (String)endDates.get(h);
									String cancel = (String)cancels.get(h);
									if(cancel.equals("1"))continue;
									
									if(tmpdate.compareTo(startDate)>=0&& tmpdate.compareTo(endDate)<=0){
										tdTitle += mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+carId),driver,userid,startDate,endDate,startTime,endTime)
											+"----------------------------------------------------------"+"\n";
									}
								}
								
								if("2".equals(temp))
								{
									bgcolor="red";
								}
								else if("1".equals(temp))
								{
									bgcolor="green";
								}
					        %>      
						         <td bgcolor="<%=bgcolor%>"
						         	<%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%>
						         >&nbsp;</td>
					        <%}%> 
						</tr>
				    <tr height=2></tr>
				<%  }%>
			</table>
		</td>
	</tr>
</table>
<%}%>


<!--========================== 日 ==========================-->
<% if(bywhat==4) {%> 
	<table border=0 cellspacing=0 cellpadding=0 bgcolor="" style="width: 100%">
	<TR class=Title>
		<TH align="left"><%=SystemEnv.getHtmlLabelName(18515,user.getLanguage())%></TH>
		<td align="right" width="25%">
			<table>
			<tr><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19096,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="green" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19097,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="red" width="20" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19098,user.getLanguage())%>
			</td></tr>
			</table>
		</td>
	</TR>	
	</table>
  	<table class=MI id=AbsenceCard 
		style="BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: hand; BORDER-BOTTOM: 1px solid" 
		cellSpacing=0 cellPadding=0>
		<tr>	
			<td>
				<table width="100%" border=1 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=8%><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></td>
						 	<td width=8%><%=SystemEnv.getHtmlLabelName(21028,user.getLanguage())%></td>
						 	<td width=8%><%=SystemEnv.getHtmlLabelName(17651,user.getLanguage())%></td>
							<td width=8%><%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(17647,user.getLanguage())+")"%></td>
							<td width=8%><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></td>
						<%for(int i=0;i<24;i++){%>
							<td width=2.5% align=center><%=i%></td>
						<%}%>
				    </tr>
				    
				  <TR class=Line><TD colspan="30" ></TD></TR> 
				  
				   <% 			
				    for(int k=0;k<carIds.size();k++){
				        String carId=(String) carIds.get(k);				     
				   %>
				        <tr>
					            <td width=8%><%=Util.toScreen(CarInfoComInfo.getFactoryNo(""+carId),user.getLanguage())%></td>
					            <td width=8%><a href="CarUseInfoTwo.jsp?fg=2&carId=<%=carId%>" target="_self"><%=Util.toScreen(CarInfoComInfo.getCarNo(""+carId),user.getLanguage())%></a></td>
					            <td width=8%><%=Util.toScreen(CarTypeComInfo.getCarTypename(CarInfoComInfo.getCarType(""+carId)),user.getLanguage())%></td>
								<td width=8%><%=Util.null2String(CarInfoComInfo.getUsefee(""+carId))%>&nbsp;</td>
								<td width=8%><%=Util.null2String(SubCompanyComInfo.getSubCompanyname(CarInfoComInfo.getSubcompanyid(""+carId)))%>&nbsp;</td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)carIds.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	if (ids.size()==0) {
			            		for (int p=0 ;p<24;p++) {
			            			out.println("<td>&nbsp;</td>");
			            		}
			            		out.println(" <TR class=Line><TD colspan='30'></TD></TR> ");
			            		continue;
			            	};	
			            				            	
							ArrayList drivers = (ArrayList)tempMap.get("drivers");	
							ArrayList userids = (ArrayList)tempMap.get("userids");	
							ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
							ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
							ArrayList startDates = (ArrayList)tempMap.get("startDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");
							ArrayList cancels = (ArrayList)tempMap.get("cancels");

					        for(int j=0; j<24; j++){
					            String bgcolor=""; 
								String tdTitle = "" ;												
								String tempTime = datenow+" "+Util.add0(j,2) ;	
								String temp = getHourOccupied(datenow, Util.add0(j,2), startDates, startTimes, endDates, endTimes, cancels);
								for (int h=0 ;h<ids.size();h++) {
									String driver = (String)drivers.get(h);
									String userid = (String)userids.get(h);
									String startTime = (String)startTimes.get(h);
									String endTime = (String)endTimes.get(h);
									String startDate = (String)startDates.get(h);
									String endDate = (String)endDates.get(h);									
									
									String tempBeginDateTime = startDate+" "+startTime.substring(0,startTime.indexOf(":"));
									String tempEndDateTime = endDate+" "+endTime.substring(0,endTime.indexOf(":"));	
									String cancel = (String)cancels.get(h);
									if(cancel.equals("1"))continue;
									
									if(tempTime.compareTo(tempBeginDateTime)>=0&& tempTime.compareTo(tempEndDateTime)<=0){
										tdTitle += mrr.getCarInfoUseCase(CarInfoComInfo.getCarNo(""+carId),driver,userid,startDate,endDate,startTime,endTime)
											+"----------------------------------------------------------"+"\n";
									}
								}
								if("2".equals(temp))
								{
									bgcolor="red";
								}
								else if("1".equals(temp))
								{
									bgcolor="green";
								}
					        %>      
						         <td bgcolor="<%=bgcolor%>"
						         	<%if(!"".equals(tdTitle)) {%>title="<%=tdTitle%>"<%}%>
						         >&nbsp;</td>
					        <%}%> 
						</tr>
				    <tr height=2></tr>
				<%  }%>
			</table>
		</td>
	</tr>
</table>
<%}%>

<!-- next show meeting use list -->
<table width="100%">
<tr class=Title>
	 <th colspan=6><%=SystemEnv.getHtmlLabelName(19018,user.getLanguage())%></th>
</tr>
<tr>
<td>
<table class=liststyle style="margin:0px">
	<col width=10%>
	<col width=30%>
	<col width=10%>
	<col width=20%>
	<col width=20%>
	<col width=10%>

	<tr class=header>
	    <th><%=SystemEnv.getHtmlLabelName(21028,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(648,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></th>
	    <th><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></th>
	    <th></th>
	</tr>
<%
	//modify by dongping for
	//会议报表只显示当日的会议占用情况
	//String listsql=mrr.getSqlNobyCar(datenow,bywhat);
	// bywhat  2: 为本月 3:为本周 4:为本日
	//out.println(listsql);
	boolean islight=true ;
	for(int i=0;i<carIds.size();i++){
        String carId = (String)carIds.get(i) ;
		HashMap tempMap = (HashMap)mrrHash.get(carId); 		
		ArrayList ids = (ArrayList)tempMap.get("ids");
		ArrayList drivers = (ArrayList)tempMap.get("drivers");
		ArrayList userids = (ArrayList)tempMap.get("userids");
		ArrayList startDates = (ArrayList)tempMap.get("startDates");
		ArrayList endDates = (ArrayList)tempMap.get("endDates");
		ArrayList startTimes = (ArrayList)tempMap.get("startTimes");
		ArrayList endTimes = (ArrayList)tempMap.get("endTimes");
		ArrayList requestids = (ArrayList)tempMap.get("requestids");
		ArrayList cancels = (ArrayList)tempMap.get("cancels");
		ArrayList currentnodetypes = (ArrayList)tempMap.get("currentnodetypes");
		
		for (int j=0;j<ids.size();j++) {
			String id = (String)ids.get(j) ;
			String driver = (String)drivers.get(j);
			String userid = (String)userids.get(j);
			String startDate = (String)startDates.get(j);
			String endDate = (String)endDates.get(j);
			String startTime = (String)startTimes.get(j);
			String endTime = (String)endTimes.get(j);
			String requestid = (String)requestids.get(j);
			String cancel = (String)cancels.get(j);
			String currentnodetype = (String)currentnodetypes.get(j);
	%>
	    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	        <td><a href="/car/CarInfoView.jsp?id=<%=carId%>"><%=CarInfoComInfo.getCarNo(carId)%></a></td>
	        <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=RequestComInfo.getRequestname(requestid)%></a></td>
	        <td><%=RequestComInfo.getRequestStatus(requestid)%></td>
	        <td><%=Util.toScreen(startDate+" "+startTime,user.getLanguage())%></td>
	        <td><%=Util.toScreen(endDate+" "+endTime,user.getLanguage())%></td>
	        <td><%if(cancelRight&&currentnodetype.equals("3")&&cancel.equals("")){%><a href="javascript:doCancel(<%=id%>)"><%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%></a><%}else if(cancelRight&&currentnodetype.equals("3")&&cancel.equals("1")){%><%=SystemEnv.getHtmlLabelName(1981,user.getLanguage())%><%}%></td>
	    </tr>
	<%
	    islight=!islight ;
	    }			
	}
	%>
</table>
</td>
</tr>
</table>

		</FORM>
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
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	frmmain.resourceid.value=id(0)
	document.frmmain.submit()
	end if
	end if
end sub
</script>

<script language=javascript>

function getSubdate() {
	document.frmmain.movedate.value = "-1" ;
	document.frmmain.submit() ;
}
function getSupdate() {
	document.frmmain.movedate.value = "1" ;
	document.frmmain.submit() ;
}
function ShowYear() {
	document.frmmain.bywhat.value = "1" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowMONTH() {
	document.frmmain.bywhat.value = "2" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowWeek() {
	document.frmmain.bywhat.value = "3" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}
function ShowDay() {
	document.frmmain.bywhat.value = "4" ;
	document.frmmain.currentdate.value = "" ;
	document.frmmain.submit() ;
}

function doCancel(id){
	document.frmmain.action="CarUseInfoOperation.jsp?operation=cancel&id="+id+"&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>";
	document.frmmain.submit() ;
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
</html>