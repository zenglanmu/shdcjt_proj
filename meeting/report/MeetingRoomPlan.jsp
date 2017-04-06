<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="mrr" class="weaver.meeting.Maint.MeetingRoomReport" scope="page"/>
<jsp:useBean id="SptmForMeeting" class="weaver.splitepage.transform.SptmForMeeting" scope="page"/>

<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<style type="text/css">
.selectable .ui-selecting { background: #FECA40;}
.selectable .ui-selected { background: #F39814; color: white; }
.selectable { list-style-type: none; margin: 0; padding: 0;cursor :pointer; }
</style>
</head>
<%!
public String getDayOccupied(String thisDate, List beginDateList, List beginTimeList, List endDateList, List endTimeList, List cancelList)
{
	String[] minute = new String[24 * 60];
	
	for (int i = 0; i < beginDateList.size(); i++)
	{
		String beginDate = (String)beginDateList.get(i);
		String beginTime = (String)beginTimeList.get(i);
		String endDate = (String)endDateList.get(i);
		String endTime = (String)endTimeList.get(i);
		String cancel = (String)cancelList.get(i);
				
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
	String[] minute = new String[24 * 60];
	
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
Calendar calendar = Calendar.getInstance();

RecordSet.executeSql("select detachable from SystemSet");
int detachable=0;
if(RecordSet.next())
{
    detachable=RecordSet.getInt("detachable");
}
    

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(15881,user.getLanguage());
String needfav ="1";
String needhelp ="";
char flag=2;
String userid=user.getUID()+"" ;
ArrayList newMeetIds = new ArrayList() ;
boolean cancelRight = HrmUserVarify.checkUserRight("Canceledpermissions:Edit",user);
//1: year 2:month 3:week 4:today but the year haven`t been used!
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);

String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));
String operation=Util.null2String(request.getParameter("operation"));
int meetingid=Util.getIntValue(request.getParameter("id"),0);
Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String nowtime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2);   
if(operation.equals("cancel")){
    RecordSet.executeSql("update meeting set cancel='1',meetingStatus=4,canceldate='"+nowdate+"',canceltime='"+nowtime+"' where id="+meetingid);
}

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
		int diffdate = (-1)*thedate.getDay() ;
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

calendar.set(currentyear, currentmonth - 1, currentday);
calendar.add(Calendar.MONTH, 1);
calendar.set(Calendar.DATE, 1);
calendar.add(Calendar.DATE, -1);
int daysOfThisMonth = calendar.get(Calendar.DATE);


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
String 	currentWeekEnd = "";
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

ArrayList meetingroomids = new ArrayList() ;
ArrayList meetingroomnames = new ArrayList() ;

if(1 == detachable)
//分权
{
    if(1 == user.getUID())
    //系统管理员
    {
        RecordSet.executeProc("MeetingRoom_SelectAll","");
        //System.out.println("fen:123");
    }
    else 
    {
        boolean countType = false;
        RecordSet.executeSql("SELECT 1 FROM HrmResourceManager WHERE id = " + user.getUID());
        if(RecordSet.next())
        {
            countType = true;
        }
        
        if(countType)
	    //管理员帐号
	    {
	        int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "MeetingRoomAdd:Add");
	        String subCompanyString = "-1";
	        for(int i = 0; i < subCompany.length; i++)
	        {
	            subCompanyString += "," + subCompany[i];
	        }
	        //System.out.println("fen1:" + user.getUID() + "SELECT * FROM MeetingRoom WHERE subCompanyId in (" + subCompanyString + ")");
	        RecordSet.executeSql("SELECT * FROM MeetingRoom WHERE subCompanyId in (" + subCompanyString + ") order by id");
	    }
	    else
	    //一般人员
	    {
	        int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "MeetingRoomAdd:Add");
	        String subCompanyString = departmentComInfo.getSubcompanyid1(String.valueOf(user.getUserDepartment()));
	        for(int i = 0; i < subCompany.length; i++)
	        {
	            subCompanyString += "," + subCompany[i];
	        }
	        //System.out.println("fen2:" + "SELECT * FROM MeetingRoom WHERE subCompanyId in (" + subCompanyString + ")");
	        RecordSet.executeSql("SELECT * FROM MeetingRoom WHERE subCompanyId in (" + subCompanyString + ") order by id");
	    }
    }
}
else
//不分权
{
    RecordSet.executeProc("MeetingRoom_SelectAll","");
}

while(RecordSet.next()){
    String tmpmeetingroomid=RecordSet.getString(1);
    String tmpmeetingroomname=RecordSet.getString(2);
    meetingroomids.add(tmpmeetingroomid) ;
    meetingroomnames.add(tmpmeetingroomname) ;
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(15008,user.getLanguage())+",/meeting/data/AddMeeting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr style="height:0px;">
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmmain name=frmmain method=post action="MeetingRoomPlan.jsp">
<input type=hidden name=currentdate value="<%=currentdate%>">
<input type=hidden name=bywhat value="<%=bywhat%>">
<input type=hidden name=movedate value="">
   <TABLE class=ViewForm>
    <TR class=Title> 
      <TH colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR class= Spacing> 
      <TD CLASS=Sep1 colspan=4></TD>
    </TR>
  </table>
  <br>
  <div> 
<button title=<%=datefrom%> onclick="getSubdate();" name=But1>&lt;</button>
<BUTTON class=calendar type=button onclick="gethbtheDate(subscribeDateFrom,subscribeDateFromSpan)"></BUTTON>
<SPAN id=subscribeDateFromSpan ><%=datenow%></SPAN>
<input type="hidden" name="subscribeDateFrom" value="<%=datenow%>">
<script>
function gethbtheDate(inputname,spanname){
    WdatePicker({el:spanname,
    		onpicked:function(dp){jQuery("#frmmain")[0].currentdate.value = dp.cal.getDateStr();
			document.frmmain.submit();},
			oncleared:function(dp){jQuery("input[name="+inputname+"]").val("");}//$dp.getElement(inputname).value =''
			});
}
</script>
<button title=<%=dateto%> onclick="getSupdate();"  name=But2>&gt;</button>
<style type=text/css>.TH {
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
  <br>
  
<!--============================ 月报表 ============================-->
<% if(bywhat==2) {%>
  <table border=0 cellspacing=0 cellpadding=0 bgcolor="" width="100%">
	<TR class=Title>
		<TH align="left" width="75%"><%=SystemEnv.getHtmlLabelName(18517,user.getLanguage())%></TH>
		<td align="right" width="25%">
			<table>
			<tr><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="" width="15" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19096,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="green" width="15" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19097,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="red" width="15" style="border-width:1">&nbsp;</td></tr>
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
				<table border=0 cellspacing=2 cellpadding=2 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=22.5%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
						<%for(int i=0;i<daysOfThisMonth;i++){%>
							<td width=2.5% align=center><%=i+1%></td>
						<%}%>
				    </tr>
				   <% 			
				    for(int k=0;k<meetingroomids.size();k++){
				        String tmproomid=(String) meetingroomids.get(k);				     
				   %>
				        <tr>
					            <td width=22.5%><%=Util.forHtml(Util.toScreen(MeetingRoomComInfo.getMeetingRoomInfoname(""+tmproomid),user.getLanguage()))%></td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)meetingroomids.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	
			            	if (ids.size()==0) { 
			            		for (int p=0 ;p<daysOfThisMonth;p++) {
			            			out.println("<td></td>");
			            		}
			            		out.println(" <TR class=Line ><TD style='padding:0;' colspan=" + (Integer.parseInt(""+daysOfThisMonth)+1)+ "></TD></TR> ");
			            		continue;
			            	};	
			            				            	
							ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");								
							ArrayList names = (ArrayList)tempMap.get("names");	
							ArrayList totalmembers = (ArrayList)tempMap.get("totalmembers");	
							ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
							ArrayList callers = (ArrayList)tempMap.get("callers");
							ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
							ArrayList contacters = (ArrayList)tempMap.get("contacters");	
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
					        for(int j=0; j<daysOfThisMonth; j++)
					        {
					            String bgcolor="#f5f5f5"; 
								String tdTitle = "" ;				
								String tmpdate = datenow + "-"+Util.add0(j+1,2) ;	//for td4306						
								String temp = getDayOccupied(tmpdate, beginDates, begintimes, endDates, endtimes, cancels);
								for (int h=0 ;h<ids.size();h++) 
								{
									String beginDate = (String)beginDates.get(h);
									String endDate = (String)endDates.get(h);
									
									String name = (String)names.get(h);
									String totalmember = (String)totalmembers.get(h);
									String caller = (String)callers.get(h);
									String contacter = (String)contacters.get(h);
									String begintime = (String)begintimes.get(h);
									String endtime = (String)endtimes.get(h);
									String cancel = (String)cancels.get(h);
									if(cancel.equals("1"))continue;
									if(tmpdate.compareTo(beginDate)>=0 && tmpdate.compareTo(endDate)<=0)
									{                                                                                
                                        if(tdTitle.equals(""))
                                        {
                                             tdTitle =mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime);
                                        }
                                        else
                                        {
                                             tdTitle +="\n"+"----------------------------------------------------------"+
                                                     mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime);
										}
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
						         ></td>
					        <%}%> 
						</tr>
				    <tr height=5></tr>
				<%  }%>
			</table>
		</td>
	</tr>
</table>
<%}%>


<!--============================ 周报表 ============================-->
<% if(bywhat==3) {%>
  <table border=0 cellspacing=0 cellpadding=0 bgcolor="" width="100%">
	<TR class=Title>
		<TH align="left" width="75%"><%=SystemEnv.getHtmlLabelName(18516,user.getLanguage())%></TH>
		<td align="right" width="25%">
			<table>
			<tr><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="" width="15" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19096,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="green" width="15" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19097,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="red" width="15" style="border-width:1">&nbsp;</td></tr>
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
				<table width="100%" border=0 cellspacing=2 cellpadding=2 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=22.5%><%=SystemEnv.getHtmlLabelName(18518,user.getLanguage())%></td>
						<%for(int i=0;i<7;i++){%>
							<td width=11% align=center><%=i+1%></td>
						<%}%>
				    </tr>
				   <% 			
				    for(int k=0;k<meetingroomids.size();k++){
				        String tmproomid=(String) meetingroomids.get(k);				     
				   %>
				        <tr>
					            <td width=22.5%><%=Util.forHtml(Util.toScreen(MeetingRoomComInfo.getMeetingRoomInfoname(""+tmproomid),user.getLanguage()))%></td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)meetingroomids.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	
			            	if (ids.size()==0) { 
			            		for (int p=0 ;p<7;p++) {
			            			out.println("<td></td>");
			            		}
			            		out.println(" <TR class=Line><TD colspan='8'></TD></TR> ");
			            		continue;
			            	};	
			            				            	
							ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");								
							ArrayList names = (ArrayList)tempMap.get("names");	
							ArrayList totalmembers = (ArrayList)tempMap.get("totalmembers");	
							ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
							ArrayList callers = (ArrayList)tempMap.get("callers");
							ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
							ArrayList contacters = (ArrayList)tempMap.get("contacters");	
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
					        for(int j=0; j<7; j++){
					            String bgcolor="#f5f5f5"; 
								String tdTitle = "" ;				
								String tmpdate = TimeUtil.dateAdd(datenow,j) ;						
								String temp = getDayOccupied(tmpdate, beginDates, begintimes, endDates, endtimes, cancels);
								for (int h=0 ;h<ids.size();h++) {
									String beginDate = (String)beginDates.get(h);
									String endDate = (String)endDates.get(h);
									
									String name = (String)names.get(h);
									String totalmember = (String)totalmembers.get(h);
									String caller = (String)callers.get(h);
									String contacter = (String)contacters.get(h);
									String begintime = (String)begintimes.get(h);
									String endtime = (String)endtimes.get(h);
									String cancel = (String)cancels.get(h);
									if(cancel.equals("1"))continue;
									if(tmpdate.compareTo(beginDate)>=0&& tmpdate.compareTo(endDate)<=0){
										 if(tdTitle.equals("")){
                                             tdTitle =mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime);
                                         }else{
                                             tdTitle +="\n"+"----------------------------------------------------------"+
                                                     mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime);
                                         }
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
						         ></td>
					        <%}%> 
						</tr>
				    <tr height=5></tr>
				<%  }%>
			</table>
		</td>
	</tr>
</table>
<%}%>


<!--============================ 日报表 ============================-->
<% if(bywhat==4) {%>
  <table border=0 cellspacing=0 cellpadding=0 bgcolor="" width="100%">
	<TR class=Title>
		<TH align="left" width="75%"><%=SystemEnv.getHtmlLabelName(18515,user.getLanguage())%></TH>
		<td align="right" width="25%">
			<table>
			<tr><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="" width="15" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19096,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="green" width="15" style="border-width:1">&nbsp;</td></tr>
				</table>
			</td><td>
				&nbsp;<%=SystemEnv.getHtmlLabelName(19097,user.getLanguage())%>
			</td><td>
				<table border=1 cellspacing=0 cellpadding=0 bgcolor="">
				<tr><td bgcolor="red" width="15" style="border-width:1">&nbsp;</td></tr>
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
				<table width="100%" border=0 cellspacing=2 cellpadding=2 Style="width:100%; font-size:8pt;table-layout:fixed">
				   
				    <tr  bgcolor=lightblue>
						 	<td width=22.5%><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></td>
						<%for(int i=0;i<24;i++){%>
							<td width=3.5% align=center><%=i%></td>
						<%}%>
				    </tr>
				   <% 			
				    for(int k=0;k<meetingroomids.size();k++){
				        String tmproomid=(String) meetingroomids.get(k);				     
				   %>
				        <tr class="selectable">
					            <td width=22.5%><%=Util.forHtml(Util.toScreen(MeetingRoomComInfo.getMeetingRoomInfoname(""+tmproomid),user.getLanguage()))%></td>
					        <%					        
					        HashMap tempMap = (HashMap)mrrHash.get((String)meetingroomids.get(k));  
					        ArrayList ids = (ArrayList)tempMap.get("ids");				        
			            	
			            	if (ids.size()==0) { 
			            		for (int p=0 ;p<24;p++) {
			            			out.println("<td id='"+tmproomid+"' target='"+p+"' onmousedown='createMeetingAction.startDrag(event);' bgcolor='#f5f5f5'>&nbsp;</td>");
			            		}
			            		//out.println(" <TR class=Line><TD colspan='25'></TD></TR> "); 
			            		continue;
			            	};	
			            				            	
							ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
							ArrayList endDates = (ArrayList)tempMap.get("endDates");								
							ArrayList names = (ArrayList)tempMap.get("names");	
							ArrayList totalmembers = (ArrayList)tempMap.get("totalmembers");	
							ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
							ArrayList callers = (ArrayList)tempMap.get("callers");
							ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
							ArrayList contacters = (ArrayList)tempMap.get("contacters");	
							ArrayList cancels = (ArrayList)tempMap.get("cancels");
					        for(int j=0; j<24; j++){
					            String bgcolor="#f5f5f5"; 
								String tdTitle = "" ;												
								String tempTime = datenow+" "+Util.add0(j,2) ;	
								String temp=getHourOccupied(datenow, Util.add0(j,2), beginDates, begintimes, endDates, endtimes, cancels);
								for (int h=0 ;h<ids.size();h++) {
									String beginDate = (String)beginDates.get(h);
									String endDate = (String)endDates.get(h);
									
									String name = (String)names.get(h);
									String totalmember = (String)totalmembers.get(h);
									String caller = (String)callers.get(h);
									String contacter = (String)contacters.get(h);
									String begintime = (String)begintimes.get(h);
									String endtime = (String)endtimes.get(h);
									String cancel = (String)cancels.get(h);
									if(cancel.equals("1"))continue;
									
									String tempBeginDateTime = beginDate+" "+begintime.substring(0,begintime.indexOf(":"));
									String tempEndDateTime = endDate+" "+endtime.substring(0,endtime.indexOf(":"));	
																		
									if(tempTime.compareTo(tempBeginDateTime)>=0&& tempTime.compareTo(tempEndDateTime)<=0){
                                         if(tdTitle.equals("")){
                                             tdTitle =mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime);
                                         }else{
                                             tdTitle +="\n"+"----------------------------------------------------------"+
                                                     mrr.getMeetRoomUseCase(name,totalmember,caller,contacter,beginDate,endDate,begintime,endtime);
                                         }
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
						         <td id="<%=tmproomid %>" target="<%=j %>" onmousedown='createMeetingAction.startDrag(event);' bgcolor="<%=bgcolor%>" <%if(!"".equals(tdTitle)) {%> title="<%=tdTitle%>"<%}%>>&nbsp;</td>
					        <%}%> 
						</tr>
				<%  }%>
			</table>
		</td>
	</tr>
</table>
<%}%>


<!-- next show meeting use list -->
<table class=listshort>
	<col width=15%>
	<col width=10%>
	<col width=10%>
	<col width=15%>
	<col width=10%>
	<col width=10%>
	<col width=10%>
	<col width=10%>
	<col width=6%>
    <col width=4%>
    <tr class=Title>
	    <th colspan=10><%=SystemEnv.getHtmlLabelName(18514,user.getLanguage())%></th>
	</tr>

	<TR class= Spacing> 
	      <TD CLASS=Sep1 colspan=10></TD>
	</TR>
	
	<tr class=header>
	    <td><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
	    <td><%=SystemEnv.getHtmlLabelName(22260,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
    <tr>
<%
	//modify by dongping for
	//会议报表只显示当日的会议占用情况
	String listsql=mrr.getSqlNobyRoom(datenow,bywhat);
	// bywhat  2: 为本月 3:为本周 4:为本日
	//out.println(listsql);
	
	 for(int i=0;i<meetingroomids.size();i++){
	    boolean islight=true ;
        String mettingRoomId = (String)meetingroomids.get(i) ;
		HashMap tempMap = (HashMap)mrrHash.get(mettingRoomId); 		
		ArrayList ids = (ArrayList)tempMap.get("ids");
		ArrayList names = (ArrayList)tempMap.get("names");	
		ArrayList beginDates = (ArrayList)tempMap.get("beginDates");
		ArrayList endDates = (ArrayList)tempMap.get("endDates");				
		ArrayList begintimes = (ArrayList)tempMap.get("begintimes");
		ArrayList endtimes = (ArrayList)tempMap.get("endtimes");
		ArrayList cancels = (ArrayList)tempMap.get("cancels");
		List callerList = (ArrayList)tempMap.get("callers");
		List meetingTypeList = (ArrayList)tempMap.get("meetingTypes");
		
		for (int j=0;j<ids.size();j++) {
			String id = (String)ids.get(j) ;
			String name = (String)names.get(j) ;
			String beginDate = (String)beginDates.get(j) ;
			String endDate = (String)endDates.get(j) ;
			String begintime = (String)begintimes.get(j) ;
			String endtime = (String)endtimes.get(j) ;
			String cancel = (String)cancels.get(j);
			String caller = (String)callerList.get(j);
			String meetingType = (String)meetingTypeList.get(j);
			String statusid = "";
			RecordSet.executeSql("select meetingstatus from meeting where id="+id);
			if(RecordSet.next()) statusid = RecordSet.getString(1);
			String paratmp = ""+user.getLanguage()+"+"+endDate+"+"+endtime+"+0";
			String statustmp = SptmForMeeting.getMeetingStatus(statusid,paratmp);
	%>
	    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
	        <td><a href="/meeting/data/ProcessMeeting.jsp?meetingid=<%=id%>"><%=Util.forHtml(Util.toScreen(name,user.getLanguage()))%></a></td>
	        <td><A href="/hrm/resource/HrmResource.jsp?id=<%= caller %>"><%= resourceComInfo.getResourcename(caller) %></A></td>
	        <td><%= meetingType %></td>
	        <td><%=Util.forHtml(MeetingRoomComInfo.getMeetingRoomInfoname(mettingRoomId))%></td>
	        <td><%=Util.toScreen(beginDate,user.getLanguage())%></td>
	        <td><%=Util.toScreen(begintime,user.getLanguage())%></td>
	        <td><%=Util.toScreen(endDate,user.getLanguage())%></td>
	        <td><%=Util.toScreen(endtime,user.getLanguage())%></td>
	        <td><%=statustmp%></td>
            <%if(cancelRight){%>
            <td><%if(!cancel.equals("1")){%><a href="javascript:doCancel(<%=id%>)"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></a><%}else{%><%=SystemEnv.getHtmlLabelName(20114,user.getLanguage())%><%}%></td>
            <%}else{%>
			<td></td>	
			<%} %>
        </tr>
	<%
	    islight=!islight ;
	    }			
	}
	%>
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
jQuery(document).ready(function(){
	jQuery("body").bind("mousemove", function(event){createMeetingAction.moving(event)});
	jQuery("body").bind("mouseup", function(event){createMeetingAction.stopDrag(event)});
})
var enable = true;

function CreateMeetingAction()
{
	this.roomid;
	this.active;
	this.startTime;
	this.endTime;
}
CreateMeetingAction.prototype.startDrag = function(event)
{
	this.roomid = "";
	this.startTime = "";
	this.endTime = "";
	this.active = false;
	//alert(event.button);
	event = jQuery.event.fix(event);
	if(enable && (0 == event.button || 1 == event.button))
	{
		var startElement = event.target;
		this.roomid = startElement.id;
		this.startTime =jQuery(startElement).attr("target");
		this.endTime = jQuery(startElement).attr("target");
		startElement.className = "ui-selecting";
		jQuery(startElement).css("background-color","#FECA40");
		this.active = true;
	}
}
CreateMeetingAction.prototype.moving = function(event)
{
	if(enable && this.active)
	{
		event = jQuery.event.fix(event);
		var movingElement = event.target;
		var pElement = movingElement.parentNode;
		if(pElement.tagName=="TR"&&pElement.className=="selectable")
		{
			var roomid = movingElement.id;
			if(roomid==this.roomid)
			{
				this.roomid = movingElement.id;
				this.endTime = jQuery(movingElement).attr("target");
				movingElement.className = "ui-selecting";
				jQuery(movingElement).css("background-color","#FECA40");
			}
		}
	}
}
CreateMeetingAction.prototype.stopDrag = function(event)
{
	event = jQuery.event.fix(event);
	if(enable && this.active)
	{
		this.createMeeting();
		this.active = false;
	}
}
CreateMeetingAction.prototype.createMeeting = function()
{
	var url = "/systeminfo/BrowserMain.jsp?url=/meeting/data/AddMeeting_left.jsp?";
	url +="roomid="+this.roomid;
	var currentdate = document.frmmain.currentdate.value;
	url +="&startdate="+currentdate;
	url +="&enddate="+currentdate;
	var tempStartTime = this.startTime;
	var tempEndTime = this.endTime;
	if(parseInt(tempStartTime)>parseInt(tempEndTime))
	{
		var temp = this.startTime;
		this.startTime = this.endTime;
		this.endTime = temp;
	}
	if(this.startTime.length==1)
	{
		this.startTime = "0"+this.startTime;
	}
	this.startTime += ":00";
	if(this.endTime.length==1)
	{
		this.endTime = "0"+this.endTime;
	}
	this.endTime += ":59";
	url +="&starttime="+this.startTime;
	url +="&endtime="+this.endTime;
	var isused = checkMeetingRoom();
	var iscontinue = false;
	if(isused)
	{
		iscontinue=confirm("<%=SystemEnv.getHtmlLabelName(19095,user.getLanguage())%>")
	}
	else
	{
		iscontinue = true;
	}
	if(iscontinue)
	{
		var rvalue = window.showModalDialog(url,'','dialogWidth:650px;dialogHeight:500px;');
		window.location.reload();
	}
	else
	{
		resetMeetingRoom();
	}
}
var createMeetingAction = new CreateMeetingAction();
function checkMeetingRoom()
{
	var tds = document.getElementsByTagName("TD");
	for(var i=0;i<tds.length;i++)
	{
		var cname = tds[i].className;
		if(cname=="ui-selecting")
		{
			var bc = tds[i].bgColor;
			if(bc !=""&&bc != "#f5f5f5")
			{
				return "1";
			}
		}
	}
}
function resetMeetingRoom()
{
	var tds = document.getElementsByTagName("TD");
	for(var i=0;i<tds.length;i++)
	{
		var cname = tds[i].className;
		if(cname=="ui-selecting")
		{
			tds[i].className = "";
			jQuery(tds[i]).css("background-color","");
		}
	}
}
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
	document.frmmain.action="MeetingRoomPlan.jsp?operation=cancel&id="+id;
	document.frmmain.submit() ;
}
</script>


</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>

