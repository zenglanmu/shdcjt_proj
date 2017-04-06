<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport.gif";
String titlename = Util.toScreen("会议情况一览表",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

//judge rights
if(!HrmUserVarify.checkUserRight("MeetingRp:View", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
		
String addressid=Util.fromScreen(request.getParameter("addressid"),user.getLanguage());
String meetingdatefrom=Util.fromScreen(request.getParameter("meetingdatefrom"),user.getLanguage());
String meetingdateto=Util.fromScreen(request.getParameter("meetingdateto"),user.getLanguage());
String begintime=Util.fromScreen(request.getParameter("begintime"),user.getLanguage());
String endtime=Util.fromScreen(request.getParameter("endtime"),user.getLanguage());
String meetingtype=Util.fromScreen(request.getParameter("meetingtype"),user.getLanguage());
String departmentid=Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<form name="frmmain" method="post" action="MeetingRp.jsp">
<table class=viewform>
    <colgroup>
    <col width="15%"><col width="35%"><col width="15%"><col width="35%">
    <tr class=title>
        <th colspan=4>详细</th>
    </tr>
    <tr class=spacing><td class=Sep1 colspan=4></td></tr>
    <tr>
        <td>会议室</td>
        <td class=field>
        <BUTTON class=Browser id=SelectAddress onclick="onShowAddress()"></BUTTON> 
              <SPAN id=addressspan><%=Util.toScreen(CapitalComInfo.getCapitalname(addressid),user.getLanguage())%></SPAN> 
              <INPUT id=address type=hidden name=addressid value="<%=addressid%>">
        </td>    
        <td>会议日期</td>
        <td class=field>
        <button class=calendar onClick="getDate(meetingdatefromspan,meetingdatefrom)"></button>
        <span id="meetingdatefromspan"><%=meetingdatefrom%></span><input name="meetingdatefrom" type=hidden value="<%=meetingdatefrom%>">
        - <button class=calendar onClick="getDate(meetingdatetospan,meetingdateto)"></button>
        <span id="meetingdatetospan"><%=meetingdateto%></span><input name="meetingdateto" type=hidden value="<%=meetingdateto%>">
        <!-- button class=calendar onClick="onShowTime('begintimespan','begintime')"></button>
        <span id="begintimespan"><%=begintime%></span><input name="begintime" type=hidden value="<%=begintime%>">
        - <button class=calendar onClick="onShowTime('endtimespan','endtime')"></button>
        <span id="endtimespan"><%=endtime%></span><input name="endtime" type=hidden value="<%=endtime%>" !-->
        </td>    
    </tr>
    <TR><TD class=Line colSpan=6></TD></TR> 
    <tr>
        <td>会议类型</td>
        <td class=field>
        <select class=inputstyle name="meetingtype" size=1>
            <option value="">全部</option>
            <%
            RecordSet.executeSql("select * from meeting_type order by id");
            while(RecordSet.next()){
                String tmpid=RecordSet.getString("id");
                String tmpname=RecordSet.getString("name");
                String selected="" ;
                if(meetingtype.equals(tmpid))   selected="selected";
            %> 
                <option value="<%=tmpid%>" <%=selected%>><%=Util.toScreen(tmpname,user.getLanguage())%></option>   
            <%}%>
        </select>
        </td>    
        <td>会议部门</td>
        <td class=field>
        <button class=browser onClick="onShowDepartment()"></button>
        <span id="departmentspan"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></span>
        <input name="departmentid" type=hidden value="<%=departmentid%>">
        </td>    
    </tr>
</table>
</form>
<%
boolean islight=true ;
String sql="select t1.*,t2.name typename from meeting t1,meeting_type t2 where t1.isapproved>=2 and t1.meetingtype=t2.id";
if(!addressid.equals(""))
    sql+=" and t1.address="+addressid ;
if(!meetingdatefrom.equals(""))
    sql+=" and t1.begindate>='"+meetingdatefrom+"'" ;
if(!meetingdateto.equals(""))
    sql+=" and t1.begindate<='"+meetingdateto+"'" ;    
if(!meetingtype.equals(""))
    sql+=" and t1.meetingtype="+meetingtype ;
if(!departmentid.equals(""))
    sql+=" and t1.caller in (select id from hrmresource where departmentid="+departmentid+")";
if(!begintime.equals(""))
    sql+=" and t1.begintime>='"+begintime+"'" ;
if(!endtime.equals(""))
    sql+=" and t1.endtime<='"+endtime+"'" ;    
    
sql+=" order by t1.begindate desc,t1.begintime desc,t1.address,t1.meetingtype";

RecordSet.executeSql(sql);
%>
<table class=liststyle cellspacing=1>
    <colgroup>
    <col width="20%"><col width="10%"><col width="10%"><col width="20%">
    <col width="10%"><col width="10%"><col width="20%">
    <tr class=Header>
        <th colspan=7>会议情况</th>
    </tr>
      <tr class=header>
        <td>会议名称</td>
        <td>会议类型</td>
        <td>会议室</td>
        <td>会议时间</td>
        <td>召集人</td>
        <td>联系人</td>
        <td>部门</td>
    </tr>
    <TR class=Line><TD colspan="7" ></TD></TR> 
<%
while(RecordSet.next()){
    String meetingid=RecordSet.getString("id");
    String meetingname=RecordSet.getString("name") ;
    String address=RecordSet.getString("address") ;
    String tmpbegindate=RecordSet.getString("begindate") ;
    String tmpbegintime=RecordSet.getString("begintime") ;
    String tmpendtime=RecordSet.getString("endtime") ;
    String caller=RecordSet.getString("caller") ;
    String contacter=RecordSet.getString("contacter") ;
    String typename=RecordSet.getString("typename") ;
%>
    <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
        <td><a href="/meeting/data/ViewMeeting.jsp?meetingid=<%=meetingid%>"><%=Util.toScreen(meetingname,user.getLanguage())%></a></td>
        <td><%=Util.toScreen(typename,user.getLanguage())%></td>
        <td><A href="/cpt/capital/CptCapital.jsp?id=<%=address%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(address),user.getLanguage())%></a></td>
        <td><%=tmpbegindate%>  <%=tmpbegintime%>-<%=tmpendtime%></td>
        <td><a href="/hrm/resource/HrmResource.jsp?id=<%=caller%>"><%=Util.toScreen(ResourceComInfo.getResourcename(caller),user.getLanguage())%></a></td>
        <td><a href="/hrm/resource/HrmResource.jsp?id=<%=contacter%>"><%=Util.toScreen(ResourceComInfo.getResourcename(contacter),user.getLanguage())%></a></td>
        <td><%=Util.toScreen(DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(caller)),user.getLanguage())%></td>
    </tr>
<%
    islight=!islight ;
}
%>
</table>
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
<script language=javascript>  
function submitData() {
 frmmain.submit();
}
</script>

<script language=vbs>
sub onShowAddress()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where capitalgroupid=16")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	addressspan.innerHtml =id(1)
	frmmain.address.value=id(0)
	else
	addressspan.innerHtml = ""
	frmmain.address.value=""
	end if
	end if
end sub

sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmmain.departmentid.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	departmentspan.innerHtml =id(1)
	frmmain.departmentid.value=id(0)
	else
	departmentspan.innerHtml = ""
	frmmain.departmentid.value=""
	end if
	end if
end sub
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime.js"></script>
</HTML>

