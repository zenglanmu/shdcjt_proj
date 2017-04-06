<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%

String method=Util.null2String(request.getParameter("method"));
String from=Util.null2String(request.getParameter("from"));

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(920,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onGoSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",CarSearch.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM id=weaver name="frmain" action="/car/CarSearchResult.jsp" method=post>
<input class=inputstyle type="hidden" name="destination" value="no"> 
<input type="hidden" name="from" value="<%=from%>"> 
<TABLE class=viewForm style="width:98%" align="center">
        <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
        <TBODY align="left">
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(920,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
			<td  class=Field>
				<%
				//String meetingtypes = ","+MeetingSearchComInfo.getmeetingtype()+",";
				RecordSetCT.executeProc("CarType_Select","");
				while(RecordSetCT.next()){
				%>			
					<input class=inputstyle name="carType" type="checkbox" value="<%=RecordSetCT.getString("id")%>"><%=Util.toScreen(RecordSetCT.getString("name"),user.getLanguage())%>
				<%}%>			
			</td>
		</tr>
		<TR style="height:2px"><TD class=line colSpan="2"></TD></TR>
        <TR>
			<TD><%=SystemEnv.getHtmlLabelName(20319,user.getLanguage())%></TD>
			<TD class=Field><INPUT class=inputstyle maxLength=30 size=30 name="carNo"></TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(20318,user.getLanguage())%></TD>
        	<TD class=Field><INPUT class=inputstyle maxLength=30 size=30 name="factoryNo"></TD>
        </TR>
       <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></TD>
        	<TD class=Field>
				<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>&nbsp;&nbsp;
				<input name="startdate" type="hidden" class=wuiDate  ></input> 
				
				<%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%>&nbsp;&nbsp;
				<input name="enddate" type="hidden" class=wuiDate />
				
        	</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        <TR>
        	<TD><%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%></TD>
        	<TD class=Field>
				<input class=wuiBrowser  type=hidden name=driver _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp">
				<span id=driverSpan></span> 
			</TD>
        </TR>
        <TR style="height:2px"><TD class=line colspan="2"></TD></TR>
        </TBODY>
	  </TABLE>
</FORM>
</div>
<script language=javascript>
function onGoSearch(){
	weaver.destination.value="goSearch";
	weaver.submit();
}
</script>
<% /* 
<script language=vbs>
sub onShowResourceID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	driverSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.driver.value=id(0)
	else
	driverSpan.innerHtml = ""
	weaver.driver.value=""
	end if
	end if
end sub
</script>
*/ %>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
</HTML>