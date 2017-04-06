<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

RecordSetC.executeProc("CRM_ContacterLog_R_SById",CustomerID);
RecordSetC.next();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'before')){
        weaver.submit();
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(6061,user.getLanguage())+" - "+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
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
		<%if(!isfromtab) {%>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

<FORM id=weaver name=weaver action="ContacterLogRemindOperation.jsp" method=post onsubmit='return check_form(this,"before")'>
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
<input type="hidden" name="isfromtab" value="<%=isfromtab%>">
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY>        
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
		  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=checkbox name="isremind" value="0" <%if (RecordSetC.getString("isremind").equals("0")) {%>checked><%}%></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <!--TR>          <TD><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          <TD class=Field>
		  <select name="daytype">
			<option value="1" <%if (RecordSetC.getString("daytype").equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></option>
			<option value="2" <%if (RecordSetC.getString("daytype").equals("2")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>
			</select></TD>
        </TR-->    
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(6077,user.getLanguage())%>£¨<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>£©</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=2 size=10 name="before" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("before")' onchange='checkinput("before","beforeimage")' value = "<%=RecordSetC.getString("before")%>"><SPAN id=beforeimage><%if (RecordSetC.getString("before").equals("")) {%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
</FORM>
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
</BODY>
</HTML>
