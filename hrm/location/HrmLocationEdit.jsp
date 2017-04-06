<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type='text/javascript' src='/dwr/interface/HrmUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String locationname="";
String locationdesc="";
String address1="";
String address2="";
String locationcity="";
String postcode="";
String countryid="";
String telephone="";
String fax="";
String showOrder="";
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
RecordSet.executeProc("HrmLocations_SelectByID",""+id);

if(RecordSet.next()){
	locationname = Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage());
	locationdesc = Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage());
	address1 = Util.toScreenToEdit(RecordSet.getString(4),user.getLanguage());
	address2= Util.toScreenToEdit(RecordSet.getString(5),user.getLanguage());
	locationcity = Util.toScreenToEdit(RecordSet.getString(6),user.getLanguage());
	postcode = Util.toScreenToEdit(RecordSet.getString(7),user.getLanguage());
	countryid = Util.toScreenToEdit(RecordSet.getString(8),user.getLanguage());
	telephone = Util.toScreenToEdit(RecordSet.getString(9),user.getLanguage());
	fax = Util.toScreenToEdit(RecordSet.getString(10),user.getLanguage());
	showOrder = Util.null2String(RecordSet.getString("showOrder"));        
}

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(378,user.getLanguage())+"："+locationname;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmLocationsEdit: Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/location/HrmLocationAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmLocationsEdit:Delete", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmLocations:Log", user)){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)=23 and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem=23 and relatedid="+id+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
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

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=weaver name=frmMain action="LocationOperation.jsp" method=post>
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
   <TD class=Field>
   <%if(canEdit){%><INPUT class=inputstyle type=text size=30 name="locationname" value="<%=locationname%>" onchange='checkinput("locationname","locationnameimage")'>
          <SPAN id=locationnameimage></SPAN>
	<%}else{%><%=locationname%><%}%>
   </TD>
     </tr>
       <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
     <TD class=Field><%if(canEdit){%><INPUT class=inputstyle type=text size=30 name="locationdesc"  value="<%=locationdesc%>" onchange='checkinput("locationdesc","locationdescimage")'>
          <SPAN id=locationdescimage></SPAN><%}else{%><%=locationdesc%><%}%></TD>
     </tr>
         <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
    <TR class=Title>
      <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15712,user.getLanguage())%></TH>
    </TR>
    <TR style="height:2px"><TD class=Line1 colSpan=4></TD></TR>

      <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 1</TD>
    <TD class=FIELD colSpan=3><%if(canEdit){%><INPUT class=InputStyle maxLength=100 size=60
      name=address1 value="<%=address1%>"><%}else{%><%=address1%><%}%></TD>
        &nbsp; </TD>
    </TR>
         <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%> 2</TD>
    <TD class=FIELD colSpan=3><%if(canEdit){%><INPUT class=InputStyle maxLength=100 size=60
      name=address2 value="<%=address2%>"> <%}else{%><%=address2%><%}%></TD></TR>
<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
     <TR>
    <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
    <TD class=FIELD colSpan=3><%if(canEdit){%><INPUT class=InputStyle maxLength=6 size=6 name=postcode value="<%=postcode%>" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("postcode")' >&nbsp;


        <INPUT class="wuiBrowser" id=cityid type=hidden name=cityid  value="<%=locationcity%>" 
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
		_displayText="<%=CityComInfo.getCityname(locationcity)%>"
		_required="yes">
        <%}else{%><%=CityComInfo.getCityname(locationcity)%><%}%></TD></TR>
<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
       <TD class=FIELD colSpan=3><%if(canEdit){%>

<INPUT class="wuiBrowser" id=countryid type=hidden name=countryid  value="<%=countryid%>" 
_url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp"
_displayText="<%=CountryComInfo.getCountrydesc(countryid)%>"
_required="yes">
      <%}else{%><%=CountryComInfo.getCountrydesc(countryid)%><%}%>
       </TD></TR>
<TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
   <TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15858,user.getLanguage())%></TH></TR>
  <TR style="height:2px">
    <TD class=Line1 colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
    <TD class=FIELD  colspan=3><%if(canEdit){%><INPUT class=inputStyle maxLength=30 size=30
    name=telephone value="<%=telephone%>" ><%}else{%><%=telephone%><%}%></TD>
  </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
    <TD class=FIELD colspan=3><%if(canEdit){%><INPUT class=inputStyle maxLength=30 size=30
  name=fax value="<%=fax%>" ><%}else{%><%=fax%><%}%></TD></TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>
   <TR class=Title>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TH></TR>
  <TR style="height:2px">
    <TD class=Line1 colSpan=4></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
    <TD class=FIELD  colspan=3><%if(canEdit){%><INPUT class=inputStyle maxLength=15 size=15
    name=showOrder value="<%=showOrder%>" onKeyPress='ItemDecimal_KeyPress("showOrder",15,2)'  onchange='checknumber("showOrder");checkDigit("showOrder",15,2);checkinput("showOrder","showOrderImage")'><%}else{%><%=showOrder%><%}%>
	<SPAN id=showOrderImage></SPAN>
	</TD>
  </TR>
    <TR style="height:1px"><TD class=Line colSpan=4></TD></TR>

    </TBODY></TABLE>
   <input class=inputstyle type="hidden" name=operation>
   <input class=inputstyle type="hidden" name=id value=<%=id%>>
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

 <script language=vbs>
 sub onShowCountry()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	   if frmMain.cityid.value<>"" then
             result=checkCity(frmMain.cityid.value,id(0) )
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
	frmMain.cityid.value=id(0)
    getCountry(id(0))
    else
	cityspan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.cityid.value=""
	end if
	end if
end sub
</script>
 <script language=javascript>
jQuery(document).ready(function(){
	jQuery(".wuiBrowser").modalDialog();
});

 function onSave(){

	if(document.frmMain.locationname.value==""|| document.frmMain.locationdesc.value==""||
	   document.frmMain.countryid.value==""||
	   document.frmMain.cityid.value==""){
	 alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
	}else{
	 	document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
 }
 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
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
 </script>
</BODY></HTML>
