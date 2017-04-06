<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.tools.Time" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement" %>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement" %>
<%@ page import="weaver.hrm.resource.SptmForLeave"%>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>


<%
Time time = new Time();
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(6140,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

String resourceid=Util.null2String(request.getParameter("resourceid"));
String diffid =Util.null2String(request.getParameter("diffid"));
String subcompanyid = ResourceComInfo.getSubCompanyID(resourceid);

String attendancetype = Util.null2String(request.getParameter("attendancetype"));
String attendancetypename = Util.null2String(request.getParameter("attendancetypename"));
String leavetype = "";
String otherleavetype = "";
String leavesqlwhere = "";
if(!attendancetype.equals("")){
   if(Util.TokenizerString2(attendancetype,"_")[0].equals("otherleavetype")){
       otherleavetype = Util.TokenizerString2(attendancetype,"_")[1];
       leavesqlwhere = " and leavetype = 4 and otherleavetype = " + otherleavetype;
   }else{
       leavetype = Util.TokenizerString2(attendancetype,"_")[1];
       leavesqlwhere = " and leavetype = " + leavetype;
   }
}


if(!resourceid.equals(""+user.getUID()) && !ResourceComInfo.getManagerID(resourceid).equals(""+user.getUID()) && !HrmUserVarify.checkUserRight("HrmResource:Absense",user,ResourceComInfo.getDepartmentID(resourceid)) && (user.getSeclevel()).compareTo(ResourceComInfo.getSeclevel(resourceid))<0 ) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int bywhat = Util.getIntValue(request.getParameter("bywhat"),1);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));
String relatewfid = Util.null2String(request.getParameter("relatewfid"));

Calendar today = Calendar.getInstance();
Calendar temptoday1 = Calendar.getInstance();
Calendar temptoday2 = Calendar.getInstance();

if(!currentdate.equals("")) {
	int tempyear = Util.getIntValue(currentdate.substring(0,4)) ;
	int tempmonth = Util.getIntValue(currentdate.substring(5,7))-1 ;
	int tempdate = Util.getIntValue(currentdate.substring(8,10)) ;
	today.set(tempyear,tempmonth,tempdate);
}
	
int currentyear=today.get(Calendar.YEAR);
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
        leavesqlwhere += " and ( (startdate >= '" + datenow + "-01-01' and startdate <= '" + datenow + "-12-31') or (enddate >= '" + datenow + "-01-01' and enddate <= '" + datenow + "-12-31') or (startdate < '" + datenow + "-01-01' and enddate > '" + datenow + "-12-31') )";
		break ;
	case 2 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;
		temptoday1.add(Calendar.MONTH,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2) ;

		temptoday2.add(Calendar.MONTH,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "-01' and startdate <= '" + datenow + "-31') or (enddate >= '" + datenow + "-01' and enddate <= '" + datenow + "-31') or (startdate < '" + datenow + "-01' and enddate > '" + datenow + "-31') )";
		break ;
 	case 3 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.WEEK_OF_YEAR,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;

		temptoday2.add(Calendar.WEEK_OF_YEAR,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
        leavesqlwhere += " and ( (startdate >= '" + datenow + "' and startdate < '" + dateto + "') or (enddate >= '" + datenow + "' and enddate < '" + dateto + "') or (startdate < '" + datenow + "' and enddate >= '" + dateto + "') )";
		break ;
	case 4 :
		datenow = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		temptoday1.add(Calendar.DATE,-1) ;
		datefrom = Util.add0(temptoday1.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday1.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday1.get(Calendar.DATE),2) ;
		
		Calendar datetos = Calendar.getInstance();
		temptoday2.add(Calendar.DATE,1) ;
		dateto = Util.add0(temptoday2.get(Calendar.YEAR),4)+"-"+Util.add0(temptoday2.get(Calendar.MONTH)+1,2)+"-"+Util.add0(temptoday2.get(Calendar.DATE),2) ;
        leavesqlwhere += " and startdate <= '" + datenow + "' and enddate >= '" + datenow + "'";
}

ArrayList ids = new ArrayList() ;
ArrayList resourceids = new ArrayList() ;
ArrayList diffids = new ArrayList() ;
ArrayList startdates = new ArrayList() ;
ArrayList starttimes = new ArrayList() ;
ArrayList enddates = new ArrayList() ;
ArrayList endtimes = new ArrayList() ;
ArrayList subjects = new ArrayList() ;

ArrayList memos = new ArrayList() ;

String sql = "select * from HrmAnnualLeaveInfo where resourceid = "+resourceid + leavesqlwhere;
String querystr = "select * from HrmScheduleMaintance where resourceid = "+resourceid;
if(!diffid.equals("")&&!diffid.equals("0")){
  //querystr += " and diffid = "+diffid;
}
querystr += " order by startdate ,starttime" ;


querystr = sql;

SptmForLeave sfl = new SptmForLeave();

RecordSet.executeSql(querystr);
while(RecordSet.next()) {
ids.add(Util.null2String(RecordSet.getString("id"))) ;
resourceids.add(Util.null2String(RecordSet.getString("resourceid"))) ;
diffids.add(Util.null2String(sfl.getLeaveTypeColor(RecordSet.getString("leavetype"),RecordSet.getString("otherleavetype"),subcompanyid))) ;
startdates.add(Util.null2String(RecordSet.getString("startdate"))) ;
starttimes.add(Util.null2String(RecordSet.getString("starttime"))) ;
enddates.add(Util.null2String(RecordSet.getString("enddate"))) ;
endtimes.add(Util.null2String(RecordSet.getString("endtime"))) ;
memos.add(Util.null2String(RecordSet.getString("memo"))) ;
subjects.add(sfl.getLeaveType(RecordSet.getString("leavetype"),RecordSet.getString("otherleavetype"))) ;

}  

if(RecordSet.getDBType().equals("oracle")){
	querystr = "select id,holidaydate,holidayname,changetype from HrmPubHoliday where substr(holidaydate,1,4)="+datenow.substring(0,4)+" and countryid="+user.getCountryid()+" order by holidaydate ";
}else{
	querystr = "select id,holidaydate,holidayname,changetype from HrmPubHoliday where substring(holidaydate,1,4)="+datenow.substring(0,4)+" and countryid="+user.getCountryid()+" order by holidaydate ";
}
RecordSet.executeSql(querystr);
while(RecordSet.next()) {
ids.add(Util.null2String(RecordSet.getString("id")));
resourceids.add(Util.null2String(resourceid));
int tempchangetype = Util.getIntValue(RecordSet.getString("changetype"),1);
if(tempchangetype==1) diffids.add(Util.null2String("FF0000"));
if(tempchangetype==2) diffids.add(Util.null2String("008000"));
if(tempchangetype==3) diffids.add(Util.null2String("0000CD"));
Map onDutyAndOffDutyTimeMap = HrmScheduleDiffUtil.getOnDutyAndOffDutyTimeMap(RecordSet.getString("holidaydate"),1);
startdates.add(Util.null2String(RecordSet.getString("holidaydate")));
starttimes.add(Util.null2String((String)onDutyAndOffDutyTimeMap.get("onDutyTimeAM")));
enddates.add(Util.null2String(RecordSet.getString("holidaydate")));
endtimes.add(Util.null2String((String)onDutyAndOffDutyTimeMap.get("offDutyTimePM")));
memos.add(Util.null2String(RecordSet.getString("memo")));
subjects.add(RecordSet.getString("holidayname")) ;
}
%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=GBK">
</head>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/workflow/request/RequestType.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{-}" ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(445,user.getLanguage())+",javascript:ShowYear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+",javascript:ShowMONTH(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1926,user.getLanguage())+",javascript:ShowWeek(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(390,user.getLanguage())+",javascript:ShowDay(),_self} " ;
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
<%if(!isfromtab){ %>
<TABLE class=Shadow>
<%}else{ %>
<TABLE width='100%'>
<%} %>
<tr>
<td valign="top">
<FORM id=frmmain name=frmmain method=post action="HrmResourceAbsense.jsp">
<input  class=inputstyle type=hidden name=currentdate id=currentdate value="<%=currentdate%>">
<input class=inputstyle type=hidden name=bywhat id=bywhat value="<%=bywhat%>">
<input class=inputstyle type=hidden name=movedate id=movedate value="">
<input class=inputstyle type=hidden name=relatewfid id=relatewfid value="<%=relatewfid%>">
  
  <TABLE class=ViewForm>
    <col width=10%> <col width=40%>  <col width=10%> <col width=40%>
    <TR class=Title> 
      <TH colspan=4><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD CLASS=Sep1 colspan=4></TD>
    </TR>   
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class="field">
        <BUTTON class=Browser type="button" id=SelecResourceid onClick="onShowResourceID()"></BUTTON> 
        <span id=resourceidspan> <A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></span> 
        <INPUT class=inputstyle id=resourceid type=hidden name=resourceid value="<%=resourceid%>">
      </td>
      <td><%=SystemEnv.getHtmlLabelName(16070,user.getLanguage())%></td>
      <td class="field">
          <BUTTON class=Browser type="button" onclick="onShowScheduleDiff('attendancetypespan','attendancetypename','attendancetype')"></BUTTON> 
          <SPAN id=attendancetypespan><%=attendancetypename%></SPAN> 
          <INPUT class=inputstyle type=hidden name=attendancetype value="<%=attendancetype%>">
          <INPUT class=inputstyle type=hidden name=attendancetypename value="<%=attendancetypename%>">	  
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  </table>
  <br>
<div> 
<button title=<%=datefrom%> onclick="getSubdate();" name=But1>&lt;</button>
<BUTTON type="button" class=Calendar id=selectbirthday onclick="getSubTheDate()"></BUTTON><span id="hiddenSpan" style="display:none"></span> 
<%=datenow%><button title=<%=dateto%> onclick="getSupdate();" name=But2>&gt;
</button>
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

td{
	border-color: #ECE9D8;
}
</style>
  </div>
  <br>
 <% if(bywhat==1) {%> 
  <table class=MI id=AbsenceCard style="border-color: #ECE9D8;BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: pointer; BORDER-BOTTOM: 1px solid" cellSpacing=0 cellPadding=0>
     <TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
    <TD CLASS=Sep1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="border-color: #ECE9D8;width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  int i=0;
	  int j=0;
	  for(i=0;i<32;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%if(i>0){%><%=i%><%} else {%>&nbsp<%}%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%

	String bgcolor="white";
        //String bgcolor = ScheduleDiffComInfo.getColor(diffid);
	Calendar tempday = Calendar.getInstance();
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;
	ArrayList tempids = new ArrayList() ;
	ArrayList tempdiffids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	
	
	int canlink = 0 ;
	for(j=1;j<13;j++){
	  for(i=0;i<32;i++){
	    canlink=0 ;
	    bgcolor="white";
	    tempids.clear() ;
	    tempdiffids.clear() ;
     	    
 	    tempstartdates.clear() ;
	    tempenddates.clear() ;
	    tempstarttimes.clear() ;
	    tempendtimes.clear() ;
	    tempsubjects.clear() ;
	    
		
	    if(i==0){
		bgcolor="white";
		canlink=0;
		if(j==1) innertext=SystemEnv.getHtmlLabelName(1492,user.getLanguage());
		if(j==2) innertext=SystemEnv.getHtmlLabelName(1493,user.getLanguage());
		if(j==3) innertext=SystemEnv.getHtmlLabelName(1494,user.getLanguage());
		if(j==4) innertext=SystemEnv.getHtmlLabelName(1495,user.getLanguage());
		if(j==5) innertext=SystemEnv.getHtmlLabelName(1496,user.getLanguage());
		if(j==6) innertext=SystemEnv.getHtmlLabelName(1497,user.getLanguage());
		if(j==7) innertext=SystemEnv.getHtmlLabelName(1498,user.getLanguage());
		if(j==8) innertext=SystemEnv.getHtmlLabelName(1499,user.getLanguage());
		if(j==9) innertext=SystemEnv.getHtmlLabelName(1800,user.getLanguage());
		if(j==10) innertext=SystemEnv.getHtmlLabelName(1801,user.getLanguage());
		if(j==11) innertext=SystemEnv.getHtmlLabelName(1802,user.getLanguage());
		if(j==12) innertext=SystemEnv.getHtmlLabelName(1803,user.getLanguage());
	     }else  {
		innertext="&nbsp;";
		tempday.clear();
		tempday.set(Util.getIntValue(currentdate.substring(0,4)),j-1,i);
		if((tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)&&i>0) {bgcolor="lightblue";}
		if((tempday.getTime().getMonth()!=(j-1))&&i>0) { bgcolor="darkblue";canlink=1;}
		if(!bgcolor.equals("darkblue")){
		  thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		  for(int k=0 ; k<ids.size() ; k++) {
		    String tempdatefrom = (String)startdates.get(k) ;
		    String tempdateto = (String)enddates.get(k) ;
		    if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
		        tempids.add((String)ids.get(k)) ;
		        tempdiffids.add((String)diffids.get(k)) ;
			
			tempstartdates.add((String)startdates.get(k)) ;
			tempenddates.add((String)enddates.get(k)) ;
			tempstarttimes.add((String)starttimes.get(k)) ;
			tempendtimes.add((String)endtimes.get(k)) ;
			tempsubjects.add((String)subjects.get(k)) ;
			
		     }
		}
	    }
	    if(tempids.size() > 0){%>
		<TD>
      		<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        	  <TBODY>
		  <%
		    for(int t=0 ; t< tempids.size() ; t++) {		      
		  %>
		  <TR>
          	     <TD title="<%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%>: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>: <%=tempsubjects.get(t)%>&#13;" bgColor=#<%=(String)tempdiffids.get(t)%> height=12>          	     
          	      </TD>
          	  </TR>
          	  <tr>
          	      <td bgColor=<%=bgcolor%> height=2>
          	      </td>
          	  </tr><%}%>
          	  </TBODY>
                </TABLE>
                </TD>
	      <%} else {%>
		<TD bgColor=<%=bgcolor%> 
		       <% 
		       if(canlink==0) { 
		         if(i!=0) {
		       %> 
		       title=<%=thenowday%> 
		       <%
		         }
		       } else {
		       %>
		       title="<%=SystemEnv.getHtmlLabelName(1928,user.getLanguage())%>" 
		       <%}%>>
		       <%=innertext%>
		</TD>
		       <%}%>	
		  <%if(i==31){%> 
             </tr>
	     <tr>
		  <%}
		}
	     }
	     %>
	</table>
	</td>
	</tr>
</table>
<%}%>


<% if(bywhat==2) {%> 
  <table class=MI id=AbsenceCard style=" border-color: #ECE9D8; BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: pointer; BORDER-BOTTOM: 1px solid" cellSpacing=0 cellPadding=0>
     <TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD CLASS=Sep1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="border-color: #ECE9D8;width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  	<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></td>
		<td height=20px ALIGN=CENTER><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></td>

	</tr>
	<tr>
	<%
	int i=0;
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	tempday.set(Util.getIntValue(currentdate.substring(0,4)),Util.getIntValue(currentdate.substring(5,7))-1,Util.getIntValue(currentdate.substring(8,10))) ;
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;
	
	Date thedate = tempday.getTime() ;
	int diffdate = thedate.getDay() ;
	for(i=0 ; i<diffdate;i++) {%>
	<TD bgColor=<%=bgcolor%>>&nbsp;</TD>
	<%}

	ArrayList tempids = new ArrayList() ;
	ArrayList tempdiffids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;	

	for(i=0;i<31;i++){
		bgcolor="white";
		tempids.clear() ;
		tempdiffids.clear() ;		
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		
		innertext = ""+tempday.get(Calendar.DAY_OF_MONTH) ;
				
		for(int k=0 ; k<ids.size() ; k++) {
			String tempdatefrom = (String)startdates.get(k) ;
			String tempdateto = (String)enddates.get(k) ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
			tempids.add((String)ids.get(k)) ;
			tempdiffids.add((String)diffids.get(k)) ;
			tempstartdates.add((String)startdates.get(k)) ;
			tempenddates.add((String)enddates.get(k)) ;
			tempstarttimes.add((String)starttimes.get(k)) ;
			tempendtimes.add((String)endtimes.get(k)) ;
			tempsubjects.add((String)subjects.get(k)) ;
			
		}
			
			if(tempids.size() > 0){%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempids.size() ; t++) { %>
			<TR>
          	         <TD title="<%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%>: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>: <%=tempsubjects.get(t)%>&#13;" bgColor=#<%=(String)tempdiffids.get(t)%>>           	         
          	         &nbsp
          	         </TD>
          	         </TR>
          	         <%}%>
          	         </TBODY>
          	         </TABLE>
          	         </TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=thenowday%> align=center valign=middle><%=innertext%></TD><%}%>	
			<%
			thedate = tempday.getTime() ;
			diffdate = thedate.getDay() ;
			int tempmonth = tempday.getTime().getMonth() ;
			tempday.add(Calendar.DATE,1) ;
			if(tempmonth != tempday.getTime().getMonth()) {bgcolor="white"; break ;}
			if(diffdate==6){%> 
			</tr><tr>
			<%}
		}
		for(i=diffdate;i<6;i++) {%>
		<TD bgColor=<%=bgcolor%>>&nbsp;</TD>
		<%} %>
		</tr>
	</table>
	</td></tr>
</table>
<%}%>


<% if(bywhat==3) {%> 
  <table class=MI id=AbsenceCard style="border-color: #ECE9D8;BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: pointer; BORDER-BOTTOM: 1px solid" cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD CLASS=Sep1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="border-color: #ECE9D8;width:100%; font-size:8pt;table-layout:fixed">
	
	
	<%
	int i=0;
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	tempday.set(Util.getIntValue(currentdate.substring(0,4)),Util.getIntValue(currentdate.substring(5,7))-1,Util.getIntValue(currentdate.substring(8,10))) ;

	String thenowday="";
	String innertext = "" ;

	ArrayList tempids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	ArrayList tempdiffids = new ArrayList() ;
	

	for(i=0;i<7;i++){

		bgcolor="white";
		tempids.clear() ;
		tempdiffids.clear() ;
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
		
		
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";
		
		Date thedate = tempday.getTime() ;
		int diffdate = thedate.getDay() ;

		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		
		innertext = thenowday ;
				
		for(int k=0 ; k<ids.size() ; k++) {
			String tempdatefrom = (String)startdates.get(k) ;
			String tempdateto = (String)enddates.get(k) ;
			if(thenowday.compareToIgnoreCase(tempdatefrom) < 0 || thenowday.compareToIgnoreCase(tempdateto)>0 ) continue ;
			tempids.add((String)ids.get(k)) ;
			tempdiffids.add((String)diffids.get(k)) ;
			tempstartdates.add((String)startdates.get(k)) ;
			tempenddates.add((String)enddates.get(k)) ;
			tempstarttimes.add((String)starttimes.get(k)) ;
			tempendtimes.add((String)endtimes.get(k)) ;
			tempsubjects.add((String)subjects.get(k)) ;
			
		}
		%>	
		<tr>
		<td width=15% align=center valign=middle >
		<% if(diffdate == 0) {%><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%>
		<%} else if(diffdate == 1) {%><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%>
		<%} else if(diffdate == 2) {%><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%>
		<%} else if(diffdate == 3) {%><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%>
		<%} else if(diffdate == 4) {%><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%>
		<%} else if(diffdate == 5) {%><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%>
		<%} else if(diffdate == 6) {%><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%><%}%></td>
		
		<%	if(tempids.size() > 0){%>
			<TD width=85%>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% for(int t=0 ; t< tempids.size() ; t++) {%>
			<TR>
            <TD 
          title="<%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%>: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>: <%=tempsubjects.get(t)%>&#13;" 
          bgColor=#<%=(String)tempdiffids.get(t)%>  rowspan="2">&nbsp;</TD>
		  <td><%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%>: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%></td>
		  <td><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%></td>
		  </tr>
		  <tr>
		  <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>: <%=tempsubjects.get(t)%></td>
		  <td></td>
		  </TR><%}%></TBODY></TABLE></TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=thenowday%> width=85% height=20><%=innertext%></TD><%}%>
			</tr>	
			<%
			tempday.add(Calendar.DATE,1) ;
		}
		%>
		
	</table>
	</td></tr>
</table>
<%}%>


<% if(bywhat==4) {%> 
  <table class=MI id=AbsenceCard style="border-color: #ECE9D8;BORDER-RIGHT: 1px solid; TABLE-LAYOUT: fixed; FONT-SIZE: 8pt; WIDTH: 100%; CURSOR: pointer; BORDER-BOTTOM: 1px solid" cellSpacing=0 cellPadding=0>
	<TR class=Title>
      <TH align="left"><%=SystemEnv.getHtmlLabelName(1927,user.getLanguage())%></TH>
	</TR>	
	<TR class=Spacing>
		<TD CLASS=Sep1></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="border-color: #ECE9D8;width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  int i=0;
	  for(i=0;i<24;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%=i%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	tempday.set(Util.getIntValue(currentdate.substring(0,4)),Util.getIntValue(currentdate.substring(5,7))-1,Util.getIntValue(currentdate.substring(8,10))) ;
	String tempcreatedate="";
	String thenowday="";
	String innertext = "" ;


	ArrayList tempids = new ArrayList() ;
	ArrayList tempdiffids = new ArrayList() ;
	ArrayList tempstartdates = new ArrayList() ;
	ArrayList tempenddates = new ArrayList() ;
	ArrayList tempstarttimes = new ArrayList() ;
	ArrayList tempendtimes = new ArrayList() ;
	ArrayList tempsubjects = new ArrayList() ;
	
	

	for(i=0;i<24;i++){
		bgcolor="white";
		tempids.clear() ;
		tempdiffids.clear() ;
		tempstartdates.clear() ;
		tempenddates.clear() ;
		tempstarttimes.clear() ;
		tempendtimes.clear() ;
		tempsubjects.clear() ;
				
		if(tempday.getTime().getDay()==0||tempday.getTime().getDay()==6)  bgcolor="lightblue";
		thenowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
						Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
						Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;
		String thenowtimefrom = thenowday+" "+Util.add0(i,2)+":00" ;
		String thenowtimeto = thenowday+" "+Util.add0(i+1,2)+":00" ;
		
		innertext = thenowday+ " "+Util.add0(i,2)+":00 - "+Util.add0(i+1,2)+":00" ;
				
		for(int k=0 ; k<ids.size() ; k++) {		
			String tempdatefrom = (String)startdates.get(k) ;
			String tempdateto = (String)enddates.get(k) ;
			String temptimefrom = (String)starttimes.get(k) ;
			String temptimeto = (String)endtimes.get(k) ;
			if(temptimefrom.length() <5 || temptimeto.length() <5) continue ;
			String tempallfrom = tempdatefrom + " " + temptimefrom.substring(0,5) ;
			String tempallto = tempdateto + " " +temptimeto.substring(0,5) ;
						
			if((tempallfrom.compareToIgnoreCase(thenowtimefrom) < 0 && tempallto.compareToIgnoreCase(thenowtimeto)>0) ||
			 (thenowtimefrom.compareToIgnoreCase(tempallfrom) <= 0 && thenowtimeto.compareToIgnoreCase(tempallfrom)>0) ||
			 (thenowtimefrom.compareToIgnoreCase(tempallto) < 0 && thenowtimeto.compareToIgnoreCase(tempallto)>=0)) {			 
				tempids.add((String)ids.get(k)) ;
				tempdiffids.add((String)diffids.get(k)) ;
				tempstartdates.add((String)startdates.get(k)) ;
				tempenddates.add((String)enddates.get(k)) ;
				tempstarttimes.add((String)starttimes.get(k)) ;
				tempendtimes.add((String)endtimes.get(k)) ;
				tempsubjects.add((String)subjects.get(k)) ;
				
			}		
			
		}
			
			if(tempids.size() > 0){
			
			%>
			<TD>
      			<TABLE class=we style="TABLE-LAYOUT: fixed; WIDTH: 100%" cellSpacing=0   cellPadding=0>
        		<TBODY>
			<% 
			for(int t=0 ; t< tempids.size() ; t++) {%>
			<TR>
	          	<TD title="<%=SystemEnv.getHtmlLabelName(404,user.getLanguage())%>: <%=tempstartdates.get(t)%> <%=tempstarttimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%>: <%=tempenddates.get(t)%> <%=tempendtimes.get(t)%>&#13;<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>: <%=tempsubjects.get(t)%>&#13;"  bgColor=#<%=(String)tempdiffids.get(t)%>>
	          	&nbsp
	          	</TD>
	          	</TR>
	          	<%}%>
	          	</TBODY>
	          	</TABLE>
	          	</TD>
			<%} else {%>
			<TD bgColor=<%=bgcolor%> title=<%=innertext%> align=center valign=middle>&nbsp;</TD><%} }%>	
		</tr>
	</table>
	</td></tr>
</table>
  <%}%>

  <br>
  <br>
<%
Calendar annualtoday = Calendar.getInstance(); 
String nowdate = Util.add0(annualtoday.get(Calendar.YEAR),4) + "-" + Util.add0(annualtoday.get(Calendar.MONTH)+1,2) + "-" + Util.add0(annualtoday.get(Calendar.DAY_OF_MONTH),2);
String annualinfo = HrmAnnualManagement.getUserAannualInfo(resourceid,nowdate);
String thisyearannual = Util.TokenizerString2(annualinfo,"#")[0];
String lastyearannual = Util.TokenizerString2(annualinfo,"#")[1];
String allyearannual = Util.TokenizerString2(annualinfo,"#")[2];

%>
  <TABLE class=ViewForm>
    <col width=15%> <col width=85%>
    <TR class=Title> 
      <TH colspan=2><%=SystemEnv.getHtmlLabelName(21602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD CLASS=Sep1 colspan=2></TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21614,user.getLanguage())%></td>
      <td class="field"><%=lastyearannual%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21615,user.getLanguage())%></td>
      <td class="field"><%=thisyearannual%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(21616,user.getLanguage())%></td>
      <td class="field"><%=allyearannual%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>         
  </table>
  <br>
  <%
String pslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceid,nowdate);
String thisyearpsl = Util.TokenizerString2(pslinfo,"#")[0];
String lastyearpsl = Util.TokenizerString2(pslinfo,"#")[1];
String allyearpsl = Util.TokenizerString2(pslinfo,"#")[2];

%>
    <TABLE class=ViewForm>
    <col width=15%> <col width=85%>
    <TR class=Title> 
      <TH colspan=2><%=SystemEnv.getHtmlLabelName(24032,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD CLASS=Sep1 colspan=2></TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(24039,user.getLanguage())%></td>
      <td class="field"><%=lastyearpsl%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(24040,user.getLanguage())%></td>
      <td class="field"><%=thisyearpsl%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(24041,user.getLanguage())%></td>
      <td class="field"><%=allyearpsl%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>         
  </table>
  <br>

  <TABLE class=ViewForm>
    <col width=15%> <col width=85%>
    <TR class=Title> 
      <TH colspan=2><%=SystemEnv.getHtmlLabelName(20092,user.getLanguage())%></TH>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>        
	<TR>
		<TD valign="top" colSpan=2>					
			<%  
			    String sqlFrom = " HrmAnnualLeaveInfo ";
			    String sqlWhere = " resourceid = " + resourceid + leavesqlwhere;			    
				String tableString=""+
				"<table pagesize=\"10\" tabletype=\"none\">"+
				"<sql backfields=\"id,requestid,resourceid,startdate,starttime,enddate,endtime,leavetime,otherleavetype,leavetype\" sqlisdistinct=\"true\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"id\" sqlorderby=\"startdate,starttime\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
				"<head>"+
				"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(16070,user.getLanguage())+"\" column=\"leavetype\" orderkey=\"leavetype\" transmethod=\"weaver.hrm.resource.SptmForLeave.getLeaveType\" otherpara=\"column:otherleavetype\" />"+
				"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(16071,user.getLanguage())+"\" column=\"leavetype\" orderkey=\"leavetype\" transmethod=\"weaver.hrm.resource.SptmForLeave.getLeaveTypeColor\" otherpara=\"column:otherleavetype+"+subcompanyid+"\"/>"+
			    "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"startdate\" orderkey=\"startdate,starttime\" transmethod=\"weaver.hrm.resource.SptmForLeave.getDateTime\" otherpara=\"column:starttime\" />"+			    
				"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate,endtime\" transmethod=\"weaver.hrm.resource.SptmForLeave.getDateTime\" otherpara=\"column:endtime\" />"+						    
				"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(828,user.getLanguage())+"\" column=\"leavetime\" orderkey=\"leavetime\" />"+			    
				"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(1044,user.getLanguage())+"\" column=\"requestid\" orderkey=\"requestid\" transmethod=\"weaver.hrm.resource.SptmForLeave.getRequestName\" />"+
				"</head>"+
				"</table>";
		    %>					
			    <wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" isShowTopInfo="true"/>						
	   </TD>
	</TR>
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

<script language=vbs>



</script>

<script language=javascript>
function onShowScheduleDiff(tdname, spanname, inputename) {
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/AnnualTypeBrowser.jsp");
	if (data) {
		if (data.id != "" && data.id != "0") {
			document.all(tdname).innerHTML = data.name;
			document.all(spanname).value = data.name;
			document.all(inputename).value = data.id;
		} else {
			document.all(tdname).innerHTML = "";
			document.all(spanname).value = "";
			document.all(inputename).value = "";
		}
	}
}
function onShowResourceID() {
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (data) {
		if (data.id!= "") {
			frmmain.resourceid.value = data.id
			document.frmmain.submit();
		}
	}
}
function submitData() {
	document.frmmain.submit();
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
</script>

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

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>
