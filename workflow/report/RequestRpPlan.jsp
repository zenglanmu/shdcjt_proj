<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String userid =""+user.getUID();


String imagefilename = "/images/hdReport.gif";
String titlename = SystemEnv.getHtmlLabelName(15524,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15353,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM method=post name=frmain>

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


  <TABLE border=0 cellPadding=0 cellSpacing=0 width="100%">
    <TBODY> 
    <TR> 
 <TD vAlign=top width="84%">
         <TABLE class="viewform">
          <COLGROUP> <COL width="49%"> <COL width=10> <COL width="49%"> <TBODY> 
          <TR> 
            <TD vAlign=top> 
              <TABLE width="100%">
                <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
               
                <TR > 
                  <TD class="Line1" colSpan=2></TD>
                </TR>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(787,user.getLanguage())%></td>
                  <td class=Field> 
         <button type='button' class=Browser onClick='onShowResource(resourceidspan,resourceid)'></button> 
         <span class=Inputstyle id=resourceidspan></span> 
    	<input type='hidden' name='resourceid' id='resourceid' >
    	</td>
     
                </tr>  <TR > 
                  <TD class="Line" colSpan=2></TD>
                </TR>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
                  <td class=Field> 
         <button type='button' class=Browser onClick='onShowResource(accepteridspan,accepterid)'></button> 
         <span class=Inputstyle id=accepteridspan></span> 
    	<input type='hidden' name='accepterid' id='accepterid' >
    	</td>
     
                </tr><TR > 
                  <TD class="Line" colSpan=2></TD>
                </TR>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
                  <td class=Field> 
         <button type='button' class=Browser onClick='onShowDate(begindatespan,begindate)'></button> 
         <span class=Inputstyle id=begindatespan><%=currentdate%></span> 
    	<input type='hidden' name='begindate' id='begindate' value="<%=currentdate%>">
    	</td>
     
                </tr><TR > 
                  <TD class="Line" colSpan=2></TD>
                </TR>
                <tr> 
                  <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
                  <td class=Field> 
        <button type='button' class=Browser onClick='onShowDate(enddatespan,enddate)'></button> 
         <span class=Inputstyle id=enddatespan><%=currentdate%></span> 
    	<input type='hidden' name='enddate' id='enddate'  value="<%=currentdate%>"></td>
     
                </tr><TR > 
                  <TD class="Line1" colSpan=2></TD>
                </TR>
                </TBODY> 
              </TABLE>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    </TBODY>
  </TABLE>
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

</FORM>
<SCRIPT language=javascript>
function onSearch(){
	document.frmain.action="RequestRpPlanResult.jsp";
	frmain.submit();
}
</SCRIPT>
<SCRIPT language=VBS>
sub onShowResource(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

</SCRIPT>
</BODY>
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</HTML>
