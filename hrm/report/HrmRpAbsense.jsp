<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@page import="java.text.DateFormat"%> 
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="AllSubordinate" class="weaver.hrm.resource.AllSubordinate" scope="page"/>
<jsp:useBean id="SptmForLeave" class="weaver.hrm.resource.SptmForLeave" scope="page"/>

<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<META http-equiv=Content-Type content="text/html; charset=GBK">
</head>
<%/*if(!HrmUserVarify.checkUserRight("HrmResource:Absense",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}*/
String hrmid="";
ArrayList hrmids = new ArrayList();
hrmids.add(""+user.getUID());
AllSubordinate.getAll(""+user.getUID());
while(AllSubordinate.next()){
    hrmids.add(AllSubordinate.getSubordinateID());
}

String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(670,user.getLanguage());
String needfav ="1";
String needhelp ="";

String departmentid=Util.null2String(request.getParameter("departmentid"));
String resourceid=Util.null2String(request.getParameter("resourceid"));
String fromdate =Util.null2String(request.getParameter("fromdate"));
String todate =Util.null2String(request.getParameter("todate"));

String attendancetype = Util.null2String(request.getParameter("attendancetype"));
String attendancetypename = Util.null2String(request.getParameter("attendancetypename"));
String leavesqlwhere = "";
String leavetype = "";
String otherleavetype = "";
if(!attendancetype.equals("")){
	if(Util.TokenizerString2(attendancetype,"_")[0].equals("otherleavetype")){
	    otherleavetype = Util.TokenizerString2(attendancetype,"_")[1];
	    leavesqlwhere = " and leavetype = 4 and otherleavetype = " + otherleavetype;
	}else{
	    leavetype = Util.TokenizerString2(attendancetype,"_")[1];
	    leavesqlwhere = " and leavetype = " + leavetype;
	}
}

Calendar today = Calendar.getInstance();
if(fromdate.equals("")) {
	fromdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-01" ;
}

if(todate.equals("")) {
	todate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
}

String querystr = "select resourceid,leavetype,otherleavetype,fromdate,fromtime,todate,totime,leavedays,leavereason,a.requestid,b.requestname from bill_bohaileave a, workflow_requestbase b where a.requestid = b.requestid and b.currentnodetype = 3" ;
				
if(!departmentid.equals("")) querystr += " and a.departmentid = "+departmentid ;

if(HrmUserVarify.checkUserRight("HrmResource:Absense",user)) {
    if(!resourceid.equals("")) querystr += " and a.resourceid = "+resourceid ;
} else {
  if(!resourceid.equals("")) querystr += " and a.resourceid = "+resourceid ;
     else {
     
        for(int i=0 ; i<hrmids.size() ; i++){
            if(i==0)
                hrmid=(String)hrmids.get(i);
            else
                hrmid+=","+(String)hrmids.get(i);
        }
         querystr += " and a.resourceid in ("+hrmid+")" ;
     }
}



querystr += " and ((a.fromdate <= '"+todate+"' and a.fromdate >= '"+fromdate+"') or "+
				" (a.todate <= '"+todate+"' and a.todate >= '"+fromdate+"') or (a.todate >= '"+todate+"' and a.fromdate <= '"+fromdate+"')) " ;
querystr += leavesqlwhere;
querystr += " order by a.fromdate ,a.fromtime" ;
rs.executeSql(querystr);

ExcelFile.init();
ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin); 
ExcelRow er = es.newExcelRow();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(17416,user.getLanguage())+"-Excel,javascript:exportExcel(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<iframe name="ExcelOut" id="ExcelOut" src="" style="display:none" ></iframe>
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
<FORM id=frmmain name=frmmain method=post action="HrmRpAbsense.jsp">
   <TABLE class=ViewForm>
    <col width=10%> <col width=20%><col width=10%> <col width=20%> <col width=10%><col width=30%>
    <TR class=Title> 
      <TH colspan=6><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
    </TR>
    <TR class= Spacing> 
      <TD class=Line1 colspan=6></TD>
    </TR>
    <tr>   
      <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
      <td class="field">
        <!--
         <button class=Browser id=SelecResourceid onClick="onShowResourceID()"></button> 
         <span id=resourceidspan> <a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></span> 
         --> 
         <input class=wuiBrowser id=resourceid type=hidden name=resourceid value="<%=resourceid%>"   
          _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
          _displayTemplate=" <a href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</a>"
          _displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>"
         > 
        </td>
   
      <td><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></td>
      <td class="field">
          <BUTTON type="button" class=Browser onclick="onShowScheduleDiff('attendancetypespan','attendancetypename','attendancetype')"></BUTTON> 
          <SPAN id=attendancetypespan><%=attendancetypename%></SPAN> 
          <INPUT class=inputstyle type=hidden name=attendancetype value="<%=attendancetype%>">
          <INPUT class=inputstyle type=hidden name=attendancetypename value="<%=attendancetypename%>">	  
      </td>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class="field"><BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
      <SPAN id=fromdatespan ><%if(!fromdate.equals("0")){%><%=fromdate%><%}%></SPAN>
      -&nbsp;&nbsp;<BUTTON type=button class=calendar id=SelectDate2 onclick="gettoDate()"></BUTTON>&nbsp;
      <SPAN id=todatespan><%if(!fromdate.equals("0")){%><%=todate%><%}%></SPAN>
	  <input class=inputStyle type="hidden" name="fromdate" value="<%=fromdate%>">
	  <input class=inputStyle type="hidden" name="todate" value="<%=todate%>"> </td>
    </tr>
<TR  style="height:2px"><TD class=Line colSpan=6></TD></TR> 
  </table>
  
  <br>
  <table class=ListStyle cellspacing=1 >
    <colgroup> 
    <col width="23%"> 
    <col width="10%">
    <col width="7%"> 
    <col width="10%"> 
    <col width="15%"> 
    <col width="15%"> 
    <col width="30%">
    <tbody> 
    <tr class=Header> 
      <th colspan=7><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></th>
    </tr>
    <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(827,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(828,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(1881,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
	  <td><%=SystemEnv.getHtmlLabelName(791,user.getLanguage())%></td>
    </tr>
    <TR class=Line><TD colspan="7" ></TD></TR> 
    <%
	er.addStringValue(SystemEnv.getHtmlLabelName(85,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(827,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(828,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(1881,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(742,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(743,user.getLanguage()), "Header");
	er.addStringValue(SystemEnv.getHtmlLabelName(791,user.getLanguage()), "Header");
	
	float sumleavedays = 0;
	String sumStringleavedays="";
	while(rs.next()){
		//resourceid,leavetype,otherleavetype,fromdate,fromtime,todate,totime,leavedays,leavereason,a.requestid,b.requestname
		String _resourceid = rs.getString("resourceid");
		String _leavetype = rs.getString("leavetype");
		String _otherleavetype = rs.getString("otherleavetype");
		String _fromdate = rs.getString("fromdate");
		String _fromtime = rs.getString("fromtime");
		String _todate = rs.getString("todate");
		String _totime = rs.getString("totime");
		String _leavedays = rs.getString("leavedays");
		String _leavereason = rs.getString("leavereason");
		String _requestid = rs.getString("requestid");
		String _requestname = rs.getString("requestname");
		String _leavename = SptmForLeave.getLeaveType(_leavetype,_otherleavetype);
		 java.text.DecimalFormat df=new java.text.DecimalFormat("#0.00"); 
             String output = df.format(Util.getFloatValue(_leavedays,0)); 
              float sumday = Float.parseFloat(output);
              sumleavedays =sumleavedays+sumday; 
              sumStringleavedays=df.format(sumleavedays);
	%>
		<tr>
	      <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=_requestid%>" target="_blank"><%=_requestname%></a></td>
		  <td><a href="/hrm/resource/HrmResource.jsp?id=<%=_resourceid%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(_resourceid),user.getLanguage())%></a></td>
	      <td><%=_leavedays%></td>
	      <td><%=_leavename%></td>
		  <td><%=_fromdate+" "+_fromtime%></td>
	      <td><%=_todate+" "+_totime%></td>
		  <td><%=_leavereason%></td>
	    </tr>
    <%
		er = es.newExcelRow();
		er.addStringValue( _requestname, "Border");
		er.addStringValue(Util.toScreen(ResourceComInfo.getResourcename(_resourceid),user.getLanguage()), "Border");
		er.addStringValue("" + _leavedays, "Border");
		er.addStringValue("" + _leavename, "Border");
		er.addStringValue(_fromdate+" "+_fromtime, "Border");
		er.addStringValue(_todate+" "+_totime, "Border");
		er.addStringValue("" + _leavereason, "Border");
    	}%>
    <tr class=TOTAL style="FONT-WEIGHT: bold; COLOR: red"> 
		<td colspan=2><%=SystemEnv.getHtmlLabelName(358,user.getLanguage())%></td>
		<td><%=sumStringleavedays%></td> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
<%
	er = es.newExcelRow();
	er.addStringValue(SystemEnv.getHtmlLabelName(358,user.getLanguage()), "Border", 2);
	er.addStringValue(""+sumleavedays , "Border", 5);
	ExcelFile.setFilename(SystemEnv.getHtmlLabelName(16547,user.getLanguage()));
   	ExcelFile.addSheet(SystemEnv.getHtmlLabelName(16547,user.getLanguage()), es);
%>
    </tbody>
  </table>
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
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?sqlwhere=where HrmResource.id in  (<%=hrmid%>)")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	frmmain.resourceid.value=id(0)
	resourceidspan.innerHtml=id(1)
	else
	frmmain.resourceid.value=""
	resourceidspan.innerHtml=""
	end if
	end if
end sub

sub onShowScheduleDiff1(tdname,spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/AnnualTypeBrowser.jsp")
	if NOT isempty(id) then
	  if id(0)<> "" and id(0)<>"0" then
		document.all(tdname).innerHtml = id(1)
        document.all(spanname).value = id(1)
        document.all(inputename).value=id(0)
		else
		document.all(tdname).innerHtml = ""
        document.all(spanname).value = ""
		document.all(inputename).value=""
	  end if
	end if
end sub
</script>

<script language=javascript>

function onShowScheduleDiff(tdname,spanname,inputename){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/schedule/AnnualTypeBrowser.jsp");
	if(results){
	   if(results.id!=""){
	      jQuery("#"+tdname).html(results.name);
	      $GetEle(spanname).value=results.name;
	      $GetEle(inputename).value=results.id;
	   }else{
	      jQuery("#"+tdname).html("");
	      $GetEle(spanname).value="";
	      $GetEle(inputename).value="";
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
//	alert(document.frmmain.bywhat.value) ;
//	alert(document.frmmain.currentdate.value) ;
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
function submitData() {
 frmmain.submit();
}
function exportExcel()
{
    document.getElementById("ExcelOut").src = "/weaver/weaver.file.ExcelOut";
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>