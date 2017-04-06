<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String canceled = request.getParameter("canceled");
String countryname = CountryComInfo.getCountryname(""+id);
String countrydesc = CountryComInfo.getCountrydesc(""+id);;

String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(377,user.getLanguage())+":"+countryname+"-"+countrydesc;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<FORM id=weaver name=frmMain action="CountryOperation.jsp" method=post>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCountriesEdit:Edit", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCountriesAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/country/HrmCountriesAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//if(HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)){
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
if(HrmUserVarify.checkUserRight("HrmCountries:Log", user)){
    if(rs.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem)="+22+" and relatedid="+id+",_self} " ;
    }else{
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+22+" and relatedid="+id+",_self} " ;
    }
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/country/HrmCountries.jsp,_self} " ;
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
<TABLE class=viewform>
  <COLGROUP>
  <COL width="10%">
  <COL width="40%">
  <COL width="40%">
  <TBODY>
  <TR class=title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:1px;">
    <TD class=line1 colSpan=3></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
            <TD class=Field><%if(canEdit){%>
            <input class=inputstyle size=50  maxlength="30" name="countryname" value="<%=countryname%>" onchange='checkinput("countryname","countrynameimage")'>
            <SPAN id=countrynameimage></SPAN>
            <%}else{%><%=countryname%><%}%></TD>
			<td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27086,user.getLanguage())%></font></td>
        </TR>
                <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></TD>
          <TD class=Field><%if(canEdit){%><input class=inputstyle size=50  maxlength="50" name="countrydesc" value="<%=countrydesc%>"  onchange='checkinput("countrydesc","countrydescimage")'>
          <SPAN id=countrydescimage></SPAN>
          <%}else{%><%=countrydesc%><%}%></TD>
		  <td align="left"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(27087,user.getLanguage())%></font></td>
        </TR>
              <TR style="height:1px;"><TD class=Line colSpan=3></TD></TR> 
 </TBODY></TABLE>
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
	if(check_form($GetEle("frmMain"),'countryname,countrydesc')){
		$GetEle("frmMain").operation.value="edit";
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
	<%
		String sql = "select * from HrmProvince where countryid = " + id;
		boolean isOracleCity = rs.getDBType().equals("oracle");
		if(isOracleCity) {
			sql += " and nvl(canceled,0) <> 1";
		}else{
			sql += " and ISNULL(canceled,0) <> 1";
		}
		rs.executeSql(sql);
		if(rs.next()) {
	%>
			alert("<%=SystemEnv.getHtmlLabelName(26151, user.getLanguage())%>");
			return ;
	<%
		}
	%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("ope=country&cancelFlag=0&id=<%=id%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	           alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	           window.location.href = "HrmCountries.jsp";
            }catch(e){
                return false;
            }
        }
     }
  }
}

function doISCanceled(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "/hrm/country/HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("ope=country&cancelFlag=1&id=<%=id%>");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
              alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
              window.location.href = "HrmCountries.jsp";
            }catch(e){
                return false;
            }
        }
     }
   }
 }
 </script>
</BODY>
</HTML>