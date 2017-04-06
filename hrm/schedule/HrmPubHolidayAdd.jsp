<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmPubHolidayAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<script language=vbs>
sub onShowCountry(tdname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> 0 then
            document.all(tdname).innerHtml = id(1)
            document.all(inputename).value=id(0)
            if frmmain.holidaydate.value <> "" then
                frmmain.operation.value = "selectdate"
                frmmain.submit()
            end if
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
String countryid=Util.null2String(request.getParameter("countryid"));
String holidaydate=Util.null2String(request.getParameter("holidaydate"));
String selectdate=Util.null2String(request.getParameter("selectdate"));
String selectdatetype=Util.null2String(request.getParameter("selectdatetype"));  // 选择的日期原来类型 : 1 工作日, 2: 休息日
String showtype=Util.null2String(request.getParameter("showtype"));
String year=Util.null2String(request.getParameter("year"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmPubHoliday.jsp?year="+year+"&showtype="+showtype+"&countryid="+countryid+",_self} " ;//返回
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
<% if( selectdate.equals("2") ) { // 该天已经有调整记录，不能新建调整%>
<font color=red><%=SystemEnv.getHtmlLabelName(16755,user.getLanguage())%></font>
<% } %>

<FORM id=frmmain name=frmmain method=post action="HrmPubHolidayOperation.jsp" onSubmit="return check_form(this,'countryid,holidaydate,holidayname')">
<input class=inputstyle type="hidden" name="operation" value="insert">

<table class=Viewform>
  <colgroup>
    <col width="20%">
    <col width="80%">
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></td>
      <td class=field>
		<input class="wuiBrowser" type="hidden" name="countryid" value="<%=countryid%>"
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
	  _displayText="<%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%>" _required="yes"></td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=field><BUTTON class=Calendar type="button" id=SelectDate onclick=getholiday1Date()></BUTTON>
      <span id="holidaydatespan1" style="display:none;" ><IMG id=""  src='/images/BacoError.gif' align="absMiddle"></span>
	  <span id=holidaydatespan>   
       <%if(holidaydate.equals("")){%>
      <IMG src='/images/BacoError.gif' align=absMiddle>
      <%} else {%>
      <%=Util.toScreen(holidaydate,user.getLanguage())%><%}%>        
      </span>
      <input class=inputstyle type="hidden" name="holidaydate" value="<%=holidaydate%>">
      </td>
    </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <% if( selectdate.equals("1") ) { %>
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=field><input class=inputstyle maxLength=30 onchange="checkinput('holidayname','InvalidFlag_Description')" size=30 
      name="holidayname"><SPAN id=InvalidFlag_Description><IMG src="../../images/BacoError.gif" align=absMiddle></SPAN></td>
    </tr>	
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
      <td class=field>
      <select class=inputstyle name="changetype" <% if( selectdatetype.equals("2") ) {%> onChange="showType()"<%}%>>
		  <option value="1" ><%=SystemEnv.getHtmlLabelName(16478,user.getLanguage())%></option>
          <% if( selectdatetype.equals("2") ) { // 原来为假日，可以调整为工作日%>
		  <option value="2" ><%=SystemEnv.getHtmlLabelName(16751,user.getLanguage())%></option>
          <% } else { // 原来为工作日，可以调整为假日%>
          <option value="3" ><%=SystemEnv.getHtmlLabelName(16752,user.getLanguage())%></option>
          <% } %>
		</select>
      </td>
    </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
   <% if( selectdatetype.equals("2") ) { %>
   <tr id = relateweekdaytr style="display:none">
      <td><%=SystemEnv.getHtmlLabelName(16754,user.getLanguage())%></td>
      <td class=field>
      <span id="relateweekdayspan" style="display:none">
      <select class=inputstyle name="relateweekday">
		  <option value="2"><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></option>
          <option value="4"><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></option>
		  <option value="5"><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></option>
          <option value="6"><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></option>
          <option value="7"><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></option>
          <option value="1"><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></option>
		</select>
       </span>
      </td>
    </tr>
   <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
   <% } %>
   <% } %>
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

<script language=javascript>
function submitData() {
    if(check_form(document.frmmain,'countryid,holidaydate,holidayname')){
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
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>