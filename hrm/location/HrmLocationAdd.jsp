<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/HrmUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(378,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
double  showOrder=1;
RecordSet.executeSql("select max(showOrder) as maxShowOrder from HrmLocations");
if(RecordSet.next()){
	showOrder=Util.getDoubleValue(RecordSet.getString("maxShowOrder"),0);
	showOrder++;
}
%>

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

<FORM id=weaver name=frmMain action="LocationOperation.jsp" method=post >

 <TABLE class=ViewForm>
  <COLGROUP>
  <COL width="15%">
  <COL width="33%">
  <COL width="15%">
  <COL width="33%">
  <TBODY>
    <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
    </TR>
    <TR style="height:2px"><TD class=Line1 colSpan=4></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
   <TD class=Field><INPUT class=inputStyle type=text size=30 name="locationname" onchange='checkinput("locationname","locationnameimage")'>
          <SPAN id=locationnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
     </tr>  
     <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
     <TD class=Field><INPUT class=inputStyle type=text size=30 name="locationdesc" onchange='checkinput("locationdesc","locationdescimage")'>
          <SPAN id=locationdescimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
     </tr> 
     <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 	 
  <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TH>
    </TR>
  <TR style="height:2px">
    <TD class=Line1 colSpan=4></TD></TR>
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</TD>
    <TD class=FIELD colSpan=3><INPUT class=inputStyle maxLength=100 size=60 
      name=address1>
        &nbsp; </TD>
    </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 2</TD>
    <TD class=FIELD colSpan=3><INPUT class=inputStyle maxLength=100 size=60 
      name=address2> </TD></TR>
      <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
    <TD class=FIELD colSpan=3><INPUT class=inputStyle maxLength=6 size=6 name=postcode onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("postcode")' >&nbsp;

    <BUTTON type=button class=Browser onClick="onShowCity()"></BUTTON> 
    <span class=inputStyle id="cityspan"><IMG src="/images/BacoError.gif" align=absMiddle></span> 
    <INPUT class=inputStyle id=locationcity type=hidden name=cityid >
    </TD>
  </TR>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <TR>
      <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD> 
       <TD class=FIELD colSpan=3>

<BUTTON type=button class=Browser onClick="onShowCountry()"></BUTTON> 
        <span class=inputStyle id=countryspan><IMG src="/images/BacoError.gif" align=absMiddle></span> 
<INPUT class=inputStyle id=countryid type=hidden name=countryid>
      
       </TD></TR>
       <TR style="height:1px"><TD class=Line colSpan=4></TD></TR> 
  <TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15858,user.getLanguage())%></TH></TR>
  <TR style="height:2px">
    <TD class=Line1 colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
    <TD class=FIELD colspan=3><INPUT class=inputStyle maxLength=30 size=30 
    name=telephone></TD></TR>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
  <TR>

    <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
    <TD class=FIELD colspan=3><INPUT class=inputStyle maxLength=30 size=30  
  name=fax></TD></TR>
  <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
   <TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH></TR>
  <TR style="height:2px">
    <TD class=Line1 colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
    <TD class=FIELD  colspan=3><INPUT class=inputStyle maxLength=15 size=15
    name=showOrder value="<%=showOrder%>" onKeyPress='ItemDecimal_KeyPress("showOrder",15,2)'  onchange='checknumber("showOrder");checkDigit("showOrder",15,2);checkinput("showOrder","showOrderImage")'>
	<SPAN id=showOrderImage></SPAN>
	</TD>
  </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>  

  </TBODY></TABLE>
   <input class=inputStyle type="hidden" name=operation value=add>
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
jQuery(document).ready(function(){
	jQuery(".wuiBrowser").modalDialog();
});

function submitData(obj) {
 if(check_form(frmMain,'locationname,locationdesc,countryid,cityid')){
	 obj.disabled=true;
     frmMain.submit();
 }
}
 function showCountry(o){
     document.all('countryspan').innerHTML =o.split('_')[0];
	 document.all('countryid').value=o.split('_')[1] ;
 }
 function getCountry(id){
     HrmUtil.getCountryByCity(id,showCountry) ;

 }

function check(o){
     if(!o)
     alert('所选的城市与国家之间无归属关系！') ;
     return o;
 }
function checkCity(id,countryid){

     HrmUtil.checkCity(id,countryid,check) ;
 }

/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}


function onShowCity() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != 0 && rid != "") {
			$G("cityspan").innerHTML = rname;
			$G("locationcity").value = rid;
			getCountry(rid);
		} else {
			$G("cityspan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			$G("locationcity").value=""
		}
	}
}


function onShowCountry() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != 0 && rid != "") {
			 if ($G("locationcity").value != "") {
		         var result = checkCity($G("locationcity").value, rid);
		         if (result) {
			         $G("countryspan").innerHTML = rname;
			         $G("countryid").value= rid;
		         }
			 } else {
			    $G("countryspan").innerHTML = rname;
			    $G("countryid").value= rid;
			 }
		} else {
			$G("countryspan").innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>";
				$G("countryid").value="";
		}
	}
}
</script>
 <script language=vbs>
 sub onShowCountry()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
         if frmMain.locationcity.value<>"" then
             result=checkCity(frmMain.locationcity.value,id(0) )
             if result then
              countryspan.innerHtml = id(1)
	          frmMain.countryid.value=id(0)
             end if
        else
        countryspan.innerHtml = id(1)
	    frmMain.countryid.value=id(0)
        end if
    else
	countryspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.countryid.value=""
	end if
	end if
end sub
sub onShowCity()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	cityspan.innerHtml = id(1)
	frmMain.locationcity.value=id(0)
    getCountry(id(0))
    else
	cityspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.locationcity.value=""
	end if
	end if
end sub
</script>
</BODY></HTML>
