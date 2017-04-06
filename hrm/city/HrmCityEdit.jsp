<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String canceled = request.getParameter("canceled");
String cityname = CityComInfo.getCityname(""+id);
String citylongitude = CityComInfo.getCitylongitude(""+id);
String citylatitude = CityComInfo.getCitylatitude(""+id);
String provinceid = CityComInfo.getCityprovinceid(""+id);
String countryid = CityComInfo.getCitycountryid(""+id);
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(493,user.getLanguage())+":"+cityname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/city/HrmCityAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//if(HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)){
//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
if("0".equals(canceled) || "".equals(canceled) || "Null".equals(canceled)){
	  	RCMenu += "{"+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+",javascript:doCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}else{
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(22152,user.getLanguage())+",javascript:doISCanceled(),_self} " ;
	  	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCity:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+61+" and relatedid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/hrm/city/HrmCity.jsp,_self} " ;
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

<FORM id=weaver name=frmMain action="CityOperation.jsp" method=post>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="10%">
  <COL width="20%">
  <COL width="40%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=3 ></TD></TR>

  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30  maxlength="30" name="cityname" onchange='checkinput("cityname","citynameimage")' value=<%=cityname%>>
          <SPAN id=citynameimage></SPAN><%}else{%><%=cityname%><%}%></TD>
		  <td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font></td>
        </TR>
       <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR>    
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(801,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 maxlength="7" name="citylongitude"  onKeyPress="ItemNum_KeyPress()" onchange='checknumber1(this) ;checkinput("citylongitude","citylongitudeimage")' value=<%=citylongitude%>>
          <SPAN id=citylongitudeimage></SPAN><%}else{%><%=citylongitude%><%}%></TD>
        </TR>
        <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(802,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle type=text size=30 maxlength="7" name="citylatitude" onKeyPress="ItemNum_KeyPress()" onchange='checknumber1(this) ;checkinput("citylatitude","citylatitudeimage")' value=<%=citylatitude%>>
          <SPAN id=citylatitudeimage></SPAN><%} else{ %><%=citylatitude%><%}%></TD>
        </TR>
       <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><button type=button  class=Browser id=SelectCountryCode onclick="onShowCountryID()"></BUTTON><%}%> 
              <SPAN id=countryidspan><%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%></SPAN> 
              <input class=inputstyle id=CountryCode type=hidden name=countryid value="<%=countryid%>"></TD>
        </TR>
       <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
       <TR>
          <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><button type=button  class=Browser id=SelectProvinceCode onclick="onShowProvinceID()"></BUTTON><%}%> 
              <SPAN id=provinceidspan><%=Util.toScreen(ProvinceComInfo.getProvincename(provinceid),user.getLanguage())%></SPAN> 
              <input class=inputstyle id=ProvinceCode type=hidden name=provinceid value="<%=provinceid%>"></TD>
        </TR>
       <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
 </TBODY>
 </TABLE>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=id%>">
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
 <script>
 function onSave(){
	if(check_form($GetEle("frmMain"),'cityname,citylongitude,citylatitude,provinceid,countryid')){
		$GetEle("operation").value="edit";
		$GetEle("frmMain").submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			$GetEle("operation").value="delete";
			$GetEle("frmMain").submit();
		}
}
function doCanceled(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("ope=city&cancelFlag=0&id=<%=id%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	           alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	           window.location.href = "HrmCity.jsp";
            }catch(e){
                return false;
            }
        }
     }
  }
}

function doISCanceled(){
	<%
		String sql = "select * from HrmProvince where id = (select provinceid from HrmCity where id = " + id + ")";
		rs.executeSql(sql);
		if(rs.next()) {
			String provinceCanceled = Util.null2String(rs.getString("canceled"));
			if("1".equals(provinceCanceled)) {
	%>
				alert("<%=SystemEnv.getHtmlLabelName(26152, user.getLanguage())%>");
				return ;
	<%
			}
		}
	%>
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("ope=city&cancelFlag=1&id=<%=id%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
              alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
              window.location.href = "HrmCity.jsp";
            }catch(e){
                return false;
            }
        }
     }
   }
 }
</script>
<script type="text/javascript">
function onShowCountryID() {
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle("countryidspan").innerHTML = jsid[1];
            $GetEle("countryid").value = jsid[0];
        }else {
            $GetEle("countryidspan").innerHTML = "";
            $GetEle("countryid").value = "";
        }
    }
}
function onShowProvinceID() {
    var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
    try {
        jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            $GetEle("provinceidspan").innerHTML = jsid[1];
            $GetEle("provinceid").value = jsid[0];
        }else {
            $GetEle("provinceidspan").innerHTML = "";
            $GetEle("provinceid").value = "";
        }
    }
}
</script>

</BODY>
</HTML>