<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT LANGUAGE=VBS>
	Sub PublicHolidays_OnMouseOver1()
		set el = window.event.srcElement 
		If el.tagName = "TD" Then
			Info.innerHTML = el.ID
		End If
	End Sub
</SCRIPT>
<script language=javascript>

// 获取event
function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function PublicHolidays_OnMouseOver(){
	var event = getEvent();
	var el = event.srcElement || event.target;
	if (el.tagName == "TD"){
		jQuery("#Info").html();
		http://localhost:8090/hrm/schedule/HrmPubHolidayAdd.jsp?selectdate=1&countryid=&holidaydate=2012-10-07&selectdatetype=1&showtype=0&year=2012
		window.parent.location.href="/hrm/schedule/HrmPubHolidayAdd.jsp";
	}
}

jQuery(document).ready(function(){
2012-1-4
});

function doCopy(){
	if(check_form(document.frmmain,'countryid')){
	document.frmmain.action="HrmPubHolidayCopy.jsp";
	document.frmmain.submit();	
	}
}
function submitData() {
    if(check_form(document.frmmain,'countryid')){
		document.frmmain.action="HrmPubHoliday.jsp?countryid="+document.frmmain.countryid.value;
        document.frmmain.submit();
    }
}
</script> 	
<script language=vbs>
sub onShowCountry(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
		document.all(tdname).innerHtml = id(1)
		document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
		document.all(inputename).value=""
		end if
	end if
end sub
</script>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(16750,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user);
boolean CanEdit = HrmUserVarify.checkUserRight("HrmPubHolidayEdit:Edit", user);
int showtype=Util.getIntValue(request.getParameter("showtype"),0);
String countryid=Util.null2String(request.getParameter("countryid"));
int year=Util.getIntValue(request.getParameter("year"),0);
String dept_id=Util.null2String(request.getParameter("dept_id"));

if(countryid.equals("")){
	if(dept_id.equals("")){
        String locationid = user.getLocationid();
        countryid = LocationComInfo.getLocationcountry(locationid);
	}
	else{
	    countryid = "1";
	}
}
Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR); 
int fromyear=currentyear-5;
int toyear=currentyear+5;
if(year==0) year=currentyear;

String currentday = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                    Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                    Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;



// 获得一般工作时间,判断休息日
String monstarttime1 = "" ; 
String monendtime1 = "" ; 
String monstarttime2 = "" ; 
String monendtime2 = "" ;  

String tuestarttime1 = "" ; 
String tueendtime1 = "" ; 
String tuestarttime2 = "" ;  
String tueendtime2 = "" ; 

String wedstarttime1 = "" ;  
String wedendtime1 = "" ; 
String wedstarttime2 = "" ; 
String wedendtime2 = "" ; 

String thustarttime1 = "" ; 
String thuendtime1 = "" ; 
String thustarttime2 = "" ; 
String thuendtime2 = "" ;  

String fristarttime1 = "" ; 
String friendtime1 = "" ; 
String fristarttime2 = "" ; 
String friendtime2 = "" ; 

String satstarttime1 = "" ; 
String satendtime1 = "" ; 
String satstarttime2 = "" ; 
String satendtime2 = "" ; 

String sunstarttime1 = "" ; 
String sunendtime1 = "" ; 
String sunstarttime2 = "" ; 
String sunendtime2 = "" ; 

ArrayList weekrestdays = new ArrayList() ;

RecordSet.executeProc("HrmSchedule_Select_Current" , currentday) ; 
if( RecordSet.next() ) {
    
    monstarttime1 = Util.null2String(RecordSet.getString("monstarttime1")) ;
    monendtime1 = Util.null2String(RecordSet.getString("monendtime1")) ;
    monstarttime2 = Util.null2String(RecordSet.getString("monstarttime2")) ;
    monendtime2 = Util.null2String(RecordSet.getString("monendtime2")) ;

    tuestarttime1 = Util.null2String(RecordSet.getString("tuestarttime1")) ;
    tueendtime1 = Util.null2String(RecordSet.getString("tueendtime1")) ;
    tuestarttime2 = Util.null2String(RecordSet.getString("tuestarttime2")) ;
    tueendtime2 = Util.null2String(RecordSet.getString("tueendtime2")) ;

    wedstarttime1 = Util.null2String(RecordSet.getString("wedstarttime1")) ;
    wedendtime1 = Util.null2String(RecordSet.getString("wedendtime1")) ;
    wedstarttime2 = Util.null2String(RecordSet.getString("wedstarttime2")) ;
    wedendtime2 = Util.null2String(RecordSet.getString("wedendtime2")) ;

    thustarttime1 = Util.null2String(RecordSet.getString("thustarttime1")) ;
    thuendtime1 = Util.null2String(RecordSet.getString("thuendtime1")) ;
    thustarttime2 = Util.null2String(RecordSet.getString("thustarttime2")) ;
    thuendtime2 = Util.null2String(RecordSet.getString("thuendtime2")) ;

    fristarttime1 = Util.null2String(RecordSet.getString("fristarttime1")) ;
    friendtime1 = Util.null2String(RecordSet.getString("friendtime1")) ;
    fristarttime2 = Util.null2String(RecordSet.getString("fristarttime2")) ;
    friendtime2 = Util.null2String(RecordSet.getString("friendtime2")) ;

    satstarttime1 = Util.null2String(RecordSet.getString("satstarttime1")) ;
    satendtime1 = Util.null2String(RecordSet.getString("satendtime1")) ;
    satstarttime2 = Util.null2String(RecordSet.getString("satstarttime2")) ;
    satendtime2 = Util.null2String(RecordSet.getString("satendtime2")) ; 

    sunstarttime1 = Util.null2String(RecordSet.getString("sunstarttime1")) ;
    sunendtime1 = Util.null2String(RecordSet.getString("sunendtime1")) ;
    sunstarttime2 = Util.null2String(RecordSet.getString("sunstarttime2")) ;
    sunendtime2 = Util.null2String(RecordSet.getString("sunendtime2")) ;
}

if( sunstarttime1.equals("") && sunendtime1.equals("") && sunstarttime2.equals("") && sunendtime2.equals("") )   weekrestdays.add("0") ;
if( monstarttime1.equals("") && monendtime1.equals("") && monstarttime2.equals("") && monendtime2.equals("") )   weekrestdays.add("1") ;
if( tuestarttime1.equals("") && tueendtime1.equals("") && tuestarttime2.equals("") && tueendtime2.equals("") )   weekrestdays.add("2") ;
if( wedstarttime1.equals("") && wedendtime1.equals("") && wedstarttime2.equals("") && wedendtime2.equals("") )   weekrestdays.add("3") ;
if( thustarttime1.equals("") && thuendtime1.equals("") && thustarttime2.equals("") && thuendtime2.equals("") )   weekrestdays.add("4") ;
if( fristarttime1.equals("") && friendtime1.equals("") && fristarttime2.equals("") && friendtime2.equals("") )   weekrestdays.add("5") ;
if( satstarttime1.equals("") && satendtime1.equals("") && satstarttime2.equals("") && satendtime2.equals("") )   weekrestdays.add("6") ;

char separator = Util.getSeparator();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/schedule/HrmPubHolidayAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:doCopy(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmPubHoliday:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+21+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=weaver name=frmmain method=post onSubmit="return check_form(this,'countryid')">
<TABLE CLASS=VIEWFORM>
	<col width=15%>
	<col width=33%>
	<col width=24px>
	<col width=15%>
	<col width=33%>
	
	<TR CLASS=SECTION>
		<TH colspan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
	</TR>	
	<TR Class=Spacing style="height:1px">
		<TD CLASS=Line1 colspan=5></TD>
	</TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></td>
		<td>

		<input class="wuiBrowser" type="hidden" name="countryid" value="<%=countryid%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
		_displayText="<%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%>" _required="yes">
		</td>
		<td></td>
		<td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
		<td><select class=inputstyle name="year" size="1">
		<%
		int i=0;
		int j=0;
		for(i=fromyear;i<=toyear;i++){
		%>
		<option value="<%=i%>" <%if(i==year) {%> selected <%}%>><%=Util.add0(i, 4)%></option>
		<%
		}
		%>
		</select></td>
	</tr>
    <TR style="height:1px"><TD class=Line colSpan=7></TD></TR>
	<tr>
		<td><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></td>
		<td><select class=inputstyle name="showtype" size="1">
		  <option value="0" <%if(showtype==0) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(490,user.getLanguage())%></option>
		  <option value="1" <%if(showtype==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(491,user.getLanguage())%></option>
		</select></td>
	</tr>
</table>

<%if(showtype==0){%>
<table class=Viewform>
	<TR CLASS=Title>
		<TH colspan=32><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
	</TR>	
	<TR Class=Spacing style="height:2px">
		<TD CLASS=Line1 colspan=32></TD>
	</TR>
	<tr><td>
	<table border=1 cellspacing=0 cellpadding=0 ID=PublicHolidays Style="width:100%; font-size:8pt;table-layout:fixed">
	<tr>
	  <%
	  for(i=0;i<32;i++){
	  	%>
	  	<td height=20px ALIGN=CENTER><%if(i>0){%><%=i%><%} else {%>&nbsp<%}%></td>
	  	<%
	  }
	  %>
	</tr>
	<tr>
	<%
	RecordSet.executeProc("HrmPubHoliday_SelectByYear",year+""+separator+countryid);
	boolean hasholiday = RecordSet.next();
	String innertext="";
    String innertitle=""; // 第一列显示月份
	String bgcolor="white";
	Calendar tempday = Calendar.getInstance();
	
    String tempholiday = "";
    int tempchangetype = 1;

	String nowday="";
	int canlink=1;
	int isholiday=0;
	int totalholiday=0;
    int totalchangeworkday=0;
    int totalchangerestday=0;
	String id="";
	String holidayname="";
	for(j=1;j<13;j++){
		for(i=0;i<32;i++){
		canlink=1;
		isholiday=0;
		bgcolor="white";   // 默认为工作日

        tempday.clear();
        tempday.set(year,j-1,i);

        nowday=Util.add0(tempday.get(Calendar.YEAR), 4) +"-"+
                Util.add0(tempday.get(Calendar.MONTH) + 1, 2) +"-"+
                Util.add0(tempday.get(Calendar.DAY_OF_MONTH), 2) ;

        if(i==0){
            bgcolor="white";
            canlink=0;
            if(j==1) innertitle= SystemEnv.getHtmlLabelName(1492,user.getLanguage());
            if(j==2) innertitle= SystemEnv.getHtmlLabelName(1493,user.getLanguage());
            if(j==3) innertitle= SystemEnv.getHtmlLabelName(1494,user.getLanguage());
            if(j==4) innertitle= SystemEnv.getHtmlLabelName(1495,user.getLanguage());
            if(j==5) innertitle= SystemEnv.getHtmlLabelName(1496,user.getLanguage());
            if(j==6) innertitle= SystemEnv.getHtmlLabelName(1497,user.getLanguage());
            if(j==7) innertitle= SystemEnv.getHtmlLabelName(1498,user.getLanguage());
            if(j==8) innertitle= SystemEnv.getHtmlLabelName(1499,user.getLanguage());
            if(j==9) innertitle= SystemEnv.getHtmlLabelName(1800,user.getLanguage());
            if(j==10) innertitle= SystemEnv.getHtmlLabelName(1801,user.getLanguage());
            if(j==11) innertitle= SystemEnv.getHtmlLabelName(1802,user.getLanguage());
            if(j==12) innertitle= SystemEnv.getHtmlLabelName(1803,user.getLanguage());
        }
        else {
            innertitle = "" ;

            if(tempday.getTime().getDay()==0) innertext=SystemEnv.getHtmlLabelName(398,user.getLanguage());
            if(tempday.getTime().getDay()==1) innertext=SystemEnv.getHtmlLabelName(392,user.getLanguage());
            if(tempday.getTime().getDay()==2) innertext=SystemEnv.getHtmlLabelName(393,user.getLanguage());
            if(tempday.getTime().getDay()==3) innertext=SystemEnv.getHtmlLabelName(394,user.getLanguage());
            if(tempday.getTime().getDay()==4) innertext=SystemEnv.getHtmlLabelName(395,user.getLanguage());
            if(tempday.getTime().getDay()==5) innertext=SystemEnv.getHtmlLabelName(396,user.getLanguage());
            if(tempday.getTime().getDay()==6) innertext=SystemEnv.getHtmlLabelName(397,user.getLanguage());
        }
        
        if(weekrestdays.indexOf(""+tempday.getTime().getDay()) != -1 && i>0) bgcolor="lightblue"; // 如果为休息日

        if((tempday.getTime().getMonth()!=(j-1))&&i>0) { bgcolor="darkblue"; canlink=0;}
        if(!bgcolor.equals("darkblue")&&i>0){
            if ( hasholiday ) {
                tempholiday = RecordSet.getString("holidaydate");
                tempchangetype = Util.getIntValue(RecordSet.getString("changetype"),1);
                holidayname=RecordSet.getString("holidayname");
                id=RecordSet.getString("id");
            }

            if(nowday.equals(tempholiday)){
                switch( tempchangetype ) {
                    case 1 :
                        bgcolor="RED";      // 法定假日
                        totalholiday+=1;
                        break ;
                    case 2 :
                        bgcolor="GREEN";      // 工作日
                        totalchangeworkday+=1;
                        break ;
                    case 3 :
                        bgcolor="MEDIUMBLUE";      // 休息日
                        totalchangerestday+=1;
                        break ;
                }

                hasholiday = RecordSet.next();
                isholiday=1;
            }
        }
		%>


	<td height=20px ALIGN=CENTER bgcolor="<%=bgcolor%>"
		<%if((i>0)&&!bgcolor.equals("darkblue")){%>
			style="CURSOR:HAND" 
		<%}
		if(isholiday == 1 ) {%> 
			ID="<%=holidayname%>:<%=nowday%>" 
		<%}%> 
			title="<%=innertext%>">



		<%if(canlink==1&&isholiday==0&&CanAdd&&i>0){%>
			<a style="TEXT-DECORATION: none;display:inline-block;height:100%;width:100%;" href="HrmPubHolidayOperation.jsp?holidaydate=<%=nowday%>&year=<%=year%>&showtype=<%=showtype%>&countryid=<%=countryid%>&operation=selectdate">
		<%}%>
		<%if(canlink==1&&isholiday==1&&CanEdit&&i>0){%>
			<a style="TEXT-DECORATION: none;display:inline-block;height:100%;width:100%;" href=HrmPubHolidayEdit.jsp?id=<%=id%>&year=<%=year%>&showtype=<%=showtype%>&countryid=<%=countryid%>>
		<%}%>

			<%=innertitle%>&nbsp;</a></td>
			<%
		if(i==31){%> 
			</tr>
		<%  }
		}
	}
	%>
	</table>
	</td></tr>
	<tr><td><TABLE border=1 cellspacing=0 style="width:100%; font-size:10pt;"> 
	  <COL WIDTH="50%"><COL WIDTH="50%"> 
	  <TR>
	    <TD VALIGN="TOP">
	      	<TABLE border=1 cellspacing=0 style="width:100%; font-size:10pt; table-layout:fixed">
	    	<COL WIDTH="15%" ALIGN="LEFT"><COL WIDTH="60%" ALIGN="LEFT"><COL WIDTH="25%" ALIGN="RIGHT">
	    	<TR><TH><%=SystemEnv.getHtmlLabelName(495,user.getLanguage())%></TH>
	    	<TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
	    	<TH><%=SystemEnv.getHtmlLabelName(496,user.getLanguage())%></TH>
	    	</TR>
	    	<TR><TD BGCOLOR=RED>&nbsp;</TD>
	    	<TD><%=SystemEnv.getHtmlLabelName(16478,user.getLanguage())%></TD>
	    	<TD><%=totalholiday%></TD>
	    	</TR>
            <TR><TD BGCOLOR=GREEN>&nbsp;</TD>
	    	<TD><%=SystemEnv.getHtmlLabelName(16751,user.getLanguage())%></TD>
	    	<TD><%=totalchangeworkday%></TD>
	    	</TR>
            <TR><TD BGCOLOR=MEDIUMBLUE>&nbsp;</TD>
	    	<TD><%=SystemEnv.getHtmlLabelName(16752,user.getLanguage())%></TD>
	    	<TD><%=totalchangerestday%></TD>
	    	</TR>
	    	</TABLE>
	    </TD>
	    <TD VALIGN="TOP">
	    	<TABLE border=0 cellspacing=0 style="width:100%; font-size:10pt; table-layout:fixed">
	    	<TR><TD>
	    	<SPAN ID="Info">&nbsp;</SPAN>
	    	</TD></TR>
	    	</TABLE>
	    </TD>
	  </tr>
	</table></tr></td>
</table>
<%}
if(showtype==1){
%>
<table class=ListStyle cellspacing=1 >
	<col width="30%"><col width="20%"><col width="20%"><col width="30%">
	<tr class=Header>
		<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
        <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
		<td><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
	<%
	int linecolor=0;
	RecordSet.executeProc("HrmPubHoliday_SelectByYear",year+""+separator+countryid);
	while(RecordSet.next()){
        String id = Util.null2String(RecordSet.getString("id")) ;
        String holidayname = Util.toScreen(RecordSet.getString("holidayname"),user.getLanguage()) ;
        String holidaydate = Util.null2String(RecordSet.getString("holidaydate")) ;
        int changetype = Util.getIntValue(RecordSet.getString("changetype"),1) ;
        int relateweekday = Util.getIntValue(RecordSet.getString("relateweekday"),1) ;
	%>
	    <tr <%if(linecolor==0){ %> class=datalight <%}else {%> class=datadark <%}%>>
		<td><a href="HrmPubHolidayEdit.jsp?id=<%=id%>&year=<%=year%>&showtype=<%=showtype%>&countryid=<%=countryid%>"><%=holidayname%></a></td>
		<td><%=holidaydate%></td>
        <td>
        <% if( changetype == 1) {%><%=SystemEnv.getHtmlLabelName(16478,user.getLanguage())%>
        <% } else if( changetype == 2) {%><%=SystemEnv.getHtmlLabelName(16751,user.getLanguage())%>
        <% } else if( changetype == 3) {%><%=SystemEnv.getHtmlLabelName(16752,user.getLanguage())%>
        <% } %>
        </td>
        <td>
        <% 
        String relateweekdaydesc = "" ;
        if( changetype == 2) {
           switch( relateweekday ) {
               case 1 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(398,user.getLanguage()) ;
                    break ;
               case 2 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(392,user.getLanguage()) ;
                    break ;
               case 3 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(393,user.getLanguage()) ;
                    break ;
               case 4 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(394,user.getLanguage()) ;
                    break ;
               case 5 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(395,user.getLanguage()) ;
                    break ;
               case 6 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(396,user.getLanguage()) ;
                    break ;
               case 7 :
                    relateweekdaydesc = SystemEnv.getHtmlLabelName(397,user.getLanguage()) ;
                    break ;
           }
           relateweekdaydesc = SystemEnv.getHtmlLabelName(16753,user.getLanguage()) + relateweekdaydesc ;
        }
        %>
        <%=relateweekdaydesc%>
        </td>
	    </tr>
	<%
		if(linecolor==0) linecolor=1;
		else linecolor=0;
	}%>
</table>
<%}%>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</body>
</html>