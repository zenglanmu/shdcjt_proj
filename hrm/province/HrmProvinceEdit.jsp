<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
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
String provincename = ProvinceComInfo.getProvincename(""+id);
String provincedesc = ProvinceComInfo.getProvincedesc(""+id);
String countryid = ProvinceComInfo.getProvincecountryid(""+id);
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(800,user.getLanguage())+":"+provincename+"-"+provincedesc;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmProvinceEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmProvinceAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/province/HrmProvinceAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",/hrm/province/HrmProvince.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//if(HrmUserVarify.checkUserRight("HrmProvinceEdit:Delete", user)){
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
if(HrmUserVarify.checkUserRight("HrmProvince:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+74+" and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+74+" and relatedid="+id+",_self} " ;
    }
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
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="ProvinceOperation.jsp" method=post>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="10%">
  <COL width="40%">
  <COL width="40%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=3></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></TD>
            <TD class=Field><%if(canEdit){%>
            <input class=inputstyle size=50 maxlength="30" name="provincename" value="<%=provincename%>" onchange='checkinput("provincename","provincenameimage")'>
            <SPAN id=provincenameimage></SPAN>
            <%}else{%><%=provincename%><%}%></TD>
			<td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font></td>
        </TR>
      <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle size=50 maxlength="50" name="provincedesc" value="<%=provincedesc%>"  >
          <SPAN id=provincedescimage></SPAN>
          <%}else{%><%=provincedesc%><%}%></TD>
		  <td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27087,user.getLanguage())%></font></td>
        </TR>
       <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><button type=button  class=Browser id=SelectCountryCode onclick="onShowCountryID()"></BUTTON><%}%> 
              <SPAN id=countryidspan><%=Util.toScreen(CountryComInfo.getCountrydesc(countryid),user.getLanguage())%></SPAN> 
              <input class=inputstyle id=CountryCode type=hidden name=countryid value="<%=countryid%>"></TD>
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
	if(check_form(document.frmMain,'provincename,countryid')){
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
function doCanceled(){
	<%
		String sql = "select * from HrmCity where provinceid = " + id;
		boolean isOracleCity = rs.getDBType().equals("oracle");
		if(isOracleCity) {
			sql += " and nvl(canceled,0) <> 1";
		}else{
			sql += " and ISNULL(canceled,0) <> 1";
		}
		rs.executeSql(sql);
		if(rs.next()) {
	%>
			alert("<%=SystemEnv.getHtmlLabelName(26150, user.getLanguage())%>");
			return ;
	<%
		}
	%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("ope=province&cancelFlag=0&id=<%=id%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	           alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	           window.location.href = "HrmProvince.jsp";
            }catch(e){
                return false;
            }
        }
     }
  }
}

function doISCanceled(){
	<%
		String countrySql = "select * from HrmCountry where id = (select countryid from HrmProvince where id = " + id + ")";
		rs.executeSql(countrySql);
		if(rs.next()) {
			String countryCanceled = Util.null2String(rs.getString("canceled"));
			if("1".equals(countryCanceled)) {
	%>
				alert("<%=SystemEnv.getHtmlLabelName(26153, user.getLanguage())%>");
				return ;
	<%
			}
		}
	%>
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("ope=province&cancelFlag=1&id=<%=id%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
              alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
              window.location.href = "HrmProvince.jsp";
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
</script>
</BODY></HTML>
