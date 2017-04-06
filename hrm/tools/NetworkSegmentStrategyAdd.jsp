<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
 if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem.gif";
String titlename = SystemEnv.getHtmlLabelName(21384,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onAdd(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
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
<FORM id=frmMain name=frmMain action="NetworkSegmentStrategyOperation.jsp" method=post >
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21384,user.getLanguage())%></TH></TR>
  <TR class=spacing style="height:2px">
    <TD class=line1 colSpan=2 ></TD></TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(21387,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle maxLength=3 type=text size=8 name="inceptipaddressA" onBlur="checkcount1(this),CheckIntRange1(this),checkinputip('inceptipaddressimage')">.<input class=inputstyle maxLength=3 type=text size=8 name="inceptipaddressB" onBlur="checkcount1(this),CheckIntRange(this),checkinputip('inceptipaddressimage')">.<input class=inputstyle maxLength=3 type=text size=8 name="inceptipaddressC" onBlur="checkcount1(this),CheckIntRange(this),checkinputip('inceptipaddressimage')">.<input class=inputstyle maxLength=3 type=text size=8 name="inceptipaddressD" onBlur="checkcount1(this),CheckIntRange(this),checkinputip('inceptipaddressimage')">
          <SPAN id=inceptipaddressimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(21388,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle maxLength=3 type=text size=8 name="endipaddressA" onBlur="checkcount1(this),CheckIntRange1(this),checkinputipB('endipaddressimage')">.<input class=inputstyle maxLength=3 type=text size=8 name="endipaddressB" onBlur="checkcount1(this),CheckIntRange(this),checkinputipB('endipaddressimage')">.<input class=inputstyle maxLength=3 type=text size=8 name="endipaddressC" onBlur="checkcount1(this),CheckIntRange(this),checkinputipB('endipaddressimage')">.<input class=inputstyle maxLength=3 type=text size=8 name="endipaddressD" onBlur="checkcount1(this),CheckIntRange(this),checkinputipB('endipaddressimage')">
          <SPAN id=endipaddressimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>
		  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(21386,user.getLanguage())%></TD>
          <TD class=Field><input class=inputstyle type=text size=60 name="segmentdesc">
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
		<input class=inputstyle type="hidden" name=operation value=add>
		<input class=inputstyle type="hidden" name=segmentdesc value=segmentdesc>
 </TBODY></TABLE>
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
function onAdd(obj) {
 if(check_form(document.frmMain,'inceptipaddressA,inceptipaddressB,inceptipaddressC,inceptipaddressD,endipaddressA,endipaddressB,endipaddressC,endipaddressD')){
 frmMain.submit();
 obj.disabled=true;

 }
}
function goBack() {
	window.history.go(-1);
}

function CheckIntRange1(CheckCtl){
 valuechar = CheckCtl.value;
 if(valuechar!=""){
  if(valuechar>223||valuechar<1){
	alert(CheckCtl.value+"<%=SystemEnv.getHtmlLabelName(21390,user.getLanguage())%>"+"£¬"+"<%=SystemEnv.getHtmlLabelName(21389,user.getLanguage())%>");
	  if(valuechar>223){
	  CheckCtl.value="223";
	}else if(valuechar<1){
	  CheckCtl.value="1";	
	}
  }
 }
}

function CheckIntRange(CheckCtl){
 valuechar = CheckCtl.value;
 if(valuechar!=""){
  if(valuechar>255||valuechar<0){
	alert(CheckCtl.value+"<%=SystemEnv.getHtmlLabelName(21390,user.getLanguage())%>"+"£¬"+"<%=SystemEnv.getHtmlLabelName(21392,user.getLanguage())%>");
	if(valuechar>255){
	  CheckCtl.value="255";
	}else if(valuechar<0){
	  CheckCtl.value="0";	
	}
  }
 }
}
function checkinputip(spanid){
	tmpvalueA = document.all("inceptipaddressA").value;
	tmpvalueB = document.all("inceptipaddressB").value;
	tmpvalueC = document.all("inceptipaddressC").value;
	tmpvalueD = document.all("inceptipaddressD").value;
	if(tmpvalueA!=""&&tmpvalueB!=""&&tmpvalueC!=""&&tmpvalueD!=""){
		document.getElementById(spanid).innerHTML="";
	}else{
		document.getElementById(spanid).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	}
}
function checkinputipB(spanid){
	tmpvalueipA = document.all("endipaddressA").value;
	tmpvalueipB = document.all("endipaddressB").value;
	tmpvalueipC = document.all("endipaddressC").value;
	tmpvalueipD = document.all("endipaddressD").value;
	if(tmpvalueipA!=""&&tmpvalueipB!=""&&tmpvalueipC!=""&&tmpvalueipD!=""){
		document.getElementById(spanid).innerHTML="";
	}else{
		document.getElementById(spanid).innerHTML="<IMG src='/images/BacoError.gif' align=absMiddle>";
	}
}
</script>
</BODY>
</HTML>