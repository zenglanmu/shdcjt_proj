<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="session" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>

<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);

String userid = ""+user.getUID();
String logintype = ""+user.getLogintype();
String usertype ="0";
if(logintype.equals("1"))
	usertype = "0";
else usertype = "1";

StringBuffer stringBuffer = new StringBuffer();

stringBuffer.append("SELECT DISTINCT t1.id, t1.name, t1.caller, t1.contacter, t1.address,");
stringBuffer.append(" t1.beginDate, t1.beginTime, t1.endDate, t1.endTime, t1.meetingStatus, t1.customizeAddress,");
stringBuffer.append(" (SELECT status FROM Meeting_View_Status WHERE meetingId = t1.id AND userId = ");
stringBuffer.append(userid); 
stringBuffer.append(") AS status");
stringBuffer.append(" FROM Meeting t1, Meeting_Member2 t2");
stringBuffer.append(" WHERE t1.id = t2.meetingId and t1.isdecision<>2");
stringBuffer.append(" AND (t2.memberId = ");
stringBuffer.append("'"+userid+"'");
stringBuffer.append(" OR t2.othermember = ");
stringBuffer.append("'"+userid+"'");
stringBuffer.append(" OR t1.caller = ");
stringBuffer.append(userid);
stringBuffer.append(" OR t1.contacter = ");
stringBuffer.append("'"+userid+"'");
stringBuffer.append(") AND t1.meetingStatus = 2");
stringBuffer.append(" AND (t1.endDate > '");
stringBuffer.append(CurrentDate);
stringBuffer.append("' OR (t1.endDate = '");
stringBuffer.append(CurrentDate);
stringBuffer.append("' AND t1.endTime > '");
stringBuffer.append(CurrentTime);
stringBuffer.append("'))");
stringBuffer.append(" ORDER BY t1.beginDate DESC, t1.beginTime DESC");
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC.gif";
String titlename = SystemEnv.getHtmlLabelName(16420,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<TABLE width=98% height=100% border="0" cellspacing="0" cellpadding="0" class="Shadow">
<tr>
    <td width="10px">
    </td>
    <td>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">

<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<b>

</b>
<TABLE class=ListStyle cellspacing=1>
  <TBODY>

  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(2151,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(2105,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
	
    <TH><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TH>

  </TR>
  <TR style="height: 1px;"><TD colspan="7" class=Line style="padding: 0 0 0 0"></TD></TR>
<%
     
boolean isLight = false;
int totalline=1;
String meetingstatus ="";
RecordSet.executeSql(stringBuffer.toString());
if(RecordSet.last()){
	do{
		meetingstatus = RecordSet.getString("meetingstatus");
		
		String status = RecordSet.getString("status");
		
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
    <TD>
    	<a href="/meeting/data/ViewMeeting.jsp?meetingid=<%=RecordSet.getString("id")%>"><%=Util.forHtml(RecordSet.getString("name"))%></a>
    <%
    	if("0".equals(status))
    	{
    %>
    	<IMG src="/images/BDNew.gif" align=absbottom border=0>
    <%
    	}
    	else if("2".equals(status))
    	{
    %>
        <IMG src="/images/BDCancel.gif" align=absbottom border=0>
    <%
    	}
    %>
    </TD>
    <TD class=Field><A href="/meeting/Maint/MeetingRoom.jsp"><%=MeetingRoomComInfo.getMeetingRoomInfoname(RecordSet.getString("address"))%></a><%= Util.null2String(RecordSet.getString("customizeAddress")) %></TD>
    <TD><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("caller")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("caller"))%></a></TD>
    <TD><A href='/hrm/resource/HrmResource.jsp?id=<%=RecordSet.getString("contacter")%>'><%=ResourceComInfo.getResourcename(RecordSet.getString("contacter"))%></a></TD>
	
    <TD><%=RecordSet.getString("begindate")%> <%=RecordSet.getString("begintime")%></TD>
    <TD><%=RecordSet.getString("enddate")%> <%=RecordSet.getString("endtime")%></TD>

     <TD class=Field>
                <%if(meetingstatus.equals("0")){%>
					<%=SystemEnv.getHtmlLabelName(220,user.getLanguage())%>
				<%}%>

				<%if(meetingstatus.equals("1")){%>
					<%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%>
				<%}%>
				<%if(meetingstatus.equals("2")){%>
					<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
				<%}%>
				<%if(meetingstatus.equals("3")){%>
					<%=SystemEnv.getHtmlLabelName(1010,user.getLanguage())%>
				<%}%>
	      </TD>
  </TR>
<%
	isLight = !isLight;
	
}while(RecordSet.previous());
}
%>  
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

    </td>
    <td width="10px">
    </td>
</tr>
</TABLE>
<script language=javascript>  
function submitData() {
window.history.back();
}

function onReSearch(){
	location.href="/meeting/search/Search.jsp";
}
</script>
</body>
</html>
