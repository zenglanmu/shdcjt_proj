<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML>
<HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
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
<script language=javascript>
function doSave(){
	document.frmmain.operation.value="save";
	if(check_form(document.frmmain,'countryid,holidaydate,holidayname'))
	document.frmmain.submit();	
}
function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmmain.operation.value="delete";
		document.frmmain.submit();
	}
}
function showType(){
    changetypelist = window.document.frmmain.changetype;
    if(changetypelist.value==2){
        relateweekdaytr.style.display='';
        relateweekdayspan.style.display ='';
    }
    else {
        relateweekdayspan.style.display ='none';
        relateweekdaytr.style.display='none';
    }
}
</script> 
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(16750,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user);
boolean CanEdit = HrmUserVarify.checkUserRight("HrmPubHolidayEdit:Edit", user);
boolean CanDelete = HrmUserVarify.checkUserRight("HrmPubHolidayEdit:Delete", user);
String id=Util.null2String(request.getParameter("id"));
RecordSet.executeProc("HrmPubHoliday_SelectByID",id);
RecordSet.next();
String countryid=RecordSet.getString("countryid");
String holidaydate=Util.toScreen(RecordSet.getString("holidaydate"),user.getLanguage());
String holidayname=Util.toScreenToEdit(RecordSet.getString("holidayname"),user.getLanguage());
int changetype=Util.getIntValue(RecordSet.getString("changetype"),-1);
int relateweekday=Util.getIntValue(RecordSet.getString("relateweekday"),-1);


RecordSet.executeSql("select id from HrmPubHoliday where countryid =" + countryid + " and holidaydate = '"+ holidaydate +"' " );


// 判断选择的日期原来是工作日还是休息日 

String selectdatetype="";  // 选择的日期原来类型 : 1 工作日, 2: 休息日

// 获得一般工作时间,判断选择的日期是否为休息日
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

RecordSet.executeProc("HrmSchedule_Select_Current" , holidaydate) ; 
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

Calendar tempday = Calendar.getInstance();
tempday.set(Util.getIntValue(holidaydate.substring(0,4)), Util.getIntValue(holidaydate.substring(5,7))-1,Util.getIntValue(holidaydate.substring(8,10)));

if(weekrestdays.indexOf(""+tempday.getTime().getDay()) != -1 ) selectdatetype="2" ;
else selectdatetype="1" ;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",/hrm/schedule/HrmPubHolidayAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(CanDelete){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmPubHoliday.jsp?year="+request.getParameter("year")+"&showtype="+request.getParameter("showtype")+"&countryid="+request.getParameter("countryid")+",_self} " ;//返回
RCMenuHeight += RCMenuHeightStep ;
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
<FORM id=weaver name=frmmain method=post action="HrmPubHolidayOperation.jsp">
<input class=inputstyle type="hidden" name="operation">
<input type="hidden" name="countryid" value="<%=countryid%>">
<input class=inputstyle type="hidden" name="id" value="<%=id%>">
<table class=Viewform>
  <colgroup>
    <col width="20%">
    <col width="80%">
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></td>
      <td class=field><%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=field><%=Util.toScreen(holidaydate,user.getLanguage())%></td>
    </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=field><input class=inputstyle maxLength=30 onchange="checkinput('holidayname','InvalidFlag_Description')" size=30 
      name="holidayname" value="<%=holidayname%>"><SPAN id=InvalidFlag_Description><%if(holidayname.equals("")){%><IMG src="../../images/BacoError.gif" align=absMiddle ><% }%></SPAN></td>
    </tr>	
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
      <td class=field>
      <select class=inputstyle name="changetype" <% if( selectdatetype.equals("2") ) {%> onChange="showType()"<%}%>>
		  <option value="1" <%if(changetype==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16478,user.getLanguage())%></option>
          <% if( selectdatetype.equals("2") ) { // 原来为假日，可以调整为工作日%>
		  <option value="2" <%if(changetype==2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16751,user.getLanguage())%></option>
          <% } else { // 原来为工作日，可以调整为假日%>
          <option value="3" <%if(changetype==3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(16752,user.getLanguage())%></option>
          <% } %>
		</select>
      </td>
    </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
   <% if( selectdatetype.equals("2") ) { %>
   <tr id = relateweekdaytr <%if(changetype!=2) {%> style="display:none"<%}%>>
      <td><%=SystemEnv.getHtmlLabelName(16754,user.getLanguage())%></td>
      <td class=field>
      <span id="relateweekdayspan" <%if(changetype!=2) {%> style="display:none"<%}%>>
      <select class=inputstyle name="relateweekday">
		  <option value="2" <%if(relateweekday==2) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></option>
          <option value="3" <%if(relateweekday==3) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></option>
          <option value="4" <%if(relateweekday==4) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></option>
		  <option value="5" <%if(relateweekday==5) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></option>
          <option value="6" <%if(relateweekday==6) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></option>
          <option value="7" <%if(relateweekday==7) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></option>
          <option value="1" <%if(relateweekday==1) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></option>
		</select>
       </span>
      </td>
    </tr>
    <%}%>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
</table>
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>